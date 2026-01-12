import 'package:flutter/widgets.dart';

import '../models/fly_item.dart';
import '../models/fly_animation_config.dart';
import '../models/phase_config.dart';
import '../decorations/decoration_painter.dart';

/// Widget for animating flying items
class FlyingItemAnimation extends StatefulWidget {
  final FlyItem item;
  final Offset startPosition;
  final Offset endPosition;
  final Size itemSize;
  final FlyAnimationConfig config;
  final TickerProvider vsync;
  final Duration delay;
  final VoidCallback? onSpreadComplete;
  final VoidCallback? onComplete;

  /// Progress threshold (0.0-1.0) at which to trigger onSpreadComplete.
  /// Default is 1.0 (triggers at animation completion).
  final double spreadTriggerAt;

  /// Progress threshold (0.0-1.0) at which to trigger onComplete.
  /// Default is 1.0 (triggers at animation completion).
  final double flyTriggerAt;

  const FlyingItemAnimation({
    super.key,
    required this.item,
    required this.startPosition,
    required this.endPosition,
    required this.itemSize,
    required this.config,
    required this.vsync,
    this.delay = Duration.zero,
    this.onSpreadComplete,
    this.onComplete,
    this.spreadTriggerAt = 1.0,
    this.flyTriggerAt = 1.0,
  });

  @override
  State<FlyingItemAnimation> createState() => _FlyingItemAnimationState();
}

class _FlyingItemAnimationState extends State<FlyingItemAnimation>
    with TickerProviderStateMixin {
  // Pre-phase (spread) animation controller
  AnimationController? _prePhaseController;
  Animation<double>? _prePhaseAnimation;

  // Main phase animation controller
  late AnimationController _mainController;
  late Animation<double> _mainAnimation;

  bool _started = false;
  bool _prePhaseCompleted = false;
  bool _spreadCallbackTriggered = false;
  bool _flyCallbackTriggered = false;

  SpreadPhaseConfig? get _spreadConfig {
    final prePhase = widget.config.prePhase;
    return prePhase is SpreadPhaseConfig ? prePhase : null;
  }

  @override
  void initState() {
    super.initState();

    // Setup pre-phase animation if configured
    final spreadConfig = _spreadConfig;
    if (spreadConfig != null) {
      _prePhaseController = AnimationController(
        duration: spreadConfig.duration,
        vsync: this,
      );
      _prePhaseAnimation = CurvedAnimation(
        parent: _prePhaseController!,
        curve: spreadConfig.curve,
      );
      // Listen for progress-based callback trigger
      _prePhaseController!.addListener(_checkSpreadProgress);
      _prePhaseController!.addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          _prePhaseCompleted = true;
          _mainController.forward();
        }
      });
    } else {
      _prePhaseCompleted = true;
    }

    // Setup main animation
    _mainController = AnimationController(
      duration: widget.config.duration,
      vsync: this,
    );
    _mainAnimation = CurvedAnimation(
      parent: _mainController,
      curve: widget.config.curve,
    );
    // Listen for progress-based callback trigger
    _mainController.addListener(_checkFlyProgress);
    _mainController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        // Ensure callback is called if not already triggered
        if (!_flyCallbackTriggered) {
          _flyCallbackTriggered = true;
          widget.onComplete?.call();
        }
      }
    });

    // Start animation after delay
    if (widget.delay == Duration.zero) {
      _startAnimation();
    } else {
      Future.delayed(widget.delay, _startAnimation);
    }
  }

  void _startAnimation() {
    if (mounted && !_started) {
      _started = true;
      if (_prePhaseController != null) {
        _prePhaseController!.forward();
      } else {
        _mainController.forward();
      }
    }
  }

  void _checkSpreadProgress() {
    if (_spreadCallbackTriggered) return;
    final progress = _prePhaseAnimation?.value ?? 0.0;
    if (progress >= widget.spreadTriggerAt) {
      _spreadCallbackTriggered = true;
      widget.onSpreadComplete?.call();
    }
  }

  void _checkFlyProgress() {
    if (_flyCallbackTriggered) return;
    final progress = _mainAnimation.value;
    if (progress >= widget.flyTriggerAt) {
      _flyCallbackTriggered = true;
      widget.onComplete?.call();
    }
  }

  @override
  void dispose() {
    _prePhaseController?.dispose();
    _mainController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: Listenable.merge([
        if (_prePhaseAnimation != null) _prePhaseAnimation!,
        _mainAnimation,
      ]),
      builder: (context, child) {
        final Offset position;
        final double effectProgress;

        final spreadConfig = _spreadConfig;
        if (spreadConfig != null && !_prePhaseCompleted) {
          // Pre-phase: spread from gather point to start position
          final preProgress = _prePhaseAnimation?.value ?? 0.0;
          position = Offset.lerp(
            spreadConfig.gatherPoint,
            widget.startPosition,
            preProgress,
          )!;
          // No effects during pre-phase
          effectProgress = 0.0;
        } else {
          // Main phase: fly from start to end
          final mainProgress = _mainAnimation.value;
          position = widget.config.pathConfig.calculatePosition(
            mainProgress,
            widget.startPosition,
            widget.endPosition,
          );
          effectProgress = mainProgress;
        }

        // Apply effects (only during main phase)
        final effects = widget.config.effects;
        final rotation =
            effects.rotation?.calculateRotation(effectProgress) ?? 0.0;
        final scale = effects.scale?.calculateScale(effectProgress) ?? 1.0;
        final opacity = effects.fade?.calculateOpacity(effectProgress) ?? 1.0;

        // Build decorations (only during main phase)
        final decorations = _prePhaseCompleted
            ? widget.config.decorations.map((config) {
                return DecorationPainterFactory.create(
                  config: config,
                  progress: effectProgress,
                  position: position,
                  itemSize: widget.itemSize,
                  startPosition: widget.startPosition,
                  endPosition: widget.endPosition,
                );
              }).toList()
            : <DecorationPainter>[];

        return Stack(
          children: [
            // Decorations (drawn behind item)
            ...decorations
                .where((d) => !d.drawOnTop)
                .map((d) => d.build(context)),

            // Main item
            Positioned(
              left: position.dx - widget.itemSize.width / 2,
              top: position.dy - widget.itemSize.height / 2,
              child: Opacity(
                opacity: opacity.clamp(0.0, 1.0),
                child: Transform.scale(
                  scale: scale.clamp(0.0, 2.0),
                  child: Transform.rotate(
                    angle: rotation,
                    child: SizedBox(
                      width: widget.itemSize.width,
                      height: widget.itemSize.height,
                      child: widget.item.child,
                    ),
                  ),
                ),
              ),
            ),

            // Decorations (drawn in front of item)
            ...decorations
                .where((d) => d.drawOnTop)
                .map((d) => d.build(context)),
          ],
        );
      },
    );
  }
}

import 'package:flutter/widgets.dart';

import '../models/fly_item.dart';
import '../models/fly_animation_config.dart';
import '../decorations/decoration_painter.dart';

/// 飛行中のアイテムをアニメーションするウィジェット
class FlyingItemAnimation extends StatefulWidget {
  final FlyItem item;
  final Offset startPosition;
  final Offset endPosition;
  final Size itemSize;
  final FlyAnimationConfig config;
  final TickerProvider vsync;
  final Duration delay;
  final VoidCallback? onComplete;

  const FlyingItemAnimation({
    super.key,
    required this.item,
    required this.startPosition,
    required this.endPosition,
    required this.itemSize,
    required this.config,
    required this.vsync,
    this.delay = Duration.zero,
    this.onComplete,
  });

  @override
  State<FlyingItemAnimation> createState() => _FlyingItemAnimationState();
}

class _FlyingItemAnimationState extends State<FlyingItemAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _curvedAnimation;
  bool _started = false;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: widget.config.duration,
      vsync: this,
    );

    _curvedAnimation = CurvedAnimation(
      parent: _controller,
      curve: widget.config.curve,
    );

    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        widget.onComplete?.call();
      }
    });

    // 遅延後にアニメーションを開始
    if (widget.delay == Duration.zero) {
      _startAnimation();
    } else {
      Future.delayed(widget.delay, _startAnimation);
    }
  }

  void _startAnimation() {
    if (mounted && !_started) {
      _started = true;
      _controller.forward();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _curvedAnimation,
      builder: (context, child) {
        final progress = _curvedAnimation.value;

        // 位置を計算
        final position = widget.config.pathConfig.calculatePosition(
          progress,
          widget.startPosition,
          widget.endPosition,
        );

        // エフェクトを適用
        final effects = widget.config.effects;
        final rotation = effects.rotation?.calculateRotation(progress) ?? 0.0;
        final scale = effects.scale?.calculateScale(progress) ?? 1.0;
        final opacity = effects.fade?.calculateOpacity(progress) ?? 1.0;

        // 装飾を構築
        final decorations = widget.config.decorations.map((config) {
          return DecorationPainterFactory.create(
            config: config,
            progress: progress,
            position: position,
            itemSize: widget.itemSize,
          );
        }).toList();

        return Stack(
          children: [
            // 装飾（アイテムの後ろに描画するもの）
            ...decorations
                .where((d) => !d.drawOnTop)
                .map((d) => d.build(context)),

            // メインアイテム
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

            // 装飾（アイテムの前に描画するもの）
            ...decorations
                .where((d) => d.drawOnTop)
                .map((d) => d.build(context)),
          ],
        );
      },
    );
  }
}

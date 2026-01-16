import 'dart:math';

import 'package:flutter/widgets.dart';

import 'path_config.dart';
import 'effects_config.dart';
import 'decoration_config.dart';
import 'phase_config.dart';

/// Animation configuration
class FlyAnimationConfig {
  /// Pre-animation phase (e.g., spread from gather point)
  /// If null, items start directly from their origin positions
  final PrePhaseConfig? prePhase;

  /// Animation duration
  final Duration duration;

  /// Easing curve
  final Curve curve;

  /// Delay between each item start (stagger effect)
  /// When [groupSize] > 1, this is the delay between items within a group
  final Duration staggerDelay;

  /// Number of items per group (default: 1 = no grouping)
  /// When > 1, items are grouped and each group starts together
  final int groupSize;

  /// Delay between groups (only used when [groupSize] > 1)
  /// If null, uses [staggerDelay] as the group delay
  final Duration? groupStaggerDelay;

  /// Path configuration
  final PathConfig pathConfig;

  /// Effects configuration
  final FlyEffects effects;

  /// Decorations configuration
  final List<DecorationConfig> decorations;

  const FlyAnimationConfig({
    this.prePhase,
    this.duration = const Duration(milliseconds: 800),
    this.curve = Curves.easeInOut,
    this.staggerDelay = const Duration(milliseconds: 50),
    this.groupSize = 1,
    this.groupStaggerDelay,
    this.pathConfig = const LinearPathConfig(),
    this.effects = const FlyEffects(),
    this.decorations = const [],
  });

  /// Preset: parabolic flight
  factory FlyAnimationConfig.parabolic({
    Duration duration = const Duration(milliseconds: 800),
    Curve curve = Curves.easeOut,
    Duration staggerDelay = const Duration(milliseconds: 80),
    double height = -100,
  }) {
    return FlyAnimationConfig(
      duration: duration,
      curve: curve,
      staggerDelay: staggerDelay,
      pathConfig: ParabolicPathConfig(height: height),
    );
  }

  /// Preset: bezier curve flight
  factory FlyAnimationConfig.bezier({
    Duration duration = const Duration(milliseconds: 800),
    Curve curve = Curves.easeOut,
    Duration staggerDelay = const Duration(milliseconds: 80),
    double curvature = 0.5,
    double randomness = 0.0,
  }) {
    return FlyAnimationConfig(
      duration: duration,
      curve: curve,
      staggerDelay: staggerDelay,
      pathConfig: BezierPathConfig.auto(
        curvature: curvature,
        randomness: randomness,
      ),
    );
  }

  /// Preset: coin flight (rotation + scale + feather effects)
  factory FlyAnimationConfig.coin({
    Duration duration = const Duration(milliseconds: 800),
    Duration staggerDelay = const Duration(milliseconds: 80),
  }) {
    return FlyAnimationConfig(
      duration: duration,
      curve: Curves.easeOut,
      staggerDelay: staggerDelay,
      pathConfig: BezierPathConfig.auto(
        curvature: 0.6,
        randomness: 0.2,
      ),
      effects: FlyEffects(
        rotation: RotationEffect(
          rotations: 4 * pi,
          direction: RotationDirection.clockwise,
        ),
        scale: const ScaleEffect(
          startScale: 1.0,
          endScale: 0.5,
          startAt: 0.5,
        ),
        fade: const FadeEffect(
          startAt: 0.7,
          endOpacity: 0.0,
        ),
      ),
      decorations: const [
        FeatherDecorationConfig(
          count: 3,
          spread: 15.0,
        ),
        SparkleDecorationConfig(
          count: 5,
        ),
      ],
    );
  }

  /// Preset: simple movement (linear, fade only)
  factory FlyAnimationConfig.simple({
    Duration duration = const Duration(milliseconds: 600),
    Curve curve = Curves.easeInOut,
  }) {
    return FlyAnimationConfig(
      duration: duration,
      curve: curve,
      staggerDelay: Duration.zero,
      effects: const FlyEffects(
        fade: FadeEffect(startAt: 0.8),
      ),
    );
  }

  /// Preset: spread from gather point then fly to target
  factory FlyAnimationConfig.spreadAndFly({
    required Offset gatherPoint,
    Duration spreadDuration = const Duration(milliseconds: 400),
    Curve spreadCurve = Curves.easeOutBack,
    Duration flyDuration = const Duration(milliseconds: 800),
    Curve flyCurve = Curves.easeIn,
    Duration staggerDelay = const Duration(milliseconds: 50),
    int groupSize = 1,
    Duration? groupStaggerDelay,
    PathConfig pathConfig = const LinearPathConfig(),
    FlyEffects effects = const FlyEffects(),
    List<DecorationConfig> decorations = const [],
  }) {
    return FlyAnimationConfig(
      prePhase: SpreadPhaseConfig(
        gatherPoint: gatherPoint,
        duration: spreadDuration,
        curve: spreadCurve,
      ),
      duration: flyDuration,
      curve: flyCurve,
      staggerDelay: staggerDelay,
      groupSize: groupSize,
      groupStaggerDelay: groupStaggerDelay,
      pathConfig: pathConfig,
      effects: effects,
      decorations: decorations,
    );
  }

  /// Preset: add to cart animation (parabolic + scale + fade)
  factory FlyAnimationConfig.cart({
    Duration duration = const Duration(milliseconds: 500),
    Curve curve = Curves.easeOut,
    double height = -80,
  }) {
    return FlyAnimationConfig(
      duration: duration,
      curve: curve,
      staggerDelay: Duration.zero,
      pathConfig: ParabolicPathConfig(height: height),
      effects: const FlyEffects(
        scale: ScaleEffect(
          endScale: 0.5,
        ),
        fade: FadeEffect(
          startAt: 0.7,
        ),
      ),
    );
  }

  /// Preset: heart/like burst animation (bezier + rotation + scale + particles)
  factory FlyAnimationConfig.heart({
    Duration duration = const Duration(milliseconds: 1200),
    Duration staggerDelay = const Duration(milliseconds: 40),
  }) {
    return FlyAnimationConfig(
      duration: duration,
      curve: Curves.easeOutCubic,
      staggerDelay: staggerDelay,
      pathConfig: BezierPathConfig.auto(
        curvature: 0.6,
        randomness: 0.3,
      ),
      effects: const FlyEffects(
        rotation: RotationEffect(
          rotations: pi / 2,
          direction: RotationDirection.counterClockwise,
        ),
        scale: ScaleEffect(
          startScale: 1.2,
          endScale: 0.4,
          startAt: 0.3,
        ),
        fade: FadeEffect(
          startAt: 0.75,
        ),
      ),
      decorations: const [
        ParticleDecorationConfig(
          count: 8,
          minSize: 2,
          maxSize: 5,
          lifetime: 0.6,
        ),
      ],
    );
  }

  /// Preset: game reward collection (bezier + rotation + scale + sparkles)
  factory FlyAnimationConfig.gameReward({
    Duration duration = const Duration(milliseconds: 900),
    Duration staggerDelay = const Duration(milliseconds: 50),
  }) {
    return FlyAnimationConfig(
      duration: duration,
      curve: Curves.easeOutBack,
      staggerDelay: staggerDelay,
      pathConfig: BezierPathConfig.auto(
        curvature: 0.5,
      ),
      effects: FlyEffects(
        rotation: RotationEffect(
          rotations: 2 * pi,
        ),
        scale: const ScaleEffect(
          endScale: 0.5,
          startAt: 0.5,
        ),
        fade: const FadeEffect(
          startAt: 0.8,
        ),
      ),
      decorations: const [
        SparkleDecorationConfig(
          count: 5,
          size: 8,
          blinkSpeed: 4,
        ),
      ],
    );
  }

  /// copyWith method
  FlyAnimationConfig copyWith({
    PrePhaseConfig? prePhase,
    Duration? duration,
    Curve? curve,
    Duration? staggerDelay,
    int? groupSize,
    Duration? groupStaggerDelay,
    PathConfig? pathConfig,
    FlyEffects? effects,
    List<DecorationConfig>? decorations,
  }) {
    return FlyAnimationConfig(
      prePhase: prePhase ?? this.prePhase,
      duration: duration ?? this.duration,
      curve: curve ?? this.curve,
      staggerDelay: staggerDelay ?? this.staggerDelay,
      groupSize: groupSize ?? this.groupSize,
      groupStaggerDelay: groupStaggerDelay ?? this.groupStaggerDelay,
      pathConfig: pathConfig ?? this.pathConfig,
      effects: effects ?? this.effects,
      decorations: decorations ?? this.decorations,
    );
  }

  /// Calculate delay for a specific item index
  Duration calculateDelay(int index) {
    if (groupSize <= 1) {
      return staggerDelay * index;
    }
    final groupIndex = index ~/ groupSize;
    final effectiveGroupDelay = groupStaggerDelay ?? staggerDelay;
    return effectiveGroupDelay * groupIndex;
  }
}

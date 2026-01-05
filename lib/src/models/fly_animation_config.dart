import 'dart:math';

import 'package:flutter/widgets.dart';

import 'path_config.dart';
import 'effects_config.dart';
import 'decoration_config.dart';

/// Animation configuration
class FlyAnimationConfig {
  /// Animation duration
  final Duration duration;

  /// Easing curve
  final Curve curve;

  /// Delay between each item start (stagger effect)
  final Duration staggerDelay;

  /// Path configuration
  final PathConfig pathConfig;

  /// Effects configuration
  final FlyEffects effects;

  /// Decorations configuration
  final List<DecorationConfig> decorations;

  const FlyAnimationConfig({
    this.duration = const Duration(milliseconds: 800),
    this.curve = Curves.easeInOut,
    this.staggerDelay = const Duration(milliseconds: 50),
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

  /// copyWith method
  FlyAnimationConfig copyWith({
    Duration? duration,
    Curve? curve,
    Duration? staggerDelay,
    PathConfig? pathConfig,
    FlyEffects? effects,
    List<DecorationConfig>? decorations,
  }) {
    return FlyAnimationConfig(
      duration: duration ?? this.duration,
      curve: curve ?? this.curve,
      staggerDelay: staggerDelay ?? this.staggerDelay,
      pathConfig: pathConfig ?? this.pathConfig,
      effects: effects ?? this.effects,
      decorations: decorations ?? this.decorations,
    );
  }
}

import 'package:flutter/widgets.dart';

/// Particle emission type
enum ParticleEmitType {
  /// Emit while following movement
  trailing,

  /// Emit all at once at start
  burst,

  /// Emit on arrival
  arrival,
}

/// Base class for decoration configuration
sealed class DecorationConfig {
  const DecorationConfig();
}

/// Feather effect
class FeatherDecorationConfig extends DecorationConfig {
  /// Number of feathers
  final int count;

  /// Feather colors
  final List<Color> colors;

  /// Feather size
  final Size size;

  /// Spread amount
  final double spread;

  /// Feather flutter intensity
  final double flutter;

  const FeatherDecorationConfig({
    this.count = 5,
    this.colors = const [
      Color(0xFFFFFFFF),
      Color(0xFFFFEB3B),
    ],
    this.size = const Size(8, 16),
    this.spread = 20.0,
    this.flutter = 1.0,
  });
}

/// Particle effect
class ParticleDecorationConfig extends DecorationConfig {
  /// Number of particles
  final int count;

  /// Particle colors
  final List<Color> colors;

  /// Minimum particle size
  final double minSize;

  /// Maximum particle size
  final double maxSize;

  /// Emission type
  final ParticleEmitType emitType;

  /// Particle lifetime (0.0-1.0, percentage of total animation)
  final double lifetime;

  /// Emission speed
  final double speed;

  const ParticleDecorationConfig({
    this.count = 10,
    this.colors = const [
      Color(0xFFFFEB3B),
      Color(0xFFFF9800),
    ],
    this.minSize = 2.0,
    this.maxSize = 6.0,
    this.emitType = ParticleEmitType.trailing,
    this.lifetime = 0.5,
    this.speed = 1.0,
  });
}

/// Sparkle effect
class SparkleDecorationConfig extends DecorationConfig {
  /// Number of sparkles
  final int count;

  /// Sparkle color
  final Color color;

  /// Brightness intensity
  final double intensity;

  /// Sparkle size
  final double size;

  /// Blink speed
  final double blinkSpeed;

  const SparkleDecorationConfig({
    this.count = 8,
    this.color = const Color(0xFFFFFFFF),
    this.intensity = 1.0,
    this.size = 4.0,
    this.blinkSpeed = 2.0,
  });
}

/// Custom decoration
class CustomDecorationConfig extends DecorationConfig {
  /// Custom decoration builder
  /// [context] is BuildContext
  /// [progress] is animation progress from 0.0 to 1.0
  /// [position] is current position
  final Widget Function(
    BuildContext context,
    double progress,
    Offset position,
  ) builder;

  const CustomDecorationConfig({required this.builder});
}

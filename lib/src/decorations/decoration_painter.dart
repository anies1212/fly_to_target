import 'dart:math';

import 'package:flutter/widgets.dart';

import '../models/decoration_config.dart';

/// Base class for painting decorations
abstract class DecorationPainter {
  /// Whether to draw on top of the item
  bool get drawOnTop;

  /// Build decoration widget
  Widget build(BuildContext context);
}

/// Factory for creating decoration painters
class DecorationPainterFactory {
  static DecorationPainter create({
    required DecorationConfig config,
    required double progress,
    required Offset position,
    required Size itemSize,
    Offset? startPosition,
    Offset? endPosition,
  }) {
    return switch (config) {
      FeatherDecorationConfig() => FeatherPainter(
          config: config,
          progress: progress,
          position: position,
          itemSize: itemSize,
        ),
      ParticleDecorationConfig() => ParticlePainter(
          config: config,
          progress: progress,
          position: position,
          itemSize: itemSize,
        ),
      SparkleDecorationConfig() => SparklePainter(
          config: config,
          progress: progress,
          position: position,
          itemSize: itemSize,
        ),
      CustomDecorationConfig() => CustomDecorationPainter(
          config: config,
          progress: progress,
          position: position,
        ),
      StarTrailDecorationConfig() => StarTrailPainter(
          config: config,
          progress: progress,
          position: position,
          itemSize: itemSize,
          startPosition: startPosition ?? position,
          endPosition: endPosition ?? position,
        ),
    };
  }
}

/// Feather effect painter
class FeatherPainter extends DecorationPainter {
  final FeatherDecorationConfig config;
  final double progress;
  final Offset position;
  final Size itemSize;

  FeatherPainter({
    required this.config,
    required this.progress,
    required this.position,
    required this.itemSize,
  });

  @override
  bool get drawOnTop => false;

  @override
  Widget build(BuildContext context) {
    final feathers = <Widget>[];

    for (var i = 0; i < config.count; i++) {
      // Offset phase for each feather
      final phase = i / config.count;
      final angle = (progress * 2 + phase) * pi * 2;

      // Feather position (scattered around main item)
      final spreadX = sin(angle + i) * config.spread * (1 - progress * 0.5);
      final spreadY =
          cos(angle + i * 0.7) * config.spread * (1 - progress * 0.5);

      // Feather flutter
      final flutter = sin(progress * pi * 4 + i) * config.flutter * 10;

      // Feather opacity (fades out in second half)
      final opacity = (1 - progress * 0.8).clamp(0.0, 1.0);

      // Select feather color
      final color = config.colors[i % config.colors.length];

      feathers.add(
        Positioned(
          left: position.dx + spreadX + flutter - config.size.width / 2,
          top: position.dy + spreadY - config.size.height / 2,
          child: Opacity(
            opacity: opacity,
            child: Transform.rotate(
              angle: angle * 0.5,
              child: Container(
                width: config.size.width,
                height: config.size.height,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      color.withValues(alpha: 0.8),
                      color.withValues(alpha: 0.2),
                    ],
                  ),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(config.size.width / 2),
                    topRight: Radius.circular(config.size.width / 2),
                    bottomLeft: Radius.circular(config.size.width / 4),
                    bottomRight: Radius.circular(config.size.width / 4),
                  ),
                ),
              ),
            ),
          ),
        ),
      );
    }

    return Stack(children: feathers);
  }
}

/// Particle effect painter
class ParticlePainter extends DecorationPainter {
  final ParticleDecorationConfig config;
  final double progress;
  final Offset position;
  final Size itemSize;
  final Random _random = Random(123);

  ParticlePainter({
    required this.config,
    required this.progress,
    required this.position,
    required this.itemSize,
  });

  @override
  bool get drawOnTop => true;

  @override
  Widget build(BuildContext context) {
    final particles = <Widget>[];

    for (var i = 0; i < config.count; i++) {
      // Particle spawn timing and lifetime
      final spawnProgress = i / config.count * 0.5;
      if (progress < spawnProgress) continue;

      final particleProgress =
          ((progress - spawnProgress) / config.lifetime).clamp(0.0, 1.0);
      if (particleProgress >= 1.0) continue;

      // Particle size
      final baseSize = config.minSize +
          _random.nextDouble() * (config.maxSize - config.minSize);
      final size = baseSize * (1 - particleProgress * 0.5);

      // Particle position (emission direction)
      final angle = _random.nextDouble() * pi * 2;
      final distance = particleProgress * 50 * config.speed;
      final offsetX = cos(angle) * distance;
      final offsetY = sin(angle) * distance - particleProgress * 30;

      // Opacity
      final opacity = (1 - particleProgress).clamp(0.0, 1.0);

      // Select color
      final color = config.colors[i % config.colors.length];

      particles.add(
        Positioned(
          left: position.dx + offsetX - size / 2,
          top: position.dy + offsetY - size / 2,
          child: Opacity(
            opacity: opacity,
            child: Container(
              width: size,
              height: size,
              decoration: BoxDecoration(
                color: color,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: color.withValues(alpha: 0.5),
                    blurRadius: size,
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    }

    return Stack(children: particles);
  }
}

/// Sparkle effect painter
class SparklePainter extends DecorationPainter {
  final SparkleDecorationConfig config;
  final double progress;
  final Offset position;
  final Size itemSize;
  final Random _random = Random(456);

  SparklePainter({
    required this.config,
    required this.progress,
    required this.position,
    required this.itemSize,
  });

  @override
  bool get drawOnTop => true;

  @override
  Widget build(BuildContext context) {
    final sparkles = <Widget>[];

    for (var i = 0; i < config.count; i++) {
      // Sparkle position
      final angle = (i / config.count) * pi * 2;
      final distance = itemSize.width * 0.8 + _random.nextDouble() * 10;
      final offsetX = cos(angle + progress * pi) * distance;
      final offsetY = sin(angle + progress * pi) * distance;

      // Blink effect
      final blink = sin(progress * pi * config.blinkSpeed * 2 + i) * 0.5 + 0.5;
      final opacity =
          (blink * config.intensity * (1 - progress * 0.5)).clamp(0.0, 1.0);

      sparkles.add(
        Positioned(
          left: position.dx + offsetX - config.size / 2,
          top: position.dy + offsetY - config.size / 2,
          child: Opacity(
            opacity: opacity,
            child: CustomPaint(
              size: Size(config.size, config.size),
              painter: _StarShapePainter(color: config.color),
            ),
          ),
        ),
      );
    }

    return Stack(children: sparkles);
  }
}

/// Custom painter for star shape
class _StarShapePainter extends CustomPainter {
  final Color color;

  _StarShapePainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    final centerX = size.width / 2;
    final centerY = size.height / 2;
    final radius = size.width / 2;

    final path = Path();
    for (var i = 0; i < 4; i++) {
      final angle = i * pi / 2 - pi / 2;
      final x = centerX + cos(angle) * radius;
      final y = centerY + sin(angle) * radius;
      if (i == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
      final innerAngle = angle + pi / 4;
      final innerRadius = radius * 0.3;
      path.lineTo(
        centerX + cos(innerAngle) * innerRadius,
        centerY + sin(innerAngle) * innerRadius,
      );
    }
    path.close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

/// Custom decoration painter
class CustomDecorationPainter extends DecorationPainter {
  final CustomDecorationConfig config;
  final double progress;
  final Offset position;

  CustomDecorationPainter({
    required this.config,
    required this.progress,
    required this.position,
  });

  @override
  bool get drawOnTop => true;

  @override
  Widget build(BuildContext context) {
    return config.builder(context, progress, position);
  }
}

/// Star trail painter - stars following behind the item
class StarTrailPainter extends DecorationPainter {
  final StarTrailDecorationConfig config;
  final double progress;
  final Offset position;
  final Size itemSize;
  final Offset startPosition;
  final Offset endPosition;

  StarTrailPainter({
    required this.config,
    required this.progress,
    required this.position,
    required this.itemSize,
    required this.startPosition,
    required this.endPosition,
  });

  @override
  bool get drawOnTop => false;

  @override
  Widget build(BuildContext context) {
    if (progress <= 0.01) return const SizedBox.shrink();

    final stars = <Widget>[];

    // Calculate direction vector (normalized)
    final direction = endPosition - startPosition;
    final length = direction.distance;
    if (length < 1) return const SizedBox.shrink();

    final normalizedDir = Offset(direction.dx / length, direction.dy / length);
    // Perpendicular direction for scatter effect
    final perpDir = Offset(-normalizedDir.dy, normalizedDir.dx);

    for (var i = 0; i < config.count; i++) {
      // Use consistent random values based on index
      final randSeed = Random(i * 17 + 31);
      final randOffset = (randSeed.nextDouble() - 0.5) * 2;
      final randDistance = randSeed.nextDouble();

      // Position each star behind with scatter
      final trailFraction = (i + 1) / config.count;
      final distanceBehind = config.startDistance +
          config.trailLength * (trailFraction * 0.6 + randDistance * 0.4);

      // Scatter perpendicular to movement direction
      final scatterAmount = config.spreadWidth * randOffset;

      final starPosition = Offset(
        position.dx -
            normalizedDir.dx * distanceBehind +
            perpDir.dx * scatterAmount,
        position.dy -
            normalizedDir.dy * distanceBehind +
            perpDir.dy * scatterAmount,
      );

      // Size varies randomly
      final sizeFactor = 0.4 + randSeed.nextDouble() * 0.6;
      final starSize =
          config.minSize + (config.size - config.minSize) * sizeFactor;

      // Opacity decreases towards the tail with variation
      final baseOpacity =
          (1.0 - trailFraction * 0.6) * (0.7 + randSeed.nextDouble() * 0.3);

      // Twinkle effect
      final twinkle = config.twinkle
          ? (sin(progress * pi * config.twinkleSpeed * 2 + i * 1.5) * 0.4 + 0.6)
          : 1.0;

      final opacity =
          (baseOpacity * twinkle * (1.0 - progress * 0.2)).clamp(0.0, 1.0);

      stars.add(
        Positioned(
          left: starPosition.dx - starSize / 2,
          top: starPosition.dy - starSize / 2,
          child: Opacity(
            opacity: opacity,
            child: CustomPaint(
              size: Size(starSize, starSize),
              painter: _StarShapePainter(color: config.color),
            ),
          ),
        ),
      );
    }

    return Stack(children: stars);
  }
}

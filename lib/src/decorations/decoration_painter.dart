import 'dart:math';

import 'package:flutter/widgets.dart';

import '../models/decoration_config.dart';

/// 装飾を描画するための基底クラス
abstract class DecorationPainter {
  /// アイテムの前に描画するかどうか
  bool get drawOnTop;

  /// 装飾ウィジェットを構築
  Widget build(BuildContext context);
}

/// 装飾ペインターを生成するファクトリ
class DecorationPainterFactory {
  static DecorationPainter create({
    required DecorationConfig config,
    required double progress,
    required Offset position,
    required Size itemSize,
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
    };
  }
}

/// 羽根エフェクトペインター
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
      // 各羽根の位相をずらす
      final phase = i / config.count;
      final angle = (progress * 2 + phase) * pi * 2;

      // 羽根の位置（メインアイテムの周りに散らばる）
      final spreadX = sin(angle + i) * config.spread * (1 - progress * 0.5);
      final spreadY =
          cos(angle + i * 0.7) * config.spread * (1 - progress * 0.5);

      // 羽根の揺れ
      final flutter = sin(progress * pi * 4 + i) * config.flutter * 10;

      // 羽根の透明度（後半で消えていく）
      final opacity = (1 - progress * 0.8).clamp(0.0, 1.0);

      // 羽根の色を選択
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

/// パーティクルエフェクトペインター
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
      // パーティクルの生成タイミングと寿命
      final spawnProgress = i / config.count * 0.5;
      if (progress < spawnProgress) continue;

      final particleProgress =
          ((progress - spawnProgress) / config.lifetime).clamp(0.0, 1.0);
      if (particleProgress >= 1.0) continue;

      // パーティクルのサイズ
      final baseSize = config.minSize +
          _random.nextDouble() * (config.maxSize - config.minSize);
      final size = baseSize * (1 - particleProgress * 0.5);

      // パーティクルの位置（放出方向）
      final angle = _random.nextDouble() * pi * 2;
      final distance = particleProgress * 50 * config.speed;
      final offsetX = cos(angle) * distance;
      final offsetY = sin(angle) * distance - particleProgress * 30;

      // 透明度
      final opacity = (1 - particleProgress).clamp(0.0, 1.0);

      // 色を選択
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

/// キラキラエフェクトペインター
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
      // キラキラの位置
      final angle = (i / config.count) * pi * 2;
      final distance = itemSize.width * 0.8 + _random.nextDouble() * 10;
      final offsetX = cos(angle + progress * pi) * distance;
      final offsetY = sin(angle + progress * pi) * distance;

      // 点滅効果
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

/// 星型を描画するカスタムペインター
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

/// カスタム装飾ペインター
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

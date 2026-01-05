import 'package:flutter/widgets.dart';

/// パーティクルの放出タイプ
enum ParticleEmitType {
  /// 移動に追従して放出
  trailing,

  /// 開始時に一度に放出
  burst,

  /// 到着時に放出
  arrival,
}

/// 装飾設定の基底クラス
sealed class DecorationConfig {
  const DecorationConfig();
}

/// 羽根エフェクト
class FeatherDecorationConfig extends DecorationConfig {
  /// 羽根の数
  final int count;

  /// 羽根の色
  final List<Color> colors;

  /// 羽根のサイズ
  final Size size;

  /// 散らばり具合
  final double spread;

  /// 羽根の揺れの強さ
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

/// パーティクルエフェクト
class ParticleDecorationConfig extends DecorationConfig {
  /// パーティクル数
  final int count;

  /// パーティクルの色
  final List<Color> colors;

  /// パーティクルの最小サイズ
  final double minSize;

  /// パーティクルの最大サイズ
  final double maxSize;

  /// 放出タイプ
  final ParticleEmitType emitType;

  /// パーティクルの寿命（0.0-1.0、アニメーション全体の割合）
  final double lifetime;

  /// 放出速度
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

/// キラキラエフェクト
class SparkleDecorationConfig extends DecorationConfig {
  /// キラキラの数
  final int count;

  /// キラキラの色
  final Color color;

  /// 輝きの強さ
  final double intensity;

  /// キラキラのサイズ
  final double size;

  /// 点滅速度
  final double blinkSpeed;

  const SparkleDecorationConfig({
    this.count = 8,
    this.color = const Color(0xFFFFFFFF),
    this.intensity = 1.0,
    this.size = 4.0,
    this.blinkSpeed = 2.0,
  });
}

/// カスタム装飾
class CustomDecorationConfig extends DecorationConfig {
  /// カスタム装飾のビルダー
  /// [context] はBuildContext
  /// [progress] は0.0-1.0のアニメーション進捗
  /// [position] は現在の位置
  final Widget Function(
    BuildContext context,
    double progress,
    Offset position,
  ) builder;

  const CustomDecorationConfig({required this.builder});
}

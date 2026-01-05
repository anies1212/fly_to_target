import 'dart:math';

import 'package:flutter/widgets.dart';

import 'path_config.dart';
import 'effects_config.dart';
import 'decoration_config.dart';

/// アニメーション設定
class FlyAnimationConfig {
  /// アニメーション時間
  final Duration duration;

  /// イージングカーブ
  final Curve curve;

  /// 各アイテムの開始遅延（stagger effect）
  final Duration staggerDelay;

  /// 軌道設定
  final PathConfig pathConfig;

  /// エフェクト設定
  final FlyEffects effects;

  /// 装飾設定
  final List<DecorationConfig> decorations;

  const FlyAnimationConfig({
    this.duration = const Duration(milliseconds: 800),
    this.curve = Curves.easeInOut,
    this.staggerDelay = const Duration(milliseconds: 50),
    this.pathConfig = const LinearPathConfig(),
    this.effects = const FlyEffects(),
    this.decorations = const [],
  });

  /// プリセット: 放物線で飛ぶ
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

  /// プリセット: ベジェ曲線で飛ぶ
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

  /// プリセット: コインが飛ぶ（回転+縮小+羽根エフェクト）
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

  /// プリセット: シンプルな移動（直線、フェードのみ）
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

  /// copyWithメソッド
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

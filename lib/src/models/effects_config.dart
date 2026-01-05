import 'dart:math';

import 'package:flutter/painting.dart';

/// 回転方向
enum RotationDirection {
  clockwise,
  counterClockwise,
}

/// エフェクトの集合
class FlyEffects {
  /// 回転エフェクト
  final RotationEffect? rotation;

  /// スケール（縮小）エフェクト
  final ScaleEffect? scale;

  /// フェードアウトエフェクト
  final FadeEffect? fade;

  /// 軌跡エフェクト
  final TrailEffect? trail;

  const FlyEffects({
    this.rotation,
    this.scale,
    this.fade,
    this.trail,
  });

  /// エフェクトがあるかどうか
  bool get hasEffects =>
      rotation != null || scale != null || fade != null || trail != null;

  /// copyWithメソッド
  FlyEffects copyWith({
    RotationEffect? rotation,
    ScaleEffect? scale,
    FadeEffect? fade,
    TrailEffect? trail,
  }) {
    return FlyEffects(
      rotation: rotation ?? this.rotation,
      scale: scale ?? this.scale,
      fade: fade ?? this.fade,
      trail: trail ?? this.trail,
    );
  }
}

/// 回転エフェクト
class RotationEffect {
  /// 回転量（ラジアン）
  final double rotations;

  /// 回転方向
  final RotationDirection direction;

  /// 回転開始タイミング（0.0-1.0）
  final double startAt;

  /// 回転終了タイミング（0.0-1.0）
  final double endAt;

  const RotationEffect({
    this.rotations = 2 * pi,
    this.direction = RotationDirection.clockwise,
    this.startAt = 0.0,
    this.endAt = 1.0,
  });

  /// 進捗に応じた回転量を計算
  double calculateRotation(double progress) {
    if (progress < startAt) return 0.0;
    if (progress > endAt) {
      return direction == RotationDirection.clockwise ? rotations : -rotations;
    }

    final effectProgress = (progress - startAt) / (endAt - startAt);
    final rotation = rotations * effectProgress;
    return direction == RotationDirection.clockwise ? rotation : -rotation;
  }
}

/// スケール（縮小）エフェクト
class ScaleEffect {
  /// 開始スケール
  final double startScale;

  /// 終了スケール
  final double endScale;

  /// スケール変化開始タイミング
  final double startAt;

  /// スケール変化終了タイミング
  final double endAt;

  const ScaleEffect({
    this.startScale = 1.0,
    this.endScale = 0.3,
    this.startAt = 0.5,
    this.endAt = 1.0,
  });

  /// 進捗に応じたスケールを計算
  double calculateScale(double progress) {
    if (progress < startAt) return startScale;
    if (progress > endAt) return endScale;

    final effectProgress = (progress - startAt) / (endAt - startAt);
    return startScale + (endScale - startScale) * effectProgress;
  }
}

/// フェードエフェクト
class FadeEffect {
  /// 開始不透明度
  final double startOpacity;

  /// 終了不透明度
  final double endOpacity;

  /// フェード開始タイミング
  final double startAt;

  /// フェード終了タイミング
  final double endAt;

  const FadeEffect({
    this.startOpacity = 1.0,
    this.endOpacity = 0.0,
    this.startAt = 0.7,
    this.endAt = 1.0,
  });

  /// 進捗に応じた不透明度を計算
  double calculateOpacity(double progress) {
    if (progress < startAt) return startOpacity;
    if (progress > endAt) return endOpacity;

    final effectProgress = (progress - startAt) / (endAt - startAt);
    return startOpacity + (endOpacity - startOpacity) * effectProgress;
  }
}

/// 軌跡エフェクト
class TrailEffect {
  /// 軌跡の長さ（0.0-1.0、全体の何%を表示するか）
  final double length;

  /// 軌跡の色
  final Color color;

  /// 軌跡の幅
  final double width;

  /// 軌跡の不透明度減衰
  final double fadeRate;

  const TrailEffect({
    this.length = 0.3,
    this.color = const Color(0x88FFFFFF),
    this.width = 2.0,
    this.fadeRate = 0.8,
  });
}

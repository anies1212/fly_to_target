import 'dart:math';

import 'package:flutter/widgets.dart';

/// 軌道設定の基底クラス
sealed class PathConfig {
  const PathConfig();

  /// 軌道上の位置を計算
  /// [t] は 0.0 から 1.0 の進捗値
  /// [start] は開始位置
  /// [end] は終了位置
  Offset calculatePosition(double t, Offset start, Offset end);
}

/// 直線軌道
class LinearPathConfig extends PathConfig {
  const LinearPathConfig();

  @override
  Offset calculatePosition(double t, Offset start, Offset end) {
    return Offset.lerp(start, end, t)!;
  }
}

/// 放物線軌道
class ParabolicPathConfig extends PathConfig {
  /// 放物線の高さ（負の値で上に膨らむ）
  final double height;

  /// 重力係数
  final double gravity;

  const ParabolicPathConfig({
    this.height = -100,
    this.gravity = 1.0,
  });

  @override
  Offset calculatePosition(double t, Offset start, Offset end) {
    // 線形補間で基本位置を計算
    final linearX = start.dx + (end.dx - start.dx) * t;
    final linearY = start.dy + (end.dy - start.dy) * t;

    // 放物線のオフセット（頂点がt=0.5にくる）
    final parabolicOffset = height * 4 * t * (1 - t) * gravity;

    return Offset(linearX, linearY + parabolicOffset);
  }
}

/// ベジェ曲線軌道
class BezierPathConfig extends PathConfig {
  /// 制御点（相対座標）
  final List<Offset>? controlPoints;

  /// 曲率（自動計算時に使用）
  final double curvature;

  /// ランダム性（各アイテムで少しずつ異なる軌道にする）
  final double randomness;

  /// 乱数生成器のシード（再現性のため）
  final int? seed;

  const BezierPathConfig({
    this.controlPoints,
    this.curvature = 0.5,
    this.randomness = 0.0,
    this.seed,
  });

  /// 自動計算で制御点を生成
  factory BezierPathConfig.auto({
    double curvature = 0.5,
    double randomness = 0.0,
    int? seed,
  }) {
    return BezierPathConfig(
      curvature: curvature,
      randomness: randomness,
      seed: seed,
    );
  }

  @override
  Offset calculatePosition(double t, Offset start, Offset end) {
    // 制御点が指定されている場合
    if (controlPoints != null && controlPoints!.isNotEmpty) {
      return _calculateWithControlPoints(t, start, end, controlPoints!);
    }

    // 自動計算で制御点を生成
    final random = seed != null ? Random(seed) : Random();
    final randomOffset = randomness > 0
        ? Offset(
            (random.nextDouble() - 0.5) * 2 * randomness * 100,
            (random.nextDouble() - 0.5) * 2 * randomness * 100,
          )
        : Offset.zero;

    // 中間点を計算
    final midX = (start.dx + end.dx) / 2;
    final midY = (start.dy + end.dy) / 2;

    // 曲線の方向を決定（開始点より上に膨らむ）
    final dx = end.dx - start.dx;
    final dy = end.dy - start.dy;
    final distance = sqrt(dx * dx + dy * dy);

    // 垂直方向のオフセット
    final perpX = -dy / distance * curvature * distance;
    final perpY = dx / distance * curvature * distance;

    final controlPoint = Offset(
      midX + perpX + randomOffset.dx,
      midY + perpY - distance * curvature * 0.5 + randomOffset.dy,
    );

    // 2次ベジェ曲線
    return _quadraticBezier(t, start, controlPoint, end);
  }

  Offset _quadraticBezier(double t, Offset p0, Offset p1, Offset p2) {
    final oneMinusT = 1 - t;
    return Offset(
      oneMinusT * oneMinusT * p0.dx + 2 * oneMinusT * t * p1.dx + t * t * p2.dx,
      oneMinusT * oneMinusT * p0.dy + 2 * oneMinusT * t * p1.dy + t * t * p2.dy,
    );
  }

  Offset _calculateWithControlPoints(
    double t,
    Offset start,
    Offset end,
    List<Offset> controls,
  ) {
    if (controls.length == 1) {
      // 2次ベジェ曲線
      return _quadraticBezier(t, start, controls[0], end);
    } else {
      // 3次ベジェ曲線
      return _cubicBezier(t, start, controls[0], controls[1], end);
    }
  }

  Offset _cubicBezier(double t, Offset p0, Offset p1, Offset p2, Offset p3) {
    final oneMinusT = 1 - t;
    final oneMinusT2 = oneMinusT * oneMinusT;
    final oneMinusT3 = oneMinusT2 * oneMinusT;
    final t2 = t * t;
    final t3 = t2 * t;

    return Offset(
      oneMinusT3 * p0.dx +
          3 * oneMinusT2 * t * p1.dx +
          3 * oneMinusT * t2 * p2.dx +
          t3 * p3.dx,
      oneMinusT3 * p0.dy +
          3 * oneMinusT2 * t * p1.dy +
          3 * oneMinusT * t2 * p2.dy +
          t3 * p3.dy,
    );
  }
}

/// カスタム軌道
class CustomPathConfig extends PathConfig {
  final Offset Function(double t, Offset start, Offset end) pathFunction;

  const CustomPathConfig({required this.pathFunction});

  @override
  Offset calculatePosition(double t, Offset start, Offset end) {
    return pathFunction(t, start, end);
  }
}

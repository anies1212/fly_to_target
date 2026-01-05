import 'dart:math';

import 'package:flutter/widgets.dart';

/// Base class for path configuration
sealed class PathConfig {
  const PathConfig();

  /// Calculate position on path
  /// [t] is progress value from 0.0 to 1.0
  /// [start] is start position
  /// [end] is end position
  Offset calculatePosition(double t, Offset start, Offset end);
}

/// Linear path
class LinearPathConfig extends PathConfig {
  const LinearPathConfig();

  @override
  Offset calculatePosition(double t, Offset start, Offset end) {
    return Offset.lerp(start, end, t)!;
  }
}

/// Parabolic path
class ParabolicPathConfig extends PathConfig {
  /// Parabola height (negative value curves upward)
  final double height;

  /// Gravity coefficient
  final double gravity;

  const ParabolicPathConfig({
    this.height = -100,
    this.gravity = 1.0,
  });

  @override
  Offset calculatePosition(double t, Offset start, Offset end) {
    // Calculate base position with linear interpolation
    final linearX = start.dx + (end.dx - start.dx) * t;
    final linearY = start.dy + (end.dy - start.dy) * t;

    // Parabolic offset (apex at t=0.5)
    final parabolicOffset = height * 4 * t * (1 - t) * gravity;

    return Offset(linearX, linearY + parabolicOffset);
  }
}

/// Bezier curve path
class BezierPathConfig extends PathConfig {
  /// Control points (relative coordinates)
  final List<Offset>? controlPoints;

  /// Curvature (used for auto calculation)
  final double curvature;

  /// Randomness (slightly different path for each item)
  final double randomness;

  /// Random seed (for reproducibility)
  final int? seed;

  const BezierPathConfig({
    this.controlPoints,
    this.curvature = 0.5,
    this.randomness = 0.0,
    this.seed,
  });

  /// Auto-generate control points
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
    // If control points are specified
    if (controlPoints != null && controlPoints!.isNotEmpty) {
      return _calculateWithControlPoints(t, start, end, controlPoints!);
    }

    // Auto-generate control points
    final random = seed != null ? Random(seed) : Random();
    final randomOffset = randomness > 0
        ? Offset(
            (random.nextDouble() - 0.5) * 2 * randomness * 100,
            (random.nextDouble() - 0.5) * 2 * randomness * 100,
          )
        : Offset.zero;

    // Calculate midpoint
    final midX = (start.dx + end.dx) / 2;
    final midY = (start.dy + end.dy) / 2;

    // Determine curve direction (curves upward from start)
    final dx = end.dx - start.dx;
    final dy = end.dy - start.dy;
    final distance = sqrt(dx * dx + dy * dy);

    // Perpendicular offset
    final perpX = -dy / distance * curvature * distance;
    final perpY = dx / distance * curvature * distance;

    final controlPoint = Offset(
      midX + perpX + randomOffset.dx,
      midY + perpY - distance * curvature * 0.5 + randomOffset.dy,
    );

    // Quadratic bezier curve
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
      // Quadratic bezier curve
      return _quadraticBezier(t, start, controls[0], end);
    } else {
      // Cubic bezier curve
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

/// Custom path
class CustomPathConfig extends PathConfig {
  final Offset Function(double t, Offset start, Offset end) pathFunction;

  const CustomPathConfig({required this.pathFunction});

  @override
  Offset calculatePosition(double t, Offset start, Offset end) {
    return pathFunction(t, start, end);
  }
}

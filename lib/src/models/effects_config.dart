import 'dart:math';

import 'package:flutter/painting.dart';

/// Rotation direction
enum RotationDirection {
  clockwise,
  counterClockwise,
}

/// Collection of effects
class FlyEffects {
  /// Rotation effect
  final RotationEffect? rotation;

  /// Scale effect
  final ScaleEffect? scale;

  /// Fade effect
  final FadeEffect? fade;

  /// Trail effect
  final TrailEffect? trail;

  const FlyEffects({
    this.rotation,
    this.scale,
    this.fade,
    this.trail,
  });

  /// Whether any effects are present
  bool get hasEffects =>
      rotation != null || scale != null || fade != null || trail != null;

  /// copyWith method
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

/// Rotation effect
class RotationEffect {
  /// Rotation amount (radians)
  final double rotations;

  /// Rotation direction
  final RotationDirection direction;

  /// Rotation start timing (0.0-1.0)
  final double startAt;

  /// Rotation end timing (0.0-1.0)
  final double endAt;

  const RotationEffect({
    this.rotations = 2 * pi,
    this.direction = RotationDirection.clockwise,
    this.startAt = 0.0,
    this.endAt = 1.0,
  });

  /// Calculate rotation amount based on progress
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

/// Scale effect
class ScaleEffect {
  /// Start scale
  final double startScale;

  /// End scale
  final double endScale;

  /// Scale change start timing
  final double startAt;

  /// Scale change end timing
  final double endAt;

  const ScaleEffect({
    this.startScale = 1.0,
    this.endScale = 0.3,
    this.startAt = 0.5,
    this.endAt = 1.0,
  });

  /// Calculate scale based on progress
  double calculateScale(double progress) {
    if (progress < startAt) return startScale;
    if (progress > endAt) return endScale;

    final effectProgress = (progress - startAt) / (endAt - startAt);
    return startScale + (endScale - startScale) * effectProgress;
  }
}

/// Fade effect
class FadeEffect {
  /// Start opacity
  final double startOpacity;

  /// End opacity
  final double endOpacity;

  /// Fade start timing
  final double startAt;

  /// Fade end timing
  final double endAt;

  const FadeEffect({
    this.startOpacity = 1.0,
    this.endOpacity = 0.0,
    this.startAt = 0.7,
    this.endAt = 1.0,
  });

  /// Calculate opacity based on progress
  double calculateOpacity(double progress) {
    if (progress < startAt) return startOpacity;
    if (progress > endAt) return endOpacity;

    final effectProgress = (progress - startAt) / (endAt - startAt);
    return startOpacity + (endOpacity - startOpacity) * effectProgress;
  }
}

/// Trail effect
class TrailEffect {
  /// Trail length (0.0-1.0, percentage of total to display)
  final double length;

  /// Trail color
  final Color color;

  /// Trail width
  final double width;

  /// Trail opacity decay rate
  final double fadeRate;

  const TrailEffect({
    this.length = 0.3,
    this.color = const Color(0x88FFFFFF),
    this.width = 2.0,
    this.fadeRate = 0.8,
  });
}

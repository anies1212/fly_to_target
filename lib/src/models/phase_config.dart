import 'package:flutter/widgets.dart';

/// Pre-animation phase configuration
/// Used to animate items from a gather point to their start positions
/// before the main fly animation begins
sealed class PrePhaseConfig {
  const PrePhaseConfig();
}

/// Spread phase: items gather at a point and spread to their start positions
class SpreadPhaseConfig extends PrePhaseConfig {
  /// The point where all items gather before spreading
  final Offset gatherPoint;

  /// Duration of the spread animation
  final Duration duration;

  /// Easing curve for the spread animation
  final Curve curve;

  const SpreadPhaseConfig({
    required this.gatherPoint,
    this.duration = const Duration(milliseconds: 400),
    this.curve = Curves.easeOutBack,
  });

  /// Create with center offset from a position and size
  factory SpreadPhaseConfig.fromCenter({
    required Offset position,
    required Size size,
    Duration duration = const Duration(milliseconds: 400),
    Curve curve = Curves.easeOutBack,
  }) {
    return SpreadPhaseConfig(
      gatherPoint: Offset(
        position.dx + size.width / 2,
        position.dy + size.height / 2,
      ),
      duration: duration,
      curve: curve,
    );
  }

  SpreadPhaseConfig copyWith({
    Offset? gatherPoint,
    Duration? duration,
    Curve? curve,
  }) {
    return SpreadPhaseConfig(
      gatherPoint: gatherPoint ?? this.gatherPoint,
      duration: duration ?? this.duration,
      curve: curve ?? this.curve,
    );
  }
}

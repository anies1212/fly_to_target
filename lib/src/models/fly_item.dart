import 'package:flutter/widgets.dart';

/// Origin position specification
sealed class FlyOrigin {
  const FlyOrigin();

  /// Get position from GlobalKey
  Offset? resolvePosition() {
    return switch (this) {
      FlyOriginFromKey(:final key) => _getPositionFromKey(key),
      FlyOriginFromOffset(:final offset) => offset,
    };
  }

  static Offset? _getPositionFromKey(GlobalKey key) {
    final renderBox = key.currentContext?.findRenderObject() as RenderBox?;
    if (renderBox == null) return null;
    return renderBox.localToGlobal(Offset.zero);
  }

  /// Get position and size from GlobalKey
  (Offset?, Size?) resolvePositionAndSize() {
    return switch (this) {
      FlyOriginFromKey(:final key) => _getPositionAndSizeFromKey(key),
      FlyOriginFromOffset(:final offset, :final size) => (offset, size),
    };
  }

  static (Offset?, Size?) _getPositionAndSizeFromKey(GlobalKey key) {
    final renderBox = key.currentContext?.findRenderObject() as RenderBox?;
    if (renderBox == null) return (null, null);
    return (renderBox.localToGlobal(Offset.zero), renderBox.size);
  }
}

/// Get position from GlobalKey
class FlyOriginFromKey extends FlyOrigin {
  final GlobalKey key;
  const FlyOriginFromKey(this.key);
}

/// Specify position directly with Offset
class FlyOriginFromOffset extends FlyOrigin {
  final Offset offset;
  final Size? size;
  const FlyOriginFromOffset(this.offset, {this.size});
}

/// Item to fly
class FlyItem {
  /// Widget to display
  final Widget child;

  /// Start position
  final FlyOrigin origin;

  /// Item size (attempts to get from child if null)
  final Size? size;

  /// ID for identification (used in callbacks)
  final String? id;

  const FlyItem({
    required this.child,
    required this.origin,
    this.size,
    this.id,
  });

  /// Create from GlobalKey
  factory FlyItem.fromKey({
    required Widget child,
    required GlobalKey key,
    String? id,
  }) {
    return FlyItem(
      child: child,
      origin: FlyOriginFromKey(key),
      id: id,
    );
  }

  /// Create from Offset
  factory FlyItem.fromOffset({
    required Widget child,
    required Offset offset,
    Size? size,
    String? id,
  }) {
    return FlyItem(
      child: child,
      origin: FlyOriginFromOffset(offset, size: size),
      size: size,
      id: id,
    );
  }

  /// Resolve position and size
  (Offset?, Size?) resolvePositionAndSize() {
    final (position, originSize) = origin.resolvePositionAndSize();
    return (position, size ?? originSize);
  }
}

/// Pair of item and individual destination
class FlyItemWithTarget {
  final FlyItem item;
  final FlyTarget target;

  const FlyItemWithTarget({
    required this.item,
    required this.target,
  });
}

/// Destination definition
sealed class FlyTarget {
  const FlyTarget();

  /// Resolve destination position
  Offset? resolvePosition() {
    return switch (this) {
      FlyTargetFromKey(:final key) => _getPositionFromKey(key),
      FlyTargetFromOffset(:final offset) => offset,
    };
  }

  static Offset? _getPositionFromKey(GlobalKey key) {
    final renderBox = key.currentContext?.findRenderObject() as RenderBox?;
    if (renderBox == null) return null;
    final position = renderBox.localToGlobal(Offset.zero);
    final size = renderBox.size;
    // Return center position
    return position + Offset(size.width / 2, size.height / 2);
  }
}

/// Specify destination from GlobalKey
class FlyTargetFromKey extends FlyTarget {
  final GlobalKey key;
  const FlyTargetFromKey(this.key);
}

/// Specify destination directly with Offset
class FlyTargetFromOffset extends FlyTarget {
  final Offset offset;
  const FlyTargetFromOffset(this.offset);
}

import 'package:flutter/widgets.dart';

/// 開始位置の指定方法
sealed class FlyOrigin {
  const FlyOrigin();

  /// GlobalKeyから位置を取得
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

  /// GlobalKeyから位置とサイズを取得
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

/// GlobalKeyから位置を取得
class FlyOriginFromKey extends FlyOrigin {
  final GlobalKey key;
  const FlyOriginFromKey(this.key);
}

/// Offsetで直接位置を指定
class FlyOriginFromOffset extends FlyOrigin {
  final Offset offset;
  final Size? size;
  const FlyOriginFromOffset(this.offset, {this.size});
}

/// 飛ばすアイテム
class FlyItem {
  /// 表示するウィジェット
  final Widget child;

  /// 開始位置
  final FlyOrigin origin;

  /// アイテムのサイズ（nullの場合はchildから取得を試みる）
  final Size? size;

  /// 識別用ID（コールバックで使用）
  final String? id;

  const FlyItem({
    required this.child,
    required this.origin,
    this.size,
    this.id,
  });

  /// GlobalKeyから生成
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

  /// Offsetから生成
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

  /// 位置とサイズを解決
  (Offset?, Size?) resolvePositionAndSize() {
    final (position, originSize) = origin.resolvePositionAndSize();
    return (position, size ?? originSize);
  }
}

/// アイテムと個別の目的地を持つペア
class FlyItemWithTarget {
  final FlyItem item;
  final FlyTarget target;

  const FlyItemWithTarget({
    required this.item,
    required this.target,
  });
}

/// 目的地の定義
sealed class FlyTarget {
  const FlyTarget();

  /// 目的地の位置を解決
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
    // 中心位置を返す
    return position + Offset(size.width / 2, size.height / 2);
  }
}

/// GlobalKeyから目的地を指定
class FlyTargetFromKey extends FlyTarget {
  final GlobalKey key;
  const FlyTargetFromKey(this.key);
}

/// Offsetで目的地を直接指定
class FlyTargetFromOffset extends FlyTarget {
  final Offset offset;
  const FlyTargetFromOffset(this.offset);
}

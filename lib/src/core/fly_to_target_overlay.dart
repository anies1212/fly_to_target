import 'dart:async';

import 'package:flutter/widgets.dart';

import '../models/fly_item.dart';
import '../models/fly_animation_config.dart';
import '../animations/flying_item_animation.dart';

/// アニメーション中のアイテムを管理するOverlayエントリ
class FlyingOverlayEntry {
  final OverlayEntry overlayEntry;
  final String id;
  final Completer<void> completer;

  FlyingOverlayEntry({
    required this.overlayEntry,
    required this.id,
    required this.completer,
  });
}

/// Overlay上でアニメーションを管理
class FlyToTargetOverlay {
  final List<FlyingOverlayEntry> _entries = [];
  OverlayState? _overlayState;

  /// Overlayを初期化
  void attach(BuildContext context) {
    _overlayState = Overlay.of(context);
  }

  /// アイテムを飛ばす
  Future<void> fly({
    required FlyItem item,
    required FlyTarget target,
    required FlyAnimationConfig config,
    required TickerProvider vsync,
    int index = 0,
    VoidCallback? onComplete,
  }) async {
    if (_overlayState == null) {
      throw StateError(
        'FlyToTargetOverlay is not attached. '
        'Call attach() first or use FlyToTargetScope.',
      );
    }

    final completer = Completer<void>();
    final id = '${item.id ?? 'item'}_${DateTime.now().millisecondsSinceEpoch}';

    // 開始位置と終了位置を解決
    final (startPosition, itemSize) = item.resolvePositionAndSize();
    final endPosition = target.resolvePosition();

    if (startPosition == null || endPosition == null) {
      completer.complete();
      return completer.future;
    }

    late OverlayEntry overlayEntry;
    overlayEntry = OverlayEntry(
      builder: (context) {
        return FlyingItemAnimation(
          item: item,
          startPosition: startPosition,
          endPosition: endPosition,
          itemSize: itemSize ?? const Size(40, 40),
          config: config,
          vsync: vsync,
          delay: config.staggerDelay * index,
          onComplete: () {
            _removeEntry(id);
            onComplete?.call();
            if (!completer.isCompleted) {
              completer.complete();
            }
          },
        );
      },
    );

    final entry = FlyingOverlayEntry(
      overlayEntry: overlayEntry,
      id: id,
      completer: completer,
    );

    _entries.add(entry);
    _overlayState!.insert(overlayEntry);

    return completer.future;
  }

  /// 複数のアイテムを同時に飛ばす
  Future<void> flyAll({
    required List<FlyItem> items,
    required FlyTarget target,
    required FlyAnimationConfig config,
    required TickerProvider vsync,
    VoidCallback? onAllComplete,
  }) async {
    if (items.isEmpty) {
      onAllComplete?.call();
      return;
    }

    final futures = <Future<void>>[];

    for (var i = 0; i < items.length; i++) {
      final future = fly(
        item: items[i],
        target: target,
        config: config,
        vsync: vsync,
        index: i,
      );
      futures.add(future);
    }

    await Future.wait(futures);
    onAllComplete?.call();
  }

  /// 複数のアイテムをそれぞれ異なる目的地へ飛ばす
  Future<void> flyToTargets({
    required List<FlyItemWithTarget> itemsWithTargets,
    required FlyAnimationConfig config,
    required TickerProvider vsync,
    VoidCallback? onAllComplete,
  }) async {
    if (itemsWithTargets.isEmpty) {
      onAllComplete?.call();
      return;
    }

    final futures = <Future<void>>[];

    for (var i = 0; i < itemsWithTargets.length; i++) {
      final itemWithTarget = itemsWithTargets[i];
      final future = fly(
        item: itemWithTarget.item,
        target: itemWithTarget.target,
        config: config,
        vsync: vsync,
        index: i,
      );
      futures.add(future);
    }

    await Future.wait(futures);
    onAllComplete?.call();
  }

  /// エントリを削除
  void _removeEntry(String id) {
    final index = _entries.indexWhere((e) => e.id == id);
    if (index != -1) {
      _entries[index].overlayEntry.remove();
      _entries.removeAt(index);
    }
  }

  /// 全てのアニメーションをキャンセル
  void cancelAll() {
    for (final entry in _entries) {
      entry.overlayEntry.remove();
      if (!entry.completer.isCompleted) {
        entry.completer.complete();
      }
    }
    _entries.clear();
  }

  /// 現在飛行中のアイテム数
  int get flyingCount => _entries.length;

  /// リソースを解放
  void dispose() {
    cancelAll();
    _overlayState = null;
  }
}

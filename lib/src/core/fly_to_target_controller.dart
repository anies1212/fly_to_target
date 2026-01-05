import 'dart:async';

import 'package:flutter/widgets.dart';

import '../models/fly_item.dart';
import '../models/fly_animation_config.dart';
import 'fly_to_target_overlay.dart';

/// アニメーション完了イベント
class FlyCompletionEvent {
  final String? itemId;
  final DateTime completedAt;

  FlyCompletionEvent({
    this.itemId,
    DateTime? completedAt,
  }) : completedAt = completedAt ?? DateTime.now();
}

/// 複数のウィジェットを目的地に飛ばすアニメーションを制御
class FlyToTargetController {
  final FlyToTargetOverlay _overlay = FlyToTargetOverlay();
  final StreamController<FlyCompletionEvent> _completionController =
      StreamController<FlyCompletionEvent>.broadcast();

  TickerProvider? _vsync;
  bool _isAttached = false;

  /// アニメーション完了時のストリーム
  Stream<FlyCompletionEvent> get onComplete => _completionController.stream;

  /// 現在飛行中のアイテム数
  int get flyingCount => _overlay.flyingCount;

  /// コントローラーがアタッチされているかどうか
  bool get isAttached => _isAttached;

  /// BuildContextとTickerProviderでコントローラーを初期化
  void attach(BuildContext context, TickerProvider vsync) {
    _overlay.attach(context);
    _vsync = vsync;
    _isAttached = true;
  }

  /// 複数のアイテムを共通の目的地へ飛ばす
  Future<void> flyAll({
    required List<FlyItem> items,
    required FlyTarget target,
    FlyAnimationConfig? config,
  }) async {
    _ensureAttached();

    final effectiveConfig = config ?? const FlyAnimationConfig();

    await _overlay.flyAll(
      items: items,
      target: target,
      config: effectiveConfig,
      vsync: _vsync!,
      onAllComplete: () {
        for (final item in items) {
          _completionController.add(FlyCompletionEvent(itemId: item.id));
        }
      },
    );
  }

  /// 複数のアイテムをそれぞれ異なる目的地へ飛ばす
  Future<void> flyToTargets({
    required List<FlyItemWithTarget> itemsWithTargets,
    FlyAnimationConfig? config,
  }) async {
    _ensureAttached();

    final effectiveConfig = config ?? const FlyAnimationConfig();

    await _overlay.flyToTargets(
      itemsWithTargets: itemsWithTargets,
      config: effectiveConfig,
      vsync: _vsync!,
      onAllComplete: () {
        for (final itemWithTarget in itemsWithTargets) {
          _completionController.add(
            FlyCompletionEvent(itemId: itemWithTarget.item.id),
          );
        }
      },
    );
  }

  /// 単一のアイテムを飛ばす
  Future<void> fly({
    required FlyItem item,
    required FlyTarget target,
    FlyAnimationConfig? config,
  }) async {
    _ensureAttached();

    final effectiveConfig = config ?? const FlyAnimationConfig();

    await _overlay.fly(
      item: item,
      target: target,
      config: effectiveConfig,
      vsync: _vsync!,
      onComplete: () {
        _completionController.add(FlyCompletionEvent(itemId: item.id));
      },
    );
  }

  /// 全てのアニメーションをキャンセル
  void cancelAll() {
    _overlay.cancelAll();
  }

  void _ensureAttached() {
    if (!_isAttached || _vsync == null) {
      throw StateError(
        'FlyToTargetController is not attached. '
        'Call attach() first or use FlyToTargetScope.',
      );
    }
  }

  /// リソースを解放
  void dispose() {
    _overlay.dispose();
    _completionController.close();
    _vsync = null;
    _isAttached = false;
  }
}

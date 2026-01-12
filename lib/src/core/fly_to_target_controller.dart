import 'dart:async';

import 'package:flutter/widgets.dart';

import '../models/fly_item.dart';
import '../models/fly_animation_config.dart';
import 'fly_to_target_overlay.dart';

/// Animation completion event
class FlyCompletionEvent {
  final String? itemId;
  final DateTime completedAt;

  FlyCompletionEvent({
    this.itemId,
    DateTime? completedAt,
  }) : completedAt = completedAt ?? DateTime.now();
}

/// Controls animations for flying multiple widgets to destinations
class FlyToTargetController {
  final FlyToTargetOverlay _overlay = FlyToTargetOverlay();
  final StreamController<FlyCompletionEvent> _completionController =
      StreamController<FlyCompletionEvent>.broadcast();

  TickerProvider? _vsync;
  bool _isAttached = false;

  /// Stream for animation completion events
  Stream<FlyCompletionEvent> get onComplete => _completionController.stream;

  /// Number of items currently in flight
  int get flyingCount => _overlay.flyingCount;

  /// Whether the controller is attached
  bool get isAttached => _isAttached;

  /// Initialize controller with BuildContext and TickerProvider
  void attach(BuildContext context, TickerProvider vsync) {
    _overlay.attach(context);
    _vsync = vsync;
    _isAttached = true;
  }

  /// Fly multiple items to a common destination
  ///
  /// [onSpreadComplete] is called each time an individual item completes its spread phase.
  /// The callback receives the index of the item that finished spreading.
  ///
  /// [onItemComplete] is called each time an individual item reaches its target.
  /// The callback receives the index of the completed item.
  Future<void> flyAll({
    required List<FlyItem> items,
    required FlyTarget target,
    FlyAnimationConfig? config,
    void Function(int index)? onSpreadComplete,
    void Function(int index)? onItemComplete,
  }) async {
    _ensureAttached();

    final effectiveConfig = config ?? const FlyAnimationConfig();

    await _overlay.flyAll(
      items: items,
      target: target,
      config: effectiveConfig,
      vsync: _vsync!,
      onSpreadComplete: onSpreadComplete,
      onItemComplete: onItemComplete,
      onAllComplete: () {
        for (final item in items) {
          _completionController.add(FlyCompletionEvent(itemId: item.id));
        }
      },
    );
  }

  /// Fly multiple items to their respective destinations
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

  /// Fly a single item
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

  /// Cancel all animations
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

  /// Dispose resources
  void dispose() {
    _overlay.dispose();
    _completionController.close();
    _vsync = null;
    _isAttached = false;
  }
}

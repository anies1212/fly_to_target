import 'package:flutter/widgets.dart';

import '../models/fly_item.dart';

/// 目的地を示すウィジェット（GlobalKeyを自動管理）
class FlyTargetWidget extends StatefulWidget {
  /// 子ウィジェット
  final Widget child;

  /// ターゲットのID
  final String targetId;

  /// コールバックで目的地を取得するための関数
  final void Function(FlyTarget target)? onTargetReady;

  const FlyTargetWidget({
    super.key,
    required this.child,
    required this.targetId,
    this.onTargetReady,
  });

  @override
  State<FlyTargetWidget> createState() => FlyTargetWidgetState();
}

/// FlyTargetWidgetの状態
class FlyTargetWidgetState extends State<FlyTargetWidget> {
  late final GlobalKey _key;
  late final FlyTarget _target;

  @override
  void initState() {
    super.initState();
    _key = GlobalKey(debugLabel: 'FlyTarget_${widget.targetId}');
    _target = FlyTargetFromKey(_key);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      widget.onTargetReady?.call(_target);
    });
  }

  /// このウィジェットのFlyTargetを取得
  FlyTarget get target => _target;

  @override
  Widget build(BuildContext context) {
    return KeyedSubtree(
      key: _key,
      child: widget.child,
    );
  }
}

/// FlyTargetWidgetのGlobalKeyから目的地を取得するための拡張
extension FlyTargetWidgetExtension on GlobalKey<FlyTargetWidgetState> {
  /// FlyTargetを取得
  FlyTarget? get target => currentState?.target;
}

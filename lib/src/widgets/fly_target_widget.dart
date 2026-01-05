import 'package:flutter/widgets.dart';

import '../models/fly_item.dart';

/// Widget indicating a destination (automatically manages GlobalKey)
class FlyTargetWidget extends StatefulWidget {
  /// Child widget
  final Widget child;

  /// Target ID
  final String targetId;

  /// Callback function to get destination
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

/// State for FlyTargetWidget
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

  /// Get FlyTarget for this widget
  FlyTarget get target => _target;

  @override
  Widget build(BuildContext context) {
    return KeyedSubtree(
      key: _key,
      child: widget.child,
    );
  }
}

/// Extension to get destination from FlyTargetWidget's GlobalKey
extension FlyTargetWidgetExtension on GlobalKey<FlyTargetWidgetState> {
  /// Get FlyTarget
  FlyTarget? get target => currentState?.target;
}

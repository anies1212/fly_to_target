import 'package:flutter/widgets.dart';

import '../core/fly_to_target_controller.dart';

/// Scope widget that provides controller to descendants
class FlyToTargetScope extends StatefulWidget {
  /// Child widget
  final Widget child;

  /// External controller (creates internal one if omitted)
  final FlyToTargetController? controller;

  const FlyToTargetScope({
    super.key,
    required this.child,
    this.controller,
  });

  /// Get the nearest FlyToTargetController
  static FlyToTargetController of(BuildContext context) {
    final scope =
        context.dependOnInheritedWidgetOfExactType<_FlyToTargetInherited>();
    if (scope == null) {
      throw StateError(
        'No FlyToTargetScope found in context. '
        'Make sure to wrap your widget tree with FlyToTargetScope.',
      );
    }
    return scope.controller;
  }

  /// Version that returns null
  static FlyToTargetController? maybeOf(BuildContext context) {
    final scope =
        context.dependOnInheritedWidgetOfExactType<_FlyToTargetInherited>();
    return scope?.controller;
  }

  @override
  State<FlyToTargetScope> createState() => _FlyToTargetScopeState();
}

class _FlyToTargetScopeState extends State<FlyToTargetScope>
    with TickerProviderStateMixin {
  late FlyToTargetController _controller;
  bool _ownController = false;

  @override
  void initState() {
    super.initState();
    _initController();
  }

  void _initController() {
    if (widget.controller != null) {
      _controller = widget.controller!;
      _ownController = false;
    } else {
      _controller = FlyToTargetController();
      _ownController = true;
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Attach controller (set Overlay and TickerProvider)
    if (!_controller.isAttached) {
      _controller.attach(context, this);
    }
  }

  @override
  void didUpdateWidget(FlyToTargetScope oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.controller != oldWidget.controller) {
      if (_ownController) {
        _controller.dispose();
      }
      _initController();
      if (!_controller.isAttached) {
        _controller.attach(context, this);
      }
    }
  }

  @override
  void dispose() {
    if (_ownController) {
      _controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _FlyToTargetInherited(
      controller: _controller,
      child: widget.child,
    );
  }
}

class _FlyToTargetInherited extends InheritedWidget {
  final FlyToTargetController controller;

  const _FlyToTargetInherited({
    required this.controller,
    required super.child,
  });

  @override
  bool updateShouldNotify(_FlyToTargetInherited oldWidget) {
    return controller != oldWidget.controller;
  }
}

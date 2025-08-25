import 'package:flutter/material.dart';

class JosListener<T extends ChangeNotifier, F> extends StatefulWidget {
  const JosListener({
    super.key,
    required this.jos,
    required this.listener,
    this.initialState,
    required this.child,
  });

  final T jos;
  final Widget child;
  final F? Function(BuildContext, F?, T) listener;
  final F? initialState;

  @override
  State createState() => _JosListenerState<T, F>();
}

class _JosListenerState<T extends ChangeNotifier, F>
    extends State<JosListener<T, F>> {
  @override
  void initState() {
    _state = widget.initialState;
    widget.jos.addListener(_onUpdate);
    super.initState();
  }

  @override
  void didUpdateWidget(covariant JosListener<T, F> oldWidget) {
    if (oldWidget.jos != widget.jos) {
      oldWidget.jos.removeListener(_onUpdate);
      widget.jos.addListener(_onUpdate);
      _onUpdate();
    }

    if (oldWidget.child != widget.child) {
      setState(() {});
    }

    super.didUpdateWidget(oldWidget);
  }

  late F? _state;
  void _onUpdate() {
    _state = widget.listener(context, _state, widget.jos);
  }

  @override
  void dispose() {
    widget.jos.removeListener(_onUpdate);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}

import 'package:flutter/material.dart';

class JosSelector<T extends ChangeNotifier, F> extends StatefulWidget {
  const JosSelector({
    super.key,
    required this.jos,
    required this.selector,
    this.eq,
    required this.builder,
  });

  final T jos;
  final F Function(T jos) selector;
  final bool Function(F, F)? eq;
  final Widget Function(BuildContext context, F value) builder;

  @override
  State createState() => _JosSelectorState<T, F>();
}

class _JosSelectorState<T extends ChangeNotifier, F>
    extends State<JosSelector<T, F>> {
  @override
  void initState() {
    super.initState();
    _state = widget.selector(widget.jos);
    widget.jos.addListener(_onUpdate);
  }

  @override
  void didUpdateWidget(JosSelector<T, F> oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.jos != widget.jos) {
      oldWidget.jos.removeListener(_onUpdate);
      widget.jos.addListener(_onUpdate);
      final newState = widget.selector(widget.jos);
      if (!cmpState(_state, newState)) {
        _state = newState;
      }
    }
  }

  void _onUpdate() {
    final newState = widget.selector(widget.jos);
    if (!cmpState(_state, newState)) {
      setState(() {
        _state = newState;
      });
    }
  }

  bool cmpState(F old, F current) {
    final eq = widget.eq;
    if (eq == null) {
      return old == current;
    } else {
      return eq(old, current);
    }
  }

  @override
  void dispose() {
    widget.jos.removeListener(_onUpdate);
    super.dispose();
  }

  late F _state;

  @override
  Widget build(BuildContext context) {
    return widget.builder(context, _state);
  }
}

import 'package:flutter/material.dart';
import 'package:jos/jos.dart';

class JosProvider<T extends Jos> extends StatefulWidget {
  const JosProvider({
    super.key,
    required this.create,
    this.preDispose,
    required this.builder,
  });

  final T Function() create;
  final Function(T)? preDispose;
  final Function(BuildContext context, T jos) builder;

  @override
  State createState() => _JosProviderState<T>();
}

class _JosProviderState<T extends Jos> extends State<JosProvider<T>> {
  late T jos;
  @override
  void initState() {
    super.initState();
    jos = widget.create();
  }

  @override
  void dispose() {
    widget.preDispose?.call(jos);
    jos.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => widget.builder(context, jos);
}


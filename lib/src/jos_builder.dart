import 'package:flutter/material.dart';

class JosBuilder<T extends ChangeNotifier> extends StatelessWidget {
  const JosBuilder({super.key, required this.jos, required this.builder});

  final T jos;
  final Widget Function(BuildContext, T) builder;

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: jos,
      builder: (context, _) => builder(context, jos),
    );
  }
}

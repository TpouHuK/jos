## Features

This package is opinionated solution for state management.
It's a thin wrapper around `ChangeNotifier`, which allows to write controllers/state manamagement without burden of codegen and copyWith methods. Don't forget to `.flush()`!

## Getting started

Here's an example of a simple counter.

```dart
import 'package:flutter/material.dart';
import 'package:jos/jos.dart';

class CounterJos extends Jos {
  int count = 0; // That's the state!

  void inc() {
    this
      ..count += 1
      ..flush(); // Flush notifies all listeners
  }
}

class CounterPage extends StatefulWidget {
  const CounterPage({super.key});
  @override
  State createState() => _CounterPageState();
}

class _CounterPageState extends State<CounterPage> {
  final jos = CounterJos();

  @override
  void dispose() {
    jos.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        JosBuilder( // Thin wrapper around listenable builder
          jos: jos,
          builder: (context, jos) { // This is the same jos as outer in the argument
            return Text("Count: ${jos.count}");
          },
        ),
        ElevatedButton(
          onPressed: jos.inc, // Just call the function!
          child: Text("inc"),
        ),
      ],
    );
  }
}
```

## Additional information

Questions:

> Is it any good? 

Yes.

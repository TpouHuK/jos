import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

class Jos extends ChangeNotifier {
  Function()? preFlush;
  Function()? postFlush;

  void flush() {
    preFlush?.call();
    notifyListeners();
    postFlush?.call();
  }
}

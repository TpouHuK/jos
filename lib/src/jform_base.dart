import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:jos/jos.dart';

List<JFormError> jValidateAll(List<JFormField> fields) {
  List<JFormError> errors = [];
  for (final field in fields) {
    final error = field.error;
    if (error != null) {
      errors.add(error);
    }
  }
  return errors;
}

bool jIsValid(List<JFormField> fields) {
  for (final field in fields) {
    if (field.error != null) {
      return false;
    }
  }
  return true;
}

void touchAll(List<JFormField> fields) {
  for (final field in fields) {
    field.markDirty();
  }
}

abstract class JFormError {
  String getDescription(BuildContext context) {
    if (kDebugMode) {
      debugPrint("Please override the debug description of an error");
    }
    return $debugDescription;
  }

  String get $debugDescription {
    return "Field is invalid";
  }
}

mixin JFormErrorDebugMixin implements JFormError {
  @override
  String getDescription(BuildContext context) {
    return $debugDescription;
  }

  @override
  String get $debugDescription {
    return "Field is invalid: reason: $this";
  }
}

abstract class JFormField<T, E extends JFormError> {
  E? get error;
  E? get displayError;

  void setValue(T value);
  T get value;

  void markDirty({bool isDirty = true});
  void forceSet(T value, bool isDirty);
}

abstract class JFormFieldImpl<T, E extends JFormError> extends Jos
    implements JFormField<T, E> {
  JFormFieldImpl({required T value, this.isDirty = false}) : _value = value;
  E? validate(T value);

  @override
  T get value => _value;
  T _value;

  bool isDirty;

  @override
  E? get error => validate(value);
  @override
  E? get displayError => isDirty ? error : null;

  @override
  void forceSet(T value, bool isDirty) {
    this
      .._value = value
      ..isDirty = isDirty
      ..flush();
  }

  @override
  void setValue(T value) {
    this
      .._value = value
      ..isDirty = true
      ..flush();
  }

  @override
  void markDirty({bool isDirty = true}) {
    if (isDirty != this.isDirty) {
      this
        ..isDirty = isDirty
        ..flush();
    }
  }
}

abstract class JFormFieldImplCachedErr<T, E extends JFormError> extends Jos
    implements JFormField<T, E> {
  JFormFieldImplCachedErr({required T value, this.isDirty = false})
    : _value = value;
  E? validate(T value);

  @override
  T get value => _value;
  T _value;
  E? _cachedErr;

  bool isDirty;

  @override
  E? get error => _cachedErr;
  @override
  E? get displayError => isDirty ? error : null;

  @override
  void forceSet(T value, bool isDirty) {
    this
      .._value = value
      ..isDirty = isDirty
      .._cachedErr = validate(value)
      ..flush();
  }

  @override
  void setValue(T value) {
    this
      .._value = value
      .._cachedErr = validate(value)
      ..isDirty = true
      ..flush();
  }

  @override
  void markDirty({bool isDirty = true}) {
    if (isDirty != this.isDirty) {
      this
        ..isDirty = isDirty
        ..flush();
    }
  }
}

abstract class TextFormInput<E extends JFormError>
    extends JFormFieldImpl<String, E> {
  TextFormInput({String text = "", super.isDirty}) : super(value: text) {
    controller = TextEditingController(text: text)..addListener(_onUpdate);
  }

  late final TextEditingController controller;
  void _onUpdate() {
    if (value != controller.text) {
      setValue(controller.text);
    }
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }
}

abstract class TextFormInputCachedErr<E extends JFormError>
    extends JFormFieldImplCachedErr<String, E> {
  TextFormInputCachedErr({String text = "", super.isDirty})
    : super(value: text) {
    controller = TextEditingController(text: text)..addListener(_onUpdate);
  }

  late final TextEditingController controller;
  void _onUpdate() {
    if (value != controller.text) {
      setValue(controller.text);
    }
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }
}

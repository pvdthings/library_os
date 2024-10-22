part of '../editable.dart';

class Editable<T> {
  Editable(this._initialValue);

  final T _initialValue;
  T? _editedValue;

  void set(T value) {
    _editedValue = value;
  }

  void reset() {
    _editedValue = null;
  }

  T get value => _editedValue ?? _initialValue;

  bool get edited => _editedValue != _initialValue;
}

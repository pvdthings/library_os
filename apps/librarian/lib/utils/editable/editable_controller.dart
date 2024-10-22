part of '../editable.dart';

class EditableController {
  const EditableController(this._editables);

  final Iterable<Editable<dynamic>> _editables;

  bool get edited => _editables.any((e) => e.edited);

  void reset() {
    for (final e in _editables) {
      e.reset();
    }
  }
}

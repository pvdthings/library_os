import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:librarian_app/modules/loans/checkout/checkout_minimizable_dialog.dart';

class WorkspaceController {
  WorkspaceController(this.ref);

  final Ref ref;
  final Map<String, WorkspaceItem> _minimized = {};

  String? _windowId;
  Widget? _window;

  ActiveWorkspaceItem? get activeItem {
    if (_window == null) {
      return null;
    }

    return ActiveWorkspaceItem(
      isMinimized: isMinimized(_windowId!),
      widget: _window!,
    );
  }

  List<MapEntry<String, WorkspaceItem>> get minimizedItems {
    return _minimized.entries.toList();
  }

  void open(WorkspaceWindow window) {
    _windowId = window.id;
    _window = window;
    ref.notifyListeners();
  }

  void close(String id) {
    _windowId = null;
    _window = null;
    ref.notifyListeners();
  }

  void maximize(String id) {
    _minimized.remove(id);
    ref.notifyListeners();
  }

  void minimize(
    String id, {
    String? title,
  }) {
    _minimized[id] = WorkspaceItem(id: id, title: title);
    ref.notifyListeners();
  }

  bool isMinimized(String id) {
    return _minimized.containsKey(id);
  }
}

class WorkspaceItem {
  WorkspaceItem({
    required this.id,
    this.title,
  });

  final String id;
  final String? title;
}

class ActiveWorkspaceItem {
  const ActiveWorkspaceItem({
    required this.isMinimized,
    required this.widget,
  });

  final bool isMinimized;
  final Widget widget;
}

final workspace = Provider((ref) => WorkspaceController(ref));

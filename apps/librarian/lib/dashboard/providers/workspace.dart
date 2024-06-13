import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:librarian_app/dashboard/widgets/workspace_window.dart';

class WorkspaceController {
  WorkspaceController(this.ref);

  final Ref ref;
  final List<WorkspaceItem> _items = [];
  final Map<String, WorkspaceItem> _minimized = {};

  bool get hasItem => _items.isNotEmpty;

  ActiveWorkspaceItem? get activeItem {
    if (_items.isEmpty) {
      return null;
    }

    final item = _items.last;

    return ActiveWorkspaceItem(
      isMinimized: isMinimized(item.id),
      widget: item.widget,
    );
  }

  List<MapEntry<String, WorkspaceItem>> get minimizedItems {
    return _minimized.entries.toList();
  }

  void open(WorkspaceWindow window) {
    _items.add(WorkspaceItem(
      id: window.id,
      title: window.title,
      widget: window,
    ));

    ref.notifyListeners();
  }

  void closeWindow() {
    _items.removeLast();
    ref.notifyListeners();
  }

  void close(String id) {
    _items.removeWhere((i) => i.id == id);
    _minimized.remove(id);

    ref.notifyListeners();
  }

  void maximize(String id) {
    // minimize current active item
    final activeItem = _items.last;
    _minimized[activeItem.id] = activeItem;

    // make active
    final item = _items.firstWhere((i) => i.id == id);
    _items.remove(item);
    _items.add(item);

    // maximize
    _minimized.remove(id);

    ref.notifyListeners();
  }

  void minimize(
    String id, {
    String? title,
  }) {
    _minimized[id] = _items.last;
    ref.notifyListeners();
  }

  bool isMinimized(String id) {
    return _minimized.containsKey(id);
  }
}

class WorkspaceItem {
  WorkspaceItem({
    required this.id,
    required this.widget,
    this.title,
  });

  final String id;
  final String? title;
  final Widget widget;
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

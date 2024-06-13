import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:librarian_app/dashboard/providers/workspace.dart';
import 'package:uuid/uuid.dart';

class WorkspaceWindow extends ConsumerWidget {
  WorkspaceWindow({
    super.key,
    required this.title,
    required this.content,
  });

  late final id = const Uuid().v4();

  final String title;
  final Widget content;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ws = ref.watch(workspace);

    return Offstage(
      offstage: ws.isMinimized(id),
      child: Card(
        clipBehavior: Clip.antiAlias,
        color: Theme.of(context).colorScheme.surfaceContainerHigh,
        elevation: 1,
        child: Column(
          children: [
            WorkspaceWindowHeader(
              title: title,
              onMinimize: () => ws.minimize(id, title: title),
              onClose: () => ws.close(id),
            ),
            Expanded(
              child: SingleChildScrollView(
                child: content,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class WorkspaceWindowHeader extends StatelessWidget {
  const WorkspaceWindowHeader({
    super.key,
    required this.title,
    required this.onMinimize,
    required this.onClose,
  });

  final String title;
  final void Function() onMinimize;
  final void Function() onClose;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).colorScheme.primaryContainer,
      padding: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 8,
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              title,
              style: Theme.of(context).textTheme.titleLarge,
            ),
          ),
          IconButton(
            onPressed: onMinimize,
            icon: const Icon(Icons.arrow_downward),
          ),
          const SizedBox(width: 4),
          IconButton(
            onPressed: onClose,
            icon: const Icon(Icons.close),
          ),
        ],
      ),
    );
  }
}

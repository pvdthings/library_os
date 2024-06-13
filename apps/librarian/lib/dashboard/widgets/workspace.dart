import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:librarian_app/dashboard/providers/workspace.dart';

class Workspace extends ConsumerWidget {
  const Workspace({
    super.key,
    required this.child,
  });

  final Widget child;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ws = ref.watch(workspace);

    return Stack(
      children: [
        Container(
          margin: const EdgeInsets.only(right: 8, bottom: 8),
          child: child,
        ),
        Align(
          alignment: Alignment.center,
          child: Container(
            margin: const EdgeInsets.only(
              right: 8,
              bottom: 8,
              left: 8,
            ),
            child: AnimatedOpacity(
              opacity: ws.activeItem != null ? 1 : 0,
              duration: const Duration(milliseconds: 200),
              child: ws.activeItem?.widget,
            ),
          ),
        ),
        const Align(
          alignment: Alignment.bottomRight,
          child: MinimizedItems(),
        ),
      ],
    );
  }
}

class MinimizedItems extends ConsumerWidget {
  const MinimizedItems({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ws = ref.watch(workspace);

    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      mainAxisAlignment: MainAxisAlignment.end,
      mainAxisSize: MainAxisSize.min,
      children: [
        ...ws.minimizedItems.map(
          (entry) => MinimizedItem(
            title: entry.value.title ?? '',
            onMaximize: () {
              ws.maximize(entry.value.id);
            },
          ),
        ),
        const SizedBox(width: 16),
      ],
    );
  }
}

class MinimizedItem extends StatelessWidget {
  const MinimizedItem({
    super.key,
    required this.title,
    required this.onMaximize,
  });

  final String title;
  final void Function() onMaximize;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onMaximize,
      child: Container(
        constraints: const BoxConstraints(minWidth: 160, maxWidth: 400),
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(8),
            topRight: Radius.circular(8),
          ),
          boxShadow: [
            BoxShadow(
              color: Theme.of(context).shadowColor.withOpacity(0.2),
              blurRadius: 4,
              spreadRadius: 2,
            )
          ],
          color: Colors.amber,
        ),
        padding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 8,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: const TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(width: 16),
            const Icon(
              Icons.circle,
              size: 8,
              color: Colors.black,
            ),
          ],
        ),
      ),
    );
  }
}

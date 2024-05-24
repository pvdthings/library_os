import 'package:flutter/material.dart';

import 'pane_header.dart';

class ListPane extends StatelessWidget {
  const ListPane({
    super.key,
    required this.header,
    required this.child,
  });

  final PaneHeader header;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Theme.of(context).colorScheme.surfaceContainerHigh,
      clipBehavior: Clip.antiAlias,
      child: SizedBox(
        width: 500,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            header,
            Expanded(child: child),
          ],
        ),
      ),
    );
  }
}

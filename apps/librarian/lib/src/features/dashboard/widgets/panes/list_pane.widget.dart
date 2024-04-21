import 'package:flutter/material.dart';

import 'pane_header.widget.dart';

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
      clipBehavior: Clip.antiAlias,
      child: SizedBox(
        width: 500,
        child: Column(
          children: [
            header,
            Expanded(child: child),
          ],
        ),
      ),
    );
  }
}

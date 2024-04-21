import 'package:flutter/material.dart';
import 'package:librarian_app/src/utils/media_query.dart';

class DetailsCard extends StatelessWidget {
  const DetailsCard({
    super.key,
    this.header,
    this.showDivider = false,
    required this.body,
  });

  final Widget? header;
  final Widget? body;
  final bool showDivider;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: isMobile(context) ? 1 : 0,
      margin: EdgeInsets.zero,
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (header != null) ...[
            header!,
            if (showDivider) const Divider(),
          ],
          if (body != null) body!,
          if (body == null) const SizedBox(height: 8),
        ],
      ),
    );
  }
}

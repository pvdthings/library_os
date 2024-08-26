import 'package:flutter/material.dart';

class GeneralDialog extends StatelessWidget {
  const GeneralDialog({
    super.key,
    required this.content,
    this.title,
    this.titlePrefix,
    this.footerActions,
  });

  final Widget content;
  final String? title;
  final Widget? titlePrefix;
  final List<Widget>? footerActions;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                if (titlePrefix != null) titlePrefix!,
                const SizedBox(width: 8.0),
                if (title != null)
                  Expanded(
                    child: Text(
                      title!,
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                  ),
                CloseButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            ),
          ),
          Expanded(child: content),
          if (footerActions != null && footerActions!.isNotEmpty)
            Container(
              color: Theme.of(context).colorScheme.surface.withAlpha(180),
              padding: const EdgeInsets.all(16.0),
              child: Wrap(
                alignment: WrapAlignment.end,
                spacing: 8.0,
                children: footerActions!,
              ),
            ),
        ],
      ),
    );
  }
}

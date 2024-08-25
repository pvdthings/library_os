import 'package:flutter/material.dart';

class GeneralDialog extends StatelessWidget {
  const GeneralDialog({
    super.key,
    required this.content,
    this.title,
    this.titlePrefix,
    this.closeWidget,
  });

  final Widget content;
  final String? title;
  final Widget? titlePrefix;
  final Widget? closeWidget;

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
                closeWidget ??
                    CloseButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
              ],
            ),
          ),
          Expanded(child: content),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';

class GeneralDialog extends StatelessWidget {
  const GeneralDialog({
    super.key,
    required this.content,
    this.title,
    this.titlePrefix,
    this.titleSuffix,
    this.toolbar,
    this.footerActions,
    this.closeButton = true,
  });

  final bool closeButton;
  final String? title;
  final Widget? titlePrefix;
  final Widget? titleSuffix;
  final Widget? toolbar;
  final Widget content;
  final List<Widget>? footerActions;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            decoration: BoxDecoration(
              color: Theme.of(context).dialogBackgroundColor,
              boxShadow: const [
                BoxShadow(
                  blurRadius: 8.0,
                  offset: Offset(0, -1.0),
                )
              ],
            ),
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
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
                    if (titleSuffix != null) titleSuffix!,
                    const SizedBox(width: 8.0),
                    if (closeButton)
                      CloseButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      ),
                  ],
                ),
                if (toolbar != null)
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: toolbar!,
                  ),
              ],
            ),
          ),
          Expanded(child: content),
          if (footerActions != null && footerActions!.isNotEmpty)
            Container(
              decoration: BoxDecoration(
                color: Theme.of(context).dialogBackgroundColor,
                boxShadow: const [
                  BoxShadow(
                    blurRadius: 8.0,
                    offset: Offset(0, 2.0),
                  )
                ],
              ),
              padding: const EdgeInsets.all(16.0),
              child: Wrap(
                alignment: WrapAlignment.end,
                crossAxisAlignment: WrapCrossAlignment.center,
                spacing: 8.0,
                children: footerActions!,
              ),
            ),
        ],
      ),
    );
  }
}

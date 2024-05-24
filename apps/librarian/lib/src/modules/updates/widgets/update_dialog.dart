// ignore: avoid_web_libraries_in_flutter
import 'dart:html';

import 'package:flutter/material.dart';

import '../core/semantic_version.dart';

class UpdateDialog extends StatelessWidget {
  const UpdateDialog({super.key, required this.version});

  final SemanticVersion version;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      icon: const Icon(Icons.update),
      title: const Text('Update Available'),
      content: Text(
          'A new version (${version.text}) is available.\n\nWarning: Choosing \'Update\' will restart the app and delete any unsaved changes. You may update at any time by restarting the app.'),
      contentPadding: const EdgeInsets.all(16),
      actions: [
        OutlinedButton(
          onPressed: () {
            Navigator.of(context).pop(false);
          },
          child: const Text('Cancel'),
        ),
        FilledButton(
          onPressed: () {
            // Restart the app
            window.location.reload();
          },
          child: const Text('Update'),
        ),
      ],
    );
  }
}

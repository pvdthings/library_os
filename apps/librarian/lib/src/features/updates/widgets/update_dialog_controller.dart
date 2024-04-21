import 'package:flutter/material.dart';

import '../core/semantic_version.dart';
import 'update_dialog.dart';

class UpdateDialogController {
  const UpdateDialogController(this.context);

  final BuildContext context;

  void showUpdateDialog(SemanticVersion version) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => FractionallySizedBox(
        widthFactor: 0.3,
        child: UpdateDialog(version: version),
      ),
    );
  }
}

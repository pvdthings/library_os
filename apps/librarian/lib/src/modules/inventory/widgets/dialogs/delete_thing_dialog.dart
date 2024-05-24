import 'package:flutter/material.dart';
import 'package:librarian_app/src/widgets/dialogs/delete_dialog.dart';

String _buildDeleteDialogMessage(String thingName) {
  return 'Are you sure you want to delete $thingName?\nALL items belonging to this Thing will be deleted.\nThis action cannot be undone.';
}

Future<bool> showDeleteThingDialog(
  BuildContext context, {
  required String thingName,
}) async {
  return await showDeleteDialog(
    context,
    title: 'Delete Thing',
    message: _buildDeleteDialogMessage(thingName),
    deleteActionText: 'Delete ALL',
  );
}

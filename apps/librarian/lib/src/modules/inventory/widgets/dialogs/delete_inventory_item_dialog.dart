import 'package:flutter/material.dart';
import 'package:librarian_app/src/widgets/dialogs/delete_dialog.dart';

String _buildMessage(int itemNumber, String thingName) {
  return 'Are you sure you want to delete item #$itemNumber ($thingName)?\nThis action cannot be undone.';
}

Future<bool> showDeleteInventoryItemDialog(
  BuildContext context, {
  required int itemNumber,
  required String thingName,
}) async {
  return await showDeleteDialog(
    context,
    title: 'Delete Inventory Item',
    message: _buildMessage(itemNumber, thingName),
    deleteActionText: 'Delete Item',
  );
}

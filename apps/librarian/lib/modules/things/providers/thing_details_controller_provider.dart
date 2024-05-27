import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:librarian_app/modules/things/providers/selected_thing_provider.dart';
import 'package:librarian_app/modules/things/details/inventory/delete_inventory_item_dialog.dart';
import 'package:librarian_app/utils/media_query.dart';

import '../delete/delete_thing_dialog.dart';
import 'things_repository_provider.dart';

class ThingDetailsController {
  const ThingDetailsController({required this.ref});

  final Ref ref;

  Future<void> delete(BuildContext context) async {
    final selectedThing = ref.read(selectedThingProvider)!;
    final thingName = selectedThing.name;

    if (await showDeleteThingDialog(
      context,
      thingName: thingName,
    )) {
      ref.invalidate(selectedThingProvider);
      ref
          .read(thingsRepositoryProvider.notifier)
          .deleteThing(selectedThing.id)
          .whenComplete(() {
        if (isMobile(context)) {
          Navigator.of(context).pop();
        }
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('$thingName deleted'),
        ));
      });
    }
  }

  Future<void> deleteItem(
    BuildContext context, {
    required String id,
    required int itemNumber,
    required String thingName,
  }) async {
    if (await showDeleteInventoryItemDialog(
      context,
      itemNumber: itemNumber,
      thingName: thingName,
    )) {
      ref
          .read(thingsRepositoryProvider.notifier)
          .deleteItem(id)
          .whenComplete(() {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('#$itemNumber ($thingName) deleted'),
        ));
      });
    }
  }
}

final thingDetailsControllerProvider = Provider((ref) {
  return ThingDetailsController(ref: ref);
});

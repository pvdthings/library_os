import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:librarian_app/src/features/inventory/providers/edited_thing_details_providers.dart';
import 'package:librarian_app/src/features/inventory/providers/selected_thing_provider.dart';
import 'package:librarian_app/src/features/inventory/providers/things_provider.dart';

import '../../models/thing_model.dart';
import 'inventory_list.dart';

class InventoryListView extends ConsumerWidget {
  const InventoryListView({super.key, this.onTap});

  final void Function(ThingModel)? onTap;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final things = ref.watch(thingsProvider);
    final selectedThing = ref.watch(selectedThingProvider);

    return FutureBuilder(
      future: things,
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasData && snapshot.data!.isEmpty) {
          return const Center(child: Text('Nothing to see here'));
        }

        return InventoryList(
          things: snapshot.data!,
          selected: selectedThing,
          onTap: (thing) {
            ref.read(thingDetailsEditorProvider).discardChanges();
            ref.read(selectedThingProvider.notifier).state = thing;
            onTap?.call(thing);
          },
        );
      },
    );
  }
}

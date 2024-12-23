import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:librarian_app/modules/things/providers/edited_thing_details_providers.dart';
import 'package:librarian_app/modules/things/providers/selected_thing_provider.dart';
import 'package:librarian_app/modules/things/providers/things_provider.dart';
import 'package:librarian_app/widgets/skeleton.dart';

import '../../../../../core/api/models/thing_model.dart';
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
        if (snapshot.hasData && snapshot.data!.isEmpty) {
          return const Center(child: Text('Nothing to see here'));
        }

        return Skeleton(
          enabled: !snapshot.hasData,
          child: InventoryList(
            things: snapshot.data ?? [dummyThing, dummyThing, dummyThing],
            selected: selectedThing,
            onTap: (thing) {
              ref.read(thingDetailsEditorProvider).discardChanges();
              ref.read(selectedThingProvider.notifier).state = thing;
              onTap?.call(thing);
            },
          ),
        );
      },
    );
  }
}

final dummyThing = ThingModel(
  id: '',
  name: 'Something',
  hidden: false,
  stock: 1,
  available: 1,
);

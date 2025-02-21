import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:librarian_app/core/models/item_model.dart';
import 'package:librarian_app/modules/things/providers/things_repository_provider.dart';
import 'package:librarian_app/widgets/item_card.dart';

import 'connected_thing_search_field.dart';
import 'eye_protection_dialog.dart';
import 'suggested_things_dialog.dart';

Step buildItemsStep({
  required BuildContext context,
  required WidgetRef ref,
  required bool isActive,
  required bool didPromptForEyeProtection,
  required List<ItemModel> items,
  required void Function(ItemModel) onAddItem,
  required void Function(ItemModel) onRemoveItem,
  required void Function() onPromptForEyeProtection,
}) {
  return Step(
    title: const Text('Add Items'),
    subtitle: Text('${items.length} Item${items.length == 1 ? '' : 's'} Added'),
    content: Column(
      children: [
        ConnectedThingSearchField(
          controller: ThingSearchController(
            context: context,
            items: items,
            onMatchFound: (item) {
              onAddItem(item);

              if (item.eyeProtection && !didPromptForEyeProtection) {
                showDialog(
                  context: context,
                  builder: (_) => const EyeProtectionDialog(),
                );
                onPromptForEyeProtection();
              }

              if (item.linkedThingIds.isNotEmpty) {
                showDialog(
                  context: context,
                  builder: (_) => SuggestedThingsDialog(
                    thingName: item.name,
                    thingIds: item.linkedThingIds,
                  ),
                );
              }
            },
            repository: ref.read(thingsRepositoryProvider.notifier),
          ),
        ),
        const SizedBox(height: 16.0),
        GridView.count(
          crossAxisCount: 8,
          shrinkWrap: true,
          childAspectRatio: 1.0 / 1.2,
          children: items.map((item) {
            return ItemCard(
              number: item.number,
              name: item.name,
              imageUrl: item.imageUrls.firstOrNull,
              trailing: IconButton(
                icon: const Icon(Icons.remove_circle),
                onPressed: () => onRemoveItem(item),
                padding: EdgeInsets.zero,
                tooltip: 'Remove',
              ),
            );
          }).toList(),
        ),
      ],
    ),
    isActive: isActive,
  );
}

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:librarian_app/modules/things/providers/thing_details_controller_provider.dart';
import 'package:librarian_app/widgets/details_card/card_body.dart';
import 'package:librarian_app/widgets/details_card/details_card.dart';
import 'package:librarian_app/widgets/hint_text.dart';

import '../../../../core/api/models/item_model.dart';
import '../../../../widgets/details_card/card_header.dart';
import 'icons.dart';

class ItemsCard extends ConsumerWidget {
  const ItemsCard({
    super.key,
    required this.items,
    required this.availableItemsCount,
    required this.onAddItemsPressed,
    required this.onTap,
    required this.onToggleHidden,
  });

  final List<ItemModel> items;
  final int availableItemsCount;
  final void Function() onAddItemsPressed;
  final void Function(ItemModel item)? onTap;
  final void Function(String id, bool value)? onToggleHidden;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    Future<void> deleteItem(String id, int number, String name) async {
      await ref
          .read(thingDetailsControllerProvider)
          .deleteItem(context, id: id, itemNumber: number, thingName: name);
    }

    return DetailsCard(
      header: CardHeader(
        title: 'Inventory',
        trailing: TextButton.icon(
          onPressed: onAddItemsPressed,
          icon: const Icon(Icons.add),
          label: const Text('Add items'),
        ),
        children: [
          Row(
            children: [
              Text('Available: $availableItemsCount'),
              const SizedBox(width: 16),
              Text('Total: ${items.length}'),
            ],
          ),
          const SizedBox(height: 8),
        ],
      ),
      body: items.isNotEmpty
          ? ListView.separated(
              shrinkWrap: true,
              itemCount: items.length,
              itemBuilder: (context, index) {
                final item = items[index];

                return ListTile(
                  leading: getIcon(item),
                  onTap: () => onTap?.call(item),
                  title: Text('#${item.number}'),
                  subtitle: Text(item.brand ?? 'Generic'),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        onPressed: onToggleHidden != null
                            ? () => onToggleHidden!(item.id, !item.hidden)
                            : null,
                        tooltip: onToggleHidden == null
                            ? null
                            : item.hidden
                                ? 'Unhide'
                                : 'Hide',
                        icon: item.hidden
                            ? const Icon(Icons.visibility_off)
                            : const Icon(Icons.visibility),
                      ),
                      const SizedBox(width: 16),
                      IconButton(
                        onPressed: () => deleteItem(
                          item.id,
                          item.number,
                          item.name,
                        ),
                        tooltip: 'Delete',
                        icon: const Icon(
                          Icons.delete_outline,
                          color: Colors.red,
                        ),
                      ),
                    ],
                  ),
                );
              },
              separatorBuilder: (c, i) => const Divider(height: 1),
            )
          : const CardBody(
              child: HintText(
                  'Since this thing has no items, it will be shown on the Wish List.'),
            ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:librarian_app/modules/things/maintenance/providers/items.dart';
import 'package:librarian_app/utils/pluralize.dart';
import 'package:librarian_app/widgets/no_image.dart';
import 'package:skeletonizer/skeletonizer.dart';

import '../providers/item_details_orchestrator.dart';

class MaintenanceView extends ConsumerWidget {
  const MaintenanceView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return FutureBuilder(
      future: ref.watch(items),
      builder: (context, snapshot) {
        final damagedItems = snapshot.data?.damagedItems ?? [];
        final inRepairItems = snapshot.data?.inRepairItems ?? [];

        return Skeletonizer(
          enabled: snapshot.connectionState == ConnectionState.waiting,
          child: MaintenanceKanban(
            damagedItems: damagedItems,
            inRepairItems: inRepairItems,
            onTapItem: (item) {
              final orchestrator = ref.read(itemDetailsOrchestrator);
              orchestrator.openItem(
                context,
                item: item.item,
                hiddenLocked: item.isThingHidden ?? false,
              );
            },
          ),
        );
      },
    );
  }
}

class MaintenanceKanban extends StatelessWidget {
  const MaintenanceKanban({
    super.key,
    required this.damagedItems,
    required this.inRepairItems,
    this.onTapItem,
  });

  final List<RepairItemModel> damagedItems;
  final List<RepairItemModel> inRepairItems;
  final void Function(RepairItemModel)? onTapItem;

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      childAspectRatio: 1 / 1,
      crossAxisCount: 2,
      crossAxisSpacing: 4,
      children: [
        KanbanColumn(
          title: 'Damaged',
          items: damagedItems,
          onTapItem: onTapItem,
        ),
        KanbanColumn(
          title: 'In Repair',
          items: inRepairItems,
          onTapItem: onTapItem,
        ),
      ],
    );
  }
}

class KanbanColumn extends StatelessWidget {
  const KanbanColumn({
    super.key,
    required this.title,
    required this.items,
    this.onTapItem,
  });

  final String title;
  final List<RepairItemModel> items;
  final void Function(RepairItemModel)? onTapItem;

  @override
  Widget build(BuildContext context) {
    return Card.outlined(
      clipBehavior: Clip.antiAlias,
      color: Colors.transparent,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ListTile(
            title: Text(
              title,
              style: Theme.of(context).textTheme.titleLarge,
            ),
            trailing: Text(pluralize(items.length, 'Item')),
          ),
          const Divider(height: 1),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: GridView.count(
                crossAxisCount: 4,
                children: items.map((model) {
                  final item = model.item;
                  return ItemCard(
                    number: item.number,
                    imageUrl: item.imageUrls.firstOrNull,
                    notes: item.notes,
                    onTap: () => onTapItem?.call(model),
                  );
                }).toList(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class ItemCard extends StatelessWidget {
  const ItemCard({
    super.key,
    required this.number,
    this.imageUrl,
    this.notes,
    this.onTap,
  });

  final int number;
  final String? imageUrl;
  final String? notes;
  final void Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      color: Theme.of(context).colorScheme.secondaryContainer,
      child: InkWell(
        onTap: onTap,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: Container(
                color: Theme.of(context).canvasColor.withOpacity(0.5),
                child: imageUrl != null
                    ? Image.network(
                        imageUrl!,
                        fit: BoxFit.cover,
                      )
                    : const NoImage(),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '#$number',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  if (notes != null)
                    Tooltip(
                      message: '#$number: $notes',
                      textStyle: Theme.of(context)
                          .textTheme
                          .bodyLarge
                          ?.copyWith(color: Colors.black, fontSize: 18),
                      child: const Icon(Icons.info),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

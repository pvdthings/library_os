import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:librarian_app/core/api/models/item_model.dart';
import 'package:librarian_app/modules/things/maintenance/providers/items.dart';
import 'package:skeletonizer/skeletonizer.dart';

class MaintenanceView extends ConsumerWidget {
  const MaintenanceView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return FutureBuilder(
      future: ref.read(items),
      builder: (context, snapshot) {
        final damagedItems = snapshot.data?.damagedItems ?? [];
        final inRepairItems = snapshot.data?.inRepairItems ?? [];

        return Skeletonizer(
          enabled: snapshot.connectionState == ConnectionState.waiting,
          child: MaintenanceKanban(
            damagedItems: damagedItems,
            inRepairItems: inRepairItems,
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
  });

  final List<ItemModel> damagedItems;
  final List<ItemModel> inRepairItems;

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      childAspectRatio: 1 / 1,
      crossAxisCount: 2,
      crossAxisSpacing: 8,
      children: [
        KanbanColumn(
          title: 'Damaged',
          icon: const Icon(Icons.sentiment_very_dissatisfied),
          items: damagedItems,
        ),
        KanbanColumn(
          title: 'In Repair',
          icon: const Icon(Icons.healing),
          items: inRepairItems,
        ),
      ],
    );
  }
}

class KanbanColumn extends StatelessWidget {
  const KanbanColumn({
    super.key,
    required this.title,
    required this.icon,
    required this.items,
  });

  final String title;
  final Icon icon;
  final List<ItemModel> items;

  @override
  Widget build(BuildContext context) {
    return Card.outlined(
      clipBehavior: Clip.antiAlias,
      color: Colors.transparent,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ListTile(
            leading: icon,
            title: Text(
              title,
              style: Theme.of(context).textTheme.titleLarge,
            ),
          ),
          const Divider(height: 1),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: GridView.count(
                crossAxisCount: 4,
                children:
                    items.map((item) => ItemCard(number: item.number)).toList(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class ItemCard extends StatelessWidget {
  const ItemCard({super.key, required this.number});

  final int number;

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      color: Theme.of(context).colorScheme.secondaryContainer,
      child: InkWell(
        onTap: () {},
        child: Column(
          children: [
            Expanded(
              child: Image.network(
                'https://images.unsplash.com/photo-1575908393823-8e6ee16403d8?q=80&w=1548&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
                fit: BoxFit.cover,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                '#$number',
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

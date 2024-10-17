import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:librarian_app/core/api/models/item_model.dart';
import 'package:librarian_app/modules/things/providers/items.dart';

final items = Provider((ref) async {
  final items = await ref.watch(allItems);
  return ItemsViewModel(
    damagedItems: items.where((item) => item.condition == damaged).toList(),
    inRepairItems: items.where((item) => item.condition == inRepair).toList(),
  );
});

const damaged = 'Damaged';
const inRepair = 'In Repair';

class ItemsViewModel {
  const ItemsViewModel({
    required this.damagedItems,
    required this.inRepairItems,
  });

  final List<ItemModel> damagedItems;
  final List<ItemModel> inRepairItems;
}

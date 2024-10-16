import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:librarian_app/core/api/models/item_model.dart';
import 'package:librarian_app/modules/things/providers/items.dart';

final items = Provider((ref) async {
  final items = await ref.watch(allItems);
  final model = ItemsViewModel();
  model.damagedItems =
      items.where((item) => item.condition == 'Damaged').toList();
  model.inRepairItems =
      items.where((item) => item.condition == 'In Repair').toList();

  return model;
});

class ItemsViewModel {
  late List<ItemModel> damagedItems;
  late List<ItemModel> inRepairItems;
}

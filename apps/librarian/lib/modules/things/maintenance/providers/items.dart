import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:librarian_app/core/api/models/item_model.dart';
import 'package:librarian_app/modules/things/providers/items.dart';
import 'package:librarian_app/modules/things/providers/things_repository_provider.dart';

final items = Provider((ref) async {
  final items = await ref.watch(allItems);
  final things = (await ref.watch(thingsRepositoryProvider));
  final hiddenMap = {for (final e in things) e.id: e.hidden};

  return RepairItemsViewModel(
    damagedItems: items
        .where((item) => item.condition == damaged)
        .map((item) => RepairItemModel(
              item: item,
              isThingHidden: hiddenMap[item.thingId],
            ))
        .toList(),
    inRepairItems: items
        .where((item) => item.condition == inRepair)
        .map((item) => RepairItemModel(
              item: item,
              isThingHidden: hiddenMap[item.thingId],
            ))
        .toList(),
  );
});

const damaged = 'Damaged';
const inRepair = 'In Repair';

class RepairItemsViewModel {
  const RepairItemsViewModel({
    required this.damagedItems,
    required this.inRepairItems,
  });

  final List<RepairItemModel> damagedItems;
  final List<RepairItemModel> inRepairItems;
}

class RepairItemModel {
  const RepairItemModel({
    required this.item,
    this.isThingHidden,
  });

  final ItemModel item;
  final bool? isThingHidden;
}

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:librarian_app/core/data/inventory_repository.dart';
import 'package:librarian_app/core/models/thing_model.dart';

Provider<Future<List<ThingModel>>> findThingsByName(String name) {
  return Provider(
      (ref) async => await inventoryRepository.getThings(filter: name));
}

Provider<Future<List<ThingModel>>> findThingsByItem({required int number}) {
  return Provider((ref) async {
    final repository = inventoryRepository;
    final item = await repository.getItem(number: number);

    if (item == null) {
      return [];
    }

    return await repository.getThings(filter: item.name);
  });
}

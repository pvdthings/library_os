import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:librarian_app/core/data/inventory_repository.dart';
import 'package:librarian_app/providers/things.dart';

final allItems = Provider((ref) async {
  ref.watch(rootThingsProvider);
  return await inventoryRepository.getItems();
});

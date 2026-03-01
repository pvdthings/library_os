import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:librarian_app/core/data/inventory_repository.dart';

final rootThingsProvider = Provider((ref) async {
  return await inventoryRepository.getThings();
});

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:librarian_app/src/features/inventory/data/inventory_repository.dart';
import 'package:librarian_app/src/features/inventory/models/thing_model.dart';

final thingsRepositoryProvider =
    NotifierProvider<InventoryRepository, Future<List<ThingModel>>>(
        InventoryRepository.new);

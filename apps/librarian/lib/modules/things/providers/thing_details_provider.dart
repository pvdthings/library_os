import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:librarian_app/core/data/inventory_repository.dart';
import 'package:librarian_app/core/models/detailed_thing_model.dart';
import 'package:librarian_app/modules/things/providers/selected_thing_provider.dart';
import 'package:librarian_app/providers/things.dart';

final thingDetailsProvider = Provider<Future<DetailedThingModel?>>((ref) async {
  ref.watch(rootThingsProvider);
  final selectedThing = ref.watch(selectedThingProvider);
  if (selectedThing == null) {
    return null;
  }

  return await inventoryRepository.getThingDetails(id: selectedThing.id);
});

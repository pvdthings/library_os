import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:librarian_app/src/features/inventory/models/detailed_thing_model.dart';
import 'package:librarian_app/src/features/inventory/providers/selected_thing_provider.dart';
import 'package:librarian_app/src/features/inventory/providers/things_repository_provider.dart';

final thingDetailsProvider = Provider<Future<DetailedThingModel?>>((ref) async {
  ref.watch(thingsRepositoryProvider);
  final selectedThing = ref.watch(selectedThingProvider);
  if (selectedThing == null) {
    return null;
  }

  final repository = ref.read(thingsRepositoryProvider.notifier);
  return await repository.getThingDetails(id: selectedThing.id);
});

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:librarian_app/modules/things/providers/things_repository_provider.dart';

import '../../../core/api/models/thing_model.dart';

Provider<Future<List<ThingModel>>> findThingsByName(String name) {
  return Provider((ref) async => await ref
      .read(thingsRepositoryProvider.notifier)
      .getThings(filter: name));
}

Provider<Future<List<ThingModel>>> findThingsByItem({required int number}) {
  return Provider((ref) async {
    final repository = ref.read(thingsRepositoryProvider.notifier);
    final item = await repository.getItem(number: number);

    if (item == null) {
      return [];
    }

    return await repository.getThings(filter: item.name);
  });
}

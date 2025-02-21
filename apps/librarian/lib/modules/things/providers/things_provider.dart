import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:librarian_app/modules/things/providers/find_things.dart';
import 'package:librarian_app/modules/things/providers/things_filter_provider.dart';
import 'package:librarian_app/modules/things/providers/things_repository_provider.dart';

import '../../../core/models/thing_model.dart';

final thingsProvider = Provider<Future<List<ThingModel>>>((ref) async {
  final searchFilter = ref.watch(thingsFilterProvider);
  final things = await ref.watch(thingsRepositoryProvider);

  if (searchFilter == null || searchFilter.isEmpty) {
    return things;
  }

  if (searchFilter.startsWith('#')) {
    final itemNumber = int.tryParse(searchFilter.replaceFirst('#', ''));

    if (itemNumber != null) {
      return await ref.read(findThingsByItem(number: itemNumber));
    }
  }

  return things
      .where((t) => t.name.toLowerCase().contains(searchFilter.toLowerCase()))
      .toList();
});

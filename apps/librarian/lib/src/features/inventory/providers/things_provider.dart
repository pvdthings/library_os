import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:librarian_app/src/features/inventory/providers/things_filter_provider.dart';
import 'package:librarian_app/src/features/inventory/providers/things_repository_provider.dart';

import '../models/thing_model.dart';

final thingsProvider = Provider<Future<List<ThingModel>>>((ref) async {
  final searchFilter = ref.watch(thingsFilterProvider);
  final things = await ref.watch(thingsRepositoryProvider);

  if (searchFilter == null || searchFilter.isEmpty) {
    return things;
  }

  return things
      .where((t) => t.name.toLowerCase().contains(searchFilter.toLowerCase()))
      .toList();
});

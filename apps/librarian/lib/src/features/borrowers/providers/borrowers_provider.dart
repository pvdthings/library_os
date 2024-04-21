import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:librarian_app/src/features/borrowers/models/borrower_model.dart';
import 'package:librarian_app/src/features/borrowers/providers/borrowers_filter_provider.dart';
import 'package:librarian_app/src/features/borrowers/providers/borrowers_repository_provider.dart';

final borrowersProvider = Provider<Future<List<BorrowerModel>>>((ref) async {
  final searchFilter = ref.watch(borrowersFilterProvider);
  final borrowers = await ref.watch(borrowersRepositoryProvider);

  if (searchFilter == null) {
    return borrowers;
  }

  return borrowers
      .where((b) => b.name.toLowerCase().contains(searchFilter.toLowerCase()))
      .toList();
});

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:librarian_app/modules/borrowers/providers/borrowers_repository_provider.dart';
import 'package:librarian_app/modules/borrowers/providers/selected_borrower_provider.dart';

import '../../../core/api/models/borrower_model.dart';

final borrowerDetailsProvider = Provider<Future<BorrowerModel?>>((ref) async {
  ref.watch(borrowersRepositoryProvider);
  final selectedBorrower = ref.watch(selectedBorrowerProvider);
  if (selectedBorrower == null) {
    return null;
  }

  final borrowers = ref.read(borrowersRepositoryProvider.notifier);
  return await borrowers.getBorrowerDetails(selectedBorrower.id);
});

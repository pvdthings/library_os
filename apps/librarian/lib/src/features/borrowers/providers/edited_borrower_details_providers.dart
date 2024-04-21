import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:librarian_app/src/features/borrowers/providers/borrower_details_provider.dart';
import 'package:librarian_app/src/features/borrowers/providers/borrowers_repository_provider.dart';
import 'package:librarian_app/src/features/borrowers/providers/selected_borrower_provider.dart';
import 'package:librarian_app/src/features/loans/providers/loans_repository_provider.dart';

final phoneProvider = StateProvider<String?>((ref) => null);

final emailProvider = StateProvider<String?>((ref) => null);

final unsavedChangesProvider = Provider<bool>((ref) {
  return ref.watch(phoneProvider) != null || ref.watch(emailProvider) != null;
});

class BorrowerDetailsEditor {
  BorrowerDetailsEditor(this.ref);

  final ProviderRef ref;

  Future<void> save() async {
    await ref.read(borrowersRepositoryProvider.notifier).updateBorrower(
        ref.read(selectedBorrowerProvider)!.id,
        email: ref.read(emailProvider),
        phone: ref.read(phoneProvider));

    discardChanges();

    ref.invalidate(loansRepositoryProvider);
  }

  void discardChanges() {
    ref.read(phoneProvider.notifier).state = null;
    ref.read(emailProvider.notifier).state = null;

    // Causes borrower details to refresh from the API
    ref.invalidate(borrowerDetailsProvider);
  }
}

final borrowerDetailsEditorProvider =
    Provider((ref) => BorrowerDetailsEditor(ref));

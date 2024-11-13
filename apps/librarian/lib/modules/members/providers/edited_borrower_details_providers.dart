import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:librarian_app/core/data/borrowers_repository.dart';
import 'package:librarian_app/modules/members/providers/borrower_details_provider.dart';
import 'package:librarian_app/modules/members/providers/selected_borrower_provider.dart';
import 'package:librarian_app/providers/loans.dart';
import 'package:librarian_app/providers/members.dart';

final phoneProvider = StateProvider<String?>((ref) => null);

final emailProvider = StateProvider<String?>((ref) => null);

final unsavedChangesProvider = Provider<bool>((ref) {
  return ref.watch(phoneProvider) != null || ref.watch(emailProvider) != null;
});

class BorrowerDetailsEditor {
  BorrowerDetailsEditor(this.ref);

  final ProviderRef ref;

  Future<void> save() async {
    await BorrowersRepository().updateBorrower(
        ref.read(selectedBorrowerProvider)!.id,
        email: ref.read(emailProvider),
        phone: ref.read(phoneProvider));

    discardChanges();

    ref.invalidate(loansProvider);
    ref.invalidate(membersProvider);
  }

  void discardChanges() {
    ref.read(phoneProvider.notifier).state = null;
    ref.read(emailProvider.notifier).state = null;

    // Causes borrower details to refresh from the API
    ref.invalidate(memberDetailsProvider);
  }
}

final borrowerDetailsEditorProvider =
    Provider((ref) => BorrowerDetailsEditor(ref));

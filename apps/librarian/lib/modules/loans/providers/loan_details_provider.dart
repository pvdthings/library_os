import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:librarian_app/core/api/models/loan_details_model.dart';
import 'package:librarian_app/core/data/loans_repository.dart';
import 'package:librarian_app/modules/loans/providers/selected_loan_provider.dart';
import 'package:librarian_app/providers/loans.dart';
import 'package:librarian_app/providers/members.dart';

final loanDetailsProvider = FutureProvider((ref) async {
  ref.watch(loansProvider);
  final selectedLoan = ref.watch(selectedLoanProvider);
  if (selectedLoan == null) {
    return LoanDetailsViewModel();
  }

  final details = await LoansRepository().getLoan(
    id: selectedLoan.id,
    thingId: selectedLoan.thing.id,
  );

  return LoanDetailsViewModel(
    loan: details,
    onSave: (dueDate, notes) {
      LoansRepository()
          .updateLoan(
              loanId: details!.id,
              thingId: details.thing.id,
              dueBackDate: dueDate,
              notes: notes)
          .then((_) => ref.invalidate(loansProvider));
    },
    onCheckIn: () {
      LoansRepository()
          .closeLoan(loanId: details!.id, thingId: details.thing.id)
          .then((_) {
        ref.invalidate(loansProvider);
        ref.invalidate(selectedLoanProvider);
        ref.invalidate(membersProvider);
      });
    },
  );
});

class LoanDetailsViewModel {
  LoanDetailsViewModel({
    this.loan,
    this.onSave,
    this.onCheckIn,
  });

  final LoanDetailsModel? loan;
  final void Function(DateTime, String?)? onSave;
  final void Function()? onCheckIn;
}

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:librarian_app/core/models/member_model.dart';
import 'package:librarian_app/core/models/loan_details_model.dart';
import 'package:librarian_app/core/data/borrowers_repository.dart';
import 'package:librarian_app/core/data/loans_repository.dart';
import 'package:librarian_app/modules/loans/providers/selected_loan_provider.dart';
import 'package:librarian_app/providers/loans.dart';

final loanDetailsProvider = FutureProvider((ref) async {
  ref.watch(loansProvider);
  final selectedLoan = ref.watch(selectedLoanProvider);
  if (selectedLoan == null) {
    return LoanDetailsViewModel();
  }

  final [details, memberDetails] = await Future.wait([
    LoansRepository().getLoan(
      id: selectedLoan.id,
      itemId: selectedLoan.thing.id,
    ),
    BorrowersRepository().getBorrowerDetails(selectedLoan.borrower.id),
  ]);

  return LoanDetailsViewModel(
    loan: details as LoanDetailsModel,
    member: memberDetails as MemberModel,
    onSave: (dueDate, notes) {
      LoansRepository()
          .updateLoan(
              parentLoanId: details.parentLoanId,
              dueBackDate: dueDate,
              notes: notes)
          .then((_) => ref.invalidate(loansProvider));
    },
    onCheckIn: () {
      LoansRepository().closeLoan(details.id).then((_) {
        ref.invalidate(loansProvider);
        ref.invalidate(selectedLoanProvider);
      });
    },
  );
});

class LoanDetailsViewModel {
  LoanDetailsViewModel({
    this.loan,
    this.member,
    this.onSave,
    this.onCheckIn,
  });

  final LoanDetailsModel? loan;
  final MemberModel? member;
  final void Function(DateTime, String?)? onSave;
  final void Function()? onCheckIn;
}

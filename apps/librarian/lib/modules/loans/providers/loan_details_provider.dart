import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:librarian_app/modules/loans/providers/loans_repository_provider.dart';
import 'package:librarian_app/modules/loans/providers/selected_loan_provider.dart';

import '../../../core/api/models/loan_details_model.dart';

final loanDetailsProvider = Provider<Future<LoanDetailsModel?>>((ref) async {
  ref.watch(loansRepositoryProvider);
  final selectedLoan = ref.watch(selectedLoanProvider);
  if (selectedLoan == null) {
    return null;
  }

  return await ref
      .read(loansRepositoryProvider.notifier)
      .getLoan(id: selectedLoan.id, thingId: selectedLoan.thing.id);
});

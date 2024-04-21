import 'package:collection/collection.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'loans_repository_provider.dart';
import 'selected_loan_provider.dart';

class LoansController {
  LoansController({required this.ref});

  final Ref ref;

  Future<bool> openLoan({
    required String borrowerId,
    required List<String> thingIds,
    required DateTime dueDate,
  }) async {
    final loanId = await ref.read(loansRepositoryProvider.notifier).openLoan(
        borrowerId: borrowerId, thingIds: thingIds, dueBackDate: dueDate);

    final loan = (await ref.read(loansRepositoryProvider))
        .firstWhereOrNull((l) => l.id == loanId);
    ref.read(selectedLoanProvider.notifier).state = loan;

    return loan != null;
  }
}

final loansControllerProvider = Provider((ref) => LoansController(ref: ref));

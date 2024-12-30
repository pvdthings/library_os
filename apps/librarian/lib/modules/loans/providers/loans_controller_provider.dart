import 'package:collection/collection.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:librarian_app/core/api/models/item_model.dart';
import 'package:librarian_app/core/data/loans_repository.dart';
import 'package:librarian_app/providers/loans.dart';

import 'selected_loan_provider.dart';

class LoansController {
  LoansController({required this.ref});

  final Ref ref;

  Future<bool> openLoan({
    required String borrowerId,
    required List<ItemModel> items,
    required DateTime dueDate,
  }) async {
    final loanId = await LoansRepository()
        .openLoan(borrowerId: borrowerId, items: items, dueBackDate: dueDate);

    final loan = (await ref.refresh(loansProvider))
        .firstWhereOrNull((l) => l.id == loanId);
    ref.read(selectedLoanProvider.notifier).state = loan;

    return loan != null;
  }
}

final loansControllerProvider = Provider((ref) => LoansController(ref: ref));

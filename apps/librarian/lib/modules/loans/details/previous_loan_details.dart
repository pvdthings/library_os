import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:librarian_app/core/data/loans_repository.dart';

import 'loan_details.dart';

class PreviousLoanDetails extends ConsumerWidget {
  const PreviousLoanDetails({
    super.key,
    required this.loanId,
    required this.itemId,
  });

  final String loanId;
  final String itemId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return FutureBuilder(
      future: LoansRepository().getLoan(id: loanId, thingId: itemId),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          final previousLoan = snapshot.data!;
          return LoanDetails(
            borrower: previousLoan.borrower,
            things: [previousLoan.item],
            checkedOutDate: previousLoan.checkedOutDate,
            dueDate: previousLoan.dueDate,
          );
        }

        return const Center(
          child: CircularProgressIndicator(),
        );
      },
    );
  }
}

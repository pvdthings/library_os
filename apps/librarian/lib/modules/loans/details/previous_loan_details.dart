import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/loans_repository_provider.dart';
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
      future: ref
          .read(loansRepositoryProvider.notifier)
          .getLoan(id: loanId, thingId: itemId),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          final previousLoan = snapshot.data!;
          return LoanDetails(
            borrower: previousLoan.borrower,
            things: [previousLoan.thing],
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

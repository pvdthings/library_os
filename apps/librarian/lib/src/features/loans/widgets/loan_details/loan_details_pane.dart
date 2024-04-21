import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:librarian_app/src/features/loans/providers/loan_details_provider.dart';
import 'package:librarian_app/src/features/loans/providers/selected_loan_provider.dart';
import 'package:librarian_app/src/features/loans/widgets/loan_details/loan_details_header.dart';

import '../../providers/loans_repository_provider.dart';
import 'loan_details.dart';

class LoanDetailsPane extends ConsumerWidget {
  const LoanDetailsPane({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedLoan = ref.read(selectedLoanProvider);
    final loanDetailsFuture = ref.watch(loanDetailsProvider);

    return Card(
      clipBehavior: Clip.antiAlias,
      child: selectedLoan == null
          ? const Center(child: Text('Loan Details'))
          : FutureBuilder(
              future: loanDetailsFuture,
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return Center(child: Text(snapshot.error.toString()));
                }

                if (!snapshot.hasData) {
                  return const Center(child: CircularProgressIndicator());
                }

                final loanDetails = snapshot.data!;

                return Column(
                  children: [
                    LoanDetailsHeader(
                      loan: loanDetails,
                      onSave: (dueDate, notes) {
                        ref.read(loansRepositoryProvider.notifier).updateLoan(
                            loanId: selectedLoan.id,
                            thingId: selectedLoan.thing.id,
                            dueBackDate: dueDate,
                            notes: notes);
                      },
                      onCheckIn: () {
                        ref
                            .read(loansRepositoryProvider.notifier)
                            .closeLoan(
                              loanId: selectedLoan.id,
                              thingId: selectedLoan.thing.id,
                            )
                            .then((_) {
                          ref.read(selectedLoanProvider.notifier).state = null;
                        });
                      },
                    ),
                    Expanded(
                      child: SingleChildScrollView(
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: LoanDetails(
                            borrower: loanDetails.borrower,
                            things: [loanDetails.thing],
                            notes: loanDetails.notes,
                            checkedOutDate: loanDetails.checkedOutDate,
                            dueDate: loanDetails.dueDate,
                            isOverdue: loanDetails.isOverdue,
                          ),
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
    );
  }
}

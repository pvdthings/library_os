import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:librarian_app/core/models/member_model.dart';
import 'package:librarian_app/core/models/loan_model.dart';
import 'package:librarian_app/core/models/item_summary_model.dart';
import 'package:librarian_app/modules/loans/providers/loans_provider.dart';
import 'package:librarian_app/modules/loans/providers/selected_loan_provider.dart';
import 'package:librarian_app/widgets/skeleton.dart';

import 'loans_list.dart';

class LoansListView extends ConsumerWidget {
  const LoansListView({
    super.key,
    this.onTap,
  });

  final void Function(LoanModel)? onTap;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final filteredLoans = ref.watch(loansListProvider);
    return filteredLoans.when(
      data: (model) {
        if (model.loans.isEmpty) {
          return const Center(child: Text('No results found'));
        }

        return LoansList(
          loans: model.loans,
          selected: ref.watch(selectedLoanProvider),
          onTap: (loan) {
            ref.read(selectedLoanProvider.notifier).state = loan;
            onTap?.call(loan);
          },
        );
      },
      loading: () {
        return Skeleton(
          enabled: true,
          child: LoansList(
            loans: [
              dummyLoan,
              dummyLoan,
              dummyLoan,
            ],
          ),
        );
      },
      error: (error, stackTrace) {
        return Center(child: Text(stackTrace.toString()));
      },
    );
  }
}

final dummyLoan = LoanModel(
  id: '',
  number: 0,
  thing: const ItemSummaryModel(
    id: '',
    name: 'Thing',
    number: 0,
    images: [],
  ),
  borrower: const MemberModel(
    id: '',
    name: 'Borrower Borrowersson',
    issues: [],
  ),
  checkedOutDate: DateTime.now(),
  dueDate: DateTime.now(),
);

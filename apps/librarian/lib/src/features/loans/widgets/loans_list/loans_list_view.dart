import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:librarian_app/src/features/loans/providers/loans_provider.dart';
import 'package:librarian_app/src/features/loans/providers/selected_loan_provider.dart';

import '../../models/loan_model.dart';
import 'loans_list.dart';

class LoansListView extends ConsumerWidget {
  const LoansListView({
    super.key,
    this.onTap,
  });

  final void Function(LoanModel)? onTap;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final filteredLoans = ref.watch(loansProvider);

    return FutureBuilder(
      future: filteredLoans,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Center(child: Text(snapshot.error.toString()));
        }

        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasData && snapshot.data!.isEmpty) {
          return const Center(child: Text('No results found'));
        }

        return LoansList(
          loans: snapshot.data!,
          selected: ref.watch(selectedLoanProvider),
          onTap: (loan) {
            ref.read(selectedLoanProvider.notifier).state = loan;
            onTap?.call(loan);
          },
        );
      },
    );
  }
}

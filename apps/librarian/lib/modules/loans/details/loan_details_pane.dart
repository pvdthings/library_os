import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:librarian_app/core/api/models/borrower_model.dart';
import 'package:librarian_app/core/api/models/loan_details_model.dart';
import 'package:librarian_app/core/api/models/thing_summary_model.dart';
import 'package:librarian_app/modules/loans/providers/loan_details_provider.dart';
import 'package:librarian_app/modules/loans/details/loan_details_header.dart';
import 'package:librarian_app/widgets/skeleton.dart';

import 'loan_details.dart';

class LoanDetailsPane extends ConsumerWidget {
  const LoanDetailsPane({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final loanDetailsAsync = ref.watch(loanDetailsProvider);

    return Card(
      color: Theme.of(context).colorScheme.surfaceContainerHigh,
      clipBehavior: Clip.antiAlias,
      child: loanDetailsAsync.when(
        data: (model) {
          if (model.loan == null) {
            return const Center(child: Text('Loan Details'));
          }

          final loan = model.loan!;

          return _Details(
            loading: false,
            details: loan,
            onSave: (dueDate, notes) {
              model.onSave?.call(dueDate, notes);
            },
            onCheckIn: model.onCheckIn ?? () {},
          );
        },
        loading: () {
          return _Details(
            loading: true,
            details: dummyDetails,
            onSave: (_, __) {},
            onCheckIn: () {},
          );
        },
        error: (error, stackTrace) {
          return Center(child: Text(stackTrace.toString()));
        },
      ),
    );
  }
}

class _Details extends StatelessWidget {
  const _Details({
    required this.details,
    required this.onSave,
    required this.onCheckIn,
    this.loading = false,
  });

  final bool loading;
  final LoanDetailsModel details;
  final void Function(DateTime, String?)? onSave;
  final void Function()? onCheckIn;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        LoanDetailsHeader(
          loading: loading,
          loan: details,
          onSave: onSave,
          onCheckIn: onCheckIn,
        ),
        Expanded(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Skeleton(
                enabled: loading,
                child: LoanDetails(
                  borrower: details.borrower,
                  things: [details.thing],
                  notes: details.notes,
                  checkedOutDate: details.checkedOutDate,
                  dueDate: details.dueDate,
                  isOverdue: details.isOverdue,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

final dummyDetails = LoanDetailsModel(
  id: '',
  number: 1000,
  thing: const ThingSummaryModel(
    id: '',
    name: 'Something',
    number: 0,
    images: [],
  ),
  borrower: const BorrowerModel(
    id: '',
    name: 'Jane Smith',
    issues: [],
  ),
  checkedOutDate: DateTime.now(),
  dueDate: DateTime.now(),
  remindersSent: 0,
);

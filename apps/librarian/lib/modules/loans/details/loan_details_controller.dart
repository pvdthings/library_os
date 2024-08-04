import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:librarian_app/core/api/api.dart' as api;
import 'package:librarian_app/modules/loans/providers/loans_repository_provider.dart';
import 'package:librarian_app/widgets/dialogs/general_dialog.dart';

import 'previous_loan_details.dart';

class LoanDetailsController {
  const LoanDetailsController({
    required this.context,
    required this.ref,
  });

  final BuildContext context;
  final WidgetRef ref;

  void viewPreviousLoan({
    required String id,
    required String itemId,
  }) {
    showDialog(
      context: context,
      builder: (context) {
        return GeneralDialog(
          title: 'Previous Loan',
          content: SingleChildScrollView(
            controller: ScrollController(),
            child: PreviousLoanDetails(
              loanId: id,
              itemId: itemId,
            ),
          ),
        );
      },
    );
  }

  Future<void> sendReminderEmail({required int loanNumber}) async {
    api.sendReminderEmail(loanNumber: loanNumber).then((value) {
      ref.invalidate(loansRepositoryProvider);

      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Email was sent')));
    }, onError: (error) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Email could not be sent')));
    });
  }
}

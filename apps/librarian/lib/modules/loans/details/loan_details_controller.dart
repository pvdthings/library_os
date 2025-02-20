import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:librarian_app/core/api/api.dart' as api;
import 'package:librarian_app/core/api/models/loan_details_model.dart';
import 'package:librarian_app/modules/loans/details/thing_number.dart';
import 'package:librarian_app/providers/loans.dart';
import 'package:librarian_app/widgets/dialogs/general_dialog.dart';

import 'previous_loan_details.dart';

class LoanDetailsController {
  const LoanDetailsController({
    required this.context,
    required this.ref,
  });

  final BuildContext context;
  final WidgetRef ref;

  void viewPreviousLoan(LoanDetailsModel loan) {
    showDialog(
      context: context,
      builder: (context) {
        return GeneralDialog(
          titlePrefix: ThingNumber(number: loan.item.number),
          title: 'Previous Loan',
          content: PreviousLoanDetails(
            loanId: loan.id,
            itemId: loan.item.id,
          ),
        );
      },
    );
  }

  Future<void> sendReminderEmail({required int loanNumber}) async {
    api.sendReminderEmail(loanNumber: loanNumber).then((value) {
      ref.invalidate(loansProvider);

      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Email was sent')));
    }, onError: (error) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Email could not be sent')));
    });
  }
}

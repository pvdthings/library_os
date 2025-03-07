import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:librarian_app/widgets/panes/pane_header.dart';
import 'package:librarian_app/modules/loans/email/send_email_dialog.dart';
import 'package:librarian_app/modules/loans/details/loan_details_controller.dart';

import '../../../core/api/models/loan_details_model.dart';
import '../checkin/checkin_dialog.dart';
import '../edit/edit_loan_dialog.dart';
import 'thing_number.dart';

class LoanDetailsHeader extends ConsumerWidget {
  const LoanDetailsHeader({
    super.key,
    required this.loading,
    required this.loan,
    required this.onSave,
    required this.onCheckIn,
  });

  final bool loading;
  final LoanDetailsModel loan;
  final void Function(DateTime dueDate, String? notes)? onSave;
  final void Function()? onCheckIn;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = LoanDetailsController(context: context, ref: ref);

    return PaneHeader(
      child: Row(
        children: [
          if (!loading) ...[
            ThingNumber(number: loan.thing.number),
            const SizedBox(width: 16),
          ],
          Expanded(
            child: Container(
              margin: const EdgeInsets.only(right: 16.0),
              child: Text(
                loading ? '' : loan.thing.name,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(fontSize: 24),
              ),
            ),
          ),
          Row(
            children: [
              IconButton(
                onPressed: loading
                    ? null
                    : () {
                        showDialog(
                          context: context,
                          builder: (context) {
                            return EditLoanDialog(
                              dueDate: loan.dueDate,
                              notes: loan.notes,
                              onSavePressed: onSave,
                            );
                          },
                        );
                      },
                icon: const Icon(Icons.edit),
                tooltip: 'Edit',
              ),
              SizedBox(
                height: 24,
                width: 24,
                child: VerticalDivider(
                  color: Colors.white.withOpacity(0.3),
                ),
              ),
              IconButton(
                onPressed: !loading && loan.thing.lastLoanId != null
                    ? () {
                        controller.viewPreviousLoan(
                          id: loan.thing.lastLoanId!,
                          itemId: loan.thing.id,
                          itemNumber: loan.thing.number,
                        );
                      }
                    : null,
                tooltip: 'Previous Loan',
                icon: const Icon(Icons.history),
              ),
              const SizedBox(width: 4),
              IconButton(
                onPressed: !loading && loan.borrower.email != null
                    ? () {
                        showDialog(
                          context: context,
                          builder: (context) {
                            return SendEmailDialog(
                              recipientName: loan.borrower.name,
                              remindersSent: loan.remindersSent,
                              onSend: () async {
                                await controller.sendReminderEmail(
                                    loanNumber: loan.number);
                              },
                            );
                          },
                        );
                      }
                    : null,
                tooltip: 'Send Email',
                icon: const Icon(Icons.email),
              ),
              const SizedBox(width: 4),
              IconButton(
                onPressed: !loading && onCheckIn != null
                    ? () {
                        showDialog(
                          context: context,
                          builder: (context) {
                            return CheckinDialog(
                              thingNumber: loan.thing.number,
                              onCheckin: () async {
                                await Future(onCheckIn!);
                              },
                            );
                          },
                        );
                      }
                    : null,
                tooltip: 'Check in',
                icon: const Icon(Icons.library_add_check),
              ),
            ],
          )
        ],
      ),
    );
  }
}

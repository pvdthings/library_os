import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:librarian_app/src/features/dashboard/widgets/panes/pane_header.widget.dart';
import 'package:librarian_app/src/features/loans/widgets/email/send_email_dialog.dart';
import 'package:librarian_app/src/features/loans/widgets/loan_details/loan_details_controller.dart';

import '../../models/loan_details_model.dart';
import '../checkin/checkin_dialog.dart';
import '../edit/edit_loan_dialog.dart';
import 'thing_number.dart';

class LoanDetailsHeader extends ConsumerWidget {
  const LoanDetailsHeader({
    super.key,
    required this.loan,
    required this.onSave,
    required this.onCheckIn,
  });

  final LoanDetailsModel loan;
  final void Function(DateTime dueDate, String? notes) onSave;
  final void Function() onCheckIn;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = LoanDetailsController(context: context, ref: ref);

    return PaneHeader(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              ThingNumber(number: loan.thing.number),
              const SizedBox(width: 16),
              Text(
                loan.thing.name,
                style: const TextStyle(fontSize: 24),
              ),
            ],
          ),
          Row(
            children: [
              IconButton(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (context) {
                      return EditLoanDialog(
                        dueDate: loan.dueDate,
                        notes: loan.notes,
                        onSavePressed: (newDueDate, notes) {
                          onSave(newDueDate, notes);
                        },
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
                onPressed: loan.borrower.email != null
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
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (context) {
                      return CheckinDialog(
                        thingNumber: loan.thing.number,
                        onCheckin: () async {
                          await Future(onCheckIn);
                        },
                      );
                    },
                  );
                },
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

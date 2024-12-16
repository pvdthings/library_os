import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:librarian_app/modules/things/details/inventory_details_page.dart';
import 'package:librarian_app/modules/loans/providers/loan_details_provider.dart';
import 'package:librarian_app/modules/loans/checkin/checkin_dialog.dart';
import 'package:librarian_app/modules/loans/email/send_email_dialog.dart';
import 'package:librarian_app/modules/loans/details/loan_details.dart';
import 'package:librarian_app/modules/loans/details/loan_details_controller.dart';

import '../edit/edit_loan_dialog.dart';

class LoanDetailsPage extends ConsumerWidget {
  const LoanDetailsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final loanDetailsAsync = ref.watch(loanDetailsProvider);

    return loanDetailsAsync.when(
      data: (model) {
        final loan = model.loan!;
        return Scaffold(
          appBar: AppBar(
            title: Text('#${loan.thing.number}'),
            centerTitle: true,
            actions: [
              IconButton(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (context) {
                      return EditLoanDialog(
                        dueDate: loan.dueDate,
                        notes: loan.notes,
                        onSavePressed: (newDueDate, notes) {
                          model.onSave?.call(newDueDate, notes);
                        },
                      );
                    },
                  );
                },
                icon: const Icon(Icons.edit),
                tooltip: 'Edit',
              ),
              const SizedBox(width: 8),
              IconButton(
                onPressed: loan.borrower.email != null
                    ? () {
                        showDialog(
                          context: context,
                          builder: (context) {
                            final controller = LoanDetailsController(
                                context: context, ref: ref);

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
                icon: const Icon(Icons.email),
                tooltip: 'Send Email',
              ),
              const SizedBox(width: 8),
            ],
          ),
          body: LoanDetails(
            borrower: model.member,
            things: [loan.thing],
            checkedOutDate: loan.checkedOutDate,
            dueDate: loan.dueDate,
            isOverdue: loan.isOverdue,
            notes: loan.notes,
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              showDialog<bool>(
                context: context,
                builder: (context) {
                  return CheckinDialog(
                    thingNumber: loan.thing.number,
                    onCheckin: () async {
                      model.onCheckIn?.call();
                    },
                  );
                },
              ).then((result) {
                if (result ?? false) {
                  Navigator.of(context).pop();
                }
              });
            },
            tooltip: 'Check in',
            child: const Icon(Icons.check_rounded),
          ),
        );
      },
      loading: () {
        return loadingScaffold;
      },
      error: (error, stackTrace) {
        return errorScaffold(stackTrace.toString());
      },
    );
  }
}

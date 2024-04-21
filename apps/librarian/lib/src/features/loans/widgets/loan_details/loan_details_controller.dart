import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:librarian_app/src/api/lending_api.dart';
import 'package:librarian_app/src/features/loans/providers/loans_repository_provider.dart';

class LoanDetailsController {
  const LoanDetailsController({
    required this.context,
    required this.ref,
  });

  final BuildContext context;
  final WidgetRef ref;

  Future<void> sendReminderEmail({required int loanNumber}) async {
    LendingApi.sendReminderEmail(loanNumber: loanNumber).then((value) {
      ref.invalidate(loansRepositoryProvider);

      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Email was sent')));
    }, onError: (error) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Email could not be sent')));
    });
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:librarian_app/modules/borrowers/providers/borrowers_repository_provider.dart';

import '../../../core/api/models/issue_model.dart';
import '../payments/dues_dialog.dart';

class BorrowerIssues extends ConsumerWidget {
  final String borrowerId;
  final List<Issue> issues;
  final void Function(bool success) onRecordCashPayment;

  const BorrowerIssues({
    super.key,
    required this.borrowerId,
    required this.issues,
    required this.onRecordCashPayment,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ListView(
      shrinkWrap: true,
      children: [
        _IssueTile(
          duesNotPaidIssue,
          isOk: !issues.contains(duesNotPaidIssue),
          trailing: _PayDuesButton(
            borrowerId: borrowerId,
            onRecordCashPayment: onRecordCashPayment,
          ),
        ),
        _IssueTile(
          overdueLoanIssue,
          isOk: !issues.contains(overdueLoanIssue),
        ),
        _IssueTile(
          needsLiabilityWaiverIssue,
          isOk: !issues.contains(needsLiabilityWaiverIssue),
        ),
        _IssueTile(
          suspendedIssue,
          isOk: !issues.contains(suspendedIssue),
        ),
      ],
    );
  }
}

class _IssueTile extends StatelessWidget {
  const _IssueTile(
    this.issue, {
    this.isOk = false,
    this.trailing,
  });

  final Issue issue;
  final bool isOk;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    if (isOk) {
      return ListTile(
        leading: const Icon(
          Icons.check,
          color: Colors.green,
        ),
        title: Text(issue.okTitle),
        subtitle:
            issue.okExplanation != null ? Text(issue.okExplanation!) : null,
      );
    }

    return ListTile(
      leading: const Icon(
        Icons.warning_rounded,
        color: Colors.amber,
      ),
      title: Text(issue.title),
      subtitle: issue.explanation != null ? Text(issue.explanation!) : null,
      trailing: trailing,
    );
  }
}

class _PayDuesButton extends ConsumerWidget {
  const _PayDuesButton({
    required this.borrowerId,
    required this.onRecordCashPayment,
  });

  final String borrowerId;
  final void Function(bool success) onRecordCashPayment;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    const issue = duesNotPaidIssue;
    return OutlinedButton(
      onPressed: () {
        showDialog(
          context: context,
          builder: (context) {
            return DuesNotPaidDialog(
              instructions: issue.instructions!,
              imageUrl: issue.graphicUrl,
              onConfirmPayment: (cash) async {
                final result = await ref
                    .read(borrowersRepositoryProvider.notifier)
                    .recordPayment(borrowerId: borrowerId, cash: cash);

                onRecordCashPayment(result);
              },
            );
          },
        );
      },
      child: const Text('Pay Dues'),
    );
  }
}

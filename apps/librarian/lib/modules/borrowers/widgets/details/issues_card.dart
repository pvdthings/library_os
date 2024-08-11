import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:librarian_app/modules/borrowers/models/issue_model.dart';
import 'package:librarian_app/modules/borrowers/widgets/details/borrower_issues.dart';
import 'package:librarian_app/widgets/details_card/card_header.dart';
import 'package:librarian_app/widgets/details_card/details_card.dart';

class IssuesCard extends ConsumerWidget {
  const IssuesCard({
    super.key,
    required this.borrowerId,
    required this.issues,
  });

  final String borrowerId;
  final List<Issue> issues;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return DetailsCard(
      header: const CardHeader(title: 'Issues'),
      showDivider: issues.isNotEmpty,
      body: Padding(
        padding: const EdgeInsets.only(bottom: 8.0),
        child: BorrowerIssues(
          borrowerId: borrowerId,
          issues: issues,
          onRecordCashPayment: (success) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content:
                    Text(success ? 'Success!' : 'Failed to record payment'),
              ),
            );
          },
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:librarian_app/src/features/borrowers/widgets/borrower_details/borrower_issues.dart';
import 'package:librarian_app/src/widgets/details_card/card_header.dart';
import 'package:librarian_app/src/widgets/details_card/details_card.dart';

import '../../providers/selected_borrower_provider.dart';

class IssuesCard extends ConsumerWidget {
  const IssuesCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final borrower = ref.watch(selectedBorrowerProvider)!;

    return DetailsCard(
      header: const CardHeader(title: 'Issues'),
      showDivider: borrower.issues.isNotEmpty,
      body: Padding(
        padding: const EdgeInsets.only(bottom: 8.0),
        child: BorrowerIssues(
          borrowerId: borrower.id,
          issues: borrower.issues,
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

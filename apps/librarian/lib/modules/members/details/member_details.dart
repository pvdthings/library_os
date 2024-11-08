import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:librarian_app/modules/members/details/contact_card.dart';
import 'package:librarian_app/modules/members/providers/borrower_details_provider.dart';
import 'package:librarian_app/modules/members/details/issues_card.dart';
import 'package:librarian_app/modules/members/details/payments_card.dart';

class MemberDetails extends ConsumerWidget {
  const MemberDetails({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final borrowerDetails = ref.watch(borrowerDetailsProvider);

    return FutureBuilder(
      future: borrowerDetails,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return Center(child: Text(snapshot.error.toString()));
        }

        final borrower = snapshot.data!;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ContactCard(
              name: borrower.name,
              email: borrower.email,
              phone: borrower.phone,
            ),
            const SizedBox(height: 32),
            IssuesCard(
              borrowerId: borrower.id,
              issues: borrower.issues,
            ),
            const SizedBox(height: 32),
            const PaymentsCard(),
          ],
        );
      },
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:librarian_app/src/features/borrowers/providers/borrower_details_provider.dart';
import 'package:librarian_app/src/features/borrowers/providers/edited_borrower_details_providers.dart';
import 'package:librarian_app/src/features/borrowers/widgets/borrower_details/issues_card.dart';
import 'package:librarian_app/src/features/borrowers/widgets/borrower_details/payments_card.dart';

class BorrowerDetails extends ConsumerWidget {
  const BorrowerDetails({super.key});

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
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: TextEditingController(text: borrower.name),
              readOnly: true,
              decoration: const InputDecoration(
                icon: Icon(Icons.person_rounded),
                labelText: 'Name',
                border: OutlineInputBorder(),
                constraints: BoxConstraints(maxWidth: 500),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: TextEditingController(
                text: ref.read(emailProvider) ?? borrower.email,
              ),
              decoration: const InputDecoration(
                icon: Icon(Icons.email_rounded),
                labelText: 'Email',
                border: OutlineInputBorder(),
                constraints: BoxConstraints(maxWidth: 500),
              ),
              onChanged: (value) {
                ref.read(emailProvider.notifier).state = value;
              },
            ),
            const SizedBox(height: 16),
            TextField(
              controller: TextEditingController(
                text: ref.read(phoneProvider) ?? borrower.phone,
              ),
              decoration: const InputDecoration(
                icon: Icon(Icons.phone_rounded),
                labelText: 'Phone',
                border: OutlineInputBorder(),
                constraints: BoxConstraints(maxWidth: 500),
              ),
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
              ],
              keyboardType: TextInputType.phone,
              onChanged: (value) {
                ref.read(phoneProvider.notifier).state = value;
              },
            ),
            const SizedBox(height: 32),
            const IssuesCard(),
            const SizedBox(height: 32),
            const PaymentsCard(),
          ],
        );
      },
    );
  }
}

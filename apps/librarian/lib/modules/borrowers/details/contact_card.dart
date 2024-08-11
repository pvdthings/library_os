import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:librarian_app/widgets/details_card/card_header.dart';
import 'package:librarian_app/widgets/details_card/details_card.dart';

import '../providers/edited_borrower_details_providers.dart';

class ContactCard extends ConsumerWidget {
  const ContactCard({
    super.key,
    required this.name,
    this.email,
    this.phone,
  });

  final String name;
  final String? email;
  final String? phone;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return DetailsCard(
      header: const CardHeader(title: 'Contact Details'),
      showDivider: true,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: TextEditingController(text: name),
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
                text: ref.read(emailProvider) ?? email,
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
                text: ref.read(phoneProvider) ?? phone,
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
          ],
        ),
      ),
    );
  }
}

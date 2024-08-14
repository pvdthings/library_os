import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:librarian_app/widgets/details_card/card_body.dart';
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
      body: CardBody(
        child: Column(
          children: [
            TextField(
              controller: TextEditingController(text: name),
              readOnly: true,
              decoration: const InputDecoration(
                icon: Icon(Icons.person_rounded),
                labelText: 'Name',
                border: OutlineInputBorder(),
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

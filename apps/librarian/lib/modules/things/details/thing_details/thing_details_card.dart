import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:librarian_app/core/models/detailed_thing_model.dart';
import 'package:librarian_app/widgets/details_card/card_body.dart';
import 'package:librarian_app/widgets/details_card/details_card.dart';
import 'package:librarian_app/widgets/fields/checkbox_field.dart';
import 'package:librarian_app/widgets/input_decoration.dart';

import '../../providers/edited_thing_details_providers.dart';

class ThingDetailsCard extends ConsumerWidget {
  const ThingDetailsCard({super.key, required this.details});

  final DetailedThingModel details;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return DetailsCard(
        body: CardBody(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextField(
            controller: TextEditingController(text: details.name),
            decoration: inputDecoration.copyWith(labelText: 'Name'),
            onChanged: (value) => ref.read(nameProvider.notifier).state = value,
          ),
          const SizedBox(height: 16),
          TextField(
            controller: TextEditingController(text: details.spanishName),
            decoration: inputDecoration.copyWith(labelText: 'Name (Spanish)'),
            onChanged: (value) =>
                ref.read(spanishNameProvider.notifier).state = value,
          ),
          const SizedBox(height: 32),
          CheckboxField(
            title: 'Hidden',
            value: ref.watch(hiddenProvider) ?? details.hidden,
            onChanged: (bool? value) {
              ref.read(hiddenProvider.notifier).state = value ?? false;
            },
          ),
          const SizedBox(height: 16),
          CheckboxField(
            title: 'Eye Protection Required',
            value: ref.watch(eyeProtectionProvider) ?? details.eyeProtection,
            onChanged: (bool? value) {
              ref.read(eyeProtectionProvider.notifier).state = value ?? false;
            },
          ),
        ],
      ),
    ));
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:librarian_app/core/api/models/detailed_thing_model.dart';
import 'package:librarian_app/core/api/models/thing_model.dart';
import 'package:librarian_app/modules/things/providers/edited_thing_details_providers.dart';
import 'package:librarian_app/modules/things/providers/thing_details_provider.dart';
import 'package:librarian_app/widgets/details_card/card_body.dart';
import 'package:librarian_app/widgets/details_card/card_header.dart';
import 'package:librarian_app/widgets/details_card/details_card.dart';
import 'package:librarian_app/widgets/hint_text.dart';

import 'dialog.dart';

class LinkedThingsCard extends ConsumerWidget {
  const LinkedThingsCard({super.key});

  Future<List<LinkedThing>?> _chooseThings(
      context, Iterable<String> linkedIds) async {
    final things = await showDialog<List<ThingModel>?>(
      context: context,
      builder: (context) => ChooseThingsDialog(existing: linkedIds),
    );

    return things?.map((t) => LinkedThing(id: t.id, name: t.name)).toList();
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return FutureBuilder(
      future: ref.watch(thingDetailsProvider),
      builder: (context, snapshot) {
        final List<LinkedThing> linkedThings = snapshot.connectionState ==
                ConnectionState.waiting
            ? []
            : ref.watch(linkedThingsProvider) ?? snapshot.data!.linkedThings;

        return DetailsCard(
          header: CardHeader(
            title: 'Linked Things',
            trailing: TextButton.icon(
              onPressed: () async {
                final chosen =
                    await _chooseThings(context, linkedThings.map((t) => t.id));

                final List<LinkedThing> newState = [
                  ...linkedThings,
                  ...(chosen ?? [])
                ];

                ref.read(linkedThingsProvider.notifier).state = newState;
              },
              label: const Text('Link things'),
              icon: const Icon(Icons.add),
            ),
          ),
          body: linkedThings.isEmpty
              ? const CardBody(
                  child: HintText('No linked things.'),
                )
              : CardBody(
                  child: Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: linkedThings
                        .map((t) => Chip(
                              label: Text(t.name),
                              onDeleted: () {
                                ref.read(linkedThingsProvider.notifier).state =
                                    linkedThings
                                        .where((lt) => lt.id != t.id)
                                        .toList();
                              },
                            ))
                        .toList(),
                  ),
                ),
        );
      },
    );
  }
}

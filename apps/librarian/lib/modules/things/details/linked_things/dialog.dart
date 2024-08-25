import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:librarian_app/core/api/models/thing_model.dart';
import 'package:librarian_app/widgets/dialogs/general_dialog.dart';

import '../../providers/things_repository_provider.dart';

class ChooseThingsDialog extends ConsumerStatefulWidget {
  const ChooseThingsDialog({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() {
    return _ChooseThingsDialogState();
  }
}

class _ChooseThingsDialogState extends ConsumerState<ChooseThingsDialog> {
  final List<ThingModel> selected = [];

  late Future<List<ThingModel>> thingsFuture;

  String? searchFilter;

  @override
  void initState() {
    super.initState();
    thingsFuture = ref.read(thingsRepositoryProvider);
  }

  List<ThingModel> filtered(List<ThingModel> things) {
    if (searchFilter == null || searchFilter!.isEmpty) {
      return things;
    }

    return things
        .where(
            (t) => t.name.toLowerCase().contains(searchFilter!.toLowerCase()))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return FractionallySizedBox(
      widthFactor: 1 / 2,
      child: GeneralDialog(
        title: 'Linked Things',
        closeWidget: Row(
          children: [
            OutlinedButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            const SizedBox(width: 8.0),
            FilledButton(
              onPressed: () {
                Navigator.of(context).pop(selected);
              },
              child: const Text('Finish'),
            ),
          ],
        ),
        content: FutureBuilder(
          future: thingsFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            final things = snapshot.data ?? [];
            final filteredThings = filtered(things);

            return Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
                    onChanged: (value) => setState(() {
                      searchFilter = value;
                    }),
                    decoration: const InputDecoration(
                      prefixIcon: Icon(Icons.search),
                      label: Text('Search'),
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                Expanded(
                  child: SingleChildScrollView(
                    child: DataTable(
                      columns: [
                        DataColumn(
                          label: Text('${selected.length} things selected'),
                        ),
                      ],
                      rows: filteredThings
                          .map((thing) => DataRow(
                                cells: [
                                  DataCell(Text(thing.name)),
                                ],
                                selected: selected.contains(thing),
                                onSelectChanged: (value) => setState(() {
                                  if (value == false &&
                                      selected.contains(thing)) {
                                    selected.remove(thing);
                                  }

                                  if (value == true) {
                                    selected.add(thing);
                                  }
                                }),
                              ))
                          .toList(),
                      onSelectAll: (value) => setState(() {
                        selected.clear();

                        if (value == true) {
                          selected.addAll(things);
                        }
                      }),
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

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
  final searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    thingsFuture = ref.read(thingsRepositoryProvider);
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
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

  void clearSearch() {
    searchController.clear();
    setState(() => searchFilter = null);
  }

  @override
  Widget build(BuildContext context) {
    return FractionallySizedBox(
      widthFactor: 1 / 2,
      child: GeneralDialog(
        title: 'Add Linked Things',
        titleSuffix: Chip(label: Text('Adding ${selected.length} Things')),
        closeButton: false,
        toolbar: TextField(
          controller: searchController,
          onChanged: (value) => setState(() {
            searchFilter = value;
          }),
          decoration: InputDecoration(
            prefixIcon: const Icon(Icons.search),
            suffixIcon: IconButton(
              onPressed: searchFilter == null ? null : clearSearch,
              icon: const Icon(Icons.clear),
            ),
            label: const Text('Search'),
            border: const OutlineInputBorder(),
          ),
        ),
        footerActions: [
          OutlinedButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: selected.isNotEmpty
                ? () => Navigator.of(context).pop(selected)
                : null,
            child: const Text('Add'),
          ),
        ],
        content: FutureBuilder(
          future: thingsFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            final things = snapshot.data ?? [];
            final filteredThings = filtered(things);

            return SingleChildScrollView(
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
                            if (value == false && selected.contains(thing)) {
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
            );
          },
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:librarian_app/widgets/fields/submit_text_field.dart';
import 'package:librarian_app/core/api/models/thing_model.dart';
import 'package:librarian_app/modules/things/providers/things_filter_provider.dart';
import 'package:librarian_app/modules/things/details/inventory/inventory_list/inventory_list_view.dart';

class SearchableInventoryList extends ConsumerWidget {
  final Function(ThingModel)? onThingTapped;

  const SearchableInventoryList({
    super.key,
    this.onThingTapped,
  });

  // final _searchController = TextEditingController();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final searchFilter = ref.watch(thingsFilterProvider);

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: SubmitTextField(
            hintText: "Hammer",
            labelText: "Search",
            prefixIcon: const Icon(Icons.search),
            showSubmitButton: false,
            onChanged: (value) {
              ref.read(thingsFilterProvider.notifier).state = value;
            },
            onSubmitted: (_) => {},
            controller: TextEditingController(text: searchFilter),
          ),
        ),
        Expanded(
          child: InventoryListView(
            onTap: onThingTapped,
          ),
        ),
      ],
    );
  }
}

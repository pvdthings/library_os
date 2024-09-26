import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:librarian_app/widgets/fields/search_field.dart';

import '../providers/selected_thing_provider.dart';
import '../providers/things_filter_provider.dart';
import 'item_lookup_button.dart';

class ThingsSearchField extends ConsumerWidget {
  const ThingsSearchField({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SearchField(
      text: ref.watch(thingsFilterProvider),
      onChanged: (value) {
        ref.read(thingsFilterProvider.notifier).state = value;
      },
      onClearPressed: () {
        ref.read(thingsFilterProvider.notifier).state = null;
        ref.read(selectedThingProvider.notifier).state = null;
      },
      trailing: const Tooltip(
        message: 'Item Lookup',
        child: ItemLookupButton(),
      ),
    );
  }
}

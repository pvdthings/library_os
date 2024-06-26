import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:librarian_app/widgets/panes/list_pane.dart';
import 'package:librarian_app/widgets/panes/pane_header.dart';
import 'package:librarian_app/widgets/fields/search_field.dart';
import 'package:librarian_app/modules/things/providers/selected_thing_provider.dart';
import 'package:librarian_app/modules/things/providers/things_filter_provider.dart';

import '../../modules/things/details/inventory_details_pane.dart';
import '../../modules/things/details/inventory/inventory_list/inventory_list_view.dart';

class InventoryDesktopLayout extends ConsumerWidget {
  const InventoryDesktopLayout({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Row(
      children: [
        ListPane(
          header: PaneHeader(
            child: SearchField(
              text: ref.watch(thingsFilterProvider),
              onChanged: (value) {
                ref.read(thingsFilterProvider.notifier).state = value;
              },
              onClearPressed: () {
                ref.read(thingsFilterProvider.notifier).state = null;
                ref.read(selectedThingProvider.notifier).state = null;
              },
            ),
          ),
          child: const InventoryListView(),
        ),
        const Expanded(
          child: InventoryDetailsPane(),
        ),
      ],
    );
  }
}

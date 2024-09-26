import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:librarian_app/modules/things/search/search_field.dart';
import 'package:librarian_app/widgets/panes/list_pane.dart';
import 'package:librarian_app/widgets/panes/pane_header.dart';

import '../../modules/things/details/inventory_details_pane.dart';
import '../../modules/things/details/inventory/inventory_list/inventory_list_view.dart';

class InventoryDesktopLayout extends ConsumerWidget {
  const InventoryDesktopLayout({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return const Row(
      children: [
        ListPane(
          header: PaneHeader(
            child: ThingsSearchField(),
          ),
          child: InventoryListView(),
        ),
        Expanded(
          child: InventoryDetailsPane(),
        ),
      ],
    );
  }
}

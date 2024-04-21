import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:librarian_app/src/features/borrowers/providers/borrower_details_provider.dart';
import 'package:librarian_app/src/features/borrowers/providers/borrowers_filter_provider.dart';
import 'package:librarian_app/src/features/borrowers/providers/selected_borrower_provider.dart';
import 'package:librarian_app/src/features/borrowers/widgets/borrower_details/borrower_details_pane.dart';
import 'package:librarian_app/src/widgets/fields/search_field.dart';
import 'package:librarian_app/src/features/dashboard/widgets/panes/list_pane.widget.dart';
import 'package:librarian_app/src/features/dashboard/widgets/panes/pane_header.widget.dart';

import '../borrowers_list/borrowers_list_view.dart';

class BorrowersDesktopLayout extends ConsumerWidget {
  const BorrowersDesktopLayout({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Row(
      children: [
        ListPane(
          header: PaneHeader(
            child: SearchField(
              text: ref.watch(borrowersFilterProvider),
              onChanged: (value) {
                ref.read(borrowersFilterProvider.notifier).state = value;
              },
              onClearPressed: () {
                ref.read(borrowersFilterProvider.notifier).state = null;
                ref.read(selectedBorrowerProvider.notifier).state = null;
              },
            ),
          ),
          child: const BorrowersListView(),
        ),
        Expanded(
          child: BorrowerDetailsPane(
            borrowerFuture: ref.watch(borrowerDetailsProvider),
          ),
        ),
      ],
    );
  }
}

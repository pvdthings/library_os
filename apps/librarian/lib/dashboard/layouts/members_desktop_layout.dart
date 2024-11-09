import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:librarian_app/modules/members/providers/borrower_details_provider.dart';
import 'package:librarian_app/modules/members/providers/borrowers_filter_provider.dart';
import 'package:librarian_app/modules/members/providers/selected_borrower_provider.dart';
import 'package:librarian_app/modules/members/details/member_details_pane.dart';
import 'package:librarian_app/widgets/fields/search_field.dart';
import 'package:librarian_app/widgets/panes/list_pane.dart';
import 'package:librarian_app/widgets/panes/pane_header.dart';

import '../../modules/members/list/members_list_view.dart';

class MembersDesktopLayout extends ConsumerWidget {
  const MembersDesktopLayout({super.key});

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
          child: const MembersListView(),
        ),
        Expanded(
          child: MemberDetailsPane(
            borrowerFuture: ref.watch(borrowerDetailsProvider),
          ),
        ),
      ],
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:librarian_app/core/models/member_model.dart';
import 'package:librarian_app/modules/members/providers/borrowers_filter_provider.dart';
import 'package:librarian_app/modules/members/list/members_list_view.dart';

import '../../../widgets/fields/submit_text_field.dart';

class SearchableMembersList extends ConsumerWidget {
  final void Function(MemberModel borrower)? onTapBorrower;

  const SearchableMembersList({
    super.key,
    this.onTapBorrower,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: SubmitTextField(
            hintText: "Alice Appleseed",
            labelText: "Search",
            prefixIcon: const Icon(Icons.search),
            showSubmitButton: false,
            onChanged: (value) {
              ref.read(borrowersFilterProvider.notifier).state = value;
            },
            onSubmitted: (_) => {},
            controller: TextEditingController(
              text: ref.watch(borrowersFilterProvider),
            ),
          ),
        ),
        Expanded(
          child: MembersListView(onTap: onTapBorrower),
        ),
      ],
    );
  }
}

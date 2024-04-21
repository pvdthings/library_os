import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:librarian_app/src/features/borrowers/models/borrower_model.dart';
import 'package:librarian_app/src/features/borrowers/providers/borrowers_filter_provider.dart';
import 'package:librarian_app/src/features/borrowers/widgets/borrowers_list/borrowers_list_view.dart';

import '../../../../widgets/fields/submit_text_field.dart';

class SearchableBorrowersList extends ConsumerWidget {
  final void Function(BorrowerModel borrower)? onTapBorrower;

  const SearchableBorrowersList({
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
          child: BorrowersListView(onTap: onTapBorrower),
        ),
      ],
    );
  }
}

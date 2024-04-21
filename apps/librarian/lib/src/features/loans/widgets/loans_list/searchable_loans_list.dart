import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:librarian_app/src/widgets/fields/submit_text_field.dart';
import 'package:librarian_app/src/features/loans/models/loan_model.dart';
import 'package:librarian_app/src/features/loans/providers/loans_filter_provider.dart';

import 'loans_list_view.dart';

class SearchableLoansList extends ConsumerWidget {
  final Function(LoanModel)? onLoanTapped;

  const SearchableLoansList({
    super.key,
    this.onLoanTapped,
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
              ref.read(loansFilterProvider.notifier).state =
                  value.toLowerCase();
            },
            onSubmitted: (_) => {},
            controller:
                TextEditingController(text: ref.read(loansFilterProvider)),
          ),
        ),
        Expanded(child: LoansListView(onTap: onLoanTapped)),
      ],
    );
  }
}

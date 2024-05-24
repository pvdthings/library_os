import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:librarian_app/widgets/fields/search_field.dart';
import 'package:librarian_app/modules/dashboard/widgets/panes/list_pane.dart';
import 'package:librarian_app/modules/dashboard/widgets/panes/pane_header.dart';
import 'package:librarian_app/modules/loans/providers/loans_filter_provider.dart';
import 'package:librarian_app/modules/loans/providers/selected_loan_provider.dart';
import 'package:librarian_app/modules/loans/widgets/loan_details/loan_details_pane.dart';
import 'package:librarian_app/modules/loans/widgets/loans_list/loans_list_view.dart';

class LoansDesktopLayout extends ConsumerWidget {
  const LoansDesktopLayout({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Row(
      children: [
        ListPane(
          header: PaneHeader(
            child: SearchField(
              text: ref.watch(loansFilterProvider),
              onChanged: (value) {
                ref.read(loansFilterProvider.notifier).state =
                    value.toLowerCase();
              },
              onClearPressed: () {
                ref.read(loansFilterProvider.notifier).state = null;
                ref.read(selectedLoanProvider.notifier).state = null;
              },
            ),
          ),
          child: const LoansListView(),
        ),
        const Expanded(
          child: LoanDetailsPane(),
        ),
      ],
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:librarian_app/modules/members/providers/borrowers_provider.dart';
import 'package:librarian_app/modules/members/providers/edited_borrower_details_providers.dart';
import 'package:librarian_app/modules/members/providers/selected_borrower_provider.dart';

import '../../../core/api/models/borrower_model.dart';
import 'members_list.dart';

class MembersListView extends ConsumerWidget {
  const MembersListView({super.key, this.onTap});

  final void Function(BorrowerModel)? onTap;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return FutureBuilder(
      future: ref.watch(borrowersProvider),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Center(child: Text(snapshot.error!.toString()));
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.data!.isEmpty) {
          return const Center(child: Text('No results found'));
        }

        return BorrowersList(
          borrowers: snapshot.data!,
          selected: ref.watch(selectedBorrowerProvider),
          onTap: (borrower) {
            ref.read(borrowerDetailsEditorProvider).discardChanges();
            ref.read(selectedBorrowerProvider.notifier).state = borrower;
            onTap?.call(borrower);
          },
        );
      },
    );
  }
}

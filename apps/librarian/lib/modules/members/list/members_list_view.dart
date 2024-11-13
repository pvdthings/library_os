import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:librarian_app/core/api/models/borrower_model.dart';
import 'package:librarian_app/modules/members/providers/borrowers_provider.dart';
import 'package:librarian_app/widgets/skeleton.dart';

import 'members_list.dart';

class MembersListView extends ConsumerWidget {
  const MembersListView({super.key, this.onTap});

  final void Function(BorrowerModel)? onTap;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final membersListAsync = ref.watch(membersListProvider);
    return membersListAsync.when(
      loading: () {
        return const Skeleton(
          enabled: true,
          child: MembersList(
            borrowers: [
              dummyMember,
              dummyMember,
              dummyMember,
            ],
          ),
        );
      },
      data: (list) {
        if (list.members.isEmpty) {
          return const Center(child: Text('No results found'));
        }

        return MembersList(
          borrowers: list.members,
          selected: list.selected,
          onTap: (model) {
            list.onTap(model);
            onTap?.call(model);
          },
        );
      },
      error: (error, stackTrace) {
        return Center(child: Text(stackTrace.toString()));
      },
      skipLoadingOnReload: true,
    );
  }
}

const dummyMember = BorrowerModel(
  id: '',
  name: 'Member',
  issues: [],
);

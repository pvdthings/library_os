import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:librarian_app/core/models/member_model.dart';
import 'package:librarian_app/modules/members/providers/borrowers_filter_provider.dart';
import 'package:librarian_app/modules/members/providers/selected_borrower_provider.dart';
import 'package:librarian_app/providers/members.dart';

import 'edited_borrower_details_providers.dart';

final borrowersProvider = Provider<Future<List<MemberModel>>>((ref) async {
  final searchFilter = ref.watch(borrowersFilterProvider);
  final borrowers = await ref.watch(membersProvider);

  if (searchFilter == null) {
    return borrowers;
  }

  return borrowers
      .where((b) => b.name.toLowerCase().contains(searchFilter.toLowerCase()))
      .toList();
});

final membersListProvider = FutureProvider((ref) async {
  final filter = ref.watch(borrowersFilterProvider);
  final members = await ref.watch(membersProvider);

  final filteredMembers = filter == null || filter.isEmpty
      ? members
      : members
          .where((b) => b.name.toLowerCase().contains(filter.toLowerCase()))
          .toList();

  return MembersListViewModel(
    selected: ref.watch(selectedBorrowerProvider),
    members: filteredMembers,
    onTap: (member) {
      ref.read(borrowerDetailsEditorProvider).discardChanges();
      ref.read(selectedBorrowerProvider.notifier).state = member;
    },
  );
});

class MembersListViewModel {
  const MembersListViewModel({
    required this.selected,
    required this.members,
    required this.onTap,
  });

  final MemberModel? selected;
  final List<MemberModel> members;
  final void Function(MemberModel) onTap;
}

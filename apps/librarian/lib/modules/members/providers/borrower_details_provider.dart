import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:librarian_app/core/api/models/issue_model.dart';
import 'package:librarian_app/core/data/borrowers_repository.dart';
import 'package:librarian_app/modules/members/providers/borrowers_repository_provider.dart';
import 'package:librarian_app/modules/members/providers/selected_borrower_provider.dart';

import '../../../core/api/models/borrower_model.dart';

final borrowerDetailsProvider = Provider<Future<BorrowerModel?>>((ref) async {
  ref.watch(borrowersRepositoryProvider);
  final selectedBorrower = ref.watch(selectedBorrowerProvider);
  if (selectedBorrower == null) {
    return null;
  }

  final borrowers = ref.read(borrowersRepositoryProvider.notifier);
  return await borrowers.getBorrowerDetails(selectedBorrower.id);
});

final memberDetailsProvider = FutureProvider((ref) async {
  final selectedMemberId = ref.watch(selectedBorrowerProvider)?.id;
  if (selectedMemberId == null) {
    return null;
  }

  final details =
      await BorrowersRepository().getBorrowerDetails(selectedMemberId);
  if (details == null) {
    return null;
  }

  return MemberDetailsViewModel(
    id: selectedMemberId,
    name: details.name,
    email: details.email,
    phone: details.phone,
    issues: details.issues,
  );
});

class MemberDetailsViewModel {
  const MemberDetailsViewModel({
    required this.id,
    required this.name,
    required this.issues,
    this.email,
    this.phone,
  });

  final String id;
  final String name;
  final String? email;
  final String? phone;
  final List<Issue> issues;
}

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:librarian_app/core/api/models/member_model.dart';
import 'package:librarian_app/core/api/models/issue_model.dart';
import 'package:librarian_app/core/api/models/payment_model.dart';
import 'package:librarian_app/core/data/borrowers_repository.dart';
import 'package:librarian_app/modules/members/providers/selected_borrower_provider.dart';
import 'package:librarian_app/providers/members.dart';

// TODO: Remove this provider
final borrowerDetailsProvider = Provider<Future<MemberModel?>>((ref) async {
  ref.watch(membersProvider);
  final selectedBorrower = ref.watch(selectedBorrowerProvider);
  if (selectedBorrower == null) {
    return null;
  }

  return await BorrowersRepository().getBorrowerDetails(selectedBorrower.id);
});

final memberDetailsProvider = FutureProvider((ref) async {
  final selectedMemberId = ref.watch(selectedBorrowerProvider)?.id;
  if (selectedMemberId == null) {
    return null;
  }

  final repository = BorrowersRepository();

  final details = await repository.getBorrowerDetails(selectedMemberId);
  if (details == null) {
    return null;
  }

  final payments = await repository.getPayments(selectedMemberId);

  return MemberDetailsViewModel(
    id: selectedMemberId,
    name: details.name,
    email: details.email,
    phone: details.phone,
    issues: details.issues,
    keyholder: details.keyholder,
    memberSince: details.joinDate,
    volunteerHours: details.volunteerHours,
    payments: payments,
  );
});

class MemberDetailsViewModel {
  const MemberDetailsViewModel({
    required this.id,
    required this.name,
    required this.issues,
    required this.keyholder,
    required this.payments,
    required this.volunteerHours,
    this.memberSince,
    this.email,
    this.phone,
  });

  final String id;
  final String name;
  final String? email;
  final String? phone;
  final List<Issue> issues;
  final bool keyholder;
  final DateTime? memberSince;
  final int volunteerHours;
  final List<PaymentModel> payments;
}

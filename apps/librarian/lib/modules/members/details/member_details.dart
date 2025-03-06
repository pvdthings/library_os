import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:librarian_app/core/models/issue_model.dart';
import 'package:librarian_app/core/models/payment_model.dart';
import 'package:librarian_app/modules/members/details/contact_card.dart';
import 'package:librarian_app/modules/members/details/stats_card.dart';
import 'package:librarian_app/modules/members/providers/borrower_details_provider.dart';
import 'package:librarian_app/modules/members/details/issues_card.dart';
import 'package:librarian_app/modules/members/details/payments_card.dart';
import 'package:librarian_app/widgets/skeleton.dart';

class MemberDetails extends ConsumerWidget {
  const MemberDetails({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final details = ref.watch(memberDetailsProvider);
    return details.when(
      data: (model) {
        if (model == null) {
          return const SizedBox.shrink();
        }

        return _Details(
          id: model.id,
          name: model.name,
          email: model.email,
          phone: model.phone,
          issues: model.issues,
          memberSince: model.memberSince,
          keyholder: model.keyholder,
          volunteerHours: model.volunteerHours,
          payments: model.payments,
        );
      },
      loading: () {
        return Skeleton(
          enabled: true,
          child: _Details(
            id: '',
            name: '',
            email: '',
            phone: '',
            issues: const [],
            keyholder: false,
            memberSince: DateTime.now(),
            volunteerHours: 0,
            payments: const [],
          ),
        );
      },
      error: (error, stackTrace) {
        return Center(child: Text(stackTrace.toString()));
      },
    );
  }
}

class _Details extends StatelessWidget {
  const _Details({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.issues,
    required this.keyholder,
    required this.memberSince,
    required this.payments,
    required this.volunteerHours,
  });

  final String id;
  final String name;
  final String? email;
  final String? phone;
  final List<Issue> issues;
  final bool keyholder;
  final DateTime? memberSince;
  final List<PaymentModel> payments;
  final int volunteerHours;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      spacing: 16,
      children: [
        ContactCard(
          name: name,
          email: email,
          phone: phone,
        ),
        StatsCard(
          keyholder: keyholder,
          memberSince: memberSince,
          volunteerHours: volunteerHours,
        ),
        IssuesCard(
          borrowerId: id,
          issues: issues,
        ),
        PaymentsCard(payments: payments),
      ],
    );
  }
}

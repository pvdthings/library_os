import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:librarian_app/core/models/member_model.dart';
import 'package:librarian_app/modules/members/details/issues.dart';
import 'package:librarian_app/modules/loans/checkout/stepper/borrower/borrower_search_delegate.dart';
import 'package:librarian_app/modules/members/details/stats_card.dart';
import 'package:librarian_app/providers/members.dart';
import 'package:librarian_app/utils/media_query.dart';
import 'package:librarian_app/widgets/details_card/details_card.dart';

Step buildBorrowerStep({
  required BuildContext context,
  required WidgetRef ref,
  required bool isActive,
  required MemberModel? borrower,
  required void Function(MemberModel?) onBorrowerSelected,
}) {
  return Step(
    title: const Text('Select Borrower'),
    subtitle: borrower != null ? Text(borrower.name) : null,
    content: Column(
      children: [
        _SelectBorrowerTextField(
          text: borrower?.name,
          onSelected: onBorrowerSelected,
        ),
        if (borrower != null) ...[
          const SizedBox(height: 16),
          LayoutBuilder(builder: (context, constraints) {
            final children = [
              StatsCard(
                keyholder: borrower.keyholder,
                memberSince: borrower.joinDate,
                volunteerHours: borrower.volunteerHours,
              ),
              DetailsCard(
                body: MemberIssues(
                  borrowerId: borrower.id,
                  issues: borrower.issues,
                  onRecordCashPayment: (success) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                            success ? 'Success!' : 'Failed to record payment'),
                      ),
                    );

                    if (success) {
                      ref.read(membersProvider).then((list) {
                        return list
                            .firstWhereOrNull((b) => b.id == borrower.id);
                      }).then(onBorrowerSelected);
                    }
                  },
                ),
              ),
            ];

            if (isMobile(context)) {
              return Wrap(
                runSpacing: 16.0,
                spacing: 16.0,
                children: children,
              );
            }

            return GridView.count(
              childAspectRatio: 2 / 1,
              crossAxisCount: 2,
              crossAxisSpacing: 16.0,
              mainAxisSpacing: 16.0,
              shrinkWrap: true,
              children: children,
            );
          }),
        ],
      ],
    ),
    isActive: isActive,
  );
}

class _SelectBorrowerTextField extends ConsumerStatefulWidget {
  const _SelectBorrowerTextField({
    required this.text,
    required this.onSelected,
  });

  final String? text;
  final void Function(MemberModel? borrower) onSelected;

  @override
  ConsumerState<_SelectBorrowerTextField> createState() =>
      _SelectBorrowerTextFieldState();
}

class _SelectBorrowerTextFieldState
    extends ConsumerState<_SelectBorrowerTextField> {
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: TextEditingController(text: widget.text),
      canRequestFocus: false,
      decoration: InputDecoration(
        labelText: _isLoading ? 'Loading...' : 'Borrower',
        prefixIcon: const Icon(Icons.person_rounded),
      ),
      enabled: !_isLoading,
      onTap: () {
        setState(() => _isLoading = true);

        ref.invalidate(membersProvider);
        ref.read(membersProvider).then((borrowers) async {
          return await showSearch(
            context: context,
            delegate: BorrowerSearchDelegate(borrowers),
            useRootNavigator: true,
          );
        }).then((borrower) {
          widget.onSelected(borrower);
          setState(() => _isLoading = false);
        });
      },
    );
  }
}

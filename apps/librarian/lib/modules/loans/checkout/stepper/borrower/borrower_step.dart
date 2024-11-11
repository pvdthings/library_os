import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:librarian_app/core/api/models/borrower_model.dart';
import 'package:librarian_app/modules/members/details/issues.dart';
import 'package:librarian_app/modules/members/providers/borrowers_repository_provider.dart';
import 'package:librarian_app/modules/loans/checkout/stepper/borrower/borrower_search_delegate.dart';
import 'package:librarian_app/providers/members.dart';

Step buildBorrowerStep({
  required BuildContext context,
  required WidgetRef ref,
  required bool isActive,
  required BorrowerModel? borrower,
  required void Function(BorrowerModel?) onBorrowerSelected,
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
        if (borrower != null && !borrower.active) ...[
          const SizedBox(height: 16),
          MemberIssues(
            borrowerId: borrower.id,
            issues: borrower.issues,
            onRecordCashPayment: (success) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content:
                      Text(success ? 'Success!' : 'Failed to record payment'),
                ),
              );

              if (success) {
                ref
                    .read(borrowersRepositoryProvider.notifier)
                    .getBorrower(borrower.id)
                    .then(onBorrowerSelected);
              }
            },
          ),
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
  final void Function(BorrowerModel? borrower) onSelected;

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

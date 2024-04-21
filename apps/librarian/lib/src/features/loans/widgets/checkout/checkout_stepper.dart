import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:librarian_app/src/features/borrowers/models/borrower_model.dart';
import 'package:librarian_app/src/features/borrowers/providers/borrowers_repository_provider.dart';
import 'package:librarian_app/src/features/borrowers/widgets/borrower_details/borrower_issues.dart';
import 'package:librarian_app/src/features/borrowers/widgets/borrower_search_delegate.dart';
import 'package:librarian_app/src/features/loans/pages/loan_details_page.dart';
import 'package:librarian_app/src/features/loans/providers/loans_controller_provider.dart';
import 'package:librarian_app/src/features/loans/widgets/checkout/eye_protection_dialog.dart';
import 'package:librarian_app/src/utils/media_query.dart';
import 'package:librarian_app/src/widgets/filled_progress_button.dart';
import 'package:librarian_app/src/features/inventory/models/item_model.dart';
import 'package:librarian_app/src/features/inventory/providers/things_repository_provider.dart';
import 'package:librarian_app/src/features/loans/models/thing_summary_model.dart';
import 'package:librarian_app/src/features/loans/widgets/checkout/connected_thing_search_field.dart';

import 'checkout_details.dart';

class CheckoutStepper extends ConsumerStatefulWidget {
  const CheckoutStepper({super.key});

  @override
  ConsumerState<CheckoutStepper> createState() => _CheckoutStepperState();
}

class _CheckoutStepperState extends ConsumerState<CheckoutStepper> {
  int _index = 0;
  BorrowerModel? _borrower;
  DateTime _dueDate = DateTime.now().add(const Duration(days: 7));

  bool _didPromptForEyeProtection = false;

  final List<ItemModel> _things = [];

  void Function()? _onStepContinueFactory(int index) {
    switch (index) {
      case 0:
        if (_borrower == null || !_borrower!.active) {
          return null;
        }

        return () {
          setState(() => _index++);
        };
      case 1:
        if (_things.isEmpty) {
          return null;
        }

        return () {
          setState(() => _index++);
        };
      default:
        return _finish;
    }
  }

  void _finish() async {
    final success = await ref.read(loansControllerProvider).openLoan(
        borrowerId: _borrower!.id,
        thingIds: _things.map((e) => e.id).toList(),
        dueDate: _dueDate);

    Future.delayed(Duration.zero, () {
      Navigator.of(context).pop();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(success ? 'Success!' : 'Failed to create loan records'),
        ),
      );

      if (isMobile(context)) {
        Navigator.of(context).push(MaterialPageRoute(builder: (context) {
          return const LoanDetailsPage();
        }));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stepper(
      currentStep: _index,
      controlsBuilder: (context, details) {
        return Padding(
          padding: const EdgeInsets.only(top: 16),
          child: Row(
            children: [
              details.stepIndex != 2
                  ? FilledButton(
                      onPressed: details.onStepContinue,
                      child: const Text('Continue'),
                    )
                  : FilledProgressButton(
                      onPressed: details.onStepContinue,
                      child: const Text('Confirm'),
                    ),
            ],
          ),
        );
      },
      onStepTapped: (value) {
        if (value < _index) {
          setState(() => _index = value);
        }
      },
      onStepContinue: _onStepContinueFactory(_index),
      onStepCancel: _index > 0
          ? () {
              setState(() => _index--);
            }
          : null,
      steps: [
        Step(
          title: const Text('Select Borrower'),
          subtitle: _borrower != null ? Text(_borrower!.name) : null,
          content: Column(
            children: [
              _SelectBorrowerTextField(
                text: _borrower?.name,
                onSelected: (borrower) {
                  if (borrower != null) {
                    setState(() => _borrower = borrower);
                  }
                },
              ),
              if (_borrower != null && !_borrower!.active) ...[
                const SizedBox(height: 16),
                BorrowerIssues(
                  borrowerId: _borrower!.id,
                  issues: _borrower!.issues,
                  onRecordCashPayment: (success) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                            success ? 'Success!' : 'Failed to record payment'),
                      ),
                    );

                    if (success) {
                      ref
                          .read(borrowersRepositoryProvider.notifier)
                          .getBorrower(_borrower!.id)
                          .then((b) {
                        setState(() => _borrower = b);
                      });
                    }
                  },
                ),
              ],
            ],
          ),
          isActive: _index >= 0,
        ),
        Step(
          title: const Text('Add Things'),
          subtitle: Text(
              '${_things.length} Thing${_things.length == 1 ? '' : 's'} Added'),
          content: Column(
            children: [
              ConnectedThingSearchField(
                controller: ThingSearchController(
                  context: context,
                  onMatchFound: (thing) {
                    setState(() => _things.add(thing));

                    if (thing.eyeProtection && !_didPromptForEyeProtection) {
                      showDialog(
                          context: context,
                          builder: (_) => const EyeProtectionDialog());
                      _didPromptForEyeProtection = true;
                    }
                  },
                  repository: ref.read(thingsRepositoryProvider.notifier),
                ),
              ),
              const SizedBox(height: 8),
              ListView.builder(
                itemCount: _things.length,
                itemBuilder: (context, index) {
                  final thing = _things[index];
                  return Card(
                    child: ListTile(
                      leading: Text('#${thing.number}'),
                      title: Text(thing.name),
                      trailing: IconButton(
                        icon: const Icon(Icons.remove_circle_rounded),
                        onPressed: () {
                          setState(() => _things.remove(thing));
                        },
                        tooltip: 'Remove #${thing.number}',
                      ),
                    ),
                  );
                },
                shrinkWrap: true,
              ),
            ],
          ),
          isActive: _index >= 1,
        ),
        Step(
          title: const Text('Confirm Details'),
          content: Padding(
            padding: const EdgeInsets.only(top: 8),
            child: CheckoutDetails(
              borrower: _borrower,
              things: _things
                  .map((t) => ThingSummaryModel(
                        id: t.id,
                        name: t.name,
                        number: t.number,
                        images: [],
                      ))
                  .toList(),
              dueDate: _dueDate,
              onDueDateUpdated: (newDate) {
                setState(() => _dueDate = newDate);
              },
            ),
          ),
          isActive: _index >= 2,
        ),
      ],
    );
  }
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

        ref.invalidate(borrowersRepositoryProvider);
        ref.read(borrowersRepositoryProvider).then((borrowers) async {
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

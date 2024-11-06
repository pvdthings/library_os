import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:librarian_app/core/api/models/borrower_model.dart';
import 'package:librarian_app/modules/loans/checkout/existing_item_dialog.dart';
import 'package:librarian_app/modules/loans/checkout/stepper/steps/borrower_step.dart';
import 'package:librarian_app/modules/loans/checkout/suggested_things_dialog.dart';
import 'package:librarian_app/modules/loans/details/loan_details_page.dart';
import 'package:librarian_app/modules/loans/providers/loans_controller_provider.dart';
import 'package:librarian_app/modules/loans/checkout/eye_protection_dialog.dart';
import 'package:librarian_app/utils/media_query.dart';
import 'package:librarian_app/widgets/filled_progress_button.dart';
import 'package:librarian_app/core/api/models/item_model.dart';
import 'package:librarian_app/modules/things/providers/things_repository_provider.dart';
import 'package:librarian_app/core/api/models/thing_summary_model.dart';
import 'package:librarian_app/modules/loans/checkout/connected_thing_search_field.dart';
import 'package:librarian_app/widgets/item_card.dart';

import '../checkout_details.dart';

class CheckoutStepper extends ConsumerStatefulWidget {
  const CheckoutStepper({super.key, this.onFinish});

  final void Function()? onFinish;

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
      widget.onFinish?.call();
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
        buildBorrowerStep(
          context: context,
          ref: ref,
          isActive: _index >= 0,
          borrower: _borrower,
          onBorrowerSelected: (b) {
            setState(() => _borrower = b);
          },
        ),
        Step(
          title: const Text('Add Items'),
          subtitle: Text(
              '${_things.length} Item${_things.length == 1 ? '' : 's'} Added'),
          content: Column(
            children: [
              ConnectedThingSearchField(
                controller: ThingSearchController(
                  context: context,
                  onMatchFound: (thing) {
                    if (_things.any((t) => t.id == thing.id)) {
                      showDialog(
                        context: context,
                        builder: (context) {
                          return ExistingItemDialog(number: thing.number);
                        },
                      );
                      return;
                    }

                    setState(() => _things.add(thing));

                    if (thing.eyeProtection && !_didPromptForEyeProtection) {
                      showDialog(
                        context: context,
                        builder: (_) => const EyeProtectionDialog(),
                      );
                      _didPromptForEyeProtection = true;
                    }

                    if (thing.linkedThingIds.isNotEmpty) {
                      showDialog(
                        context: context,
                        builder: (_) => SuggestedThingsDialog(
                          thingName: thing.name,
                          thingIds: thing.linkedThingIds,
                        ),
                      );
                    }
                  },
                  repository: ref.read(thingsRepositoryProvider.notifier),
                ),
              ),
              const SizedBox(height: 16.0),
              GridView.count(
                crossAxisCount: 8,
                shrinkWrap: true,
                children: _things.map((item) {
                  return ItemCard(
                    number: item.number,
                    imageUrl: item.imageUrls.firstOrNull,
                    trailing: IconButton(
                      icon: const Icon(Icons.remove_circle),
                      onPressed: () {
                        setState(() => _things.remove(item));
                      },
                      padding: EdgeInsets.zero,
                      tooltip: 'Remove',
                    ),
                  );
                }).toList(),
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

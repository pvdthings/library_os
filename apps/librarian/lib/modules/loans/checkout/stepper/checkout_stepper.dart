import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:librarian_app/core/api/models/borrower_model.dart';
import 'package:librarian_app/modules/loans/details/loan_details_page.dart';
import 'package:librarian_app/modules/loans/providers/loans_controller_provider.dart';
import 'package:librarian_app/utils/media_query.dart';
import 'package:librarian_app/widgets/filled_progress_button.dart';
import 'package:librarian_app/core/api/models/item_model.dart';

import 'steps/borrower_step.dart';
import 'steps/confirm_step.dart';
import 'steps/items_step.dart';

class CheckoutStepper extends ConsumerStatefulWidget {
  const CheckoutStepper({super.key, this.onFinish});

  final void Function()? onFinish;

  @override
  ConsumerState<CheckoutStepper> createState() => _CheckoutStepperState();
}

class _CheckoutStepperState extends ConsumerState<CheckoutStepper> {
  int stepIndex = 0;
  BorrowerModel? borrower;
  DateTime dueDate = DateTime.now().add(const Duration(days: 7));

  bool didPromptForEyeProtection = false;

  final List<ItemModel> items = [];

  void Function()? _onStepContinueFactory(int index) {
    switch (index) {
      case 0:
        if (borrower == null || !borrower!.active) {
          return null;
        }

        return () {
          setState(() => stepIndex++);
        };
      case 1:
        if (items.isEmpty) {
          return null;
        }

        return () {
          setState(() => stepIndex++);
        };
      default:
        return _finish;
    }
  }

  void _finish() async {
    final success = await ref.read(loansControllerProvider).openLoan(
        borrowerId: borrower!.id,
        thingIds: items.map((e) => e.id).toList(),
        dueDate: dueDate);

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
      currentStep: stepIndex,
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
        if (value < stepIndex) {
          setState(() => stepIndex = value);
        }
      },
      onStepContinue: _onStepContinueFactory(stepIndex),
      onStepCancel: stepIndex > 0
          ? () {
              setState(() => stepIndex--);
            }
          : null,
      steps: [
        buildBorrowerStep(
          context: context,
          ref: ref,
          isActive: stepIndex >= 0,
          borrower: borrower,
          onBorrowerSelected: (b) {
            setState(() => borrower = b);
          },
        ),
        buildItemsStep(
          context: context,
          ref: ref,
          isActive: stepIndex >= 1,
          didPromptForEyeProtection: didPromptForEyeProtection,
          items: items,
          onAddItem: (item) {
            setState(() => items.add(item));
          },
          onRemoveItem: (item) {
            setState(() => items.remove(item));
          },
          onPromptForEyeProtection: () {
            setState(() => didPromptForEyeProtection = true);
          },
        ),
        buildConfirmStep(
          isActive: stepIndex >= 2,
          borrower: borrower,
          items: items,
          dueDate: dueDate,
          onDueDateUpdated: (newDate) {
            setState(() => dueDate = newDate);
          },
        ),
      ],
    );
  }
}

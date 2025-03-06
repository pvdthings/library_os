import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:librarian_app/modules/members/providers/selected_borrower_provider.dart';
import 'record_payment_dialog.dart';

class DuesNotPaidDialog extends ConsumerStatefulWidget {
  final String instructions;
  final String? imageUrl;
  final Future<void> Function() onConfirmPayment;

  const DuesNotPaidDialog({
    super.key,
    required this.instructions,
    required this.onConfirmPayment,
    this.imageUrl,
  });

  @override
  ConsumerState<DuesNotPaidDialog> createState() => _DuesNotPaidDialogState();
}

class _DuesNotPaidDialogState extends ConsumerState<DuesNotPaidDialog> {
  bool _recordPayment = false;

  @override
  Widget build(BuildContext context) {
    if (_recordPayment) {
      return RecordPaymentDialog(
        name: ref.read(selectedBorrowerProvider)!.name,
        onConfirm: widget.onConfirmPayment,
      );
    }

    return AlertDialog(
      title: const Text('Dues Not Paid'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            widget.instructions,
            style: Theme.of(context).textTheme.bodyLarge,
          ),
          const SizedBox(height: 16),
          if (widget.imageUrl != null)
            Center(
              child: Image.asset(
                widget.imageUrl!,
                width: 360,
              ),
            ),
        ],
      ),
      actions: [
        OutlinedButton(
          onPressed: () {
            setState(() => _recordPayment = true);
          },
          child: const Text('Record Payment'),
        ),
        FilledButton(
          onPressed: () => Navigator.pop(context, false),
          child: const Text('OK'),
        ),
      ],
    );
  }
}

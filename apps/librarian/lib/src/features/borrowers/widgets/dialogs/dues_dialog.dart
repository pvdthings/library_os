import 'package:flutter/material.dart';
import 'record_payment_dialog.dart';

class DuesNotPaidDialog extends StatefulWidget {
  final String instructions;
  final String? imageUrl;
  final void Function(double cash) onConfirmPayment;

  const DuesNotPaidDialog({
    super.key,
    required this.instructions,
    required this.onConfirmPayment,
    this.imageUrl,
  });

  @override
  State<DuesNotPaidDialog> createState() => _DuesNotPaidDialogState();
}

class _DuesNotPaidDialogState extends State<DuesNotPaidDialog> {
  bool _recordPayment = false;

  @override
  Widget build(BuildContext context) {
    if (_recordPayment) {
      return RecordPaymentDialog(
        onConfirmPayment: widget.onConfirmPayment,
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

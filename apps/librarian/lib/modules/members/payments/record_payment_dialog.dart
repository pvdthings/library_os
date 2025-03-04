import 'package:flutter/material.dart';

class RecordPaymentDialog extends StatelessWidget {
  final String name;
  final Future<void> Function() onConfirm;

  const RecordPaymentDialog({
    super.key,
    required this.name,
    required this.onConfirm,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Annual Contribution'),
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        spacing: 16,
        children: [
          Chip(label: Text(name)),
          Text(
              'Clicking OK below will mark their annual contribution as paid.'),
        ],
      ),
      actions: [
        OutlinedButton(
          onPressed: () => Navigator.pop(context, false),
          child: const Text('Cancel'),
        ),
        FilledButton(
          onPressed: () {
            onConfirm().whenComplete(() => Navigator.pop(context, true));
          },
          child: const Text('OK'),
        ),
      ],
    );
  }
}

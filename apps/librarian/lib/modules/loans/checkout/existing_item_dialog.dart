import 'package:flutter/material.dart';

class ExistingItemDialog extends StatelessWidget {
  const ExistingItemDialog({super.key, required this.number});

  final int number;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Item #$number Already Added'),
      content: const Text("The item can't be added again."),
      actions: [
        FilledButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text('OK'),
        ),
      ],
    );
  }
}

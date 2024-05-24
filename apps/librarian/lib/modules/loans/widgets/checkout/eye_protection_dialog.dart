import 'package:flutter/material.dart';

class EyeProtectionDialog extends StatelessWidget {
  const EyeProtectionDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      icon: const Icon(
        Icons.warning_rounded,
        color: Colors.amber,
      ),
      title: const Text('Eye Protection Required'),
      content: const Text('Make sure to add eye protection to this loan.'),
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

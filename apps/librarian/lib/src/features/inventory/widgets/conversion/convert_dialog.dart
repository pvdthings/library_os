import 'package:flutter/material.dart';
import 'package:librarian_app/src/features/inventory/widgets/conversion/icon.dart';

class ConvertDialog extends StatefulWidget {
  const ConvertDialog({super.key});

  @override
  State<ConvertDialog> createState() => _ConvertDialogState();
}

class _ConvertDialogState extends State<ConvertDialog> {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      icon: const Icon(convertIcon),
      title: const Text('Convert Item'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
              'Choose a thing to convert this item into, then click Convert.'),
          const SizedBox(height: 16),
          DropdownButtonFormField(
            items: const [
              DropdownMenuItem(value: 'id', child: Text('Another Thing')),
            ],
            onChanged: (value) {},
          )
        ],
      ),
      actions: [
        OutlinedButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text('Cancel'),
        ),
        const FilledButton(
          onPressed: null,
          child: Text('Convert'),
        ),
      ],
    );
  }
}

void showConvertDialog(BuildContext context) {
  showDialog(context: context, builder: (context) => const ConvertDialog());
}

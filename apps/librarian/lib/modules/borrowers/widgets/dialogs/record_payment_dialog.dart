import 'package:flutter/material.dart';

class RecordPaymentDialog extends StatefulWidget {
  final void Function(double cash) onConfirmPayment;

  const RecordPaymentDialog({
    super.key,
    required this.onConfirmPayment,
  });

  @override
  State<RecordPaymentDialog> createState() => _RecordPaymentDialogState();
}

class _RecordPaymentDialogState extends State<RecordPaymentDialog> {
  final _formKey = GlobalKey<FormState>();
  final _cashController = TextEditingController();

  bool _confirm = false;

  @override
  Widget build(BuildContext context) {
    if (_confirm) {
      return _ConfirmDialog(
        content: Text(
          'Are you sure you want to record a \$${_cashController.text} cash payment?',
          style: Theme.of(context).textTheme.bodyLarge,
        ),
        onConfirm: () {
          widget.onConfirmPayment(double.parse(_cashController.text));
          Navigator.pop(context, true);
        },
        onCancel: () => Navigator.pop(context, false),
      );
    }

    return AlertDialog(
      title: const Text('Record Cash Payment'),
      content: Form(
        key: _formKey,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              controller: _cashController,
              validator: (value) {
                final doubleValue = double.tryParse(value ?? '');
                return doubleValue != null
                    ? null
                    : 'Must be a valid dollar amount';
              },
              decoration: const InputDecoration(
                prefixText: '\$',
                labelText: 'Cash',
                border: OutlineInputBorder(),
              ),
            ),
          ],
        ),
      ),
      actions: [
        OutlinedButton(
          onPressed: () => Navigator.pop(context, false),
          child: const Text('Cancel'),
        ),
        FilledButton(
          onPressed: () {
            if (_formKey.currentState!.validate()) {
              setState(() => _confirm = true);
            }
          },
          child: const Text('OK'),
        ),
      ],
    );
  }
}

class _ConfirmDialog extends StatelessWidget {
  final void Function() onConfirm;
  final void Function() onCancel;
  final Widget? content;

  const _ConfirmDialog({
    required this.onConfirm,
    required this.onCancel,
    this.content,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: content,
      actions: [
        OutlinedButton(
          onPressed: onCancel,
          child: const Text('NO'),
        ),
        FilledButton(
          onPressed: onConfirm,
          child: const Text('YES'),
        ),
      ],
    );
  }
}

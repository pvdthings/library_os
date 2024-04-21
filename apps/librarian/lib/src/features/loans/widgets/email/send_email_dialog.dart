import 'package:flutter/material.dart';

class SendEmailDialog extends StatelessWidget {
  final String recipientName;
  final int remindersSent;
  final Future<void> Function() onSend;

  const SendEmailDialog({
    super.key,
    required this.recipientName,
    required this.remindersSent,
    required this.onSend,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      icon: const Icon(Icons.send),
      title: const Text("Send Reminder Email"),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Are you sure you want to send an email to $recipientName?"),
          if (remindersSent > 0)
            Text("They have previously received $remindersSent reminders."),
        ],
      ),
      actions: [
        OutlinedButton(
          child: const Text("Cancel"),
          onPressed: () => Navigator.of(context).pop(false),
        ),
        FilledButton(
          onPressed: () {
            onSend().whenComplete(() => Navigator.of(context).pop(true));
          },
          child: const Text('Send'),
        ),
      ],
    );
  }
}

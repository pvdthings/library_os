import 'package:flutter/material.dart';
import 'package:librarian_app/src/widgets/filled_progress_button.dart';

class CheckinDialog extends StatelessWidget {
  final int thingNumber;
  final Future<void> Function()? onCheckin;
  final void Function()? onPostCheckin;

  const CheckinDialog({
    super.key,
    required this.thingNumber,
    this.onCheckin,
    this.onPostCheckin,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      icon: const Icon(Icons.library_add_check),
      title: Text("Thing #$thingNumber"),
      content:
          Text("Are you sure you want to check Thing #$thingNumber back in?"),
      actions: [
        OutlinedButton(
          child: const Text("Cancel"),
          onPressed: () => Navigator.of(context).pop(false),
        ),
        FilledProgressButton(
          child: const Text('Check in'),
          onPressed: () {
            Future.delayed(const Duration(seconds: 2), () async {
              await onCheckin?.call();
            }).whenComplete(() {
              Navigator.of(context).pop(true);
              onPostCheckin?.call();
            });
          },
        ),
      ],
    );
  }
}

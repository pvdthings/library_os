import 'package:flutter/material.dart';
import 'package:librarian_app/src/widgets/filled_progress_button.dart';

class EditLoanDialog extends StatefulWidget {
  const EditLoanDialog({
    super.key,
    required this.dueDate,
    required this.notes,
    required this.onSavePressed,
  });

  final DateTime dueDate;
  final String? notes;
  final void Function(DateTime newDueDate, String? notes) onSavePressed;

  @override
  State<EditLoanDialog> createState() => _EditLoanDialogState();
}

class _EditLoanDialogState extends State<EditLoanDialog> {
  late DateTime dueDate = widget.dueDate;

  late final _notesController = TextEditingController(text: widget.notes);

  bool _hasUnsavedChanges() =>
      dueDate != widget.dueDate || _notesController.text != widget.notes;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(false),
          child: const Text('Cancel'),
        ),
        // This works, but it's not the cleanest solution.
        ListenableBuilder(
          listenable: _notesController,
          builder: (context, child) {
            return FilledProgressButton(
              onPressed: _hasUnsavedChanges()
                  ? () {
                      widget.onSavePressed(dueDate, _notesController.text);
                      Navigator.of(context).pop(true);
                    }
                  : null,
              child: const Text('Save'),
            );
          },
        ),
      ],
      icon: const Icon(Icons.edit),
      title: const Text('Edit Loan'),
      content: SizedBox(
        width: 500,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: TextEditingController(
                text: '${dueDate.month}/${dueDate.day}',
              ),
              onTap: () {
                showDatePicker(
                  context: context,
                  initialDate: dueDate,
                  firstDate: widget.dueDate,
                  lastDate: widget.dueDate.add(const Duration(days: 14)),
                ).then((value) {
                  if (value == null) return;
                  setState(() => dueDate = value);
                });
              },
              decoration: const InputDecoration(
                icon: Icon(Icons.calendar_month_rounded),
                labelText: 'Due Back',
                border: OutlineInputBorder(),
                constraints: BoxConstraints(maxWidth: 200),
              ),
            ),
            const SizedBox(height: 32),
            TextField(
              controller: _notesController,
              maxLines: null,
              decoration: const InputDecoration(
                icon: Icon(Icons.notes),
                labelText: 'Notes',
                border: OutlineInputBorder(),
              ),
            ),
          ],
        ),
      ),
      contentPadding: const EdgeInsets.all(16),
    );
  }
}

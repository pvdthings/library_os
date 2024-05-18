import 'package:flutter/material.dart';
import 'package:librarian_app/src/widgets/input_decoration.dart';

class CreateThingDialog extends StatelessWidget {
  CreateThingDialog({super.key, this.onCreate});

  final _formKey = GlobalKey<FormState>();
  final void Function(String name, String? spanishName)? onCreate;

  final _name = TextEditingController();
  final _spanishName = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      icon: const Icon(Icons.build_rounded),
      title: const Text('Create New Thing'),
      actions: [
        OutlinedButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text('Cancel'),
        ),
        ListenableBuilder(
          listenable: _name,
          builder: (context, child) => FilledButton(
            onPressed: _name.text.isNotEmpty
                ? () {
                    if (_formKey.currentState!.validate()) {
                      onCreate?.call(_name.text, _spanishName.text);
                    }
                  }
                : null,
            child: const Text('Create'),
          ),
        ),
      ],
      contentPadding: const EdgeInsets.all(16),
      content: IntrinsicWidth(
        child: Form(
          key: _formKey,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                controller: _name,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Name is required';
                  }

                  return null;
                },
                decoration: inputDecoration.copyWith(
                  labelText: 'Name',
                  constraints: const BoxConstraints(minWidth: 500),
                ),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _spanishName,
                decoration: inputDecoration.copyWith(
                  labelText: 'Name (Spanish)',
                  constraints: const BoxConstraints(minWidth: 500),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

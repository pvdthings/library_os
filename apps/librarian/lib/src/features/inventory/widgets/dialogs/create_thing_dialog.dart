import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:librarian_app/src/features/inventory/providers/find_things_by_name.dart';
import 'package:librarian_app/src/widgets/input_decoration.dart';

import '../../models/thing_model.dart';
import '../../providers/things_repository_provider.dart';

class CreateThingDialog extends ConsumerStatefulWidget {
  const CreateThingDialog({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() {
    return _CreateThingDialogState();
  }
}

class _CreateThingDialogState extends ConsumerState<CreateThingDialog> {
  final _formKey = GlobalKey<FormState>();

  final _name = TextEditingController();
  final _spanishName = TextEditingController();

  Future<List<ThingModel>>? existingMatches;

  createThing() {
    ref
        .read(thingsRepositoryProvider.notifier)
        .createThing(name: _name.text, spanishName: _spanishName.text)
        .then((value) {
      Navigator.of(context).pop();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('${value.name} created'),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      icon: const Icon(Icons.build),
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
                      createThing();
                    }
                  }
                : null,
            child: const Text('Create'),
          ),
        ),
      ],
      contentPadding: const EdgeInsets.all(16),
      content: SizedBox(
        width: 500,
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
                onChanged: (value) {
                  if (value.isEmpty || value.length < 4) {
                    setState(() => existingMatches = null);
                    return;
                  }

                  setState(() {
                    existingMatches = ref.read(findThingsByName(value));
                  });
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _spanishName,
                decoration: inputDecoration.copyWith(
                  labelText: 'Name (Spanish)',
                  constraints: const BoxConstraints(minWidth: 500),
                ),
              ),
              const SizedBox(height: 16),
              FutureBuilder(
                future: existingMatches,
                builder: (context, snapshot) {
                  final existingThingName = snapshot.data?.firstOrNull?.name;
                  if (existingMatches != null && existingThingName != null) {
                    return _ExistingThingWarning(
                      thingName: _name.text,
                      existingThingName: existingThingName,
                    );
                  }

                  return const SizedBox.shrink();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ExistingThingWarning extends StatelessWidget {
  const _ExistingThingWarning({
    required this.thingName,
    required this.existingThingName,
  });

  final String thingName;
  final String existingThingName;

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      margin: EdgeInsets.zero,
      child: ListTile(
        leading: const Icon(
          Icons.warning_rounded,
          color: Colors.amber,
        ),
        title: const Text('Thing Already Exists'),
        subtitle: Text.rich(
          TextSpan(
            children: [
              const TextSpan(text: 'A thing named '),
              TextSpan(text: thingName, style: boldTextStyle),
              const TextSpan(text: ' might already exist.\n'),
              const TextSpan(text: 'Is '),
              TextSpan(text: existingThingName, style: boldTextStyle),
              const TextSpan(text: ' the same thing?'),
            ],
          ),
        ),
      ),
    );
  }
}

const boldTextStyle = TextStyle(fontWeight: FontWeight.bold);

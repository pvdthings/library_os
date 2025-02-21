import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:librarian_app/core/models/thing_model.dart';
import 'package:librarian_app/modules/things/providers/create_thing_service.dart';
import 'package:librarian_app/modules/things/providers/find_things.dart';
import 'package:librarian_app/utils/future_signal.dart';
import 'package:librarian_app/widgets/circular_progress_icon.dart';
import 'package:librarian_app/widgets/input_decoration.dart';

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

  FutureSignal<List<ThingModel>>? existingThings;

  bool get doesNameHaveSufficientLength {
    return _name.text.length > 2;
  }

  void onCreate() {
    if (_formKey.currentState!.validate()) {
      ref.read(createThing).create(
          name: _name.text,
          spanishName: _spanishName.text,
          onFinish: () {
            Navigator.of(context).pop();
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('${_name.text} created'),
              ),
            );
          });
    }
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
            listenable: Listenable.merge([existingThings, _name]),
            builder: (context, child) {
              final isLoading = existingThings?.isLoading ?? false;
              return ValueListenableBuilder(
                valueListenable: _name,
                builder: (context, name, child) => FilledButton(
                  onPressed: isLoading || _name.text.isEmpty ? null : onCreate,
                  child: const Text('Create'),
                ),
              );
            }),
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
                onChanged: (value) {
                  if (value.length < 3) {
                    setState(() => existingThings = null);
                    return;
                  }

                  setState(() {
                    existingThings =
                        FutureSignal(ref.read(findThingsByName(value)));
                  });
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
              const SizedBox(height: 16),
              ListenableBuilder(
                  listenable: Listenable.merge([existingThings, _name]),
                  builder: (context, child) {
                    return FutureBuilder(
                      future: existingThings?.future,
                      builder: (context, snapshot) => _ExistingThingWarning(
                        thingName: _name.text,
                        existingThingName: !doesNameHaveSufficientLength
                            ? null
                            : snapshot.data?.firstOrNull?.name,
                        isLoading: existingThings?.isLoading ?? false,
                      ),
                    );
                  }),
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
    this.existingThingName,
    this.isLoading = false,
  });

  final String thingName;
  final String? existingThingName;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Card.outlined(
        clipBehavior: Clip.antiAlias,
        margin: EdgeInsets.zero,
        child: ListTile(
          title: Text('Searching...'),
          trailing: CircularProgressIcon(),
        ),
      );
    }

    if (existingThingName == null) {
      return const Card.outlined(
        clipBehavior: Clip.antiAlias,
        margin: EdgeInsets.zero,
        child: ListTile(
          title: Text('No Duplicates Found'),
        ),
      );
    }

    return Card.outlined(
      clipBehavior: Clip.antiAlias,
      margin: EdgeInsets.zero,
      child: ListTile(
        trailing: const Icon(
          Icons.warning_rounded,
          color: Colors.amber,
        ),
        title: const Text('Duplicate Thing'),
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

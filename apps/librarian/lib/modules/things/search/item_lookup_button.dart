import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:librarian_app/modules/things/providers/find_things.dart';
import 'package:librarian_app/modules/things/providers/selected_thing_provider.dart';
import 'package:librarian_app/widgets/input_decoration.dart';

class ItemLookupButton extends StatelessWidget {
  const ItemLookupButton({super.key});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () {
        showDialog(
          context: context,
          builder: (context) => const ItemLookupDialog(),
        );
      },
      icon: const Icon(Icons.numbers),
    );
  }
}

class ItemLookupDialog extends ConsumerStatefulWidget {
  const ItemLookupDialog({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() {
    return _ItemLookupDialogState();
  }
}

class _ItemLookupDialogState extends ConsumerState<ItemLookupDialog> {
  final formKey = GlobalKey<FormState>();
  final numberController = TextEditingController();

  String? errorMessage;

  void onSubmit() {
    if (formKey.currentState!.validate()) {
      search(int.parse(numberController.text));
    }
  }

  void search(int number) async {
    final things = await ref.read(findThingsByItem(number: number));

    if (things.isEmpty) {
      setState(() {
        errorMessage = 'Item #$number does not exist';
      });
      return;
    }

    ref.read(selectedThingProvider.notifier).state = things[0];
    Future.delayed(Duration.zero, () {
      Navigator.of(context).pop();
    });
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      icon: const Icon(Icons.search),
      title: const Text('Item Lookup'),
      actions: [
        OutlinedButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text('Cancel'),
        ),
        ValueListenableBuilder(
          valueListenable: numberController,
          builder: (context, name, child) => FilledButton(
            onPressed: name.text.isNotEmpty ? onSubmit : null,
            child: const Text('Look up'),
          ),
        ),
      ],
      contentPadding: const EdgeInsets.all(16),
      content: SizedBox(
        width: 500,
        child: Form(
          key: formKey,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          child: TextFormField(
            controller: numberController,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Number is required';
              }

              return null;
            },
            onChanged: (value) {
              if (value.length < 3) {
                return;
              }
            },
            onFieldSubmitted: (value) => onSubmit(),
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            decoration: inputDecoration.copyWith(
              labelText: 'Item Number',
              constraints: const BoxConstraints(minWidth: 500),
              prefixIcon: const Icon(Icons.numbers),
              errorText: errorMessage,
            ),
          ),
        ),
      ),
    );
  }
}

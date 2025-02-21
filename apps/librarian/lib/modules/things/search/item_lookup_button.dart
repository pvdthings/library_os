import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:librarian_app/core/models/item_model.dart';
import 'package:librarian_app/core/models/thing_model.dart';
import 'package:librarian_app/modules/things/providers/find_things.dart';
import 'package:librarian_app/modules/things/providers/item_details_orchestrator.dart';
import 'package:librarian_app/modules/things/providers/selected_thing_provider.dart';
import 'package:librarian_app/modules/things/providers/things_repository_provider.dart';
import 'package:librarian_app/widgets/input_decoration.dart';

class ItemLookupButton extends ConsumerWidget {
  const ItemLookupButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return IconButton(
      onPressed: () async {
        final result = await showDialog<LookupResult?>(
          context: context,
          builder: (context) => const ItemLookupDialog(),
        );

        // Load Thing and Item Details
        if (result != null) {
          ref.read(selectedThingProvider.notifier).state = result.thing;

          Future.delayed(Duration.zero, () {
            ref.read(itemDetailsOrchestrator).openItem(context,
                item: result.item, hiddenLocked: result.thing.hidden);
          });
        }
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
    final item = await ref
        .read(thingsRepositoryProvider.notifier)
        .getItem(number: number);

    if (item == null) {
      setState(() {
        errorMessage = 'Item #$number does not exist';
      });
      return;
    }

    final things = await ref.read(findThingsByItem(number: number));
    final thing = things[0];

    await Future.delayed(Duration.zero, () {
      Navigator.of(context).pop(LookupResult(item: item, thing: thing));
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
            Navigator.of(context).pop(null);
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
            autofocus: true,
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

class LookupResult {
  final ItemModel item;
  final ThingModel thing;

  LookupResult({required this.item, required this.thing});
}

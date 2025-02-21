import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:librarian_app/core/models/thing_model.dart';
import 'package:librarian_app/modules/things/providers/things_repository_provider.dart';
import 'package:librarian_app/modules/things/convert/icon.dart';

class ConvertDialog extends ConsumerStatefulWidget {
  const ConvertDialog({super.key, required this.itemId});

  final String itemId;

  @override
  ConsumerState<ConvertDialog> createState() => _ConvertDialogState();
}

class _ConvertDialogState extends ConsumerState<ConvertDialog> {
  final selectedThingId = ValueNotifier<String?>(null);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      icon: const Icon(convertIcon),
      title: const Text('Convert Item'),
      content: SizedBox(
        width: 500,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Choose a thing to convert to, then click Convert.'),
            const SizedBox(height: 16),
            FutureBuilder(
              future: ref.read(thingsRepositoryProvider),
              builder: (context, snapshot) {
                final List<ThingModel> thingOptions =
                    snapshot.connectionState != ConnectionState.done
                        ? []
                        : snapshot.data!;

                return _Autocomplete(
                  optionsBuilder: (value) {
                    if (value.text.isEmpty) {
                      return const Iterable.empty();
                    }

                    return thingOptions.where((o) => o.name
                        .toLowerCase()
                        .contains(value.text.toLowerCase()));
                  },
                  onChanged: (_) {
                    selectedThingId.value = null;
                  },
                  onSelected: (value) {
                    selectedThingId.value = value.id;
                  },
                );
              },
            ),
          ],
        ),
      ),
      actions: [
        OutlinedButton(
          onPressed: () => Navigator.of(context).pop(false),
          child: const Text('Cancel'),
        ),
        ListenableBuilder(
          listenable: selectedThingId,
          builder: (context, child) {
            return FilledButton(
              onPressed: selectedThingId.value == null
                  ? null
                  : () {
                      ref
                          .read(thingsRepositoryProvider.notifier)
                          .convertItem(widget.itemId, selectedThingId.value!)
                          .then((_) => Navigator.of(context).pop(true));
                    },
              child: const Text('Convert'),
            );
          },
        ),
      ],
    );
  }
}

class _Autocomplete extends StatelessWidget {
  const _Autocomplete({
    required this.optionsBuilder,
    required this.onChanged,
    required this.onSelected,
  });

  final FutureOr<Iterable<ThingModel>> Function(TextEditingValue)
      optionsBuilder;

  final void Function(ThingModel value)? onSelected;
  final void Function(String value)? onChanged;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (_, BoxConstraints constraints) => Autocomplete<ThingModel>(
        displayStringForOption: (option) => option.name,
        fieldViewBuilder: (context, controller, focusNode, onFieldSubmitted) {
          return TextField(
            controller: controller,
            decoration: const InputDecoration(
              hintText: 'Search...',
              labelText: 'Thing',
            ),
            focusNode: focusNode,
            onChanged: onChanged,
          );
        },
        optionsBuilder: optionsBuilder,
        optionsViewBuilder: (_, onSelected, options) {
          return Align(
            alignment: Alignment.topLeft,
            child: Material(
              elevation: 4,
              child: SizedBox(
                width: constraints.maxWidth,
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: options.length,
                  itemBuilder: (context, index) {
                    final element = options.elementAt(index);
                    return ListTile(
                      tileColor:
                          AutocompleteHighlightedOption.of(context) == index
                              ? Theme.of(context).highlightColor
                              : null,
                      onTap: () => onSelected(element),
                      title: Text(element.name),
                    );
                  },
                ),
              ),
            ),
          );
        },
        onSelected: onSelected,
      ),
    );
  }
}

Future<bool> showConvertDialog(BuildContext context, String itemId) async {
  final result = await showDialog<bool?>(
      context: context, builder: (context) => ConvertDialog(itemId: itemId));
  return result ?? false;
}

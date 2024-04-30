import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:librarian_app/src/features/inventory/providers/things_repository_provider.dart';
import 'package:librarian_app/src/features/inventory/widgets/conversion/icon.dart';

import '../../models/thing_model.dart';

class ConvertDialog extends ConsumerStatefulWidget {
  const ConvertDialog({super.key, required this.itemId});

  final String itemId;

  @override
  ConsumerState<ConvertDialog> createState() => _ConvertDialogState();
}

class _ConvertDialogState extends ConsumerState<ConvertDialog> {
  String? selectedThingId;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      icon: const Icon(convertIcon),
      title: const Text('Convert Item'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
              'Choose a thing to convert this item into, then click Convert.'),
          const SizedBox(height: 16),
          FutureBuilder(
            future: ref.read(thingsRepositoryProvider),
            builder: (context, snapshot) {
              final List<ThingModel> thingOptions =
                  snapshot.connectionState != ConnectionState.done
                      ? []
                      : snapshot.data!;

              return DropdownButtonFormField(
                hint: const Text('Choose a thing to convert to'),
                items: thingOptions
                    .map((t) => DropdownMenuItem(
                          value: t.id,
                          child: Text(t.name),
                        ))
                    .toList(),
                onChanged: (value) => setState(() {
                  selectedThingId = value;
                }),
              );
            },
          ),
        ],
      ),
      actions: [
        OutlinedButton(
          onPressed: () => Navigator.of(context).pop(false),
          child: const Text('Cancel'),
        ),
        FilledButton(
          onPressed: selectedThingId == null
              ? null
              : () {
                  ref
                      .read(thingsRepositoryProvider.notifier)
                      .convertItem(widget.itemId, selectedThingId!)
                      .then((_) => Navigator.of(context).pop(true));
                },
          child: const Text('Convert'),
        ),
      ],
    );
  }
}

Future<bool> showConvertDialog(BuildContext context, String itemId) async {
  final result = await showDialog<bool?>(
      context: context, builder: (context) => ConvertDialog(itemId: itemId));
  return result ?? false;
}

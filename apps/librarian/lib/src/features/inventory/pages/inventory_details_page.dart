import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:librarian_app/src/features/inventory/providers/thing_details_controller_provider.dart';
import 'package:librarian_app/src/features/inventory/providers/thing_details_provider.dart';

import '../providers/edited_thing_details_providers.dart';
import '../widgets/inventory_details/inventory_details.dart';

class InventoryDetailsPage extends ConsumerWidget {
  const InventoryDetailsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final thingDetails = ref.watch(thingDetailsProvider);

    return FutureBuilder(
      future: thingDetails,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return errorScaffold(snapshot.error.toString());
        }

        if (!snapshot.hasData) {
          return loadingScaffold;
        }

        final thingDetails = snapshot.data!;
        final hasUnsavedChanges = ref.watch(unsavedChangesProvider);

        void discardChanges() async {
          ref.read(thingDetailsEditorProvider).discardChanges();
        }

        Future<void> save() async {
          await ref.read(thingDetailsEditorProvider).save();
        }

        Future<void> delete() async {
          await ref.read(thingDetailsControllerProvider).delete(context);
        }

        return Scaffold(
          appBar: AppBar(
            title: Text(thingDetails.name),
            actions: [
              IconButton(
                onPressed: hasUnsavedChanges ? save : null,
                icon: const Icon(Icons.save),
              ),
              IconButton(
                onPressed: hasUnsavedChanges ? discardChanges : null,
                icon: const Icon(Icons.cancel),
              ),
            ],
          ),
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  const InventoryDetails(),
                  const SizedBox(height: 24),
                  FilledButton.icon(
                    onPressed: delete,
                    icon: const Icon(Icons.delete_forever_outlined),
                    label: const Text('Delete Thing'),
                    style: FilledButton.styleFrom(
                      backgroundColor: Colors.red,
                      foregroundColor: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

Scaffold errorScaffold(String error) {
  return Scaffold(
    body: Center(
      child: Text(error),
    ),
  );
}

const loadingScaffold = Scaffold(
  body: Center(
    child: CircularProgressIndicator(),
  ),
);

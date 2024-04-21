import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:librarian_app/src/features/inventory/providers/thing_details_controller_provider.dart';
import 'package:librarian_app/src/widgets/dialogs/save_dialog.dart';
import 'package:librarian_app/src/features/dashboard/widgets/panes/pane_header.widget.dart';
import 'package:librarian_app/src/features/inventory/models/detailed_thing_model.dart';
import 'package:librarian_app/src/features/inventory/providers/edited_thing_details_providers.dart';
import 'package:librarian_app/src/features/inventory/providers/selected_thing_provider.dart';
import 'package:librarian_app/src/features/inventory/providers/thing_details_provider.dart';
import 'package:librarian_app/src/features/inventory/widgets/inventory_details/inventory_details.dart';

class InventoryDetailsPane extends ConsumerWidget {
  const InventoryDetailsPane({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedThing = ref.watch(selectedThingProvider);
    final thingDetails = ref.watch(thingDetailsProvider);

    void discardChanges() {
      ref.read(thingDetailsEditorProvider).discardChanges();
    }

    Future<void> save() async {
      if (await showSaveDialog(context)) {
        await ref.read(thingDetailsEditorProvider).save();
      }
    }

    Future<void> delete() async {
      await ref.read(thingDetailsControllerProvider).delete(context);
    }

    return Card(
      clipBehavior: Clip.antiAlias,
      child: selectedThing == null
          ? const Center(child: Text('Inventory Details'))
          : FutureBuilder<DetailedThingModel?>(
              future: thingDetails,
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return Center(child: Text(snapshot.error.toString()));
                }

                if (!snapshot.hasData) {
                  return const Center(child: CircularProgressIndicator());
                }

                final thingDetails = snapshot.data!;
                final hasUnsavedChanges = ref.watch(unsavedChangesProvider);

                return Column(
                  children: [
                    PaneHeader(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            thingDetails.name,
                            style: const TextStyle(fontSize: 24),
                          ),
                          Row(
                            children: [
                              if (hasUnsavedChanges) ...[
                                Text(
                                  'Unsaved Changes',
                                  style: Theme.of(context)
                                      .textTheme
                                      .labelMedium!
                                      .copyWith(
                                        color: Colors.white.withOpacity(0.8),
                                        fontStyle: FontStyle.italic,
                                      ),
                                ),
                                const SizedBox(width: 8),
                              ],
                              IconButton(
                                onPressed: hasUnsavedChanges ? save : null,
                                icon: const Icon(Icons.save_rounded),
                                tooltip: 'Save',
                              ),
                              const SizedBox(width: 4),
                              IconButton(
                                onPressed:
                                    hasUnsavedChanges ? discardChanges : null,
                                icon: const Icon(Icons.cancel),
                                tooltip: 'Discard Changes',
                              ),
                              SizedBox(
                                height: 24,
                                width: 24,
                                child: VerticalDivider(
                                  color: Colors.white.withOpacity(0.3),
                                ),
                              ),
                              IconButton(
                                onPressed: delete,
                                icon: const Icon(Icons.delete_forever),
                                tooltip: 'Delete Thing',
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                    const Expanded(
                      child: SingleChildScrollView(
                        child: Padding(
                          padding: EdgeInsets.all(16),
                          child: InventoryDetails(),
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
    );
  }
}

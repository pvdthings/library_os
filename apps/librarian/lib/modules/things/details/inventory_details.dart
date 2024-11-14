import 'package:file_picker/_internal/file_picker_web.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:librarian_app/core/api/models/detailed_thing_model.dart';
import 'package:librarian_app/modules/things/details/inventory/create_items/create_items_dialog.dart';
import 'package:librarian_app/modules/things/details/thing_details/thing_details_card.dart';
import 'package:librarian_app/core/api/models/updated_image_model.dart';
import 'package:librarian_app/modules/things/providers/edited_thing_details_providers.dart';
import 'package:librarian_app/modules/things/providers/item_details_orchestrator.dart';
import 'package:librarian_app/modules/things/providers/selected_thing_provider.dart';
import 'package:librarian_app/modules/things/providers/thing_details_provider.dart';
import 'package:librarian_app/modules/things/providers/things_repository_provider.dart';
import 'package:librarian_app/modules/things/details/categories/categories_card.dart';
import 'package:librarian_app/modules/things/details/inventory/items_card.dart';
import 'package:librarian_app/modules/things/details/image/thing_image_card.dart';
import 'package:librarian_app/widgets/skeleton.dart';

import 'linked_things/card.dart';

class InventoryDetails extends ConsumerWidget {
  const InventoryDetails({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final detailsFuture = ref.watch(thingDetailsProvider);

    return FutureBuilder(
      future: detailsFuture,
      builder: (context, snapshot) {
        final details = snapshot.data;

        return Skeleton(
          enabled: snapshot.connectionState == ConnectionState.waiting,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Wrap(
                spacing: 16,
                runSpacing: 32,
                children: [
                  ThingImageCard(
                    width: 240,
                    height: 240,
                    imageUrl: ref.watch(imageUploadProvider) != null
                        ? null
                        : details?.images.firstOrNull?.url,
                    imageBytes: ref.watch(imageUploadProvider)?.bytes,
                    onRemove: () {
                      ref.read(imageUploadProvider.notifier).state =
                          const UpdatedImageModel(type: null, bytes: null);
                    },
                    onReplace: () async {
                      FilePickerResult? result = await FilePickerWeb.platform
                          .pickFiles(type: FileType.image);
                      if (result != null) {
                        ref.read(imageUploadProvider.notifier).state =
                            UpdatedImageModel(
                          type: result.files.single.extension,
                          bytes: result.files.single.bytes,
                        );
                      }
                    },
                  ),
                  ThingDetailsCard(
                    details: details ??
                        DetailedThingModel(
                          id: '',
                          name: 'Something',
                          categories: ['Category', 'Category'],
                          linkedThings: [],
                          images: [],
                          items: [],
                          hidden: false,
                          eyeProtection: false,
                          stock: 1,
                          available: 1,
                        ),
                  ),
                ],
              ),
              const SizedBox(height: 32),
              const Wrap(
                spacing: 16,
                runSpacing: 32,
                children: [
                  CategoriesCard(),
                  LinkedThingsCard(),
                ],
              ),
              const SizedBox(height: 32),
              ItemsCard(
                items: details?.items ?? [],
                availableItemsCount: details?.available ?? 0,
                onTap: (item) => ref.read(itemDetailsOrchestrator).openItem(
                    context,
                    item: item,
                    hiddenLocked: details?.hidden ?? false),
                onAddItemsPressed: () {
                  showDialog(
                    context: context,
                    builder: (context) => CreateItemsDialog(
                      thing: ref.read(selectedThingProvider)!,
                    ),
                  );
                },
                onToggleHidden: details?.hidden == true
                    ? null
                    : (id, value) async {
                        await ref
                            .read(thingsRepositoryProvider.notifier)
                            .updateItem(id, hidden: value);
                      },
              ),
            ],
          ),
        );
      },
    );
  }
}

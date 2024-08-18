import 'package:file_picker/_internal/file_picker_web.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:librarian_app/dashboard/providers/end_drawer_provider.dart';
import 'package:librarian_app/modules/things/details/inventory/create_items/create_items_dialog.dart';
import 'package:librarian_app/modules/things/details/inventory/item_details/drawer.dart';
import 'package:librarian_app/modules/things/details/thing_details/thing_details_card.dart';
import 'package:librarian_app/core/api/models/updated_image_model.dart';
import 'package:librarian_app/modules/things/details/inventory/item_details_page.dart';
import 'package:librarian_app/modules/things/providers/edited_thing_details_providers.dart';
import 'package:librarian_app/modules/things/providers/selected_thing_provider.dart';
import 'package:librarian_app/modules/things/providers/thing_details_provider.dart';
import 'package:librarian_app/modules/things/providers/things_repository_provider.dart';
import 'package:librarian_app/modules/things/details/categories/categories_card.dart';
import 'package:librarian_app/modules/things/details/inventory/items_card.dart';
import 'package:librarian_app/modules/things/details/image/thing_image_card.dart';
import 'package:librarian_app/utils/media_query.dart';

import 'inventory/item_details/item_details_controller.dart';

class InventoryDetails extends ConsumerWidget {
  const InventoryDetails({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final detailsFuture = ref.watch(thingDetailsProvider);

    return FutureBuilder(
      future: detailsFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        final details = snapshot.data!;

        return Column(
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
                      : details.images.firstOrNull?.url,
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
                ThingDetailsCard(details: details),
              ],
            ),
            const SizedBox(height: 32),
            const CategoriesCard(),
            const SizedBox(height: 32),
            ItemsCard(
              items: details.items,
              availableItemsCount: details.available,
              onTap: (item) {
                if (isMobile(context)) {
                  Navigator.of(context)
                      .push(MaterialPageRoute(builder: (context) {
                    return ItemDetailsPage(
                      item: item,
                      hiddenLocked: details.hidden,
                    );
                  }));
                  return;
                }

                final detailsController = ItemDetailsController(
                  item: item,
                  repository: ref.read(thingsRepositoryProvider.notifier),
                  onSave: () {
                    // setState(() => _isLoading = true);
                  },
                  onSaveComplete: () {
                    // setState(() => _isLoading = false);
                  },
                );

                ref.read(endDrawerProvider).openEndDrawer(
                      context,
                      ItemDetailsDrawer(
                        controller: detailsController,
                        isHiddenLocked: details.hidden,
                      ),
                    );
              },
              onAddItemsPressed: () {
                showDialog(
                  context: context,
                  builder: (context) => CreateItemsDialog(
                    thing: ref.read(selectedThingProvider)!,
                  ),
                );
              },
              onToggleHidden: details.hidden
                  ? null
                  : (id, value) async {
                      await ref
                          .read(thingsRepositoryProvider.notifier)
                          .updateItem(id, hidden: value);
                    },
            ),
          ],
        );
      },
    );
  }
}

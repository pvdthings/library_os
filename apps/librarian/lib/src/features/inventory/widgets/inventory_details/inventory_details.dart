import 'package:file_picker/_internal/file_picker_web.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:librarian_app/src/features/inventory/widgets/inventory_details/items/create_items/create_items_dialog.dart';
import 'package:librarian_app/src/widgets/fields/checkbox_field.dart';
import 'package:librarian_app/src/widgets/input_decoration.dart';
import 'package:librarian_app/src/features/inventory/models/updated_image_model.dart';
import 'package:librarian_app/src/features/inventory/pages/item_details_page.dart';
import 'package:librarian_app/src/features/inventory/providers/edited_thing_details_providers.dart';
import 'package:librarian_app/src/features/inventory/providers/selected_thing_provider.dart';
import 'package:librarian_app/src/features/inventory/providers/thing_details_provider.dart';
import 'package:librarian_app/src/features/inventory/providers/things_repository_provider.dart';
import 'package:librarian_app/src/features/inventory/widgets/inventory_details/categories_card.dart';
import 'package:librarian_app/src/features/inventory/widgets/inventory_details/items/item_details/item_details_dialog.dart';
import 'package:librarian_app/src/features/inventory/widgets/inventory_details/items/items_card.dart';
import 'package:librarian_app/src/features/inventory/widgets/inventory_details/thing_image_card/thing_image_card.dart';
import 'package:librarian_app/src/utils/media_query.dart';

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
          crossAxisAlignment: CrossAxisAlignment.start,
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
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextField(
                      controller: TextEditingController(text: details.name),
                      decoration: inputDecoration.copyWith(labelText: 'Name'),
                      onChanged: (value) =>
                          ref.read(nameProvider.notifier).state = value,
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller:
                          TextEditingController(text: details.spanishName),
                      decoration:
                          inputDecoration.copyWith(labelText: 'Name (Spanish)'),
                      onChanged: (value) =>
                          ref.read(spanishNameProvider.notifier).state = value,
                    ),
                    const SizedBox(height: 32),
                    CheckboxField(
                      title: 'Hidden',
                      value: ref.watch(hiddenProvider) ?? details.hidden,
                      onChanged: (bool? value) {
                        ref.read(hiddenProvider.notifier).state =
                            value ?? false;
                      },
                    ),
                    const SizedBox(height: 32),
                    CheckboxField(
                      title: 'Eye Protection Required',
                      value: ref.watch(eyeProtectionProvider) ??
                          details.eyeProtection,
                      onChanged: (bool? value) {
                        ref.read(eyeProtectionProvider.notifier).state =
                            value ?? false;
                      },
                    ),
                  ],
                ),
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

                showDialog(
                  context: context,
                  builder: (context) {
                    return ItemDetailsDialog(
                      item: item,
                      hiddenLocked: details.hidden,
                    );
                  },
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

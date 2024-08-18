import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:librarian_app/modules/things/details/inventory/item_details/item_details_controller.dart';
import 'package:librarian_app/modules/things/details/inventory/item_manuals_card.dart';
import 'package:librarian_app/modules/things/details/image/thing_image_card.dart';
import 'package:librarian_app/core/api/models/item_model.dart';
import 'package:librarian_app/utils/media_query.dart';

import '../../../convert/icon.dart';

class ItemDetails extends ConsumerWidget {
  const ItemDetails({
    super.key,
    required this.controller,
    required this.item,
    required this.isThingHidden,
  });

  final ItemDetailsController controller;
  final ItemModel item;
  final bool isThingHidden;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ListenableBuilder(
      listenable: controller,
      builder: (context, _) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.max,
          children: [
            ThingImageCard(
              imageUrl: controller.existingImageUrl,
              imageBytes: controller.uploadedImageBytes,
              height: 240,
              onRemove: controller.removeImage,
              onReplace: controller.replaceImage,
              useNewDesign: true,
            ),
            const SizedBox(height: 32),
            Card(
              clipBehavior: Clip.antiAlias,
              elevation: isMobile(context) ? 1 : 0,
              margin: EdgeInsets.zero,
              child: _HiddenCheckboxListTile(
                isThingHidden: isThingHidden,
                isManagedByPartner: item.isManagedByPartner,
                value: controller.hiddenNotifier.value,
                onChanged: (value) {
                  controller.hiddenNotifier.value = value ?? false;
                },
              ),
            ),
            const SizedBox(height: 32),
            Card(
              clipBehavior: Clip.antiAlias,
              elevation: isMobile(context) ? 1 : 0,
              margin: EdgeInsets.zero,
              child: Column(
                children: [
                  const ListTile(
                    leading: Icon(Icons.data_array),
                    title: Text('Details'),
                    visualDensity: VisualDensity.comfortable,
                  ),
                  const Divider(height: 1),
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        TextFormField(
                          readOnly: true,
                          controller: controller.nameController,
                          decoration: InputDecoration(
                            labelText: 'Thing',
                            suffix: Tooltip(
                              message: 'Convert',
                              child: IconButton(
                                onPressed: () {
                                  controller.convertThing(context);
                                },
                                icon: const Icon(convertIcon),
                              ),
                            ),
                          ),
                          enabled: !controller.isLoading,
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          controller: controller.brandController,
                          decoration: const InputDecoration(
                            labelText: 'Brand',
                            hintText: 'Generic',
                          ),
                          enabled: !controller.isLoading,
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          controller: controller.descriptionController,
                          decoration: const InputDecoration(
                            labelText: 'Description',
                          ),
                          enabled: !controller.isLoading,
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          controller: controller.estimatedValueController,
                          decoration: const InputDecoration(
                            labelText: 'Estimated Value (\$)',
                            prefixText: '\$ ',
                          ),
                          enabled: !controller.isLoading,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly
                          ],
                          keyboardType: TextInputType.number,
                        ),
                        const SizedBox(height: 16),
                        DropdownButtonFormField<String?>(
                          decoration: const InputDecoration(
                            labelText: 'Condition',
                          ),
                          items: controller.isLoading
                              ? null
                              : const [
                                  DropdownMenuItem(
                                    value: null,
                                    child: Text('None'),
                                  ),
                                  DropdownMenuItem(
                                    value: 'Like New',
                                    child: Text('Like New'),
                                  ),
                                  DropdownMenuItem(
                                    value: 'Lightly Used',
                                    child: Text('Lightly Used'),
                                  ),
                                  DropdownMenuItem(
                                    value: 'Heavily Used',
                                    child: Text('Heavily Used'),
                                  ),
                                  DropdownMenuItem(
                                    value: 'Damaged',
                                    child: Text('Damaged'),
                                  ),
                                ],
                          onChanged: (value) {
                            controller.conditionNotifier.value = value;
                          },
                          value: controller.conditionNotifier.value,
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          decoration: const InputDecoration(
                            labelText: 'Location',
                          ),
                          enabled: false,
                          initialValue: controller.item?.location,
                          readOnly: true,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),
            ItemManualsCard(
              manuals: controller.manualsNotifier.value,
              onAdd: () async {
                controller.addManual();
              },
              onRemove: (index) {
                controller.removeManual(index);
              },
            ),
          ],
        );
      },
    );
  }
}

class _HiddenCheckboxListTile extends StatelessWidget {
  const _HiddenCheckboxListTile({
    required this.isThingHidden,
    required this.isManagedByPartner,
    required this.value,
    required this.onChanged,
  });

  final bool isThingHidden;
  final bool isManagedByPartner;
  final bool? value;
  final void Function(bool?) onChanged;

  @override
  Widget build(BuildContext context) {
    return Builder(
      builder: (context) {
        if (isThingHidden) {
          return const CheckboxListTile(
            title: Text('Hidden'),
            subtitle:
                Text('Unable to unhide because the parent thing is hidden.'),
            secondary: Icon(Icons.visibility_off_outlined),
            value: true,
            onChanged: null,
          );
        }

        if (isManagedByPartner) {
          return const CheckboxListTile(
            title: Text('Hidden'),
            subtitle: Text(
                'Unable to unhide because this item is at a partner location.'),
            secondary: Icon(Icons.visibility_off_outlined),
            value: true,
            onChanged: null,
          );
        }

        return CheckboxListTile(
          title: const Text('Hidden'),
          secondary: value == true
              ? const Icon(Icons.visibility_off_outlined)
              : const Icon(Icons.visibility_outlined),
          value: value,
          onChanged: onChanged,
        );
      },
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:librarian_app/modules/things/details/inventory/item_details/condition_dropdown.dart';
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

  get _isItemDamaged {
    final condition = controller.conditionNotifier.value;
    return ConditionDropdown.isDamagedCondition(condition);
  }

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
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: ConditionDropdown(
                      editable: !controller.isLoading,
                      onChanged: (option) {
                        controller.conditionNotifier.value = option?.value;

                        // Some conditions are also treated as "hidden"
                        if (option?.hidden == true) {
                          controller.hiddenNotifier.value = true;
                        } else {
                          controller.hiddenNotifier.value = item.hidden;
                        }
                      },
                      value: controller.conditionNotifier.value,
                    ),
                  ),
                  const Divider(height: 1),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: TextFormField(
                      controller: controller.notesController,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: 'Needs a new part installed.',
                        labelText: 'Notes',
                      ),
                      enabled: !controller.isLoading,
                      maxLines: 128,
                      minLines: 3,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),
            Card(
              clipBehavior: Clip.antiAlias,
              elevation: isMobile(context) ? 1 : 0,
              margin: EdgeInsets.zero,
              child: _HiddenCheckboxListTile(
                isItemDamaged: _isItemDamaged,
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
                            border: const OutlineInputBorder(),
                            labelText: 'Thing',
                            suffixIcon: Padding(
                              padding: const EdgeInsets.only(right: 8),
                              child: Tooltip(
                                message: 'Convert',
                                child: IconButton(
                                  onPressed: () {
                                    controller.convertThing(context);
                                  },
                                  icon: const Icon(convertIcon),
                                ),
                              ),
                            ),
                          ),
                          enabled: !controller.isLoading,
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          controller: controller.brandController,
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: 'Brand',
                            hintText: 'Generic',
                          ),
                          enabled: !controller.isLoading,
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          controller: controller.estimatedValueController,
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
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
                        TextFormField(
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
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
    required this.isItemDamaged,
    required this.isThingHidden,
    required this.isManagedByPartner,
    required this.value,
    required this.onChanged,
  });

  final bool isItemDamaged;
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

        if (isItemDamaged) {
          return const CheckboxListTile(
            title: Text('Hidden'),
            subtitle: Text(
                'Unable to unhide because this item is not in working condition.'),
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

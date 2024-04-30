import 'package:flutter/material.dart';
import 'package:librarian_app/src/features/inventory/widgets/inventory_details/items/item_details/item_details_controller.dart';

import '../conversion/icon.dart';
import '../inventory_details/items/item_details/item_details.dart';

class ItemDetailsDrawer extends StatelessWidget {
  const ItemDetailsDrawer({
    super.key,
    required this.controller,
    this.isHiddenLocked = false,
  });

  final ItemDetailsController controller;
  final bool isHiddenLocked;

  @override
  Widget build(BuildContext context) {
    return Drawer(
      width: 500,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '#${controller.item!.number}',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                Tooltip(
                  message: 'Convert',
                  child: IconButton.filled(
                    onPressed: () {
                      if (controller.convertThing(context)) {
                        Scaffold.of(context).closeEndDrawer();
                        // TODO: show snackbar
                      }
                    },
                    icon: const Icon(convertIcon),
                  ),
                ),
              ],
            ),
          ),
          const Divider(height: 1),
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: ItemDetails(
                  controller: controller,
                  item: controller.item!,
                  hiddenLocked: isHiddenLocked,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

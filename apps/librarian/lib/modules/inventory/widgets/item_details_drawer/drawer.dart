import 'package:flutter/material.dart';
import 'package:librarian_app/modules/inventory/widgets/inventory_details/items/item_details/item_details_controller.dart';
import 'package:librarian_app/widgets/filled_progress_button.dart';

import '../inventory_details/items/item_details/item_details.dart';

class ItemDetailsDrawer extends StatefulWidget {
  const ItemDetailsDrawer({
    super.key,
    required this.controller,
    this.isHiddenLocked = false,
  });

  final ItemDetailsController controller;
  final bool isHiddenLocked;

  @override
  State<ItemDetailsDrawer> createState() => _ItemDetailsDrawerState();
}

class _ItemDetailsDrawerState extends State<ItemDetailsDrawer> {
  final menuController = MenuController();

  bool isLoading = false;

  convert() {
    widget.controller.convertThing(context);
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      width: 500,
      child: Stack(
        children: [
          Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '#${widget.controller.item!.number}',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    MenuAnchor(
                      controller: menuController,
                      menuChildren: [
                        MenuItemButton(
                          onPressed: convert,
                          leadingIcon: const Icon(Icons.transform),
                          child: const Text('Convert'),
                        ),
                      ],
                      child: IconButton.filled(
                        onPressed: () => menuController.open(),
                        icon: const Icon(Icons.more_vert),
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
                    child: Column(
                      children: [
                        ItemDetails(
                          controller: widget.controller,
                          item: widget.controller.item!,
                          hiddenLocked: widget.isHiddenLocked,
                        ),
                        const SizedBox(height: 80),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              color: Theme.of(context).colorScheme.surface.withAlpha(180),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    ListenableBuilder(
                      listenable: widget.controller,
                      builder: (context, child) {
                        if (!widget.controller.hasUnsavedChanges) {
                          return child!;
                        }

                        return OutlinedButton(
                          onPressed: () {
                            widget.controller.discardChanges();
                          },
                          child: const Text('Discard'),
                        );
                      },
                      child: OutlinedButton(
                        onPressed: () => Navigator.of(context).pop(),
                        child: const Text('Cancel'),
                      ),
                    ),
                    const SizedBox(width: 8),
                    ListenableBuilder(
                      listenable: widget.controller,
                      builder: (_, __) {
                        return FilledProgressButton(
                          onPressed: widget.controller.saveChanges,
                          isLoading: isLoading,
                          child: const Text('Save'),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

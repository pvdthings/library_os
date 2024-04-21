import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:librarian_app/src/features/inventory/providers/things_repository_provider.dart';
import 'package:librarian_app/src/features/inventory/widgets/inventory_details/items/item_details/item_details_controller.dart';
import 'package:librarian_app/src/widgets/filled_progress_button.dart';
import 'package:librarian_app/src/features/inventory/models/item_model.dart';
import 'package:librarian_app/src/features/inventory/widgets/inventory_details/items/item_details/item_details.dart';

class ItemDetailsDialog extends ConsumerStatefulWidget {
  const ItemDetailsDialog({
    super.key,
    required this.item,
    required this.hiddenLocked,
  });

  final ItemModel item;
  final bool hiddenLocked;

  @override
  ConsumerState<ItemDetailsDialog> createState() => _ItemDetailsDialogState();
}

class _ItemDetailsDialogState extends ConsumerState<ItemDetailsDialog> {
  late ItemDetailsController _controller;

  @override
  void initState() {
    super.initState();
    _controller = createController();
  }

  ItemDetailsController createController() {
    return ItemDetailsController(
      item: widget.item,
      repository: ref.read(thingsRepositoryProvider.notifier),
      onSave: () {
        setState(() => _isLoading = true);
      },
      onSaveComplete: () {
        setState(() => _isLoading = false);
      },
    );
  }

  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      scrollable: true,
      actions: [
        ListenableBuilder(
          listenable: _controller,
          builder: (context, child) {
            if (!_controller.hasUnsavedChanges) {
              return child!;
            }

            return OutlinedButton(
              onPressed: () {
                setState(() => _controller = createController());
              },
              child: const Text('Discard'),
            );
          },
          child: OutlinedButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
        ),
        ListenableBuilder(
          listenable: _controller,
          builder: (_, __) {
            return FilledProgressButton(
              onPressed: _controller.saveChanges,
              isLoading: _isLoading,
              child: const Text('Save'),
            );
          },
        ),
      ],
      clipBehavior: Clip.antiAlias,
      title: Text(
        '#${widget.item.number} ${widget.item.name}',
        style: Theme.of(context).textTheme.titleLarge,
      ),
      content: Container(
        constraints: const BoxConstraints(minWidth: 500),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: ItemDetails(
            controller: _controller,
            item: widget.item,
            hiddenLocked: widget.hiddenLocked,
          ),
        ),
      ),
    );
  }
}

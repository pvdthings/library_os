import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:librarian_app/src/features/inventory/providers/things_repository_provider.dart';
import 'package:librarian_app/src/features/inventory/widgets/inventory_details/items/create_items/create_items.dart';
import 'package:librarian_app/src/features/inventory/widgets/inventory_details/items/create_items/create_items_controller.dart';
import 'package:librarian_app/src/widgets/filled_progress_button.dart';

import '../../../../models/thing_model.dart';

class CreateItemsDialog extends ConsumerStatefulWidget {
  const CreateItemsDialog({super.key, required this.thing});

  final ThingModel thing;

  @override
  ConsumerState<CreateItemsDialog> createState() => _CreateItemsDialogState();
}

class _CreateItemsDialogState extends ConsumerState<CreateItemsDialog> {
  late CreateItemsController _controller;

  @override
  void initState() {
    super.initState();
    _controller = createController();
  }

  CreateItemsController createController() {
    return CreateItemsController(
      thing: widget.thing,
      repository: ref.read(thingsRepositoryProvider.notifier),
      onSave: () {
        setState(() => _isLoading = true);
      },
      onSaveComplete: () {
        Navigator.of(context).pop();
      },
    );
  }

  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      scrollable: true,
      actions: [
        OutlinedButton(
          onPressed: _isLoading ? null : () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        ListenableBuilder(
          listenable: _controller,
          builder: (_, __) {
            return FilledProgressButton(
              onPressed: _controller.saveChanges,
              isLoading: _isLoading,
              child: const Text('Create'),
            );
          },
        ),
      ],
      clipBehavior: Clip.antiAlias,
      title: Text('Create ${widget.thing.name} items'),
      content: Container(
        constraints: const BoxConstraints(minWidth: 500),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: CreateItems(
            controller: _controller,
            thing: widget.thing,
          ),
        ),
      ),
    );
  }
}

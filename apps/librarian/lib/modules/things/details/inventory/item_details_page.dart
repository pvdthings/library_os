import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:librarian_app/modules/things/providers/things_repository_provider.dart';
import 'package:librarian_app/modules/things/details/inventory/item_details/item_details.dart';
import 'package:librarian_app/modules/things/details/inventory/item_details/item_details_controller.dart';

import '../../../../core/api/models/item_model.dart';

class ItemDetailsPage extends ConsumerStatefulWidget {
  const ItemDetailsPage({
    super.key,
    required this.item,
    required this.hiddenLocked,
  });

  final ItemModel item;
  final bool hiddenLocked;

  @override
  ConsumerState<ItemDetailsPage> createState() => _ItemDetailsPageState();
}

class _ItemDetailsPageState extends ConsumerState<ItemDetailsPage> {
  late final _controller = ItemDetailsController(
    item: widget.item,
    repository: ref.read(thingsRepositoryProvider.notifier),
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('#${widget.item.number}'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: ItemDetails(
            controller: _controller,
            item: widget.item,
            isThingHidden: widget.hiddenLocked,
          ),
        ),
      ),
      floatingActionButton: ListenableBuilder(
        listenable: _controller,
        builder: (_, __) {
          return _FloatingActionSaveButton(
            onPressed: _controller.saveChanges,
          );
        },
      ),
    );
  }
}

class _FloatingActionSaveButton extends ConsumerWidget {
  const _FloatingActionSaveButton({
    this.onPressed,
  });

  final void Function()? onPressed;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Visibility(
      visible: onPressed != null,
      child: FloatingActionButton(
        onPressed: onPressed,
        child: const Icon(Icons.save),
      ),
    );
  }
}

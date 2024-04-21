import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:librarian_app/src/features/inventory/data/inventory_repository.dart';
import 'package:librarian_app/src/features/inventory/models/item_model.dart';

class ConnectedThingSearchField extends StatelessWidget {
  final ThingSearchController controller;

  ConnectedThingSearchField({
    super.key,
    required this.controller,
  });

  final _textController = TextEditingController();

  bool get isLoading => controller.isLoading;

  void _submit() {
    if (_textController.text.isEmpty) {
      return;
    }

    controller.search(_textController.text);
    _textController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: _textController,
      onSubmitted: (_) => _submit(),
      decoration: InputDecoration(
        hintText: 'Enter Thing Number',
        prefixIcon: const Icon(Icons.numbers),
        suffixIcon: IconButton(
          tooltip: 'Add Thing',
          onPressed: () => _submit(),
          icon: const Icon(Icons.add_rounded),
        ),
      ),
      inputFormatters: [
        FilteringTextInputFormatter.digitsOnly,
      ],
    );
  }
}

class ThingSearchController {
  final BuildContext context;
  final InventoryRepository repository;
  final void Function(ItemModel) onMatchFound;

  bool isLoading = false;

  ThingSearchController({
    required this.context,
    required this.repository,
    required this.onMatchFound,
  });

  Future<void> search(String value) async {
    isLoading = true;
    final match = await repository.getItem(number: int.parse(value));
    isLoading = false;

    if (match != null) {
      if (!match.available) {
        _showThingCheckedOutDialog(match);
      } else {
        onMatchFound(match);
      }
    } else {
      _showUnknownThingDialog(value);
    }
  }

  void _showThingCheckedOutDialog(ItemModel thing) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Thing Unavailable"),
          content: Text(
              "Thing #${thing.number} is checked out or not available for lending."),
          actions: [
            TextButton(
              child: const Text("OK"),
              onPressed: () => Navigator.pop(context),
            )
          ],
        );
      },
    );
  }

  void _showUnknownThingDialog(String searchValue) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Thing #$searchValue does not exist"),
          content: const Text("Try another number."),
          actions: [
            TextButton(
              child: const Text("OK"),
              onPressed: () => Navigator.pop(context),
            )
          ],
        );
      },
    );
  }
}

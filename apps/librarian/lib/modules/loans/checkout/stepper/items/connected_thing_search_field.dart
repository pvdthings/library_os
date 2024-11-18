import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:librarian_app/core/data/inventory_repository.dart';
import 'package:librarian_app/core/api/models/item_model.dart';

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
    return ListenableBuilder(
        listenable: controller,
        builder: (context, child) {
          return TextField(
            controller: _textController,
            onSubmitted: (_) => _submit(),
            decoration: InputDecoration(
              errorText: controller.errorText,
              hintText: 'Enter Item Number',
              prefixIcon: const Icon(Icons.numbers),
              suffixIcon: IconButton(
                tooltip: 'Add Item',
                onPressed: () => _submit(),
                icon: const Icon(Icons.add_rounded),
              ),
            ),
            inputFormatters: [
              FilteringTextInputFormatter.digitsOnly,
            ],
          );
        });
  }
}

class ThingSearchController extends ChangeNotifier {
  final BuildContext context;
  final List<ItemModel> items;
  final InventoryRepository repository;
  final void Function(ItemModel) onMatchFound;

  bool isLoading = false;

  String? errorText;

  ThingSearchController({
    required this.context,
    required this.items,
    required this.repository,
    required this.onMatchFound,
  });

  Future<void> search(String value) async {
    final itemNumber = int.parse(value);

    if (items.any((t) => t.number == itemNumber)) {
      errorText = '#$value is already added to this loan.';
      notifyListeners();
      return;
    }

    isLoading = true;
    final match = await repository.getItem(number: itemNumber);
    isLoading = false;

    if (match == null) {
      errorText = '#$value could not be found.';
      notifyListeners();
      return;
    }

    if (!match.available) {
      errorText = '#$value is unavailable.';
      notifyListeners();
      return;
    }

    onMatchFound(match);
  }
}

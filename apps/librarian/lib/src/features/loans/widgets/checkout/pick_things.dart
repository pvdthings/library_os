import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:librarian_app/src/features/inventory/models/item_model.dart';
import 'package:librarian_app/src/features/inventory/providers/things_repository_provider.dart';

import '../../../../widgets/fields/submit_text_field.dart';
import 'thing_list_tile.dart';

class PickThingsView extends ConsumerStatefulWidget {
  const PickThingsView({
    super.key,
    required this.pickedThings,
    required this.onThingPicked,
  });

  final List<ItemModel> pickedThings;
  final Function(ItemModel thing) onThingPicked;

  @override
  ConsumerState<PickThingsView> createState() => _PickThingsViewState();
}

class _PickThingsViewState extends ConsumerState<PickThingsView> {
  final _searchController = TextEditingController();
  bool _isLoading = false;

  Future<void> _onSearchSubmitted(String value) async {
    setState(() => _isLoading = true);

    final thingsRepository = ref.read(thingsRepositoryProvider.notifier);
    final match = await thingsRepository.getItem(number: int.parse(value));

    setState(() => _isLoading = false);

    if (match != null) {
      if (!match.available) {
        _showThingCheckedOutDialog(match);
      } else {
        widget.onThingPicked(match);
      }
    } else {
      _showUnknownThingDialog(value);
    }

    _searchController.clear();
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

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    final pickedThings = widget.pickedThings;
    pickedThings.sort((a, b) => a.number.compareTo(b.number));

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: SubmitTextField(
            labelText: "Thing ID",
            prefixIcon: const Icon(Icons.search),
            controller: _searchController,
            keyboardType: TextInputType.number,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            onSubmitted: _onSearchSubmitted,
            onChanged: (_) => {},
          ),
        ),
        pickedThings.isNotEmpty
            ? ListView.builder(
                itemCount: pickedThings.length,
                itemBuilder: (context, index) {
                  final thing = pickedThings[index];

                  return ThingListTile(
                    number: thing.number,
                    name: thing.name,
                    available: thing.available,
                    selected: true,
                    onTap: () => widget.onThingPicked(thing),
                  );
                },
                shrinkWrap: true,
              )
            : const Expanded(
                child: Center(child: Text('Add things to check out.')),
              ),
      ],
    );
  }
}

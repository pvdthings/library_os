import 'package:flutter/material.dart';
import 'package:librarian_app/src/utils/media_query.dart';

import '../../models/thing_model.dart';

class InventoryList extends StatelessWidget {
  const InventoryList({
    super.key,
    required this.things,
    this.selected,
    this.onTap,
  });

  final List<ThingModel> things;
  final ThingModel? selected;
  final void Function(ThingModel thing)? onTap;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: things.length,
      itemBuilder: (context, index) {
        final thing = things[index];

        return ListTile(
          title: Text(thing.name),
          selected: isMobile(context) ? false : thing.id == selected?.id,
          onTap: () => onTap?.call(thing),
        );
      },
      shrinkWrap: true,
    );
  }
}

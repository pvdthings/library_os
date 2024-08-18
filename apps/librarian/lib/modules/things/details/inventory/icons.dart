import 'package:flutter/material.dart';
import 'package:librarian_app/core/api/models/item_model.dart';

const checkedInIcon = Tooltip(
  message: 'Available',
  child: Icon(Icons.circle, color: Colors.green, size: 16),
);

const checkedOutIcon = Tooltip(
  message: 'Unavailable',
  child: Icon(Icons.circle, color: Colors.amber, size: 16),
);

const partnerLocationIcon = Tooltip(
  message: 'Partner Location',
  child: Icon(Icons.circle, color: Colors.grey, size: 16),
);

const hiddenIcon = Tooltip(
  message: 'Hidden',
  child: Icon(Icons.circle, color: Colors.red, size: 16),
);

Widget getIcon(ItemModel item) {
  if (item.hidden) {
    return hiddenIcon;
  }

  if (item.isManagedByPartner) {
    return partnerLocationIcon;
  }

  return item.available ? checkedInIcon : checkedOutIcon;
}

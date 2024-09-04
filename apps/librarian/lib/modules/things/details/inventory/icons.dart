import 'package:flutter/material.dart';
import 'package:librarian_app/core/api/models/item_model.dart';
import 'package:librarian_app/widgets/icons.dart';

Widget getIcon(ItemModel item) {
  if (item.hidden) {
    return hiddenIcon;
  }

  if (item.isManagedByPartner) {
    return partnerLocationIcon;
  }

  return item.available ? checkedInIcon : checkedOutIcon;
}

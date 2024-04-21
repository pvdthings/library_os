import 'package:flutter/material.dart';

Widget createMenuItem({
  required void Function() onTap,
  required String text,
  required BuildContext context,
  Widget? leadingIcon,
}) {
  return MenuItemButton(
    onPressed: onTap,
    leadingIcon: leadingIcon,
    trailingIcon: const Icon(Icons.add),
    child: Text(
      text,
      style: Theme.of(context).textTheme.titleMedium,
    ),
  );
}

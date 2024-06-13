import 'package:flutter/material.dart';

Widget createMenuItem({
  required void Function()? onTap,
  required String text,
  required BuildContext context,
  Widget? leadingIcon,
  String? tooltip,
}) {
  final button = MenuItemButton(
    onPressed: onTap,
    leadingIcon: leadingIcon,
    trailingIcon: const Icon(Icons.add),
    child: Text(
      text,
      style: Theme.of(context).textTheme.titleMedium,
    ),
  );

  if (tooltip != null) {
    return Tooltip(
      message: tooltip,
      child: button,
    );
  }

  return button;
}

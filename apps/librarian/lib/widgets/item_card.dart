import 'package:flutter/material.dart';

import 'no_image.dart';

class ItemCard extends StatelessWidget {
  const ItemCard({
    super.key,
    required this.number,
    this.name,
    this.imageUrl,
    this.notes,
    this.trailing,
    this.onTap,
  });

  final int number;
  final String? name;
  final String? imageUrl;
  final String? notes;
  final Widget? trailing;
  final void Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      color: Theme.of(context).colorScheme.secondaryContainer,
      child: InkWell(
        onTap: onTap,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.min,
          children: [
            Expanded(
              child: Container(
                color: Theme.of(context).canvasColor.withOpacity(0.5),
                child: imageUrl != null
                    ? Image.network(
                        imageUrl!,
                        fit: BoxFit.cover,
                      )
                    : const NoImage(),
              ),
            ),
            Padding(
              padding: trailing == null
                  ? const EdgeInsets.all(8.0)
                  : const EdgeInsets.only(left: 8.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '#$number',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  if (notes != null)
                    Tooltip(
                      message: '#$number: $notes',
                      textStyle: Theme.of(context)
                          .textTheme
                          .bodyLarge
                          ?.copyWith(color: Colors.black, fontSize: 18),
                      child: const Icon(Icons.info),
                    ),
                  if (trailing != null) trailing!,
                ],
              ),
            ),
            if (name != null)
              Padding(
                padding: const EdgeInsets.only(
                  left: 8.0,
                  right: 8.0,
                  bottom: 8.0,
                ),
                child: Text(
                  name!,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.labelSmall,
                ),
              ),
          ],
        ),
      ),
    );
  }
}

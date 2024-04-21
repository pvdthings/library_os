import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:librarian_app/src/utils/media_query.dart';
import 'package:librarian_app/src/widgets/no_image.dart';

class ThingImageCard extends StatelessWidget {
  const ThingImageCard({
    super.key,
    this.imageUrl,
    this.imageBytes,
    this.width,
    this.height,
    this.useNewDesign = false,
    required this.onRemove,
    required this.onReplace,
  });

  final String? imageUrl;
  final Uint8List? imageBytes;
  final double? width;
  final double? height;
  final void Function()? onRemove;
  final void Function()? onReplace;

  final bool useNewDesign;

  @override
  Widget build(BuildContext context) {
    final imageChild = imageBytes != null
        ? Image.memory(
            imageBytes!,
            width: width,
            height: height,
            fit: BoxFit.cover,
          )
        : imageUrl != null
            ? Image.network(
                imageUrl!,
                width: width,
                height: height,
                fit: BoxFit.cover,
              )
            : SizedBox(
                width: width,
                height: height,
                child: const Center(child: NoImage()),
              );

    if (useNewDesign) {
      return Card(
        clipBehavior: Clip.antiAlias,
        elevation: 0,
        margin: EdgeInsets.zero,
        child: Stack(
          alignment: AlignmentDirectional.center,
          children: [
            imageChild,
            Positioned(
              bottom: 8,
              right: 8,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  IconButton.outlined(
                    onPressed: onReplace,
                    icon: const Icon(Icons.image_outlined),
                  ),
                  const SizedBox(width: 8),
                  IconButton.outlined(
                    onPressed: onRemove,
                    color: Colors.red,
                    icon: const Icon(Icons.remove),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    }

    return Card(
      elevation: isMobile(context) ? 1 : 0,
      margin: EdgeInsets.zero,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: width,
              height: height,
              clipBehavior: Clip.antiAliasWithSaveLayer,
              decoration: const BoxDecoration(
                shape: BoxShape.rectangle,
                borderRadius: BorderRadius.all(Radius.circular(8)),
              ),
              child: imageChild,
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextButton(
                  onPressed: onReplace,
                  child: const Text('Choose'),
                ),
                TextButton(
                  onPressed: imageUrl != null ? onRemove : null,
                  child: Text(
                    'Remove',
                    style: TextStyle(color: Colors.red.shade300),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

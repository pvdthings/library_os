import 'package:flutter/material.dart';
import 'package:librarian_app/core/core.dart';

class LogoImage extends StatelessWidget {
  const LogoImage({super.key});

  @override
  Widget build(BuildContext context) {
    final defaultIcon = const Icon(
      Icons.local_library_outlined,
      size: 120,
    );

    if (Library.logoUrl != null) {
      return Image.network(
        Library.logoUrl!,
        errorBuilder: (context, error, stackTrace) {
          return defaultIcon;
        },
        loadingBuilder: (context, child, progress) {
          return Center(child: child);
        },
        isAntiAlias: true,
        height: 120,
      );
    }

    return defaultIcon;
  }
}

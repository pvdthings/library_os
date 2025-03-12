import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:librarian_app/core/core.dart';

class LogoImage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    if (Library.logoUrl != null) {
      return Image.network(
        Library.logoUrl!,
        loadingBuilder: (context, child, progress) {
          return Center(child: child);
        },
        isAntiAlias: true,
        height: 120,
      );
    }

    if (kDebugMode) {
      return Image.asset(
        'pvd_things.png',
        isAntiAlias: true,
        height: 120,
      );
    }

    return const Icon(
      Icons.local_library_outlined,
      size: 120,
    );
  }
}

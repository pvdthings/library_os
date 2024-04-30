import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class EndDrawerController {
  EndDrawerController(this.ref);

  final Ref ref;
  Widget? drawer;

  openEndDrawer(BuildContext context, Widget drawer) {
    this.drawer = drawer;
    ref.notifyListeners();
    Future.delayed(const Duration(milliseconds: 500), () {
      Scaffold.of(context).openEndDrawer();
    });
  }
}

final endDrawerProvider = Provider((ref) => EndDrawerController(ref));

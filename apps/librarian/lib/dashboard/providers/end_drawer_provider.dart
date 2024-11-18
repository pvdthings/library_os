import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class EndDrawerController {
  EndDrawerController(this.ref);

  final Ref ref;
  Widget child = const SizedBox.expand();

  openEndDrawer(BuildContext context, Widget child) {
    this.child = child;
    ref.notifyListeners();
    Future.delayed(const Duration(milliseconds: 750), () {
      Scaffold.of(context).openEndDrawer();
    });
  }
}

final endDrawerProvider = Provider((ref) => EndDrawerController(ref));

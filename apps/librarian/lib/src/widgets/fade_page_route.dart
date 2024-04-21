import 'package:flutter/material.dart';

Route createFadePageRoute({required Widget child}) {
  return PageRouteBuilder(
    pageBuilder: (_, __, ___) => child,
    transitionsBuilder: (_, a, __, c) => FadeTransition(
      opacity: a,
      child: c,
    ),
  );
}

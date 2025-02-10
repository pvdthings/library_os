import 'package:flutter/material.dart';

Route createFadePageRoute({
  required Widget child,
  Duration? duration,
}) {
  return PageRouteBuilder(
    transitionDuration: duration ?? const Duration(milliseconds: 300),
    pageBuilder: (_, __, ___) => child,
    transitionsBuilder: (_, a, __, c) => FadeTransition(
      opacity: a,
      child: c,
    ),
  );
}

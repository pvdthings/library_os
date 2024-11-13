import 'package:flutter/material.dart';
import 'package:skeletonizer/skeletonizer.dart';

class Skeleton extends StatelessWidget {
  const Skeleton({
    super.key,
    required this.enabled,
    required this.child,
  });

  final bool enabled;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Skeletonizer(
      enabled: enabled,
      child: child,
    );
  }
}

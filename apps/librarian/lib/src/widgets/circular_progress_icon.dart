import 'package:flutter/material.dart';

class CircularProgressIcon extends StatelessWidget {
  const CircularProgressIcon({super.key});

  @override
  Widget build(BuildContext context) {
    return const SizedBox(
      width: 16,
      height: 16,
      child: CircularProgressIndicator(strokeWidth: 2),
    );
  }
}

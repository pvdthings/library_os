import 'package:flutter/material.dart';

class PaneHeader extends StatelessWidget {
  const PaneHeader({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    var primaryColor = Theme.of(context).primaryColor;
    return Container(
      decoration: BoxDecoration(
        color: primaryColor.withAlpha(100),
        border: Border(
          bottom: BorderSide(color: Colors.black.withOpacity(0.5)),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        child: SizedBox(
          height: 48,
          width: double.infinity,
          child: child,
        ),
      ),
    );
  }
}

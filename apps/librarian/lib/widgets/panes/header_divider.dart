import 'package:flutter/material.dart';

class HeaderDivider extends StatelessWidget {
  const HeaderDivider({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 24,
      width: 24,
      child: VerticalDivider(
        color: Colors.white.withOpacity(0.3),
      ),
    );
  }
}

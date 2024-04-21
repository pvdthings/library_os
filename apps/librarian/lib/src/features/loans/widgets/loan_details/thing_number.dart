import 'package:flutter/material.dart';

class ThingNumber extends StatelessWidget {
  const ThingNumber({super.key, required this.number});

  final int number;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.5),
          border: Border.all(color: Colors.black.withOpacity(0.2)),
          borderRadius: const BorderRadius.all(Radius.circular(8))),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 12,
          vertical: 4,
        ),
        child: Text(
          '#$number',
          style: Theme.of(context).textTheme.bodyLarge,
        ),
      ),
    );
  }
}

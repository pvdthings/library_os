import 'package:flutter/material.dart';

class HintText extends StatelessWidget {
  const HintText(this.text, {super.key});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: hintTextStyle(context),
    );
  }
}

TextStyle? hintTextStyle(BuildContext context) {
  return Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.grey);
}

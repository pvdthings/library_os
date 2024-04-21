import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class SubmitTextField extends StatefulWidget {
  const SubmitTextField({
    super.key,
    this.controller,
    this.keyboardType,
    this.inputFormatters,
    this.hintText,
    this.labelText,
    this.icon,
    this.prefixIcon,
    this.showSubmitButton = true,
    required this.onSubmitted,
    required this.onChanged,
  });

  final TextEditingController? controller;
  final TextInputType? keyboardType;
  final List<TextInputFormatter>? inputFormatters;
  final String? hintText;
  final String? labelText;
  final Widget? icon;
  final Widget? prefixIcon;
  final bool showSubmitButton;
  final Function(String) onSubmitted;
  final Function(String) onChanged;

  @override
  State<StatefulWidget> createState() {
    return _SubmitTextFieldState();
  }
}

class _SubmitTextFieldState extends State<SubmitTextField> {
  bool _showSubmitButton = false;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: widget.controller,
      onSubmitted: widget.onSubmitted,
      onChanged: (value) {
        setState(() => _showSubmitButton = value.isNotEmpty);
        widget.onChanged(value);
      },
      keyboardType: widget.keyboardType,
      inputFormatters: widget.inputFormatters,
      decoration: InputDecoration(
        icon: widget.icon,
        prefixIcon: widget.prefixIcon,
        suffixIcon: _showSubmitButton && widget.showSubmitButton
            ? IconButton(
                onPressed: () => widget.onSubmitted(widget.controller!.text),
                icon: const Icon(Icons.keyboard_return_rounded),
              )
            : null,
        labelText: widget.labelText,
        hintText: widget.hintText,
        border: const OutlineInputBorder(),
      ),
    );
  }
}

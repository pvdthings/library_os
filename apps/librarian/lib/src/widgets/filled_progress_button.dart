import 'package:flutter/material.dart';
import 'package:librarian_app/src/widgets/circular_progress_icon.dart';

class FilledProgressButton extends StatefulWidget {
  const FilledProgressButton({
    super.key,
    required this.child,
    required this.onPressed,
    this.isLoading,
  });

  final Widget child;
  final void Function()? onPressed;
  final bool? isLoading;

  @override
  State<FilledProgressButton> createState() => _FilledProgressButtonState();
}

class _FilledProgressButtonState extends State<FilledProgressButton> {
  late bool _isLoading = widget.isLoading ?? false;

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return FilledButton.icon(
        onPressed: null,
        icon: const CircularProgressIcon(),
        label: widget.child,
      );
    }

    return FilledButton(
      onPressed: widget.onPressed == null
          ? null
          : () {
              if (widget.isLoading == null) {
                setState(() => _isLoading = true);
              }
              widget.onPressed?.call();
            },
      child: widget.child,
    );
  }
}

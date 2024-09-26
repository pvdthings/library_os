import 'package:flutter/material.dart';
import 'package:librarian_app/widgets/panes/header_divider.dart';

class SearchField extends StatefulWidget {
  const SearchField({
    super.key,
    required this.onChanged,
    this.onClearPressed,
    this.text,
    this.trailing,
  });

  final Widget? trailing;
  final void Function(String value) onChanged;
  final void Function()? onClearPressed;
  final String? text;

  @override
  State<SearchField> createState() => _SearchFieldState();
}

class _SearchFieldState extends State<SearchField> {
  late final _searchController = TextEditingController(text: widget.text);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: TextField(
            controller: _searchController,
            onChanged: widget.onChanged,
            decoration: InputDecoration(
              border: InputBorder.none,
              constraints: const BoxConstraints(maxWidth: 400),
              hintText: 'Search...',
              icon: Icon(
                Icons.search_rounded,
                color: _searchController.text.isEmpty
                    ? null
                    : Theme.of(context).primaryIconTheme.color,
              ),
            ),
          ),
        ),
        IconButton(
          onPressed: _searchController.text.isEmpty
              ? null
              : () {
                  setState(() => _searchController.clear());
                  widget.onClearPressed?.call();
                },
          icon: const Icon(Icons.clear_rounded),
          tooltip: 'Clear',
        ),
        if (widget.trailing != null) ...[
          const HeaderDivider(),
          widget.trailing!,
        ],
      ],
    );
  }
}

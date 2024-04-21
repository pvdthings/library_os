import 'package:flutter/material.dart';
import 'package:librarian_app/src/utils/media_query.dart';

import '../../models/borrower_model.dart';

class BorrowersList extends StatefulWidget {
  final List<BorrowerModel> borrowers;
  final BorrowerModel? selected;
  final void Function(BorrowerModel borrower)? onTap;

  const BorrowersList({
    super.key,
    required this.borrowers,
    this.selected,
    this.onTap,
  });

  @override
  State<BorrowersList> createState() => _BorrowersListState();
}

class _BorrowersListState extends State<BorrowersList> {
  final _scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      controller: _scrollController,
      itemCount: widget.borrowers.length,
      itemBuilder: (context, index) {
        final b = widget.borrowers[index];

        return ListTile(
          title: Text(b.name),
          trailing: b.active ? null : const Icon(Icons.warning_rounded),
          onTap: () => widget.onTap?.call(b),
          selected: isMobile(context) ? false : b.id == widget.selected?.id,
        );
      },
      shrinkWrap: true,
    );
  }
}

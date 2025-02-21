import 'package:flutter/material.dart';
import 'package:librarian_app/utils/media_query.dart';

import '../../../core/models/member_model.dart';

class MembersList extends StatefulWidget {
  final List<MemberModel> borrowers;
  final MemberModel? selected;
  final void Function(MemberModel borrower)? onTap;

  const MembersList({
    super.key,
    required this.borrowers,
    this.selected,
    this.onTap,
  });

  @override
  State<MembersList> createState() => _MembersListState();
}

class _MembersListState extends State<MembersList> {
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

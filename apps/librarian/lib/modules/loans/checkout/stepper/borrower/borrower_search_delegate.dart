import 'package:flutter/material.dart';

import '../../../../../core/api/models/member_model.dart';
import '../../../../members/list/members_list.dart';

class BorrowerSearchDelegate extends SearchDelegate<MemberModel?> {
  BorrowerSearchDelegate(this.borrowers);

  final List<MemberModel> borrowers;

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
        icon: const Icon(Icons.clear),
        onPressed: () => query = '',
      ),
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      icon: AnimatedIcon(
        icon: AnimatedIcons.menu_arrow,
        progress: transitionAnimation,
      ),
      onPressed: () => close(context, null),
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return _buildQueriedList(context);
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return _buildQueriedList(context);
  }

  Widget _buildQueriedList(BuildContext context) {
    final results = borrowers
        .where((b) => b.name.toLowerCase().contains(query.toLowerCase()))
        .toList();

    return MembersList(
      borrowers: results,
      onTap: (borrower) {
        close(context, borrower);
      },
    );
  }
}

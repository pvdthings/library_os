import 'package:flutter/material.dart';

import '../models/borrower_model.dart';
import 'borrowers_list/borrowers_list.dart';

class BorrowerSearchDelegate extends SearchDelegate<BorrowerModel?> {
  BorrowerSearchDelegate(this.borrowers);

  final List<BorrowerModel> borrowers;

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

    return BorrowersList(
      borrowers: results,
      onTap: (borrower) {
        close(context, borrower);
      },
    );
  }
}

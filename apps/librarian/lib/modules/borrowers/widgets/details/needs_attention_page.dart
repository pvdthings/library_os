import 'package:flutter/material.dart';
import 'package:librarian_app/modules/borrowers/models/borrower_model.dart';

import 'needs_attention_view.dart';

class NeedsAttentionPage extends StatelessWidget {
  const NeedsAttentionPage({super.key, required this.borrower});

  final BorrowerModel borrower;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(borrower.name)),
      body: NeedsAttentionView(borrower: borrower),
    );
  }
}

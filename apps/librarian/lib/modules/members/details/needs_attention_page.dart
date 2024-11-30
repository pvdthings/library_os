import 'package:flutter/material.dart';
import 'package:librarian_app/core/api/models/borrower_model.dart';

import 'needs_attention_view.dart';

class NeedsAttentionPage extends StatelessWidget {
  const NeedsAttentionPage({super.key, required this.member});

  final MemberModel member;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(member.name)),
      body: NeedsAttentionView(member: member),
    );
  }
}

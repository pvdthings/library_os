import 'package:flutter/material.dart';
import 'package:librarian_app/core/models/member_model.dart';

class NeedsAttentionView extends StatelessWidget {
  final MemberModel member;

  const NeedsAttentionView({super.key, required this.member});

  @override
  Widget build(BuildContext context) {
    if (member.issues.isEmpty) {
      return const Center(child: Text('Ready to borrow!'));
    }

    return Padding(
      padding: const EdgeInsets.all(8),
      child: ListView.builder(
        itemCount: member.issues.length,
        itemBuilder: (context, index) {
          final reason = member.issues[index];

          return Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    reason.title,
                    style: const TextStyle(
                      color: Colors.orange,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    reason.explanation ?? "",
                    style: const TextStyle(fontSize: 18),
                  ),
                  const SizedBox(height: 16),
                  if (reason.graphicUrl != null)
                    Center(child: Image.asset(reason.graphicUrl!)),
                ],
              ),
            ),
          );
        },
        shrinkWrap: true,
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:librarian_app/src/core/core.dart';
import 'package:librarian_app/src/features/authentication/providers/user_provider.dart';
import 'package:librarian_app/src/features/authentication/widgets/user_avatar.dart';

class UserTray extends ConsumerWidget {
  const UserTray({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    SystemUser? user = ref.watch(userProvider);

    return Row(
      children: [
        Text(user?.name ?? ''),
        const SizedBox(width: 12),
        const UserAvatar(),
      ],
    );
  }
}

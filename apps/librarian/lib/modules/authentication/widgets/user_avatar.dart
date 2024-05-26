import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:librarian_app/core/core.dart';
import 'package:librarian_app/modules/authentication/providers/user_provider.dart';

class UserAvatar extends ConsumerWidget {
  const UserAvatar({super.key});

  static const double _radius = 16;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    SystemUser? user = ref.watch(userProvider);

    if (user == null || !user.isSignedIn || user.pictureUrl == null) {
      return CircleAvatar(
        backgroundColor: Theme.of(context).primaryColor.withAlpha(100),
        radius: _radius,
      );
    }

    return CircleAvatar(
      backgroundImage: NetworkImage(user.pictureUrl!),
      radius: _radius,
    );
  }
}

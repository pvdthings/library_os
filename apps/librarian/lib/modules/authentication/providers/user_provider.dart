import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:librarian_app/core/core.dart';
import 'package:librarian_app/core/supabase.dart';

final userProvider = Provider<SystemUser?>((ref) {
  final currentUser = supabase.auth.currentUser;

  if (currentUser == null) {
    return null;
  }

  return SystemUser.from(currentUser);
});

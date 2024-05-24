import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:librarian_app/core/core.dart';
import 'package:supabase_flutter/supabase_flutter.dart' as supabase;

final userProvider = Provider<SystemUser?>((ref) {
  final currentUser = supabase.Supabase.instance.client.auth.currentUser;

  if (currentUser == null) {
    return null;
  }

  return SystemUser.from(currentUser);
});

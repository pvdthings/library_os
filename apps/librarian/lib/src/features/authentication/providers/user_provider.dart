import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart' as supabase;

import '../models/user_model.dart';

final userProvider = Provider<UserModel>((ref) {
  final currentUser = supabase.Supabase.instance.client.auth.currentUser;
  return UserModel.from(currentUser);
});

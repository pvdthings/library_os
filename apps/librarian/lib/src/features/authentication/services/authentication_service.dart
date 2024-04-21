import 'package:librarian_app/constants.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../models/user_model.dart';

class AuthenticationService {
  static SupabaseClient get _supabase => Supabase.instance.client;
  static User? get _currentUser => _supabase.auth.currentUser;

  bool get hasValidSession => _supabase.auth.currentSession != null;

  UserModel get currentUser => UserModel.from(_currentUser);

  Future<void> signIn() async {
    await _supabase.auth.signInWithOAuth(Provider.discord,
        redirectTo: appUrl.isNotEmpty ? appUrl : null);
  }

  Future<void> signOut() async {
    await _supabase.auth.signOut();
  }
}

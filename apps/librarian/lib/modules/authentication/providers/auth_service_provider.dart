import 'package:flutter_riverpod/flutter_riverpod.dart' as rp;
import 'package:librarian_app/constants.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'user_provider.dart';

class AuthService {
  const AuthService(this.ref);

  final rp.Ref ref;

  static SupabaseClient get _supabase => Supabase.instance.client;

  bool get hasValidSession => _supabase.auth.currentSession != null;

  Future<void> signIn({void Function()? onSuccess}) async {
    await _supabase.auth.signInWithOAuth(
      OAuthProvider.discord,
      redirectTo: appUrl.isNotEmpty ? appUrl : null,
    );

    if (onSuccess != null) {
      ref.listen(userProvider, (_, user) {
        if (user != null) {
          onSuccess();
        }
      });
    }
  }

  Future<void> signOut() async {
    await _supabase.auth.signOut();
  }
}

final authServiceProvider = rp.Provider((ref) => AuthService(ref));

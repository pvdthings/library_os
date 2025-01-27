import 'package:flutter_riverpod/flutter_riverpod.dart' as rp;
import 'package:librarian_app/core/supabase.dart';

class AuthService {
  const AuthService(this.ref);

  final rp.Ref ref;

  bool get hasValidSession => supabase.auth.currentSession != null;

  Future<void> signIn({
    required String email,
    required String password,
    void Function()? onSuccess,
  }) async {
    await supabase.auth.signInWithPassword(
      email: email,
      password: password,
    );

    if (supabase.auth.currentUser != null) {
      onSuccess?.call();
    }
  }

  Future<void> signOut() async {
    await supabase.auth.signOut();
  }
}

final authServiceProvider = rp.Provider((ref) => AuthService(ref));

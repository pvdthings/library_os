import 'package:librarian_app/core/supabase.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AuthService {
  const AuthService();

  static get instance => _instance;

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

  void handleSignOut(void Function()? onSignedOut) {
    supabase.auth.onAuthStateChange.listen((state) {
      final AuthChangeEvent event = state.event;

      if (event == AuthChangeEvent.signedOut ||
          event == AuthChangeEvent.tokenRefreshed) {
        onSignedOut?.call();
      }
    });
  }
}

final _instance = AuthService();

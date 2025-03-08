import 'package:librarian_app/core/supabase.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AuthService {
  const AuthService();

  static AuthService get instance => _instance;

  bool get hasValidSession => supabase.auth.currentSession != null;

  Future<void> requestAccessCode({
    required String email,
    void Function()? onSuccess,
    void Function(String)? onError,
  }) async {
    try {
      await supabase.auth.signInWithOtp(
        email: email,
        shouldCreateUser: false,
      );
      onSuccess?.call();
    } on AuthException catch (error) {
      onError?.call(error.message);
    } catch (error) {
      onError?.call("An unexpected error occurred.");
    }
  }

  Future<void> verifyAccessCode({
    required String accessCode,
    required String email,
    void Function()? onSuccess,
    void Function(String)? onError,
  }) async {
    try {
      await supabase.auth.verifyOTP(
        type: OtpType.email,
        email: email,
        token: accessCode,
      );
    } on AuthException catch (error) {
      onError?.call(error.message);
    } catch (error) {
      onError?.call("An unexpected error occurred.");
    }

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

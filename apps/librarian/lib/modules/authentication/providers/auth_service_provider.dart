import 'package:flutter_riverpod/flutter_riverpod.dart' as rp;
import 'package:librarian_app/core/supabase.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AuthService {
  const AuthService(this.ref);

  final rp.Ref ref;

  bool get hasValidSession => supabase.auth.currentSession != null;

  Future<void> requestCode({
    required String email,
    void Function()? onSuccess,
    void Function(String error)? onError,
  }) async {
    try {
      await supabase.auth.signInWithOtp(
        email: email,
        shouldCreateUser: false,
      );
      onSuccess?.call();
    } catch (error) {
      onError?.call(error.toString());
    }
  }

  Future<void> verifyCode({
    required String email,
    required String code,
    void Function()? onSuccess,
    void Function(String error)? onError,
  }) async {
    try {
      await supabase.auth.verifyOTP(
        email: email,
        token: code,
        type: OtpType.email,
      );
      onSuccess?.call();
    } catch (error) {
      onError?.call(error.toString());
    }
  }

  Future<void> signOut() async {
    await supabase.auth.signOut();
  }
}

final authServiceProvider = rp.Provider((ref) => AuthService(ref));

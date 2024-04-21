import 'package:supabase_flutter/supabase_flutter.dart';

class UserModel {
  final String name;
  final bool isSignedIn;
  final String? pictureUrl;

  const UserModel({
    required this.name,
    required this.isSignedIn,
    this.pictureUrl,
  });

  factory UserModel.from(User? supabaseUser) {
    final metadata = supabaseUser?.userMetadata;
    final name = metadata?['full_name'] ?? supabaseUser?.email ?? 'User';

    return UserModel(
      name: name,
      isSignedIn: supabaseUser != null,
      pictureUrl: metadata?['picture'],
    );
  }
}

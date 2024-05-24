part of 'core.dart';

class SystemUser {
  final String name;
  final bool isSignedIn;
  final String? pictureUrl;

  const SystemUser({
    required this.name,
    required this.isSignedIn,
    this.pictureUrl,
  });

  factory SystemUser.from(User? supabaseUser) {
    final metadata = supabaseUser?.userMetadata;
    final name = metadata?['full_name'] ?? supabaseUser?.email ?? 'User';

    return SystemUser(
      name: name,
      isSignedIn: supabaseUser != null,
      pictureUrl: metadata?['picture'],
    );
  }
}

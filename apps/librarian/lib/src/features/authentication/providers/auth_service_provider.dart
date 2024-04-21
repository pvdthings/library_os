import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:librarian_app/src/features/authentication/services/authentication_service.dart';

final authServiceProvider = Provider((ref) => AuthenticationService());

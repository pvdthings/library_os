import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart' as riverpod;
import 'package:librarian_app/core/supabase.dart';
import 'package:librarian_app/modules/splash/pages/splash_page.dart';
import 'package:librarian_app/theme/indigo_theme.dart';

import 'modules/authentication/pages/signin_page.dart';
import 'core/services/auth_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  initializeSupabase();

  runApp(const riverpod.ProviderScope(
    child: LibrarianApp(),
  ));
}

final navigatorKey = GlobalKey<NavigatorState>();

class LibrarianApp extends StatelessWidget {
  const LibrarianApp({super.key});

  @override
  Widget build(BuildContext context) {
    AuthService.instance.handleSignOut(() {
      navigatorKey.currentState?.pushReplacement(signOutPageTransition);
    });

    return MaterialApp(
      title: 'Library OS',
      debugShowCheckedModeBanner: false,
      theme: indigoTheme,
      navigatorKey: navigatorKey,
      initialRoute: '/',
      routes: {
        '/': (_) => const SplashPage(),
      },
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart' as riverpod;
import 'package:librarian_app/core/supabase.dart';
import 'package:librarian_app/modules/splash/pages/splash_page.dart';
import 'package:librarian_app/theme/indigo_theme.dart';

import 'modules/authentication/pages/signin_page.dart';
import 'modules/authentication/providers/auth_service_provider.dart';
import 'widgets/fade_page_route.dart';

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
      navigatorKey.currentState?.pushReplacement(createFadePageRoute(
        child: SignInPage(
          message: 'You have been signed out.',
        ),
        duration: Duration(milliseconds: 500),
      ));
    });

    return MaterialApp(
      title: 'Librarian',
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

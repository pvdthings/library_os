import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart' as riverpod;
import 'package:librarian_app/constants.dart';
import 'package:librarian_app/core/supabase.dart';
import 'package:librarian_app/modules/splash/pages/splash_page.dart';
import 'package:librarian_app/theme/indigo_theme.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await loadEnvironmentVariables();
  initializeSupabase();

  runApp(const riverpod.ProviderScope(
    child: LibrarianApp(),
  ));
}

class LibrarianApp extends StatelessWidget {
  const LibrarianApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Librarian',
      debugShowCheckedModeBanner: false,
      theme: indigoTheme,
      initialRoute: '/',
      routes: {
        '/': (_) => const SplashPage(),
      },
    );
  }
}

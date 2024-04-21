import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart' as riverpod;
import 'package:librarian_app/constants.dart';
import 'package:librarian_app/src/core/library.dart';
import 'package:librarian_app/src/features/splash/pages/splash_page.dart';
import 'package:librarian_app/src/services/image_service.dart';
import 'package:librarian_app/src/theme/indigo_theme.dart';
import 'package:supabase_flutter/supabase_flutter.dart' as supabase;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await supabase.Supabase.initialize(
    url: supabaseUrl,
    anonKey: supabasePublicKey,
  );

  if (supabaseUrl.isNotEmpty) {
    Library.logoUrl = ImageService().getPublicUrl('library', 'settings/logo');
  }

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

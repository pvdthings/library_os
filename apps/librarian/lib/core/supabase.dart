import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:librarian_app/constants.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'core.dart';
import 'services/image_service.dart';

final supabase = Supabase.instance.client;

Future<void> initializeSupabase() async {
  await Supabase.initialize(
    url: dotenv.get('SUPABASE_URL'),
    anonKey: dotenv.get('SUPABASE_KEY'),
  );

  if (supabaseUrl.isNotEmpty) {
    Library.logoUrl = ImageService().getPublicUrl('library', 'settings/logo');
  }
}

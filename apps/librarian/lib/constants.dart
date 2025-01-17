import 'package:flutter_dotenv/flutter_dotenv.dart';

Future<void> loadEnvironmentVariables() async {
  await dotenv.load(isOptional: true);
}

const supabaseUrlKey = 'SUPABASE_URL';
const supabasePublicKeyKey = 'SUPABASE_PUBLIC_KEY';
const apiHostKey = 'API_HOST';
const apiKeyKey = 'API_KEY';
const appUrlKey = 'APP_URL';

const String _supabaseUrl = String.fromEnvironment(supabaseUrlKey);
const String _supabasePublicKey = String.fromEnvironment(supabasePublicKeyKey);
const String _apiHost = String.fromEnvironment(apiHostKey);
const String _apiKey = String.fromEnvironment(apiKeyKey);
const String _appUrl = String.fromEnvironment(appUrlKey);

String get supabaseUrl => dotenv.get(supabaseUrlKey, fallback: _supabaseUrl);
String get supabasePublicKey =>
    dotenv.get(supabasePublicKeyKey, fallback: _supabasePublicKey);
String get apiHost => dotenv.get(apiHostKey, fallback: _apiHost);
String get apiKey => dotenv.get(apiKeyKey, fallback: _apiKey);
String get appUrl => dotenv.get(appUrlKey, fallback: _appUrl);

import 'package:dio/dio.dart';
import 'package:librarian_app/constants.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class DioClient {
  static String get _accessToken =>
      Supabase.instance.client.auth.currentSession?.accessToken ?? '';

  static String get _refreshToken =>
      Supabase.instance.client.auth.currentSession?.refreshToken ?? '';

  static BaseOptions get _options {
    return BaseOptions(
      baseUrl: apiHost,
      contentType: 'application/json',
      headers: {
        'x-api-key': apiKey,
        'supabase-access-token': _accessToken,
        'supabase-refresh-token': _refreshToken,
      },
    );
  }

  static Dio get instance => Dio(_options);
}

part of 'api.dart';

class DioClient {
  static String get _accessToken =>
      supabase.auth.currentSession?.accessToken ?? '';

  static BaseOptions get _options {
    return BaseOptions(
      baseUrl: apiHost,
      contentType: 'application/json',
      headers: {
        'x-api-key': apiKey,
        'x-access-token': _accessToken,
      },
    );
  }

  static Dio get instance => Dio(_options);
}

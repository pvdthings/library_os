import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:librarian_app/constants.dart';
import 'package:librarian_app/core/api/client/client.dart';

final os = Provider<LibraryOSConnection>((ref) {
  return LibraryOS.connect(key: apiKey, url: apiHost);
});

import 'dart:typed_data';

import 'package:librarian_app/core/supabase.dart';
import 'package:uuid/uuid.dart';

class ImageService {
  static ImageService get instance => _instance;

  Future<ImageUploadResult> uploadImage({
    required Uint8List bytes,
    required String type,
    String? bucket,
    String? path,
  }) async {
    final pathName = path ?? createPath(type);

    await supabase.storage
        .from(bucket ?? 'uploads')
        .uploadBinary(pathName, bytes);

    final String url =
        supabase.storage.from(bucket ?? 'uploads').getPublicUrl(pathName);

    return ImageUploadResult(url: url);
  }

  String createPath(String type) {
    final guid = const Uuid().v4();
    return '$guid.$type';
  }

  String getPublicUrl(String bucket, String path) {
    return supabase.storage.from(bucket).getPublicUrl(path);
  }
}

final _instance = ImageService();

class ImageUploadResult {
  final String url;

  const ImageUploadResult({required this.url});
}

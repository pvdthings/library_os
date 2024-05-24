import 'dart:typed_data';

import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:uuid/uuid.dart';

class ImageService {
  Future<ImageUploadResult> uploadImage({
    required Uint8List bytes,
    required String type,
    String? bucket,
    String? path,
  }) async {
    final pathName = path ?? createPath(type);

    await Supabase.instance.client.storage
        .from(bucket ?? 'librarian_images')
        .uploadBinary(pathName, bytes);

    final String url = Supabase.instance.client.storage
        .from(bucket ?? 'librarian_images')
        .getPublicUrl(pathName);

    return ImageUploadResult(url: url);
  }

  String createPath(String type) {
    final guid = const Uuid().v4();
    return '$guid.$type';
  }

  String getPublicUrl(String bucket, String path) {
    return Supabase.instance.client.storage.from(bucket).getPublicUrl(path);
  }
}

class ImageUploadResult {
  final String url;

  const ImageUploadResult({required this.url});
}

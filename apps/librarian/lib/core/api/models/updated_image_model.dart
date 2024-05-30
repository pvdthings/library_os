part of 'models.dart';

class UpdatedImageModel {
  final String? name;
  final String? type;
  final Uint8List? bytes;
  final String? existingUrl;

  const UpdatedImageModel({
    this.name,
    this.existingUrl,
    required this.type,
    required this.bytes,
  });
}

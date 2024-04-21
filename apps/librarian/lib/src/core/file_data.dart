import 'package:flutter/foundation.dart';

class FileData {
  final String name;
  final Uint8List bytes;
  final String type;

  const FileData({
    required this.name,
    required this.bytes,
    required this.type,
  });
}

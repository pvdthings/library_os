import 'package:file_picker/_internal/file_picker_web.dart';
import 'package:file_picker/file_picker.dart';

import 'file_data.dart';

Future<FileData?> pickDocumentFile() async {
  FilePickerResult? result = await FilePickerWeb.platform.pickFiles(
    type: FileType.custom,
    allowedExtensions: ['pdf'],
  );
  return result == null
      ? null
      : FileData(
          name: result.files.single.name,
          bytes: result.files.single.bytes!,
          type: 'application/pdf',
        );
}

Future<FileData?> pickImageFile() async {
  FilePickerResult? result =
      await FilePickerWeb.platform.pickFiles(type: FileType.image);
  return result == null
      ? null
      : FileData(
          name: result.files.single.name,
          bytes: result.files.single.bytes!,
          type: result.files.single.extension!,
        );
}

part of 'core.dart';

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

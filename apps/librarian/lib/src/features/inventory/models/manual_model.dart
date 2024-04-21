class ManualModel {
  const ManualModel({
    required this.filename,
    required this.url,
  });

  final String filename;
  final String url;

  factory ManualModel.fromJson(dynamic data) {
    return ManualModel(
      filename: data['filename'],
      url: data['url'],
    );
  }
}

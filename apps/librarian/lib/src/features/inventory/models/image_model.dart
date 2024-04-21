class ImageModel {
  const ImageModel({
    required this.id,
    required this.url,
    required this.type,
    required this.width,
    required this.height,
  });

  final String id;
  final String url;
  final String type;
  final double width;
  final double height;

  factory ImageModel.fromJson(Map<String, dynamic> json) {
    return ImageModel(
      id: json['id'] as String,
      url: json['url'] as String,
      type: json['type'] as String,
      width: json['width'] as double,
      height: json['height'] as double,
    );
  }
}

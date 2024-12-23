class ThingModel {
  ThingModel({
    required this.id,
    required this.name,
    required this.hidden,
    required this.stock,
    required this.available,
    this.spanishName,
  });

  final String id;
  final String name;
  final String? spanishName;
  final bool hidden;
  final int stock;
  final int available;

  factory ThingModel.fromJson(Map<String, dynamic> json) {
    return ThingModel(
      id: json['id'] as String,
      name: json['name'] as String,
      spanishName: json['name_es'] as String?,
      hidden: json['hidden'] as bool,
      stock: json['stock'] as int,
      available: json['available'] as int,
    );
  }

  factory ThingModel.fromQuery(Map<String, dynamic> data) {
    final stock = data['items'][0]['stock'] as int;
    return ThingModel(
      id: data['id'].toString(),
      name: data['name'] as String,
      spanishName: data['spanish_name'] as String?,
      hidden: data['hidden'] as bool,
      stock: stock,
      available: stock - data['loans'][0]['unavailable'] as int,
    );
  }
}

import 'package:librarian_app/src/features/inventory/models/image_model.dart';

import 'item_model.dart';

class DetailedThingModel {
  DetailedThingModel({
    required this.id,
    required this.name,
    required this.categories,
    required this.images,
    required this.items,
    required this.hidden,
    required this.eyeProtection,
    required this.stock,
    required this.available,
    this.spanishName,
  });

  final String id;
  final String name;
  final String? spanishName;
  final bool hidden;
  final bool eyeProtection;
  final int stock;
  final int available;
  final List<String> categories;
  final List<ImageModel> images;
  final List<ItemModel> items;

  factory DetailedThingModel.fromJson(Map<String, dynamic> json) {
    return DetailedThingModel(
      id: json['id'] as String,
      name: json['name'] as String,
      spanishName: json['name_es'] as String?,
      hidden: json['hidden'] as bool,
      eyeProtection: json['eyeProtection'] as bool,
      stock: json['stock'] as int,
      available: json['available'] as int,
      categories: (json['categories'] as List).cast<String>(),
      images:
          (json['images'] as List).map((e) => ImageModel.fromJson(e)).toList(),
      items: (json['items'] as List).map((e) => ItemModel.fromJson(e)).toList(),
    );
  }
}

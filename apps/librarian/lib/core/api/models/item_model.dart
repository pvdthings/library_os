import 'manual_model.dart';

class ItemModel {
  ItemModel({
    required this.id,
    required this.thingId,
    required this.number,
    required this.name,
    required this.available,
    required this.hidden,
    required this.eyeProtection,
    required this.totalLoans,
    required this.imageUrls,
    required this.manuals,
    required this.linkedThingIds,
    this.brand,
    this.condition,
    this.notes,
    this.estimatedValue,
    this.location,
  });

  final String id;
  final String thingId;
  final int number;
  final String name;
  final String? notes;
  final String? brand;
  final String? condition;
  final String? location;
  final double? estimatedValue;
  final bool available;
  final bool hidden;
  final bool eyeProtection;
  final int totalLoans;
  final List<String> linkedThingIds;
  final List<String> imageUrls;
  final List<ManualModel> manuals;

  // TECH DEBT - Will be replaced by a location system in the future.
  bool get isManagedByPartner {
    return location == 'Providence Public Library';
  }

  factory ItemModel.fromJson(Map<String, dynamic> json) {
    return ItemModel(
      id: json['id'] as String,
      thingId: json['thingId'] as String,
      number: json['number'] as int,
      name: json['name'] as String? ?? 'Unknown Thing',
      notes: json['notes'] as String?,
      available: json['available'] as bool,
      hidden: json['hidden'] as bool,
      totalLoans: json['totalLoans'] as int,
      brand: json['brand'] as String?,
      condition: json['condition'] as String?,
      location: json['location'] as String?,
      estimatedValue: json['estimatedValue'] as double?,
      eyeProtection: json['eyeProtection'] as bool,
      linkedThingIds: (json['linkedThingIds'] as List).cast<String>(),
      imageUrls: (json['images'] as List).cast<String>(),
      manuals: (json['manuals'] as List)
          .map((m) => ManualModel.fromJson(m))
          .toList(),
    );
  }
}

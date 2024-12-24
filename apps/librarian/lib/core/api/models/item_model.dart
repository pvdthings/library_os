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

  factory ItemModel.fromQuery(Map<String, dynamic> data) {
    final thing = data['thing'];
    return ItemModel(
      id: data['id'].toString(),
      thingId: data['thing_id'].toString(),
      number: data['number'] as int,
      name: thing['name'] as String? ?? 'Unknown Thing',
      notes: data['notes'] as String?,
      available: (data['active_loans'][0]['count'] as int) == 0,
      hidden: data['hidden'] as bool,
      brand: data['brand'] as String?,
      condition: data['status'] as String?,
      location: data['location']?.toString(),
      estimatedValue: data['estimated_value'] as double?,
      eyeProtection: thing['eye_protection'] as bool,
      linkedThingIds: [],
      imageUrls: (data['images'] as List?)
              ?.map((image) => image['url'] as String)
              .toList() ??
          [],
      manuals: (data['attachments'] as List?)
              ?.map((a) => ManualModel(
                    filename: a['name'] as String? ?? 'Attachment',
                    url: a['url'] as String,
                  ))
              .toList() ??
          [],
    );
  }
}

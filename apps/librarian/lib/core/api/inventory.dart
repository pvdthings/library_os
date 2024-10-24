part of 'api.dart';

Future<Response> fetchInventoryItems() async {
  return await DioClient.instance.get('/inventory');
}

Future<Response> fetchInventoryItem({required int number}) async {
  return await DioClient.instance.get('/inventory/$number');
}

Future<Response> createInventoryItems(
  String thingId, {
  required int quantity,
  required String? brand,
  String? condition,
  required String? notes,
  required double? estimatedValue,
  bool? hidden,
  ImageDTO? image,
  List<ImageDTO>? manuals,
}) async {
  return await DioClient.instance.put('/inventory', data: {
    'thingId': thingId,
    'quantity': quantity,
    'brand': brand,
    'condition': condition,
    'notes': notes,
    'estimatedValue': estimatedValue,
    'hidden': hidden,
    'image': {
      'url': image?.url,
    },
    'manuals': manuals?.map((m) => {'url': m.url, 'filename': m.name}).toList(),
  });
}

Future<Response> updateInventoryItem(
  String id, {
  String? brand,
  String? condition,
  String? notes,
  double? estimatedValue,
  bool? hidden,
  ImageDTO? image,
  List<ImageDTO>? manuals,
}) async {
  return await DioClient.instance.patch('/inventory/$id', data: {
    'brand': brand,
    'condition': condition,
    'notes': notes,
    'estimatedValue': estimatedValue,
    'hidden': hidden,
    'image': image != null ? {'url': image.url} : null,
    'manuals': manuals?.map((m) => {'url': m.url, 'filename': m.name}).toList(),
  });
}

Future<Response> convertInventoryItem(
  String id,
  String thingId,
) async {
  return await DioClient.instance.post('/inventory/$id/convert', data: {
    'thingId': thingId,
  });
}

Future<Response> deleteInventoryItem(String id) async {
  return await DioClient.instance.delete('/inventory/$id');
}

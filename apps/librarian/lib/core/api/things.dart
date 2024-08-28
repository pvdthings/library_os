part of 'api.dart';

Future<Response> getCategories() async {
  return await DioClient.instance.get('/things/categories');
}

Future<Response> fetchThings() async {
  return await DioClient.instance.get('/things');
}

Future<Response> fetchThing({required String id}) async {
  return await DioClient.instance.get('/things/$id');
}

Future<Response> createThing({
  required String name,
  String? spanishName,
}) async {
  return await DioClient.instance.put('/things', data: {
    'name': name,
    'spanishName': spanishName,
  });
}

Future<Response> updateThing(
  String thingId, {
  String? name,
  String? spanishName,
  List<String>? categories,
  List<String>? linkedThings,
  bool? hidden,
  bool? eyeProtection,
  ImageDTO? image,
}) async {
  return await DioClient.instance.patch('/things/$thingId', data: {
    'name': name,
    'spanishName': spanishName,
    'categories': categories,
    'linkedThings': linkedThings,
    'hidden': hidden,
    'eyeProtection': eyeProtection,
    'image': image != null ? {'url': image.url} : null,
  });
}

Future<Response> deleteThing(String id) async {
  return await DioClient.instance.delete('/things/$id');
}

Future<Response> deleteThingImage(String thingId) async {
  return await DioClient.instance.delete('/things/$thingId/image');
}

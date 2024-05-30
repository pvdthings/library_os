part of 'client.dart';

class LibraryOSThings {
  Future<List<ThingModel>> all() async {
    final response = await fetchThings();
    final objects = response.data as List;
    return objects.map((e) => ThingModel.fromJson(e)).toList();
  }

  LibraryOSThingReference one(String id) {
    return LibraryOSThingReference(id: id);
  }

  Future<ThingModel> create({
    required String name,
    String? spanishName,
  }) {
    return createThing(
      name: name,
      spanishName: spanishName,
    ).then((r) {
      return ThingModel.fromJson(r.data);
    });
  }
}

class LibraryOSThingReference {
  const LibraryOSThingReference({required this.id});

  final String id;

  LibraryOSItemsReference get items {
    return LibraryOSItemsReference(thingId: id);
  }

  Future<DetailedThingModel> details() async {
    final response = await fetchThing(id: id);
    return DetailedThingModel.fromJson(response.data);
  }

  Future<ThingModel> update({
    String? name,
    String? spanishName,
    bool? hidden,
    bool? eyeProtection,
    List<String>? categories,
    UpdatedImageModel? image,
  }) async {
    if (image != null && image.bytes == null) {
      await deleteThingImage(id);
    }

    if (categories != null) {
      await updateThingCategories(id, categories: categories);
    }

    await updateThing(
      id,
      name: name,
      spanishName: spanishName,
      hidden: hidden,
      eyeProtection: eyeProtection,
      image: const ImageDTO(url: ''), // FIXME
    );

    return ThingModel(
      id: id,
      name: name ?? '',
      spanishName: spanishName,
      hidden: hidden ?? false,
    );
  }

  Future<void> delete() async {
    await deleteThing(id);
  }

  Future<void> deleteImage() async {
    await deleteThingImage(id);
  }
}

class LibraryOSItemsReference {
  const LibraryOSItemsReference({required this.thingId});

  final String thingId;

  Future<void> createMany(
    int quantity, {
    String? brand,
    String? condition,
    String? description,
    double? estimatedValue,
    bool? hidden,
    ImageDTO? image,
    List<ImageDTO>? manuals,
  }) async {
    await createInventoryItems(
      thingId,
      quantity: quantity,
      brand: brand,
      condition: condition,
      description: description,
      estimatedValue: estimatedValue,
      hidden: hidden,
      image: image,
      manuals: manuals,
    );
  }
}

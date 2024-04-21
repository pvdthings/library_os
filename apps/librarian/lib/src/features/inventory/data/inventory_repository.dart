import 'package:collection/collection.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:librarian_app/src/api/lending_api.dart';
import 'package:librarian_app/src/services/image_service.dart';
import 'package:librarian_app/src/features/inventory/models/updated_image_model.dart';

import '../models/detailed_thing_model.dart';
import '../models/item_model.dart';
import '../models/thing_model.dart';

class InventoryRepository extends Notifier<Future<List<ThingModel>>> {
  final imageService = _ImageServiceWrapper();

  @override
  Future<List<ThingModel>> build() async => await getThings();

  Future<List<String>> getCategories() async {
    final response = await LendingApi.getCategories();
    return (response.data as List).map((e) => e.toString()).sorted().toList();
  }

  Future<List<ThingModel>> getThings({String? filter}) async {
    final response = await LendingApi.fetchThings();
    final objects = response.data as List;
    final things = objects.map((e) => ThingModel.fromJson(e)).toList();

    if (filter == null) {
      return things;
    }

    return things
        .where((t) => t.name.toLowerCase().contains(filter.toLowerCase()))
        .toList();
  }

  Future<DetailedThingModel> getThingDetails({required String id}) async {
    final response = await LendingApi.fetchThing(id: id);
    return DetailedThingModel.fromJson(response.data as Map<String, dynamic>);
  }

  Future<ItemModel?> getItem({required int number}) async {
    try {
      final response = await LendingApi.fetchInventoryItem(number: number);
      return ItemModel.fromJson(response.data as Map<String, dynamic>);
    } catch (_) {
      return null;
    }
  }

  Future<ThingModel> createThing({
    required String name,
    String? spanishName,
  }) async {
    final response = await LendingApi.createThing(
      name: name,
      spanishName: spanishName,
    );

    ref.invalidateSelf();

    return ThingModel.fromJson(response.data as Map<String, dynamic>);
  }

  Future<void> updateThing({
    required String thingId,
    String? name,
    String? spanishName,
    bool? hidden,
    bool? eyeProtection,
    List<String>? categories,
    UpdatedImageModel? image,
  }) async {
    if (image != null && image.bytes == null) {
      await deleteThingImage(thingId: thingId);
    }

    if (categories != null) {
      await LendingApi.updateThingCategories(thingId, categories: categories);
    }

    await LendingApi.updateThing(
      thingId,
      name: name,
      spanishName: spanishName,
      hidden: hidden,
      eyeProtection: eyeProtection,
      image: await _convert(image),
    );

    ref.invalidateSelf();
  }

  Future<ImageDTO?> _convert(UpdatedImageModel? updatedImage) async {
    if (updatedImage == null || updatedImage.bytes == null || kDebugMode) {
      return null;
    }

    final result = await ImageService().uploadImage(
      bytes: updatedImage.bytes!,
      type: updatedImage.type!,
    );

    return ImageDTO(url: result.url);
  }

  Future<void> deleteThing(String id) async {
    await LendingApi.deleteThing(id);
    ref.invalidateSelf();
  }

  Future<void> deleteThingImage({required String thingId}) async {
    await LendingApi.deleteThingImage(thingId);
    ref.invalidateSelf();
  }

  Future<void> createItems({
    required String thingId,
    required int quantity,
    required String? brand,
    required String? condition,
    required String? description,
    required double? estimatedValue,
    required bool? hidden,
    required UpdatedImageModel? image,
    List<UpdatedImageModel>? manuals,
  }) async {
    final imageUrl = await imageService.uploadImage(image);

    final manualDTOs = manuals == null || kDebugMode
        ? null
        : await Future.wait(manuals.map((m) => imageService.uploadImageDTO(m)));

    await LendingApi.createInventoryItems(
      thingId,
      quantity: quantity,
      brand: brand,
      condition: condition,
      description: description,
      estimatedValue: estimatedValue,
      hidden: hidden,
      image: image == null ? null : ImageDTO(url: imageUrl),
      manuals: manualDTOs,
    );
    ref.invalidateSelf();
  }

  Future<void> updateItem(
    String id, {
    String? brand,
    String? description,
    String? condition,
    double? estimatedValue,
    bool? hidden,
    UpdatedImageModel? image,
    List<UpdatedImageModel>? manuals,
  }) async {
    final imageUrl = await imageService.uploadImage(image);

    final manualDTOs = manuals == null || kDebugMode
        ? null
        : await Future.wait(manuals.map((m) => imageService.uploadImageDTO(m)));

    await LendingApi.updateInventoryItem(
      id,
      brand: brand,
      condition: condition,
      description: description,
      estimatedValue: estimatedValue,
      hidden: hidden,
      image: image == null ? null : ImageDTO(url: imageUrl),
      manuals: manualDTOs,
    );

    ref.invalidateSelf();
  }

  Future<void> deleteItem(String id) async {
    await LendingApi.deleteInventoryItem(id);
    ref.invalidateSelf();
  }
}

class _ImageServiceWrapper {
  static final _service = ImageService();

  Future<String?> uploadImage(UpdatedImageModel? image) async {
    if (image?.bytes == null || kDebugMode) {
      return null;
    }

    final result = await _service.uploadImage(
      bytes: image!.bytes!,
      type: image.type!,
    );

    return result.url;
  }

  Future<ImageDTO> uploadImageDTO(UpdatedImageModel image) async {
    if (image.existingUrl != null) {
      return ImageDTO(url: image.existingUrl, name: image.name);
    }

    final result = await _service.uploadImage(
      bytes: image.bytes!,
      type: image.type!,
      path: image.name,
    );

    return ImageDTO(url: result.url, name: image.name);
  }
}

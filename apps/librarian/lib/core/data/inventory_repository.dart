import 'dart:convert';

import 'package:collection/collection.dart';
import 'package:flutter/foundation.dart';
import 'package:librarian_app/core/config/mode.dart';
import 'package:librarian_app/core/models/detailed_thing_model.dart';
import 'package:librarian_app/core/models/image_upload_model.dart';
import 'package:librarian_app/core/models/item_model.dart';
import 'package:librarian_app/core/models/thing_model.dart';
import 'package:librarian_app/core/models/updated_image_model.dart';
import 'package:librarian_app/core/services/image_service.dart';
import 'package:librarian_app/core/supabase.dart';

final inventoryRepository =
    appMode.isDemo ? FakeInventoryRepository() : SupabaseInventoryRepository();

abstract class InventoryRepository {
  Future<List<ThingCategory>> getCategories();

  Future<List<ThingModel>> getThings({String? filter});

  Future<List<ThingModel>> getCachedThingsById(Iterable<String> ids);

  Future<DetailedThingModel> getThingDetails({required String id});

  Future<List<ItemModel>> getItems();

  Future<ItemModel?> getItem({required int number});

  Future<void> createThing({
    required String name,
    String? spanishName,
  });

  Future<void> updateThing({
    required String thingId,
    String? name,
    String? spanishName,
    bool? hidden,
    bool? eyeProtection,
    List<ThingCategory>? categories,
    List<LinkedThing>? linkedThings,
    UpdatedImageModel? image,
  });

  Future<void> deleteThing(String id);

  Future<void> createItems({
    required String thingId,
    required int quantity,
    required String? brand,
    required String? condition,
    required String? notes,
    required double? estimatedValue,
    required bool? hidden,
    required UpdatedImageModel? image,
    List<UpdatedImageModel>? manuals,
  });

  Future<void> updateItem(
    String id, {
    String? brand,
    String? notes,
    String? condition,
    double? estimatedValue,
    bool? hidden,
    UpdatedImageModel? image,
    List<UpdatedImageModel>? manuals,
  });

  Future<void> convertItem(String id, String thingId);

  Future<void> deleteItem(String id);
}

class SupabaseInventoryRepository implements InventoryRepository {
  @override
  Future<List<ThingCategory>> getCategories() async {
    final data = await supabase.from('categories').select();
    return data
        .map(
            (e) => ThingCategory(id: e['id'] as int, name: e['name'] as String))
        .sorted((a, b) => a.name.compareTo(b.name))
        .toList();
  }

  @override
  Future<List<ThingModel>> getThings({String? filter}) async {
    final data = await supabase.from('things').select('''
        *,
        items (
          stock:count
        ),
        loans:loans_items (
          unavailable:count
        )
      ''').eq('loans.returned', false).order('name', ascending: true);

    final things = data.map((e) => ThingModel.fromQuery(e)).toList();

    if (filter == null) {
      return things;
    }

    return things
        .where((t) => t.name.toLowerCase().contains(filter.toLowerCase()))
        .toList();
  }

  @override
  Future<List<ThingModel>> getCachedThingsById(Iterable<String> ids) async {
    final all = await getThings();
    return all.where((t) => ids.contains(t.id)).toList();
  }

  @override
  Future<DetailedThingModel> getThingDetails({required String id}) async {
    final data = await supabase
        .from('things')
        .select('''
        *,
        associations:things_associations!things_associations_thing_id_fkey (
          id,
          things!things_associations_associated_thing_id_fkey ( name )
        ),
        categories ( * ),
        images:thing_images ( url ),
        items (
          *,
          active_loans:loans_items (count),
          loans:loans_items (count),
          attachments:item_attachments (*),
          images:item_images (*),
          thing:things (*)
        ),
        unavailable_items:loans_items (count)
      ''')
        .eq('id', int.parse(id))
        .eq('unavailable_items.returned', false)
        .eq('items.active_loans.returned', false)
        .limit(1)
        .single();

    if (kDebugMode) {
      print(jsonEncode(data));
    }

    return DetailedThingModel.fromQuery(data);
  }

  @override
  Future<List<ItemModel>> getItems() async {
    final data = await supabase.from('items').select('''
            *,
            active_loans:loans_items (count),
            loans:loans_items (count),
            attachments:item_attachments (*),
            images:item_images (*),
            thing:things (*)
          ''').eq('active_loans.returned', false);

    return data.map((e) => ItemModel.fromQuery(e)).toList();
  }

  @override
  Future<ItemModel?> getItem({required int number}) async {
    try {
      final data = await supabase
          .from('items')
          .select('''
            *,
            active_loans:loans_items (count),
            loans:loans_items (count),
            attachments:item_attachments (*),
            images:item_images (*),
            thing:things (*)
          ''')
          .eq('number', number)
          .eq('active_loans.returned', false)
          .limit(1)
          .single();

      if (kDebugMode) {
        print(jsonEncode(data));
      }

      return ItemModel.fromQuery(data);
    } catch (_) {
      return null;
    }
  }

  @override
  Future<void> createThing({
    required String name,
    String? spanishName,
  }) async {
    await supabase.from('things').insert({
      'name': name,
      'spanish_name': spanishName,
    });
  }

  // TODO: This is a dreadful mess which can be fixed by introducing auto-save
  @override
  Future<void> updateThing({
    required String thingId,
    String? name,
    String? spanishName,
    bool? hidden,
    bool? eyeProtection,
    List<ThingCategory>? categories,
    List<LinkedThing>? linkedThings,
    UpdatedImageModel? image,
  }) async {
    final id = int.parse(thingId);

    final values = {};

    if (name != null) {
      values['name'] = name;
    }

    if (spanishName != null) {
      values['spanish_name'] = spanishName;
    }

    if (eyeProtection != null) {
      values['eye_protection'] = eyeProtection;
    }

    if (hidden != null) {
      values['hidden'] = hidden;
    }

    await supabase.from('things').update(values).eq('id', id);

    if (linkedThings != null) {
      await supabase.from('things_associations').delete().eq('thing_id', id);

      await supabase.from('things_associations').insert(linkedThings
          .map((t) => {'thing_id': id, 'associated_thing_id': int.parse(t.id)})
          .toList());
    }

    if (categories != null) {
      await supabase.from('thing_categories').delete().eq('thing_id', id);

      await supabase.from('thing_categories').insert(categories
          .map((c) => {'thing_id': id, 'category_id': c.id})
          .toList());
    }

    if (image != null && image.bytes == null) {
      await supabase.from('thing_images').delete().eq('thing_id', id);
    } else {
      final uploadedImage = await uploadImage(image);
      if (uploadedImage != null) {
        await supabase.from('thing_images').delete().eq('thing_id', id);

        await supabase
            .from('thing_images')
            .insert({'thing_id': id, 'url': uploadedImage.url});
      }
    }
  }

  Future<ImageUploadModel?> uploadImage(UpdatedImageModel? updatedImage) async {
    if (updatedImage == null || updatedImage.bytes == null) {
      return null;
    }

    final result = await ImageService.instance.uploadImage(
      bytes: updatedImage.bytes!,
      type: updatedImage.type!,
    );

    return ImageUploadModel(url: result.url);
  }

  Future<List<ImageUploadModel>?> uploadImages(
      List<UpdatedImageModel>? images) async {
    if (images == null) {
      return null;
    }

    final uploads = images.map((image) => ImageService.instance
        .uploadImage(bytes: image.bytes!, type: image.type!));
    final results = await Future.wait(uploads);

    return results.map((r) => ImageUploadModel(url: r.url)).toList();
  }

  @override
  Future<void> deleteThing(String id) async {
    await supabase.from('things').delete().eq('id', int.parse(id));
  }

  // Future<void> deleteThingImage({required String thingId}) async {
  //   await supabase
  //       .from('thing_images')
  //       .delete()
  //       .eq('thing_id', int.parse(thingId));
  // }

  @override
  Future<void> createItems({
    required String thingId,
    required int quantity,
    required String? brand,
    required String? condition,
    required String? notes,
    required double? estimatedValue,
    required bool? hidden,
    required UpdatedImageModel? image,
    List<UpdatedImageModel>? manuals,
  }) async {
    final values = List.generate(quantity, (_) {
      return {
        'thing_id': int.parse(thingId),
        'brand': brand,
        'estimated_value': estimatedValue,
        'hidden': hidden,
        'notes': notes,
        'status': condition,
      };
    });

    final ids = await supabase.from('items').insert(values).select();

    final imageUrl = await uploadImage(image);
    if (imageUrl != null) {
      await supabase.from('item_images').insert(ids.map((v) {
            return {
              'item_id': v['id'] as int,
              'url': imageUrl.url,
            };
          }).toList());
    }

    final manualUrls = await uploadImages(manuals);
    if (manualUrls != null) {
      for (final url in manualUrls) {
        await supabase.from('item_attachments').insert(ids.map((v) {
              return {
                'item_id': v['id'] as int,
                'name': 'Manual',
                'url': url.url,
              };
            }).toList());
      }
    }
  }

  @override
  Future<void> updateItem(
    String id, {
    String? brand,
    String? notes,
    String? condition,
    double? estimatedValue,
    bool? hidden,
    UpdatedImageModel? image,
    List<UpdatedImageModel>? manuals,
  }) async {
    final values = {};

    if (brand != null) {
      values['brand'] = brand;
    }

    if (notes != null) {
      values['notes'] = notes;
    }

    if (condition != null) {
      values['status'] = condition;
    }

    if (estimatedValue != null) {
      values['estimated_value'] = estimatedValue;
    }

    if (hidden != null) {
      values['hidden'] = hidden;
    }

    final itemId = int.parse(id);
    await supabase.from('items').update(values).eq('id', itemId);

    if (image != null) {
      await supabase.from('item_images').delete().eq('item_id', itemId);
    }

    final imageUrl = await uploadImage(image);
    if (imageUrl != null) {
      await supabase.from('item_images').insert({
        'item_id': itemId,
        'url': imageUrl.url,
      });
    }

    // TODO: unable to remove existing manuals
    final manualUrls = await uploadImages(manuals);
    if (manualUrls != null) {
      for (final url in manualUrls) {
        await supabase.from('item_attachments').insert({
          'item_id': itemId,
          'name': 'Manual',
          'url': url.url,
        });
      }
    }
  }

  @override
  Future<void> convertItem(String id, String thingId) async {
    await supabase
        .from('items')
        .update({'thing_id': int.parse(thingId)}).eq('id', int.parse(id));
  }

  @override
  Future<void> deleteItem(String id) async {
    await supabase.from('items').delete().eq('id', int.parse(id));
  }
}

class FakeInventoryRepository implements InventoryRepository {
  @override
  Future<List<ThingCategory>> getCategories() async {
    return [
      ThingCategory(id: 1, name: 'Audio'),
      ThingCategory(id: 2, name: 'Visual'),
      ThingCategory(id: 3, name: 'Computer'),
    ];
  }

  @override
  Future<List<ThingModel>> getThings({String? filter}) async {
    return [
      ThingModel(
        id: '1',
        name: 'The Great Gatsby',
        spanishName: 'El Gran Gatsby',
        hidden: false,
        stock: 5,
        available: 4,
      ),
    ];
  }

  @override
  Future<List<ThingModel>> getCachedThingsById(Iterable<String> ids) async {
    return getThings()
        .then((things) => things.where((t) => ids.contains(t.id)).toList());
  }

  @override
  Future<DetailedThingModel> getThingDetails({required String id}) async {
    final things = await getThings();
    final thing = things.firstWhere((t) => t.id == id);

    return DetailedThingModel(
      id: thing.id,
      name: thing.name,
      spanishName: thing.spanishName,
      hidden: thing.hidden,
      eyeProtection: false,
      categories: [ThingCategory(id: 1, name: 'Books')],
      linkedThings: [],
      images: [],
      stock: thing.stock,
      available: thing.available,
      items: [],
    );
  }

  @override
  Future<List<ItemModel>> getItems() async {
    return [];
  }

  @override
  Future<ItemModel?> getItem({required int number}) async {
    return null;
  }

  @override
  Future<void> createThing({
    required String name,
    String? spanishName,
  }) async {}

  @override
  Future<void> updateThing({
    required String thingId,
    String? name,
    String? spanishName,
    bool? hidden,
    bool? eyeProtection,
    List<ThingCategory>? categories,
    List<LinkedThing>? linkedThings,
    UpdatedImageModel? image,
  }) async {}

  @override
  Future<void> deleteThing(String id) {
    return Future.delayed(const Duration(seconds: 1));
  }

  @override
  Future<void> convertItem(String id, String thingId) {
    return Future.delayed(const Duration(seconds: 1));
  }

  @override
  Future<void> createItems(
      {required String thingId,
      required int quantity,
      required String? brand,
      required String? condition,
      required String? notes,
      required double? estimatedValue,
      required bool? hidden,
      required UpdatedImageModel? image,
      List<UpdatedImageModel>? manuals}) {
    return Future.delayed(const Duration(seconds: 1));
  }

  @override
  Future<void> deleteItem(String id) {
    return Future.delayed(const Duration(seconds: 1));
  }

  @override
  Future<void> updateItem(String id,
      {String? brand,
      String? notes,
      String? condition,
      double? estimatedValue,
      bool? hidden,
      UpdatedImageModel? image,
      List<UpdatedImageModel>? manuals}) {
    return Future.delayed(const Duration(seconds: 1));
  }
}

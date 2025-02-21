import 'dart:convert';

import 'package:collection/collection.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:librarian_app/core/services/image_service.dart';
import 'package:librarian_app/core/supabase.dart';

import '../models/detailed_thing_model.dart';
import '../models/image_upload_model.dart';
import '../models/item_model.dart';
import '../models/thing_model.dart';
import '../models/updated_image_model.dart';

class InventoryRepository extends Notifier<Future<List<ThingModel>>> {
  @override
  Future<List<ThingModel>> build() async => await getThings();

  Future<List<ThingCategory>> getCategories() async {
    final data = await supabase.from('categories').select();
    return data
        .map(
            (e) => ThingCategory(id: e['id'] as int, name: e['name'] as String))
        .sorted((a, b) => a.name.compareTo(b.name))
        .toList();
  }

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

  Future<List<ThingModel>> getCachedThingsById(Iterable<String> ids) async {
    final all = await state;
    return all.where((t) => ids.contains(t.id)).toList();
  }

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

  Future<void> createThing({
    required String name,
    String? spanishName,
  }) async {
    await supabase.from('things').insert({
      'name': name,
      'spanish_name': spanishName,
    });

    ref.invalidateSelf();
  }

  // TODO: This is a dreadful mess which can be fixed by introducing auto-save
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

    ref.invalidateSelf();
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

  Future<void> deleteThing(String id) async {
    await supabase.from('things').delete().eq('id', int.parse(id));
    ref.invalidateSelf();
  }

  Future<void> deleteThingImage({required String thingId}) async {
    await supabase
        .from('thing_images')
        .delete()
        .eq('thing_id', int.parse(thingId));
    ref.invalidateSelf();
  }

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

    ref.invalidateSelf();
  }

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

    ref.invalidateSelf();
  }

  Future<void> convertItem(String id, String thingId) async {
    await supabase
        .from('items')
        .update({'thing_id': int.parse(thingId)}).eq('id', int.parse(id));
    ref.invalidateSelf();
  }

  Future<void> deleteItem(String id) async {
    await supabase.from('items').delete().eq('id', int.parse(id));
    ref.invalidateSelf();
  }
}

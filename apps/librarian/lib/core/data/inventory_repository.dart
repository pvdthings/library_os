import 'dart:convert';

import 'package:collection/collection.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:librarian_app/core/api/api.dart' as api;
import 'package:librarian_app/core/services/image_service.dart';
import 'package:librarian_app/core/api/models/updated_image_model.dart';
import 'package:librarian_app/core/supabase.dart';

import '../api/models/detailed_thing_model.dart';
import '../api/models/item_model.dart';
import '../api/models/thing_model.dart';

class InventoryRepository extends Notifier<Future<List<ThingModel>>> {
  final imageService = ImageService();

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
      ''').eq('loans.returned', false);

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

  Future<api.ImageDTO?> uploadImage(UpdatedImageModel? updatedImage) async {
    if (updatedImage == null || updatedImage.bytes == null) {
      return null;
    }

    final result = await ImageService().uploadImage(
      bytes: updatedImage.bytes!,
      type: updatedImage.type!,
    );

    return api.ImageDTO(url: result.url);
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

    if (manuals != null) {
      // add attachments
    }

    // OLD
    // final imageUrl = await imageService.uploadImage(image);

    // final manualDTOs = manuals == null || kDebugMode
    //     ? null
    //     : await Future.wait(manuals.map((m) => imageService.uploadImageDTO(m)));

    // await api.createInventoryItems(
    //   thingId,
    //   quantity: quantity,
    //   brand: brand,
    //   condition: condition,
    //   notes: notes,
    //   estimatedValue: estimatedValue,
    //   hidden: hidden,
    //   image: image == null ? null : api.ImageDTO(url: imageUrl),
    //   manuals: manualDTOs,
    // );
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
    // final imageUrl = await imageService.uploadImage(image);

    // final manualDTOs = manuals == null || kDebugMode
    //     ? null
    //     : await Future.wait(manuals.map((m) => imageService.uploadImageDTO(m)));

    // await api.updateInventoryItem(
    //   id,
    //   brand: brand,
    //   condition: condition,
    //   notes: notes,
    //   estimatedValue: estimatedValue,
    //   hidden: hidden,
    //   image: image == null ? null : api.ImageDTO(url: imageUrl),
    //   manuals: manualDTOs,
    // );

    ref.invalidateSelf();
  }

  Future<void> convertItem(String id, String thingId) async {
    await api.convertInventoryItem(id, thingId);
    ref.invalidateSelf();
  }

  Future<void> deleteItem(String id) async {
    await api.deleteInventoryItem(id);
    ref.invalidateSelf();
  }
}

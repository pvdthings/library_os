import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:librarian_app/core/api/models/detailed_thing_model.dart';
import 'package:librarian_app/core/api/models/image_model.dart';
import 'package:librarian_app/core/api/models/updated_image_model.dart';
import 'package:librarian_app/modules/things/providers/selected_thing_provider.dart';
import 'package:librarian_app/modules/things/providers/thing_details_provider.dart';
import 'package:librarian_app/modules/things/providers/things_repository_provider.dart';

final nameProvider = StateProvider<String?>((ref) => null);

final spanishNameProvider = StateProvider<String?>((ref) => null);

final hiddenProvider = StateProvider<bool?>((ref) => null);

final eyeProtectionProvider = StateProvider<bool?>((ref) => null);

final categoriesProvider = StateProvider<List<ThingCategory>?>((ref) => null);

final linkedThingsProvider = StateProvider<List<LinkedThing>?>((ref) => null);

final imageProvider = StateProvider<ImageModel?>((ref) => null);

final imageUploadProvider = StateProvider<UpdatedImageModel?>((ref) => null);

final unsavedChangesProvider = Provider<bool>((ref) {
  return ref.watch(nameProvider) != null ||
      ref.watch(spanishNameProvider) != null ||
      ref.watch(hiddenProvider) != null ||
      ref.watch(eyeProtectionProvider) != null ||
      ref.watch(imageUploadProvider) != null ||
      ref.watch(categoriesProvider) != null ||
      ref.watch(linkedThingsProvider) != null;
});

class ThingDetailsEditor {
  ThingDetailsEditor(this.ref);

  final Ref ref;

  Future<void> save() async {
    await ref.read(thingsRepositoryProvider.notifier).updateThing(
        thingId: ref.read(selectedThingProvider)!.id,
        name: ref.read(nameProvider),
        spanishName: ref.read(spanishNameProvider),
        hidden: ref.read(hiddenProvider),
        eyeProtection: ref.read(eyeProtectionProvider),
        categories: ref.read(categoriesProvider),
        linkedThings: ref.read(linkedThingsProvider),
        image: ref.read(imageUploadProvider));
    discardChanges();
  }

  void discardChanges() {
    ref.read(nameProvider.notifier).state = null;
    ref.read(spanishNameProvider.notifier).state = null;
    ref.read(hiddenProvider.notifier).state = null;
    ref.read(eyeProtectionProvider.notifier).state = null;
    ref.read(categoriesProvider.notifier).state = null;
    ref.read(linkedThingsProvider.notifier).state = null;
    ref.read(imageUploadProvider.notifier).state = null;
    ref.invalidate(thingDetailsProvider);
  }
}

final thingDetailsEditorProvider = Provider((ref) => ThingDetailsEditor(ref));

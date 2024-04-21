import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:librarian_app/src/features/inventory/models/image_model.dart';
import 'package:librarian_app/src/features/inventory/models/updated_image_model.dart';
import 'package:librarian_app/src/features/inventory/providers/selected_thing_provider.dart';
import 'package:librarian_app/src/features/inventory/providers/thing_details_provider.dart';
import 'package:librarian_app/src/features/inventory/providers/things_repository_provider.dart';

final nameProvider = StateProvider<String?>((ref) => null);

final spanishNameProvider = StateProvider<String?>((ref) => null);

final hiddenProvider = StateProvider<bool?>((ref) => null);

final eyeProtectionProvider = StateProvider<bool?>((ref) => null);

final categoriesProvider = StateProvider<List<String>?>((ref) => null);

final imageProvider = StateProvider<ImageModel?>((ref) => null);

final imageUploadProvider = StateProvider<UpdatedImageModel?>((ref) => null);

final unsavedChangesProvider = Provider<bool>((ref) {
  return ref.watch(nameProvider) != null ||
      ref.watch(spanishNameProvider) != null ||
      ref.watch(hiddenProvider) != null ||
      ref.watch(eyeProtectionProvider) != null ||
      ref.watch(imageUploadProvider) != null ||
      ref.watch(categoriesProvider) != null;
});

class ThingDetailsEditor {
  ThingDetailsEditor(this.ref);

  final ProviderRef ref;

  Future<void> save() async {
    await ref.read(thingsRepositoryProvider.notifier).updateThing(
        thingId: ref.read(selectedThingProvider)!.id,
        name: ref.read(nameProvider),
        spanishName: ref.read(spanishNameProvider),
        hidden: ref.read(hiddenProvider),
        eyeProtection: ref.read(eyeProtectionProvider),
        categories: ref.read(categoriesProvider),
        image: ref.read(imageUploadProvider));
    discardChanges();
  }

  void discardChanges() {
    ref.read(nameProvider.notifier).state = null;
    ref.read(spanishNameProvider.notifier).state = null;
    ref.read(hiddenProvider.notifier).state = null;
    ref.read(eyeProtectionProvider.notifier).state = null;
    ref.read(categoriesProvider.notifier).state = null;
    ref.read(imageUploadProvider.notifier).state = null;
    ref.invalidate(thingDetailsProvider);
  }
}

final thingDetailsEditorProvider = Provider((ref) => ThingDetailsEditor(ref));

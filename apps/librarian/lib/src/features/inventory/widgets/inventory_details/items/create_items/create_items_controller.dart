import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:librarian_app/src/core/file_data.dart';
import 'package:librarian_app/src/core/pick_file.dart';
import 'package:librarian_app/src/features/inventory/data/inventory_repository.dart';
import 'package:librarian_app/src/features/inventory/models/updated_image_model.dart';

import '../../../../models/thing_model.dart';
import '../item_manuals_card.dart';

class CreateItemsController extends ChangeNotifier {
  CreateItemsController({
    required this.thing,
    this.repository,
    this.onSave,
    this.onSaveComplete,
  });

  final ThingModel thing;
  final InventoryRepository? repository;
  final Function()? onSave;
  final Function()? onSaveComplete;

  late final hiddenNotifier = ValueNotifier<bool>(false)
    ..addListener(notifyListeners);

  late final brandController = TextEditingController()
    ..addListener(notifyListeners);

  late final descriptionController = TextEditingController()
    ..addListener(notifyListeners);

  late final estimatedValueController = TextEditingController()
    ..addListener(notifyListeners);

  late final conditionNotifier = ValueNotifier<String?>(null)
    ..addListener(notifyListeners);

  late final quantityController = TextEditingController(text: '1')
    ..addListener(notifyListeners);

  late final ValueNotifier<List<ManualData>> manualsNotifier = ValueNotifier([])
    ..addListener(notifyListeners);

  bool isLoading = false;

  FileData? _uploadedImage;

  Uint8List? get uploadedImageBytes => _uploadedImage?.bytes;

  void _replaceImage() async {
    final file = await pickImageFile();

    if (file != null) {
      _uploadedImage = file;
      notifyListeners();
    }
  }

  void Function()? get replaceImage {
    if (isLoading) {
      return null;
    }

    return _replaceImage;
  }

  void _removeImage() {
    _uploadedImage = null;
    notifyListeners();
  }

  void Function()? get removeImage {
    if (_uploadedImage == null) {
      return null;
    }

    return _removeImage;
  }

  void addManual() async {
    final file = await pickDocumentFile();
    if (file == null) {
      return;
    }

    final existing = manualsNotifier.value;
    manualsNotifier.value = [...existing, ManualData.fromFile(file)];
  }

  void removeManual(int index) {
    final existing = manualsNotifier.value;
    existing.removeAt(index);
    manualsNotifier.value = [...existing];
  }

  void _saveChanges() async {
    onSave?.call();

    final quantity = int.parse(quantityController.text);
    final estimatedValue = double.tryParse(estimatedValueController.text);

    await repository?.createItems(
      thingId: thing.id,
      quantity: quantity,
      brand: brandController.text,
      condition: conditionNotifier.value,
      description: descriptionController.text,
      estimatedValue: estimatedValue,
      hidden: hiddenNotifier.value,
      image: createUpdatedImageModel(),
      manuals: manualsNotifier.value
          .map((m) => UpdatedImageModel(
                type: m.data?.type,
                bytes: m.data?.bytes,
                name: m.name,
              ))
          .toList(),
    );

    onSaveComplete?.call();
  }

  UpdatedImageModel? createUpdatedImageModel() {
    if (uploadedImageBytes != null) {
      return UpdatedImageModel(
        type: _uploadedImage!.type,
        bytes: _uploadedImage!.bytes,
        name: _uploadedImage!.name,
      );
    }

    return null;
  }

  void Function()? get saveChanges {
    if (isLoading || repository == null) {
      return null;
    }

    return _saveChanges;
  }
}

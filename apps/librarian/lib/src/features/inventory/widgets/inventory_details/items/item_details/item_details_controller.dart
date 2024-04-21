import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:librarian_app/src/core/file_data.dart';
import 'package:librarian_app/src/core/pick_file.dart';
import 'package:librarian_app/src/features/inventory/data/inventory_repository.dart';
import 'package:librarian_app/src/features/inventory/models/updated_image_model.dart';
import 'package:librarian_app/src/features/inventory/widgets/inventory_details/items/item_manuals_card.dart';
import 'package:librarian_app/src/utils/format.dart';

import '../../../../models/item_model.dart';

class ItemDetailsController extends ChangeNotifier {
  ItemDetailsController({
    this.item,
    this.repository,
    this.onSave,
    this.onSaveComplete,
  }) {
    _loadItemDetails();
  }

  ItemModel? item;
  final InventoryRepository? repository;
  final Function()? onSave;
  final Function()? onSaveComplete;

  late ValueNotifier<bool> hiddenNotifier = ValueNotifier(false)
    ..addListener(notifyListeners);
  late TextEditingController brandController = TextEditingController()
    ..addListener(notifyListeners);
  late TextEditingController descriptionController = TextEditingController()
    ..addListener(notifyListeners);
  late TextEditingController estimatedValueController = TextEditingController()
    ..addListener(notifyListeners);
  late ValueNotifier<String?> conditionNotifier = ValueNotifier(null)
    ..addListener(notifyListeners);
  late ValueNotifier<List<ManualData>> manualsNotifier = ValueNotifier([])
    ..addListener(notifyListeners);

  late List<ManualData> _originalManuals = [];

  bool isLoading = false;

  Future<void> _loadItemDetails() async {
    isLoading = true;
    notifyListeners();

    item = await repository?.getItem(number: item!.number);

    hiddenNotifier.value = (item?.hidden ?? false);

    if (item?.brand != null) {
      brandController.text = item!.brand!;
    }

    if (item?.description != null) {
      descriptionController.text = item!.description!;
    }

    final estimatedValue = formatNumber(item?.estimatedValue);
    if (estimatedValue != null) {
      estimatedValueController.text = estimatedValue;
    }

    if (item?.condition != null) {
      conditionNotifier.value = item!.condition!;
    }

    if (item != null) {
      final manualData = item!.manuals
          .map((m) => ManualData(name: m.filename, url: m.url))
          .toList();
      _originalManuals = manualData;
      manualsNotifier.value = manualData;
    }

    isLoading = false;
    notifyListeners();
  }

  bool _removeExistingImage = false;

  FileData? _uploadedImage;
  Uint8List? get uploadedImageBytes => _uploadedImage?.bytes;

  String? get existingImageUrl =>
      _removeExistingImage ? null : item?.imageUrls.firstOrNull;

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
    if (existingImageUrl != null) {
      _removeExistingImage = true;
    }

    _uploadedImage = null;
    notifyListeners();
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

  void Function()? get removeImage {
    if (existingImageUrl == null && _uploadedImage == null) {
      return null;
    }

    return _removeImage;
  }

  void _saveChanges() async {
    onSave?.call();

    final estimatedValue = double.tryParse(estimatedValueController.text);

    await repository?.updateItem(
      item!.id,
      brand: brandController.text,
      description: descriptionController.text,
      condition: conditionNotifier.value,
      estimatedValue: estimatedValue,
      hidden: hiddenNotifier.value,
      image: createUpdatedImageModel(),
      manuals: manualsNotifier.value
          .map((m) => UpdatedImageModel(
                type: m.data?.type,
                bytes: m.data?.bytes,
                name: m.name,
                existingUrl: m.url,
              ))
          .toList(),
    );

    _discardChanges();
    await _loadItemDetails();

    onSaveComplete?.call();
  }

  UpdatedImageModel? createUpdatedImageModel() {
    if (_removeExistingImage) {
      return const UpdatedImageModel(type: null, bytes: null);
    }

    if (_uploadedImage != null) {
      return UpdatedImageModel(
        type: _uploadedImage!.type,
        bytes: _uploadedImage!.bytes,
      );
    }

    return null;
  }

  void _discardChanges() {
    _uploadedImage = null;
    _removeExistingImage = false;
  }

  void Function()? get saveChanges {
    if (isLoading || item == null || repository == null) {
      return null;
    }

    if (hasUnsavedChanges) {
      return _saveChanges;
    }

    return null;
  }

  bool get hasUnsavedChanges {
    return _uploadedImage != null ||
        !listEquals(manualsNotifier.value, _originalManuals) ||
        hiddenNotifier.value != (item?.hidden ?? false) ||
        brandController.text != (item?.brand ?? '') ||
        descriptionController.text != (item?.description ?? '') ||
        estimatedValueController.text !=
            (formatNumber(item?.estimatedValue) ?? '') ||
        conditionNotifier.value != item?.condition ||
        _removeExistingImage;
  }
}

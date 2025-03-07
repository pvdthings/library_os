import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:librarian_app/core/core.dart';
import 'package:librarian_app/core/data/inventory_repository.dart';
import 'package:librarian_app/core/api/models/updated_image_model.dart';
import 'package:librarian_app/modules/things/convert/convert_dialog.dart';
import 'package:librarian_app/modules/things/details/inventory/item_manuals_card.dart';
import 'package:librarian_app/utils/format.dart';

import '../../../../../core/api/models/item_model.dart';

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

  late TextEditingController nameController;
  late ValueNotifier<bool> hiddenNotifier;
  late TextEditingController brandController;
  late TextEditingController notesController;
  late TextEditingController estimatedValueController;
  late ValueNotifier<String?> conditionNotifier;
  late ValueNotifier<List<ManualData>> manualsNotifier;

  late List<ManualData> _originalManuals = [];

  bool isLoading = false;

  Future<void> _loadItemDetails() async {
    isLoading = true;
    notifyListeners();

    item = await repository?.getItem(number: item!.number);

    nameController = TextEditingController(text: item!.name);
    hiddenNotifier = ValueNotifier(false)..addListener(notifyListeners);
    brandController = TextEditingController()..addListener(notifyListeners);
    notesController = TextEditingController()..addListener(notifyListeners);
    estimatedValueController = TextEditingController()
      ..addListener(notifyListeners);
    conditionNotifier = ValueNotifier(null)..addListener(notifyListeners);
    manualsNotifier = ValueNotifier([])..addListener(notifyListeners);

    hiddenNotifier.value = (item?.hidden ?? false);

    if (item?.brand != null) {
      brandController.text = item!.brand!;
    }

    if (item?.notes != null) {
      notesController.text = item!.notes!;
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

  Future<bool> convertThing(BuildContext context) {
    return showConvertDialog(context, item!.id).then((didConvert) {
      if (didConvert) {
        _loadItemDetails();

        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('Converted successfully!'),
        ));
      }

      return didConvert;
    });
  }

  void _saveChanges() async {
    onSave?.call();

    final estimatedValue = double.tryParse(estimatedValueController.text);

    await repository?.updateItem(
      item!.id,
      brand: brandController.text,
      notes: notesController.text,
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

  void discardChanges() {
    _discardChanges();
    _loadItemDetails();
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
        notesController.text != (item?.notes ?? '') ||
        estimatedValueController.text !=
            (formatNumber(item?.estimatedValue) ?? '') ||
        conditionNotifier.value != item?.condition ||
        _removeExistingImage;
  }
}

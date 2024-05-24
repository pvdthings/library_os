import 'package:flutter/material.dart';
import 'package:librarian_app/src/utils/format.dart';

import '../providers/actions_service_provider.dart';

class ActionWizardController extends ChangeNotifier {
  ActionWizardController(this.context, {required this.service});

  final BuildContext context;
  final ActionsService service;

  DateTime? _dueDate;

  DateTime? get dueDate => _dueDate;

  set dueDate(DateTime? value) {
    _dueDate = value;

    if (value != null) {
      dueDateController.text = formatDateForHumans(value);
    }

    notifyListeners();
  }

  final dueDateController = TextEditingController();

  bool _isLoading = false;

  bool get isLoading => _isLoading;

  set isLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  Future<void> Function()? get onExecute =>
      _dueDate != null && !isLoading ? _runAction : null;

  Future<void> _runAction() {
    isLoading = true;
    return service.extendAllDueDates(dueDate!).then((success) {
      Navigator.of(context).pop(success);

      if (success) {
        final dateString = formatDateForHumans(dueDate!);
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          showCloseIcon: true,
          content: Row(
            children: [
              Icon(
                Icons.electric_bolt_rounded,
                color: Theme.of(context).primaryColor,
              ),
              const SizedBox(width: 8),
              Text(
                  'Updating all dues dates to $dateString... This action may take several minutes to complete.'),
            ],
          ),
          duration: const Duration(seconds: 15),
        ));
      } else {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Row(
            children: [
              Icon(Icons.error, color: Colors.red),
              SizedBox(width: 8),
              Text('Whoops! Due dates could not be extended.'),
            ],
          ),
        ));
      }
    });
  }
}

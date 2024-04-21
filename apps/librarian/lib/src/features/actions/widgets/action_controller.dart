import 'package:flutter/material.dart';
import 'package:librarian_app/src/features/actions/providers/actions_service_provider.dart';
import 'package:librarian_app/src/features/actions/widgets/action_wizard.dart';
import 'package:librarian_app/src/features/actions/widgets/action_wizard_controller.dart';
import 'package:librarian_app/src/features/actions/widgets/action_wizard_dialog.dart';
import 'package:librarian_app/src/utils/media_query.dart';

class ActionController {
  const ActionController(this.context, {required this.service});

  final BuildContext context;
  final ActionsService service;

  Future<bool> isAuthorized() {
    return service.isAuthorizedToExtendAllDueDates();
  }

  void showWizard() {
    final isMobileScreen = isMobile(context);
    final controller = ActionWizardController(context, service: service);

    if (isMobileScreen) {
      Navigator.of(context).push(MaterialPageRoute(builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: ActionWizard(controller: controller),
        );
      }));
    } else {
      showDialog(
        context: context,
        builder: (context) => ActionWizardDialog(controller: controller),
      );
    }
  }
}

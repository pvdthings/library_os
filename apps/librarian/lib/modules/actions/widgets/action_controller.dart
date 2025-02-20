import 'package:flutter/material.dart';
import 'package:librarian_app/modules/actions/widgets/action_wizard.dart';
import 'package:librarian_app/modules/actions/widgets/action_wizard_controller.dart';
import 'package:librarian_app/modules/actions/widgets/action_wizard_dialog.dart';
import 'package:librarian_app/utils/media_query.dart';

class ActionController {
  const ActionController(this.context);

  final BuildContext context;

  Future<bool> isAuthorized() {
    // TODO: Use Supabase roles to determine authorization
    return Future.value(false);
  }

  void showWizard() {
    final isMobileScreen = isMobile(context);
    final controller = ActionWizardController(context);

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

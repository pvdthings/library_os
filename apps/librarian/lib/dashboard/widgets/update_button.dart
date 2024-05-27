import 'package:flutter/material.dart';
import 'package:librarian_app/modules/updates/notifiers/update_notifier.dart';
import 'package:librarian_app/modules/updates/widgets/update_dialog_controller.dart';

class UpdateButton extends StatelessWidget {
  const UpdateButton({super.key});

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: UpdateNotifier.instance,
      builder: (context, _) {
        final newVersion = UpdateNotifier.instance.newerVersion;

        if (newVersion == null) {
          return const SizedBox.shrink();
        }

        return IconButton(
          onPressed: () {
            UpdateDialogController(context).showUpdateDialog(newVersion);
          },
          tooltip: 'Update Available',
          icon: const Icon(Icons.update, color: Colors.amber),
        );
      },
    );
  }
}

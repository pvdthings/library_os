import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:librarian_app/src/features/actions/providers/actions_service_provider.dart';
import 'package:librarian_app/src/features/actions/widgets/action_controller.dart';
import 'package:librarian_app/src/features/actions/widgets/extend_active_loans/extend_active_loans.dart';
import 'package:librarian_app/src/utils/media_query.dart';
import 'package:librarian_app/src/widgets/detail.dart';

class Actions extends ConsumerWidget {
  const Actions({super.key});

  static const String notAuthorizedMessage =
      'You do not have permission to run this action.\nPlease contact an administrator.';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isMobileScreen = isMobile(context);

    return SizedBox(
      height: double.infinity,
      width: double.infinity,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Wrap(
            children: [
              // Currently hard-coded for a single action.
              FractionallySizedBox(
                widthFactor: isMobileScreen ? 1 : 0.33,
                child: _Action(
                  controller: ActionController(
                    context,
                    service: ref.read(actionsServiceProvider),
                  ),
                  title: ExtendActiveLoans.title,
                  description: ExtendActiveLoans.description,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _Action extends StatelessWidget {
  const _Action({
    required this.controller,
    required this.title,
    this.description,
  });

  final ActionController controller;
  final String title;
  final String? description;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        children: [
          ListTile(
            leading: const Icon(
              Icons.electric_bolt_rounded,
              color: Colors.amber,
            ),
            title: Text(title,
                style: Theme.of(context)
                    .textTheme
                    .bodyLarge!
                    .copyWith(fontSize: 20)),
          ),
          if (description != null)
            Detail(
              useListTile: true,
              label: 'Description',
              value: description!,
              valueFontSize: 18,
            ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                FutureBuilder(
                  future: controller.isAuthorized(),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return const CircularProgressIndicator();
                    }

                    final isAuthorized = snapshot.data ?? false;

                    final button = FilledButton(
                      onPressed: isAuthorized ? controller.showWizard : null,
                      child: const Text('Run Action'),
                    );

                    if (!isAuthorized) {
                      return Tooltip(
                        message: Actions.notAuthorizedMessage,
                        child: button,
                      );
                    }

                    return button;
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

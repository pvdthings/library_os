import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:librarian_app/modules/members/providers/edited_borrower_details_providers.dart';
import 'package:librarian_app/modules/members/details/member_details.dart';
import 'package:librarian_app/modules/members/providers/selected_borrower_provider.dart';
import 'package:librarian_app/widgets/dialogs/save_dialog.dart';
import 'package:librarian_app/widgets/panes/pane_header.dart';

import '../../../core/api/models/member_model.dart';

class MemberDetailsPane extends ConsumerWidget {
  final Future<MemberModel?> borrowerFuture;

  const MemberDetailsPane({
    super.key,
    required this.borrowerFuture,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Card(
      color: Theme.of(context).colorScheme.surfaceContainerHigh,
      clipBehavior: Clip.antiAlias,
      child: FutureBuilder(
        future: borrowerFuture,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text(snapshot.error!.toString()));
          }

          final loading = snapshot.connectionState == ConnectionState.waiting;
          final borrower = snapshot.data;

          return ref.watch(selectedBorrowerProvider) == null
              ? const Center(child: Text('Borrower Details'))
              : Column(
                  children: [
                    PaneHeader(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            loading ? '' : borrower!.name,
                            style: const TextStyle(
                              fontSize: 24,
                            ),
                          ),
                          Row(
                            children: [
                              if (ref.watch(unsavedChangesProvider)) ...[
                                Text(
                                  'Unsaved Changes',
                                  style: Theme.of(context)
                                      .textTheme
                                      .labelMedium!
                                      .copyWith(
                                        color: Colors.white.withOpacity(0.8),
                                        fontStyle: FontStyle.italic,
                                      ),
                                ),
                                const SizedBox(width: 8),
                              ],
                              IconButton(
                                onPressed: ref.watch(unsavedChangesProvider)
                                    ? () async {
                                        if (await showSaveDialog(context)) {
                                          ref
                                              .read(
                                                  borrowerDetailsEditorProvider)
                                              .save();
                                        }
                                      }
                                    : null,
                                icon: const Icon(Icons.save_rounded),
                                tooltip: 'Save',
                              ),
                              const SizedBox(width: 4),
                              IconButton(
                                onPressed: ref.watch(unsavedChangesProvider)
                                    ? () {
                                        ref
                                            .read(borrowerDetailsEditorProvider)
                                            .discardChanges();
                                      }
                                    : null,
                                icon: const Icon(Icons.cancel),
                                tooltip: 'Discard Changes',
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const Expanded(
                      child: SingleChildScrollView(
                        child: Padding(
                          padding: EdgeInsets.all(16),
                          child: MemberDetails(),
                        ),
                      ),
                    ),
                  ],
                );
        },
      ),
    );
  }
}

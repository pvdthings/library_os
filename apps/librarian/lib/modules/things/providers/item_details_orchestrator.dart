import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:librarian_app/core/api/models/item_model.dart';
import 'package:librarian_app/dashboard/providers/end_drawer_provider.dart';
import 'package:librarian_app/utils/media_query.dart';

import '../details/inventory/item_details/drawer.dart';
import '../details/inventory/item_details/item_details_controller.dart';
import '../details/inventory/item_details_page.dart';
import 'things_repository_provider.dart';

class ItemDetailsOrchestrator {
  ItemDetailsOrchestrator(this.ref);

  final Ref ref;

  void openItem(
    BuildContext context, {
    required ItemModel item,
    required bool hiddenLocked,
  }) {
    if (isMobile(context)) {
      Navigator.of(context).push(MaterialPageRoute(builder: (context) {
        return ItemDetailsPage(
          item: item,
          hiddenLocked: hiddenLocked,
        );
      }));
      return;
    }

    final detailsController = ItemDetailsController(
      item: item,
      repository: ref.read(thingsRepositoryProvider.notifier),
      onSave: () {
        // setState(() => _isLoading = true);
      },
      onSaveComplete: () {
        // setState(() => _isLoading = false);
      },
    );

    ref.read(endDrawerProvider).openEndDrawer(
          context,
          ItemDetailsDrawer(
            controller: detailsController,
            isHiddenLocked: hiddenLocked,
          ),
        );
  }
}

final itemDetailsOrchestrator = Provider((ref) => ItemDetailsOrchestrator(ref));

import 'package:flutter/material.dart';
import 'package:librarian_app/core/api/models/member_model.dart';
import 'package:librarian_app/core/api/models/item_model.dart';
import 'package:librarian_app/core/api/models/item_summary_model.dart';

import 'checkout_details.dart';

Step buildConfirmStep({
  required bool isActive,
  required MemberModel? borrower,
  required List<ItemModel> items,
  required DateTime dueDate,
  required void Function(DateTime) onDueDateUpdated,
}) {
  return Step(
    title: const Text('Confirm Details'),
    content: Padding(
      padding: const EdgeInsets.only(top: 8),
      child: CheckoutDetails(
        borrower: borrower,
        things: items
            .map((t) => ItemSummaryModel(
                  id: t.id,
                  name: t.name,
                  number: t.number,
                  images: [],
                ))
            .toList(),
        dueDate: dueDate,
        onDueDateUpdated: onDueDateUpdated,
      ),
    ),
    isActive: isActive,
  );
}

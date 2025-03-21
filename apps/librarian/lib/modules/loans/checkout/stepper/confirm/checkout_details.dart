import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:librarian_app/core/api/models/member_model.dart';
import 'package:librarian_app/widgets/detail.dart';
import 'package:librarian_app/core/api/models/thing_summary_model.dart';

class CheckoutDetails extends StatelessWidget {
  const CheckoutDetails({
    super.key,
    required this.borrower,
    required this.things,
    required this.dueDate,
    required this.onDueDateUpdated,
  });

  final MemberModel? borrower;
  final List<ThingSummaryModel> things;
  final DateTime dueDate;
  final void Function(DateTime newDate) onDueDateUpdated;

  DateTime get _twoWeeksAgo => DateTime.now().add(const Duration(days: -14));

  void showDateSelection(BuildContext context) async {
    showDatePicker(
      context: context,
      initialDate: dueDate,
      firstDate: kDebugMode ? _twoWeeksAgo : dueDate,
      lastDate: dueDate.add(const Duration(days: 14)),
    ).then((value) {
      if (value == null) return;
      onDueDateUpdated(value);
    });
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Detail(
            prefixIcon: const Icon(Icons.person),
            label: 'Borrower',
            value: borrower?.name,
          ),
          const SizedBox(height: 32),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ...things.map((thing) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: Detail(
                    prefixIcon: const Icon(Icons.build_rounded),
                    label: 'Item',
                    value: '#${thing.number} ${thing.name}',
                  ),
                );
              })
            ],
          ),
          const SizedBox(height: 32),
          Wrap(
            spacing: 16,
            runSpacing: 16,
            crossAxisAlignment: WrapCrossAlignment.end,
            children: [
              Detail(
                prefixIcon: const Icon(Icons.calendar_month),
                suffixIcon: TextButton(
                  onPressed: () {
                    showDateSelection(context);
                  },
                  child: const Text('Change'),
                ),
                label: 'Due Back',
                value: '${dueDate.month}/${dueDate.day}/${dueDate.year}',
              ),
            ],
          ),
          const SizedBox(height: 32),
        ],
      ),
    );
  }
}

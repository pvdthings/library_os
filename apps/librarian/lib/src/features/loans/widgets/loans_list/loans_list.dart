import 'package:flutter/material.dart';
import 'package:librarian_app/src/utils/media_query.dart';

import '../../models/loan_model.dart';

class LoansList extends StatelessWidget {
  final List<LoanModel> loans;
  final LoanModel? selected;
  final void Function(LoanModel loan)? onTap;

  const LoansList({
    super.key,
    required this.loans,
    this.selected,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: loans.length,
      itemBuilder: (context, index) {
        final loan = loans[index];

        final thingNumber = Text('#${loan.thing.number}');
        final thingName = Text(loan.thing.name);
        final borrowerInitials = Initials.convert(loan.borrower.name);
        final isSelected =
            loan.id == selected?.id && loan.thing.id == selected?.thing.id;
        final isSelectedShown = isMobile(context) ? false : isSelected;

        return ListTile(
          leading: Tooltip(
            message: loan.borrower.name,
            child: CircleAvatar(
              backgroundColor: isSelectedShown
                  ? Theme.of(context).primaryColor
                  : Colors.black38,
              child: Text(borrowerInitials),
            ),
          ),
          title: thingName,
          subtitle: thingNumber,
          trailing: loan.isOverdue
              ? const Tooltip(
                  message: 'Overdue',
                  child: Icon(Icons.warning_rounded),
                )
              : Text(
                  loan.isDueToday
                      ? 'Today'
                      : '${loan.dueDate.month}/${loan.dueDate.day}',
                  style: TextStyle(
                    fontSize: Theme.of(context).textTheme.bodyMedium?.fontSize,
                  ),
                ),
          selected: isSelectedShown,
          onTap: () => onTap?.call(loan),
        );
      },
      shrinkWrap: true,
    );
  }
}

class Initials {
  static String convert(String fullName) {
    final trimmedName = fullName.trim().toUpperCase();
    if (trimmedName.isEmpty) {
      return '?';
    }

    final firstLetter = trimmedName[0];

    final split = trimmedName.split(' ');
    final secondLetter = split.length > 1 ? split.last[0] : trimmedName[1];

    return firstLetter + secondLetter;
  }
}

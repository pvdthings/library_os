import 'package:flutter/material.dart';
import 'package:librarian_app/core/api/models/member_model.dart';

import 'item_summary_model.dart';

class LoanDetailsModel {
  final String id;
  final int parentLoanId;
  final int number;
  final ItemSummaryModel item;
  final MemberModel borrower;
  final DateTime checkedOutDate;
  final String? notes;
  final int remindersSent;
  DateTime dueDate;
  LoanDetailsModel? previousLoan;

  bool get isOverdue {
    final now = DateTime.now();
    return DateUtils.dateOnly(dueDate).isBefore(DateUtils.dateOnly(now));
  }

  bool get isDueToday => DateUtils.isSameDay(DateTime.now(), dueDate);

  LoanDetailsModel({
    required this.id,
    required this.parentLoanId,
    required this.number,
    required this.item,
    required this.borrower,
    required this.checkedOutDate,
    required this.dueDate,
    required this.remindersSent,
    this.notes,
    this.previousLoan,
  });

  factory LoanDetailsModel.fromQuery(
    Map<String, dynamic> data, {
    LoanDetailsModel? previousLoan,
  }) {
    final item = data['item'];
    final loan = data['loan'];
    final member = loan['member'];
    final thing = item['thing'];

    return LoanDetailsModel(
      id: data['id'].toString(),
      parentLoanId: loan['id'] as int,
      number: item['number'] as int,
      previousLoan: previousLoan,
      item: ItemSummaryModel(
        id: item['id'].toString(),
        name: thing['name'] as String,
        number: item['number'] as int,
        images: (item['images'] as List)
            .map((image) => image['url'] as String)
            .toList(),
      ),
      borrower: MemberModel(
        id: member['id'].toString(),
        name: member['name'] as String,
        email: member['email'] as String?,
        phone: member['phone'] as String?,
        joinDate: DateTime.parse(member['join_date']),
        issues: [],
      ),
      notes: loan['notes'] as String?,
      checkedOutDate: DateTime.parse(loan['checkout_date']),
      dueDate: DateTime.parse(loan['due_date']),
      remindersSent: loan['reminders_sent'] as int,
    );
  }
}

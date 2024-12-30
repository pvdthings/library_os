import 'package:flutter/material.dart';
import 'package:librarian_app/core/api/models/member_model.dart';

import 'item_summary_model.dart';

class LoanDetailsModel {
  final String id;
  final int parentLoanId;
  final int number;
  final ItemSummaryModel thing;
  final MemberModel borrower;
  final DateTime checkedOutDate;
  final String? notes;
  final int remindersSent;
  DateTime dueDate;
  DateTime? checkedInDate;

  bool get isOverdue {
    final now = DateTime.now();
    return DateUtils.dateOnly(dueDate).isBefore(DateUtils.dateOnly(now));
  }

  bool get isDueToday => DateUtils.isSameDay(DateTime.now(), dueDate);

  LoanDetailsModel({
    required this.id,
    required this.parentLoanId,
    required this.number,
    required this.thing,
    required this.borrower,
    required this.checkedOutDate,
    required this.dueDate,
    required this.remindersSent,
    this.checkedInDate,
    this.notes,
  });

  factory LoanDetailsModel.fromQuery(Map<String, dynamic> data) {
    final item = data['item'];
    final loan = data['loan'];
    final member = loan['member'];
    final thing = item['thing'];

    return LoanDetailsModel(
      id: data['id'].toString(),
      parentLoanId: loan['id'] as int,
      number: item['number'] as int,
      thing: ItemSummaryModel(
        id: item['id'].toString(),
        name: thing['name'] as String,
        number: item['number'] as int,
        images: (item['images'] as List)
            .map((image) => image['url'] as String)
            .toList(),
        lastLoanId: null, // TODO
      ),
      borrower: MemberModel(
        id: member['id'].toString(),
        name: member['name'] as String,
        email: member['email'] as String?,
        phone: member['phone'] as String?,
        joinDate: DateTime.parse(member['join_date']),
        issues: [], // TODO ?
      ),
      notes: loan['notes'] as String?,
      checkedOutDate: DateTime.parse(loan['checkout_date']),
      checkedInDate: null,
      dueDate: DateTime.parse(loan['due_date']),
      remindersSent: loan['reminders_sent'] as int,
    );
  }
}

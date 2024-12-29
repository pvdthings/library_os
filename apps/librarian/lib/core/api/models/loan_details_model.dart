import 'package:flutter/material.dart';
import 'package:librarian_app/core/api/models/member_model.dart';

import 'item_summary_model.dart';

class LoanDetailsModel {
  final String id;
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
    required this.number,
    required this.thing,
    required this.borrower,
    required this.checkedOutDate,
    required this.dueDate,
    required this.remindersSent,
    this.checkedInDate,
    this.notes,
  });

  factory LoanDetailsModel.fromJson(Map<String, dynamic> json) {
    return LoanDetailsModel(
      id: json['id'] as String? ?? '?',
      number: json['number'] as int,
      thing: ItemSummaryModel.fromJson(json['thing'] as Map<String, dynamic>),
      borrower: MemberModel(
        id: json['borrower']?['id'] as String? ?? '?',
        name: json['borrower']?['name'] as String? ?? '???',
        email: json['borrower']?['contact']['email'] as String?,
        phone: json['borrower']?['contact']['phone'] as String?,
        issues: [],
      ),
      notes: json['notes'] as String?,
      checkedOutDate: json['checkedOutDate'] != null
          ? DateTime.parse(json['checkedOutDate'] as String)
          : DateTime.now(),
      checkedInDate: json['checkedInDate'] != null
          ? DateTime.parse(json['checkedInDate'] as String)
          : null,
      dueDate: json['dueBackDate'] != null
          ? DateTime.parse(json['dueBackDate'])
          : DateTime.now(),
      remindersSent: json['remindersSent'] as int,
    );
  }

  factory LoanDetailsModel.fromQuery(Map<String, dynamic> data) {
    final item = data['item'];
    final loan = data['loan'];
    final member = loan['member'];
    final thing = item['thing'];

    return LoanDetailsModel(
      id: data['id'].toString(),
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

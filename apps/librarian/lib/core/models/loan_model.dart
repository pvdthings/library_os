import 'package:flutter/material.dart';
import 'package:librarian_app/core/models/member_model.dart';
import 'package:librarian_app/core/models/item_summary_model.dart';

class LoanModel {
  final String id;
  final int number;
  final ItemSummaryModel thing;
  final MemberModel borrower;
  final DateTime checkedOutDate;
  DateTime dueDate;
  DateTime? checkedInDate;

  bool get isOverdue {
    final now = DateTime.now();
    return DateUtils.dateOnly(dueDate).isBefore(DateUtils.dateOnly(now));
  }

  bool get isDueToday => DateUtils.isSameDay(DateTime.now(), dueDate);

  LoanModel({
    required this.id,
    required this.number,
    required this.thing,
    required this.borrower,
    required this.checkedOutDate,
    required this.dueDate,
  });

  factory LoanModel.fromQuery(Map<String, dynamic> data) {
    final item = data['item'];
    final loan = data['loan'];
    final member = loan['member'];
    final thing = item['thing'];

    return LoanModel(
      id: data['id'].toString(),
      number: item['number'] as int,
      thing: ItemSummaryModel(
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
        issues: [], // TODO ?
      ),
      checkedOutDate: DateTime.parse(loan['checkout_date']),
      dueDate: DateTime.parse(loan['due_date']),
    );
  }
}

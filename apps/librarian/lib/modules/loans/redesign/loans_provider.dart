import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:librarian_app/core/api/models/loan_model.dart';
import 'package:librarian_app/modules/loans/providers/loans_repository_provider.dart';

final loansProvider = FutureProvider((ref) async {
  final loans = await ref.watch(loansRepositoryProvider);
  final g = loans.groupListsBy((m) => m.borrower.id);
  final loanGroups = g.values.map((loans) {
    return LoanGroup(
      borrowerName: loans[0].borrower.name,
      duedate: DateTime.now(),
      loans: loans,
    );
  }).toList();

  return LoansViewModel(loanGroups);
});

class LoansViewModel {
  LoansViewModel(this._loanGroups);

  final List<LoanGroup> _loanGroups;

  List<LoanGroup> get all => _loanGroups;

  List<LoanGroup> get dueToday {
    return _loanGroups
        .where((l) => DateUtils.isSameDay(DateTime.now(), l.duedate))
        .toList();
  }

  List<LoanGroup> get overdue {
    return _loanGroups
        .where((l) => l.duedate.isBefore(DateTime.now()))
        .toList();
  }
}

class LoanGroup {
  LoanGroup({
    required this.borrowerName,
    required this.duedate,
    required this.loans,
  });

  final String borrowerName;
  final DateTime duedate;
  final List<LoanModel> loans;
}

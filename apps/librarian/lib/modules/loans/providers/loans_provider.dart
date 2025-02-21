import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:librarian_app/core/models/loan_model.dart';
import 'package:librarian_app/modules/loans/providers/loans_filter_provider.dart';
import 'package:librarian_app/providers/loans.dart';

final loansListProvider = FutureProvider((ref) async {
  final searchFilter = ref.watch(loansFilterProvider);
  final loans = await ref.watch(loansProvider);

  if (searchFilter == null || searchFilter.isEmpty) {
    return LoansListViewModel(loans: loans);
  }

  final filteredLoans = loans
      .where((l) =>
          l.borrower.name.toLowerCase().contains(searchFilter.toLowerCase()) ||
          l.thing.name.toLowerCase().contains(searchFilter.toLowerCase()) ||
          l.thing.number.toString() == searchFilter)
      .toList();

  return LoansListViewModel(loans: filteredLoans);
});

class LoansListViewModel {
  LoansListViewModel({required this.loans});

  final List<LoanModel> loans;
}

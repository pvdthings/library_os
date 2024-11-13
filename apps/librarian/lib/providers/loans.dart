import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:librarian_app/core/data/loans_repository.dart';

final loansProvider = Provider((ref) async {
  return await LoansRepository().getLoans();
});

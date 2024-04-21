import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:librarian_app/src/features/loans/data/loans_repository.dart';

import '../models/loan_model.dart';

final loansRepositoryProvider =
    NotifierProvider<LoansRepository, Future<List<LoanModel>>>(
        LoansRepository.new);

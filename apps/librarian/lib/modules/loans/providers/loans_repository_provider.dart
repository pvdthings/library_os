import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:librarian_app/core/data/loans_repository.dart';

import '../../../core/api/models/loan_model.dart';

final loansRepositoryProvider =
    NotifierProvider<LoansRepository, Future<List<LoanModel>>>(
        LoansRepository.new);

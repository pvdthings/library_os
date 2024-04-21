import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:librarian_app/src/features/borrowers/models/borrower_model.dart';
import 'package:librarian_app/src/features/borrowers/data/borrowers_repository.dart';

final borrowersRepositoryProvider =
    NotifierProvider<BorrowersRepository, Future<List<BorrowerModel>>>(
        BorrowersRepository.new);

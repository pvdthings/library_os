import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:librarian_app/modules/borrowers/models/borrower_model.dart';
import 'package:librarian_app/modules/borrowers/data/borrowers_repository.dart';

final borrowersRepositoryProvider =
    NotifierProvider<BorrowersRepository, Future<List<BorrowerModel>>>(
        BorrowersRepository.new);

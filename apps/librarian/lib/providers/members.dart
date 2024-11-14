import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:librarian_app/core/data/borrowers_repository.dart';

final membersProvider = Provider((ref) async {
  return await BorrowersRepository().getBorrowers();
});

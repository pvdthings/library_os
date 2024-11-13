import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:librarian_app/core/api/api.dart' as API;

import '../api/models/loan_details_model.dart';
import '../api/models/loan_model.dart';

class LoansRepository extends Notifier<Future<List<LoanModel>>> {
  @override
  Future<List<LoanModel>> build() async => await getLoans();

  Future<LoanDetailsModel?> getLoan({
    required String id,
    required String thingId,
  }) async {
    try {
      final response = await API.fetchLoan(id: id, thingId: thingId);
      return LoanDetailsModel.fromJson(response.data as Map<String, dynamic>);
    } catch (error) {
      return null;
    }
  }

  Future<List<LoanModel>> getLoans() async {
    final response = await API.fetchLoans();
    return (response.data as List).map((e) => LoanModel.fromJson(e)).toList();
  }

  Future<String?> openLoan({
    required String borrowerId,
    required List<String> thingIds,
    required DateTime dueBackDate,
  }) async {
    final dateFormat = DateFormat('yyyy-MM-dd');
    try {
      final response = await API.createLoan(API.NewLoan(
        borrowerId: borrowerId,
        thingIds: thingIds,
        checkedOutDate: dateFormat.format(DateTime.now()),
        dueBackDate: dateFormat.format(dueBackDate),
      ));

      ref.invalidateSelf();
      return (response.data as Map<String, dynamic>)['id'] as String;
    } catch (error) {
      return null;
    }
  }

  Future<void> closeLoan({
    required String loanId,
    required String thingId,
  }) async {
    final dateFormat = DateFormat('yyyy-MM-dd');

    await API.updateLoan(API.UpdatedLoan(
      loanId: loanId,
      thingId: thingId,
      checkedInDate: dateFormat.format(DateTime.now()),
    ));
  }

  Future<void> updateLoan({
    required String loanId,
    required String thingId,
    required DateTime dueBackDate,
    String? notes,
  }) async {
    final dateFormat = DateFormat('yyyy-MM-dd');

    await API.updateLoan(API.UpdatedLoan(
      loanId: loanId,
      thingId: thingId,
      dueBackDate: dateFormat.format(dueBackDate),
      notes: notes,
    ));
  }
}

import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';
import 'package:librarian_app/core/api/api.dart' as API;
import 'package:librarian_app/core/supabase.dart';

import '../api/models/loan_details_model.dart';
import '../api/models/loan_model.dart';

class LoansRepository {
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
    final data = await supabase.from('loans_items').select('''
      id,
      item:items (
        *,
        thing:things (id, name),
        images:item_images (*)
      ),
      loan:loans (
        *,
        member:members (*)
      )
    ''').eq('returned', false);

    if (kDebugMode) {
      print(jsonEncode(data));
    }

    return data.map((e) => LoanModel.fromQuery(e)).toList();
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

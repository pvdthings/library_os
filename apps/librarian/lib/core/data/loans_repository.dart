import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';
import 'package:librarian_app/core/api/models/item_model.dart';
import 'package:librarian_app/core/supabase.dart';

import '../api/models/loan_details_model.dart';
import '../api/models/loan_model.dart';

class LoansRepository {
  final dateFormat = DateFormat('yyyy-MM-dd');

  Future<LoanDetailsModel?> getLoan({
    required String id,
    required String itemId,
  }) async {
    try {
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
      ''').eq('id', int.parse(id)).limit(1).single();

      if (kDebugMode) {
        print(jsonEncode(data));
      }

      return LoanDetailsModel.fromQuery(data);
    } catch (error) {
      if (kDebugMode) {
        print(error.toString());
      }

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
    required List<ItemModel> items,
    required DateTime dueBackDate,
  }) async {
    try {
      final data = await supabase
          .from('loans')
          .insert({
            'member_id': int.parse(borrowerId),
            'due_date': dateFormat.format(dueBackDate),
          })
          .select()
          .single();

      final loanId = data['id'] as int;

      final futures = items.map((item) => supabase
          .from('loans_items')
          .insert({
            'loan_id': loanId,
            'item_id': int.parse(item.id),
            'thing_id': int.parse(item.thingId),
          })
          .select()
          .single());

      await Future.wait(
        futures,
        eagerError: true,
        cleanUp: (value) async {
          final id = value['id'];
          if (id == null) {
            return;
          }

          if (kDebugMode) {
            print('Cleaning up... ID: $id');
          }

          await supabase.from('loans_items').delete().eq('id', id);
        },
      );

      return data['id'].toString();
    } catch (error) {
      if (kDebugMode) {
        print(error.toString());
      }
      return null;
    }
  }

  Future<void> closeLoan(String loanId) async {
    await supabase
        .from('loans_items')
        .update({'returned': true}).eq('id', int.parse(loanId));
  }

  Future<void> updateLoan({
    required int parentLoanId,
    required DateTime dueBackDate,
    String? notes,
  }) async {
    await supabase.from('loans').update({
      'due_date': dateFormat.format(dueBackDate),
      'notes': notes,
    }).eq('id', parentLoanId);
  }
}

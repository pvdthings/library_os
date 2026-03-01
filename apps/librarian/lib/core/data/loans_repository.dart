import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';
import 'package:librarian_app/core/config/mode.dart';
import 'package:librarian_app/core/models/item_model.dart';
import 'package:librarian_app/core/models/item_summary_model.dart';
import 'package:librarian_app/core/models/loan_details_model.dart';
import 'package:librarian_app/core/models/loan_model.dart';
import 'package:librarian_app/core/models/member_model.dart';
import 'package:librarian_app/core/supabase.dart';

final loansRepository =
    appMode.isDemo ? FakeLoansRepository() : SupabaseLoansRepository();

abstract class LoansRepository {
  Future<LoanDetailsModel?> getLoan({
    required String id,
    required String itemId,
  });

  Future<List<LoanModel>> getLoans();

  Future<String?> openLoan({
    required String borrowerId,
    required List<ItemModel> items,
    required DateTime dueBackDate,
  });

  Future<void> closeLoan(String loanId);

  Future<void> updateLoan({
    required int parentLoanId,
    required DateTime dueBackDate,
    String? notes,
  });
}

class SupabaseLoansRepository implements LoansRepository {
  final dateFormat = DateFormat('yyyy-MM-dd');

  @override
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

      final previousLoan = await getPreviousLoan(itemId: int.parse(itemId));

      return LoanDetailsModel.fromQuery(data, previousLoan: previousLoan);
    } catch (error) {
      if (kDebugMode) {
        print(error.toString());
      }

      return null;
    }
  }

  Future<LoanDetailsModel?> getPreviousLoan({required int itemId}) async {
    final data = await supabase.from('loans_items').select('''
        id,
        item_id,
        item:items (
          *,
          thing:things (id, name),
          images:item_images (*)
        ),
        loan:loans (
          *,
          member:members (*)
        )
      ''').eq('item_id', itemId).order('loan_id', ascending: false).limit(2);

    if (kDebugMode) {
      print(jsonEncode(data));
    }

    if (data.length < 2) {
      return null;
    }

    return LoanDetailsModel.fromQuery(data[1]);
  }

  @override
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

  @override
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

  @override
  Future<void> closeLoan(String loanId) async {
    await supabase
        .from('loans_items')
        .update({'returned': true}).eq('id', int.parse(loanId));
  }

  @override
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

class FakeLoansRepository implements LoansRepository {
  @override
  Future<LoanDetailsModel?> getLoan({
    required String id,
    required String itemId,
  }) async {
    await Future.delayed(const Duration(seconds: 1));
    return LoanDetailsModel(
      id: id,
      parentLoanId: 100,
      number: 1,
      item: ItemSummaryModel(
        id: itemId,
        name: 'The Great Gatsby',
        number: 101,
        images: [],
      ),
      borrower: MemberModel(id: id, name: 'John Doe', issues: []),
      checkedOutDate: DateTime.now(),
      dueDate: DateTime.now().add(const Duration(days: 7)),
      remindersSent: 0,
    );
  }

  @override
  Future<List<LoanModel>> getLoans() async {
    await Future.delayed(const Duration(seconds: 1));
    return [
      LoanModel(
        id: '123',
        thing: ItemSummaryModel(
          id: '1',
          name: 'The Great Gatsby',
          number: 101,
          images: [],
        ),
        borrower: MemberModel(
          id: '1',
          name: 'John Doe',
          issues: [],
        ),
        dueDate: DateTime.now().add(const Duration(days: 7)),
        number: 1,
        checkedOutDate: DateTime.now(),
      ),
    ];
  }

  @override
  Future<String?> openLoan({
    required String borrowerId,
    required List<ItemModel> items,
    required DateTime dueBackDate,
  }) async {
    await Future.delayed(const Duration(seconds: 1));
    return '123';
  }

  @override
  Future<void> closeLoan(String loanId) async {
    await Future.delayed(const Duration(seconds: 1));
  }

  @override
  Future<void> updateLoan({
    required int parentLoanId,
    required DateTime dueBackDate,
    String? notes,
  }) async {
    await Future.delayed(const Duration(seconds: 1));
  }
}

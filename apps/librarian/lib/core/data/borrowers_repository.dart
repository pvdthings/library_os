import 'package:collection/collection.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:librarian_app/core/api/api.dart' as api;
import 'package:librarian_app/core/api/models/payment_model.dart';

import '../api/models/borrower_model.dart';

class BorrowersRepository extends Notifier<Future<List<BorrowerModel>>> {
  @override
  Future<List<BorrowerModel>> build() async => await getBorrowers();

  Future<List<BorrowerModel>> getBorrowers() async {
    final response = await api.fetchBorrowers();
    return (response.data as List)
        .map((json) => BorrowerModel.fromJson(json))
        .toList();
  }

  Future<BorrowerModel?> getBorrower(String id) async {
    final borrowers = await state;
    return borrowers.firstWhereOrNull((b) => b.id == id);
  }

  Future<BorrowerModel?> getBorrowerDetails(String id) async {
    final response = await api.fetchBorrower(id);
    return BorrowerModel.fromJson(response.data as Map<String, dynamic>);
  }

  Future<bool> updateBorrower(String id, {String? email, String? phone}) async {
    try {
      await api.updateBorrower(id, email: email, phone: phone);

      ref.invalidateSelf();
      return true;
    } catch (error) {
      return false;
    }
  }

  Future<List<PaymentModel>> getPayments(String borrowerId) async {
    final response = await api.fetchPayments(borrowerId: borrowerId);
    return (response.data as List)
        .map((e) => PaymentModel.fromJson(e))
        .toList();
  }

  Future<bool> recordPayment({
    required String borrowerId,
    required double cash,
  }) async {
    try {
      await api.recordCashPayment(
        cash: cash,
        borrowerId: borrowerId,
      );
    } catch (error) {
      return false;
    }

    ref.invalidateSelf();
    return true;
  }
}

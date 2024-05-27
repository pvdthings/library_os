import 'package:collection/collection.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:librarian_app/core/api/api.dart';
import 'package:librarian_app/modules/borrowers/models/payment_model.dart';

import '../models/borrower_model.dart';

class BorrowersRepository extends Notifier<Future<List<BorrowerModel>>> {
  @override
  Future<List<BorrowerModel>> build() async => await getBorrowers();

  Future<List<BorrowerModel>> getBorrowers() async {
    final response = await fetchBorrowers();
    return (response.data as List)
        .map((json) => BorrowerModel.fromJson(json))
        .toList();
  }

  Future<BorrowerModel?> getBorrower(String id) async {
    final borrowers = await state;
    return borrowers.firstWhereOrNull((b) => b.id == id);
  }

  Future<BorrowerModel?> getBorrowerDetails(String id) async {
    final response = await fetchBorrower(id);
    return BorrowerModel.fromJson(response.data as Map<String, dynamic>);
  }

  Future<bool> updateBorrower(String id, {String? email, String? phone}) async {
    try {
      await updateBorrower(id, email: email, phone: phone);

      ref.invalidateSelf();
      return true;
    } catch (error) {
      return false;
    }
  }

  Future<List<PaymentModel>> getPayments(String borrowerId) async {
    final response = await fetchPayments(borrowerId: borrowerId);
    return (response.data as List)
        .map((e) => PaymentModel.fromJson(e))
        .toList();
  }

  Future<bool> recordCashPayment({
    required String borrowerId,
    required double cash,
  }) async {
    try {
      await recordCashPayment(
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

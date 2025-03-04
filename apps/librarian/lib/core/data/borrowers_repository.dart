import 'package:librarian_app/core/api/api.dart' as api;
import 'package:librarian_app/core/api/models/payment_model.dart';

import '../api/models/member_model.dart';

class BorrowersRepository {
  Future<List<MemberModel>> getBorrowers() async {
    final response = await api.fetchBorrowers();
    return (response.data as List)
        .map((json) => MemberModel.fromJson(json))
        .toList();
  }

  Future<MemberModel?> getBorrowerDetails(String id) async {
    final response = await api.fetchBorrower(id);
    return MemberModel.fromJson(response.data as Map<String, dynamic>);
  }

  Future<bool> updateBorrower(String id, {String? email, String? phone}) async {
    try {
      await api.updateBorrower(id, email: email, phone: phone);
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
  }) async {
    try {
      await api.recordCashPayment(
        borrowerId: borrowerId,
      );
    } catch (error) {
      return false;
    }
    return true;
  }
}

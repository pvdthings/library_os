import 'package:librarian_app/core/api/api.dart' as api;
import 'package:librarian_app/core/api/models/payment_model.dart';
import 'package:librarian_app/core/supabase.dart';

import '../api/models/member_model.dart';

class BorrowersRepository {
  Future<List<MemberModel>> getBorrowers() async {
    final data = await supabase.from('members').select();
    return data.map((json) => MemberModel.fromQuery(json)).toList();
  }

  Future<MemberModel?> getBorrowerDetails(String id) async {
    final data = await supabase
        .from('members')
        .select()
        .eq('id', int.parse(id))
        .limit(1)
        .single();
    return MemberModel.fromQuery(data);
  }

  Future<bool> updateBorrower(String id, {String? email, String? phone}) async {
    try {
      await api.updateBorrower(id, email: email, phone: phone);
      return true;
    } catch (error) {
      return false;
    }
  }

  // TODO: Will need to create a wrapper around Airtable or Givebutter
  Future<List<PaymentModel>> getPayments(String borrowerId) async {
    return [];
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
    return true;
  }
}

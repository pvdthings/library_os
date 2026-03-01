import 'package:librarian_app/core/config/mode.dart';
import 'package:librarian_app/core/models/payment_model.dart';
import 'package:librarian_app/core/supabase.dart';

import '../models/member_model.dart';

final borrowersRepository =
    appMode.isDemo ? FakeBorrowersRepository() : SupabaseBorrowersRepository();

abstract class BorrowersRepository {
  Future<List<MemberModel>> getBorrowers();

  Future<MemberModel?> getBorrowerDetails(String id);

  Future<void> updateBorrower(String id, {String? email, String? phone});

  Future<List<PaymentModel>> getPayments(String borrowerId);

  Future<bool> recordPayment({
    required String borrowerId,
  });
}

class SupabaseBorrowersRepository implements BorrowersRepository {
  @override
  Future<List<MemberModel>> getBorrowers() async {
    final data = await supabase.from('members').select();
    return data.map((json) => MemberModel.fromQuery(json)).toList();
  }

  @override
  Future<MemberModel?> getBorrowerDetails(String id) async {
    final data = await supabase
        .from('members')
        .select()
        .eq('id', int.parse(id))
        .limit(1)
        .single();
    return MemberModel.fromQuery(data);
  }

  @override
  Future<void> updateBorrower(String id, {String? email, String? phone}) async {
    final values = {};

    if (email != null) {
      values['email'] = email;
    }

    if (phone != null) {
      values['phone'] = phone;
    }

    await supabase.from('members').update(values).eq('id', int.parse(id));
  }

  // TODO: (!!!) Will need to create a wrapper around Givebutter or Stripe to handle online payments.
  @override
  Future<List<PaymentModel>> getPayments(String borrowerId) async {
    final data = await supabase
        .from('members_payments')
        .select()
        .eq('member_id', borrowerId);
    return data.map((json) => PaymentModel.fromQuery(json)).toList();
  }

  @override
  Future<bool> recordPayment({
    required String borrowerId,
  }) async {
    try {
      await supabase.from('members_payments').insert({
        'member_id': int.parse(borrowerId),
      });
    } catch (error) {
      return false;
    }

    return true;
  }
}

class FakeBorrowersRepository implements BorrowersRepository {
  @override
  Future<List<MemberModel>> getBorrowers() async {
    return [MemberModel(id: '123', name: 'John Doe', issues: [])];
  }

  @override
  Future<MemberModel?> getBorrowerDetails(String id) async {
    return MemberModel(id: id, name: 'John Doe', issues: []);
  }

  @override
  Future<void> updateBorrower(String id,
      {String? email, String? phone}) async {}

  @override
  Future<List<PaymentModel>> getPayments(String borrowerId) async {
    return [];
  }

  @override
  Future<bool> recordPayment({
    required String borrowerId,
  }) async {
    return true;
  }
}

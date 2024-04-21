import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:librarian_app/src/api/loans_api.dart';
import 'package:librarian_app/src/features/loans/providers/loans_repository_provider.dart';
import 'package:librarian_app/src/utils/format.dart';

class ActionsService {
  ActionsService(this.ref);

  final Ref ref;

  Future<bool> isAuthorizedToExtendAllDueDates() async {
    try {
      final res = await LoansApi.extendAuthorization();
      return res.statusCode == 204;
    } catch (error) {
      return false;
    }
  }

  Future<bool> extendAllDueDates(DateTime dueDate) async {
    try {
      final res = await LoansApi.extend(dueDate: formatDate(dueDate));
      final data = res.data as Map<String, dynamic>;
      final result = data['success'] as bool;

      if (result) {
        Future.delayed(const Duration(seconds: 2), () {
          ref.invalidate(loansRepositoryProvider);
        });
      }

      return result;
    } catch (error) {
      if (kDebugMode) {
        print(error);
      }

      return false;
    }
  }
}

final actionsServiceProvider = Provider((ref) => ActionsService(ref));

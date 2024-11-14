import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:librarian_app/core/api/api.dart';
import 'package:librarian_app/providers/loans.dart';
import 'package:librarian_app/utils/format.dart';

class ActionsService {
  ActionsService(this.ref);

  final Ref ref;

  Future<bool> isAuthorizedToExtendAllDueDates() async {
    try {
      final res = await extendAuthorization();
      return res.statusCode == 204;
    } catch (error) {
      return false;
    }
  }

  Future<bool> extendAllDueDates(DateTime dueDate) async {
    try {
      final res = await extend(dueDate: formatDate(dueDate));
      final data = res.data as Map<String, dynamic>;
      final result = data['success'] as bool;

      if (result) {
        Future.delayed(const Duration(seconds: 2), () {
          ref.invalidate(loansProvider);
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

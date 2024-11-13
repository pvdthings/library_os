import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:librarian_app/modules/things/providers/things_repository_provider.dart';
import 'package:librarian_app/providers/loans.dart';
import 'package:librarian_app/providers/members.dart';

void invalidateModule(WidgetRef ref, int index) {
  switch (index) {
    case loansIndex:
      ref.invalidate(loansProvider);
      return;
    case membersIndex:
      ref.invalidate(membersProvider);
    case thingsIndex:
    case repairIndex:
      ref.invalidate(thingsRepositoryProvider);
      return;
    case actionsIndex:
      return;
  }
}

const loansIndex = 0;
const membersIndex = 1;
const thingsIndex = 2;
const repairIndex = 3;
const actionsIndex = 4;

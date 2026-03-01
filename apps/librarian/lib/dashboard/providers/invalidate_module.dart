import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:librarian_app/providers/loans.dart';
import 'package:librarian_app/providers/members.dart';
import 'package:librarian_app/providers/things.dart';

void invalidateModule(WidgetRef ref, int index) {
  switch (index) {
    case loansIndex:
      ref.invalidate(loansProvider);
      return;
    case membersIndex:
      ref.invalidate(membersProvider);
    case thingsIndex:
    case repairIndex:
      ref.invalidate(rootThingsProvider);
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

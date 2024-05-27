import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:librarian_app/modules/things/providers/things_repository_provider.dart';

import '../../../api/models/thing_model.dart';

Provider<Future<List<ThingModel>>> findThingsByName(String name) {
  return Provider((ref) async => await ref
      .read(thingsRepositoryProvider.notifier)
      .getThings(filter: name));
}

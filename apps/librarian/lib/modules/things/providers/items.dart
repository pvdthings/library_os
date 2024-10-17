import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'things_repository_provider.dart';

final allItems = Provider((ref) async {
  ref.watch(thingsRepositoryProvider);
  return await ref.read(thingsRepositoryProvider.notifier).getItems();
});

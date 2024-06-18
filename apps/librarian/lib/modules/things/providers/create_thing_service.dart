import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'things_repository_provider.dart';

class CreateThingService {
  CreateThingService(this.ref);

  final Ref ref;

  void create({
    required String name,
    String? spanishName,
    void Function()? onFinish,
  }) {
    ref
        .read(thingsRepositoryProvider.notifier)
        .createThing(name: name, spanishName: spanishName)
        .then((value) => onFinish?.call());
  }
}

final createThing = Provider((ref) => CreateThingService(ref));

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:librarian_app/core/data/inventory_repository.dart';
import 'package:librarian_app/providers/things.dart';

class CreateThingService {
  CreateThingService(this.ref);

  final Ref ref;

  void create({
    required String name,
    String? spanishName,
    void Function()? onFinish,
  }) {
    inventoryRepository
        .createThing(name: name, spanishName: spanishName)
        .then((value) => ref.invalidate(rootThingsProvider))
        .then((value) => onFinish?.call());
  }
}

final createThing = Provider((ref) => CreateThingService(ref));

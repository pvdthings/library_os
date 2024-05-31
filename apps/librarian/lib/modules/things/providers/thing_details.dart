import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:librarian_app/core/api/models/models.dart';
import 'package:librarian_app/providers/os.dart';

Provider<Future<DetailedThingModel>> thingDetails(String id) {
  return Provider((ref) async {
    return await ref.read(os).things.one(id).details();
  });
}

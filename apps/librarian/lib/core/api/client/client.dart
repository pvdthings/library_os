// ignore_for_file: unused_local_variable

library;

import 'package:librarian_app/core/api/api.dart';
import 'package:librarian_app/core/api/models/models.dart';

part 'connection.dart';
part 'items.dart';
part 'library_os.dart';
part 'things.dart';

void demo() async {
  final library = LibraryOS.connect(key: '', url: '');
  final things = await library.things.all();

  final hammer =
      await library.things.create(name: 'Hammer', spanishName: 'Martillo');

  final thing = library.things.one(hammer.id);
  await thing.update(hidden: true);

  final thingDetails = await thing.details();
  final itemNumber = thingDetails.items.first.number;

  final itemDetails = library.items.one(number: itemNumber).details();

  await thing.items.createMany(2);
}

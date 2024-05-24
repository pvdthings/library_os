import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:librarian_app/modules/inventory/models/thing_model.dart';

final selectedThingProvider = StateProvider<ThingModel?>((ref) => null);

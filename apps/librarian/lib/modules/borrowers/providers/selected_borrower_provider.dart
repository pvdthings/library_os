import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/borrower_model.dart';

final selectedBorrowerProvider = StateProvider<BorrowerModel?>((ref) => null);

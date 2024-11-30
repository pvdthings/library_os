import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/api/models/borrower_model.dart';

final selectedBorrowerProvider = StateProvider<MemberModel?>((ref) => null);

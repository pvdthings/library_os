import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/api/models/member_model.dart';

final selectedBorrowerProvider = StateProvider<MemberModel?>((ref) => null);

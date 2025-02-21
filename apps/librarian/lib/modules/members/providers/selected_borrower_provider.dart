import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/models/member_model.dart';

final selectedBorrowerProvider = StateProvider<MemberModel?>((ref) => null);

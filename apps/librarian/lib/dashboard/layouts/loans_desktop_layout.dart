import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:librarian_app/modules/loans/redesign/scratch.dart';

class LoansDesktopLayout extends ConsumerWidget {
  const LoansDesktopLayout({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return const RedesignedLoans();
  }
}

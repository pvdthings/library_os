import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:librarian_app/dashboard/providers/workspace.dart';
import 'package:librarian_app/dashboard/widgets/workspace_window.dart';
import 'package:librarian_app/modules/loans/checkout/checkout_page.dart';
import 'package:librarian_app/modules/loans/checkout/checkout_stepper.dart';
import 'package:librarian_app/utils/media_query.dart';

class CreateLoanController {
  CreateLoanController(this.ref);

  final Ref ref;

  void createLoan(BuildContext context) {
    if (isMobile(context)) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const CheckoutPage(),
        ),
      );
      return;
    }

    final ws = ref.read(workspace);
    final window = WorkspaceWindow(
      title: 'Create Loan',
      content: CheckoutStepper(
        onFinish: () => ws.closeWindow(),
      ),
    );

    ws.open(window);
  }
}

final createLoan = Provider((ref) => CreateLoanController(ref));

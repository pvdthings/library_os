import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:librarian_app/core/api/models/payment_model.dart';
import 'package:librarian_app/widgets/details_card/card_body.dart';
import 'package:librarian_app/widgets/details_card/card_header.dart';
import 'package:librarian_app/widgets/details_card/details_card.dart';
import 'package:librarian_app/widgets/hint_text.dart';

class PaymentsCard extends StatelessWidget {
  const PaymentsCard({super.key, required this.payments});

  final List<PaymentModel> payments;

  static final DateFormat _dateFormat = DateFormat.yMMMMd('en_US');

  @override
  Widget build(BuildContext context) {
    return DetailsCard(
      header: const CardHeader(title: 'Payments'),
      body: payments.isNotEmpty
          ? ListView.separated(
              itemBuilder: (context, i) {
                return ListTile(
                  leading: Icon(Icons.payment),
                  title: Text(_dateFormat.format(payments[i].date)),
                );
              },
              itemCount: payments.length,
              separatorBuilder: (context, index) => const Divider(height: 1),
              shrinkWrap: true,
            )
          : const CardBody(child: HintText('No recorded payments.')),
    );
  }
}

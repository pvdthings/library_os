import 'package:flutter/material.dart';

class PaymentForm extends StatefulWidget {
  const PaymentForm({super.key});

  @override
  State<PaymentForm> createState() => _PaymentFormState();
}

class _PaymentFormState extends State<PaymentForm> {
  bool _coverFees = true;

  double? get dues => double.tryParse(_annualContributionController.text);
  double get netTotal => 20 + (dues ?? 0);
  double get processingFee => _coverFees ? (netTotal * 0.029) + 0.3 : 0;
  double get total => netTotal + processingFee;

  late final _annualContributionController = TextEditingController(text: '50')
    ..addListener(() {
      _totalController.text = total.toString();
    });

  late final _totalController = TextEditingController(text: total.toString());

  @override
  Widget build(BuildContext context) {
    return Form(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
              'Your PVD Things co-op membership is good for life and is refundable if you choose to give up your membership. PLEASE NOTE: In addition to your co-op membership, you will also need to pay annual dues before you can start borrowing items. Annual dues are set at a sliding scale based on your income: Annually, we suggest at least \$1/thousand of income; someone making \$50,000 a year would pay \$50/year in dues. You can pay dues the first time you visit PVD Things.'),
          const SizedBox(height: 32),
          TextFormField(
            initialValue: '20',
            readOnly: true,
            decoration: const InputDecoration(
                labelText: 'Lifetime Membership',
                prefixText: '\$ ',
                icon: Icon(Icons.card_membership)),
          ),
          const SizedBox(height: 8),
          TextFormField(
            controller: _annualContributionController,
            decoration: const InputDecoration(
              labelText: 'Annual Contribution',
              hintText: '1 / Thousand of Annual Income (Suggested)',
              prefixText: '\$ ',
              icon: Icon(Icons.add),
            ),
          ),
          const SizedBox(height: 8),
          TextFormField(
            controller: _totalController,
            readOnly: true,
            decoration: const InputDecoration(
              labelText: 'Total Due Today',
              prefixText: '\$ ',
              icon: Icon(Icons.arrow_forward),
            ),
          ),
          const SizedBox(height: 32),
          DropdownButtonFormField(
            value: _coverFees ? 0 : 1,
            items: const [
              DropdownMenuItem(
                value: 0,
                child: Text('Cover Processing Fee (2.9% +\$0.30)'),
              ),
              DropdownMenuItem(
                value: 1,
                child: Text('Do Not Cover Processing Fee'),
              ),
            ],
            onChanged: (value) {
              setState(() {
                _coverFees = value == 0;
              });
            },
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Text('Processing Fee: \$ $processingFee'),
          ),
        ],
      ),
    );
  }
}

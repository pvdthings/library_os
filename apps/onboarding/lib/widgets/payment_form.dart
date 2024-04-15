import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:onboarding/core/money.dart';

class PaymentForm extends StatefulWidget {
  const PaymentForm({super.key});

  @override
  State<PaymentForm> createState() => _PaymentFormState();
}

class _PaymentFormState extends State<PaymentForm> {
  final _formKey = GlobalKey<FormState>();

  bool _coverFees = true;
  bool _coverMembership = false;
  bool _payCash = false;

  bool get _skipPayment => _coverMembership || _payCash;

  double? get dues => double.tryParse(_annualContributionController.text);
  double get netTotal => (_coverMembership ? 0 : 20) + (dues ?? 0);
  double get processingFee => (netTotal * 0.029) + 0.3;
  double get total => netTotal + (_coverFees ? processingFee : 0);

  late final _annualContributionController = TextEditingController()
    ..addListener(() {
      _totalController.text = total.toString();
    });

  late final _totalController = TextEditingController(text: total.toString());

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (!_skipPayment)
            Card.outlined(
              clipBehavior: Clip.antiAlias,
              child: Column(
                children: [
                  const ListTile(
                    title: Text('Sliding Scale Membership'),
                    subtitle: Text(
                        'Your PVD Things co-op membership is good for life and is refundable if you choose to give up your membership. In addition, we ask our members to pay a suggested annual contribution of \$1/thousand of income. For example: Someone earning \$50,000/year would pay \$50/year.'),
                  ),
                  const Divider(height: 1),
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        TextFormField(
                          controller: _annualContributionController,
                          decoration: const InputDecoration(
                            labelText: 'Annual Contribution',
                            hintText:
                                '1 / Thousand of Annual Income (Suggested)',
                            prefixText: '\$ ',
                            border: InputBorder.none,
                          ),
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                          ],
                          keyboardType: TextInputType.number,
                          validator: (value) {
                            if (value == null ||
                                double.tryParse(value) == null) {
                              return 'Valid dollar amount required';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),
                        DropdownButtonFormField(
                          isExpanded: true,
                          decoration: const InputDecoration(
                            labelText: 'Processing Fee',
                            border: InputBorder.none,
                          ),
                          value: _coverFees ? 0 : 1,
                          items: const [
                            DropdownMenuItem(
                              value: 0,
                              child: Text('Cover Processing Fee'),
                            ),
                            DropdownMenuItem(
                              value: 1,
                              child: Text('Do not cover the processing fee'),
                            ),
                          ],
                          onChanged: (value) => setState(() {
                            _coverFees = value == 0;
                            _totalController.text = total.toString();
                          }),
                        ),
                        const Padding(
                          padding: EdgeInsets.all(8),
                          child: Text('Processing Fee: 2.9% +\$0.30'),
                        ),
                      ],
                    ),
                  ),
                  const Divider(height: 1),
                  const ListTile(
                    title: Text('Lifetime Membership'),
                    subtitle: Text('\$20'),
                  ),
                  const Divider(height: 1),
                  ListTile(
                    title: const Text('Total Due Today'),
                    subtitle: ListenableBuilder(
                      listenable: _annualContributionController,
                      builder: (context, _) {
                        return Text(Money.format(total));
                      },
                    ),
                  ),
                ],
              ),
            ),
          if (!_skipPayment) const SizedBox(height: 32),
          if (!_payCash)
            Card.outlined(
              clipBehavior: Clip.antiAlias,
              child: Column(
                children: [
                  const ListTile(
                    title: Text('Financial Assistance'),
                    subtitle: Text(
                        'Our charitable purpose is to expand tool access to everyone, regardless of ability to pay. If you cannot afford the Lifetime Membership fee, it will be waived. Check this box to assert that you are in need of financial assistance.'),
                  ),
                  const Divider(height: 1),
                  ListTile(
                    leading: Checkbox(
                      value: _coverMembership,
                      onChanged: (value) => setState(() {
                        _coverMembership = value ?? false;
                        _totalController.text = total.toString();
                      }),
                    ),
                    title: const Text('I cannot afford to pay'),
                  ),
                ],
              ),
            ),
          if (!_skipPayment) const SizedBox(height: 32),
          if (!_coverMembership)
            Card.outlined(
              clipBehavior: Clip.antiAlias,
              child: Column(
                children: [
                  const ListTile(
                    title: Text('Pay Cash'),
                    subtitle: Text(
                        'Check the box below to skip payment and pay in cash later.'),
                  ),
                  const Divider(height: 1),
                  ListTile(
                    leading: Checkbox(
                      value: _payCash,
                      onChanged: (value) => setState(() {
                        _payCash = value ?? false;
                      }),
                    ),
                    title: const Text('Pay in cash'),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}

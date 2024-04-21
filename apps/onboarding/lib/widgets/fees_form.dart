import 'package:flutter/material.dart';

class FeesForm extends StatefulWidget {
  const FeesForm({super.key});

  @override
  State<FeesForm> createState() => _FeesFormState();
}

class _FeesFormState extends State<FeesForm> {
  final _formKey = GlobalKey<FormState>();

  bool _coverMembership = false;
  bool _payCash = false;

  bool get _skipPayment => _coverMembership || _payCash;

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
            const Card.outlined(
              clipBehavior: Clip.antiAlias,
              child: Column(
                children: [
                  ListTile(
                    title: Text('Sliding Scale Membership'),
                    subtitle: Text(
                        'Your PVD Things co-op membership is good for life and is refundable if you ever choose to resign. We also ask our members to pay a suggested annual contribution of \$1/thousand of income.\n\nFor example: Someone earning \$50,000/year would pay \$50/year.'),
                  ),
                  Divider(height: 1),
                  ListTile(
                    title: Text('Year 1'),
                    subtitle: Text('\$20 + Annual Contribution'),
                  ),
                  Divider(height: 1),
                  ListTile(
                    title: Text('Years 2+'),
                    subtitle: Text('Annual Contribution'),
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

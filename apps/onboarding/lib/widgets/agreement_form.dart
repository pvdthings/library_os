import 'package:flutter/material.dart';
import 'package:onboarding/models/contact_model.dart';
import 'package:provider/provider.dart';

class AgreementForm extends StatefulWidget {
  const AgreementForm({super.key});

  @override
  State<AgreementForm> createState() => _AgreementFormState();
}

class _AgreementFormState extends State<AgreementForm> {
  bool ok = false;

  @override
  Widget build(BuildContext context) {
    final ContactModel? contact = context.watch<ContactNotifier>().value;

    return Form(
      child: Column(
        children: [
          const SizedBox(
            height: 800,
            child: Card.outlined(
              child: Center(
                child: Text('Combined Member + Liability Agreement'),
              ),
            ),
          ),
          const SizedBox(height: 16),
          Card.outlined(
            clipBehavior: Clip.antiAlias,
            child: Column(
              children: [
                ListTile(
                  leading: const Icon(Icons.draw),
                  title: const Text('Electronic Signature'),
                  subtitle: RichText(
                    text: const TextSpan(
                      children: [
                        TextSpan(text: 'By entering your name and clicking '),
                        TextSpan(
                          text: 'Continue',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        TextSpan(text: ', you agree to the terms above.'),
                      ],
                    ),
                  ),
                  trailing: ok
                      ? const Icon(
                          Icons.check_circle,
                          color: Colors.green,
                        )
                      : null,
                ),
                TextFormField(
                  enabled: !ok,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    labelText: 'Full Name',
                    hintText: contact?.fullName,
                  ),
                  onChanged: (value) {
                    if (value == contact?.fullName) {
                      setState(() => ok = true);
                    }
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

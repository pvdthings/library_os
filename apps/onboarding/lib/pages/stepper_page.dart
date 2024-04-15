import 'package:flutter/material.dart';
import 'package:onboarding/models/contact_model.dart';
import 'package:onboarding/widgets/agreement_form.dart';
import 'package:onboarding/widgets/contact_info_controller.dart';
import 'package:onboarding/widgets/contact_info_form.dart';
import 'package:onboarding/widgets/fees_form.dart';
import 'package:onboarding/widgets/responsive_body.dart';
import 'package:provider/provider.dart';

class StepperPage extends StatefulWidget {
  const StepperPage({super.key});

  @override
  State<StepperPage> createState() => _StepperPageState();
}

class _StepperPageState extends State<StepperPage> {
  late final _formController = ContactInfoController(context);

  int _currentStep = 0;

  late final List<Function()> _onStepContinue = [
    () {
      context.read<ContactNotifier>().value =
          _formController.createContactModel();
      setState(() => _currentStep = 1);
    },
    () {
      setState(() => _currentStep = 2);
    },
    () {},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ResponsiveBody(
        child: Stepper(
          currentStep: _currentStep,
          onStepContinue: _onStepContinue[_currentStep],
          onStepCancel: () => setState(() {
            if (_currentStep == 0) {
              return;
            }
            _currentStep -= 1;
          }),
          onStepTapped: (value) => setState(() {
            _currentStep = value;
          }),
          steps: [
            Step(
              title: const Text('Contact Information'),
              content: ContactInfoForm(controller: _formController),
            ),
            const Step(
              title: Text('Cooperative Agreement'),
              content: AgreementForm(),
            ),
            const Step(
              title: Text('Membership Fees'),
              content: FeesForm(),
            ),
          ],
        ),
      ),
    );
  }
}

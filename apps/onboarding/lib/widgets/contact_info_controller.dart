import 'package:flutter/material.dart';
import 'package:onboarding/core/address.dart';
import 'package:onboarding/models/contact_model.dart';

class ContactInfoController extends ChangeNotifier {
  ContactInfoController(this.context);

  final BuildContext context;

  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();

  final addressController = TextEditingController();
  final address2Controller = TextEditingController();
  final cityController = TextEditingController(text: 'Providence');
  final stateController = TextEditingController(text: 'RI');
  final postalCodeController = TextEditingController();

  ContactModel createContactModel() {
    return ContactModel(
      firstName: firstNameController.text,
      lastName: lastNameController.text,
      phone: phoneController.text,
      email: emailController.text,
      address: Address(
        street: addressController.text,
        unit: address2Controller.text,
        city: cityController.text,
        state: stateController.text,
        zipCode: postalCodeController.text,
      ),
    );
  }
}

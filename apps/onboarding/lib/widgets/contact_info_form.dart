import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:onboarding/core/text_input_format.dart';
import 'contact_info_controller.dart';

class ContactInfoForm extends StatefulWidget {
  const ContactInfoForm({super.key, required this.controller});

  final ContactInfoController controller;

  @override
  State<ContactInfoForm> createState() => _ContactInfoFormState();
}

class _ContactInfoFormState extends State<ContactInfoForm> {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          TextFormField(
            controller: widget.controller.firstNameController,
            decoration: const InputDecoration(
              labelText: 'First Name',
              hintText: 'Ezra',
            ),
            validator: Validators.isNonEmptyString,
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: widget.controller.lastNameController,
            decoration: const InputDecoration(
              labelText: 'Last Name',
              hintText: 'Elderberry',
            ),
            validator: Validators.isNonEmptyString,
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: widget.controller.emailController,
            decoration: const InputDecoration(
              labelText: 'Email',
              hintText: 'e.elderberry@mail.com',
            ),
            keyboardType: TextInputType.emailAddress,
            validator: Validators.isValidEmail,
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: widget.controller.phoneController,
            decoration: const InputDecoration(
              labelText: 'Phone',
              hintText: '(555) 555-5555',
            ),
            keyboardType: TextInputType.phone,
            inputFormatters: [
              FilteringTextInputFormatter.digitsOnly,
              TextInputFormat.phone,
            ],
            validator: Validators.isValidPhone,
          ),
          const SizedBox(height: 64),
          TextFormField(
            controller: widget.controller.addressController,
            decoration: const InputDecoration(
              labelText: 'Address',
              hintText: '123 Main Street',
            ),
            keyboardType: TextInputType.streetAddress,
            validator: Validators.isNonEmptyString,
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: widget.controller.address2Controller,
            decoration: const InputDecoration(
              labelText: 'Address Line 2',
              hintText: 'APT 404',
            ),
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: widget.controller.cityController,
            decoration: const InputDecoration(
              labelText: 'City',
              hintText: 'Providence',
            ),
            validator: Validators.isNonEmptyString,
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: widget.controller.stateController,
            decoration: const InputDecoration(
              labelText: 'State',
              hintText: 'RI',
            ),
            validator: Validators.isNonEmptyString,
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: widget.controller.postalCodeController,
            decoration: const InputDecoration(
              labelText: 'Postal Code',
              hintText: '02900',
            ),
            keyboardType: TextInputType.number,
            validator: Validators.isNonEmptyString,
          ),
        ],
      ),
    );
  }
}

class Validators {
  static String? isNonEmptyString(String? value) {
    if (value == null || value.isEmpty) {
      return 'Required';
    }

    return null;
  }

  static String? isValidEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Required';
    }

    final emailRegExp = RegExp(r"^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+");
    return emailRegExp.hasMatch(value) ? null : 'Valid email required';
  }

  static String? isValidPhone(String? value) {
    if (value == null || value.isEmpty) {
      return 'Required';
    }

    final phoneRegExp = RegExp(r"^\([0-9]{3}\) [0-9]{3}-[0-9]{4}$");
    return phoneRegExp.hasMatch(value)
        ? null
        : 'Valid 10-digit phone number required';
  }
}

import 'package:flutter/material.dart';

import 'contact_info_controller.dart';

class ContactInfoForm extends StatelessWidget {
  const ContactInfoForm({super.key, required this.controller});

  final ContactInfoController controller;

  @override
  Widget build(BuildContext context) {
    return Form(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          TextFormField(
            controller: controller.firstNameController,
            decoration: const InputDecoration(
              labelText: 'First Name',
              hintText: 'Ezra',
            ),
            validator: (value) {
              if (value == null) {
                return 'Required';
              }

              return null;
            },
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: controller.lastNameController,
            decoration: const InputDecoration(
              labelText: 'Last Name',
              hintText: 'Elderberry',
            ),
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: controller.emailController,
            decoration: const InputDecoration(
                labelText: 'Email', hintText: 'e.elderberry@mail.com'),
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: controller.phoneController,
            decoration: const InputDecoration(
              labelText: 'Phone',
              hintText: '(555) 555-5555',
            ),
          ),
          const SizedBox(height: 64),
          TextFormField(
            controller: controller.addressController,
            decoration: const InputDecoration(
              labelText: 'Address',
              hintText: '123 Main Street',
            ),
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: controller.address2Controller,
            decoration: const InputDecoration(
              labelText: 'Address Line 2',
              hintText: 'APT 404',
            ),
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: controller.cityController,
            decoration: const InputDecoration(
              labelText: 'City',
              hintText: 'Providence',
            ),
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: controller.stateController,
            decoration: const InputDecoration(
              labelText: 'State',
              hintText: 'RI',
            ),
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: controller.postalCodeController,
            decoration: const InputDecoration(
              labelText: 'Postal Code',
              hintText: '02900',
            ),
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:onboarding/core/address.dart';

class ContactModel {
  const ContactModel({
    required this.firstName,
    required this.lastName,
    required this.phone,
    required this.email,
    required this.address,
  });

  final String firstName;
  final String lastName;

  final String phone;
  final String email;

  final Address address;

  String get fullName => '$firstName $lastName';
}

class ContactNotifier extends ValueNotifier<ContactModel?> {
  ContactNotifier(super.value);
}

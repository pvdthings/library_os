import 'dart:math';

import 'package:flutter/material.dart';
import 'package:librarian_app/dashboard/pages/dashboard_page.dart';
import 'package:librarian_app/widgets/fade_page_route.dart';

import '../widgets/access_code_form.dart';
import '../widgets/username_form.dart';

class SignInPage extends StatefulWidget {
  const SignInPage({super.key, this.message});

  final String? message;

  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  bool didAccessCodeSend = false;
  String? email;

  void onEmailSubmitted(String email) {
    setState(() {
      didAccessCodeSend = true;
      this.email = email;
    });
  }

  void onCodeAccepted() {
    Navigator.of(context).pushAndRemoveUntil(
      createFadePageRoute(child: const DashboardPage()),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final cardHeight = min<double>(240, screenSize.height);
    final cardWidth = min<double>(cardHeight, screenSize.width);

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Center(
          child: Card(
            child: Container(
              padding: const EdgeInsets.all(16),
              width: cardWidth,
              child: didAccessCodeSend
                  ? AccessCodeForm(
                      email: email!,
                      message: widget.message,
                      onSuccess: onCodeAccepted,
                    )
                  : UsernameForm(
                      message: widget.message,
                      onSuccess: onEmailSubmitted,
                    ),
            ),
          ),
        ),
      ),
    );
  }
}

final signOutPageTransition = createFadePageRoute(
  child: SignInPage(
    message: 'You have been signed out.',
  ),
  duration: const Duration(milliseconds: 500),
);

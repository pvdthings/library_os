import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:librarian_app/modules/authentication/providers/signin_error_provider.dart';
import 'package:librarian_app/modules/authentication/providers/auth_service_provider.dart';
import 'package:librarian_app/dashboard/pages/dashboard_page.dart';
import 'package:librarian_app/widgets/fade_page_route.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../widgets/logo_image.dart';

// TODO: Refactor using MVVM
class SignInPage extends StatefulWidget {
  const SignInPage({super.key, this.message});

  final String? message;

  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  bool didAccessCodeSend = false;
  String? email;

  void navigateToDashboard() {
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
                      onSuccess: navigateToDashboard,
                    )
                  : UsernameForm(
                      message: widget.message,
                      onSuccess: (email) => setState(() {
                        didAccessCodeSend = true;
                        this.email = email;
                      }),
                    ),
            ),
          ),
        ),
      ),
    );
  }
}

class UsernameForm extends ConsumerWidget {
  UsernameForm({super.key, this.message, this.onSuccess});

  final _emailController = TextEditingController();

  final String? message;
  final void Function(String email)? onSuccess;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    Future<void> signIn() async {
      try {
        await AuthService.instance.signIn(email: _emailController.text);
        onSuccess?.call(_emailController.text);
      } on AuthException catch (error) {
        ref.read(signinErrorProvider.notifier).state = error.message;
      } catch (error) {
        ref.read(signinErrorProvider.notifier).state =
            "An unexpected error occurred.";
      }
    }

    return Form(
      autovalidateMode: AutovalidateMode.onUserInteraction,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          LogoImage(),
          const SizedBox(height: 8.0),
          TextFormField(
            controller: _emailController,
            decoration: const InputDecoration(
              labelText: 'Email',
            ),
            keyboardType: TextInputType.emailAddress,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Email is required';
              }

              return null;
            },
          ),
          const SizedBox(height: 16.0),
          ListenableBuilder(
            listenable: _emailController,
            builder: (context, _) => FilledButton.icon(
              onPressed: _emailController.text.isNotEmpty ? signIn : null,
              label: const Text('Sign in'),
            ),
          ),
          if (ref.watch(signinErrorProvider) != null || message != null) ...[
            const SizedBox(height: 16.0),
            Text(ref.read(signinErrorProvider) ?? message!),
          ],
        ],
      ),
    );
  }
}

class AccessCodeForm extends ConsumerWidget {
  AccessCodeForm({
    super.key,
    required this.email,
    this.message,
    this.onSuccess,
  });

  final _codeController = TextEditingController();

  final String email;
  final String? message;
  final void Function()? onSuccess;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    Future<void> signIn() async {
      try {
        await AuthService.instance.submitAccessCode(
          accessCode: _codeController.text,
          email: email,
          onSuccess: onSuccess,
        );
      } on AuthException catch (error) {
        ref.read(signinErrorProvider.notifier).state = error.message;
      } catch (error) {
        ref.read(signinErrorProvider.notifier).state =
            "An unexpected error occurred.";
      }
    }

    return Form(
      autovalidateMode: AutovalidateMode.onUserInteraction,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          LogoImage(),
          const SizedBox(height: 8.0),
          Text('Enter the access code that was sent to your email.'),
          const SizedBox(height: 8.0),
          TextFormField(
            controller: _codeController,
            decoration: const InputDecoration(
              labelText: 'Access Code',
            ),
            keyboardType: TextInputType.emailAddress,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Access Code is required';
              }

              return null;
            },
          ),
          const SizedBox(height: 16.0),
          ListenableBuilder(
            listenable: _codeController,
            builder: (context, _) => FilledButton.icon(
              onPressed: _codeController.text.isNotEmpty ? signIn : null,
              label: const Text('Verify'),
            ),
          ),
          if (ref.watch(signinErrorProvider) != null || message != null) ...[
            const SizedBox(height: 16.0),
            Text(ref.read(signinErrorProvider) ?? message!),
          ],
        ],
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

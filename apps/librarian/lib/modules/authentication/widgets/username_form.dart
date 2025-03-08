import 'package:flutter/material.dart';
import 'package:librarian_app/core/services/auth_service.dart';

import 'logo_image.dart';

class UsernameForm extends StatefulWidget {
  const UsernameForm({super.key, this.message, this.onSuccess});

  final String? message;
  final void Function(String email)? onSuccess;

  @override
  State<UsernameForm> createState() => _UsernameFormState();
}

class _UsernameFormState extends State<UsernameForm> {
  final _emailController = TextEditingController();

  String? errorMessage;

  Future<void> signIn() async {
    await AuthService.instance.requestAccessCode(
      email: _emailController.text,
      onSuccess: () {
        widget.onSuccess?.call(_emailController.text);
      },
      onError: (error) => setState(() {
        errorMessage = error;
      }),
    );
  }

  @override
  Widget build(BuildContext context) {
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
          if (errorMessage != null || widget.message != null) ...[
            const SizedBox(height: 16.0),
            Text(errorMessage ?? widget.message!),
          ],
        ],
      ),
    );
  }
}

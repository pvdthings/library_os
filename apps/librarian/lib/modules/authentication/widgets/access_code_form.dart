import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../providers/auth_service_provider.dart';
import 'logo_image.dart';

class AccessCodeForm extends StatefulWidget {
  const AccessCodeForm({
    super.key,
    required this.email,
    this.message,
    this.onSuccess,
  });

  final String email;
  final String? message;
  final void Function()? onSuccess;

  @override
  State<AccessCodeForm> createState() => _AccessCodeFormState();
}

class _AccessCodeFormState extends State<AccessCodeForm> {
  final _codeController = TextEditingController();

  String? errorMessage;

  Future<void> verify() async {
    await AuthService.instance.verifyAccessCode(
      accessCode: _codeController.text,
      email: widget.email,
      onSuccess: widget.onSuccess,
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
          Text('Enter the access code that was sent to ${widget.email}.'),
          const SizedBox(height: 8.0),
          TextFormField(
            controller: _codeController,
            decoration: const InputDecoration(
              labelText: 'Access Code',
            ),
            inputFormatters: [
              FilteringTextInputFormatter.digitsOnly,
            ],
            keyboardType: TextInputType.number,
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
              onPressed: _codeController.text.isNotEmpty ? verify : null,
              label: const Text('Verify'),
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

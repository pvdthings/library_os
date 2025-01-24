import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:librarian_app/core/core.dart';
import 'package:librarian_app/modules/authentication/providers/auth_service_provider.dart';
import 'package:librarian_app/dashboard/pages/dashboard_page.dart';
import 'package:librarian_app/widgets/fade_page_route.dart';

class SignInPage extends ConsumerStatefulWidget {
  const SignInPage({super.key});

  @override
  ConsumerState<SignInPage> createState() => SignInPageState();
}

class SignInPageState extends ConsumerState<SignInPage> {
  final _emailController = TextEditingController();
  final _codeController = TextEditingController();
  bool isCodeSent = false;

  void showSnackBar(String message) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }

  Future<void> requestCode() async {
    await ref.read(authServiceProvider).requestCode(
        email: _emailController.text,
        onSuccess: () {
          setState(() => isCodeSent = true);
          showSnackBar('Access code sent');
        },
        onError: (error) {
          showSnackBar(error);
        });
  }

  Future<void> verifyCode() async {
    await ref.read(authServiceProvider).verifyCode(
        email: _emailController.text,
        code: _codeController.text,
        onSuccess: () {
          Navigator.of(context).pushAndRemoveUntil(
            createFadePageRoute(child: const DashboardPage()),
            (route) => false,
          );
        },
        onError: (error) {
          showSnackBar(error);
        });
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
              child: Form(
                autovalidateMode: AutovalidateMode.onUserInteraction,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisSize: MainAxisSize.min,
                  spacing: 8.0,
                  children: [
                    _LogoImage(),
                    TextFormField(
                      controller: _emailController,
                      decoration: const InputDecoration(
                        labelText: 'Email',
                      ),
                      keyboardType: TextInputType.emailAddress,
                      readOnly: isCodeSent,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Email is required';
                        }

                        return null;
                      },
                    ),
                    if (isCodeSent)
                      TextFormField(
                        controller: _codeController,
                        decoration: const InputDecoration(
                          labelText: 'Access Code',
                        ),
                        keyboardType: TextInputType.number,
                        obscureText: true,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Access code is required';
                          }

                          return null;
                        },
                      ),
                    const SizedBox(height: 8.0),
                    ListenableBuilder(
                      listenable: Listenable.merge([
                        _emailController,
                        _codeController,
                      ]),
                      builder: (context, _) => FilledButton.icon(
                        onPressed: isCodeSent ? verifyCode : requestCode,
                        label: isCodeSent
                            ? const Text('Sign in')
                            : const Text('Request code'),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _LogoImage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    if (Library.logoUrl != null) {
      return Image.network(
        Library.logoUrl!,
        loadingBuilder: (context, child, progress) {
          return Center(child: child);
        },
        isAntiAlias: true,
        height: 120,
      );
    }

    if (kDebugMode) {
      return Image.asset(
        'pvd_things.png',
        isAntiAlias: true,
        height: 120,
      );
    }

    return const Icon(
      Icons.local_library_outlined,
      size: 120,
    );
  }
}

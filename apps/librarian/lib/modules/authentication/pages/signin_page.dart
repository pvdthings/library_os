import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:librarian_app/core/core.dart';
import 'package:librarian_app/modules/authentication/providers/signin_error_provider.dart';
import 'package:librarian_app/modules/authentication/providers/auth_service_provider.dart';
import 'package:librarian_app/dashboard/pages/dashboard_page.dart';
import 'package:librarian_app/widgets/fade_page_route.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SignInPage extends ConsumerWidget {
  SignInPage({super.key});

  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  bool get _canSubmit =>
      _emailController.text.isNotEmpty && _passwordController.text.isNotEmpty;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    void navigateToDashboard() {
      Navigator.of(context).pushAndRemoveUntil(
        createFadePageRoute(child: const DashboardPage()),
        (route) => false,
      );
    }

    Future<void> signIn() async {
      try {
        await ref.read(authServiceProvider).signIn(
            email: _emailController.text,
            password: _passwordController.text,
            onSuccess: navigateToDashboard);
      } on AuthException catch (error) {
        ref.read(signinErrorProvider.notifier).state = error.message;
      } catch (error) {
        ref.read(signinErrorProvider.notifier).state =
            "An unexpected error occurred.";
      }
    }

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
                children: [
                  _LogoImage(),
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
                  const SizedBox(height: 8.0),
                  TextFormField(
                    controller: _passwordController,
                    decoration: const InputDecoration(
                      labelText: 'Password',
                    ),
                    keyboardType: TextInputType.visiblePassword,
                    obscureText: true,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Password is required';
                      }

                      return null;
                    },
                  ),
                  const SizedBox(height: 16.0),
                  ListenableBuilder(
                    listenable: Listenable.merge([
                      _emailController,
                      _passwordController,
                    ]),
                    builder: (context, _) => FilledButton.icon(
                      onPressed: _canSubmit ? signIn : null,
                      label: const Text('Sign in'),
                    ),
                  ),
                  if (ref.watch(signinErrorProvider) != null) ...[
                    const SizedBox(height: 16.0),
                    Text(ref.read(signinErrorProvider)!)
                  ],
                ],
              ),
            ),
          ),
        )),
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

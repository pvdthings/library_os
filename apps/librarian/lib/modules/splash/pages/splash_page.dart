import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:librarian_app/modules/authentication/pages/signin_page.dart';
import 'package:librarian_app/core/services/auth_service.dart';
import 'package:librarian_app/dashboard/pages/dashboard_page.dart';
import 'package:librarian_app/widgets/fade_page_route.dart';

class SplashPage extends ConsumerStatefulWidget {
  const SplashPage({super.key});

  @override
  ConsumerState<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends ConsumerState<SplashPage> {
  @override
  void initState() {
    super.initState();

    Timer(const Duration(seconds: 2), () {
      if (!AuthService.instance.hasValidSession) {
        Navigator.of(context).pushAndRemoveUntil(
          createFadePageRoute(child: SignInPage()),
          (route) => false,
        );
      } else {
        Navigator.of(context).pushAndRemoveUntil(
          createFadePageRoute(child: const DashboardPage()),
          (route) => false,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(child: CircularProgressIndicator()),
    );
  }
}

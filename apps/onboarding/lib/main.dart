import 'package:flutter/material.dart';
import 'package:onboarding/models/contact_model.dart';
import 'package:onboarding/pages/stepper_page.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (_) => ContactNotifier(null)),
    ],
    child: const OnboardingApp(),
  ));
}

class OnboardingApp extends StatelessWidget {
  const OnboardingApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Onboarding',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo),
        useMaterial3: true,
        inputDecorationTheme: const InputDecorationTheme(
          filled: true,
        ),
      ),
      home: const StepperPage(),
    );
  }
}

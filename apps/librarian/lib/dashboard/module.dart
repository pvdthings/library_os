import 'package:flutter/material.dart';

class DashboardModule {
  const DashboardModule({
    required this.title,
    required this.desktopLayout,
    required this.mobileLayout,
  });

  final String title;
  final Widget desktopLayout;
  final Widget? mobileLayout;
}

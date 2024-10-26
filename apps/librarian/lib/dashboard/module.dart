import 'package:flutter/material.dart';

class DashboardModule {
  const DashboardModule({
    required this.desktopLayout,
    required this.mobileLayout,
    this.title,
  });

  final String? title;
  final Widget desktopLayout;
  final Widget? mobileLayout;
}

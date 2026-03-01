import './constants.dart';

enum AppMode {
  normal,
  demo,
}

final appMode = mode == 'demo' ? AppMode.demo : AppMode.normal;

extension AppModeExtension on AppMode {
  bool get isDemo => this == AppMode.demo;
}

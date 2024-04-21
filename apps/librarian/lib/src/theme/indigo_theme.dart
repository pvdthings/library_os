import 'package:flutter/material.dart';

ThemeData _createIndigoTheme() {
  final baseTheme = ThemeData(
    primarySwatch: Colors.indigo,
    primaryColor: Colors.deepPurple,
    brightness: Brightness.dark,
    useMaterial3: true,
  );

  return baseTheme.copyWith(
    listTileTheme: ListTileThemeData(
      selectedTileColor:
          baseTheme.colorScheme.secondaryContainer.withAlpha(100),
      selectedColor: Colors.white,
    ),
  );
}

final indigoTheme = _createIndigoTheme();

import 'package:flutter/material.dart';

ThemeData _createIndigoTheme() {
  final baseTheme = ThemeData(
    primarySwatch: Colors.indigo,
    primaryColor: Colors.deepPurple,
    brightness: Brightness.dark,
    useMaterial3: true,
  );

  return baseTheme.copyWith(
    cardTheme: baseTheme.cardTheme.copyWith(
      color: baseTheme.colorScheme.surfaceContainerLow,
    ),
    dialogTheme: DialogTheme(
      backgroundColor: baseTheme.colorScheme.surfaceContainerHigh,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
    ),
    drawerTheme: baseTheme.drawerTheme.copyWith(
      backgroundColor: baseTheme.colorScheme.surfaceContainerHigh,
    ),
    listTileTheme: ListTileThemeData(
      selectedTileColor:
          baseTheme.colorScheme.secondaryContainer.withAlpha(100),
      selectedColor: Colors.white,
    ),
  );
}

final indigoTheme = _createIndigoTheme();

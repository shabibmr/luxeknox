import 'package:flutter/material.dart';

/// Locale hooks for MaterialApp — expand ARB files as features need copy.
abstract final class AppLocaleConfig {
  static const Locale fallback = Locale('en');

  static const List<Locale> supportedLocales = [
    Locale('en'),
  ];
}

import 'package:flutter/material.dart';

/// Shorthand access to the active theme roles.
///
/// Used throughout the UI so widgets read `context.colors.primary` instead of
/// threading a `ThemeData` parameter through every constructor.
extension BuildContextTheme on BuildContext {
  /// The active Material 3 colour scheme.
  ColorScheme get colors => Theme.of(this).colorScheme;

  /// The active type scale.
  TextTheme get textTheme => Theme.of(this).textTheme;

  /// Whether the app is currently rendering in dark mode.
  bool get isDarkMode => Theme.of(this).brightness == Brightness.dark;
}

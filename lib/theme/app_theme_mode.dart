import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// The single place the app's `ThemeMode` is decided.
///
/// It defaults to [ThemeMode.system] so the app follows the device. A
/// settings surface will write to this controller in a later milestone; the
/// theme plumbing already exists, so that work will not touch the app root.
class AppThemeModeController extends Notifier<ThemeMode> {
  @override
  ThemeMode build() => ThemeMode.system;

  /// Overrides the system setting.
  void setThemeMode(ThemeMode mode) => state = mode;
}

/// The app-wide [ThemeMode]. See [AppThemeModeController].
final appThemeModeProvider =
    NotifierProvider<AppThemeModeController, ThemeMode>(
      AppThemeModeController.new,
    );

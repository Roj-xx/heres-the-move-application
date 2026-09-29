import 'package:flutter/material.dart';

/// Material 3 type scale expressed in Geist.
///
/// Roles are tuned rather than left at the Material defaults: Geist benefits
/// from slightly tighter tracking on display/headline roles (weight 600–700)
/// and neutral tracking on body and label roles (weight 400–600).
///
/// Sizes stay small-screen friendly — the largest role, `displayLarge`, is
/// 40sp so it never overflows a 375pt-wide phone at the default text scale.
abstract final class AppTypography {
  /// The bundled typeface family.
  static const String fontFamily = 'Geist';

  /// Geist as rendered for tabular / numeric surfaces (cycle days, XP, streaks).
  static const String monospaceFamily = 'Geist';

  /// The full Material 3 type scale in Geist, tinted with [color].
  static TextTheme textTheme({required Color color}) {
    return const TextTheme(
      displayLarge: TextStyle(
        fontSize: 40,
        height: 1.1,
        fontWeight: FontWeight.w700,
        letterSpacing: -0.8,
      ),
      displayMedium: TextStyle(
        fontSize: 34,
        height: 1.15,
        fontWeight: FontWeight.w700,
        letterSpacing: -0.6,
      ),
      displaySmall: TextStyle(
        fontSize: 28,
        height: 1.2,
        fontWeight: FontWeight.w600,
        letterSpacing: -0.4,
      ),
      headlineLarge: TextStyle(
        fontSize: 28,
        height: 1.2,
        fontWeight: FontWeight.w600,
        letterSpacing: -0.4,
      ),
      headlineMedium: TextStyle(
        fontSize: 24,
        height: 1.25,
        fontWeight: FontWeight.w600,
        letterSpacing: -0.3,
      ),
      headlineSmall: TextStyle(
        fontSize: 20,
        height: 1.3,
        fontWeight: FontWeight.w600,
        letterSpacing: -0.2,
      ),
      titleLarge: TextStyle(
        fontSize: 19,
        height: 1.3,
        fontWeight: FontWeight.w600,
        letterSpacing: -0.2,
      ),
      titleMedium: TextStyle(
        fontSize: 16,
        height: 1.35,
        fontWeight: FontWeight.w600,
        letterSpacing: -0.1,
      ),
      titleSmall: TextStyle(
        fontSize: 14,
        height: 1.4,
        fontWeight: FontWeight.w600,
      ),
      bodyLarge: TextStyle(
        fontSize: 16,
        height: 1.5,
        fontWeight: FontWeight.w400,
      ),
      bodyMedium: TextStyle(
        fontSize: 14.5,
        height: 1.5,
        fontWeight: FontWeight.w400,
      ),
      bodySmall: TextStyle(
        fontSize: 13,
        height: 1.45,
        fontWeight: FontWeight.w400,
        letterSpacing: 0.1,
      ),
      labelLarge: TextStyle(
        fontSize: 15,
        height: 1.3,
        fontWeight: FontWeight.w600,
        letterSpacing: 0.1,
      ),
      labelMedium: TextStyle(
        fontSize: 13,
        height: 1.3,
        fontWeight: FontWeight.w500,
        letterSpacing: 0.2,
      ),
      labelSmall: TextStyle(
        fontSize: 11.5,
        height: 1.3,
        fontWeight: FontWeight.w500,
        letterSpacing: 0.4,
      ),
    ).apply(fontFamily: fontFamily, bodyColor: color, displayColor: color);
  }
}

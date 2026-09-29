import 'package:flutter/material.dart';

import 'app_palette.dart';

/// The app's gradients.
///
/// There is exactly one gradient in Here's the Move: a warm coral-to-amber
/// ramp. Everything else is a solid surface with a border and a soft shadow.
/// Gradients are reserved for the moments that deserve emphasis —
///
/// * the primary call to action,
/// * the Today's Move hero,
/// * the Log Period call to action,
/// * XP and reward surfaces,
/// * profile-level accents.
///
/// Keeping that list short is what stops the app from looking like a wall of
/// gradients.
abstract final class AppGradients {
  /// The brand gradient, derived from the active [ColorScheme] so its two
  /// stops always sit at the same contrast as the `primary` role.
  ///
  /// Content placed on top must use `ColorScheme.onPrimary`; on a light
  /// theme that is white, and on a dark theme it is a deep coral. Hard-coding
  /// white here would fall below the 4.5:1 body-text contrast floor in dark
  /// mode.
  static LinearGradient brand(ColorScheme colors) {
    return LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [
        colors.primary,
        Color.lerp(colors.primary, _warmShift(colors), 0.32)!,
      ],
    );
  }

  /// The amber the brand gradient fades toward.
  ///
  /// Dark themes push toward a brighter gold because the gradient's own base
  /// is a light coral; light themes push toward a deeper gold so white labels
  /// keep their contrast.
  static Color _warmShift(ColorScheme colors) {
    return colors.brightness == Brightness.dark
        ? AppPalette.gold500
        : AppPalette.gold700;
  }
}

import 'package:flutter/material.dart';

import 'app_palette.dart';

/// Elevation tokens.
///
/// Light mode uses soft, warm-tinted drop shadows. Dark mode uses a deeper
/// shadow plus a restrained coral glow so elevated surfaces read as "lifted"
/// without turning the whole screen into a neon panel.
abstract final class AppShadows {
  /// [BoxShadow] colour for light-mode elevation.
  static const Color lightShadow = AppPalette.charcoal900;

  /// [BoxShadow] colour for dark-mode elevation.
  static const Color darkShadow = Color(0xFF000000);

  /// Default card elevation. Soft and wide; never a hard drop shadow.
  static List<BoxShadow> card({bool isDark = false}) => isDark
      ? const [
          BoxShadow(
            color: Color(0x59000000),
            blurRadius: 20,
            offset: Offset(0, 8),
          ),
        ]
      : const [
          BoxShadow(
            color: Color(0x0F1F1B18),
            blurRadius: 24,
            offset: Offset(0, 8),
          ),
          BoxShadow(
            color: Color(0x0A1F1B18),
            blurRadius: 4,
            offset: Offset(0, 2),
          ),
        ];

  /// Raised surfaces such as sticky footers and floating CTAs.
  static List<BoxShadow> elevated({bool isDark = false}) => isDark
      ? const [
          BoxShadow(
            color: Color(0x73000000),
            blurRadius: 28,
            offset: Offset(0, 12),
          ),
        ]
      : const [
          BoxShadow(
            color: Color(0x1A1F1B18),
            blurRadius: 32,
            offset: Offset(0, 12),
          ),
          BoxShadow(
            color: Color(0x0D1F1B18),
            blurRadius: 6,
            offset: Offset(0, 2),
          ),
        ];

  /// Full-width panels such as bottom sheets and modals.
  static List<BoxShadow> panel({bool isDark = false}) => isDark
      ? const [
          BoxShadow(
            color: Color(0x80000000),
            blurRadius: 48,
            offset: Offset(0, 24),
          ),
        ]
      : const [
          BoxShadow(
            color: Color(0x1F1F1B18),
            blurRadius: 48,
            offset: Offset(0, 24),
          ),
        ];

  /// The restrained warm glow reserved for dark-mode reward/hero surfaces.
  ///
  /// Deliberately not available in light mode: on light backgrounds a coloured
  /// glow reads as a rendering artefact rather than warmth.
  static const List<BoxShadow> darkGlow = [
    BoxShadow(color: Color(0x4DFF8A6B), blurRadius: 32, offset: Offset(0, 12)),
  ];
}

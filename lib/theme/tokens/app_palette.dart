import 'package:flutter/painting.dart';

/// Raw brand colour ramp for Here's the Move.
///
/// These are the single source of truth for the brand's hues. Semantic,
/// role-based colours (primary, surface, error, ...) are derived from this
/// ramp in `AppTheme` via Material 3 `ColorScheme`.
///
/// Nothing in the UI layer should reference this class directly; use
/// `context.colors` (a `ColorScheme`) instead. The only exceptions are the
/// brand showcase screens and the theme builder itself.
abstract final class AppPalette {
  // ---------------------------------------------------------------------------
  // Coral — the primary brand hue. Warm, friendly, never "men's app red".
  // ---------------------------------------------------------------------------

  /// Deepest coral. Reserved for press states and high-contrast text on tint.
  static const Color coral900 = Color(0xFF6E2411);

  /// Primary coral used as the light-mode `primary` role.
  /// 4.9:1 against white, so white labels on the CTA stay readable.
  static const Color coral600 = Color(0xFFC14B29);

  /// Signature brand coral. Used for gradients, glows and large accent fills.
  static const Color coral500 = Color(0xFFD9573A);

  /// Light coral. Used as the dark-mode `primary` role.
  /// 8.1:1 against the dark surface.
  static const Color coral400 = Color(0xFFFF8A6B);

  /// Soft coral tint for light-mode containers.
  static const Color coral200 = Color(0xFFFBDDD2);

  /// Deep coral for dark-mode containers.
  static const Color coral800 = Color(0xFF6B2413);

  // ---------------------------------------------------------------------------
  // Gold — reward / XP / streak accent. Never used for primary actions.
  // ---------------------------------------------------------------------------

  static const Color gold700 = Color(0xFF9A6410);
  static const Color gold600 = Color(0xFFC27F17);
  static const Color gold500 = Color(0xFFE39B2C);
  static const Color gold400 = Color(0xFFF0B45C);
  static const Color gold300 = Color(0xFFF5CE85);
  static const Color gold200 = Color(0xFFFBE7C4);

  // ---------------------------------------------------------------------------
  // Clay — tertiary supporting hue. Warm brown, used sparingly.
  // ---------------------------------------------------------------------------

  static const Color clay600 = Color(0xFF7A5C3E);
  static const Color clay400 = Color(0xFFE0BC9C);
  static const Color clay200 = Color(0xFFEFDFCE);
  static const Color clay800 = Color(0xFF412F1B);
  static const Color clay900 = Color(0xFF2E1B0B);

  // ---------------------------------------------------------------------------
  // Warm neutrals — light surfaces and warm charcoal dark surfaces.
  // ---------------------------------------------------------------------------

  static const Color neutral0 = Color(0xFFFFFFFF);
  static const Color neutral50 = Color(0xFFFBF8F4);
  static const Color neutral100 = Color(0xFFF6F1EB);
  static const Color neutral150 = Color(0xFFF1EAE2);
  static const Color neutral200 = Color(0xFFEBE3D9);
  static const Color neutral300 = Color(0xFFE5DCD1);
  static const Color neutral400 = Color(0xFFD2C6B8);
  static const Color neutral500 = Color(0xFFC9BEB2);
  static const Color neutral700 = Color(0xFF8B8178);
  static const Color neutral800 = Color(0xFF5A514A);

  static const Color charcoal950 = Color(0xFF0F0D0B);
  static const Color charcoal900 = Color(0xFF15120F);
  static const Color charcoal850 = Color(0xFF1C1815);
  static const Color charcoal800 = Color(0xFF221D19);
  static const Color charcoal700 = Color(0xFF2B2521);
  static const Color charcoal600 = Color(0xFF362F29);
  static const Color charcoal400 = Color(0xFF6E655C);
  static const Color charcoal300 = Color(0xFFBFB4AA);
  static const Color charcoal100 = Color(0xFFF4EFE9);

  // ---------------------------------------------------------------------------
  // Status.
  // ---------------------------------------------------------------------------

  /// Deeper, less saturated red than the brand coral so alerts read as
  /// "alarm" rather than "brand". Always paired with an icon and text —
  /// never signalled by colour alone.
  static const Color danger600 = Color(0xFFB3261E);
  static const Color danger200 = Color(0xFFF9DEDC);
  static const Color danger900 = Color(0xFF410E0B);
  static const Color danger400 = Color(0xFFFFB4AB);
  static const Color danger800 = Color(0xFF93000A);
}

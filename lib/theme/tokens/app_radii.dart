/// Corner radius tokens.
///
/// The shape language is deliberately *not* pill-shaped: small controls are
/// softly rounded, cards are noticeably rounder, large panels rounder still.
abstract final class AppRadii {
  /// 10 — badges and very small controls.
  static const double controlSmall = 10;

  /// 12 — buttons, text fields, chips.
  static const double control = 12;

  /// 16 — compact cards and list tiles.
  static const double cardSmall = 16;

  /// 18 — the default card radius.
  static const double card = 18;

  /// 20 — large cards.
  static const double cardLarge = 20;

  /// 24 — panels, sheets and hero surfaces.
  static const double panel = 24;

  /// Fully rounded. Reserved for progress pills and avatar chips.
  static const double pill = 999;
}

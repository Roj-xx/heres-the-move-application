/// The spacing scale for Here's the Move.
///
/// Every gap, pad and inset in the app must come from this scale so vertical
/// and horizontal rhythm stays consistent. Values are a 4pt-based scale with
/// a 20pt step where the design system needs one.
abstract final class AppSpacing {
  /// 4 — icon-to-label micro gaps, hairline separation.
  static const double xxs = 4;

  /// 8 — gaps inside a single control.
  static const double xs = 8;

  /// 12 — gaps inside a card.
  static const double sm = 12;

  /// 16 — default gap between sibling elements.
  static const double md = 16;

  /// 20 — default horizontal page gutter on mobile.
  static const double lg = 20;

  /// 24 — gap between related blocks.
  static const double xl = 24;

  /// 32 — gap between sections.
  static const double xxl = 32;

  /// 40 — gap above a major section.
  static const double xxxl = 40;

  /// 48 — hero-scale breathing room.
  static const double huge = 48;

  /// Horizontal page gutter on compact (phone) widths.
  static const double pageGutter = lg;

  /// Horizontal page gutter once the viewport is at least
  /// [AppBreakpoints.mediumMinWidth] wide.
  static const double pageGutterWide = xxl;
}

/// Layout breakpoints and content-width caps.
///
/// The product is mobile-first (375–430pt). These tokens exist so that a
/// later tablet pass is a token change rather than an architecture change.
abstract final class AppBreakpoints {
  /// Widths below this are treated as compact (phones).
  static const double mediumMinWidth = 600;

  /// Widths at or above this and below [expandedMinWidth] are medium
  /// (small tablets, unfolded foldables, desktop windows).
  static const double mediumMaxWidth = 905;

  /// Widths at or above this are expanded.
  static const double expandedMinWidth = 905;

  /// Widest a single column of reading/app content is allowed to get before
  /// it is centred with gutters around it.
  ///
  /// Keeps line lengths comfortable on large screens without introducing a
  /// separate desktop layout.
  static const double maxContentWidth = 560;
}

/// Baseline accessibility constraints for Here's the Move.
///
/// These are the floors the UI is designed against, not a substitute for
/// per-widget labelling. Anything interactive must meet
/// [minTouchTarget] and must not rely on colour alone to convey state.
abstract final class AppAccessibility {
  /// The smallest interactive target the app ships.
  ///
  /// Matches the Material accessibility guidance for touch targets so
  /// components never have to shrink below this to fit content.
  static const double minTouchTarget = 48;
}

import 'package:flutter/animation.dart';

/// Motion tokens.
///
/// Motion in this product is short, confident and never bouncy-toy.
/// [curveEmphasized] is a Material 3 emphasised-decelerate curve;
/// [curveStandard] is a plain ease-out for small affordances.
abstract final class AppMotion {
  /// 120ms — state flips such as an icon swapping colour.
  static const Duration instant = Duration(milliseconds: 120);

  /// 200ms — hovers, presses, small reveals.
  static const Duration fast = Duration(milliseconds: 200);

  /// 300ms — the default for page-level and theme transitions.
  static const Duration standard = Duration(milliseconds: 300);

  /// 500ms — large celebratory or reveal motion (XP, level-up).
  static const Duration slow = Duration(milliseconds: 500);

  /// Default curve for most motion.
  static const Curve curveStandard = Curves.easeOutCubic;

  /// Emphasised decelerate, for larger surface entrances.
  static const Curve curveEmphasized = Cubic(0.2, 0.0, 0.0, 1.0);

  /// Ease-in, used when a surface leaves the screen.
  static const Curve curveExit = Curves.easeInCubic;
}

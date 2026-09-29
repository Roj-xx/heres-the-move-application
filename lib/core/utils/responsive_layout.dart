import 'dart:math' as math;

import '../../theme/tokens/app_breakpoints.dart';
import '../../theme/tokens/app_spacing.dart';

/// Responsive helpers shared by the app's page and section primitives.
///
/// The app is mobile-first; these helpers only widen the gutters and cap the
/// content column so a larger viewport never produces an unreadable line
/// length. They intentionally do not implement a tablet/desktop layout.
abstract final class ResponsiveLayout {
  /// Horizontal page gutter appropriate for [width].
  static double pageGutter(double width) =>
      width >= AppBreakpoints.mediumMinWidth
      ? AppSpacing.pageGutterWide
      : AppSpacing.pageGutter;

  /// The width a content column may occupy on a [width]-wide viewport.
  static double contentWidth(double width) =>
      math.min(width, AppBreakpoints.maxContentWidth);

  /// Whether [width] is a compact (phone-first) viewport.
  static bool isCompact(double width) => width < AppBreakpoints.mediumMinWidth;

  /// Whether [width] is at least medium (tablet and larger).
  static bool isMediumOrWider(double width) =>
      width >= AppBreakpoints.mediumMinWidth;
}

import 'dart:math' as math;
import 'dart:ui' show Color;

/// WCAG 2.1 relative luminance.
///
/// Duplicated here on purpose: it is a specification formula, not app logic,
/// and pulling it into `lib/` to satisfy a test would be worse.
double relativeLuminance(Color color) {
  double channel(double value) => value <= 0.03928
      ? value / 12.92
      : math.pow((value + 0.055) / 1.055, 2.4).toDouble();

  return 0.2126 * channel(color.r) +
      0.7152 * channel(color.g) +
      0.0722 * channel(color.b);
}

/// WCAG 2.1 contrast ratio between two opaque colours, from 1 to 21.
double contrastRatio(Color a, Color b) {
  final first = relativeLuminance(a);
  final second = relativeLuminance(b);
  final lighter = math.max(first, second);
  final darker = math.min(first, second);
  return (lighter + 0.05) / (darker + 0.05);
}

/// The WCAG 2.1 AA contrast floor for body-sized text.
const double aaBodyContrast = 4.5;

/// The WCAG 2.1 AA contrast floor for large text and non-text UI elements.
const double aaLargeContrast = 3.0;

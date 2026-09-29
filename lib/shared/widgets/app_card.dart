import 'package:flutter/material.dart';

import '../../core/extensions/build_context_theme.dart';
import '../../theme/tokens/app_radii.dart';
import '../../theme/tokens/app_shadows.dart';
import '../../theme/tokens/app_spacing.dart';

/// How much elevation an [AppCard] has.
enum AppCardElevation {
  /// Flush with the page. For cards on an already-raised surface.
  flat,

  /// The default. Soft, warm drop shadow plus a hairline border.
  raised,

  /// Sticky footers and floating action surfaces.
  floating,
}

/// The app's card surface.
///
/// Cards are always solid with a border and a soft shadow — no gradients.
/// Gradients are reserved for primary CTAs and hero surfaces, so keeping them
/// out of [AppCard] is what keeps the app from looking like a deck of
/// gradients.
class AppCard extends StatelessWidget {
  const AppCard({
    required this.child,
    this.onTap,
    this.padding = const EdgeInsets.all(AppSpacing.lg),
    this.elevation = AppCardElevation.raised,
    this.backgroundColor,
    this.borderColor,
    this.borderRadius,
    this.semanticLabel,
    this.semanticHint,
    super.key,
  });

  final Widget child;

  /// Makes the card tappable. A `null` callback renders a non-interactive card.
  final VoidCallback? onTap;

  final EdgeInsetsGeometry padding;
  final AppCardElevation elevation;

  /// Overrides the default surface colour, e.g. for a tinted callout.
  final Color? backgroundColor;

  /// Overrides the default hairline border colour.
  final Color? borderColor;

  /// Overrides the default corner radius. Defaults to [AppRadii.card].
  final BorderRadius? borderRadius;

  /// Readable name for assistive technology. Only needed when the card's
  /// contents are not already a coherent reading order.
  final String? semanticLabel;

  /// Describes what activating the card does, e.g. "Opens cycle details".
  final String? semanticHint;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final isDark = context.isDarkMode;
    final radius = borderRadius ?? BorderRadius.circular(AppRadii.card);

    final shadows = switch (elevation) {
      AppCardElevation.flat => const <BoxShadow>[],
      AppCardElevation.raised => AppShadows.card(isDark: isDark),
      AppCardElevation.floating => AppShadows.elevated(isDark: isDark),
    };

    final decoration = BoxDecoration(
      color: backgroundColor ?? colors.surfaceContainerLow,
      borderRadius: radius,
      border: elevation == AppCardElevation.flat
          ? null
          : Border.all(color: borderColor ?? colors.outlineVariant),
      boxShadow: shadows,
    );

    final content = Padding(padding: padding, child: child);

    if (onTap == null) {
      return Semantics(
        label: semanticLabel,
        // An explicit label replaces the card's own text rather than being
        // read out alongside it.
        excludeSemantics: semanticLabel != null,
        container: semanticLabel != null,
        child: DecoratedBox(decoration: decoration, child: content),
      );
    }

    return Semantics(
      label: semanticLabel,
      hint: semanticHint,
      excludeSemantics: semanticLabel != null,
      button: true,
      child: DecoratedBox(
        decoration: decoration,
        child: Material(
          type: MaterialType.transparency,
          child: InkWell(onTap: onTap, borderRadius: radius, child: content),
        ),
      ),
    );
  }
}

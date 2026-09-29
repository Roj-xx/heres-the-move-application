import 'package:flutter/material.dart';

import '../../core/extensions/build_context_theme.dart';
import '../../theme/tokens/app_accessibility.dart';
import '../../theme/tokens/app_gradients.dart';
import '../../theme/tokens/app_radii.dart';
import '../../theme/tokens/app_spacing.dart';

/// The visual weight of an [AppButton].
enum AppButtonVariant {
  /// The single most important action on a screen.
  ///
  /// Uses the brand gradient. Reserve this for the one thing the user should
  /// do next — never put two primary buttons on the same screen.
  primary,

  /// A supporting action. Solid surface with a border, no gradient.
  secondary,

  /// A low-emphasis action such as "Skip" or "Not now".
  tertiary,
}

/// The size ramp for an [AppButton].
enum AppButtonSize {
  /// Dense contexts such as a dialog action row. Still 48pt tall.
  small,

  /// The default.
  medium,

  /// Full-width primary calls to action.
  large,
}

/// The app's button.
///
/// A single primitive covers every action in Here's the Move so spacing,
/// radius, touch target and focus behaviour stay identical everywhere.
///
/// Only [AppButtonVariant.primary] uses a gradient. Secondary and tertiary
/// variants use solid surfaces, per the design direction.
class AppButton extends StatelessWidget {
  const AppButton({
    required this.label,
    this.onPressed,
    this.icon,
    this.trailingIcon,
    this.variant = AppButtonVariant.secondary,
    this.size = AppButtonSize.medium,
    this.isLoading = false,
    this.isExpanded = false,
    this.semanticLabel,
    this.tooltip,
    super.key,
  }) : assert(
         icon == null || trailingIcon == null,
         'Provide at most one of icon or trailingIcon.',
       );

  /// The visible text. Required so every button has an accessible name.
  final String label;

  /// Called on tap. A `null` callback renders the button as disabled.
  final VoidCallback? onPressed;

  /// Optional leading icon.
  final IconData? icon;

  /// Optional trailing icon, for example a chevron on a navigational action.
  final IconData? trailingIcon;

  /// Visual weight. See [AppButtonVariant].
  final AppButtonVariant variant;

  /// Size ramp. See [AppButtonSize].
  final AppButtonSize size;

  /// Replaces the label with a spinner and blocks interaction.
  final bool isLoading;

  /// Stretches the button to fill the available width.
  final bool isExpanded;

  /// Overrides the accessible name when the visible [label] is not
  /// self-explanatory on its own.
  final String? semanticLabel;

  /// Optional long-press explanation, mainly for icon-only affordances.
  final String? tooltip;

  @override
  Widget build(BuildContext context) {
    final isEnabled = onPressed != null && !isLoading;
    final metrics = _AppButtonMetrics.of(size);

    final content = _ButtonContent(
      label: label,
      icon: icon,
      trailingIcon: trailingIcon,
      isLoading: isLoading,
      style: metrics.style.copyWith(color: _foreground(context)),
    );

    // A supplied semantic label replaces the visible label's announcement
    // rather than stacking a second one on top of it. Applied here, inside the
    // button's own `Semantics(button: true)`, so the role is preserved.
    final labelled = semanticLabel == null
        ? content
        : Semantics(
            label: semanticLabel,
            excludeSemantics: true,
            child: content,
          );

    final button = _buildButton(context, isEnabled, metrics, labelled);

    final padded = Padding(
      padding: metrics.padding,
      child: SizedBox(height: metrics.minHeight, child: button),
    );

    Widget result = isExpanded
        ? SizedBox(width: double.infinity, child: padded)
        : padded;

    if (tooltip != null) {
      result = Tooltip(message: tooltip!, child: result);
    }

    if (isLoading) {
      // A busy button is no longer actionable, so the button role is dropped
      // and the pending state is announced instead.
      result = Semantics(
        label: semanticLabel ?? label,
        liveRegion: true,
        excludeSemantics: true,
        child: result,
      );
    }

    return result;
  }

  Widget _buildButton(
    BuildContext context,
    bool isEnabled,
    _AppButtonMetrics metrics,
    Widget content,
  ) {
    final colors = context.colors;
    final radius = BorderRadius.circular(AppRadii.control);

    // A loading or disabled button must not be reachable by touch, not just
    // styled as unavailable.
    final handler = isEnabled ? onPressed : null;

    switch (variant) {
      case AppButtonVariant.primary:
        return _PrimaryButtonSurface(
          isEnabled: isEnabled,
          isDark: context.isDarkMode,
          radius: radius,
          onPressed: handler,
          child: content,
        );
      case AppButtonVariant.secondary:
        return _ButtonSurface(
          decoration: BoxDecoration(
            color: colors.surfaceContainerLow,
            borderRadius: radius,
            border: Border.all(color: colors.outlineVariant),
          ),
          isEnabled: isEnabled,
          radius: radius,
          onPressed: handler,
          child: content,
        );
      case AppButtonVariant.tertiary:
        return _ButtonSurface(
          decoration: BoxDecoration(
            color: Colors.transparent,
            borderRadius: radius,
          ),
          isEnabled: isEnabled,
          radius: radius,
          onPressed: handler,
          child: content,
        );
    }
  }

  Color? _foreground(BuildContext context) {
    final colors = context.colors;
    if (isLoading) {
      return switch (variant) {
        AppButtonVariant.primary => colors.onPrimary,
        AppButtonVariant.secondary => colors.onSurface,
        AppButtonVariant.tertiary => colors.onSurfaceVariant,
      };
    }
    return switch (variant) {
      AppButtonVariant.primary => colors.onPrimary,
      AppButtonVariant.secondary => colors.onSurface,
      AppButtonVariant.tertiary => colors.primary,
    };
  }
}

/// Brand gradient surface used only by the primary CTA.
class _PrimaryButtonSurface extends StatelessWidget {
  const _PrimaryButtonSurface({
    required this.child,
    required this.isEnabled,
    required this.isDark,
    required this.radius,
    required this.onPressed,
  });

  final Widget child;
  final bool isEnabled;
  final bool isDark;
  final BorderRadius radius;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    final gradient = isEnabled ? AppGradients.brand(colors) : null;

    final background = gradient == null
        ? (isDark
              ? colors.onSurface.withValues(alpha: 0.18)
              : colors.onSurface.withValues(alpha: 0.12))
        : null;

    return Semantics(
      button: true,
      enabled: isEnabled,
      child: DecoratedBox(
        decoration: BoxDecoration(
          gradient: gradient,
          color: background,
          borderRadius: radius,
        ),
        child: Material(
          type: MaterialType.transparency,
          child: InkWell(
            onTap: onPressed,
            borderRadius: radius,
            splashColor: colors.onPrimary.withValues(alpha: 0.18),
            highlightColor: colors.onPrimary.withValues(alpha: 0.08),
            child: child,
          ),
        ),
      ),
    );
  }
}

/// Solid surface used by the secondary and tertiary variants.
class _ButtonSurface extends StatelessWidget {
  const _ButtonSurface({
    required this.child,
    required this.decoration,
    required this.isEnabled,
    required this.radius,
    required this.onPressed,
  });

  final Widget child;
  final BoxDecoration decoration;
  final bool isEnabled;
  final BorderRadius radius;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      enabled: isEnabled,
      child: DecoratedBox(
        decoration: decoration,
        child: Material(
          type: MaterialType.transparency,
          child: InkWell(onTap: onPressed, borderRadius: radius, child: child),
        ),
      ),
    );
  }
}

class _ButtonContent extends StatelessWidget {
  const _ButtonContent({
    required this.label,
    required this.style,
    required this.isLoading,
    this.icon,
    this.trailingIcon,
  });

  final String label;
  final TextStyle style;
  final bool isLoading;
  final IconData? icon;
  final IconData? trailingIcon;

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Center(
        child: SizedBox.square(
          dimension: 20,
          child: CircularProgressIndicator(strokeWidth: 2.5),
        ),
      );
    }

    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (icon != null) ...[
          Icon(icon, size: 20, color: style.color),
          const SizedBox(width: AppSpacing.xs),
        ],
        Flexible(
          child: Text(
            label,
            style: style,
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        if (trailingIcon != null) ...[
          const SizedBox(width: AppSpacing.xs),
          Icon(trailingIcon, size: 20, color: style.color),
        ],
      ],
    );
  }
}

class _AppButtonMetrics {
  const _AppButtonMetrics({
    required this.minHeight,
    required this.padding,
    required this.style,
  });

  final double minHeight;
  final EdgeInsetsGeometry padding;
  final TextStyle style;

  static _AppButtonMetrics of(AppButtonSize size) => switch (size) {
    AppButtonSize.small => const _AppButtonMetrics(
      minHeight: AppAccessibility.minTouchTarget,
      padding: EdgeInsets.symmetric(horizontal: AppSpacing.md),
      style: TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        letterSpacing: 0.1,
      ),
    ),
    AppButtonSize.medium => const _AppButtonMetrics(
      minHeight: 52,
      padding: EdgeInsets.symmetric(horizontal: AppSpacing.xl),
      style: TextStyle(
        fontSize: 15,
        fontWeight: FontWeight.w600,
        letterSpacing: 0.1,
      ),
    ),
    AppButtonSize.large => const _AppButtonMetrics(
      minHeight: 56,
      padding: EdgeInsets.symmetric(horizontal: AppSpacing.xl),
      style: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        letterSpacing: 0.1,
      ),
    ),
  };
}

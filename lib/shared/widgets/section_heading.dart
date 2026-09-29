import 'package:flutter/material.dart';

import '../../core/extensions/build_context_theme.dart';
import '../../theme/tokens/app_spacing.dart';

/// A section title with an optional supporting line and trailing action.
///
/// Use this instead of an ad-hoc `Text` + `SizedBox` pair so section rhythm is
/// identical on every screen.
class SectionHeading extends StatelessWidget {
  const SectionHeading({
    required this.title,
    this.subtitle,
    this.trailing,
    this.padding = EdgeInsets.zero,
    super.key,
  });

  final String title;

  /// Secondary line. Omit entirely rather than passing an empty string.
  final String? subtitle;

  /// Optional trailing widget, typically a small text or icon action.
  final Widget? trailing;

  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final textTheme = context.textTheme;

    final heading = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: textTheme.titleMedium?.copyWith(color: colors.onSurface),
        ),
        if (subtitle case final subtitle?) ...[
          const SizedBox(height: AppSpacing.xxs),
          Text(
            subtitle,
            style: textTheme.bodySmall?.copyWith(
              color: colors.onSurfaceVariant,
            ),
          ),
        ],
      ],
    );

    return Padding(
      padding: padding,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(child: heading),
          if (trailing != null) ...[
            const SizedBox(width: AppSpacing.md),
            trailing!,
          ],
        ],
      ),
    );
  }
}

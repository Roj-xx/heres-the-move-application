import 'package:flutter/material.dart';

import '../../core/extensions/build_context_theme.dart';
import '../../theme/tokens/app_spacing.dart';

/// The app's "nothing here yet" state.
///
/// Use this when a list or section is legitimately empty — not as a
/// placeholder while data is still loading (that is [AppLoadingIndicator]) and
/// not as a failure state (that is `AppErrorState`).
class AppEmptyState extends StatelessWidget {
  const AppEmptyState({
    required this.title,
    this.message,
    this.icon,
    this.action,
    this.padding = const EdgeInsets.symmetric(
      horizontal: AppSpacing.xl,
      vertical: AppSpacing.xxl,
    ),
    this.iconColor,
    super.key,
  });

  /// States what is empty, in plain language.
  final String title;

  /// Optional explanation or next step.
  final String? message;

  /// Optional illustration. Keep it simple; the state must still make sense
  /// when the icon is not visible.
  final IconData? icon;

  /// Optional primary follow-up action, usually an [AppButton].
  final Widget? action;

  final EdgeInsetsGeometry padding;

  /// Overrides the icon tint. Defaults to a muted on-surface tone.
  final Color? iconColor;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final textTheme = context.textTheme;

    return Padding(
      padding: padding,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon case final icon?) ...[
            Icon(icon, size: 40, color: iconColor ?? colors.onSurfaceVariant),
            const SizedBox(height: AppSpacing.md),
          ],
          Text(
            title,
            style: textTheme.titleMedium?.copyWith(color: colors.onSurface),
            textAlign: TextAlign.center,
          ),
          if (message case final message?) ...[
            const SizedBox(height: AppSpacing.xs),
            Text(
              message,
              style: textTheme.bodyMedium?.copyWith(
                color: colors.onSurfaceVariant,
              ),
              textAlign: TextAlign.center,
            ),
          ],
          if (action case final action?) ...[
            const SizedBox(height: AppSpacing.xl),
            action,
          ],
        ],
      ),
    );
  }
}

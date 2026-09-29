import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../core/errors/app_exception.dart';
import '../../core/extensions/build_context_theme.dart';
import '../../theme/tokens/app_spacing.dart';
import 'app_button.dart';
import 'app_empty_state.dart';

/// The app's recoverable failure state.
///
/// The alert icon, the title and the retry control together carry the meaning;
/// colour is only a reinforcement, never the sole signal.
class AppErrorState extends StatelessWidget {
  const AppErrorState({
    this.title = 'Something went wrong',
    this.message = 'We couldn’t load this just now. Please try again.',
    this.onRetry,
    this.retryLabel = 'Try again',
    this.exception,
    this.padding = const EdgeInsets.symmetric(
      horizontal: AppSpacing.xl,
      vertical: AppSpacing.xxl,
    ),
    super.key,
  });

  /// What failed, in user-facing language.
  final String title;

  /// What the user can do about it. When [exception] is supplied its message
  /// is used instead.
  final String message;

  /// Called when the user asks to retry. Omit for non-recoverable errors.
  final VoidCallback? onRetry;

  final String retryLabel;

  /// The failure being surfaced, if there is one. Its [AppException.message]
  /// is displayed so screens do not have to re-translate the error.
  final AppException? exception;

  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context) {
    return AppEmptyState(
      title: title,
      message: exception?.message ?? message,
      icon: LucideIcons.triangleAlert,
      iconColor: context.colors.error,
      padding: padding,
      action: onRetry == null
          ? null
          : AppButton(
              label: retryLabel,
              icon: LucideIcons.refreshCw,
              onPressed: onRetry,
            ),
    );
  }
}

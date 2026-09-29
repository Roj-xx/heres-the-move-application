import 'package:flutter/material.dart';

import '../../core/extensions/build_context_theme.dart';
import '../../theme/tokens/app_spacing.dart';

/// The app's loading state.
///
/// Wraps a Material progress indicator with an accessible label so a screen
/// reader announces that work is happening rather than reading a bare
/// indeterminate progress node.
class AppLoadingIndicator extends StatelessWidget {
  const AppLoadingIndicator({
    this.label = 'Loading',
    this.padding = const EdgeInsets.all(AppSpacing.xl),
    this.showLabel = false,
    super.key,
  });

  /// Text announced to assistive technology, and optionally shown on screen.
  final String label;

  final EdgeInsetsGeometry padding;

  /// Whether to also render [label] as visible text.
  final bool showLabel;

  @override
  Widget build(BuildContext context) {
    final indicator = Semantics(
      label: label,
      liveRegion: true,
      value: 'In progress',
      child: const SizedBox.square(
        dimension: 32,
        child: CircularProgressIndicator(strokeWidth: 3),
      ),
    );

    return Padding(
      padding: padding,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          indicator,
          if (showLabel) ...[
            const SizedBox(height: AppSpacing.md),
            Text(
              label,
              style: context.textTheme.bodySmall,
              textAlign: TextAlign.center,
            ),
          ],
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../shared/widgets/app_card.dart';
import '../../../shared/widgets/app_empty_state.dart';
import '../../../shared/widgets/app_error_state.dart';
import '../../../shared/widgets/app_loading_indicator.dart';
import '../../../shared/widgets/section_heading.dart';
import '../../../theme/tokens/app_spacing.dart';

/// Shows the three non-content states every screen will eventually need.
///
/// Nothing here is wired to a provider: these are static demonstrations of the
/// primitives, not live data states.
class StatePreview extends StatelessWidget {
  const StatePreview({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SectionHeading(
          title: 'States',
          subtitle: 'Loading, empty and error, styled once and reused.',
        ),
        const SizedBox(height: AppSpacing.md),
        const AppCard(
          padding: EdgeInsets.symmetric(vertical: AppSpacing.xl),
          child: AppLoadingIndicator(showLabel: true),
        ),
        const SizedBox(height: AppSpacing.md),
        const AppCard(
          child: AppEmptyState(
            title: 'No suggestions yet',
            message: 'A few answers about preferences and this space fills up.',
            icon: LucideIcons.sparkles,
          ),
        ),
        const SizedBox(height: AppSpacing.md),
        AppCard(child: AppErrorState(onRetry: () {})),
      ],
    );
  }
}

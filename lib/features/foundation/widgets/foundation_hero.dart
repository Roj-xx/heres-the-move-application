import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../app/bootstrap.dart';
import '../../../core/extensions/build_context_theme.dart';
import '../../../shared/widgets/app_card.dart';
import '../../../theme/tokens/app_gradients.dart';
import '../../../theme/tokens/app_radii.dart';
import '../../../theme/tokens/app_shadows.dart';
import '../../../theme/tokens/app_spacing.dart';

/// The wordmark panel at the top of the foundation shell.
///
/// This is the shell's one gradient surface. In the product it stands in for
/// the hero moments — Today's Move, Log Period — that later milestones own.
///
/// Everything drawn on top uses `ColorScheme.onPrimary` rather than white, so
/// contrast holds in both modes.
class FoundationHero extends StatelessWidget {
  const FoundationHero({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final textTheme = context.textTheme;
    final onBrand = colors.onPrimary;

    return DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppRadii.panel),
        gradient: AppGradients.brand(colors),
        boxShadow: context.isDarkMode
            ? AppShadows.darkGlow
            : AppShadows.elevated(),
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.xl),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _Wordmark(onBrand: onBrand),
            const SizedBox(height: AppSpacing.lg),
            Text(
              Bootstrap.appName,
              style: textTheme.headlineMedium?.copyWith(
                color: onBrand,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: AppSpacing.xs),
            Text(
              Bootstrap.appTagline,
              style: textTheme.bodyLarge?.copyWith(color: onBrand),
            ),
            const SizedBox(height: AppSpacing.lg),
            AppCard(
              elevation: AppCardElevation.flat,
              backgroundColor: onBrand.withValues(alpha: 0.14),
              padding: const EdgeInsets.all(AppSpacing.md),
              child: Row(
                children: [
                  Icon(LucideIcons.heartHandshake, size: 20, color: onBrand),
                  const SizedBox(width: AppSpacing.sm),
                  Expanded(
                    child: Text(
                      'Milestone 1 · Foundation',
                      style: textTheme.labelMedium?.copyWith(color: onBrand),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// The app's mark. Decorative, so it is hidden from assistive technology —
/// the product name right beside it is the accessible name.
class _Wordmark extends StatelessWidget {
  const _Wordmark({required this.onBrand});

  final Color onBrand;

  @override
  Widget build(BuildContext context) {
    return ExcludeSemantics(
      child: Container(
        width: 56,
        height: 56,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(AppRadii.control),
          color: onBrand.withValues(alpha: 0.16),
          border: Border.all(color: onBrand.withValues(alpha: 0.24)),
        ),
        alignment: Alignment.center,
        child: Icon(LucideIcons.heartHandshake, size: 28, color: onBrand),
      ),
    );
  }
}

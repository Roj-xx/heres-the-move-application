import 'package:flutter/material.dart';

import '../../../core/extensions/build_context_theme.dart';
import '../../../shared/widgets/app_button.dart';
import '../../../shared/widgets/app_card.dart';
import '../../../shared/widgets/app_scaffold.dart';
import '../../../shared/widgets/section_heading.dart';
import '../../../theme/tokens/app_radii.dart';
import '../../../theme/tokens/app_spacing.dart';
import 'widgets/design_system_preview.dart';
import 'widgets/foundation_hero.dart';
import 'widgets/state_preview.dart';

/// The Milestone 1 shell.
///
/// This is deliberately **not** the Home / Today's Move screen. It exists to
/// prove the foundation works — theme, typography, routing, primitives,
/// responsive layout — and to show what each layer looks like before product
/// features are built on top of it.
///
/// There is no cycle data, no XP, no partner data and no moves here, by
/// design.
class FoundationPage extends StatelessWidget {
  const FoundationPage({super.key});

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const FoundationHero(),
          const SizedBox(height: AppSpacing.xxl),
          const _SurfacePreview(),
          const SizedBox(height: AppSpacing.xxl),
          const _ActionPreview(),
          const SizedBox(height: AppSpacing.xxl),
          const DesignSystemPreview(),
          const SizedBox(height: AppSpacing.xxl),
          const StatePreview(),
          const SizedBox(height: AppSpacing.xl),
          Text(
            'No product features are wired up yet. Everything below is the '
            'shared foundation that later milestones build on.',
            style: context.textTheme.bodySmall,
          ),
        ],
      ),
    );
  }
}

/// Shows the warm surface family the app renders on, in whichever mode the
/// device is currently using.
class _SurfacePreview extends StatelessWidget {
  const _SurfacePreview();

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final isDark = context.isDarkMode;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionHeading(
          title: 'Surfaces',
          subtitle: isDark
              ? 'Warm charcoal, never pure black.'
              : 'Warm off-white, never clinical white.',
        ),
        const SizedBox(height: AppSpacing.md),
        AppCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Cards are solid surfaces with a hairline border and a soft, '
                'warm shadow. Gradients stay reserved for primary actions and '
                'hero moments.',
                style: context.textTheme.bodyMedium,
              ),
              const SizedBox(height: AppSpacing.md),
              Wrap(
                spacing: AppSpacing.sm,
                runSpacing: AppSpacing.xs,
                children: [
                  _SurfaceChip(
                    label: 'Surface',
                    color: colors.surface,
                    borderColor: colors.outlineVariant,
                  ),
                  _SurfaceChip(
                    label: 'Container low',
                    color: colors.surfaceContainerLow,
                    borderColor: colors.outlineVariant,
                  ),
                  _SurfaceChip(
                    label: 'Container',
                    color: colors.surfaceContainer,
                    borderColor: colors.outlineVariant,
                  ),
                  _SurfaceChip(
                    label: 'Container high',
                    color: colors.surfaceContainerHigh,
                    borderColor: colors.outlineVariant,
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _SurfaceChip extends StatelessWidget {
  const _SurfaceChip({
    required this.label,
    required this.color,
    required this.borderColor,
  });

  final String label;
  final Color color;
  final Color borderColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.sm,
        vertical: AppSpacing.xs,
      ),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(AppRadii.controlSmall),
        border: Border.all(color: borderColor),
      ),
      child: Text(
        label,
        style: context.textTheme.labelSmall?.copyWith(
          color: context.colors.onSurface,
        ),
      ),
    );
  }
}

/// Demonstrates the three button weights. Only one primary per screen.
class _ActionPreview extends StatelessWidget {
  const _ActionPreview();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionHeading(
          title: 'Actions',
          subtitle: 'One primary, everything else quieter.',
        ),
        const SizedBox(height: AppSpacing.md),
        AppButton(
          label: 'Primary action',
          variant: AppButtonVariant.primary,
          size: AppButtonSize.large,
          isExpanded: true,
          onPressed: () {},
        ),
        const SizedBox(height: AppSpacing.sm),
        Row(
          children: [
            Expanded(
              child: AppButton(
                label: 'Secondary',
                variant: AppButtonVariant.secondary,
                onPressed: () {},
              ),
            ),
            const SizedBox(width: AppSpacing.sm),
            Expanded(
              child: AppButton(
                label: 'Disabled',
                variant: AppButtonVariant.secondary,
                onPressed: null,
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.xs),
        AppButton(
          label: 'Tertiary action',
          variant: AppButtonVariant.tertiary,
          size: AppButtonSize.small,
          onPressed: () {},
        ),
      ],
    );
  }
}

import 'package:flutter/material.dart';

import '../../../core/extensions/build_context_theme.dart';
import '../../../shared/widgets/app_card.dart';
import '../../../shared/widgets/section_heading.dart';
import '../../../theme/tokens/app_palette.dart';
import '../../../theme/tokens/app_radii.dart';
import '../../../theme/tokens/app_spacing.dart';
import '../../../theme/tokens/app_typography.dart';

/// A visual read-out of the design tokens.
///
/// Reads straight from the token classes rather than from the active theme, so
/// it shows the full system in both light and dark mode.
class DesignSystemPreview extends StatelessWidget {
  const DesignSystemPreview({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SectionHeading(
          title: 'Design system',
          subtitle: 'Every value below comes from theme/tokens.',
        ),
        const SizedBox(height: AppSpacing.md),
        AppCard(child: _RampPreview()),
        const SizedBox(height: AppSpacing.md),
        AppCard(child: _TypeScalePreview()),
        const SizedBox(height: AppSpacing.md),
        AppCard(child: _ShapePreview()),
      ],
    );
  }
}

class _RampPreview extends StatelessWidget {
  const _RampPreview();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Colour ramps', style: context.textTheme.titleSmall),
        const SizedBox(height: AppSpacing.sm),
        _Ramp(
          label: 'Coral · primary',
          swatches: const [
            (AppPalette.coral900, '900'),
            (AppPalette.coral800, '800'),
            (AppPalette.coral600, '600'),
            (AppPalette.coral500, '500'),
            (AppPalette.coral400, '400'),
            (AppPalette.coral200, '200'),
          ],
        ),
        const SizedBox(height: AppSpacing.sm),
        _Ramp(
          label: 'Gold · reward',
          swatches: const [
            (AppPalette.gold700, '700'),
            (AppPalette.gold600, '600'),
            (AppPalette.gold500, '500'),
            (AppPalette.gold400, '400'),
            (AppPalette.gold300, '300'),
            (AppPalette.gold200, '200'),
          ],
        ),
        const SizedBox(height: AppSpacing.sm),
        _Ramp(
          label: 'Warm surfaces · light',
          swatches: const [
            (AppPalette.neutral0, '0'),
            (AppPalette.neutral50, '50'),
            (AppPalette.neutral150, '150'),
            (AppPalette.neutral300, '300'),
            (AppPalette.neutral500, '500'),
          ],
        ),
        const SizedBox(height: AppSpacing.sm),
        _Ramp(
          label: 'Charcoal · dark',
          swatches: const [
            (AppPalette.charcoal950, '950'),
            (AppPalette.charcoal900, '900'),
            (AppPalette.charcoal800, '800'),
            (AppPalette.charcoal600, '600'),
            (AppPalette.charcoal300, '300'),
          ],
        ),
      ],
    );
  }
}

class _Ramp extends StatelessWidget {
  const _Ramp({required this.label, required this.swatches});

  final String label;
  final List<(Color, String)> swatches;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: context.textTheme.labelSmall?.copyWith(
            color: context.colors.onSurfaceVariant,
          ),
        ),
        const SizedBox(height: AppSpacing.xxs),
        Row(
          children: [
            for (final (color, name) in swatches)
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(right: AppSpacing.xs),
                  child: Tooltip(
                    message: '$label $name',
                    child: Semantics(
                      label: '$label, step $name',
                      child: Container(
                        height: 28,
                        decoration: BoxDecoration(
                          color: color,
                          borderRadius: BorderRadius.circular(
                            AppRadii.controlSmall,
                          ),
                          border: Border.all(
                            color: context.colors.outlineVariant,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ],
    );
  }
}

class _TypeScalePreview extends StatelessWidget {
  const _TypeScalePreview();

  @override
  Widget build(BuildContext context) {
    final textTheme = context.textTheme;
    final sample = 'Show up for her';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Type scale · ${AppTypography.fontFamily}',
          style: context.textTheme.titleSmall,
        ),
        const SizedBox(height: AppSpacing.sm),
        _TypeRow(label: 'Display', style: textTheme.displaySmall, text: sample),
        _TypeRow(
          label: 'Headline',
          style: textTheme.headlineSmall,
          text: sample,
        ),
        _TypeRow(label: 'Title', style: textTheme.titleLarge, text: sample),
        _TypeRow(label: 'Body', style: textTheme.bodyLarge, text: sample),
        _TypeRow(label: 'Label', style: textTheme.labelMedium, text: sample),
      ],
    );
  }
}

class _TypeRow extends StatelessWidget {
  const _TypeRow({
    required this.label,
    required this.style,
    required this.text,
  });

  final String label;
  final TextStyle? style;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.sm),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 68,
            child: Text(
              label,
              style: context.textTheme.labelSmall?.copyWith(
                color: context.colors.onSurfaceVariant,
              ),
            ),
          ),
          Expanded(
            child: Text(
              text,
              style: style,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}

class _ShapePreview extends StatelessWidget {
  const _ShapePreview();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Shape & spacing', style: context.textTheme.titleSmall),
        const SizedBox(height: AppSpacing.sm),
        Row(
          children: [
            _ShapeTile(label: 'Control', radius: AppRadii.control),
            const SizedBox(width: AppSpacing.sm),
            _ShapeTile(label: 'Card', radius: AppRadii.card),
            const SizedBox(width: AppSpacing.sm),
            _ShapeTile(label: 'Panel', radius: AppRadii.panel),
          ],
        ),
        const SizedBox(height: AppSpacing.md),
        Row(
          children: [
            Text('Scale', style: context.textTheme.labelSmall),
            const SizedBox(width: AppSpacing.sm),
            for (final token in _spacingSteps)
              Padding(
                padding: const EdgeInsets.only(right: AppSpacing.xs),
                child: Tooltip(
                  message: 'AppSpacing.${token.$1} = ${token.$2}',
                  child: Container(
                    width: token.$2,
                    height: 20,
                    decoration: BoxDecoration(
                      color: context.colors.primary.withValues(alpha: 0.24),
                      borderRadius: BorderRadius.circular(
                        AppRadii.controlSmall,
                      ),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ],
    );
  }

  static const List<(String, double)> _spacingSteps = [
    ('md', AppSpacing.md),
    ('lg', AppSpacing.lg),
    ('xl', AppSpacing.xl),
    ('xxl', AppSpacing.xxl),
  ];
}

class _ShapeTile extends StatelessWidget {
  const _ShapeTile({required this.label, required this.radius});

  final String label;
  final double radius;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 56,
            decoration: BoxDecoration(
              color: context.colors.surfaceContainerHigh,
              borderRadius: BorderRadius.circular(radius),
              border: Border.all(color: context.colors.outlineVariant),
            ),
          ),
          const SizedBox(height: AppSpacing.xxs),
          Text(
            label,
            style: context.textTheme.labelSmall?.copyWith(
              color: context.colors.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }
}

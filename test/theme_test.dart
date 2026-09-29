import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:heres_the_move/core/constants/app_constants.dart';
import 'package:heres_the_move/core/errors/app_exception.dart';
import 'package:heres_the_move/core/utils/responsive_layout.dart';
import 'package:heres_the_move/theme/app_theme.dart';
import 'package:heres_the_move/theme/tokens/app_accessibility.dart';
import 'package:heres_the_move/theme/tokens/app_breakpoints.dart';
import 'package:heres_the_move/theme/tokens/app_gradients.dart';
import 'package:heres_the_move/theme/tokens/app_motion.dart';
import 'package:heres_the_move/theme/tokens/app_palette.dart';
import 'package:heres_the_move/theme/tokens/app_radii.dart';
import 'package:heres_the_move/theme/tokens/app_spacing.dart';
import 'package:heres_the_move/theme/tokens/app_typography.dart';

import 'helpers/contrast.dart';

void main() {
  group('AppTheme', () {
    test('creates both a light and a dark Material 3 theme', () {
      expect(AppTheme.light.brightness, Brightness.light);
      expect(AppTheme.dark.brightness, Brightness.dark);
      expect(AppTheme.light.useMaterial3, isTrue);
      expect(AppTheme.dark.useMaterial3, isTrue);
    });

    test('of() returns the theme matching a brightness', () {
      expect(AppTheme.of(Brightness.light), same(AppTheme.light));
      expect(AppTheme.of(Brightness.dark), same(AppTheme.dark));
    });

    test('both themes are fully built', () {
      for (final theme in [AppTheme.light, AppTheme.dark]) {
        expect(theme.textTheme.bodyLarge, isNotNull);
        expect(theme.cardTheme, isNotNull);
        expect(theme.appBarTheme, isNotNull);
        expect(theme.scaffoldBackgroundColor, theme.colorScheme.surface);
      }
    });
  });

  group('typography', () {
    test('Geist is the primary typeface in both themes', () {
      for (final theme in [AppTheme.light, AppTheme.dark]) {
        expect(theme.textTheme.bodyLarge?.fontFamily, AppTypography.fontFamily);
        expect(
          theme.textTheme.titleLarge?.fontFamily,
          AppTypography.fontFamily,
        );
        expect(
          theme.textTheme.labelSmall?.fontFamily,
          AppTypography.fontFamily,
        );
      }
    });

    test('every Material 3 role is defined', () {
      final textTheme = AppTypography.textTheme(color: Colors.black);
      final roles = <TextStyle?>[
        textTheme.displayLarge,
        textTheme.displayMedium,
        textTheme.displaySmall,
        textTheme.headlineLarge,
        textTheme.headlineMedium,
        textTheme.headlineSmall,
        textTheme.titleLarge,
        textTheme.titleMedium,
        textTheme.titleSmall,
        textTheme.bodyLarge,
        textTheme.bodyMedium,
        textTheme.bodySmall,
        textTheme.labelLarge,
        textTheme.labelMedium,
        textTheme.labelSmall,
      ];

      for (final role in roles) {
        expect(role, isNotNull, reason: 'a Material 3 text role is missing');
        expect(role!.fontFamily, AppTypography.fontFamily);
        expect(role.fontSize, greaterThan(0));
        expect(role.height, greaterThan(0));
      }
    });

    test('the scale descends and stays small-screen friendly', () {
      final textTheme = AppTypography.textTheme(color: Colors.black);

      expect(
        textTheme.displaySmall!.fontSize!,
        greaterThan(textTheme.headlineSmall!.fontSize!),
      );
      expect(
        textTheme.headlineSmall!.fontSize!,
        greaterThan(textTheme.titleLarge!.fontSize!),
      );
      expect(
        textTheme.titleLarge!.fontSize!,
        greaterThan(textTheme.bodyLarge!.fontSize!),
      );
      expect(
        textTheme.bodyLarge!.fontSize!,
        greaterThan(textTheme.bodySmall!.fontSize!),
      );
      expect(textTheme.displayLarge!.fontSize, lessThanOrEqualTo(40));
    });
  });

  group('colour roles', () {
    test('light mode uses a warm off-white surface, not pure white', () {
      final surface = AppTheme.light.colorScheme.surface;

      expect(surface, isNot(const Color(0xFFFFFFFF)));
      expect(surface.r, greaterThan(surface.b), reason: 'should read as warm');
    });

    test('dark mode uses a deep charcoal surface, not pure black', () {
      final surface = AppTheme.dark.colorScheme.surface;

      expect(surface, isNot(const Color(0xFF000000)));
      expect(surface.computeLuminance(), inInclusiveRange(0.0, 0.1));
    });

    test('primary is the warm coral brand hue, secondary is gold', () {
      expect(AppTheme.light.colorScheme.primary, AppPalette.coral600);
      expect(AppTheme.dark.colorScheme.primary, AppPalette.coral400);
      expect(AppTheme.light.colorScheme.secondary, AppPalette.gold700);
      expect(AppTheme.dark.colorScheme.secondary, AppPalette.gold400);
    });

    test('the surface ramp is ordered in both modes', () {
      for (final theme in [AppTheme.light, AppTheme.dark]) {
        final colors = theme.colorScheme;
        // Material 3's documented emphasis order, least to most emphasis.
        final luminances = [
          colors.surfaceContainerLowest,
          colors.surface,
          colors.surfaceContainerLow,
          colors.surfaceContainer,
          colors.surfaceContainerHigh,
          colors.surfaceContainerHighest,
        ].map((c) => c.computeLuminance()).toList();

        for (var i = 1; i < luminances.length; i++) {
          if (theme.brightness == Brightness.light) {
            expect(
              luminances[i],
              lessThan(luminances[i - 1]),
              reason: 'container $i should be darker than ${i - 1}',
            );
          } else {
            expect(
              luminances[i],
              greaterThan(luminances[i - 1]),
              reason: 'container $i should be lighter than ${i - 1}',
            );
          }
        }
      }
    });
  });

  group('contrast', () {
    test('body text meets AA on every surface in both modes', () {
      for (final theme in [AppTheme.light, AppTheme.dark]) {
        final colors = theme.colorScheme;
        for (final background in [
          colors.surface,
          colors.surfaceContainerLow,
          colors.surfaceContainerHigh,
        ]) {
          expect(
            contrastRatio(colors.onSurface, background),
            greaterThanOrEqualTo(aaBodyContrast),
          );
          expect(
            contrastRatio(colors.onSurfaceVariant, background),
            greaterThanOrEqualTo(aaBodyContrast),
          );
        }
      }
    });

    test('labels meet AA on the primary and error surfaces', () {
      for (final theme in [AppTheme.light, AppTheme.dark]) {
        expect(
          contrastRatio(theme.colorScheme.onPrimary, theme.colorScheme.primary),
          greaterThanOrEqualTo(aaBodyContrast),
        );
        expect(
          contrastRatio(theme.colorScheme.onError, theme.colorScheme.error),
          greaterThanOrEqualTo(aaBodyContrast),
        );
      }
    });

    test('the brand gradient keeps onPrimary readable on both stops', () {
      for (final theme in [AppTheme.light, AppTheme.dark]) {
        for (final stop in AppGradients.brand(theme.colorScheme).colors) {
          expect(
            contrastRatio(theme.colorScheme.onPrimary, stop),
            greaterThanOrEqualTo(aaBodyContrast),
            reason: 'onPrimary on $stop in ${theme.brightness}',
          );
        }
      }
    });
  });

  group('AppSpacing', () {
    test('is the documented 4pt-based scale', () {
      expect(
        <double>[
          AppSpacing.xxs,
          AppSpacing.xs,
          AppSpacing.sm,
          AppSpacing.md,
          AppSpacing.lg,
          AppSpacing.xl,
          AppSpacing.xxl,
          AppSpacing.xxxl,
          AppSpacing.huge,
        ],
        <double>[4, 8, 12, 16, 20, 24, 32, 40, 48],
      );
    });

    test('gutter tokens come from the scale', () {
      expect(AppSpacing.pageGutter, AppSpacing.lg);
      expect(AppSpacing.pageGutterWide, AppSpacing.xxl);
    });
  });

  group('AppRadii', () {
    test('covers small controls through large panels', () {
      expect(AppRadii.controlSmall, inInclusiveRange(10, 12));
      expect(AppRadii.control, inInclusiveRange(10, 12));
      expect(AppRadii.card, inInclusiveRange(16, 20));
      expect(AppRadii.cardLarge, inInclusiveRange(16, 20));
      expect(AppRadii.panel, 24);
    });

    test('is not pill-shaped by default', () {
      expect(AppRadii.control, lessThan(50));
      expect(AppRadii.card, lessThan(50));
      expect(AppRadii.panel, lessThan(50));
    });
  });

  group('AppBreakpoints', () {
    test('are ordered and the phone target sits below medium', () {
      expect(
        AppBreakpoints.mediumMaxWidth,
        greaterThan(AppBreakpoints.mediumMinWidth),
      );
      for (final width in [375.0, 390.0, 412.0, 430.0]) {
        expect(width, lessThan(AppBreakpoints.mediumMinWidth));
      }
    });

    test('caps the content column', () {
      expect(AppBreakpoints.maxContentWidth, greaterThan(430));
      expect(AppBreakpoints.maxContentWidth, lessThan(720));
    });
  });

  group('AppMotion', () {
    test('durations increase and stay short', () {
      expect(AppMotion.instant, lessThan(AppMotion.fast));
      expect(AppMotion.fast, lessThan(AppMotion.standard));
      expect(AppMotion.standard, lessThan(AppMotion.slow));
      expect(AppMotion.slow, lessThanOrEqualTo(const Duration(seconds: 1)));
    });
  });

  group('AppGradients', () {
    test('produces two distinct stops derived from the primary', () {
      for (final theme in [AppTheme.light, AppTheme.dark]) {
        final gradient = AppGradients.brand(theme.colorScheme);

        expect(gradient.colors, hasLength(2));
        expect(gradient.colors.first, theme.colorScheme.primary);
        expect(gradient.colors.last, isNot(gradient.colors.first));
      }
    });
  });

  group('AppAccessibility', () {
    test('the minimum touch target is at least 48pt', () {
      expect(AppAccessibility.minTouchTarget, greaterThanOrEqualTo(48));
    });
  });

  group('AppConstants', () {
    test('exposes the product name and tagline', () {
      expect(AppConstants.appName, 'Here’s the Move');
      expect(AppConstants.appTagline, isNotEmpty);
    });
  });

  group('AppException', () {
    test('keeps a user-safe message separate from the cause', () {
      final cause = StateError('socket closed');
      final exception = AppException.from(
        cause,
        StackTrace.current,
        userMessage: 'We could not reach the server.',
      );

      expect(exception.message, 'We could not reach the server.');
      expect(exception.cause, same(cause));
      expect(exception.stackTrace, isNotNull);
      expect(exception.toString(), contains('We could not reach the server.'));
    });
  });

  group('ResponsiveLayout', () {
    test('widens the gutter at the medium breakpoint', () {
      expect(ResponsiveLayout.pageGutter(390), AppSpacing.pageGutter);
      expect(ResponsiveLayout.pageGutter(900), AppSpacing.pageGutterWide);
    });

    test('caps the content column on wide viewports', () {
      expect(ResponsiveLayout.contentWidth(390), 390);
      expect(
        ResponsiveLayout.contentWidth(1400),
        AppBreakpoints.maxContentWidth,
      );
    });

    test('classifies the phone-first viewport as compact', () {
      expect(ResponsiveLayout.isCompact(430), isTrue);
      expect(ResponsiveLayout.isMediumOrWider(430), isFalse);
      expect(ResponsiveLayout.isMediumOrWider(1024), isTrue);
    });
  });
}

import 'package:flutter/material.dart';

import 'tokens/app_accessibility.dart';
import 'tokens/app_palette.dart';
import 'tokens/app_radii.dart';
import 'tokens/app_shadows.dart';
import 'tokens/app_spacing.dart';
import 'tokens/app_typography.dart';

/// The Here's the Move design system.
///
/// Exposes exactly two themes — [light] and [dark] — built from the same
/// tokens so both modes feel like one product rather than two designs.
///
/// Widgets never build their own colours or type; they read roles from the
/// ambient `ThemeData` (`context.colors`, `context.textTheme`).
abstract final class AppTheme {
  /// The warm off-white theme.
  static final ThemeData light = _build(Brightness.light);

  /// The warm charcoal theme.
  static final ThemeData dark = _build(Brightness.dark);

  /// Returns the theme matching [brightness].
  static ThemeData of(Brightness brightness) =>
      brightness == Brightness.dark ? dark : light;

  static ThemeData _build(Brightness brightness) {
    final colorScheme = _colorScheme(brightness);
    final textTheme = AppTypography.textTheme(color: colorScheme.onSurface);

    return ThemeData(
      useMaterial3: true,
      brightness: brightness,
      colorScheme: colorScheme,
      textTheme: textTheme,
      scaffoldBackgroundColor: colorScheme.surface,
      splashFactory: InkSparkle.splashFactory,
      visualDensity: VisualDensity.standard,
      appBarTheme: AppBarTheme(
        backgroundColor: colorScheme.surface,
        foregroundColor: colorScheme.onSurface,
        surfaceTintColor: Colors.transparent,
        scrolledUnderElevation: 0,
        centerTitle: false,
        elevation: 0,
        titleTextStyle: textTheme.titleLarge?.copyWith(
          color: colorScheme.onSurface,
        ),
      ),
      cardTheme: CardThemeData(
        color: colorScheme.surfaceContainerLow,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadii.card),
        ),
      ),
      dividerTheme: DividerThemeData(
        color: colorScheme.outlineVariant,
        thickness: 1,
        space: AppSpacing.xl,
      ),
      dialogTheme: DialogThemeData(
        backgroundColor: colorScheme.surfaceContainerLow,
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadii.panel),
        ),
        titleTextStyle: textTheme.titleLarge,
        contentTextStyle: textTheme.bodyMedium,
      ),
      bottomSheetTheme: BottomSheetThemeData(
        backgroundColor: colorScheme.surfaceContainerLow,
        surfaceTintColor: Colors.transparent,
        modalBarrierColor: Colors.black.withValues(alpha: 0.45),
        showDragHandle: true,
        dragHandleColor: colorScheme.outline,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(AppRadii.panel),
          ),
        ),
      ),
      snackBarTheme: SnackBarThemeData(
        backgroundColor: colorScheme.inverseSurface,
        contentTextStyle: textTheme.bodyMedium?.copyWith(
          color: colorScheme.onInverseSurface,
        ),
        actionTextColor: colorScheme.inversePrimary,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadii.control),
        ),
      ),
      progressIndicatorTheme: ProgressIndicatorThemeData(
        color: colorScheme.primary,
        linearTrackColor: colorScheme.surfaceContainerHighest,
        circularTrackColor: colorScheme.surfaceContainerHighest,
        strokeWidth: 3,
      ),
      iconTheme: IconThemeData(color: colorScheme.onSurfaceVariant, size: 24),
      listTileTheme: ListTileThemeData(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadii.control),
        ),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          minimumSize: const Size(64, AppAccessibility.minTouchTarget),
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xl),
          textStyle: textTheme.labelLarge,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppRadii.control),
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          minimumSize: const Size(64, AppAccessibility.minTouchTarget),
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xl),
          textStyle: textTheme.labelLarge,
          side: BorderSide(color: colorScheme.outline),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppRadii.control),
          ),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          minimumSize: const Size(64, AppAccessibility.minTouchTarget),
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
          textStyle: textTheme.labelLarge,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppRadii.control),
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: colorScheme.surfaceContainerLow,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: AppSpacing.md,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadii.control),
          borderSide: BorderSide(color: colorScheme.outlineVariant),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadii.control),
          borderSide: BorderSide(color: colorScheme.outlineVariant),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadii.control),
          borderSide: BorderSide(color: colorScheme.primary, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadii.control),
          borderSide: BorderSide(color: colorScheme.error),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadii.control),
          borderSide: BorderSide(color: colorScheme.error, width: 2),
        ),
      ),
      tooltipTheme: TooltipThemeData(
        textStyle: textTheme.bodySmall?.copyWith(
          color: colorScheme.onInverseSurface,
        ),
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.sm,
          vertical: AppSpacing.xs,
        ),
        decoration: BoxDecoration(
          color: colorScheme.inverseSurface,
          borderRadius: BorderRadius.circular(AppRadii.controlSmall),
        ),
      ),
    );
  }

  /// Builds the Material 3 `ColorScheme` for [brightness].
  ///
  /// Starts from [ColorScheme.fromSeed] so every un-overridden role stays
  /// tonally coherent, then pins the brand roles: coral primary, gold
  /// secondary, clay tertiary, and a consistently warm neutral surface ramp.
  static ColorScheme _colorScheme(Brightness brightness) {
    final isDark = brightness == Brightness.dark;

    return ColorScheme.fromSeed(
      seedColor: AppPalette.coral500,
      brightness: brightness,
    ).copyWith(
      // Primary — warm coral.
      primary: isDark ? AppPalette.coral400 : AppPalette.coral600,
      onPrimary: isDark ? AppPalette.coral900 : AppPalette.neutral0,
      primaryContainer: isDark ? AppPalette.coral800 : AppPalette.coral200,
      onPrimaryContainer: isDark ? AppPalette.coral200 : AppPalette.coral900,
      inversePrimary: isDark ? AppPalette.coral600 : AppPalette.coral400,

      // Secondary — gold. Reward/XP only, never a primary action.
      secondary: isDark ? AppPalette.gold400 : AppPalette.gold700,
      onSecondary: isDark ? AppPalette.clay900 : AppPalette.neutral0,
      secondaryContainer: isDark ? AppPalette.gold600 : AppPalette.gold200,
      onSecondaryContainer: isDark ? AppPalette.gold200 : AppPalette.clay900,

      // Tertiary — warm clay, used sparingly for supporting surfaces.
      tertiary: isDark ? AppPalette.clay400 : AppPalette.clay600,
      onTertiary: isDark ? AppPalette.clay900 : AppPalette.neutral0,
      tertiaryContainer: isDark ? AppPalette.clay800 : AppPalette.clay200,
      onTertiaryContainer: isDark ? AppPalette.clay200 : AppPalette.clay900,

      // Status — deeper red than the brand coral so alerts do not read as
      // brand accents. Always accompanied by an icon and a text label.
      error: isDark ? AppPalette.danger400 : AppPalette.danger600,
      onError: isDark ? AppPalette.danger900 : AppPalette.neutral0,
      errorContainer: isDark ? AppPalette.danger800 : AppPalette.danger200,
      onErrorContainer: isDark ? AppPalette.danger200 : AppPalette.danger900,

      // Warm neutral surfaces. Charcoal, never pure black, in dark mode.
      surface: isDark ? AppPalette.charcoal900 : AppPalette.neutral50,
      onSurface: isDark ? AppPalette.charcoal100 : AppPalette.charcoal900,
      surfaceContainerLowest: isDark
          ? AppPalette.charcoal950
          : AppPalette.neutral0,
      surfaceContainerLow: isDark
          ? AppPalette.charcoal850
          : AppPalette.neutral100,
      surfaceContainer: isDark ? AppPalette.charcoal800 : AppPalette.neutral150,
      surfaceContainerHigh: isDark
          ? AppPalette.charcoal700
          : AppPalette.neutral200,
      surfaceContainerHighest: isDark
          ? AppPalette.charcoal600
          : AppPalette.neutral300,
      onSurfaceVariant: isDark ? AppPalette.charcoal300 : AppPalette.neutral800,
      surfaceTint: Colors.transparent,

      // Outlines.
      outline: isDark ? AppPalette.charcoal400 : AppPalette.neutral500,
      outlineVariant: isDark ? AppPalette.charcoal600 : AppPalette.neutral300,
      inverseSurface: isDark ? AppPalette.charcoal100 : AppPalette.charcoal800,
      onInverseSurface: isDark ? AppPalette.charcoal900 : AppPalette.neutral50,
      shadow: isDark ? AppShadows.darkShadow : AppShadows.lightShadow,
      scrim: isDark ? AppPalette.charcoal950 : AppPalette.charcoal900,
    );
  }
}

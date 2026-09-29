import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:heres_the_move/app/app.dart';
import 'package:heres_the_move/app/bootstrap.dart';
import 'package:heres_the_move/features/foundation/foundation_page.dart';
import 'package:heres_the_move/router/app_router.dart';
import 'package:heres_the_move/router/route_paths.dart';
import 'package:heres_the_move/theme/app_theme.dart';
import 'package:heres_the_move/theme/app_theme_mode.dart';
import 'package:heres_the_move/theme/tokens/app_breakpoints.dart';

import 'helpers/pump_app.dart';

class _FixedThemeMode extends AppThemeModeController {
  _FixedThemeMode(this.mode);

  final ThemeMode mode;

  @override
  ThemeMode build() => mode;
}

/// go_router normalises the root location to an empty path.
String _pathOf(GoRouter router) {
  final path = router.routerDelegate.currentConfiguration.uri.path;
  return path.isEmpty ? '/' : path;
}

ProviderContainer _container() {
  final container = ProviderContainer();
  addTearDown(container.dispose);
  return container;
}

void main() {
  group('application root', () {
    testWidgets('builds without error', (tester) async {
      await pumpHereIsTheMoveApp(tester);

      expect(find.byType(HereIsTheMoveApp), findsOneWidget);
      expect(tester.takeException(), isNull);
    });

    testWidgets('is a Riverpod app driven by MaterialApp.router', (
      tester,
    ) async {
      await pumpHereIsTheMoveApp(tester);

      final app = tester.widget<MaterialApp>(find.byType(MaterialApp));

      expect(app.routerConfig, isNotNull);
      expect(app.theme, isNotNull);
      expect(app.darkTheme, isNotNull);
      expect(app.title, Bootstrap.appName);
    });

    testWidgets('follows the system theme mode by default', (tester) async {
      final container = _container();

      expect(container.read(appThemeModeProvider), ThemeMode.system);
    });

    testWidgets('honours a centrally configured theme mode', (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            appThemeModeProvider.overrideWith(
              () => _FixedThemeMode(ThemeMode.dark),
            ),
          ],
          child: const HereIsTheMoveApp(),
        ),
      );
      await pumpFrames(tester);

      expect(
        Theme.of(tester.element(find.byType(FoundationPage))).brightness,
        Brightness.dark,
      );
    });

    test('the theme mode controller can be driven programmatically', () {
      final container = _container();
      final controller = container.read(appThemeModeProvider.notifier);

      controller.setThemeMode(ThemeMode.light);
      expect(container.read(appThemeModeProvider), ThemeMode.light);

      controller.setThemeMode(ThemeMode.dark);
      expect(container.read(appThemeModeProvider), ThemeMode.dark);
    });
  });

  group('routing', () {
    test('the foundation shell is the app entry point', () {
      expect(AppRoutePaths.foundation, '/');
      expect(AppRouteNames.foundation, isNotEmpty);
    });

    testWidgets('resolves the initial location to the foundation route', (
      tester,
    ) async {
      final router = _container().read(appRouterProvider);
      addTearDown(router.dispose);

      router.goNamed(AppRouteNames.foundation);
      await pumpFrames(tester);

      expect(_pathOf(router), AppRoutePaths.foundation);
    });

    testWidgets('renders the foundation shell at the initial location', (
      tester,
    ) async {
      final router = _container().read(appRouterProvider);
      addTearDown(router.dispose);

      await tester.pumpWidget(MaterialApp.router(routerConfig: router));
      await pumpFrames(tester);

      expect(find.byType(FoundationPage), findsOneWidget);
    });

    testWidgets('degrades an unrouted location to a real page', (tester) async {
      final router = _container().read(appRouterProvider);
      addTearDown(router.dispose);
      router.go('/definitely-not-a-route');

      await tester.pumpWidget(MaterialApp.router(routerConfig: router));
      await pumpFrames(tester);

      expect(find.text('This page does not exist'), findsOneWidget);
      expect(tester.takeException(), isNull);
    });

    testWidgets('recovers from an unrouted location back to the shell', (
      tester,
    ) async {
      final router = _container().read(appRouterProvider);
      addTearDown(router.dispose);
      router.go('/definitely-not-a-route');

      await tester.pumpWidget(MaterialApp.router(routerConfig: router));
      await pumpFrames(tester);

      await tester.tap(find.text('Back to the start'));
      await pumpFrames(tester);

      expect(find.byType(FoundationPage), findsOneWidget);
    });
  });

  group('foundation shell', () {
    testWidgets('renders the product name and tagline', (tester) async {
      await pumpAtSize(tester, phoneSize);
      await pumpInApp(tester, const FoundationPage());

      expect(find.text(Bootstrap.appName), findsWidgets);
      expect(find.text(Bootstrap.appTagline), findsOneWidget);
    });

    testWidgets('shows the design system', (tester) async {
      await pumpAtSize(tester, phoneSize);
      await pumpInApp(tester, const FoundationPage());

      expect(find.text('Design system'), findsOneWidget);
      expect(find.text('States'), findsOneWidget);
      expect(find.text('Surfaces'), findsOneWidget);
      expect(find.text('Actions'), findsOneWidget);
    });

    testWidgets('does not fake cycle, XP, partner or move data', (
      tester,
    ) async {
      await pumpAtSize(tester, phoneSize);
      await pumpInApp(tester, const FoundationPage());

      for (final forbidden in const [
        'Fertile',
        'Period',
        'Level',
        'XP',
        'Streak',
        'Partner',
        'Mission',
      ]) {
        expect(
          find.textContaining(forbidden, findRichText: true),
          findsNothing,
          reason: 'the shell must not invent "$forbidden" data',
        );
      }
    });

    testWidgets('renders in dark mode', (tester) async {
      await pumpAtSize(tester, phoneSize);
      await pumpInApp(
        tester,
        const FoundationPage(),
        brightness: Brightness.dark,
      );

      expect(tester.takeException(), isNull);
      expect(find.text(Bootstrap.appName), findsWidgets);
    });

    testWidgets('stays within the readable column on a tablet width', (
      tester,
    ) async {
      await pumpAtSize(tester, const Size(1024, 1366));
      await pumpInApp(tester, const FoundationPage());

      final tagline = tester.getRect(find.text(Bootstrap.appTagline));

      expect(tagline.width, lessThanOrEqualTo(AppBreakpoints.maxContentWidth));
    });

    testWidgets('scrolls on a short screen with large text', (tester) async {
      await pumpAtSize(tester, const Size(320, 480));

      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.light,
          home: MediaQuery(
            data: const MediaQueryData(textScaler: TextScaler.linear(1.5)),
            child: const FoundationPage(),
          ),
        ),
      );
      await tester.pump();

      expect(tester.takeException(), isNull);

      await tester.drag(
        find.byType(SingleChildScrollView),
        const Offset(0, -600),
      );
      await tester.pump();

      expect(tester.takeException(), isNull);
    });
  });
}

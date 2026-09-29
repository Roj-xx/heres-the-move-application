import 'package:flutter/material.dart';
import 'package:flutter/semantics.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:heres_the_move/core/errors/app_exception.dart';
import 'package:heres_the_move/shared/widgets/app_button.dart';
import 'package:heres_the_move/shared/widgets/app_card.dart';
import 'package:heres_the_move/shared/widgets/app_empty_state.dart';
import 'package:heres_the_move/shared/widgets/app_error_state.dart';
import 'package:heres_the_move/shared/widgets/app_loading_indicator.dart';
import 'package:heres_the_move/shared/widgets/app_scaffold.dart';
import 'package:heres_the_move/shared/widgets/section_heading.dart';
import 'package:heres_the_move/theme/tokens/app_accessibility.dart';
import 'package:heres_the_move/theme/tokens/app_breakpoints.dart';
import 'package:heres_the_move/theme/tokens/app_spacing.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import 'helpers/pump_app.dart';

/// The width-capped column `AppScaffold` centres its child in.
final _contentColumn = find
    .descendant(
      of: find.byType(SingleChildScrollView),
      matching: find.byType(ConstrainedBox),
    )
    .first;

EdgeInsets _pagePadding(WidgetTester tester) {
  final scroll = tester.widget<SingleChildScrollView>(
    find.byType(SingleChildScrollView),
  );
  return scroll.padding! as EdgeInsets;
}

void main() {
  group('AppButton', () {
    testWidgets('renders its label and fires onPressed', (tester) async {
      var taps = 0;
      await pumpInApp(
        tester,
        AppButton(label: 'Show up for her', onPressed: () => taps++),
      );

      expect(find.text('Show up for her'), findsOneWidget);

      await tester.tap(find.text('Show up for her'));
      await tester.pump();

      expect(taps, 1);
    });

    testWidgets('does not fire when disabled or loading', (tester) async {
      var taps = 0;

      await pumpInApp(tester, AppButton(label: 'Disabled', onPressed: null));
      await tester.tap(find.text('Disabled'));
      await tester.pump();
      expect(taps, 0, reason: 'a disabled button must not be reachable');

      await pumpInApp(
        tester,
        AppButton(label: 'Saving', isLoading: true, onPressed: () => taps++),
      );
      await tester.tap(find.byType(AppButton));
      await tester.pump();
      expect(taps, 0, reason: 'a loading button must not be reachable');
    });

    testWidgets('meets the minimum touch target in every size', (tester) async {
      for (final size in AppButtonSize.values) {
        await pumpInApp(
          tester,
          AppButton(label: 'Tap me', size: size, onPressed: () {}),
        );

        expect(
          tester.getSize(find.byType(AppButton)).height,
          greaterThanOrEqualTo(AppAccessibility.minTouchTarget),
          reason: 'AppButtonSize.$size is too short to tap comfortably',
        );
      }
    });

    testWidgets('stretches to the full width when expanded', (tester) async {
      await pumpAtSize(tester, phoneSize);
      var taps = 0;

      await pumpInApp(
        tester,
        AppButton(
          label: 'Full width',
          isExpanded: true,
          onPressed: () => taps++,
        ),
      );

      expect(tester.getSize(find.byType(AppButton)).width, phoneSize.width);

      await tester.tap(find.text('Full width'));
      await tester.pump();
      expect(taps, 1);
    });

    testWidgets('renders an icon alongside the label', (tester) async {
      await pumpInApp(
        tester,
        AppButton(
          label: 'Continue',
          icon: Icons.arrow_forward,
          onPressed: () {},
        ),
      );

      expect(find.byIcon(Icons.arrow_forward), findsOneWidget);
      expect(find.text('Continue'), findsOneWidget);
    });

    testWidgets('replaces the label with progress while loading', (
      tester,
    ) async {
      await pumpInApp(
        tester,
        AppButton(label: 'Saving', isLoading: true, onPressed: () {}),
      );

      expect(find.text('Saving'), findsNothing);
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('exposes an accessible name and a button role', (tester) async {
      final handle = tester.ensureSemantics();

      await pumpInApp(
        tester,
        AppButton(
          label: '▶',
          semanticLabel: 'Continue to preferences',
          onPressed: () {},
        ),
      );

      expect(find.bySemanticsLabel('Continue to preferences'), findsOneWidget);

      final node = tester.getSemantics(
        find.bySemanticsLabel('Continue to preferences'),
      );
      expect(node.getSemanticsData().flagsCollection.isButton, isTrue);
      expect(node.getSemanticsData().hasAction(SemanticsAction.tap), isTrue);

      handle.dispose();
    });

    testWidgets('renders every variant in light and dark', (tester) async {
      for (final brightness in Brightness.values) {
        for (final variant in AppButtonVariant.values) {
          await pumpInApp(
            tester,
            AppButton(label: 'Action', variant: variant, onPressed: () {}),
            brightness: brightness,
          );

          expect(tester.takeException(), isNull);
          expect(find.text('Action'), findsOneWidget);
        }
      }
    });
  });

  group('AppCard', () {
    testWidgets('renders its child', (tester) async {
      await pumpInApp(tester, const AppCard(child: Text('Card content')));

      expect(find.text('Card content'), findsOneWidget);
    });

    testWidgets('fires onTap when tappable and stays inert when not', (
      tester,
    ) async {
      var taps = 0;

      await pumpInApp(
        tester,
        AppCard(onTap: () => taps++, child: const Text('Tappable card')),
      );
      await tester.tap(find.text('Tappable card'));
      await tester.pump();
      expect(taps, 1);

      await pumpInApp(tester, const AppCard(child: Text('Static card')));
      await tester.tap(find.text('Static card'));
      await tester.pump();
      expect(taps, 1, reason: 'a card without onTap must not be interactive');
      expect(tester.takeException(), isNull);
    });

    testWidgets('carries a button role and hint when tappable', (tester) async {
      final handle = tester.ensureSemantics();

      await pumpInApp(
        tester,
        AppCard(
          onTap: () {},
          semanticLabel: 'Cycle details',
          semanticHint: 'Opens the cycle calendar',
          child: const Text('Day 12'),
        ),
      );

      final semantics = tester.getSemantics(find.byType(AppCard));

      expect(semantics.getSemanticsData().flagsCollection.isButton, isTrue);
      expect(semantics.label, 'Cycle details');
      expect(semantics.hint, 'Opens the cycle calendar');

      handle.dispose();
    });

    testWidgets('renders every elevation without error', (tester) async {
      for (final elevation in AppCardElevation.values) {
        await pumpInApp(
          tester,
          AppCard(elevation: elevation, child: const Text('Card')),
        );

        expect(tester.takeException(), isNull);
      }
    });
  });

  group('AppScaffold', () {
    testWidgets('renders its child and an optional footer', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: AppScaffold(
            footer: const Text('Bottom action'),
            child: const Text('Page body'),
          ),
        ),
      );

      expect(find.text('Page body'), findsOneWidget);
      expect(find.text('Bottom action'), findsOneWidget);
    });

    testWidgets('caps the content column and widens gutters when wide', (
      tester,
    ) async {
      await pumpAtSize(tester, const Size(1400, 900));

      await tester.pumpWidget(
        MaterialApp(home: AppScaffold(child: const Text('Page body'))),
      );

      expect(tester.getSize(find.byType(SingleChildScrollView)).width, 1400);
      expect(
        tester.widget<ConstrainedBox>(_contentColumn).constraints.maxWidth,
        AppBreakpoints.maxContentWidth,
      );
      expect(_pagePadding(tester).left, AppSpacing.pageGutterWide);
    });

    testWidgets('uses the compact gutter on a phone', (tester) async {
      await pumpAtSize(tester, phoneSize);

      await tester.pumpWidget(
        MaterialApp(home: AppScaffold(child: const Text('Page body'))),
      );

      final padding = _pagePadding(tester);
      expect(padding.left, AppSpacing.pageGutter);
      expect(padding.right, AppSpacing.pageGutter);
      expect(padding.left, lessThan(AppBreakpoints.mediumMinWidth));
    });

    testWidgets('scrolls rather than overflowing on a short screen', (
      tester,
    ) async {
      await pumpAtSize(tester, const Size(320, 480));

      await tester.pumpWidget(
        MaterialApp(
          home: AppScaffold(
            child: Column(
              children: List.generate(
                20,
                (index) => SizedBox(height: 60, child: Text('Row $index')),
              ),
            ),
          ),
        ),
      );

      expect(find.text('Row 0'), findsOneWidget);
      expect(tester.takeException(), isNull);

      await tester.drag(
        find.byType(SingleChildScrollView),
        const Offset(0, -400),
      );
      await tester.pump();

      expect(find.text('Row 12'), findsOneWidget);
    });
  });

  group('AppLoadingIndicator', () {
    testWidgets('shows progress and announces itself', (tester) async {
      final handle = tester.ensureSemantics();

      await pumpInApp(tester, const AppLoadingIndicator());

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      expect(find.bySemanticsLabel('Loading'), findsOneWidget);

      handle.dispose();
    });

    testWidgets('renders its label when asked to', (tester) async {
      await pumpInApp(
        tester,
        const AppLoadingIndicator(label: 'Loading your week', showLabel: true),
      );

      expect(find.text('Loading your week'), findsOneWidget);
    });
  });

  group('AppEmptyState', () {
    testWidgets('renders a title, message and action', (tester) async {
      await pumpInApp(
        tester,
        AppEmptyState(
          title: 'No moves yet',
          message: 'Answer a couple of questions to get suggestions.',
          icon: Icons.inbox,
          action: TextButton(
            onPressed: () {},
            child: const Text('Get started'),
          ),
        ),
      );

      expect(find.text('No moves yet'), findsOneWidget);
      expect(
        find.text('Answer a couple of questions to get suggestions.'),
        findsOneWidget,
      );
      expect(find.text('Get started'), findsOneWidget);
    });

    testWidgets('omits the message when there is none', (tester) async {
      await pumpInApp(tester, const AppEmptyState(title: 'Nothing here'));

      expect(find.text('Nothing here'), findsOneWidget);
      expect(tester.takeException(), isNull);
    });
  });

  group('AppErrorState', () {
    testWidgets('shows a default message and retries', (tester) async {
      var retries = 0;
      await pumpInApp(tester, AppErrorState(onRetry: () => retries++));

      expect(find.text('Something went wrong'), findsOneWidget);
      expect(find.text('Try again'), findsOneWidget);

      await tester.tap(find.text('Try again'));
      await tester.pump();

      expect(retries, 1);
    });

    testWidgets('surfaces the message from an AppException', (tester) async {
      await pumpInApp(
        tester,
        AppErrorState(
          exception: const AppException('Your cycle could not be loaded.'),
        ),
      );

      expect(find.text('Your cycle could not be loaded.'), findsOneWidget);
    });

    testWidgets('hides the retry action when it cannot be retried', (
      tester,
    ) async {
      await pumpInApp(tester, const AppErrorState());

      expect(find.text('Try again'), findsNothing);
    });

    testWidgets('conveys failure with an icon and a text label', (
      tester,
    ) async {
      await pumpInApp(tester, AppErrorState(onRetry: () {}));

      // Colour is a reinforcement here; the icon and the label carry meaning.
      expect(find.text('Something went wrong'), findsOneWidget);
      expect(find.byIcon(LucideIcons.triangleAlert), findsOneWidget);
    });
  });

  group('SectionHeading', () {
    testWidgets('renders a title with an optional subtitle', (tester) async {
      await pumpInApp(
        tester,
        const SectionHeading(title: 'Today', subtitle: 'Thursday, 12 June'),
      );

      expect(find.text('Today'), findsOneWidget);
      expect(find.text('Thursday, 12 June'), findsOneWidget);
    });

    testWidgets('renders a trailing action', (tester) async {
      await pumpInApp(
        tester,
        SectionHeading(
          title: 'Today',
          trailing: TextButton(onPressed: () {}, child: const Text('See all')),
        ),
      );

      expect(find.text('See all'), findsOneWidget);
    });
  });
}

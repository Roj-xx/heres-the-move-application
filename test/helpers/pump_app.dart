import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:heres_the_move/app/app.dart';
import 'package:heres_the_move/theme/app_theme.dart';

/// Phone-first surface used across the widget tests.
const Size phoneSize = Size(390, 844);

/// How long to advance after a navigation or theme change.
///
/// The foundation shell deliberately renders an indeterminate progress
/// indicator to demonstrate the loading primitive, so `pumpAndSettle` can
/// never settle against it. Tests advance a bounded number of frames instead.
const Duration settleDuration = Duration(milliseconds: 500);

/// Pins the test surface to a specific logical size and restores it after.
Future<void> pumpAtSize(WidgetTester tester, Size size) async {
  tester.view.physicalSize = size * tester.view.devicePixelRatio;
  addTearDown(tester.view.reset);
}

/// Pumps [child] inside the real app theme so primitives are exercised against
/// the tokens they will ship with, not a bare `MaterialApp`.
Future<void> pumpInApp(
  WidgetTester tester,
  Widget child, {
  Brightness brightness = Brightness.light,
  Size? surfaceSize,
}) async {
  if (surfaceSize != null) {
    await pumpAtSize(tester, surfaceSize);
  }
  await tester.pumpWidget(
    ProviderScope(
      child: MaterialApp(
        theme: AppTheme.of(brightness),
        home: Scaffold(body: child),
      ),
    ),
  );
}

/// Pumps the real application root, exactly as `main()` does.
Future<void> pumpHereIsTheMoveApp(WidgetTester tester) async {
  await tester.pumpWidget(const ProviderScope(child: HereIsTheMoveApp()));
  await pumpFrames(tester);
}

/// Advances past route and theme transitions without waiting for quiescence.
Future<void> pumpFrames(WidgetTester tester) async {
  await tester.pump();
  await tester.pump(settleDuration);
}

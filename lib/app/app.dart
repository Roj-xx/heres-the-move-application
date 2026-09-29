import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../router/app_router.dart';
import '../theme/app_theme.dart';
import '../theme/app_theme_mode.dart';
import '../theme/tokens/app_motion.dart';
import 'bootstrap.dart';

/// The application root.
///
/// Reads the router and the active theme mode from Riverpod and hands them to
/// [MaterialApp.router]. Everything below this widget is routing-driven, which
/// is what lets a later auth milestone redirect between route trees without
/// touching the widget tree.
class HereIsTheMoveApp extends ConsumerWidget {
  const HereIsTheMoveApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(appRouterProvider);
    final themeMode = ref.watch(appThemeModeProvider);

    return MaterialApp.router(
      title: Bootstrap.appName,
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      themeMode: themeMode,
      themeAnimationDuration: AppMotion.standard,
      themeAnimationCurve: AppMotion.curveEmphasized,
      routerConfig: router,
    );
  }
}

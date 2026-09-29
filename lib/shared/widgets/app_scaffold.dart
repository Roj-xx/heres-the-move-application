import 'package:flutter/material.dart';

import '../../core/utils/responsive_layout.dart';
import '../../theme/tokens/app_breakpoints.dart';
import '../../theme/tokens/app_spacing.dart';

/// The standard page surface for every screen in the app.
///
/// Provides the things every page needs and that are easy to get subtly wrong:
///
/// * safe-area handling,
/// * a single scrolling surface so dynamic text cannot overflow,
/// * a centred content column capped at [AppBreakpoints.maxContentWidth] so
///   text stays readable on larger screens,
/// * responsive gutters that widen past the medium breakpoint.
///
/// Screens pass their own content; this widget does not know what a screen is.
class AppScaffold extends StatelessWidget {
  const AppScaffold({
    required this.child,
    this.appBar,
    this.footer,
    this.useSafeArea = true,
    this.bottomInset = AppSpacing.xl,
    this.maxContentWidth = AppBreakpoints.maxContentWidth,
    super.key,
  });

  /// The page body. Usually a `Column` or a list of sections.
  final Widget child;

  /// Optional app bar. Omit for pages that supply their own header.
  final PreferredSizeWidget? appBar;

  /// Optional pinned footer, e.g. a bottom CTA bar.
  final Widget? footer;

  /// Whether to inset for the status bar, home indicator and notches.
  final bool useSafeArea;

  /// Space below [child] so the last element is never flush with the
  /// bottom of the screen.
  final double bottomInset;

  /// Width cap for the content column.
  final double maxContentWidth;

  @override
  Widget build(BuildContext context) {
    final gutter = ResponsiveLayout.pageGutter(
      MediaQuery.sizeOf(context).width,
    );

    return Scaffold(
      appBar: appBar,
      body: SafeArea(
        bottom: useSafeArea,
        child: SingleChildScrollView(
          padding: EdgeInsets.fromLTRB(
            gutter,
            AppSpacing.lg,
            gutter,
            bottomInset,
          ),
          child: Center(
            child: ConstrainedBox(
              constraints: BoxConstraints(maxWidth: maxContentWidth),
              child: child,
            ),
          ),
        ),
      ),
      bottomNavigationBar: footer == null
          ? null
          : Center(
              child: ConstrainedBox(
                constraints: BoxConstraints(maxWidth: maxContentWidth),
                child: SafeArea(top: false, child: footer!),
              ),
            ),
    );
  }
}

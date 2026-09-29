/// Every navigable location in the app, in one place.
///
/// Screens register themselves against these constants via [AppRouteNames] so
/// a URL is never spelled out as a string literal in a widget.
///
/// # Planned surface
///
/// The full V1 map is owned by later milestones and is deliberately *not*
/// declared here yet — an unused constant is a promise the code does not keep:
///
/// ```text
/// /welcome                      Milestone 2 (auth)
/// /login                       Milestone 2 (auth)
/// /signup                      Milestone 2 (auth)
/// /onboarding/partner          Milestone 2 (onboarding)
/// /onboarding/cycle             Milestone 3 (cycle tracking)
/// /onboarding/preferences       Milestone 3
/// /onboarding/favorites         Milestone 4 (moves)
/// /home                        Milestone 4 (today's move)
/// /cycle                       Milestone 3
/// /missions                    Milestone 5
/// /profile                     Milestone 6
/// ```
///
/// When authentication arrives, an unauthenticated `redirect` will send
/// protected locations to `/welcome` rather than to the current entry point.
/// The router is already a single injectable `GoRouter`, so that change is
/// additive.
abstract final class AppRoutePaths {
  /// The foundation shell. Also the app's entry point for now.
  static const String foundation = '/';
}

/// Stable, human-readable names for [AppRoutePaths].
///
/// Named routes keep `goNamed` / `onGenerateRoute` call sites readable and make
/// analytics and deep links independent of URL restructuring.
abstract final class AppRouteNames {
  /// See [AppRoutePaths.foundation].
  static const String foundation = 'foundation';
}

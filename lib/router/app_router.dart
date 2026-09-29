import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../core/extensions/build_context_theme.dart';
import '../features/foundation/foundation_page.dart';
import '../shared/widgets/app_scaffold.dart';
import '../theme/tokens/app_spacing.dart';
import 'route_paths.dart';

/// The app's single [GoRouter].
///
/// Declared as a provider so navigation state is created once per
/// `ProviderScope` and disposed with it. Features contribute screens by
/// adding a `GoRoute` to [_routes]; nothing outside this file needs to know
/// how the tree is assembled.
///
/// Authentication-based redirects arrive in a later milestone by adding a
/// `redirect` here and a `refreshListenable` fed by the auth state. No other
/// part of the navigation setup has to change.
final appRouterProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: AppRoutePaths.foundation,
    routes: _routes,
    errorBuilder: _errorBuilder,
  );
});

List<RouteBase> get _routes => [
  GoRoute(
    path: AppRoutePaths.foundation,
    name: AppRouteNames.foundation,
    builder: (context, state) => const FoundationPage(),
  ),
];

/// Renders a routable "page not found" instead of go_router's default error
/// screen, so a bad deep link degrades to a real page.
Widget _errorBuilder(BuildContext context, GoRouterState state) {
  return AppScaffold(child: _RouteNotFound(location: state.uri.toString()));
}

class _RouteNotFound extends StatelessWidget {
  const _RouteNotFound({required this.location});

  final String location;

  @override
  Widget build(BuildContext context) {
    final textTheme = context.textTheme;
    final colors = context.colors;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(LucideIcons.compass, size: 32, color: colors.onSurfaceVariant),
        const SizedBox(height: AppSpacing.lg),
        Text('This page does not exist', style: textTheme.titleLarge),
        const SizedBox(height: AppSpacing.xs),
        Text(
          'Nothing is routed to “$location” yet.',
          style: textTheme.bodyMedium?.copyWith(color: colors.onSurfaceVariant),
        ),
        const SizedBox(height: AppSpacing.xl),
        TextButton.icon(
          onPressed: () => GoRouter.of(context).go(AppRoutePaths.foundation),
          icon: const Icon(LucideIcons.arrowUpRight, size: 18),
          label: const Text('Back to the start'),
        ),
      ],
    );
  }
}

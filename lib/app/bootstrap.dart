import '../core/constants/app_constants.dart';

/// The values the app root needs before any provider or theme exists.
///
/// `main()` builds this and hands it to the widget tree, so a screen deep in
/// the tree can read `Bootstrap.appName` without importing a provider.
class Bootstrap {
  const Bootstrap._();

  /// See [AppConstants.appName].
  static const String appName = AppConstants.appName;

  /// See [AppConstants.appTagline].
  static const String appTagline = AppConstants.appTagline;
}

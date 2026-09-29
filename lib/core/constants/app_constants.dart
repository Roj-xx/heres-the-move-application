/// App-wide identity constants.
///
/// Kept in `core/constants` because they are needed by every layer — the
/// app root, the router, notification surfaces and any future platform
/// integration.
///
/// The Android application id and iOS bundle identifier deliberately live in
/// the native build configuration, not here, so this file can never disagree
/// with `android/app/build.gradle.kts` or the Xcode project.
abstract final class AppConstants {
  /// The product name as shown to users.
  ///
  /// Uses a typographic apostrophe (U+2019) to match the wordmark and the
  /// native launcher labels.
  static const String appName = 'Here’s the Move';

  /// One-line description of what the product is for.
  static const String appTagline = 'Your partner-support toolkit starts here.';
}

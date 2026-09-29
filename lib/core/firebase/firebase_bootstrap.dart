import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart' show visibleForTesting;

import '../../firebase_options.dart';
import '../errors/app_exception.dart';

/// Owns the one-time initialisation of Firebase.
///
/// Firebase is initialised exactly once, from `main()`, *before* `runApp()`
/// builds the widget tree. Doing it there rather than inside a widget means no
/// provider, repository or screen can ever observe a half-initialised backend:
/// by the time any [ProviderScope] exists, [Firebase.apps] is already
/// populated.
///
/// Failures are deliberately not swallowed. A broken backend is a
/// developer-visible fault, so the raw platform error is preserved in
/// [AppException.cause] for logs while [AppException.message] stays safe to
/// show a user.
class FirebaseBootstrap {
  const FirebaseBootstrap._();

  static bool _initialized = false;

  /// Whether [initialize] has already completed successfully.
  ///
  /// Exposed for tests and for future milestones that must assert the backend
  /// is ready before doing any work.
  static bool get isInitialized => _initialized;

  /// Initialises the default Firebase app.
  ///
  /// [options] defaults to the generated
  /// [DefaultFirebaseOptions.currentPlatform], which throws
  /// [UnsupportedError] on any platform FlutterFire was not configured for
  /// (web, desktop, Linux). That is intentional: this project ships as
  /// Android and iOS only.
  ///
  /// Calling this more than once is a no-op. Calling it concurrently is safe
  /// because concurrent callers await the same future.
  static Future<void> initialize({FirebaseOptions? options}) async {
    if (_initialized) return;
    return _initialization ??= _initialize(options ?? _currentOptions());
  }

  static Future<void>? _initialization;

  static Future<void> _initialize(FirebaseOptions options) async {
    try {
      await Firebase.initializeApp(options: options);
      _initialized = true;
    } catch (error, stackTrace) {
      // Reset so a later retry is possible instead of being stuck on a
      // permanently-failed future.
      _initialization = null;
      throw AppException.from(
        error,
        stackTrace,
        userMessage: 'We could not start up. Please try again.',
      );
    }
  }

  static FirebaseOptions _currentOptions() {
    try {
      return DefaultFirebaseOptions.currentPlatform;
    } on UnsupportedError catch (error, stackTrace) {
      throw AppException.from(
        error,
        stackTrace,
        userMessage: 'This version of the app is not supported here.',
      );
    }
  }

  /// Resets the one-time guard. Tests only.
  @visibleForTesting
  static void resetForTesting() {
    _initialized = false;
    _initialization = null;
  }
}

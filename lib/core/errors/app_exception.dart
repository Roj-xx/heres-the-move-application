/// The base error type for the application and domain layers.
///
/// Repositories and services translate platform-specific failures (Firebase,
/// HTTP, storage) into an [AppException] so the presentation layer never has
/// to know what threw. Each [AppException] carries a [message] that is safe to
/// show to a user; details stay in [cause] and [stackTrace] for logging.
class AppException implements Exception {
  const AppException(this.message, {this.cause, this.stackTrace});

  /// Wraps an arbitrary [error] and its [stackTrace].
  ///
  /// [userMessage] replaces the raw error text so internal details are never
  /// surfaced to a user.
  factory AppException.from(
    Object error,
    StackTrace stackTrace, {
    required String userMessage,
  }) {
    return AppException(userMessage, cause: error, stackTrace: stackTrace);
  }

  /// A message safe to display in the UI.
  final String message;

  /// The underlying error, kept for logging and diagnostics only.
  final Object? cause;

  /// Where [cause] was thrown.
  final StackTrace? stackTrace;

  @override
  String toString() => 'AppException: $message';
}

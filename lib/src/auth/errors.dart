part of just_google_signin.auth;

/// Occurs when library throws a custom error.
abstract class AuthError implements Exception {
  String get type;
  get message;

  String toString() => '$type: $message';
}

/// Occurs when [Auth.signIn] operation fails.
class SignInError extends AuthError {
  final String type = 'SignInError';
  final message;

  SignInError(this.message);
}

/// Occurs when [Auth.signOut] operation fails.
class SignOutError extends AuthError {
  final String type = 'SignOutError';
  final message;

  SignOutError(this.message);
}

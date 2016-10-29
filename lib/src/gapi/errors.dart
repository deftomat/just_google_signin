library just_google_signin.gapi.errors;

/// Occurs when gapi library throws a custom error.
abstract class GapiError implements Exception {
  String get type;
  get message;

  String toString() => '$type: $message';
}

/// Occurs when loading of a gapi JS library fails.
class GapiLoadError extends GapiError {
  final String type = 'GapiLoadError';
  final message;

  GapiLoadError(this.message);
}

/// Occurs when loading of a gapi.auth2 JS library fails.
class GapiAuth2LoadError extends GapiError {
  final String type = 'GapiAuth2LoadError';
  final message;

  GapiAuth2LoadError(this.message);
}

/// Occurs when initialization of a gapi.auth2 JS library fails.
class GapiAuth2InitError extends GapiError {
  final String type = 'GapiInitError';
  final message;

  GapiAuth2InitError(this.message);
}

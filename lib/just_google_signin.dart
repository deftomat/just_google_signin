/// Just a Google SignIn library with an OpenID Connect support.
///
/// Library provides a way to SignIn with a Google account
/// and obtain an Access token and ID token (JWT token).
///
/// Obtained JWT token provides an easy way to avoid
/// the need for implementation of a OAuth2 protocol in a back-end code.
///
/// https://developers.google.com/identity/protocols/OpenIDConnect and
/// https://developers.google.com/api-client-library/javascript/reference/referencedocs for more information.
library just_google_signin;

export 'src/auth.dart';
export 'src/gapi/auth2.dart' show isLoaded;

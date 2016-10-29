library just_google_signin.auth;

import 'dart:async';
import 'gapi/auth2.dart' as auth2;
import 'gapi/interfaces.dart' as gapi;

import 'package:js/js.dart';

part 'auth/implementation.dart';
part 'auth/errors.dart';

/// Initialize an [Auth] object with a given [params].
Future<Auth> init(InitParams params) async {
  if (!auth2.isLoaded) {
    await auth2.load();
  }

  var googleAuth = await auth2.init(params.gapiParams);
  return new _Auth(googleAuth);
}

/// Represents an object, which can be used to control and obtain a user's state.
abstract class Auth {
  /// Returns whether the current user is currently signed in.
  bool get isSignedIn;

  /// Returns the user. Null when user is not signed in.
  User get user;

  /// Signs in the user with the given optional options.
  Future<User> signIn([SignInOptions options]);

  /// Signs out the current account from the application.
  Future signOut();

  /// Revokes all of the scopes that the user granted.
  void disconnect();
}

/// Represents the user.
abstract class User {
  UserProfile get profile;
  AuthTokens get tokens;

  /// Returns true if the user is signed in.
  bool get isSignedIn;

  /// Returns the user's Google Apps domain if the user signed in with a Google Apps account.
  String get hostedDomain;

  /// Returns the scopes that the user granted as a space-delimited string.
  String get grantedScopes;
}

/// Represents the user's profile.
abstract class UserProfile {
  String get id;
  String get name;
  String get givenName;
  String get familyName;
  String get imageUrl;
  String get email;
}

/// Represents the user's auth tokens.
abstract class AuthTokens {
  String get idToken;
  String get accessToken;

  DateTime get expiresAt;
  Duration get expiresIn;
}

/// [Auth] object initialization parameters.
class InitParams {
  /// The app's client ID, found and created in the Google Developers Console.
  final String clientId;

  /// The domains for which to create sign-in cookies.
  /// Either a URI, single_host_origin, or none. Defaults to single_host_origin if unspecified.
  final String cookiePolicy;

  /// The scopes to request, as a space-delimited string.
  /// Optional if fetchBasicProfile is not set to false.
  final String scope;

  /// Fetch users' basic profile information when they sign in.
  /// Adds 'profile' and 'email' to the requested scopes.
  /// True if unspecified.
  final bool fetchBasicProfile;

  /// The Google Apps domain to which users must belong to sign in.
  /// This is susceptible to modification by clients,
  /// so be sure to verify the hosted domain property of the returned user.
  ///
  /// Use [User.hostedDomain] on the client, and the hd claim in the ID Token
  /// on the server to verify the domain is what you expected.
  final String hostedDomain;

  /// Used only for OpenID 2.0 client migration.
  /// Set to the value of the realm that you are currently using for OpenID 2.0
  final String openidRealm;

  InitParams(this.clientId,
      {this.cookiePolicy, this.scope, this.fetchBasicProfile, this.hostedDomain, this.openidRealm});

  gapi.Params get gapiParams => new gapi.Params(
      client_id: clientId,
      cookie_policy: cookiePolicy,
      scope: scope,
      fetch_basic_profile: fetchBasicProfile,
      hosted_domain: hostedDomain,
      openid_realm: openidRealm);
}

/// Sign In options.
/// Overrides a parameters in [InitParams] passed to the [init] function.
class SignInOptions {
  /// The package name of the Android app to install over the air.
  final String appPackageName;

  /// Fetch users' basic profile information when they sign in.
  /// Adds 'profile' and 'email' to the requested scopes.
  /// True if unspecified.
  final bool fetchBasicProfile;

  /// Specifies whether to prompt the user for re-authentication.
  /// See OpenID Connect Request Parameters:
  /// https://openid.net/specs/openid-connect-basic-1_0.html#RequestParameters
  final String prompt;

  /// The scopes to request, as a space-delimited string.
  /// Optional if fetch_basic_profile is not set to false.
  final String scope;

  SignInOptions({this.appPackageName, this.fetchBasicProfile, this.prompt, this.scope});

  gapi.Options get gapiOptions => new gapi.Options(
      app_package_name: appPackageName, fetch_basic_profile: fetchBasicProfile, prompt: prompt, scope: scope);
}

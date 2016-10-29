part of just_google_signin.auth;

class _Auth implements Auth {
  final gapi.GoogleAuth googleAuth;

  _Auth(this.googleAuth);

  bool get isSignedIn => googleAuth.isSignedIn.get();
  User get user => new _User(googleAuth.currentUser.get());

  Future<User> signIn([SignInOptions options]) {
    var completer = new Completer();

    googleAuth.signIn(options?.gapiOptions).then(
        allowInterop((gapi.GoogleUser googleUser) => completer.complete(new _User(googleUser))),
        allowInterop((error) => completer.completeError(new SignInError(error))));

    return completer.future;
  }

  Future signOut() {
    var completer = new Completer();

    googleAuth.signOut().then(
        allowInterop(() => completer.complete()),
        allowInterop((error) => completer.completeError(new SignOutError(error))));

    return completer.future;
  }

  void disconnect() => googleAuth.disconnect();
}

class _User implements User {
  final gapi.GoogleUser googleUser;

  _User(this.googleUser);

  UserProfile get profile => new _UserProfile(googleUser.getBasicProfile());
  AuthTokens get tokens => new _AuthTokens(googleUser.getAuthResponse());
  bool get isSignedIn => googleUser.isSignedIn();
  String get hostedDomain => googleUser.getHostedDomain();
  String get grantedScopes => googleUser.getGrantedScopes();
}

class _UserProfile implements UserProfile {
  final gapi.BasicProfile _basicProfile;

  _UserProfile(this._basicProfile);

  String get id => _basicProfile.getId();
  String get name => _basicProfile.getName();
  String get givenName => _basicProfile.getGivenName();
  String get familyName => _basicProfile.getFamilyName();
  String get imageUrl => _basicProfile.getImageUrl();
  String get email => _basicProfile.getEmail();
}

class _AuthTokens implements AuthTokens {
  final gapi.AuthResponse _authResponse;

  _AuthTokens(this._authResponse);

  String get idToken => _authResponse.id_token;
  String get accessToken => _authResponse.access_token;

  DateTime get expiresAt => new DateTime.fromMillisecondsSinceEpoch(_authResponse.expires_at);
  Duration get expiresIn => new Duration(seconds: _authResponse.expires_in);
}

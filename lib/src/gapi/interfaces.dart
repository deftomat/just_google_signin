@JS()
library just_google_signin.gapi.interfaces;

import 'package:js/js.dart';

@JS('gapi.load')
external void load(String name, Function onLoaded);

@JS('gapi.auth2.init')
external Promise initAuth2(Params params);

@JS()
class Promise {
  external Promise then(Function onFulfilled, Function onRejected);
}

@JS()
class AuthResponse {
  external dynamic get access_token;
  external String get id_token;
  external String get login_hint;
  external String get scope;
  external int get first_issued_at;
  external int get expires_in;
  external int get expires_at;
}

@JS()
class GoogleUser {
  external bool isSignedIn();
  external String getHostedDomain();
  external String getGrantedScopes();
  external BasicProfile getBasicProfile();
  external AuthResponse getAuthResponse();
}

@JS()
class BasicProfile {
  external String getId();
  external String getName();
  external String getGivenName();
  external String getFamilyName();
  external String getImageUrl();
  external String getEmail();
}

@JS()
class GoogleAuth {
  external Wrapper get isSignedIn;
  external Wrapper<GoogleUser> get currentUser;
  external Promise signIn(Options options);
  external Promise signOut();
  external dynamic disconnect();
}

@JS()
class Wrapper<T> {
  external T get();
}

@JS()
@anonymous
class Params {
  external String get client_id;
  external String get cookie_policy;
  external String get scope;
  external bool get fetch_basic_profile;
  external String get hosted_domain;
  external String get openid_realm;

  external factory Params(
      {String client_id,
      String cookie_policy,
      String scope,
      bool fetch_basic_profile,
      String hosted_domain,
      String openid_realm});
}

@JS()
@anonymous
class Options {
  external String get app_package_name;
  external bool get fetch_basic_profile;
  external String get prompt;
  external String get scope;

  external factory Options({String app_package_name, bool fetch_basic_profile, String prompt, String scope});
}

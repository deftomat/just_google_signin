# Just Google SignIn

A simple Google SignIn library for Dart with support for an OpenID Connect.

## Usage

```dart
import 'dart:async';
import 'package:just_google_signin/just_google_signin.dart';

main() async {
  var params = new InitParams('<CLIENT_ID>', scope: 'email');
  var auth = await init(params);
  
  if (!auth.isSignedIn) {
    // Shows a Google SignIn form.
    await auth.signIn();
  }
  
  var user = auth.user;
  print('User name: ${user.profile.name}');
  print('JWT token: ${user.tokens.idToken}');
}
```

## Background

 - [Google OpenID Connect](https://developers.google.com/identity/protocols/OpenIDConnect)
 - [Google API Client reference](https://developers.google.com/api-client-library/javascript/reference/referencedocs)

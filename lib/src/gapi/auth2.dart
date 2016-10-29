library just_google_signin.gapi.auth2;

import 'dart:async';
import 'dart:html' as html;
import 'dart:js' as js;

import 'package:js/js.dart';

import 'interfaces.dart' as gapi;
import 'errors.dart';

const _gapiUrl = 'https://apis.google.com/js/client.js';
const _fapiOnLoadCallbackName = '_gapiLoaded';
const _onLoadTimeout = const Duration(seconds: 30);
Completer _loadCompleter = new Completer();

/// Returns true when gapi.auth2 library was loaded.
bool get isLoaded => js.context['gapi'] != null && js.context['gapi']['auth2'] != null;

/// Loads the gapi.auth2 JS library.
///
/// When a gapi.auth2 already exists in JS context, then a [GapiAuth2LoadError] will occur.
Future load() {
  if (isLoaded) throw new GapiAuth2LoadError('gapi.auth2 library cannot be loaded twice!');

  var timeout = new Timer(_onLoadTimeout, () {
    _loadCompleter.completeError(
        new GapiAuth2LoadError('Timed out while waiting for the gapi.auth2 library to load.'));
  });

  js.context[_fapiOnLoadCallbackName] = () {
    gapi.load('auth2', allowInterop(() {
      timeout.cancel();
      return _loadCompleter.complete();
    }));
  };

  _addGapiScript().onError.first.then((errorEvent) {
    timeout.cancel();
    _loadCompleter.completeError(new GapiLoadError('Failed to load gapi library.'));
  });

  return _loadCompleter.future;
}

html.ScriptElement _addGapiScript() {
  var script = new html.ScriptElement();
  script.src = '$_gapiUrl?onload=$_fapiOnLoadCallbackName';
  html.document.body.append(script);

  return script;
}

/// Initializes a gapi.auth2 JS library.
///
/// [GapiAuth2InitError] will occur when library initialization fail.
Future<gapi.GoogleAuth> init(gapi.Params params) {
  var completer = new Completer();

  gapi.initAuth2(params).then(
      allowInterop((gapi.GoogleAuth googleAuth) => completer.complete(googleAuth)),
      allowInterop((error) => completer.completeError(new GapiAuth2InitError(error))));

  return completer.future;
}

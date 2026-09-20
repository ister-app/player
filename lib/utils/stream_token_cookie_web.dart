import 'dart:js_interop';

@JS('location.origin')
external String get _origin;

@JS('document.cookie')
external String get _cookie;

@JS('document.cookie')
external set _cookie(String value);

String? pageOrigin() => _origin;

void writeCookie(String cookie) => _cookie = cookie;

String readCookies() => _cookie;

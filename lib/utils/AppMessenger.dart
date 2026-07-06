import 'package:flutter/material.dart';

/// Global messenger key so non-widget singletons (e.g. [MediaPlayerHandler])
/// can surface user-facing snackbars without holding a [BuildContext]. Wired
/// into [MaterialApp.router] in `main.dart`.
final GlobalKey<ScaffoldMessengerState> rootScaffoldMessengerKey =
    GlobalKey<ScaffoldMessengerState>();

/// Shows [message] on the app's root messenger, replacing any current snackbar.
/// A no-op when no messenger is mounted (e.g. headless audio-service startup).
void showAppSnackBar(String message) {
  rootScaffoldMessengerKey.currentState
    ?..hideCurrentSnackBar()
    ..showSnackBar(SnackBar(content: Text(message)));
}

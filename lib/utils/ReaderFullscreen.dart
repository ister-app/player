import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:media_kit_video/media_kit_video.dart';

/// Fullscreen for the readers (epub and comic).
///
/// Mobile hides the system bars with [SystemChrome] rather than media_kit's
/// [defaultEnterNativeFullscreen], because the latter also forces landscape —
/// fine for video, wrong for a book. Desktop and web do use the media_kit
/// helpers (native window fullscreen / `requestFullscreen`), which swallow
/// their own failures. On web a browser may refuse `requestFullscreen`
/// outside a user gesture, so restoring fullscreen on open silently leaves
/// the reader windowed there.
class ReaderFullscreen {
  ReaderFullscreen._();

  /// Whether a reader is currently fullscreen. The server shell listens to
  /// this to hide its own navigation chrome (rail / bottom bar / mini player),
  /// which [SystemChrome] can't touch.
  static final ValueNotifier<bool> active = ValueNotifier(false);

  static bool get _mobile => !kIsWeb && (Platform.isAndroid || Platform.isIOS);

  static Future<void> enter() async {
    active.value = true;
    if (_mobile) {
      await SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
    } else {
      await defaultEnterNativeFullscreen();
    }
  }

  static Future<void> exit() async {
    active.value = false;
    if (_mobile) {
      await SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    } else {
      await defaultExitNativeFullscreen();
    }
  }

  /// Re-applies immersive mode after an app resume; some Android builds drop
  /// it while backgrounded. No-op where fullscreen is a window state.
  static Future<void> reassert() async {
    if (_mobile) {
      await SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
    }
  }
}

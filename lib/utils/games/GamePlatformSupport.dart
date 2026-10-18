import 'dart:io' show Platform;

import 'package:flutter/foundation.dart' show kIsWeb;

/// Where games can be installed and launched: the desktop builds that can
/// start a local emulator or executable. Every other platform browses the
/// game library and manages saves, and says so instead of showing a Play
/// button that cannot work.
final bool kGamesSupported = !kIsWeb && (Platform.isLinux || Platform.isWindows);

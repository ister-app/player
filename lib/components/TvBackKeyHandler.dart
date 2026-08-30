import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

/// Root-level "back" for keyboard-driven TV mode (SteamOS game mode, HTPC).
///
/// A gamepad reaches the app as keyboard events (Steam Input maps B → Escape,
/// per the SteamOS guide), and a CEC/HTPC remote sends GoBack/BrowserBack —
/// none of which Flutter routes anywhere by default, so every page was a
/// one-way door. This sits at the very top of the focus chain: any back key a
/// descendant did not consume (the video controls keep Escape while hidden,
/// dialogs pop themselves) triggers [onBack], which the app wires to the root
/// router's popRoute so the music-player dismiss animation keeps working.
class TvBackKeyHandler extends StatelessWidget {
  const TvBackKeyHandler({
    super.key,
    required this.onBack,
    required this.child,
  });

  final VoidCallback onBack;
  final Widget child;

  static final _backKeys = {
    LogicalKeyboardKey.escape,
    LogicalKeyboardKey.goBack,
    LogicalKeyboardKey.browserBack,
  };

  KeyEventResult _onKeyEvent(FocusNode node, KeyEvent event) {
    if (event is! KeyDownEvent || !_backKeys.contains(event.logicalKey)) {
      return KeyEventResult.ignored;
    }
    onBack();
    return KeyEventResult.handled;
  }

  @override
  Widget build(BuildContext context) {
    return Focus(
      canRequestFocus: false,
      skipTraversal: true,
      onKeyEvent: _onKeyEvent,
      child: child,
    );
  }
}

import 'package:flutter/material.dart';
import 'package:media_kit_video/media_kit_video.dart';

import '../utils/MediaPlayerHandler.dart';
import '../utils/PlatformService.dart';

class IsterPlayer extends StatefulWidget {
  const IsterPlayer({
    super.key,
  });

  @override
  State<IsterPlayer> createState() => _IsterPlayerState();
}

class _IsterPlayerState extends State<IsterPlayer> {
  final MediaPlayerHandler _handler = MediaPlayerHandler.instance;

  @override
  Widget build(BuildContext context) {
    // On Android TV input is D-pad based, so use the desktop controls: they
    // bind arrow keys to seek/volume and space/media keys to play-pause, which
    // a remote can drive. The adaptive (mobile) controls are touch-only.
    return Video(
      controller: _handler.videoController,
      controls: PlatformService.isAndroidTvSync
          ? MaterialDesktopVideoControls
          : AdaptiveVideoControls,
    );
  }
}

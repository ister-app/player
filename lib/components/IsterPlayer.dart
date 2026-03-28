import 'package:flutter/material.dart';
import 'package:media_kit_video/media_kit_video.dart';

import '../utils/MediaPlayerHandler.dart';

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
    return Video(
      controller: _handler.videoController,
      controls: AdaptiveVideoControls,
    );
  }
}

import 'package:flutter/material.dart';
import 'package:media_kit/media_kit.dart';
import 'package:media_kit_video/media_kit_video.dart';

import '../utils/LoginManager.dart';

class IsterPlayer extends StatefulWidget {
  const IsterPlayer(
      {super.key, required this.serverName, required this.mediaId, this.onProgressChanged, this.startTimeInMilliseconds, this.onCompleted});

  final String serverName;
  final String mediaId;
  final int? startTimeInMilliseconds;
  final Function(Duration duration)? onProgressChanged;
  final Function(bool completed)? onCompleted;

  @override
  State<IsterPlayer> createState() => _IsterPlayerState();
}

class _IsterPlayerState extends State<IsterPlayer> {
  late final player = Player(
      configuration: PlayerConfiguration(
          libass: true,
          libassAndroidFont: "assets/fonts/DroidSansFallback.ttf",
          libassAndroidFontName: "Droid Sans Fallback",
          bufferSize: 320 * 1024 * 1024));
  late final controller = VideoController(
    player,
    configuration: VideoControllerConfiguration(
      enableHardwareAcceleration: true,
    ),
  );

  Duration? lastDurationUpdate;

  @override
  void initState() {
    super.initState();
    _initPlayer();

    player.stream.position.listen(
          (Duration position) {
            if (widget.onProgressChanged != null && (lastDurationUpdate == null || (position.inMilliseconds - lastDurationUpdate!.inMilliseconds).abs() > 10 * 1000)) {
              lastDurationUpdate = position;
              widget.onProgressChanged!(position);
            }
      },
    );
    player.stream.completed.listen((completed) {
      if (widget.onCompleted != null) {
        widget.onCompleted!(completed);
      }
    },);
  }

  void _initPlayer() async {
    // if (Platform.isAndroid) {
    //   NativePlayer _nativePlayer = player.platform as NativePlayer;
    //   final ByteData data = await rootBundle.load("assets/fonts/DroidSansFallback.ttf");
    //   final Uint8List buffer = data.buffer.asUint8List();
    //   final Directory directory = await getApplicationSupportDirectory();
    //   final String fontsDir = "${directory.path}/fonts";
    //   final File file = File("$fontsDir/DroidSansFallback.ttf");
    //   await file.create(recursive: true);
    //   await file.writeAsBytes(buffer);
    //   // await _nativePlayer.setProperty("sub-fonts-dir", fontsDir);
    //   // await _nativePlayer.setProperty("sub-font", "Droid Sans Fallback");
    // }

    if (player.platform is NativePlayer) {
      // (player.platform as dynamic).setProperty("profile", "fast");
      // (player.platform as dynamic).setProperty("cache", "no");
      // (player.platform as dynamic).setProperty("tscale", "mitchell");
      // (player.platform as dynamic).setProperty("video-sync", "display-resample");
      // (player.platform as dynamic).setProperty("correct-pts", "no");
      // (player.platform as dynamic).setProperty("untimed", "");
    }

    // Play a [Media] or [Playlist].
    var duration = Duration(milliseconds: widget.startTimeInMilliseconds ?? 0);
    print(duration);
    var media = Media(
        'https://${widget.serverName}/mediaFile/${widget.mediaId}/download',
        start: duration,
        httpHeaders: LoginManager.getHeaders(widget.serverName));
    player.open(media);
  }

  Future<void> setSubtitleTrack() async {
    if (player.state.track.subtitle.id == "no") {
      player.setSubtitleTrack(player.state.tracks.subtitle[2]);
    } else {
      player.setSubtitleTrack(SubtitleTrack.no());
    }
  }

  @override
  void dispose() {
    player.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.width * 9.0 / 16.0,
      // Use [Video] widget to display video output.
      child: Video(controller: controller, controls: AdaptiveVideoControls),
    );
  }
}

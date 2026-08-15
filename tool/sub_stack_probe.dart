// Headless probe for HLS subtitle behaviour in mpv, using the same
// package:media_kit + system libmpv the app runs on. Plays a (local) HLS
// master with a subtitle track enabled and reports how many lines libass
// shows at once — the segmented-WebVTT bug stacks repeated cues.
//
// Usage: dart run tool/sub_stack_probe.dart <master.m3u8>
import 'dart:async';
import 'dart:io';

import 'package:media_kit/media_kit.dart';

Future<void> main(List<String> args) async {
  final master = args.first;
  MediaKit.ensureInitialized();
  final player = Player(
    configuration: const PlayerConfiguration(
      vo: 'null',
      logLevel: MPVLogLevel.warn,
    ),
  );
  // Same demuxer options as MediaPlayerHandler._applyMpvNetworkOptions.
  final dynamic native = player.platform;
  await native.setProperty('demuxer-lavf-o',
      'seg_max_retry=5,strict=experimental,allowed_extensions=ALL,extension_picky=0');

  var maxLines = 0;
  var samples = 0;
  player.stream.subtitle.listen((subtitle) {
    final text = subtitle[0];
    if (text.isEmpty) return;
    samples++;
    final lines = text.split('\n').length;
    if (lines > maxLines) maxLines = lines;
    stdout.writeln('[SUB] lines=$lines "${text.replaceAll('\n', ' | ')}"');
  });
  player.stream.log.listen((l) => stdout.writeln('[mpv][${l.level}] ${l.text}'));

  await player.open(Media(master));
  final tracks = await player.stream.tracks
      .firstWhere(
          (t) => t.subtitle.any((x) => x.id != 'auto' && x.id != 'no'))
      .timeout(const Duration(seconds: 30));
  final sub =
      tracks.subtitle.firstWhere((x) => x.id != 'auto' && x.id != 'no');
  stdout.writeln('[PROBE] subtitle tracks: '
      '${tracks.subtitle.map((t) => t.id).join(',')} -> selecting ${sub.id}');
  await player.setSubtitleTrack(sub);
  final scenario = args.length > 1 ? args[1] : 'play';
  switch (scenario) {
    case 'play':
      await player.seek(const Duration(seconds: 40));
      await Future.delayed(const Duration(seconds: 30));
    case 'seekback':
      // The app's backward-scrub flow: play ahead, seek back, sid-cycle.
      await player.seek(const Duration(seconds: 60));
      await Future.delayed(const Duration(seconds: 6));
      stdout.writeln('[PROBE] backward seek');
      await player.seek(const Duration(seconds: 44));
      await Future.delayed(const Duration(seconds: 2));
      stdout.writeln('[PROBE] sid cycle');
      await native.setProperty('sid', 'no');
      await native.setProperty('sid', sub.id);
      await Future.delayed(const Duration(seconds: 22));
    case 'resume':
      // Mid-file open like a watch-progress resume.
      await player.stop();
      samples = 0;
      maxLines = 0;
      await player.open(Media(master, start: const Duration(seconds: 44)));
      await player.stream.tracks
          .firstWhere(
              (t) => t.subtitle.any((x) => x.id != 'auto' && x.id != 'no'))
          .timeout(const Duration(seconds: 30));
      await player.setSubtitleTrack(player.state.tracks.subtitle
          .firstWhere((x) => x.id != 'auto' && x.id != 'no'));
      await Future.delayed(const Duration(seconds: 25));
  }
  stdout.writeln('RESULT samples=$samples maxLines=$maxLines');
  await player.dispose();
  exit(0);
}

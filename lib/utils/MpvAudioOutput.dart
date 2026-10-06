import 'package:flutter/foundation.dart';
import 'package:media_kit/media_kit.dart';

/// mpv audio output (`--ao`) override, `--dart-define=ISTER_MPV_AO=pulse`.
///
/// Only the headless e2e/docs runs set it. mpv ≥ 0.41 autoprobes `pipewire`
/// before `pulse`; on a runner that has libpipewire but only a PulseAudio
/// daemon the first file still plays, and the *second* open then wedges the
/// mpv core in the ao, with the Dart main isolate blocked behind it in
/// `mpv_get_property_string` (ubuntu-26.04 migration, October 2026). Pinning
/// the output to the daemon that is actually running sidesteps the autoprobe.
/// Empty (the default, and every shipped build) leaves mpv's choice alone.
const String mpvAudioOutput = String.fromEnvironment('ISTER_MPV_AO');

/// Applies [mpvAudioOutput] to [player]; call before the first `open`.
Future<void> applyMpvAudioOutput(Player player) async {
  if (kIsWeb || mpvAudioOutput.isEmpty) return;
  final platform = player.platform;
  if (platform is! NativePlayer) return;
  // Dynamic dispatch, same reason as in MediaPlayerHandler: the web stub has
  // no setProperty and a static call breaks dart2js even when unreachable.
  final dynamic native = platform;
  await native.setProperty('ao', mpvAudioOutput);
}

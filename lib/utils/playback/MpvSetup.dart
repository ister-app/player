// mpv process-level setup for the app's single media_kit Player: the demuxer
// cache budget per device class and the ffmpeg/mpv network options that keep
// backgrounded HLS playback from hanging. Pure functions of the platform —
// nothing here reads playback state — so they live outside MediaPlayerHandler.
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:media_kit/media_kit.dart';
import 'package:player/utils/LoggerService.dart';
import 'package:player/utils/MpvAudioOutput.dart';

/// Make HLS playback more resilient in the background. Android throttles the
/// network when the app is backgrounded, which can stall mpv's segment
/// fetches indefinitely. These ffmpeg/mpv options make the underlying HTTP
/// connections time out and auto-reconnect instead of hanging forever.
Future<void> applyMpvNetworkOptions(Player player) async {
  if (kIsWeb) return;
  final platform = player.platform;
  if (platform is! NativePlayer) return;
  const reconnect =
      'reconnect=1,reconnect_streamed=1,reconnect_on_network_error=1,reconnect_delay_max=30';
  // Setting demuxer-lavf-o here REPLACES the options media_kit configured at
  // player init (seg_max_retry, allowed_extensions) — merge them back in.
  // extension_picky=1 must be EXPLICIT even though it is ffmpeg's default:
  // mpv ≥ 0.40 force-sets extension_picky=0 whenever the user leaves it out
  // of demuxer-lavf-o (demux_lavf.c, "known FFmpeg bugs"), and with picky
  // off ffmpeg stops dropping the in-manifest `.srt` subtitle renditions.
  // Those tracks then win the language preference over the side-loaded
  // external SRTs (_loadExternalSubtitleTracks) and re-deliver segment cues
  // on every seek/refetch, which libass stacks as doubled subtitle lines.
  // http_persistent=0 belongs with it: ffmpeg 8.x only rejects the `.srt`
  // rendition mid-parse of its sub playlist, leaving the shared keep-alive
  // playlist connection desynced — the *video* playlist then reads garbage
  // ("parse_playlist error", "Empty segment") and playback is a black
  // screen with a growing live-style duration. A fresh connection per
  // playlist makes the rejection harmless. ffmpeg 9 drops unsupported
  // renditions before parsing ("Can't support the subtitle") and never
  // hits this.
  const demuxerExtras =
      'seg_max_retry=5,strict=experimental,allowed_extensions=ALL,'
      'extension_picky=1,http_persistent=0';
  try {
    // Dynamic dispatch: on web media_kit substitutes a stub NativePlayer
    // without setProperty, so a static call breaks dart2js/dart2wasm even
    // though this code is unreachable there.
    final dynamic native = platform;
    // When video falls behind the audio clock (e.g. right after unpausing on
    // a low-end TV), the default framedrop=vo only drops frames *after*
    // they were decoded, copied and uploaded — on the mediacodec-copy path
    // that keeps the pipeline saturated for seconds (a visible slideshow
    // until it catches up). Dropping at the decoder as well skips the
    // expensive part of the pipeline and recovers within a few frames.
    await applyMpvAudioOutput(player);
    await native.setProperty('framedrop', 'decoder+vo');
    // media_kit turns on cache-on-disk but sets no demuxer-cache-dir; on
    // Android mpv has no user cache dir to fall back to, so every demuxer
    // open (one per HLS sub-playlist) logs "Failed to create file cache"
    // and buffers in RAM anyway. Say so explicitly. Desktop keeps the disk
    // cache: there mp_find_user_file resolves a real directory.
    if (Platform.isAndroid) {
      await native.setProperty('cache-on-disk', 'no');
    }
    await native.setProperty('network-timeout', '30');
    await native.setProperty('stream-lavf-o', reconnect);
    await native.setProperty('demuxer-lavf-o', '$reconnect,$demuxerExtras');
    LoggerService().logger.d('Applied mpv network reconnect options');
  } catch (e) {
    LoggerService().logger.w('Failed to set mpv network options: $e');
  }
}

/// mpv demuxer cache budget. media_kit applies this value to *both*
/// demuxer-max-bytes and demuxer-max-back-bytes, so the real ceiling is
/// twice what is returned here. On low-RAM devices (2GB Android TV boxes)
/// the 320MB desktop default lets the process grow past 800MB RSS and the
/// lowmemorykiller SIGKILLs the app mid-playback — scale down there.
int demuxerBufferSize() {
  const desktop = 320 * 1024 * 1024;
  const mobile = 64 * 1024 * 1024;
  const lowRam = 32 * 1024 * 1024;
  // iOS has no readable total-memory figure (see totalPhysicalMemory), and
  // its per-app jetsam limit is a fraction of installed RAM regardless — a
  // 640MB demuxer budget gets the process killed without a log line or a
  // crash report, the same way the lowmemorykiller does on 2GB Android TV
  // boxes. Pick the mobile tier unconditionally rather than measure.
  if (!kIsWeb && Platform.isIOS) return mobile;
  final totalRam = totalPhysicalMemory();
  if (totalRam != null && totalRam < 3 * 1024 * 1024 * 1024) return lowRam;
  return desktop;
}

/// Total physical memory in bytes, or null when it cannot be determined.
///
/// Only Android and Linux expose procfs. On iOS and macOS there is no
/// synchronous equivalent — `ProcessInfo` in dart:io reports this process's
/// RSS, not the machine's RAM, and `IosDeviceInfo` carries no memory figure
/// (and is async besides) — so callers handle null themselves.
int? totalPhysicalMemory() {
  if (kIsWeb || !(Platform.isAndroid || Platform.isLinux)) return null;
  try {
    final memInfo = File('/proc/meminfo').readAsStringSync();
    final match = RegExp(r'MemTotal:\s+(\d+) kB').firstMatch(memInfo);
    if (match == null) return null;
    return int.parse(match.group(1)!) * 1024;
  } catch (_) {
    return null;
  }
}

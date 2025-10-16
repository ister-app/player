import 'dart:async';

import 'package:flutter/material.dart';
import 'package:media_kit/media_kit.dart';
import 'package:media_kit_video/media_kit_video.dart';
import 'package:player/utils/ClientManager.dart';
import 'package:player/utils/LanguagePreferences.dart';

import '../utils/LanguageService.dart';
import '../utils/LoggerService.dart';
import '../utils/LoginManager.dart';

class IsterPlayer extends StatefulWidget {
  const IsterPlayer({
    super.key,
    required this.serverName,
    required this.mediaId,
    this.onProgressChanged,
    this.startTimeInMilliseconds,
    this.onCompleted,
  });

  final String serverName;
  final String mediaId;
  final int? startTimeInMilliseconds;
  final ValueChanged<Duration>? onProgressChanged;
  final ValueChanged<bool>? onCompleted;

  @override
  State<IsterPlayer> createState() => _IsterPlayerState();
}

class _IsterPlayerState extends State<IsterPlayer> {
  late final Player _player;
  late final VideoController _controller;
  final GlobalKey<VideoState> _videoKey = GlobalKey<VideoState>();
  Duration? _lastProgress;
  final List<StreamSubscription> _subs = [];
  final LanguageService languageService = LanguageService();

  @override
  void initState() {
    super.initState();
    _setupPlayer();
  }

  Future<void> _setupPlayer() async {
    _player = Player(
      configuration: const PlayerConfiguration(
        libass: true,
        libassAndroidFont: 'assets/fonts/DroidSansFallback.ttf',
        libassAndroidFontName: 'Droid Sans Fallback',
        bufferSize: 320 * 1024 * 1024,
      ),
    );
    _controller = VideoController(
      _player,
      configuration: const VideoControllerConfiguration(
        enableHardwareAcceleration: true,
      ),
    );

    _listenToTracks();
    _listenToPosition();
    _listenToCompletion();

    await _openMedia();
  }

  void _listenToTracks() {
    final sub = _player.stream.tracks.listen((tracks) async {
      await _selectPreferredTrack<SubtitleTrack>(
        tracks.subtitle,
        LanguagePreferences.getSubtitleLanguages,
        (track) => _player.setSubtitleTrack(track),
      );
      await _selectPreferredTrack<AudioTrack>(
        tracks.audio,
        LanguagePreferences.getSpokenLanguages,
        (track) => _player.setAudioTrack(track),
      );
    });
    _subs.add(sub);
  }

  Future<void> _selectPreferredTrack<T>(
    List<T> available,
    Future<List<String>> Function() getPrefs,
    Future<void> Function(T) setter,
  ) async {
    final prefs = await getPrefs();
    for (final lang in prefs) {
      final data = await languageService.getLanguageData(lang);
      if (data == null) continue;

      final match = available
          .where(
            (t) => data.toCodeList().contains(
                _trackLanguage(t)),
          )
          .toList();
      if (match.isNotEmpty) {
        await setter(match.first);
        return;
      }
    }
    // fallback
    await setter(_fallbackTrack<T>());
  }

  // Helper to extract language code from a track (implementation depends on type)
  String? _trackLanguage<T>(T track) {
    if (track is SubtitleTrack) return track.language;
    if (track is AudioTrack) return track.language;
    return null;
  }

  T _fallbackTrack<T>() {
    if (T == SubtitleTrack) return SubtitleTrack.no() as T;
    if (T == AudioTrack) return AudioTrack.auto() as T;
    throw UnimplementedError();
  }

  void _listenToPosition() {
    final sub = _player.stream.position.listen((pos) {
      final cb = widget.onProgressChanged;
      if (cb == null) return;
      if (_lastProgress == null ||
          (pos - _lastProgress!).inMilliseconds.abs() > 10 * 1000) {
        _lastProgress = pos;
        cb(pos);
      }
    });
    _subs.add(sub);
  }

  void _listenToCompletion() {
    final sub = _player.stream.completed.listen((completed) {
      _videoKey.currentState?.exitFullscreen();
      widget.onCompleted?.call(completed);
    });
    _subs.add(sub);
  }

  Future<void> _openMedia() async {
    final start = Duration(milliseconds: widget.startTimeInMilliseconds ?? 0);
    final media = Media(
      '${ClientManager.getHttpOrHttps(widget.serverName)}://${widget.serverName}'
      '/mediaFile/${widget.mediaId}/download',
      start: start,
      httpHeaders: LoginManager.getHeaders(widget.serverName),
    );
    try {
      await _player.open(media);
    } catch (e) {
      LoggerService().logger.e('Failed to open media: $e');
    }
  }

  @override
  void dispose() {
    for (final s in _subs) {
      s.cancel();
    }
    _player.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 16 / 9,
      child: Video(
        key: _videoKey,
        controller: _controller,
        controls: AdaptiveVideoControls,
      ),
    );
  }
}

import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:media_kit/media_kit.dart';

import '../l10n/app_localizations.dart';
import '../utils/MediaPlayerHandler.dart';

class TrackSelectionWidget extends StatefulWidget {
  const TrackSelectionWidget({super.key});

  @override
  State<TrackSelectionWidget> createState() => _TrackSelectionWidgetState();
}

class _TrackSelectionWidgetState extends State<TrackSelectionWidget> {
  final Player _player = MediaPlayerHandler.instance.player;

  List<AudioTrack> _audioTracks = [];
  List<SubtitleTrack> _subtitleTracks = [];
  AudioTrack? _currentAudio;
  SubtitleTrack? _currentSubtitle;

  late StreamSubscription _tracksSubscription;
  late StreamSubscription _trackSubscription;
  Timer? _tracksTimer;

  @override
  void initState() {
    super.initState();
    _audioTracks = _player.state.tracks.audio;
    _subtitleTracks = _player.state.tracks.subtitle;
    _currentAudio = _player.state.track.audio;
    _currentSubtitle = _player.state.track.subtitle;

    _tracksSubscription = _player.stream.tracks.listen((tracks) {
      if (!mounted) return;
      setState(() {
        _audioTracks = tracks.audio;
        _subtitleTracks = tracks.subtitle;
      });
      if (tracks.audio.length > 2 || tracks.subtitle.length > 2) {
        _tracksTimer?.cancel();
      }
    });

    _trackSubscription = _player.stream.track.listen((track) {
      if (!mounted) return;
      setState(() {
        _currentAudio = track.audio;
        _currentSubtitle = track.subtitle;
      });
    });

    // HLS op Linux: tracks kunnen laat binnenkomen. Eenmalige herlezing.
    if (_audioTracks.length <= 2 && _subtitleTracks.length <= 2) {
      _tracksTimer = Timer(const Duration(milliseconds: 800), () {
        if (!mounted) return;
        final tracks = _player.state.tracks;
        if (tracks.audio.length > 2 || tracks.subtitle.length > 2) {
          setState(() {
            _audioTracks = tracks.audio;
            _subtitleTracks = tracks.subtitle;
          });
        }
      });
    }
  }

  @override
  void dispose() {
    _tracksTimer?.cancel();
    _tracksSubscription.cancel();
    _trackSubscription.cancel();
    super.dispose();
  }

  String _audioLabel(AudioTrack t, AppLocalizations loc) {
    if (t == AudioTrack.auto()) return loc.trackAuto;
    final parts = [t.title, t.language].where((s) => s != null && s.isNotEmpty).toList();
    return parts.isNotEmpty ? parts.join(' – ') : t.id;
  }

  String _subtitleLabel(SubtitleTrack t, AppLocalizations loc) {
    if (t == SubtitleTrack.no()) return loc.trackNone;
    final parts = [t.title, t.language].where((s) => s != null && s.isNotEmpty).toList();
    return parts.isNotEmpty ? parts.join(' – ') : t.id;
  }

  bool get _hasMultipleAudio => _audioTracks.where((t) => t != AudioTrack.auto()).length > 1;

  @override
  Widget build(BuildContext context) {
    if (_audioTracks.isEmpty && _subtitleTracks.isEmpty) return const SizedBox.shrink();

    final loc = AppLocalizations.of(context)!;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      child: Wrap(
        spacing: 16,
        runSpacing: 8,
        crossAxisAlignment: WrapCrossAlignment.center,
        children: [
          if (_hasMultipleAudio) _buildAudioMenu(context, loc),
          if (_subtitleTracks.isNotEmpty) _buildSubtitleMenu(context, loc),
        ],
      ),
    );
  }

  Widget _buildAudioMenu(BuildContext context, AppLocalizations loc) {
    final current = _currentAudio ?? AudioTrack.auto();
    final effectiveCurrent = _audioTracks.contains(current) ? current : _audioTracks.first;
    final label = _audioLabel(effectiveCurrent, loc);

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        const Icon(Icons.volume_up, size: 18),
        const SizedBox(width: 4),
        MenuAnchor(
          menuChildren: _audioTracks.map((t) => MenuItemButton(
            onPressed: () {
              setState(() => _currentAudio = t);
              _player.setAudioTrack(t).then((_) {
                if (!kIsWeb) _player.seek(_player.state.position);
              });
            },
            child: Text(_audioLabel(t, loc)),
          )).toList(),
          builder: (context, controller, child) => TextButton(
            onPressed: () => controller.isOpen ? controller.close() : controller.open(),
            style: TextButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              minimumSize: Size.zero,
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(label, style: const TextStyle(fontSize: 13)),
                const Icon(Icons.arrow_drop_down, size: 18),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSubtitleMenu(BuildContext context, AppLocalizations loc) {
    final noTrack = SubtitleTrack.no();
    final current = _currentSubtitle ?? noTrack;
    final validTracks = _subtitleTracks.contains(noTrack)
        ? _subtitleTracks
        : [noTrack, ..._subtitleTracks];
    final effectiveCurrent = validTracks.contains(current) ? current : noTrack;
    final label = _subtitleLabel(effectiveCurrent, loc);

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        const Icon(Icons.subtitles, size: 18),
        const SizedBox(width: 4),
        MenuAnchor(
          menuChildren: validTracks.map((t) => MenuItemButton(
            onPressed: () {
              setState(() => _currentSubtitle = t);
              MediaPlayerHandler.instance.switchSubtitleTrack(t);
            },
            child: Text(_subtitleLabel(t, loc)),
          )).toList(),
          builder: (context, controller, child) => TextButton(
            onPressed: () => controller.isOpen ? controller.close() : controller.open(),
            style: TextButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              minimumSize: Size.zero,
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(label, style: const TextStyle(fontSize: 13)),
                const Icon(Icons.arrow_drop_down, size: 18),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

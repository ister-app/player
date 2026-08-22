import 'package:auto_route/auto_route.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:player/utils/DisplayPreferences.dart';
import 'package:player/utils/PlatformService.dart';
import 'package:player/utils/PlaybackPreferences.dart';

import '../l10n/app_localizations.dart';

@RoutePage()
class ServerSettingsPlaybackPage extends StatefulWidget {
  const ServerSettingsPlaybackPage({
    super.key,
    @PathParam.inherit('serverName') required this.serverName,
  });

  final String serverName;

  @override
  State<ServerSettingsPlaybackPage> createState() =>
      _ServerSettingsPlaybackPageState();
}

class _ServerSettingsPlaybackPageState
    extends State<ServerSettingsPlaybackPage> {
  bool _directPlay = true;
  bool _transcode = true;
  bool _autoSkipIntro = false;
  int? _maxVideoHeight;
  bool _realHdr = false;
  bool _matchFrameRate = false;
  late Future<void> _preferencesFuture;

  /// The SurfaceView/HDR path only exists on Android with an HDR display
  /// (phone or TV); hide the device-local toggles everywhere else.
  bool get _showDisplaySettings => PlatformService.isHdrDisplaySync;

  @override
  void initState() {
    super.initState();
    _preferencesFuture = _loadPreferences();
  }

  Future<void> _loadPreferences() async {
    final server = widget.serverName;
    final directPlay = await PlaybackPreferences.getDirectPlay(serverName: server);
    final transcode = await PlaybackPreferences.getTranscode(serverName: server);
    final maxVideoHeight =
        await PlaybackPreferences.getMaxVideoHeight(serverName: server);
    final autoSkipIntro =
        await PlaybackPreferences.getAutoSkipIntro(serverName: server);
    if (!mounted) return;
    setState(() {
      _directPlay = directPlay;
      _transcode = transcode;
      _maxVideoHeight = maxVideoHeight;
      _autoSkipIntro = autoSkipIntro;
      _realHdr = DisplayPreferences.realHdrSync;
      _matchFrameRate = DisplayPreferences.matchFrameRateSync;
    });
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    final server = widget.serverName;

    return Scaffold(
      appBar: AppBar(title: Text(loc.playbackSettings)),
      body: FutureBuilder<void>(
        future: _preferencesFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          return ListView(
            padding: const EdgeInsets.all(16.0),
            children: [
              Card(
                child: SwitchListTile(
                  secondary: const Icon(Icons.play_circle_outline),
                  title: Text(loc.directPlay),
                  subtitle: Text(loc.directPlayDescription),
                  value: _directPlay,
                  onChanged: (value) {
                    PlaybackPreferences.setDirectPlay(value, serverName: server);
                    setState(() => _directPlay = value);
                  },
                ),
              ),
              Card(
                child: SwitchListTile(
                  secondary: const Icon(Icons.transform),
                  title: Text(loc.transcode),
                  subtitle: Text(loc.transcodeDescription),
                  value: kIsWeb ? true : _transcode,
                  onChanged: kIsWeb
                      ? null
                      : (value) {
                          PlaybackPreferences.setTranscode(value,
                              serverName: server);
                          setState(() => _transcode = value);
                        },
                ),
              ),
              Card(
                child: SwitchListTile(
                  secondary: const Icon(Icons.skip_next_outlined),
                  title: Text(loc.autoSkipIntro),
                  subtitle: Text(loc.autoSkipIntroDescription),
                  value: _autoSkipIntro,
                  onChanged: (value) {
                    PlaybackPreferences.setAutoSkipIntro(value,
                        serverName: server);
                    setState(() => _autoSkipIntro = value);
                  },
                ),
              ),
              Card(
                child: ListTile(
                  leading: const Icon(Icons.high_quality_outlined),
                  title: Text(loc.maxQuality),
                  subtitle: Text(loc.maxQualityDescription),
                  trailing: DropdownButton<int?>(
                    value: _maxVideoHeight,
                    onChanged: (value) {
                      PlaybackPreferences.setMaxVideoHeight(value,
                          serverName: server);
                      setState(() => _maxVideoHeight = value);
                    },
                    items: [
                      DropdownMenuItem(value: null, child: Text(loc.qualityAuto)),
                      const DropdownMenuItem(value: 720, child: Text('720p')),
                      const DropdownMenuItem(value: 480, child: Text('480p')),
                    ],
                  ),
                ),
              ),
              if (_showDisplaySettings) ...[
                Card(
                  child: SwitchListTile(
                    secondary: const Icon(Icons.hdr_on_outlined),
                    title: Text(loc.realHdr),
                    subtitle: Text(loc.realHdrDescription),
                    value: _realHdr,
                    onChanged: (value) {
                      DisplayPreferences.setRealHdr(value);
                      setState(() => _realHdr = value);
                    },
                  ),
                ),
                Card(
                  child: SwitchListTile(
                    secondary: const Icon(Icons.slow_motion_video_outlined),
                    title: Text(loc.matchFrameRate),
                    subtitle: Text(loc.matchFrameRateDescription),
                    value: _matchFrameRate,
                    onChanged: (value) {
                      DisplayPreferences.setMatchFrameRate(value);
                      setState(() => _matchFrameRate = value);
                    },
                  ),
                ),
              ],
            ],
          );
        },
      ),
    );
  }
}

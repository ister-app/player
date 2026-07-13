import 'package:auto_route/auto_route.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
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
  int? _maxVideoHeight;
  late Future<void> _preferencesFuture;

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
    if (!mounted) return;
    setState(() {
      _directPlay = directPlay;
      _transcode = transcode;
      _maxVideoHeight = maxVideoHeight;
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
            ],
          );
        },
      ),
    );
  }
}

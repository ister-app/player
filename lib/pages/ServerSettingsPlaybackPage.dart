import 'package:auto_route/auto_route.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:player/utils/PlaybackPreferences.dart';

import '../l10n/app_localizations.dart';

@RoutePage()
class ServerSettingsPlaybackPage extends StatefulWidget {
  const ServerSettingsPlaybackPage({
    super.key,
    @PathParam.inherit('serverName') required String serverName,
  });

  @override
  State<ServerSettingsPlaybackPage> createState() =>
      _ServerSettingsPlaybackPageState();
}

class _ServerSettingsPlaybackPageState
    extends State<ServerSettingsPlaybackPage> {
  bool _directPlay = true;
  bool _transcode = true;
  late Future<void> _preferencesFuture;

  @override
  void initState() {
    super.initState();
    _preferencesFuture = _loadPreferences();
  }

  Future<void> _loadPreferences() async {
    final directPlay = await PlaybackPreferences.getDirectPlay();
    final transcode = await PlaybackPreferences.getTranscode();
    if (!mounted) return;
    setState(() {
      _directPlay = directPlay;
      _transcode = transcode;
    });
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;

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
                    PlaybackPreferences.setDirectPlay(value);
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
                          PlaybackPreferences.setTranscode(value);
                          setState(() => _transcode = value);
                        },
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:player/l10n/app_localizations.dart';
import 'package:player/utils/download/DownloadModels.dart';
import 'package:player/utils/download/DownloadPreferences.dart';
import 'package:player/utils/download/DownloadService.dart';
import 'package:player/utils/download/MusicCachePreferences.dart';
import 'package:player/utils/download/MusicCacheService.dart';
import 'package:player/pages/DownloadsPage.dart' show formatBytes;

@RoutePage()
class DownloadSettingsPage extends StatefulWidget {
  const DownloadSettingsPage({
    super.key,
    @PathParam('serverName') required this.serverName,
  });

  final String serverName;

  @override
  State<DownloadSettingsPage> createState() => _DownloadSettingsPageState();
}

class _DownloadSettingsPageState extends State<DownloadSettingsPage> {
  DownloadVideoQuality _videoQuality = DownloadVideoQuality.original;
  DownloadAudioQuality _audioQuality = DownloadAudioQuality.original;
  bool _subtitles = true;
  bool _unmeteredOnly = true;
  int _concurrent = 1;
  int _nextCount = 5;
  MusicCacheSettings _cache = MusicCacheSettings(maxBytes: MusicCachePreferences.defaultMaxBytes);
  bool _loaded = false;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final s = widget.serverName;
    final values = await Future.wait<Object>([
      DownloadPreferences.getVideoQuality(s),
      DownloadPreferences.getAudioQuality(s),
      DownloadPreferences.getDownloadSubtitles(s),
      DownloadPreferences.getUnmeteredOnly(s),
      DownloadPreferences.getConcurrent(s),
      DownloadPreferences.getDefaultNextCount(s),
      MusicCachePreferences.get(s),
    ]);
    if (!mounted) return;
    setState(() {
      _videoQuality = values[0] as DownloadVideoQuality;
      _audioQuality = values[1] as DownloadAudioQuality;
      _subtitles = values[2] as bool;
      _unmeteredOnly = values[3] as bool;
      _concurrent = values[4] as int;
      _nextCount = values[5] as int;
      _cache = values[6] as MusicCacheSettings;
      _loaded = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    final server = widget.serverName;
    return Scaffold(
      appBar: AppBar(title: Text(loc.downloadSettings)),
      body: !_loaded
          ? const Center(child: CircularProgressIndicator())
          : ListView(
              padding: const EdgeInsets.all(16),
              children: [
                Card(
                  child: Column(
                    children: [
                      ListTile(
                        leading: const Icon(Icons.high_quality_outlined),
                        title: Text(loc.videoDownloadQuality),
                        subtitle: Text(loc.videoDownloadQualityDescription),
                        trailing: DropdownButton<DownloadVideoQuality>(
                          value: _videoQuality,
                          onChanged: (v) {
                            if (v == null) return;
                            DownloadPreferences.setVideoQuality(server, v);
                            setState(() => _videoQuality = v);
                          },
                          items: [
                            DropdownMenuItem(
                                value: DownloadVideoQuality.original,
                                child: Text(loc.qualityOriginal)),
                            const DropdownMenuItem(
                                value: DownloadVideoQuality.p720,
                                child: Text('720p')),
                            const DropdownMenuItem(
                                value: DownloadVideoQuality.p480,
                                child: Text('480p')),
                          ],
                        ),
                      ),
                      const Divider(height: 1, indent: 56),
                      ListTile(
                        leading: const Icon(Icons.music_note_outlined),
                        title: Text(loc.audioDownloadQuality),
                        trailing: DropdownButton<DownloadAudioQuality>(
                          value: _audioQuality,
                          onChanged: (v) {
                            if (v == null) return;
                            DownloadPreferences.setAudioQuality(server, v);
                            setState(() => _audioQuality = v);
                          },
                          items: [
                            DropdownMenuItem(
                                value: DownloadAudioQuality.original,
                                child: Text(loc.qualityOriginal)),
                            DropdownMenuItem(
                                value: DownloadAudioQuality.compact,
                                child: Text(loc.qualityCompact)),
                          ],
                        ),
                      ),
                      const Divider(height: 1, indent: 56),
                      SwitchListTile(
                        secondary: const Icon(Icons.subtitles_outlined),
                        title: Text(loc.downloadSubtitles),
                        value: _subtitles,
                        onChanged: (v) {
                          DownloadPreferences.setDownloadSubtitles(server, v);
                          setState(() => _subtitles = v);
                        },
                      ),
                      const Divider(height: 1, indent: 56),
                      SwitchListTile(
                        secondary: const Icon(Icons.wifi),
                        title: Text(loc.unmeteredOnly),
                        subtitle: Text(loc.unmeteredOnlySubtitle),
                        value: _unmeteredOnly,
                        onChanged: (v) {
                          DownloadPreferences.setUnmeteredOnly(server, v);
                          setState(() => _unmeteredOnly = v);
                        },
                      ),
                      const Divider(height: 1, indent: 56),
                      ListTile(
                        leading: const Icon(Icons.swap_vert),
                        title: Text(loc.concurrentDownloads),
                        trailing: DropdownButton<int>(
                          value: _concurrent,
                          onChanged: (v) {
                            if (v == null) return;
                            DownloadPreferences.setConcurrent(server, v);
                            setState(() => _concurrent = v);
                          },
                          items: const [
                            DropdownMenuItem(value: 1, child: Text('1')),
                            DropdownMenuItem(value: 2, child: Text('2')),
                          ],
                        ),
                      ),
                      const Divider(height: 1, indent: 56),
                      ListTile(
                        leading: const Icon(Icons.format_list_numbered),
                        title: Text(loc.defaultNextCount),
                        trailing: DropdownButton<int>(
                          value: _nextCount,
                          onChanged: (v) {
                            if (v == null) return;
                            DownloadPreferences.setDefaultNextCount(server, v);
                            setState(() => _nextCount = v);
                          },
                          items: const [
                            DropdownMenuItem(value: 1, child: Text('1')),
                            DropdownMenuItem(value: 3, child: Text('3')),
                            DropdownMenuItem(value: 5, child: Text('5')),
                            DropdownMenuItem(value: 10, child: Text('10')),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                Padding(
                  padding: const EdgeInsets.fromLTRB(8, 8, 8, 4),
                  child: Text(loc.musicCache,
                      style: Theme.of(context).textTheme.titleMedium),
                ),
                Card(
                  child: Column(
                    children: [
                      SwitchListTile(
                        secondary: const Icon(Icons.library_music_outlined),
                        title: Text(loc.musicCacheEnabled),
                        subtitle: Text(loc.musicCacheDescription),
                        value: _cache.enabled,
                        onChanged: (v) => _setCacheEnabled(context, v),
                      ),
                      const Divider(height: 1, indent: 56),
                      ListTile(
                        leading: const Icon(Icons.format_list_numbered),
                        title: Text(loc.musicCacheMaxTracks),
                        trailing: DropdownButton<int>(
                          value: _cache.maxTracks,
                          onChanged: _cache.enabled
                              ? (v) => _saveCache(_cache.copyWith(maxTracks: v))
                              : null,
                          items: [
                            for (final n in const [100, 250, 500, 1000, 2000])
                              DropdownMenuItem(value: n, child: Text('$n')),
                          ],
                        ),
                      ),
                      const Divider(height: 1, indent: 56),
                      ListTile(
                        leading: const Icon(Icons.sd_storage_outlined),
                        title: Text(loc.musicCacheMaxSize),
                        trailing: DropdownButton<int>(
                          value: _cache.maxBytes,
                          onChanged: _cache.enabled
                              ? (v) => _saveCache(_cache.copyWith(maxBytes: v))
                              : null,
                          items: [
                            for (final g in const [1, 2, 5, 10, 20, 50])
                              DropdownMenuItem(
                                  value: g * MusicCachePreferences.gb,
                                  child: Text('$g GB')),
                            if (![1, 2, 5, 10, 20, 50]
                                .map((g) => g * MusicCachePreferences.gb)
                                .contains(_cache.maxBytes))
                              DropdownMenuItem(
                                  value: _cache.maxBytes,
                                  child: Text(formatBytes(_cache.maxBytes))),
                          ],
                        ),
                      ),
                      const Divider(height: 1, indent: 56),
                      ListTile(
                        leading: const Icon(Icons.music_note_outlined),
                        title: Text(loc.musicCacheQuality),
                        trailing: DropdownButton<DownloadAudioQuality>(
                          value: _cache.quality,
                          onChanged: _cache.enabled
                              ? (v) => _saveCache(_cache.copyWith(quality: v))
                              : null,
                          items: [
                            DropdownMenuItem(
                                value: DownloadAudioQuality.original,
                                child: Text(loc.qualityOriginal)),
                            DropdownMenuItem(
                                value: DownloadAudioQuality.compact,
                                child: Text(loc.qualityCompact)),
                          ],
                        ),
                      ),
                      const Divider(height: 1, indent: 56),
                      ListTile(
                        leading: const Icon(Icons.cloud_download_outlined),
                        title: Text(loc.fillCacheNow),
                        enabled: _cache.enabled,
                        onTap: _cache.enabled
                            ? () => MusicCacheService.instance.run(server)
                            : null,
                      ),
                      const Divider(height: 1, indent: 56),
                      ListTile(
                        leading: const Icon(Icons.delete_outline),
                        title: Text(loc.clearMusicCache),
                        onTap: () => MusicCacheService.instance.clear(server),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                Card(
                  child: ListTile(
                    leading: Icon(Icons.delete_sweep_outlined,
                        color: Theme.of(context).colorScheme.error),
                    title: Text(loc.clearAllDownloads),
                    onTap: () => _clearAll(context),
                  ),
                ),
              ],
            ),
    );
  }

  Future<void> _saveCache(MusicCacheSettings next) async {
    setState(() => _cache = next);
    await MusicCachePreferences.save(widget.serverName, next);
    if (next.enabled) MusicCacheService.instance.schedule(widget.serverName, delay: Duration.zero);
  }

  Future<void> _setCacheEnabled(BuildContext context, bool enabled) async {
    if (enabled) {
      await _saveCache(_cache.copyWith(enabled: true));
      return;
    }
    final loc = AppLocalizations.of(context)!;
    final hasCached = DownloadService.instance
        .entriesFor(widget.serverName)
        .any((e) => !e.pinned);
    var remove = false;
    if (hasCached) {
      final choice = await showDialog<bool>(
        context: context,
        builder: (context) => AlertDialog(
          title: Text(loc.musicCacheDisableTitle),
          content: Text(loc.musicCacheDisableBody),
          actions: [
            TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: Text(loc.musicCacheDisableKeep)),
            FilledButton(
                onPressed: () => Navigator.of(context).pop(true),
                child: Text(loc.musicCacheDisableRemove)),
          ],
        ),
      );
      if (choice == null) return;
      remove = choice;
    }
    await _saveCache(_cache.copyWith(enabled: false));
    if (remove) await MusicCacheService.instance.clear(widget.serverName);
  }

  Future<void> _clearAll(BuildContext context) async {
    final loc = AppLocalizations.of(context)!;
    final ok = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(loc.clearAllDownloads),
        content: Text(loc.clearAllDownloadsConfirm),
        actions: [
          TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: Text(loc.cancel)),
          FilledButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: Text(loc.clearAllDownloads)),
        ],
      ),
    );
    if (ok == true) {
      await DownloadService.instance.removeAll(widget.serverName);
    }
  }
}

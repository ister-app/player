import 'dart:async';
import 'dart:io';

import 'package:auto_route/auto_route.dart';
import 'package:file_picker/file_picker.dart';
import 'package:material_ui/material_ui.dart';
import 'package:player/utils/games/GameLibraryService.dart';
import 'package:player/utils/games/GameSettings.dart';
import 'package:player/utils/games/launch/EmulatorRegistry.dart';
import 'package:player/utils/games/steam/SteamLibraryLocator.dart';
import 'package:player/utils/upload/UploadSource.dart' show uploadSourceSupported;

import '../components/SettingsSection.dart';
import '../l10n/app_localizations.dart';

/// Where games are installed, which emulators were found (and overrides when
/// detection is wrong), and the save/achievement sync switches. Device-local.
@RoutePage()
class GameSettingsPage extends StatefulWidget {
  const GameSettingsPage({
    super.key,
    @PathParam.inherit('serverName') required this.serverName,
    this.steamLibraries,
    this.pickDirectory,
  });

  final String serverName;

  /// Test seams.
  final Future<List<SteamLibrary>> Function()? steamLibraries;
  final Future<String?> Function()? pickDirectory;

  @override
  State<GameSettingsPage> createState() => _GameSettingsPageState();
}

class _GameSettingsPageState extends State<GameSettingsPage> {
  final GameLibraryService _service = GameLibraryService.instance;
  String? _gamesRoot;
  String? _defaultRoot;
  final Map<EmulatorKind, EmulatorLocation?> _found = {};
  final Map<EmulatorKind, String?> _overrides = {};
  bool _saveSync = true;
  bool _achievementSync = true;
  bool _loading = true;

  /// Where the upload page looks for games: the user's folders (or the
  /// defaults when none are set) and the Steam libraries found on their own.
  List<String> _sources = const [];
  List<String> _defaultSources = const [];
  bool _sourcesAreDefaults = true;
  List<String> _steamLibraries = const [];

  @override
  void initState() {
    super.initState();
    unawaited(_load());
  }

  Future<void> _load({bool refresh = false}) async {
    final root = await GameSettings.gamesRoot();
    final defaultRoot = await GameSettings.defaultGamesRoot();
    for (final kind in EmulatorKind.values) {
      _overrides[kind] = await GameSettings.emulatorPath(kind.name);
      _found[kind] = await _service.registry.find(kind, refresh: refresh);
    }
    final saveSync = await GameSettings.saveSyncEnabled();
    final achievementSync = await GameSettings.achievementSyncEnabled();
    final configured = await GameSettings.uploadSourceFolders();
    final defaults = GameSettings.defaultUploadSourceFolders();
    final steam = widget.steamLibraries == null ? await SteamLibraryLocator().libraries() : await widget.steamLibraries!();
    if (!mounted) return;
    setState(() {
      _gamesRoot = root.path;
      _defaultRoot = defaultRoot;
      _sources = configured.isNotEmpty ? configured : defaults;
      _defaultSources = defaults;
      _sourcesAreDefaults = configured.isEmpty;
      _steamLibraries = [for (final l in steam) l.path];
      _saveSync = saveSync;
      _achievementSync = achievementSync;
      _loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(title: Text(loc.gameSettings)),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : ListView(
              padding: const EdgeInsets.all(16),
              children: [
                SettingsSection(
                  title: loc.gameSettingsStorage,
                  children: [
                    ListTile(
                      key: const ValueKey('game-settings-root'),
                      leading: const Icon(Icons.folder_outlined),
                      title: Text(loc.gameSettingsRoot),
                      subtitle: Text('${_gamesRoot ?? ''}\n${loc.gameSettingsRootChangedHint}'),
                      isThreeLine: true,
                      trailing: Wrap(children: [
                        if (_gamesRoot != _defaultRoot)
                          TextButton(onPressed: () => unawaited(_setRoot(null)), child: Text(loc.gameSettingsResetDefault)),
                        IconButton(icon: const Icon(Icons.edit_outlined), onPressed: () => unawaited(_pickRoot())),
                      ]),
                    ),
                  ],
                ),
                SettingsSection(
                  title: loc.gameSettingsEmulators,
                  hint: loc.gameSettingsEmulatorsHint,
                  children: [
                    for (final kind in EmulatorKind.values) _emulatorTile(loc, kind),
                    ListTile(
                      leading: const Icon(Icons.refresh),
                      title: Text(loc.gameSettingsRedetect),
                      onTap: () {
                        _service.registry.invalidate();
                        unawaited(_load(refresh: true));
                      },
                    ),
                  ],
                ),
                if (uploadSourceSupported) _sourcesSection(loc),
                SettingsSection(
                  title: loc.gameSettingsSync,
                  children: [
                    SwitchListTile(
                      key: const ValueKey('game-settings-save-sync'),
                      secondary: const Icon(Icons.cloud_sync_outlined),
                      title: Text(loc.gameSettingsSaveSync),
                      subtitle: Text(loc.gameSettingsSaveSyncSubtitle),
                      value: _saveSync,
                      onChanged: (value) async {
                        await GameSettings.setSaveSyncEnabled(value);
                        if (mounted) setState(() => _saveSync = value);
                      },
                    ),
                    SwitchListTile(
                      key: const ValueKey('game-settings-achievement-sync'),
                      secondary: const Icon(Icons.emoji_events_outlined),
                      title: Text(loc.gameSettingsAchievementSync),
                      subtitle: Text(loc.gameSettingsAchievementSyncSubtitle),
                      value: _achievementSync,
                      onChanged: (value) async {
                        await GameSettings.setAchievementSyncEnabled(value);
                        if (mounted) setState(() => _achievementSync = value);
                      },
                    ),
                  ],
                ),
              ],
            ),
    );
  }

  Widget _emulatorTile(AppLocalizations loc, EmulatorKind kind) {
    final found = _found[kind];
    final override = _overrides[kind];
    final name = switch (kind) {
      EmulatorKind.retroarch => 'RetroArch',
      EmulatorKind.rpcs3 => 'RPCS3',
      EmulatorKind.steam => 'Steam',
    };
    final subtitle = found == null
        ? loc.gameSettingsNotFound
        : found.overridden
            ? loc.gameSettingsManual(found.command)
            : loc.gameSettingsDetected(found.command);
    return ListTile(
      key: ValueKey('game-settings-emulator-${kind.name}'),
      leading: Icon(found == null ? Icons.error_outline : Icons.check_circle_outline,
          color: found == null ? Theme.of(context).colorScheme.error : null),
      title: Text(name),
      subtitle: Text(subtitle),
      trailing: Wrap(children: [
        if (override != null)
          TextButton(onPressed: () => unawaited(_setOverride(kind, null)), child: Text(loc.gameSettingsResetDefault)),
        IconButton(
          tooltip: loc.gameSettingsPickExecutable,
          icon: const Icon(Icons.edit_outlined),
          onPressed: () => unawaited(_pickExecutable(kind)),
        ),
      ]),
    );
  }

  Widget _sourcesSection(AppLocalizations loc) {
    final theme = Theme.of(context);
    return SettingsSection(
      title: loc.gameSettingsSources,
      hint: loc.gameSettingsSourcesHint,
      children: [
        for (final folder in _sources)
          ListTile(
            key: ValueKey('game-settings-source-$folder'),
            leading: Icon(
              Directory(folder).existsSync() ? Icons.folder_outlined : Icons.folder_off_outlined,
              color: Directory(folder).existsSync() ? null : theme.colorScheme.error,
            ),
            title: Text(folder),
            subtitle: _sourcesAreDefaults
                ? Text(loc.gameSettingsSourceDefault)
                : Directory(folder).existsSync()
                    ? null
                    : Text(loc.gameSettingsSourceMissing),
            trailing: _sourcesAreDefaults
                ? null
                : IconButton(
                    key: ValueKey('game-settings-source-remove-$folder'),
                    icon: const Icon(Icons.close),
                    onPressed: () => unawaited(_setSources([for (final f in _sources) if (f != folder) f])),
                  ),
          ),
        ListTile(
          key: const ValueKey('game-settings-source-add'),
          leading: const Icon(Icons.create_new_folder_outlined),
          title: Text(loc.gameSettingsAddSource),
          onTap: () => unawaited(_addSource()),
        ),
        if (!_sourcesAreDefaults && _defaultSources.isNotEmpty)
          ListTile(
            leading: const Icon(Icons.restore),
            title: Text(loc.gameSettingsResetDefault),
            onTap: () => unawaited(_setSources(const [])),
          ),
        ListTile(
          dense: true,
          leading: const Icon(Icons.info_outline),
          title: Text(
            _steamLibraries.isEmpty ? loc.gameSettingsSteamNone : loc.gameSettingsSteamLibraries(_steamLibraries.join(', ')),
            style: theme.textTheme.bodySmall,
          ),
        ),
      ],
    );
  }

  Future<void> _addSource() async {
    final picked = await (widget.pickDirectory ?? FilePicker.getDirectoryPath)();
    if (picked == null || picked.isEmpty) return;
    // Adding to the defaults keeps them: the user list starts as a copy.
    final current = _sourcesAreDefaults ? _defaultSources : _sources;
    if (current.contains(picked)) return;
    await _setSources([...current, picked]);
  }

  Future<void> _setSources(List<String> folders) async {
    await GameSettings.setUploadSourceFolders(folders);
    await _load();
  }

  Future<void> _pickRoot() async {
    final picked = await FilePicker.getDirectoryPath();
    if (picked != null) await _setRoot(picked);
  }

  Future<void> _setRoot(String? path) async {
    await GameSettings.setGamesRoot(path);
    // The installs under the old folder are not under the new one.
    _service.store.invalidate();
    _service.revision.value++;
    await _load();
  }

  Future<void> _pickExecutable(EmulatorKind kind) async {
    final result = await FilePicker.pickFiles(dialogTitle: AppLocalizations.of(context)!.gameSettingsPickExecutable);
    final path = result.isEmpty ? null : result.single.path;
    if (path != null) await _setOverride(kind, path);
  }

  Future<void> _setOverride(EmulatorKind kind, String? path) async {
    await GameSettings.setEmulatorPath(kind.name, path);
    _service.registry.invalidate();
    await _load(refresh: true);
  }
}

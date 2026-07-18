import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:player/graphql/schema.graphql.dart';
import 'package:player/utils/SharingSettingsService.dart';

import '../l10n/app_localizations.dart';

/// Lets a user decide who may see their now-playing sessions and who may remote-control them.
/// Now-playing defaults to everyone; remote control defaults to private. Either scope can be an
/// allowlist of specific users, picked from [SharingSettingsService.shareableUsers].
@RoutePage()
class ServerSettingsSharingPage extends StatefulWidget {
  const ServerSettingsSharingPage({
    super.key,
    @PathParam.inherit('serverName') required this.serverName,
  });

  final String serverName;

  @override
  State<ServerSettingsSharingPage> createState() =>
      _ServerSettingsSharingPageState();
}

class _ServerSettingsSharingPageState extends State<ServerSettingsSharingPage> {
  late Future<void> _loadFuture;
  PlaybackSharingSettings? _settings;
  List<ShareableUser> _users = const [];
  bool _saving = false;

  @override
  void initState() {
    super.initState();
    _loadFuture = _load();
  }

  Future<void> _load() async {
    final service = SharingSettingsService();
    final settings = await service.settingsFor(widget.serverName);
    final users = await service.shareableUsers(widget.serverName);
    if (!mounted) return;
    setState(() {
      _settings = settings;
      _users = users;
    });
  }

  Future<void> _save(PlaybackSharingSettings updated) async {
    final previous = _settings;
    setState(() {
      _settings = updated;
      _saving = true;
    });
    try {
      final stored =
          await SharingSettingsService().save(widget.serverName, updated);
      if (!mounted) return;
      setState(() => _settings = stored);
    } catch (_) {
      if (!mounted) return;
      setState(() => _settings = previous);
      final loc = AppLocalizations.of(context)!;
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(loc.sharingCouldNotSave)));
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(title: Text(loc.sharingSettings)),
      body: FutureBuilder<void>(
        future: _loadFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          final settings = _settings;
          if (snapshot.hasError || settings == null) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(loc.sharingCouldNotLoad),
              ),
            );
          }
          return ListView(
            padding: const EdgeInsets.all(16.0),
            children: [
              _nowPlayingCard(loc, settings),
              const SizedBox(height: 8),
              _remoteControlCard(loc, settings),
            ],
          );
        },
      ),
    );
  }

  Widget _nowPlayingCard(AppLocalizations loc, PlaybackSharingSettings s) {
    return Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ListTile(
            leading: const Icon(Icons.visibility_outlined),
            title: Text(loc.nowPlayingVisibility),
            subtitle: Text(loc.nowPlayingVisibilityDescription),
            trailing: DropdownButton<Enum$SharingScope>(
              value: s.nowPlayingScope,
              onChanged: _saving
                  ? null
                  : (value) {
                      if (value != null) {
                        _save(s.copyWith(nowPlayingScope: value));
                      }
                    },
              items: [
                DropdownMenuItem(
                    value: Enum$SharingScope.EVERYONE,
                    child: Text(loc.sharingScopeEveryone)),
                DropdownMenuItem(
                    value: Enum$SharingScope.ALLOWLIST,
                    child: Text(loc.sharingScopeAllowlist)),
                DropdownMenuItem(
                    value: Enum$SharingScope.PRIVATE,
                    child: Text(loc.sharingScopePrivate)),
              ],
            ),
          ),
          if (s.nowPlayingScope == Enum$SharingScope.ALLOWLIST)
            _allowlistPicker(
              loc,
              selected: s.nowPlayingAllowedUserIds,
              onChanged: (ids) =>
                  _save(s.copyWith(nowPlayingAllowedUserIds: ids)),
            ),
        ],
      ),
    );
  }

  Widget _remoteControlCard(AppLocalizations loc, PlaybackSharingSettings s) {
    return Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ListTile(
            leading: const Icon(Icons.settings_remote_outlined),
            title: Text(loc.remoteControlSharing),
            subtitle: Text(loc.remoteControlSharingDescription),
            trailing: DropdownButton<Enum$RemoteControlScope>(
              value: s.controlScope,
              onChanged: _saving
                  ? null
                  : (value) {
                      if (value != null) {
                        _save(s.copyWith(controlScope: value));
                      }
                    },
              items: [
                DropdownMenuItem(
                    value: Enum$RemoteControlScope.PRIVATE,
                    child: Text(loc.sharingScopePrivate)),
                DropdownMenuItem(
                    value: Enum$RemoteControlScope.EVERYONE,
                    child: Text(loc.sharingScopeEveryone)),
                DropdownMenuItem(
                    value: Enum$RemoteControlScope.ALLOWLIST,
                    child: Text(loc.sharingScopeAllowlist)),
                DropdownMenuItem(
                    value: Enum$RemoteControlScope.SAME_AS_NOW_PLAYING,
                    child: Text(loc.sharingScopeSameAsNowPlaying)),
              ],
            ),
          ),
          if (s.controlScope == Enum$RemoteControlScope.ALLOWLIST)
            _allowlistPicker(
              loc,
              selected: s.controlAllowedUserIds,
              onChanged: (ids) => _save(s.copyWith(controlAllowedUserIds: ids)),
            ),
        ],
      ),
    );
  }

  Widget _allowlistPicker(
    AppLocalizations loc, {
    required List<String> selected,
    required ValueChanged<List<String>> onChanged,
  }) {
    if (_users.isEmpty) {
      return Padding(
        padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
        child: Text(loc.sharingNoOtherUsers),
      );
    }
    final selectedSet = selected.toSet();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 4),
          child: Text(loc.sharingChoosePeople,
              style: Theme.of(context).textTheme.labelLarge),
        ),
        for (final user in _users)
          CheckboxListTile(
            dense: true,
            value: selectedSet.contains(user.id),
            title: Text(user.name ?? user.id),
            onChanged: _saving
                ? null
                : (checked) {
                    final next = selected.toList();
                    if (checked == true) {
                      if (!next.contains(user.id)) next.add(user.id);
                    } else {
                      next.remove(user.id);
                    }
                    onChanged(next);
                  },
          ),
        const SizedBox(height: 8),
      ],
    );
  }
}

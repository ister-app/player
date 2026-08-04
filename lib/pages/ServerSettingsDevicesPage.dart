import 'dart:async';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:player/components/DevicePickerSheet.dart';
import 'package:player/graphql/serverActivitySnapshot.graphql.dart';
import 'package:player/utils/ClientManager.dart';
import 'package:player/utils/DevicePreferences.dart';
import 'package:player/utils/DeviceService.dart';

import '../l10n/app_localizations.dart';

/// The user's registered devices on this server: name, platform, a live online dot and the
/// last-online time, with rename/remove. Refreshes every 15s so the online dots track the
/// server's presence registry (60s expiry) without a dedicated subscription.
@RoutePage()
class ServerSettingsDevicesPage extends StatefulWidget {
  const ServerSettingsDevicesPage({
    super.key,
    @PathParam.inherit('serverName') required this.serverName,
  });

  final String serverName;

  @override
  State<ServerSettingsDevicesPage> createState() =>
      _ServerSettingsDevicesPageState();
}

class _ServerSettingsDevicesPageState extends State<ServerSettingsDevicesPage> {
  List<DeviceInfo>? _devices;

  /// Titles of what each device is playing right now, by deviceId.
  Map<String, String> _nowPlayingTitles = const {};
  bool _loadFailed = false;
  bool _busy = false;
  Timer? _refreshTimer;

  @override
  void initState() {
    super.initState();
    _refresh();
    _refreshTimer =
        Timer.periodic(const Duration(seconds: 15), (_) => _refresh());
  }

  @override
  void dispose() {
    _refreshTimer?.cancel();
    super.dispose();
  }

  Future<void> _refresh() async {
    try {
      final devices = await DeviceService.instance.myDevices(widget.serverName);
      final titles = await _loadNowPlayingTitles();
      if (!mounted) return;
      setState(() {
        _devices = devices;
        _nowPlayingTitles = titles;
        _loadFailed = false;
      });
    } catch (_) {
      if (!mounted) return;
      // Keep showing the last known list; only report failure when empty-handed.
      setState(() => _loadFailed = _devices == null);
    }
  }

  Future<Map<String, String>> _loadNowPlayingTitles() async {
    try {
      final client = ClientManager.getClientForUrl(widget.serverName).value;
      final result = await client.query(QueryOptions(
        document: documentNodeQueryserverActivitySnapshot,
        fetchPolicy: FetchPolicy.networkOnly,
      ));
      if (result.hasException || result.data == null) return const {};
      final sessions = Query$serverActivitySnapshot.fromJson(result.data!)
          .serverActivitySnapshot
          .nowPlaying;
      return {
        for (final s in sessions)
          if (s.deviceId != null && s.title != null) s.deviceId!: s.title!,
      };
    } catch (_) {
      return const {};
    }
  }

  Future<void> _rename(DeviceInfo device) async {
    final loc = AppLocalizations.of(context)!;
    final controller = TextEditingController(text: device.name);
    final name = await showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(loc.deviceRename),
        content: TextField(
          controller: controller,
          autofocus: true,
          onSubmitted: (value) => Navigator.of(context).pop(value),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(MaterialLocalizations.of(context).cancelButtonLabel),
          ),
          FilledButton(
            onPressed: () => Navigator.of(context).pop(controller.text),
            child: Text(MaterialLocalizations.of(context).okButtonLabel),
          ),
        ],
      ),
    );
    final trimmed = name?.trim();
    if (trimmed == null || trimmed.isEmpty || trimmed == device.name) return;

    setState(() => _busy = true);
    try {
      final renamed = await DeviceService.instance
          .rename(widget.serverName, device.deviceId, trimmed);
      if (renamed != null && device.isThisDevice) {
        await DevicePreferences.setDeviceName(trimmed);
      }
      await _refresh();
    } catch (_) {
      if (mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(loc.deviceCouldNotSave)));
      }
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Future<void> _remove(DeviceInfo device) async {
    final loc = AppLocalizations.of(context)!;
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(loc.deviceRemove),
        content: Text(device.isThisDevice
            ? loc.deviceRemoveThisDeviceConfirm(device.name)
            : loc.deviceRemoveConfirm(device.name)),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text(MaterialLocalizations.of(context).cancelButtonLabel),
          ),
          FilledButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: Text(loc.deviceRemove),
          ),
        ],
      ),
    );
    if (confirmed != true) return;

    setState(() => _busy = true);
    try {
      await DeviceService.instance.remove(widget.serverName, device.deviceId);
      await _refresh();
    } catch (_) {
      if (mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(loc.deviceCouldNotSave)));
      }
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    final devices = _devices;
    return Scaffold(
      appBar: AppBar(title: Text(loc.devicesTitle)),
      body: devices == null
          ? Center(
              child: _loadFailed
                  ? Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Text(loc.deviceCouldNotLoad),
                    )
                  : const CircularProgressIndicator(),
            )
          : ListView(
              padding: const EdgeInsets.all(16.0),
              children: [
                if (devices.isEmpty)
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text(loc.deviceNoDevices),
                  )
                else
                  Card(
                    child: Column(
                      children: [
                        for (var i = 0; i < devices.length; i++) ...[
                          if (i > 0) const Divider(height: 1, indent: 56),
                          _deviceTile(loc, devices[i]),
                        ],
                      ],
                    ),
                  ),
              ],
            ),
    );
  }

  Widget _deviceTile(AppLocalizations loc, DeviceInfo device) {
    final nowPlaying = _nowPlayingTitles[device.deviceId];
    return ListTile(
      leading: Icon(devicePlatformIcon(device.platform)),
      title: Row(
        children: [
          Flexible(child: Text(device.name, overflow: TextOverflow.ellipsis)),
          const SizedBox(width: 8),
          _OnlineDot(online: device.online),
          if (device.isThisDevice) ...[
            const SizedBox(width: 8),
            Chip(
              label: Text(loc.deviceThisDevice),
              visualDensity: VisualDensity.compact,
              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
          ],
        ],
      ),
      subtitle: Text(nowPlaying != null
          ? loc.deviceNowPlaying(nowPlaying)
          : _lastSeenLabel(loc, device)),
      trailing: PopupMenuButton<String>(
        enabled: !_busy,
        onSelected: (choice) {
          if (choice == 'rename') _rename(device);
          if (choice == 'remove') _remove(device);
        },
        itemBuilder: (context) => [
          PopupMenuItem(value: 'rename', child: Text(loc.deviceRename)),
          PopupMenuItem(value: 'remove', child: Text(loc.deviceRemove)),
        ],
      ),
    );
  }

  String _lastSeenLabel(AppLocalizations loc, DeviceInfo device) {
    if (device.online) return loc.deviceOnlineNow;
    final lastSeen = device.lastSeenAt;
    if (lastSeen == null) return loc.deviceLastSeenUnknown;
    final elapsed = DateTime.now().toUtc().difference(lastSeen.toUtc());
    if (elapsed.inMinutes < 1) return loc.deviceOnlineNow;
    if (elapsed.inHours < 1) return loc.deviceLastSeenMinutesAgo(elapsed.inMinutes);
    if (elapsed.inDays < 1) return loc.deviceLastSeenHoursAgo(elapsed.inHours);
    return loc.deviceLastSeenDaysAgo(elapsed.inDays);
  }

}

class _OnlineDot extends StatelessWidget {
  const _OnlineDot({required this.online});

  final bool online;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 10,
      height: 10,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: online ? Colors.green : Theme.of(context).disabledColor,
      ),
    );
  }
}

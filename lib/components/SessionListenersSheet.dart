import 'dart:async';

import 'package:flutter/material.dart';
import 'package:player/components/DevicePickerSheet.dart';
import 'package:player/utils/ClientManager.dart';
import 'package:player/utils/PermissionsService.dart';
import 'package:player/utils/PlayQueueService.dart';

import '../l10n/app_localizations.dart';

/// Embeddable list of every device listening along with a session, grouped per
/// user, refreshed while mounted. With [canKick] the owner can remove one
/// device or a whole user again; without it the list is read-only.
///
/// The server answers the full list for the session owner only; for anyone
/// else it may be empty even while people are listening, and an older server
/// without the query cannot answer at all. [hideWhenUnavailable] renders
/// nothing in those cases instead of a misleading "nobody is listening".
class SessionListenersList extends StatefulWidget {
  const SessionListenersList({
    super.key,
    required this.serverName,
    required this.playQueueId,
    this.canKick = false,
    this.hideWhenUnavailable = false,
  });

  final String serverName;
  final String playQueueId;
  final bool canKick;
  final bool hideWhenUnavailable;

  @override
  State<SessionListenersList> createState() => _SessionListenersListState();
}

class _SessionListenersListState extends State<SessionListenersList> {
  /// Followers register on a ~20s heartbeat and expire at 60s, so a short poll keeps the
  /// list honest while the sheet is open.
  static const _refreshInterval = Duration(seconds: 5);

  List<SessionFollower>? _followers;
  bool _failed = false;
  Timer? _refreshTimer;

  @override
  void initState() {
    super.initState();
    _load();
    _refreshTimer = Timer.periodic(_refreshInterval, (_) => _load());
  }

  @override
  void dispose() {
    _refreshTimer?.cancel();
    super.dispose();
  }

  Future<void> _load() async {
    try {
      final client = ClientManager.getClientForUrl(widget.serverName).value;
      final followers =
          await PlayQueueService().sessionFollowers(client, widget.playQueueId);
      if (!mounted) return;
      // A server without the query cannot answer this at all; treat it as a load failure
      // rather than as "nobody is listening".
      setState(() {
        _followers = followers;
        _failed = followers == null;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() => _failed = true);
    }
  }

  Future<void> _remove(String userId, String name, {String? deviceId}) async {
    final loc = AppLocalizations.of(context)!;
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(loc.followerRemove),
        content: Text(loc.followerRemoveConfirm(name)),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text(MaterialLocalizations.of(context).cancelButtonLabel),
          ),
          FilledButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: Text(loc.followerRemove),
          ),
        ],
      ),
    );
    if (confirmed != true || !mounted) return;

    final client = ClientManager.getClientForUrl(widget.serverName).value;
    final removed = await PlayQueueService().removeFollower(
      client,
      playQueueId: widget.playQueueId,
      userId: userId,
      deviceId: deviceId,
    );
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(
            removed ? loc.followerRemoved(name) : loc.followerRemoveFailed)));
    await _load();
  }

  /// Followers per user, the caller's own devices first and the rest by name, so a party
  /// with several listeners reads as a list of people rather than of devices.
  List<MapEntry<String, List<SessionFollower>>> _grouped(
      List<SessionFollower> followers) {
    final groups = <String, List<SessionFollower>>{};
    for (final follower in followers) {
      groups.putIfAbsent(follower.userId, () => []).add(follower);
    }
    final ownId = PermissionsService().cachedUserIdFor(widget.serverName);
    final entries = groups.entries.toList();
    entries.sort((a, b) {
      if (a.key == ownId) return -1;
      if (b.key == ownId) return 1;
      return (a.value.first.userName ?? '')
          .toLowerCase()
          .compareTo((b.value.first.userName ?? '').toLowerCase());
    });
    return entries;
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    final followers = _followers;

    if (widget.hideWhenUnavailable &&
        (_failed || (followers != null && followers.isEmpty))) {
      return const SizedBox.shrink();
    }
    if (_failed) {
      return Padding(
        padding: const EdgeInsets.all(24),
        child: Center(child: Text(loc.followersCouldNotLoad)),
      );
    }
    if (followers == null) {
      return const Padding(
        padding: EdgeInsets.all(32),
        child: Center(child: CircularProgressIndicator()),
      );
    }
    if (followers.isEmpty) {
      return Padding(
        padding: const EdgeInsets.all(24),
        child: Center(child: Text(loc.followersNone)),
      );
    }
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        for (final group in _grouped(followers)) ...[
          ListTile(
            leading: const Icon(Icons.person),
            title: Text(group.value.first.userName ?? loc.followerUnknownUser,
                maxLines: 1, overflow: TextOverflow.ellipsis),
            subtitle: Text(loc.followersListening(group.value.length)),
            trailing: widget.canKick
                ? IconButton(
                    icon: const Icon(Icons.person_remove),
                    tooltip: loc.followerRemoveUser,
                    onPressed: () => _remove(group.key,
                        group.value.first.userName ?? loc.followerUnknownUser),
                  )
                : null,
          ),
          for (final follower in group.value)
            ListTile(
              dense: true,
              contentPadding: const EdgeInsets.only(left: 56, right: 8),
              leading: Icon(follower.platform == null
                  ? Icons.devices_other
                  : devicePlatformIcon(follower.platform!)),
              title: Text(follower.deviceName ?? loc.followerUnknownDevice,
                  maxLines: 1, overflow: TextOverflow.ellipsis),
              trailing: widget.canKick
                  ? IconButton(
                      icon: const Icon(Icons.close),
                      tooltip: loc.followerRemove,
                      onPressed: () => _remove(
                        group.key,
                        follower.deviceName ?? loc.followerUnknownDevice,
                        deviceId: follower.deviceId,
                      ),
                    )
                  : null,
            ),
        ],
      ],
    );
  }
}

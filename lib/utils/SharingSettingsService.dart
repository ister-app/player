import 'dart:async';

import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:player/graphql/fragmentPlaybackSharingSettings.graphql.dart';
import 'package:player/graphql/playbackSharingSettings.graphql.dart';
import 'package:player/graphql/schema.graphql.dart';
import 'package:player/graphql/setSessionSharing.graphql.dart';
import 'package:player/graphql/shareableUsers.graphql.dart';
import 'package:player/graphql/updatePlaybackSharingSettings.graphql.dart';
import 'package:player/utils/ClientManager.dart';

/// A user's playback-session sharing preferences, as the server stores them per account.
///
/// Now-playing visibility defaults to [Enum$SharingScope.EVERYONE] (everyone sees what you play);
/// remote control defaults to [Enum$RemoteControlScope.PRIVATE] (only you). Both carry an allowlist
/// of user ids used when the scope is [Enum$SharingScope.ALLOWLIST] /
/// [Enum$RemoteControlScope.ALLOWLIST].
class PlaybackSharingSettings {
  const PlaybackSharingSettings({
    this.nowPlayingScope = Enum$SharingScope.EVERYONE,
    this.controlScope = Enum$RemoteControlScope.PRIVATE,
    this.nowPlayingAllowedUserIds = const [],
    this.controlAllowedUserIds = const [],
  });

  final Enum$SharingScope nowPlayingScope;
  final Enum$RemoteControlScope controlScope;
  final List<String> nowPlayingAllowedUserIds;
  final List<String> controlAllowedUserIds;

  PlaybackSharingSettings copyWith({
    Enum$SharingScope? nowPlayingScope,
    Enum$RemoteControlScope? controlScope,
    List<String>? nowPlayingAllowedUserIds,
    List<String>? controlAllowedUserIds,
  }) {
    return PlaybackSharingSettings(
      nowPlayingScope: nowPlayingScope ?? this.nowPlayingScope,
      controlScope: controlScope ?? this.controlScope,
      nowPlayingAllowedUserIds:
          nowPlayingAllowedUserIds ?? this.nowPlayingAllowedUserIds,
      controlAllowedUserIds:
          controlAllowedUserIds ?? this.controlAllowedUserIds,
    );
  }
}

/// One user that can be added to a sharing allowlist (identity only).
class ShareableUser {
  const ShareableUser({required this.id, this.name});
  final String id;
  final String? name;
}

/// Reads and writes the account-level sharing preferences and the per-session remote-control
/// override. The server is the source of truth; an in-memory per-server cache lets the settings
/// page render without a flash and is invalidated on save and on server/user switch.
class SharingSettingsService {
  SharingSettingsService._privateConstructor();

  static final SharingSettingsService _instance =
      SharingSettingsService._privateConstructor();

  factory SharingSettingsService() => _instance;

  final Map<String, PlaybackSharingSettings> _cache = {};
  final Map<String, Future<PlaybackSharingSettings>> _inFlight = {};

  /// The sharing settings for [serverName]: from memory, else the server.
  Future<PlaybackSharingSettings> settingsFor(String? serverName) async {
    final server = serverName ?? ClientManager.instance.lastClientUsed;
    if (server == null) return const PlaybackSharingSettings();

    final cached = _cache[server];
    if (cached != null) return cached;

    return _inFlight[server] ??= _load(server).whenComplete(() {
      _inFlight.remove(server);
    });
  }

  Future<PlaybackSharingSettings> _load(String server) async {
    final client = ClientManager.getClientForUrl(server).value;
    final QueryResult result = await client.query(QueryOptions(
      document: documentNodeQueryplaybackSharingSettings,
      fetchPolicy: FetchPolicy.networkOnly,
    ));
    if (result.hasException || result.data == null) {
      throw result.exception ?? Exception('empty playbackSharingSettings response');
    }
    final loaded = _fromFragment(
        Query$playbackSharingSettings.fromJson(result.data!).playbackSharingSettings);
    _cache[server] = loaded;
    return loaded;
  }

  /// Saves the settings on the server and updates the cache. Throws when the server rejects it.
  Future<PlaybackSharingSettings> save(
      String? serverName, PlaybackSharingSettings settings) async {
    final server = serverName ?? ClientManager.instance.lastClientUsed;
    if (server == null) return settings;

    final client = ClientManager.getClientForUrl(server).value;
    final QueryResult result = await client.mutate(MutationOptions(
      document: documentNodeMutationupdatePlaybackSharingSettings,
      variables: Variables$Mutation$updatePlaybackSharingSettings(
              input: _toInput(settings))
          .toJson(),
    ));
    if (result.hasException || result.data == null) {
      throw result.exception ??
          Exception('empty updatePlaybackSharingSettings response');
    }
    final stored = _fromFragment(Mutation$updatePlaybackSharingSettings.fromJson(
            result.data!)
        .updatePlaybackSharingSettings);
    _cache[server] = stored;
    return stored;
  }

  /// The users this account can add to an allowlist (name-only; excludes the caller).
  Future<List<ShareableUser>> shareableUsers(String? serverName) async {
    final server = serverName ?? ClientManager.instance.lastClientUsed;
    if (server == null) return const [];

    final client = ClientManager.getClientForUrl(server).value;
    final QueryResult result = await client.query(QueryOptions(
      document: documentNodeQueryshareableUsers,
      fetchPolicy: FetchPolicy.networkOnly,
    ));
    if (result.hasException || result.data == null) {
      throw result.exception ?? Exception('empty shareableUsers response');
    }
    return Query$shareableUsers.fromJson(result.data!)
        .shareableUsers
        .map((u) => ShareableUser(id: u.id, name: u.name))
        .toList();
  }

  /// Overrides remote-control sharing for one of the caller's own sessions.
  /// [controlScope] null clears the override; [allowedUserIds] is the session's own control
  /// allowlist, used when the scope is [Enum$RemoteControlScope.ALLOWLIST].
  Future<void> setSessionSharing(
    String? serverName,
    String playQueueId, {
    Enum$RemoteControlScope? controlScope,
    List<String>? allowedUserIds,
  }) async {
    final server = serverName ?? ClientManager.instance.lastClientUsed;
    if (server == null) return;

    final client = ClientManager.getClientForUrl(server).value;
    final QueryResult result = await client.mutate(MutationOptions(
      document: documentNodeMutationsetSessionSharing,
      variables: Variables$Mutation$setSessionSharing(
        playQueueId: playQueueId,
        controlScope: controlScope,
        allowedUserIds: allowedUserIds,
      ).toJson(),
    ));
    if (result.hasException) {
      throw result.exception!;
    }
  }

  /// Drops the memory cache so the next read re-queries; used after switching user/server.
  void invalidate(String serverName) => _cache.remove(serverName);

  Input$PlaybackSharingSettingsInput _toInput(PlaybackSharingSettings settings) {
    return Input$PlaybackSharingSettingsInput(
      nowPlayingScope: settings.nowPlayingScope,
      controlScope: settings.controlScope,
      nowPlayingAllowedUserIds: settings.nowPlayingAllowedUserIds,
      controlAllowedUserIds: settings.controlAllowedUserIds,
    );
  }

  PlaybackSharingSettings _fromFragment(
      Fragment$fragmentPlaybackSharingSettings fragment) {
    return PlaybackSharingSettings(
      nowPlayingScope: fragment.nowPlayingScope,
      controlScope: fragment.controlScope,
      nowPlayingAllowedUserIds: List<String>.from(fragment.nowPlayingAllowedUserIds),
      controlAllowedUserIds: List<String>.from(fragment.controlAllowedUserIds),
    );
  }
}

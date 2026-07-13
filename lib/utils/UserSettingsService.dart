import 'dart:async';

import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:player/graphql/fragmentUserSettings.graphql.dart';
import 'package:player/graphql/schema.graphql.dart';
import 'package:player/graphql/updateUserSettings.graphql.dart';
import 'package:player/graphql/userSettings.graphql.dart';
import 'package:player/utils/ClientManager.dart';
import 'package:player/utils/LoggerService.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// A user's playback settings as the server stores them.
class UserSettings {
  const UserSettings({
    this.spokenLanguages = const [],
    this.subtitleLanguages = const [],
    this.directPlay = true,
    this.transcode = true,
    this.maxVideoHeight,
  });

  /// Ordered, most preferred first — the first language with a matching track wins.
  final List<String> spokenLanguages;
  final List<String> subtitleLanguages;
  final bool directPlay;
  final bool transcode;

  /// Highest video variant the server pre-transcodes (720 / 480); null means every variant.
  final int? maxVideoHeight;

  UserSettings copyWith({
    List<String>? spokenLanguages,
    List<String>? subtitleLanguages,
    bool? directPlay,
    bool? transcode,
    int? maxVideoHeight,
    bool clearMaxVideoHeight = false,
  }) {
    return UserSettings(
      spokenLanguages: spokenLanguages ?? this.spokenLanguages,
      subtitleLanguages: subtitleLanguages ?? this.subtitleLanguages,
      directPlay: directPlay ?? this.directPlay,
      transcode: transcode ?? this.transcode,
      maxVideoHeight:
          clearMaxVideoHeight ? null : (maxVideoHeight ?? this.maxVideoHeight),
    );
  }
}

/// Playback settings live on the server, per user, so they follow the account to every device —
/// and so the server knows which audio tracks are worth pre-transcoding (it used to transcode
/// every audio stream of a file, in every bitrate, because it had no idea what you would play).
///
/// SharedPreferences is only a cache here, keyed per server: it lets the app start with the right
/// settings before the query returns, and keeps them working offline. The server is the source of
/// truth; a save writes through to it.
class UserSettingsService {
  UserSettingsService._privateConstructor();

  static final UserSettingsService _instance =
      UserSettingsService._privateConstructor();

  factory UserSettingsService() => _instance;

  static final SharedPreferencesAsync _prefs = SharedPreferencesAsync();

  // Legacy keys: settings used to be global over all servers, stored only on this device.
  static const _kLegacySpoken = 'pref_spoken_languages';
  static const _kLegacySubtitle = 'pref_subtitle_languages';
  static const _kLegacyDirectPlay = 'pref_direct_play';
  static const _kLegacyTranscode = 'pref_transcode';

  final Map<String, UserSettings> _cache = {};
  final Map<String, Future<UserSettings>> _inFlight = {};

  /// The settings for [serverName]: from memory, else the server, else the local cache.
  Future<UserSettings> settingsFor(String? serverName) async {
    final server = serverName ?? ClientManager.instance.lastClientUsed;
    if (server == null) return const UserSettings();

    final cached = _cache[server];
    if (cached != null) return cached;

    return _inFlight[server] ??= _load(server).whenComplete(() {
      _inFlight.remove(server);
    });
  }

  Future<UserSettings> _load(String server) async {
    final local = await _readCache(server);
    final client = ClientManager.getClientForUrl(server).value;
    try {
      final QueryResult result = await client.query(QueryOptions(
        document: documentNodeQueryuserSettings,
        fetchPolicy: FetchPolicy.networkOnly,
      ));
      if (result.hasException || result.data == null) {
        throw result.exception ?? Exception('empty userSettings response');
      }
      final loaded =
          _fromFragment(Query$userSettings.fromJson(result.data!).userSettings);
      // First run against this server while this device still holds the old global settings:
      // those were the user's actual choices, so they win over the server's defaults.
      final migrated = await _migrateLegacySettings(server, loaded, local);
      _cache[server] = migrated;
      await _writeCache(server, migrated);
      return migrated;
    } catch (e) {
      LoggerService().logger.w('Could not load user settings from $server: $e');
      final fallback = local ?? const UserSettings();
      _cache[server] = fallback;
      return fallback;
    }
  }

  /// Saves the settings on the server and updates the caches. Throws when the server rejects it,
  /// so the UI can tell the user their change did not stick.
  Future<UserSettings> save(String? serverName, UserSettings settings) async {
    final server = serverName ?? ClientManager.instance.lastClientUsed;
    if (server == null) return settings;

    final client = ClientManager.getClientForUrl(server).value;
    final QueryResult result = await client.mutate(MutationOptions(
      document: documentNodeMutationupdateUserSettings,
      variables: Variables$Mutation$updateUserSettings(input: _toInput(settings)).toJson(),
    ));
    if (result.hasException || result.data == null) {
      throw result.exception ?? Exception('empty updateUserSettings response');
    }

    final stored = _fromFragment(
        Mutation$updateUserSettings.fromJson(result.data!).updateUserSettings);
    _cache[server] = stored;
    await _writeCache(server, stored);
    return stored;
  }

  /// Drops the memory cache so the next read re-queries; used after switching user/server.
  void invalidate(String serverName) => _cache.remove(serverName);

  Input$UserSettingsInput _toInput(UserSettings settings) {
    return Input$UserSettingsInput(
      preferredAudioLanguages: settings.spokenLanguages,
      preferredSubtitleLanguages: settings.subtitleLanguages,
      directPlay: settings.directPlay,
      transcode: settings.transcode,
      maxVideoHeight: settings.maxVideoHeight,
    );
  }

  UserSettings _fromFragment(Fragment$fragmentUserSettings fragment) {
    return UserSettings(
      spokenLanguages: List<String>.from(fragment.preferredAudioLanguages),
      subtitleLanguages: List<String>.from(fragment.preferredSubtitleLanguages),
      directPlay: fragment.directPlay,
      transcode: fragment.transcode,
      maxVideoHeight: fragment.maxVideoHeight,
    );
  }

  /// Pushes this device's old global settings to a server that has never seen them, once.
  /// After the first migration the legacy keys are removed and the server stays authoritative.
  Future<UserSettings> _migrateLegacySettings(
      String server, UserSettings fromServer, UserSettings? localCache) async {
    if (localCache != null) return fromServer; // this server was synced before

    final legacySpoken = await _prefs.getStringList(_kLegacySpoken);
    final legacySubtitle = await _prefs.getStringList(_kLegacySubtitle);
    if (legacySpoken == null && legacySubtitle == null) return fromServer;

    final legacy = UserSettings(
      spokenLanguages: legacySpoken ?? fromServer.spokenLanguages,
      subtitleLanguages: legacySubtitle ?? fromServer.subtitleLanguages,
      directPlay: await _prefs.getBool(_kLegacyDirectPlay) ?? fromServer.directPlay,
      transcode: await _prefs.getBool(_kLegacyTranscode) ?? fromServer.transcode,
      maxVideoHeight: fromServer.maxVideoHeight,
    );
    LoggerService().logger.i('Migrating this device\'s playback settings to $server');
    final saved = await save(server, legacy);
    await _prefs.remove(_kLegacySpoken);
    await _prefs.remove(_kLegacySubtitle);
    await _prefs.remove(_kLegacyDirectPlay);
    await _prefs.remove(_kLegacyTranscode);
    return saved;
  }

  // ---------- local cache (per server) ----------

  Future<UserSettings?> _readCache(String server) async {
    final spoken = await _prefs.getStringList('pref_spoken_languages_$server');
    final subtitle = await _prefs.getStringList('pref_subtitle_languages_$server');
    if (spoken == null && subtitle == null) return null;
    return UserSettings(
      spokenLanguages: spoken ?? const [],
      subtitleLanguages: subtitle ?? const [],
      directPlay: await _prefs.getBool('pref_direct_play_$server') ?? true,
      transcode: await _prefs.getBool('pref_transcode_$server') ?? true,
      maxVideoHeight: await _prefs.getInt('pref_max_video_height_$server'),
    );
  }

  Future<void> _writeCache(String server, UserSettings settings) async {
    await _prefs.setStringList(
        'pref_spoken_languages_$server', settings.spokenLanguages);
    await _prefs.setStringList(
        'pref_subtitle_languages_$server', settings.subtitleLanguages);
    await _prefs.setBool('pref_direct_play_$server', settings.directPlay);
    await _prefs.setBool('pref_transcode_$server', settings.transcode);
    final maxVideoHeight = settings.maxVideoHeight;
    if (maxVideoHeight == null) {
      await _prefs.remove('pref_max_video_height_$server');
    } else {
      await _prefs.setInt('pref_max_video_height_$server', maxVideoHeight);
    }
  }
}

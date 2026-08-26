import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:intl/intl.dart';
import 'package:player/graphql/playbackHistory.graphql.dart';
import 'package:player/graphql/trackPlaybackHistory.graphql.dart';
import 'package:player/graphql/schema.graphql.dart';

import '../l10n/app_localizations.dart';
import '../utils/ClientManager.dart';
import '../utils/LoggerService.dart';
import '../utils/MetadataUtil.dart';

/// One row of the sheet: a single play, whichever query produced it.
class PlaybackHistoryEntry {
  const PlaybackHistoryEntry({
    required this.id,
    required this.watched,
    required this.updatedAt,
    this.chapterNumber,
    this.trackTitle,
    this.albumTitle,
  });

  final String id;
  final bool watched;
  final String updatedAt;
  final int? chapterNumber;

  /// Which track was played — only on container histories, where every row is a
  /// different track; [albumTitle] is added when the container spans albums.
  final String? trackTitle;
  final String? albumTitle;
}

/// Where the sheet's rows come from: one media item, or every track of a
/// container (an album, or an artist's tracks across albums).
sealed class PlaybackHistorySource {
  const PlaybackHistorySource();

  /// "Mark as played just now" only means something for a single item — there is
  /// no such thing as playing a whole album "just now".
  bool get canMarkPlayed;

  Future<List<PlaybackHistoryEntry>> load(GraphQLClient client);
}

/// The history of one playable item, the per-play rows of `playbackHistory`.
class ItemPlaybackHistorySource extends PlaybackHistorySource {
  const ItemPlaybackHistorySource({required this.mediaType, required this.mediaId});

  final Enum$MediaType mediaType;
  final String mediaId;

  @override
  bool get canMarkPlayed => true;

  /// Books and comics keep a single upserted progress row instead of one row per
  /// play; deleting that row clears the reading position, which deserves a hint.
  bool get isBookLike =>
      mediaType == Enum$MediaType.BOOK || mediaType == Enum$MediaType.COMIC;

  @override
  Future<List<PlaybackHistoryEntry>> load(GraphQLClient client) async {
    final result = await client.query(QueryOptions(
      document: documentNodeQueryplaybackHistory,
      variables: Variables$Query$playbackHistory(
        mediaType: mediaType,
        mediaId: mediaId,
      ).toJson(),
      fetchPolicy: FetchPolicy.noCache,
    ));
    if (result.hasException || result.data == null) throw _failure(result);
    return Query$playbackHistory.fromJson(result.data!)
        .playbackHistory
        .map((entry) => PlaybackHistoryEntry(
              id: entry.id,
              watched: entry.watched,
              updatedAt: entry.updatedAt,
              chapterNumber: entry.chapter?.number,
            ))
        .toList();
  }
}

/// The plays of every track of an album or of an artist, newest first.
class TrackScopePlaybackHistorySource extends PlaybackHistorySource {
  const TrackScopePlaybackHistorySource({required this.scope, required this.id});

  final Enum$TrackHistoryScope scope;
  final String id;

  @override
  bool get canMarkPlayed => false;

  @override
  Future<List<PlaybackHistoryEntry>> load(GraphQLClient client) async {
    final result = await client.query(QueryOptions(
      document: documentNodeQuerytrackPlaybackHistory,
      variables: Variables$Query$trackPlaybackHistory(scope: scope, id: id).toJson(),
      fetchPolicy: FetchPolicy.noCache,
    ));
    if (result.hasException || result.data == null) throw _failure(result);
    return Query$trackPlaybackHistory.fromJson(result.data!)
        .trackPlaybackHistory
        .map((entry) {
      final track = entry.track;
      final album = track?.album;
      return PlaybackHistoryEntry(
        id: entry.id,
        watched: entry.watched,
        updatedAt: entry.updatedAt,
        trackTitle: track == null
            ? null
            : MetadataUtil.getTitle(track.metadata) ?? '${track.number}',
        // An album history is already one album; only an artist's rows need it.
        albumTitle: scope == Enum$TrackHistoryScope.ALBUM || album == null
            ? null
            : MetadataUtil.getTitle(album.metadata) ?? album.name,
      );
    }).toList();
  }
}

Object _failure(QueryResult result) =>
    result.exception ?? Exception('Empty playback history response');

/// Bottom sheet with the calling user's playback history of one media item:
/// one row per play (date + time), each deletable, plus a "mark as played just
/// now" action on top. [onChanged] fires after every mutation, so the opening
/// page can refetch watched badges / play counts.
Future<void> showPlaybackHistorySheet(
  BuildContext context, {
  required String serverName,
  required Enum$MediaType mediaType,
  required String mediaId,
  VoidCallback? onChanged,
}) {
  return _show(
    context,
    serverName: serverName,
    source: ItemPlaybackHistorySource(mediaType: mediaType, mediaId: mediaId),
    onChanged: onChanged,
  );
}

/// The same sheet for a container: every play of the tracks of an album, or of
/// the tracks an artist is credited on. Rows name the track they belong to and
/// there is no "mark as played" — see [TrackScopePlaybackHistorySource].
Future<void> showTrackScopePlaybackHistorySheet(
  BuildContext context, {
  required String serverName,
  required Enum$TrackHistoryScope scope,
  required String id,
  VoidCallback? onChanged,
}) {
  return _show(
    context,
    serverName: serverName,
    source: TrackScopePlaybackHistorySource(scope: scope, id: id),
    onChanged: onChanged,
  );
}

Future<void> _show(
  BuildContext context, {
  required String serverName,
  required PlaybackHistorySource source,
  VoidCallback? onChanged,
}) {
  return showModalBottomSheet<void>(
    context: context,
    showDragHandle: true,
    isScrollControlled: true,
    builder: (context) => PlaybackHistorySheetBody(
      serverName: serverName,
      source: source,
      onChanged: onChanged,
    ),
  );
}

class PlaybackHistorySheetBody extends StatefulWidget {
  const PlaybackHistorySheetBody({
    super.key,
    required this.serverName,
    required this.source,
    this.onChanged,
  });

  final String serverName;
  final PlaybackHistorySource source;
  final VoidCallback? onChanged;

  @override
  State<PlaybackHistorySheetBody> createState() =>
      _PlaybackHistorySheetBodyState();
}

class _PlaybackHistorySheetBodyState extends State<PlaybackHistorySheetBody> {
  List<PlaybackHistoryEntry>? _entries;
  Object? _error;
  bool _busy = false;

  GraphQLClient get _client =>
      ClientManager.getClientForUrl(widget.serverName).value;

  bool get _isBookLike {
    final source = widget.source;
    return source is ItemPlaybackHistorySource && source.isBookLike;
  }

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    List<PlaybackHistoryEntry> entries;
    try {
      entries = await widget.source.load(_client);
    } catch (error) {
      LoggerService().logger.e(error);
      if (!mounted) return;
      setState(() => _error = error);
      return;
    }
    if (!mounted) return;
    setState(() {
      _error = null;
      _entries = entries;
    });
  }

  Future<void> _markPlayedNow() async {
    final source = widget.source;
    if (source is! ItemPlaybackHistorySource) return;
    setState(() => _busy = true);
    final result = await _client.mutate(MutationOptions(
      document: documentNodeMutationmarkPlayed,
      variables: Variables$Mutation$markPlayed(
        mediaType: source.mediaType,
        mediaId: source.mediaId,
      ).toJson(),
    ));
    if (result.hasException) LoggerService().logger.e(result.exception);
    widget.onChanged?.call();
    if (!mounted) return;
    setState(() => _busy = false);
    await _load();
  }

  Future<void> _delete(PlaybackHistoryEntry entry) async {
    setState(() => _busy = true);
    final result = await _client.mutate(MutationOptions(
      document: documentNodeMutationdeleteWatchStatus,
      variables: Variables$Mutation$deleteWatchStatus(id: entry.id).toJson(),
    ));
    if (result.hasException) LoggerService().logger.e(result.exception);
    widget.onChanged?.call();
    if (!mounted) return;
    setState(() => _busy = false);
    await _load();
  }

  String _playedAt(PlaybackHistoryEntry entry) {
    final locale = Localizations.localeOf(context).toLanguageTag();
    final moment = DateTime.tryParse(entry.updatedAt)?.toLocal();
    if (moment == null) return entry.updatedAt;
    return DateFormat.yMMMd(locale).add_Hm().format(moment);
  }

  String? _subtitle(PlaybackHistoryEntry entry) {
    final loc = AppLocalizations.of(context)!;
    if (entry.chapterNumber != null) {
      return '${loc.chapter} ${entry.chapterNumber}';
    }
    if (entry.trackTitle != null) {
      return entry.albumTitle == null
          ? entry.trackTitle
          : '${entry.trackTitle} · ${entry.albumTitle}';
    }
    return _isBookLike ? loc.playbackHistoryDeleteBookHint : null;
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    final entries = _entries;

    Widget body;
    if (_error != null) {
      body = Padding(
        padding: const EdgeInsets.all(32),
        child: Center(child: Text(loc.error(_error!))),
      );
    } else if (_busy || entries == null) {
      body = const Padding(
        padding: EdgeInsets.all(32),
        child: Center(child: CircularProgressIndicator()),
      );
    } else {
      body = Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(24, 0, 24, 8),
            child: Text(loc.playbackHistory,
                style: Theme.of(context).textTheme.titleMedium),
          ),
          if (widget.source.canMarkPlayed)
            ListTile(
              key: const ValueKey('playback-history-mark-played'),
              leading: const Icon(Icons.check_circle_outline),
              title: Text(loc.markPlayedNow),
              onTap: _markPlayedNow,
            ),
          if (entries.isEmpty)
            ListTile(
              key: const ValueKey('playback-history-empty'),
              leading: const Icon(Icons.history),
              title: Text(loc.playbackHistoryEmpty),
            ),
          for (final entry in entries)
            ListTile(
              key: ValueKey('playback-history-entry-${entry.id}'),
              leading: Icon(entry.watched
                  ? Icons.check_circle
                  : Icons.play_circle_outline),
              title: Text(_playedAt(entry)),
              subtitle:
                  _subtitle(entry) == null ? null : Text(_subtitle(entry)!),
              trailing: IconButton(
                key: ValueKey('playback-history-delete-${entry.id}'),
                icon: const Icon(Icons.delete_outline),
                tooltip: loc.deleteHistoryEntry,
                onPressed: () => _delete(entry),
              ),
            ),
        ],
      );
    }

    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.only(bottom: 16),
        child: body,
      ),
    );
  }
}

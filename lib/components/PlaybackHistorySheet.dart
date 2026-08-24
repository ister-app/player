import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:intl/intl.dart';
import 'package:player/graphql/playbackHistory.graphql.dart';
import 'package:player/graphql/schema.graphql.dart';

import '../l10n/app_localizations.dart';
import '../utils/ClientManager.dart';
import '../utils/LoggerService.dart';

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
  return showModalBottomSheet<void>(
    context: context,
    showDragHandle: true,
    isScrollControlled: true,
    builder: (context) => PlaybackHistorySheetBody(
      serverName: serverName,
      mediaType: mediaType,
      mediaId: mediaId,
      onChanged: onChanged,
    ),
  );
}

class PlaybackHistorySheetBody extends StatefulWidget {
  const PlaybackHistorySheetBody({
    super.key,
    required this.serverName,
    required this.mediaType,
    required this.mediaId,
    this.onChanged,
  });

  final String serverName;
  final Enum$MediaType mediaType;
  final String mediaId;
  final VoidCallback? onChanged;

  @override
  State<PlaybackHistorySheetBody> createState() =>
      _PlaybackHistorySheetBodyState();
}

class _PlaybackHistorySheetBodyState extends State<PlaybackHistorySheetBody> {
  List<Query$playbackHistory$playbackHistory>? _entries;
  Object? _error;
  bool _busy = false;

  GraphQLClient get _client =>
      ClientManager.getClientForUrl(widget.serverName).value;

  /// Books and comics keep a single upserted progress row instead of one row
  /// per play; deleting that row clears the reading position, which deserves a
  /// hint under the entry.
  bool get _isBookLike =>
      widget.mediaType == Enum$MediaType.BOOK ||
      widget.mediaType == Enum$MediaType.COMIC;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final result = await _client.query(QueryOptions(
      document: documentNodeQueryplaybackHistory,
      variables: Variables$Query$playbackHistory(
        mediaType: widget.mediaType,
        mediaId: widget.mediaId,
      ).toJson(),
      fetchPolicy: FetchPolicy.noCache,
    ));
    if (!mounted) return;
    if (result.hasException || result.data == null) {
      LoggerService().logger.e(result.exception);
      setState(() => _error = result.exception);
      return;
    }
    setState(() {
      _error = null;
      _entries = Query$playbackHistory.fromJson(result.data!).playbackHistory;
    });
  }

  Future<void> _markPlayedNow() async {
    setState(() => _busy = true);
    final result = await _client.mutate(MutationOptions(
      document: documentNodeMutationmarkPlayed,
      variables: Variables$Mutation$markPlayed(
        mediaType: widget.mediaType,
        mediaId: widget.mediaId,
      ).toJson(),
    ));
    if (result.hasException) LoggerService().logger.e(result.exception);
    widget.onChanged?.call();
    if (!mounted) return;
    setState(() => _busy = false);
    await _load();
  }

  Future<void> _delete(Query$playbackHistory$playbackHistory entry) async {
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

  String _playedAt(Query$playbackHistory$playbackHistory entry) {
    final locale = Localizations.localeOf(context).toLanguageTag();
    final moment = DateTime.tryParse(entry.updatedAt)?.toLocal();
    if (moment == null) return entry.updatedAt;
    return DateFormat.yMMMd(locale).add_Hm().format(moment);
  }

  String? _subtitle(Query$playbackHistory$playbackHistory entry) {
    final loc = AppLocalizations.of(context)!;
    if (entry.chapter != null) {
      return '${loc.chapter} ${entry.chapter!.number}';
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
          ListTile(
            leading: const Icon(Icons.check_circle_outline),
            title: Text(loc.markPlayedNow),
            onTap: _markPlayedNow,
          ),
          if (entries.isEmpty)
            ListTile(
              leading: const Icon(Icons.history),
              title: Text(loc.playbackHistoryEmpty),
            ),
          for (final entry in entries)
            ListTile(
              leading: Icon(entry.watched
                  ? Icons.check_circle
                  : Icons.play_circle_outline),
              title: Text(_playedAt(entry)),
              subtitle:
                  _subtitle(entry) == null ? null : Text(_subtitle(entry)!),
              trailing: IconButton(
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

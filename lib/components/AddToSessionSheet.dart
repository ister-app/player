import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:player/graphql/fragmentServerActivity.graphql.dart';
import 'package:player/graphql/schema.graphql.dart';
import 'package:player/graphql/serverActivitySnapshot.graphql.dart';

import '../l10n/app_localizations.dart';
import '../utils/ClientManager.dart';
import '../utils/LoggerService.dart';
import '../utils/PlayQueueService.dart';
import '../utils/StreamTokenService.dart';
import '../utils/WellKnownService.dart';

/// One media item to add to a session's play queue. Only MOVIE/EPISODE/TRACK
/// are accepted by the server; albums and shows must be expanded by the caller.
typedef AddToSessionItem = (Enum$MediaType, String);

/// Bottom sheet ("party mode") that adds media to another client's active play
/// queue: pick a session, then choose "play next" or "add to end". [loadItems]
/// resolves the items to add — lazily, so a whole show only fetches its
/// episodes after a session was actually chosen.
Future<void> showAddToSessionSheet(
  BuildContext context, {
  required String serverName,
  required Future<List<AddToSessionItem>> Function(GraphQLClient client)
      loadItems,
}) {
  return showModalBottomSheet<void>(
    context: context,
    showDragHandle: true,
    isScrollControlled: true,
    builder: (context) => _AddToSessionSheet(
      serverName: serverName,
      loadItems: loadItems,
    ),
  );
}

class _AddToSessionSheet extends StatefulWidget {
  const _AddToSessionSheet({
    required this.serverName,
    required this.loadItems,
  });

  final String serverName;
  final Future<List<AddToSessionItem>> Function(GraphQLClient client) loadItems;

  @override
  State<_AddToSessionSheet> createState() => _AddToSessionSheetState();
}

class _AddToSessionSheetState extends State<_AddToSessionSheet> {
  List<Fragment$fragmentPlaybackSession>? _sessions;
  Fragment$fragmentPlaybackSession? _selected;
  String? _error;
  bool _busy = false;

  GraphQLClient get _client =>
      ClientManager.getClientForUrl(widget.serverName).value;

  @override
  void initState() {
    super.initState();
    StreamTokenService.ensureToken(widget.serverName).then((_) {
      if (mounted) setState(() {});
    });
    _client
        .query(QueryOptions(
            document: documentNodeQueryserverActivitySnapshot,
            fetchPolicy: FetchPolicy.networkOnly))
        .then((result) {
      if (!mounted) return;
      if (result.hasException) {
        LoggerService().logger.e(result.exception);
        setState(() => _error = result.exception.toString());
        return;
      }
      setState(() {
        _sessions = Query$serverActivitySnapshot.fromJson(result.data!)
            .serverActivitySnapshot
            .nowPlaying;
      });
    });
  }

  /// Adds the items to [session]'s queue. "Play next" inserts every item
  /// directly after the session's current item — in reverse order, so the
  /// final queue order matches the natural item order without needing the new
  /// ids from the responses. "Add to end" appends in natural order.
  Future<void> _add(
      Fragment$fragmentPlaybackSession session, bool playNext) async {
    final loc = AppLocalizations.of(context)!;
    setState(() => _busy = true);
    var success = true;
    try {
      final items = await widget.loadItems(_client);
      if (items.isEmpty) success = false;
      final ordered = playNext ? items.reversed : items;
      final afterId = playNext ? session.playQueueItemId : null;
      for (final (mediaType, mediaId) in ordered) {
        final updated = await PlayQueueService().addPlayQueueItem(
          _client,
          session.playQueueId,
          mediaType,
          mediaId,
          afterPlayQueueItemId: afterId,
        );
        if (updated == null) {
          success = false;
          break;
        }
      }
    } catch (e) {
      LoggerService().logger.e(e);
      success = false;
    }
    if (!mounted) return;
    Navigator.of(context).pop();
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content:
            Text(success ? loc.addedToSession : loc.addToSessionFailed)));
  }

  String? _artworkUrl(Fragment$fragmentPlaybackSession session) {
    final imageId = session.artworkImageId;
    if (imageId == null) return null;
    final serverUrl = WellKnownService.getCached(widget.serverName)?.serverUrl;
    if (serverUrl == null) return null;
    final token = StreamTokenService.getToken(widget.serverName);
    final base = '$serverUrl/images/$imageId/download';
    return token != null ? '$base?token=$token' : base;
  }

  IconData _mediaIcon(Enum$MediaType? type) {
    switch (type) {
      case Enum$MediaType.EPISODE:
        return Icons.tv;
      case Enum$MediaType.TRACK:
        return Icons.music_note;
      case Enum$MediaType.MOVIE:
        return Icons.movie;
      default:
        return Icons.play_circle_outline;
    }
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    final sessions = _sessions;
    final selected = _selected;

    Widget body;
    if (_busy) {
      body = const Padding(
        padding: EdgeInsets.all(32),
        child: Center(child: CircularProgressIndicator()),
      );
    } else if (_error != null) {
      body = Padding(
        padding: const EdgeInsets.all(24),
        child: Text(_error!),
      );
    } else if (sessions == null) {
      body = const Padding(
        padding: EdgeInsets.all(32),
        child: Center(child: CircularProgressIndicator()),
      );
    } else if (sessions.isEmpty) {
      body = Padding(
        padding: const EdgeInsets.all(24),
        child: Center(child: Text(loc.noActiveSessions)),
      );
    } else if (selected == null) {
      body = Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(24, 0, 24, 8),
            child: Text(loc.chooseSession,
                style: Theme.of(context).textTheme.titleMedium),
          ),
          for (final session in sessions)
            ListTile(
              leading: _SessionAvatar(
                url: _artworkUrl(session),
                fallbackIcon: _mediaIcon(session.mediaType),
              ),
              title: Text(
                session.title ?? session.mediaId ?? session.playQueueId,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              subtitle: Text(
                [
                  if (session.userName != null) session.userName!,
                  session.nodeName,
                ].join(' · '),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              onTap: () => setState(() => _selected = session),
            ),
        ],
      );
    } else {
      body = Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            leading: const Icon(Icons.playlist_play),
            title: Text(loc.playNext),
            onTap: () => _add(selected, true),
          ),
          ListTile(
            leading: const Icon(Icons.playlist_add),
            title: Text(loc.addToEndOfQueue),
            onTap: () => _add(selected, false),
          ),
        ],
      );
    }

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.only(bottom: 16),
        child: body,
      ),
    );
  }
}

class _SessionAvatar extends StatelessWidget {
  const _SessionAvatar({required this.url, required this.fallbackIcon});

  final String? url;
  final IconData fallbackIcon;

  @override
  Widget build(BuildContext context) {
    final placeholder = Container(
      width: 44,
      height: 44,
      color: Theme.of(context).colorScheme.surfaceContainerHighest,
      child: Icon(fallbackIcon,
          color: Theme.of(context).colorScheme.onSurfaceVariant, size: 22),
    );
    return ClipRRect(
      borderRadius: BorderRadius.circular(6),
      child: url == null
          ? placeholder
          : Image.network(
              url!,
              width: 44,
              height: 44,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => placeholder,
            ),
    );
  }
}

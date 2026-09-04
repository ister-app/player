import 'dart:async';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:player/components/ArtworkImage.dart';
import 'package:player/graphql/fragmentServerActivity.graphql.dart';
import 'package:player/graphql/nowPlayingSubscription.graphql.dart';
import 'package:player/graphql/schema.graphql.dart';
import 'package:player/graphql/serverActivitySnapshot.graphql.dart';
import 'package:player/routes/AppRouter.gr.dart';
import 'package:skeletonizer/skeletonizer.dart';

import '../components/ListenTogetherSheet.dart';
import '../components/LiveFeedBanner.dart';
import '../components/SettingsSection.dart';
import '../l10n/app_localizations.dart';
import '../utils/ClientManager.dart';
import '../utils/ImageUtil.dart';
import '../utils/LoggerService.dart';
import '../utils/MediaPlayerHandler.dart';
import '../utils/PermissionsService.dart';
import '../utils/ResilientSubscription.dart';
import '../utils/StreamTokenService.dart';

/// Live list of active playback sessions on the server, seeded from
/// serverActivitySnapshot and kept current via the nowPlaying subscription
/// (which re-emits the full list on every change).
@RoutePage()
class ServerNowPlayingPage extends StatefulWidget {
  final String serverName;

  const ServerNowPlayingPage({
    super.key,
    @PathParam.inherit('serverName') required this.serverName,
  });

  @override
  State<ServerNowPlayingPage> createState() => _ServerNowPlayingPageState();
}

class _ServerNowPlayingPageState extends State<ServerNowPlayingPage> {
  /// Session cards the skeleton reserves.
  static const int _skeletonSessionCount = 3;

  List<Fragment$fragmentPlaybackSession>? _sessions;
  ResilientSubscription? _subscription;
  String? _error;
  bool _liveFeedBroken = false;

  /// Wall-clock instant the current [_sessions] snapshot was received. Used to
  /// interpolate the position of PLAYING sessions between server heartbeats so
  /// the progress bar keeps counting up (and stands still when PAUSED).
  DateTime? _anchor;

  /// Drives the per-second interpolation while something is playing.
  Timer? _ticker;

  /// This user's own id on the server; only their own sessions expose who is
  /// listening along. Null until loaded, and on a server without the me query.
  String? _ownUserId;

  @override
  void initState() {
    super.initState();
    final client = ClientManager.getClientForUrl(widget.serverName).value;

    PermissionsService().userIdFor(widget.serverName).then((userId) {
      if (mounted) setState(() => _ownUserId = userId);
    });

    // Make sure image URLs can carry a valid stream token.
    StreamTokenService.ensureToken(widget.serverName).then((_) {
      if (mounted) setState(() {});
    });

    // Subscribe first, then seed from the snapshot only while nothing has
    // arrived yet — the subscription re-emits the full list, so it always
    // wins over a stale snapshot.
    _subscription = ResilientSubscription(
      client: client,
      document: documentNodeSubscriptionnowPlaying,
      onData: (result) {
        if (!mounted) return;
        setState(() {
          _error = null;
          _liveFeedBroken = false;
          _sessions = Subscription$nowPlaying.fromJson(result.data!).nowPlaying;
          _anchor = DateTime.now();
        });
        _syncTicker();
      },
      onFailure: (_) {
        if (!mounted) return;
        setState(() => _liveFeedBroken = true);
      },
    );

    client
        .query(QueryOptions(
            document: documentNodeQueryserverActivitySnapshot,
            fetchPolicy: FetchPolicy.networkOnly))
        .then((result) {
      if (!mounted) return;
      if (result.hasException) {
        LoggerService().logger.e(result.exception);
        setState(() => _error ??= result.exception.toString());
        return;
      }
      final data = result.data;
      if (data == null || _sessions != null) return;
      setState(() {
        _sessions = Query$serverActivitySnapshot.fromJson(data)
            .serverActivitySnapshot
            .nowPlaying;
        _anchor = DateTime.now();
      });
      _syncTicker();
    });
  }

  @override
  void dispose() {
    _ticker?.cancel();
    _subscription?.dispose();
    super.dispose();
  }

  /// Runs the 1s ticker only while at least one session is playing.
  void _syncTicker() {
    final anyPlaying = _sessions?.any(
            (s) => s.playState != Enum$PlayState.PAUSED) ??
        false;
    if (anyPlaying && _ticker == null) {
      _ticker = Timer.periodic(const Duration(seconds: 1), (_) {
        if (mounted) setState(() {});
      });
    } else if (!anyPlaying) {
      _ticker?.cancel();
      _ticker = null;
    }
  }

  /// Interpolated playback position: PLAYING sessions advance with wall-clock
  /// time since the snapshot was received; PAUSED sessions stay put.
  int _livePositionMs(Fragment$fragmentPlaybackSession session) {
    var pos = session.progressInMilliseconds;
    final anchor = _anchor;
    if (session.playState != Enum$PlayState.PAUSED && anchor != null) {
      pos += DateTime.now().difference(anchor).inMilliseconds;
    }
    final total = session.durationInMilliseconds;
    if (total != null && pos > total) pos = total;
    return pos < 0 ? 0 : pos;
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

  String _formatProgress(int milliseconds) {
    final duration = Duration(milliseconds: milliseconds);
    final hours = duration.inHours;
    final minutes = duration.inMinutes.remainder(60);
    final seconds = duration.inSeconds.remainder(60);
    final mmss =
        '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
    return hours > 0 ? '$hours:$mmss' : mmss;
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    final sessions = _sessions;

    Widget body;
    if (_error != null && sessions == null) {
      body = SettingsErrorState(
        message: loc.couldNotLoad,
        detailsLabel: loc.errorDetails,
        details: _error,
      );
    } else if (sessions == null) {
      body = Skeletonizer(
        enabled: true,
        child: ListView(
          padding: const EdgeInsets.all(16.0),
          children: [
            // The loaded list opens with this paragraph; leaving it out of the
            // skeleton shoved every card down once the sessions arrived.
            Skeleton.keep(child: SettingsIntro(loc.nowPlayingIntro)),
            for (var i = 0; i < _skeletonSessionCount; i++)
              const _SessionCardSkeleton(),
          ],
        ),
      );
    } else if (sessions.isEmpty && !_liveFeedBroken) {
      body = SettingsEmptyState(
        icon: Icons.pause_circle_outline,
        title: loc.noActiveSessions,
        message: loc.nowPlayingIntro,
      );
    } else {
      body = ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          if (_liveFeedBroken) const LiveFeedBanner(),
          SettingsIntro(loc.nowPlayingIntro),
          if (sessions.isEmpty) Center(child: Text(loc.noActiveSessions)),
          for (final session in sessions)
            _SessionCard(
              session: session,
              positionMs: _livePositionMs(session),
              artworkUrl:
                  ImageUtil.buildUrlById(widget.serverName, session.artworkImageId),
              mediaIcon: _mediaIcon(session.mediaType),
              formatProgress: _formatProgress,
              // Party mode: open the remote control overlay for this session — but only when the
              // owner allows this user to control it (server-computed per viewer). A view-only
              // session has no tap target.
              onTap: session.controllable
                  ? () => context.router.root.push(RemoteControlRoute(
                      serverName: widget.serverName,
                      playQueueId: session.playQueueId))
                  : null,
              // Listen together: the owner manages the session (listeners,
              // devices, sharing); anyone who may control it may also join it
              // on this device — except for this device's own session as seen
              // through another card, where the owner check already covers it.
              onListenTogether: session.userId == _ownUserId ||
                      (session.controllable &&
                          !MediaPlayerHandler.instance.isOwnLiveQueue(
                              widget.serverName, session.playQueueId))
                  ? () => showListenTogetherSheet(context,
                      serverName: widget.serverName,
                      playQueueId: session.playQueueId,
                      mediaType: session.mediaType,
                      sessionUserId: session.userId,
                      sessionDeviceId: session.deviceId)
                  : null,
            ),
        ],
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(loc.nowPlaying),
      ),
      body: body,
    );
  }
}

class _SessionCard extends StatelessWidget {
  final Fragment$fragmentPlaybackSession session;
  final int positionMs;
  final String? artworkUrl;
  final IconData mediaIcon;
  final String Function(int) formatProgress;
  final VoidCallback? onTap;
  final VoidCallback? onListenTogether;

  const _SessionCard({
    required this.session,
    required this.positionMs,
    required this.artworkUrl,
    required this.mediaIcon,
    required this.formatProgress,
    this.onTap,
    this.onListenTogether,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final mutedColor = theme.colorScheme.onSurfaceVariant;
    final paused = session.playState == Enum$PlayState.PAUSED;
    final isVideo = session.mediaType == Enum$MediaType.MOVIE ||
        session.mediaType == Enum$MediaType.EPISODE;
    final total = session.durationInMilliseconds;
    final fraction = (total != null && total > 0)
        ? (positionMs / total).clamp(0.0, 1.0)
        : null;

    final loc = AppLocalizations.of(context)!;
    final subtitleParts = [
      if (session.userName != null) session.userName!,
      // The registered device name says *which* client plays; the node name
      // (kept as fallback) only says which server node it reports to.
      session.deviceName ?? session.nodeName,
      if (session.followerCount > 0)
        loc.followersListening(session.followerCount),
    ];

    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _Artwork(url: artworkUrl, fallbackIcon: mediaIcon),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          session.title ??
                              session.mediaId ??
                              session.playQueueId,
                          style: theme.textTheme.titleSmall,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const SizedBox(width: 8),
                      _StateChip(paused: paused),
                      if (onListenTogether != null)
                        IconButton(
                          icon: Icon(isVideo
                              ? Icons.connected_tv
                              : Icons.headphones),
                          tooltip: isVideo
                              ? loc.watchTogetherTitle
                              : loc.listenTogetherTitle,
                          visualDensity: VisualDensity.compact,
                          onPressed: onListenTogether,
                        ),
                    ],
                  ),
                  if (subtitleParts.isNotEmpty) ...[
                    const SizedBox(height: 2),
                    Text(
                      subtitleParts.join(' · '),
                      style: theme.textTheme.bodySmall
                          ?.copyWith(color: mutedColor),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                  const SizedBox(height: 10),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(4),
                    child: LinearProgressIndicator(
                      value: fraction,
                      minHeight: 4,
                      backgroundColor:
                          theme.colorScheme.surfaceContainerHighest,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        formatProgress(positionMs),
                        style: theme.textTheme.bodySmall
                            ?.copyWith(color: mutedColor),
                      ),
                      if (total != null)
                        Text(
                          formatProgress(total),
                          style: theme.textTheme.bodySmall
                              ?.copyWith(color: mutedColor),
                        ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
        ),
      ),
    );
  }
}

class _Artwork extends StatelessWidget {
  final String? url;
  final IconData fallbackIcon;

  const _Artwork({required this.url, required this.fallbackIcon});

  static const double _size = 64;

  @override
  Widget build(BuildContext context) {
    final placeholder = Container(
      width: _size,
      height: _size,
      color: Theme.of(context).colorScheme.surfaceContainerHighest,
      child: Icon(fallbackIcon,
          color: Theme.of(context).colorScheme.onSurfaceVariant),
    );

    return ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: url == null
          ? placeholder
          : ArtworkImage(
              url: url,
              logicalWidth: _size,
              width: _size,
              height: _size,
              placeholder: (_) => placeholder,
              errorBuilder: (_) => placeholder,
            ),
    );
  }
}

class _StateChip extends StatelessWidget {
  final bool paused;

  const _StateChip({required this.paused});

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    return Chip(
      avatar: Icon(paused ? Icons.pause : Icons.play_arrow, size: 16),
      label: Text(
        paused ? loc.statePaused : loc.statePlaying,
        style: theme.textTheme.bodySmall,
      ),
      padding: EdgeInsets.zero,
      visualDensity: VisualDensity.compact,
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
    );
  }
}

class _SessionCardSkeleton extends StatelessWidget {
  const _SessionCardSkeleton();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // The real artwork placeholder, not a copy of its decoration.
            const _Artwork(url: null, fallbackIcon: Icons.music_note),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  // The state chip is what makes the real title row two lines
                  // tall on a phone; without it the skeleton reserved less
                  // than every card that landed.
                  Row(
                    children: [
                      Expanded(
                        child: Text(BoneMock.name,
                            style: theme.textTheme.titleSmall, maxLines: 2),
                      ),
                      const SizedBox(width: 8),
                      const _StateChip(paused: false),
                    ],
                  ),
                  const SizedBox(height: 2),
                  Text(BoneMock.words(2), style: theme.textTheme.bodySmall),
                  const SizedBox(height: 10),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(4),
                    child: LinearProgressIndicator(
                      value: 0,
                      minHeight: 4,
                      backgroundColor: theme.colorScheme.surfaceContainerHighest,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(BoneMock.chars(5),
                          style: theme.textTheme.bodySmall),
                      Text(BoneMock.chars(5),
                          style: theme.textTheme.bodySmall),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

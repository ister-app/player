import 'dart:ui';

import 'package:audio_service/audio_service.dart';
import 'package:cached_network_image_ce/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:player/graphql/fragmentAlbum.graphql.dart';
import 'package:player/graphql/fragmentTrack.graphql.dart';
import 'package:player/graphql/schema.graphql.dart';
import 'package:player/utils/DurationUtil.dart';
import 'package:player/utils/ImageTypes.dart';
import 'package:player/utils/ImageUtil.dart';
import 'package:player/utils/MediaPlayerHandler.dart';
import 'package:player/utils/MetadataUtil.dart';
import 'package:player/utils/StreamTokenService.dart';

import '../dto/IsterMediaItem.dart';
import '../dto/MediaItemId.dart';
import '../l10n/app_localizations.dart';
import 'AddToPlaylistSheet.dart';
import 'PlaybackHistorySheet.dart';
import 'RatingStars.dart';
import 'TvFocusable.dart';

/// Which detail a top-track list shows on the right of each row.
enum ArtistTrackListVariant {
  /// Play-count badge ("Most played").
  plays,

  /// Relative last-played time ("Last played").
  recency,

  /// Rating stars + duration ("Highest rated").
  rating,

  /// Relative added-to-library time ("Recently added").
  added;

  /// The server-side ranking this list renders; playing the list creates an
  /// ARTIST play queue for the same ranking.
  Enum$RankKind get rankKind => switch (this) {
        plays => Enum$RankKind.MOST_PLAYED,
        recency => Enum$RankKind.RECENTLY_PLAYED,
        rating => Enum$RankKind.HIGHEST_RATED,
        added => Enum$RankKind.RECENTLY_ADDED,
      };
}

/// One row of an [ArtistTrackList]: a track with the album it plays in and
/// the per-user statistics of the list it appears in.
class ArtistTrackListItem {
  const ArtistTrackListItem({
    required this.track,
    required this.album,
    this.playCount,
    this.lastPlayedAt,
    this.dateAdded,
  });

  final Fragment$fragmentTrack track;
  final Fragment$fragmentAlbum album;
  final int? playCount;
  final DateTime? lastPlayedAt;
  final DateTime? dateAdded;
}

/// A ranked track list for the artist page (most played / last played /
/// highest rated): rank number, album-art thumbnail, title and album, with a
/// per-variant trailing detail. Collapsed to [collapsedCount] rows with a
/// show-more toggle; tapping a row plays the ranked list itself as the queue,
/// starting at the tapped track.
class ArtistTrackList extends StatefulWidget {
  const ArtistTrackList({
    super.key,
    required this.items,
    required this.serverName,
    required this.personId,
    required this.variant,
    this.collapsedCount = 5,
  });

  final List<ArtistTrackListItem> items;
  final String serverName;

  /// The artist whose ranked list this is; the ARTIST play queue's source.
  final String personId;
  final ArtistTrackListVariant variant;
  final int collapsedCount;

  @override
  State<ArtistTrackList> createState() => _ArtistTrackListState();
}

class _ArtistTrackListState extends State<ArtistTrackList> {
  bool _expanded = false;

  // Live overrides for ratings changed via the row menu this session, so the
  // stars update immediately without waiting for a refetch.
  final Map<String, int?> _ratingOverrides = {};

  static bool _trackHasFile(Fragment$fragmentTrack track) =>
      track.mediaFile?.isNotEmpty == true;

  int? _rating(Fragment$fragmentTrack track) =>
      _ratingOverrides.containsKey(track.id)
          ? _ratingOverrides[track.id]
          : track.rating;

  void _playTrack(BuildContext context, ArtistTrackListItem item) {
    final client = GraphQLProvider.of(context).value;
    MediaPlayerHandler.instance.startPlayQueueForArtistRankedList(
      client,
      widget.serverName,
      widget.personId,
      widget.variant.rankKind,
      item.track.id,
    );
  }

  Future<void> _addToQueue(BuildContext context, String trackId) async {
    final messenger = ScaffoldMessenger.of(context);
    final loc = AppLocalizations.of(context)!;
    final added = await MediaPlayerHandler.instance
        .addToQueue(widget.serverName, Enum$MediaType.TRACK, trackId);
    if (added) {
      messenger.showSnackBar(SnackBar(content: Text(loc.addToQueue)));
    }
  }

  /// The id of the track currently playing on this list's server, or null.
  String? _playingTrackId(MediaItem? item) {
    if (item == null) return null;
    try {
      final id = MediaItemId.byStringId(item.id);
      if (id.serverName == widget.serverName &&
          id.isterMediaType == IsterMediaTypes.track) {
        return id.id;
      }
    } catch (_) {
      // Malformed/unknown id (e.g. from an older session): no indicator.
    }
    return null;
  }

  String _relativeTime(AppLocalizations loc, DateTime moment) {
    final elapsed = DateTime.now().difference(moment);
    if (elapsed.inHours < 1) return loc.playedJustNow;
    if (elapsed.inHours < 24) return loc.hoursAgoShort(elapsed.inHours);
    if (elapsed.inDays < 7) return loc.daysAgoShort(elapsed.inDays);
    if (elapsed.inDays < 31) return loc.weeksAgoShort(elapsed.inDays ~/ 7);
    if (elapsed.inDays < 365) return loc.monthsAgoShort(elapsed.inDays ~/ 30);
    return loc.yearsAgoShort(elapsed.inDays ~/ 365);
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    final visible = _expanded
        ? widget.items
        : widget.items.take(widget.collapsedCount).toList();

    return StreamBuilder<MediaItem?>(
      stream: MediaPlayerHandler.instance.mediaItem,
      initialData: MediaPlayerHandler.instance.mediaItem.valueOrNull,
      builder: (context, snapshot) {
        final playingTrackId = _playingTrackId(snapshot.data);
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            for (var rank = 0; rank < visible.length; rank++)
              _buildRow(context, loc, rank, visible[rank], playingTrackId),
            if (widget.items.length > widget.collapsedCount)
              Padding(
                padding: const EdgeInsets.only(left: 8),
                child: TvFocusable(
                  onTap: () => setState(() => _expanded = !_expanded),
                  child: TextButton(
                    onPressed: () => setState(() => _expanded = !_expanded),
                    child: Text(_expanded ? loc.showLess : loc.showMore),
                  ),
                ),
              ),
          ],
        );
      },
    );
  }

  Widget _buildRow(BuildContext context, AppLocalizations loc, int rank,
      ArtistTrackListItem item, String? playingTrackId) {
    final theme = Theme.of(context);
    final mutedColor = theme.colorScheme.onSurfaceVariant;
    final accentColor = theme.colorScheme.primary;
    final track = item.track;
    final hasFile = _trackHasFile(track);
    final isPlaying = track.id == playingTrackId;
    final title = MetadataUtil.getTitle(track.metadata) ?? '${track.number}';
    final albumTitle =
        MetadataUtil.getTitle(item.album.metadata) ?? item.album.name;
    final rating = _rating(track);
    final durationMs = track.mediaFile?.firstOrNull?.durationInMilliseconds;
    // Hoisted so the TV remote's long-press can open the same menu as the
    // trailing icon button.
    final menuController = MenuController();

    void onRowTap() {
      if (!hasFile) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(loc.trackNotPlayable)),
        );
        return;
      }
      _playTrack(context, item);
    }

    return Opacity(
      opacity: hasFile ? 1.0 : 0.5,
      child: TvFocusable(
        onTap: onRowTap,
        onLongPress: () => menuController.isOpen
            ? menuController.close()
            : menuController.open(),
        borderRadius: const BorderRadius.all(Radius.circular(4)),
        child: ListTile(
          dense: true,
          visualDensity: VisualDensity.compact,
          leading: SizedBox(
            width: 68,
            child: Row(
              children: [
                SizedBox(
                  width: 20,
                  child: isPlaying
                      ? Icon(Icons.graphic_eq, size: 16, color: accentColor)
                      : Text(
                          '${rank + 1}',
                          textAlign: TextAlign.center,
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: mutedColor,
                            fontFeatures: [const FontFeature.tabularFigures()],
                          ),
                        ),
                ),
                const SizedBox(width: 8),
                _albumThumb(context, item.album),
              ],
            ),
          ),
          title: Text(
            title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: isPlaying
                ? TextStyle(color: accentColor, fontWeight: FontWeight.w600)
                : null,
          ),
          subtitle: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (widget.variant == ArtistTrackListVariant.rating &&
                  rating != null) ...[
                RatingStarsDisplay(rating: rating),
                const SizedBox(width: 8),
              ],
              Flexible(
                child: Text(
                  albumTitle,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.bodySmall
                      ?.copyWith(color: mutedColor),
                ),
              ),
            ],
          ),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              _trailingDetail(loc, theme, mutedColor, item, durationMs),
              MenuAnchor(
                controller: menuController,
                menuChildren: [
                  MenuItemButton(
                    onPressed:
                        hasFile ? () => _addToQueue(context, track.id) : null,
                    child: ListTile(
                      leading: const Icon(Icons.playlist_add),
                      title: Text(loc.addToQueue),
                    ),
                  ),
                  MenuItemButton(
                    onPressed: hasFile
                        ? () => showAddToPlaylistSheet(
                              context,
                              serverName: widget.serverName,
                              mediaType: Enum$MediaType.TRACK,
                              loadItemIds: (_) async => [track.id],
                            )
                        : null,
                    child: ListTile(
                      leading: const Icon(Icons.playlist_add_check),
                      title: Text(loc.addToPlaylist),
                    ),
                  ),
                  MenuItemButton(
                    onPressed: () => showRatingDialog(
                      context,
                      mediaType: Enum$RatingMediaType.TRACK,
                      mediaId: track.id,
                      rating: rating,
                      title: title,
                      onChanged: (value) =>
                          setState(() => _ratingOverrides[track.id] = value),
                    ),
                    child: ListTile(
                      leading: const Icon(Icons.star_outline_rounded),
                      title: Text(loc.rate),
                    ),
                  ),
                  MenuItemButton(
                    onPressed: () => showPlaybackHistorySheet(
                      context,
                      serverName: widget.serverName,
                      mediaType: Enum$MediaType.TRACK,
                      mediaId: track.id,
                    ),
                    child: ListTile(
                      leading: const Icon(Icons.history),
                      title: Text(loc.playbackHistory),
                    ),
                  ),
                ],
                builder: (_, MenuController controller, Widget? child) {
                  return IconButton(
                    icon: const Icon(Icons.more_vert),
                    onPressed: () => controller.isOpen
                        ? controller.close()
                        : controller.open(),
                  );
                },
              ),
            ],
          ),
          onTap: onRowTap,
        ),
      ),
    );
  }

  Widget _trailingDetail(AppLocalizations loc, ThemeData theme,
      Color mutedColor, ArtistTrackListItem item, int? durationMs) {
    final style = theme.textTheme.bodySmall?.copyWith(
      color: mutedColor,
      fontFeatures: [const FontFeature.tabularFigures()],
    );
    switch (widget.variant) {
      case ArtistTrackListVariant.plays:
        final count = item.playCount ?? 0;
        return Tooltip(
          message: loc.playCountTimes(count),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.play_arrow, size: 14, color: mutedColor),
              const SizedBox(width: 2),
              Text('$count', style: style),
            ],
          ),
        );
      case ArtistTrackListVariant.recency:
        final lastPlayedAt = item.lastPlayedAt;
        return Text(
          lastPlayedAt != null ? _relativeTime(loc, lastPlayedAt) : '',
          style: style,
        );
      case ArtistTrackListVariant.added:
        final dateAdded = item.dateAdded;
        return Text(
          dateAdded != null ? _relativeTime(loc, dateAdded) : '',
          style: style,
        );
      case ArtistTrackListVariant.rating:
        return Text(
          durationMs != null
              ? DurationUtil.format(Duration(milliseconds: durationMs))
              : '',
          style: style,
        );
    }
  }

  Widget _albumThumb(BuildContext context, Fragment$fragmentAlbum album) {
    final img = ImageUtil.getImageByType(album.images, ImageTypes.cover);
    final imageUrl = img != null
        ? ImageUtil.buildUrl(img,
            token: StreamTokenService.getToken(widget.serverName))
        : null;
    return ClipRRect(
      borderRadius: BorderRadius.circular(6),
      child: SizedBox(
        width: 40,
        height: 40,
        child: imageUrl != null
            ? CachedNetworkImage(
                imageUrl: imageUrl,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => _thumbPlaceholder(context),
              )
            : _thumbPlaceholder(context),
      ),
    );
  }

  Widget _thumbPlaceholder(BuildContext context) => Container(
        color: Theme.of(context).colorScheme.surfaceContainerHighest,
        child: Icon(
          Icons.music_note,
          size: 20,
          color: Theme.of(context).colorScheme.onSurfaceVariant,
        ),
      );
}

import 'dart:async';

import 'package:flutter/material.dart';

import '../l10n/app_localizations.dart';
import '../utils/QueueEnd.dart';
import '../utils/QueueEndSuggestions.dart';
import 'ArtworkImage.dart';
import 'TvFocusable.dart';

/// What to play after an audio queue ended, under the ended banner: a
/// header naming what these are (more from the artist, next in the series,
/// next unplayed episode) and a strip of tiles. Collapses while resolving
/// and when there is nothing to suggest.
class QueueEndSuggestionsRow extends StatefulWidget {
  const QueueEndSuggestionsRow({super.key, required this.info});

  static const Key rowKey = Key('queue-end-suggestions');

  /// Key of the tile for the suggestion with [id].
  static Key tileKey(String id) => Key('queue-end-suggestion-$id');

  final QueueEndedInfo info;

  @override
  State<QueueEndSuggestionsRow> createState() => _QueueEndSuggestionsRowState();
}

class _QueueEndSuggestionsRowState extends State<QueueEndSuggestionsRow> {
  late Future<QueueEndSuggestionSet?> _suggestions;

  @override
  void initState() {
    super.initState();
    _suggestions = QueueEndSuggestions.resolve(widget.info);
  }

  @override
  void didUpdateWidget(QueueEndSuggestionsRow oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.info != widget.info) {
      _suggestions = QueueEndSuggestions.resolve(widget.info);
    }
  }

  String _header(AppLocalizations loc, QueueEndSuggestionSet set) {
    switch (set.kind) {
      case QueueEndKind.album:
        return loc.moreFromArtist(set.artistName ?? '');
      case QueueEndKind.book:
        return loc.nextInSeries;
      case QueueEndKind.podcast:
        return loc.nextUnplayedEpisode;
      case QueueEndKind.episode:
      case QueueEndKind.movie:
      case QueueEndKind.playlist:
      case QueueEndKind.other:
        return loc.youMightAlsoLike;
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<QueueEndSuggestionSet?>(
      future: _suggestions,
      builder: (context, snapshot) {
        final set = snapshot.data;
        final loc = AppLocalizations.of(context);
        if (set == null || set.isEmpty || loc == null) {
          return const SizedBox.shrink();
        }
        return Padding(
          key: QueueEndSuggestionsRow.rowKey,
          padding: const EdgeInsets.only(top: 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                _header(loc, set),
                style: const TextStyle(color: Colors.white70, fontSize: 12),
              ),
              const SizedBox(height: 6),
              SizedBox(
                height: 64,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: set.items.length,
                  separatorBuilder: (_, _) => const SizedBox(width: 8),
                  itemBuilder: (context, index) =>
                      _SuggestionTile(suggestion: set.items[index]),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _SuggestionTile extends StatelessWidget {
  const _SuggestionTile({required this.suggestion});

  final QueueEndSuggestion suggestion;

  @override
  Widget build(BuildContext context) {
    void start() => unawaited(suggestion.start());
    return TvFocusable(
      onTap: start,
      borderRadius: const BorderRadius.all(Radius.circular(8)),
      child: Material(
        color: Colors.white.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(8),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          key: QueueEndSuggestionsRow.tileKey(suggestion.id),
          onTap: start,
          child: SizedBox(
            width: 220,
            child: Row(
              children: [
                SizedBox(
                  width: 56,
                  height: 56,
                  child: suggestion.artUrl != null
                      ? ArtworkImage(
                          url: suggestion.artUrl!,
                          logicalWidth: 56,
                          errorBuilder: (context) => _placeholder(),
                        )
                      : _placeholder(),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        suggestion.title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                            color: Colors.white,
                            fontSize: 13,
                            fontWeight: FontWeight.bold),
                      ),
                      if (suggestion.subtitle != null)
                        Text(
                          suggestion.subtitle!,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                              color: Colors.white70, fontSize: 12),
                        ),
                    ],
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.only(right: 8),
                  child: Icon(Icons.play_arrow, color: Colors.white70),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _placeholder() => const ColoredBox(
        color: Colors.white12,
        child: Icon(Icons.music_note, color: Colors.white54),
      );
}

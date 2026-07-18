import 'package:flutter/material.dart';
import 'package:player/graphql/fragmentImages.graphql.dart';
import 'package:player/graphql/fragmentMetadata.graphql.dart';
import 'package:player/graphql/schema.graphql.dart';
import 'package:player/l10n/app_localizations.dart';
import 'package:player/utils/MetadataUtil.dart';

/// A muted one-line "Source: TMDB · Wikipedia" note crediting the external
/// providers the shown metadata (and optionally artwork) came from. Renders
/// nothing when everything is locally sourced.
class SourceAttribution extends StatelessWidget {
  final List<Fragment$fragmentMetadata>? metadata;
  final List<Fragment$fragmentImages?>? images;

  const SourceAttribution({super.key, this.metadata, this.images});

  /// Proper names, not translated.
  static String? displayName(Enum$MetadataSource source) {
    switch (source) {
      case Enum$MetadataSource.TMDB:
        return "TMDB";
      case Enum$MetadataSource.MUSICBRAINZ:
        return "MusicBrainz";
      case Enum$MetadataSource.COVER_ART_ARCHIVE:
        return "Cover Art Archive";
      case Enum$MetadataSource.WIKIMEDIA_COMMONS:
        return "Wikimedia Commons";
      case Enum$MetadataSource.WIKIPEDIA:
        return "Wikipedia";
      case Enum$MetadataSource.WIKIDATA:
        return "Wikidata";
      case Enum$MetadataSource.OPEN_LIBRARY:
        return "Open Library";
      // Not external providers to credit.
      case Enum$MetadataSource.PODCAST_FEED:
      case Enum$MetadataSource.LOCAL_FILE:
      case Enum$MetadataSource.$unknown:
        return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    final sources = <Enum$MetadataSource>{
      ...MetadataUtil.getSources(metadata),
      ...?images
          ?.map((image) => image?.source)
          .whereType<Enum$MetadataSource>(),
    };
    final names = sources.map(displayName).whereType<String>().toList();
    if (names.isEmpty) {
      return const SizedBox.shrink();
    }
    return Text(
      AppLocalizations.of(context)!.sourceAttribution(names.join(' · ')),
      style: Theme.of(context)
          .textTheme
          .bodySmall
          ?.copyWith(color: Theme.of(context).disabledColor),
    );
  }
}

import 'package:player/graphql/schema.graphql.dart';

import '../ImageTypes.dart';

/// Which item an artwork action is about: one kind, one id — the client twin
/// of the server's `ImageTargetInput`, which wants exactly one id set.
enum ArtworkTargetKind {
  movie,
  show,
  episode,
  album,
  person,
  book,
  podcast,
  game,
  series,
}

class ArtworkTarget {
  const ArtworkTarget(this.kind, this.id);

  final ArtworkTargetKind kind;
  final String id;

  /// Movies and episodes own video files: a frame can be the source.
  bool get hasVideo =>
      kind == ArtworkTargetKind.movie || kind == ArtworkTargetKind.episode;

  /// Round-trips through a route path segment.
  static ArtworkTarget? parse(String kind, String id) {
    final k = ArtworkTargetKind.values.asNameMap()[kind];
    return k == null ? null : ArtworkTarget(k, id);
  }

  Input$ImageTargetInput toInput() => Input$ImageTargetInput(
    movieId: kind == ArtworkTargetKind.movie ? id : null,
    showId: kind == ArtworkTargetKind.show ? id : null,
    episodeId: kind == ArtworkTargetKind.episode ? id : null,
    albumId: kind == ArtworkTargetKind.album ? id : null,
    personId: kind == ArtworkTargetKind.person ? id : null,
    bookId: kind == ArtworkTargetKind.book ? id : null,
    podcastId: kind == ArtworkTargetKind.podcast ? id : null,
    gameId: kind == ArtworkTargetKind.game ? id : null,
    seriesId: kind == ArtworkTargetKind.series ? id : null,
  );

  /// The query parameter the REST upload wants (`movieId=…`).
  String get queryParamName => '${kind.name}Id';

  @override
  bool operator ==(Object other) =>
      other is ArtworkTarget && other.kind == kind && other.id == id;

  @override
  int get hashCode => Object.hash(kind, id);

  @override
  String toString() => 'ArtworkTarget(${kind.name}, $id)';
}

/// The GraphQL `ImageType` for a client-side [ImageTypes].
Enum$ImageType imageTypeOf(ImageTypes type) =>
    type == ImageTypes.cover ? Enum$ImageType.COVER : Enum$ImageType.BACKGROUND;

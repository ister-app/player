import 'fragmentBook.graphql.dart';
import 'fragmentCredit.graphql.dart';
import 'fragmentEpisode.graphql.dart';
import 'fragmentImages.graphql.dart';
import 'fragmentMediafiles.graphql.dart';
import 'fragmentMetadata.graphql.dart';
import 'fragmentMovie.graphql.dart';
import 'fragmentWatchStatus.graphql.dart';

import 'package:gql/ast.dart';

import 'schema.graphql.dart';

class Fragment$fragmentPlaylistItem {
  Fragment$fragmentPlaylistItem({
    required this.id,
    required this.position,
    required this.type,
    this.episode,
    this.movie,
    this.track,
    this.book,
    this.podcastEpisode,
    this.$__typename = 'PlaylistItem',
  });

  factory Fragment$fragmentPlaylistItem.fromJson(Map<String, dynamic> json) {
    final l$id = json['id'];
    final l$position = json['position'];
    final l$type = json['type'];
    final l$episode = json['episode'];
    final l$movie = json['movie'];
    final l$track = json['track'];
    final l$book = json['book'];
    final l$podcastEpisode = json['podcastEpisode'];
    final l$$__typename = json['__typename'];
    return Fragment$fragmentPlaylistItem(
      id: (l$id as String),
      position: (l$position as num).toDouble(),
      type: fromJson$Enum$MediaType((l$type as String)),
      episode: l$episode == null
          ? null
          : Fragment$fragmentEpisode.fromJson(
              (l$episode as Map<String, dynamic>),
            ),
      movie: l$movie == null
          ? null
          : Fragment$fragmentMovie.fromJson((l$movie as Map<String, dynamic>)),
      track: l$track == null
          ? null
          : Fragment$fragmentPlaylistItem$track.fromJson(
              (l$track as Map<String, dynamic>),
            ),
      book: l$book == null
          ? null
          : Fragment$fragmentBook.fromJson((l$book as Map<String, dynamic>)),
      podcastEpisode: l$podcastEpisode == null
          ? null
          : Fragment$fragmentPlaylistItem$podcastEpisode.fromJson(
              (l$podcastEpisode as Map<String, dynamic>),
            ),
      $__typename: (l$$__typename as String),
    );
  }

  final String id;

  final double position;

  final Enum$MediaType type;

  final Fragment$fragmentEpisode? episode;

  final Fragment$fragmentMovie? movie;

  final Fragment$fragmentPlaylistItem$track? track;

  final Fragment$fragmentBook? book;

  final Fragment$fragmentPlaylistItem$podcastEpisode? podcastEpisode;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$id = id;
    _resultData['id'] = l$id;
    final l$position = position;
    _resultData['position'] = l$position;
    final l$type = type;
    _resultData['type'] = toJson$Enum$MediaType(l$type);
    final l$episode = episode;
    _resultData['episode'] = l$episode?.toJson();
    final l$movie = movie;
    _resultData['movie'] = l$movie?.toJson();
    final l$track = track;
    _resultData['track'] = l$track?.toJson();
    final l$book = book;
    _resultData['book'] = l$book?.toJson();
    final l$podcastEpisode = podcastEpisode;
    _resultData['podcastEpisode'] = l$podcastEpisode?.toJson();
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$id = id;
    final l$position = position;
    final l$type = type;
    final l$episode = episode;
    final l$movie = movie;
    final l$track = track;
    final l$book = book;
    final l$podcastEpisode = podcastEpisode;
    final l$$__typename = $__typename;
    return Object.hashAll([
      l$id,
      l$position,
      l$type,
      l$episode,
      l$movie,
      l$track,
      l$book,
      l$podcastEpisode,
      l$$__typename,
    ]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Fragment$fragmentPlaylistItem ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$id = id;
    final lOther$id = other.id;
    if (l$id != lOther$id) {
      return false;
    }
    final l$position = position;
    final lOther$position = other.position;
    if (l$position != lOther$position) {
      return false;
    }
    final l$type = type;
    final lOther$type = other.type;
    if (l$type != lOther$type) {
      return false;
    }
    final l$episode = episode;
    final lOther$episode = other.episode;
    if (l$episode != lOther$episode) {
      return false;
    }
    final l$movie = movie;
    final lOther$movie = other.movie;
    if (l$movie != lOther$movie) {
      return false;
    }
    final l$track = track;
    final lOther$track = other.track;
    if (l$track != lOther$track) {
      return false;
    }
    final l$book = book;
    final lOther$book = other.book;
    if (l$book != lOther$book) {
      return false;
    }
    final l$podcastEpisode = podcastEpisode;
    final lOther$podcastEpisode = other.podcastEpisode;
    if (l$podcastEpisode != lOther$podcastEpisode) {
      return false;
    }
    final l$$__typename = $__typename;
    final lOther$$__typename = other.$__typename;
    if (l$$__typename != lOther$$__typename) {
      return false;
    }
    return true;
  }
}

extension UtilityExtension$Fragment$fragmentPlaylistItem
    on Fragment$fragmentPlaylistItem {
  CopyWith$Fragment$fragmentPlaylistItem<Fragment$fragmentPlaylistItem>
  get copyWith => CopyWith$Fragment$fragmentPlaylistItem(this, (i) => i);
}

abstract class CopyWith$Fragment$fragmentPlaylistItem<TRes> {
  factory CopyWith$Fragment$fragmentPlaylistItem(
    Fragment$fragmentPlaylistItem instance,
    TRes Function(Fragment$fragmentPlaylistItem) then,
  ) = _CopyWithImpl$Fragment$fragmentPlaylistItem;

  factory CopyWith$Fragment$fragmentPlaylistItem.stub(TRes res) =
      _CopyWithStubImpl$Fragment$fragmentPlaylistItem;

  TRes call({
    String? id,
    double? position,
    Enum$MediaType? type,
    Fragment$fragmentEpisode? episode,
    Fragment$fragmentMovie? movie,
    Fragment$fragmentPlaylistItem$track? track,
    Fragment$fragmentBook? book,
    Fragment$fragmentPlaylistItem$podcastEpisode? podcastEpisode,
    String? $__typename,
  });
  CopyWith$Fragment$fragmentEpisode<TRes> get episode;
  CopyWith$Fragment$fragmentMovie<TRes> get movie;
  CopyWith$Fragment$fragmentPlaylistItem$track<TRes> get track;
  CopyWith$Fragment$fragmentBook<TRes> get book;
  CopyWith$Fragment$fragmentPlaylistItem$podcastEpisode<TRes>
  get podcastEpisode;
}

class _CopyWithImpl$Fragment$fragmentPlaylistItem<TRes>
    implements CopyWith$Fragment$fragmentPlaylistItem<TRes> {
  _CopyWithImpl$Fragment$fragmentPlaylistItem(this._instance, this._then);

  final Fragment$fragmentPlaylistItem _instance;

  final TRes Function(Fragment$fragmentPlaylistItem) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? id = _undefined,
    Object? position = _undefined,
    Object? type = _undefined,
    Object? episode = _undefined,
    Object? movie = _undefined,
    Object? track = _undefined,
    Object? book = _undefined,
    Object? podcastEpisode = _undefined,
    Object? $__typename = _undefined,
  }) => _then(
    Fragment$fragmentPlaylistItem(
      id: id == _undefined || id == null ? _instance.id : (id as String),
      position: position == _undefined || position == null
          ? _instance.position
          : (position as double),
      type: type == _undefined || type == null
          ? _instance.type
          : (type as Enum$MediaType),
      episode: episode == _undefined
          ? _instance.episode
          : (episode as Fragment$fragmentEpisode?),
      movie: movie == _undefined
          ? _instance.movie
          : (movie as Fragment$fragmentMovie?),
      track: track == _undefined
          ? _instance.track
          : (track as Fragment$fragmentPlaylistItem$track?),
      book: book == _undefined
          ? _instance.book
          : (book as Fragment$fragmentBook?),
      podcastEpisode: podcastEpisode == _undefined
          ? _instance.podcastEpisode
          : (podcastEpisode as Fragment$fragmentPlaylistItem$podcastEpisode?),
      $__typename: $__typename == _undefined || $__typename == null
          ? _instance.$__typename
          : ($__typename as String),
    ),
  );

  CopyWith$Fragment$fragmentEpisode<TRes> get episode {
    final local$episode = _instance.episode;
    return local$episode == null
        ? CopyWith$Fragment$fragmentEpisode.stub(_then(_instance))
        : CopyWith$Fragment$fragmentEpisode(
            local$episode,
            (e) => call(episode: e),
          );
  }

  CopyWith$Fragment$fragmentMovie<TRes> get movie {
    final local$movie = _instance.movie;
    return local$movie == null
        ? CopyWith$Fragment$fragmentMovie.stub(_then(_instance))
        : CopyWith$Fragment$fragmentMovie(local$movie, (e) => call(movie: e));
  }

  CopyWith$Fragment$fragmentPlaylistItem$track<TRes> get track {
    final local$track = _instance.track;
    return local$track == null
        ? CopyWith$Fragment$fragmentPlaylistItem$track.stub(_then(_instance))
        : CopyWith$Fragment$fragmentPlaylistItem$track(
            local$track,
            (e) => call(track: e),
          );
  }

  CopyWith$Fragment$fragmentBook<TRes> get book {
    final local$book = _instance.book;
    return local$book == null
        ? CopyWith$Fragment$fragmentBook.stub(_then(_instance))
        : CopyWith$Fragment$fragmentBook(local$book, (e) => call(book: e));
  }

  CopyWith$Fragment$fragmentPlaylistItem$podcastEpisode<TRes>
  get podcastEpisode {
    final local$podcastEpisode = _instance.podcastEpisode;
    return local$podcastEpisode == null
        ? CopyWith$Fragment$fragmentPlaylistItem$podcastEpisode.stub(
            _then(_instance),
          )
        : CopyWith$Fragment$fragmentPlaylistItem$podcastEpisode(
            local$podcastEpisode,
            (e) => call(podcastEpisode: e),
          );
  }
}

class _CopyWithStubImpl$Fragment$fragmentPlaylistItem<TRes>
    implements CopyWith$Fragment$fragmentPlaylistItem<TRes> {
  _CopyWithStubImpl$Fragment$fragmentPlaylistItem(this._res);

  TRes _res;

  call({
    String? id,
    double? position,
    Enum$MediaType? type,
    Fragment$fragmentEpisode? episode,
    Fragment$fragmentMovie? movie,
    Fragment$fragmentPlaylistItem$track? track,
    Fragment$fragmentBook? book,
    Fragment$fragmentPlaylistItem$podcastEpisode? podcastEpisode,
    String? $__typename,
  }) => _res;

  CopyWith$Fragment$fragmentEpisode<TRes> get episode =>
      CopyWith$Fragment$fragmentEpisode.stub(_res);

  CopyWith$Fragment$fragmentMovie<TRes> get movie =>
      CopyWith$Fragment$fragmentMovie.stub(_res);

  CopyWith$Fragment$fragmentPlaylistItem$track<TRes> get track =>
      CopyWith$Fragment$fragmentPlaylistItem$track.stub(_res);

  CopyWith$Fragment$fragmentBook<TRes> get book =>
      CopyWith$Fragment$fragmentBook.stub(_res);

  CopyWith$Fragment$fragmentPlaylistItem$podcastEpisode<TRes>
  get podcastEpisode =>
      CopyWith$Fragment$fragmentPlaylistItem$podcastEpisode.stub(_res);
}

const fragmentDefinitionfragmentPlaylistItem = FragmentDefinitionNode(
  name: NameNode(value: 'fragmentPlaylistItem'),
  typeCondition: TypeConditionNode(
    on: NamedTypeNode(name: NameNode(value: 'PlaylistItem'), isNonNull: false),
  ),
  directives: [],
  selectionSet: SelectionSetNode(
    selections: [
      FieldNode(
        name: NameNode(value: 'id'),
        alias: null,
        arguments: [],
        directives: [],
        selectionSet: null,
      ),
      FieldNode(
        name: NameNode(value: 'position'),
        alias: null,
        arguments: [],
        directives: [],
        selectionSet: null,
      ),
      FieldNode(
        name: NameNode(value: 'type'),
        alias: null,
        arguments: [],
        directives: [],
        selectionSet: null,
      ),
      FieldNode(
        name: NameNode(value: 'episode'),
        alias: null,
        arguments: [],
        directives: [],
        selectionSet: SelectionSetNode(
          selections: [
            FragmentSpreadNode(
              name: NameNode(value: 'fragmentEpisode'),
              directives: [],
            ),
            FieldNode(
              name: NameNode(value: '__typename'),
              alias: null,
              arguments: [],
              directives: [],
              selectionSet: null,
            ),
          ],
        ),
      ),
      FieldNode(
        name: NameNode(value: 'movie'),
        alias: null,
        arguments: [],
        directives: [],
        selectionSet: SelectionSetNode(
          selections: [
            FragmentSpreadNode(
              name: NameNode(value: 'fragmentMovie'),
              directives: [],
            ),
            FieldNode(
              name: NameNode(value: '__typename'),
              alias: null,
              arguments: [],
              directives: [],
              selectionSet: null,
            ),
          ],
        ),
      ),
      FieldNode(
        name: NameNode(value: 'track'),
        alias: null,
        arguments: [],
        directives: [],
        selectionSet: SelectionSetNode(
          selections: [
            FieldNode(
              name: NameNode(value: 'id'),
              alias: null,
              arguments: [],
              directives: [],
              selectionSet: null,
            ),
            FieldNode(
              name: NameNode(value: 'number'),
              alias: null,
              arguments: [],
              directives: [],
              selectionSet: null,
            ),
            FieldNode(
              name: NameNode(value: 'discNumber'),
              alias: null,
              arguments: [],
              directives: [],
              selectionSet: null,
            ),
            FieldNode(
              name: NameNode(value: 'artist'),
              alias: null,
              arguments: [],
              directives: [],
              selectionSet: SelectionSetNode(
                selections: [
                  FieldNode(
                    name: NameNode(value: 'id'),
                    alias: null,
                    arguments: [],
                    directives: [],
                    selectionSet: null,
                  ),
                  FieldNode(
                    name: NameNode(value: 'name'),
                    alias: null,
                    arguments: [],
                    directives: [],
                    selectionSet: null,
                  ),
                  FieldNode(
                    name: NameNode(value: '__typename'),
                    alias: null,
                    arguments: [],
                    directives: [],
                    selectionSet: null,
                  ),
                ],
              ),
            ),
            FieldNode(
              name: NameNode(value: 'album'),
              alias: null,
              arguments: [],
              directives: [],
              selectionSet: SelectionSetNode(
                selections: [
                  FieldNode(
                    name: NameNode(value: 'id'),
                    alias: null,
                    arguments: [],
                    directives: [],
                    selectionSet: null,
                  ),
                  FieldNode(
                    name: NameNode(value: 'name'),
                    alias: null,
                    arguments: [],
                    directives: [],
                    selectionSet: null,
                  ),
                  FieldNode(
                    name: NameNode(value: 'images'),
                    alias: null,
                    arguments: [],
                    directives: [],
                    selectionSet: SelectionSetNode(
                      selections: [
                        FragmentSpreadNode(
                          name: NameNode(value: 'fragmentImages'),
                          directives: [],
                        ),
                        FieldNode(
                          name: NameNode(value: '__typename'),
                          alias: null,
                          arguments: [],
                          directives: [],
                          selectionSet: null,
                        ),
                      ],
                    ),
                  ),
                  FieldNode(
                    name: NameNode(value: '__typename'),
                    alias: null,
                    arguments: [],
                    directives: [],
                    selectionSet: null,
                  ),
                ],
              ),
            ),
            FieldNode(
              name: NameNode(value: 'metadata'),
              alias: null,
              arguments: [],
              directives: [],
              selectionSet: SelectionSetNode(
                selections: [
                  FragmentSpreadNode(
                    name: NameNode(value: 'fragmentMetadata'),
                    directives: [],
                  ),
                  FieldNode(
                    name: NameNode(value: '__typename'),
                    alias: null,
                    arguments: [],
                    directives: [],
                    selectionSet: null,
                  ),
                ],
              ),
            ),
            FieldNode(
              name: NameNode(value: 'mediaFile'),
              alias: null,
              arguments: [],
              directives: [],
              selectionSet: SelectionSetNode(
                selections: [
                  FragmentSpreadNode(
                    name: NameNode(value: 'fragmentMediaFiles'),
                    directives: [],
                  ),
                  FieldNode(
                    name: NameNode(value: '__typename'),
                    alias: null,
                    arguments: [],
                    directives: [],
                    selectionSet: null,
                  ),
                ],
              ),
            ),
            FieldNode(
              name: NameNode(value: 'rating'),
              alias: null,
              arguments: [],
              directives: [],
              selectionSet: null,
            ),
            FieldNode(
              name: NameNode(value: '__typename'),
              alias: null,
              arguments: [],
              directives: [],
              selectionSet: null,
            ),
          ],
        ),
      ),
      FieldNode(
        name: NameNode(value: 'book'),
        alias: null,
        arguments: [],
        directives: [],
        selectionSet: SelectionSetNode(
          selections: [
            FragmentSpreadNode(
              name: NameNode(value: 'fragmentBook'),
              directives: [],
            ),
            FieldNode(
              name: NameNode(value: '__typename'),
              alias: null,
              arguments: [],
              directives: [],
              selectionSet: null,
            ),
          ],
        ),
      ),
      FieldNode(
        name: NameNode(value: 'podcastEpisode'),
        alias: null,
        arguments: [],
        directives: [],
        selectionSet: SelectionSetNode(
          selections: [
            FieldNode(
              name: NameNode(value: 'id'),
              alias: null,
              arguments: [],
              directives: [],
              selectionSet: null,
            ),
            FieldNode(
              name: NameNode(value: 'publishedAt'),
              alias: null,
              arguments: [],
              directives: [],
              selectionSet: null,
            ),
            FieldNode(
              name: NameNode(value: 'podcast'),
              alias: null,
              arguments: [],
              directives: [],
              selectionSet: SelectionSetNode(
                selections: [
                  FieldNode(
                    name: NameNode(value: 'id'),
                    alias: null,
                    arguments: [],
                    directives: [],
                    selectionSet: null,
                  ),
                  FieldNode(
                    name: NameNode(value: 'title'),
                    alias: null,
                    arguments: [],
                    directives: [],
                    selectionSet: null,
                  ),
                  FieldNode(
                    name: NameNode(value: 'author'),
                    alias: null,
                    arguments: [],
                    directives: [],
                    selectionSet: null,
                  ),
                  FieldNode(
                    name: NameNode(value: 'images'),
                    alias: null,
                    arguments: [],
                    directives: [],
                    selectionSet: SelectionSetNode(
                      selections: [
                        FragmentSpreadNode(
                          name: NameNode(value: 'fragmentImages'),
                          directives: [],
                        ),
                        FieldNode(
                          name: NameNode(value: '__typename'),
                          alias: null,
                          arguments: [],
                          directives: [],
                          selectionSet: null,
                        ),
                      ],
                    ),
                  ),
                  FieldNode(
                    name: NameNode(value: '__typename'),
                    alias: null,
                    arguments: [],
                    directives: [],
                    selectionSet: null,
                  ),
                ],
              ),
            ),
            FieldNode(
              name: NameNode(value: 'metadata'),
              alias: null,
              arguments: [],
              directives: [],
              selectionSet: SelectionSetNode(
                selections: [
                  FragmentSpreadNode(
                    name: NameNode(value: 'fragmentMetadata'),
                    directives: [],
                  ),
                  FieldNode(
                    name: NameNode(value: '__typename'),
                    alias: null,
                    arguments: [],
                    directives: [],
                    selectionSet: null,
                  ),
                ],
              ),
            ),
            FieldNode(
              name: NameNode(value: 'mediaFile'),
              alias: null,
              arguments: [],
              directives: [],
              selectionSet: SelectionSetNode(
                selections: [
                  FragmentSpreadNode(
                    name: NameNode(value: 'fragmentMediaFiles'),
                    directives: [],
                  ),
                  FieldNode(
                    name: NameNode(value: '__typename'),
                    alias: null,
                    arguments: [],
                    directives: [],
                    selectionSet: null,
                  ),
                ],
              ),
            ),
            FieldNode(
              name: NameNode(value: 'watchStatus'),
              alias: null,
              arguments: [],
              directives: [],
              selectionSet: SelectionSetNode(
                selections: [
                  FragmentSpreadNode(
                    name: NameNode(value: 'fragmentWatchStatus'),
                    directives: [],
                  ),
                  FieldNode(
                    name: NameNode(value: '__typename'),
                    alias: null,
                    arguments: [],
                    directives: [],
                    selectionSet: null,
                  ),
                ],
              ),
            ),
            FieldNode(
              name: NameNode(value: '__typename'),
              alias: null,
              arguments: [],
              directives: [],
              selectionSet: null,
            ),
          ],
        ),
      ),
      FieldNode(
        name: NameNode(value: '__typename'),
        alias: null,
        arguments: [],
        directives: [],
        selectionSet: null,
      ),
    ],
  ),
);
const documentNodeFragmentfragmentPlaylistItem = DocumentNode(
  definitions: [
    fragmentDefinitionfragmentPlaylistItem,
    fragmentDefinitionfragmentEpisode,
    fragmentDefinitionfragmentMetadata,
    fragmentDefinitionfragmentImages,
    fragmentDefinitionfragmentMediaFiles,
    fragmentDefinitionfragmentCastMember,
    fragmentDefinitionfragmentMovie,
    fragmentDefinitionfragmentBook,
    fragmentDefinitionfragmentWatchStatus,
  ],
);

class Fragment$fragmentPlaylistItem$track {
  Fragment$fragmentPlaylistItem$track({
    required this.id,
    required this.number,
    required this.discNumber,
    required this.artist,
    required this.album,
    this.metadata,
    this.mediaFile,
    this.rating,
    this.$__typename = 'Track',
  });

  factory Fragment$fragmentPlaylistItem$track.fromJson(
    Map<String, dynamic> json,
  ) {
    final l$id = json['id'];
    final l$number = json['number'];
    final l$discNumber = json['discNumber'];
    final l$artist = json['artist'];
    final l$album = json['album'];
    final l$metadata = json['metadata'];
    final l$mediaFile = json['mediaFile'];
    final l$rating = json['rating'];
    final l$$__typename = json['__typename'];
    return Fragment$fragmentPlaylistItem$track(
      id: (l$id as String),
      number: (l$number as int),
      discNumber: (l$discNumber as int),
      artist: Fragment$fragmentPlaylistItem$track$artist.fromJson(
        (l$artist as Map<String, dynamic>),
      ),
      album: Fragment$fragmentPlaylistItem$track$album.fromJson(
        (l$album as Map<String, dynamic>),
      ),
      metadata: (l$metadata as List<dynamic>?)
          ?.map(
            (e) =>
                Fragment$fragmentMetadata.fromJson((e as Map<String, dynamic>)),
          )
          .toList(),
      mediaFile: (l$mediaFile as List<dynamic>?)
          ?.map(
            (e) => Fragment$fragmentMediaFiles.fromJson(
              (e as Map<String, dynamic>),
            ),
          )
          .toList(),
      rating: (l$rating as int?),
      $__typename: (l$$__typename as String),
    );
  }

  final String id;

  final int number;

  final int discNumber;

  final Fragment$fragmentPlaylistItem$track$artist artist;

  final Fragment$fragmentPlaylistItem$track$album album;

  final List<Fragment$fragmentMetadata>? metadata;

  final List<Fragment$fragmentMediaFiles>? mediaFile;

  final int? rating;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$id = id;
    _resultData['id'] = l$id;
    final l$number = number;
    _resultData['number'] = l$number;
    final l$discNumber = discNumber;
    _resultData['discNumber'] = l$discNumber;
    final l$artist = artist;
    _resultData['artist'] = l$artist.toJson();
    final l$album = album;
    _resultData['album'] = l$album.toJson();
    final l$metadata = metadata;
    _resultData['metadata'] = l$metadata?.map((e) => e.toJson()).toList();
    final l$mediaFile = mediaFile;
    _resultData['mediaFile'] = l$mediaFile?.map((e) => e.toJson()).toList();
    final l$rating = rating;
    _resultData['rating'] = l$rating;
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$id = id;
    final l$number = number;
    final l$discNumber = discNumber;
    final l$artist = artist;
    final l$album = album;
    final l$metadata = metadata;
    final l$mediaFile = mediaFile;
    final l$rating = rating;
    final l$$__typename = $__typename;
    return Object.hashAll([
      l$id,
      l$number,
      l$discNumber,
      l$artist,
      l$album,
      l$metadata == null ? null : Object.hashAll(l$metadata.map((v) => v)),
      l$mediaFile == null ? null : Object.hashAll(l$mediaFile.map((v) => v)),
      l$rating,
      l$$__typename,
    ]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Fragment$fragmentPlaylistItem$track ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$id = id;
    final lOther$id = other.id;
    if (l$id != lOther$id) {
      return false;
    }
    final l$number = number;
    final lOther$number = other.number;
    if (l$number != lOther$number) {
      return false;
    }
    final l$discNumber = discNumber;
    final lOther$discNumber = other.discNumber;
    if (l$discNumber != lOther$discNumber) {
      return false;
    }
    final l$artist = artist;
    final lOther$artist = other.artist;
    if (l$artist != lOther$artist) {
      return false;
    }
    final l$album = album;
    final lOther$album = other.album;
    if (l$album != lOther$album) {
      return false;
    }
    final l$metadata = metadata;
    final lOther$metadata = other.metadata;
    if (l$metadata != null && lOther$metadata != null) {
      if (l$metadata.length != lOther$metadata.length) {
        return false;
      }
      for (int i = 0; i < l$metadata.length; i++) {
        final l$metadata$entry = l$metadata[i];
        final lOther$metadata$entry = lOther$metadata[i];
        if (l$metadata$entry != lOther$metadata$entry) {
          return false;
        }
      }
    } else if (l$metadata != lOther$metadata) {
      return false;
    }
    final l$mediaFile = mediaFile;
    final lOther$mediaFile = other.mediaFile;
    if (l$mediaFile != null && lOther$mediaFile != null) {
      if (l$mediaFile.length != lOther$mediaFile.length) {
        return false;
      }
      for (int i = 0; i < l$mediaFile.length; i++) {
        final l$mediaFile$entry = l$mediaFile[i];
        final lOther$mediaFile$entry = lOther$mediaFile[i];
        if (l$mediaFile$entry != lOther$mediaFile$entry) {
          return false;
        }
      }
    } else if (l$mediaFile != lOther$mediaFile) {
      return false;
    }
    final l$rating = rating;
    final lOther$rating = other.rating;
    if (l$rating != lOther$rating) {
      return false;
    }
    final l$$__typename = $__typename;
    final lOther$$__typename = other.$__typename;
    if (l$$__typename != lOther$$__typename) {
      return false;
    }
    return true;
  }
}

extension UtilityExtension$Fragment$fragmentPlaylistItem$track
    on Fragment$fragmentPlaylistItem$track {
  CopyWith$Fragment$fragmentPlaylistItem$track<
    Fragment$fragmentPlaylistItem$track
  >
  get copyWith => CopyWith$Fragment$fragmentPlaylistItem$track(this, (i) => i);
}

abstract class CopyWith$Fragment$fragmentPlaylistItem$track<TRes> {
  factory CopyWith$Fragment$fragmentPlaylistItem$track(
    Fragment$fragmentPlaylistItem$track instance,
    TRes Function(Fragment$fragmentPlaylistItem$track) then,
  ) = _CopyWithImpl$Fragment$fragmentPlaylistItem$track;

  factory CopyWith$Fragment$fragmentPlaylistItem$track.stub(TRes res) =
      _CopyWithStubImpl$Fragment$fragmentPlaylistItem$track;

  TRes call({
    String? id,
    int? number,
    int? discNumber,
    Fragment$fragmentPlaylistItem$track$artist? artist,
    Fragment$fragmentPlaylistItem$track$album? album,
    List<Fragment$fragmentMetadata>? metadata,
    List<Fragment$fragmentMediaFiles>? mediaFile,
    int? rating,
    String? $__typename,
  });
  CopyWith$Fragment$fragmentPlaylistItem$track$artist<TRes> get artist;
  CopyWith$Fragment$fragmentPlaylistItem$track$album<TRes> get album;
  TRes metadata(
    Iterable<Fragment$fragmentMetadata>? Function(
      Iterable<CopyWith$Fragment$fragmentMetadata<Fragment$fragmentMetadata>>?,
    )
    _fn,
  );
  TRes mediaFile(
    Iterable<Fragment$fragmentMediaFiles>? Function(
      Iterable<
        CopyWith$Fragment$fragmentMediaFiles<Fragment$fragmentMediaFiles>
      >?,
    )
    _fn,
  );
}

class _CopyWithImpl$Fragment$fragmentPlaylistItem$track<TRes>
    implements CopyWith$Fragment$fragmentPlaylistItem$track<TRes> {
  _CopyWithImpl$Fragment$fragmentPlaylistItem$track(this._instance, this._then);

  final Fragment$fragmentPlaylistItem$track _instance;

  final TRes Function(Fragment$fragmentPlaylistItem$track) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? id = _undefined,
    Object? number = _undefined,
    Object? discNumber = _undefined,
    Object? artist = _undefined,
    Object? album = _undefined,
    Object? metadata = _undefined,
    Object? mediaFile = _undefined,
    Object? rating = _undefined,
    Object? $__typename = _undefined,
  }) => _then(
    Fragment$fragmentPlaylistItem$track(
      id: id == _undefined || id == null ? _instance.id : (id as String),
      number: number == _undefined || number == null
          ? _instance.number
          : (number as int),
      discNumber: discNumber == _undefined || discNumber == null
          ? _instance.discNumber
          : (discNumber as int),
      artist: artist == _undefined || artist == null
          ? _instance.artist
          : (artist as Fragment$fragmentPlaylistItem$track$artist),
      album: album == _undefined || album == null
          ? _instance.album
          : (album as Fragment$fragmentPlaylistItem$track$album),
      metadata: metadata == _undefined
          ? _instance.metadata
          : (metadata as List<Fragment$fragmentMetadata>?),
      mediaFile: mediaFile == _undefined
          ? _instance.mediaFile
          : (mediaFile as List<Fragment$fragmentMediaFiles>?),
      rating: rating == _undefined ? _instance.rating : (rating as int?),
      $__typename: $__typename == _undefined || $__typename == null
          ? _instance.$__typename
          : ($__typename as String),
    ),
  );

  CopyWith$Fragment$fragmentPlaylistItem$track$artist<TRes> get artist {
    final local$artist = _instance.artist;
    return CopyWith$Fragment$fragmentPlaylistItem$track$artist(
      local$artist,
      (e) => call(artist: e),
    );
  }

  CopyWith$Fragment$fragmentPlaylistItem$track$album<TRes> get album {
    final local$album = _instance.album;
    return CopyWith$Fragment$fragmentPlaylistItem$track$album(
      local$album,
      (e) => call(album: e),
    );
  }

  TRes metadata(
    Iterable<Fragment$fragmentMetadata>? Function(
      Iterable<CopyWith$Fragment$fragmentMetadata<Fragment$fragmentMetadata>>?,
    )
    _fn,
  ) => call(
    metadata: _fn(
      _instance.metadata?.map(
        (e) => CopyWith$Fragment$fragmentMetadata(e, (i) => i),
      ),
    )?.toList(),
  );

  TRes mediaFile(
    Iterable<Fragment$fragmentMediaFiles>? Function(
      Iterable<
        CopyWith$Fragment$fragmentMediaFiles<Fragment$fragmentMediaFiles>
      >?,
    )
    _fn,
  ) => call(
    mediaFile: _fn(
      _instance.mediaFile?.map(
        (e) => CopyWith$Fragment$fragmentMediaFiles(e, (i) => i),
      ),
    )?.toList(),
  );
}

class _CopyWithStubImpl$Fragment$fragmentPlaylistItem$track<TRes>
    implements CopyWith$Fragment$fragmentPlaylistItem$track<TRes> {
  _CopyWithStubImpl$Fragment$fragmentPlaylistItem$track(this._res);

  TRes _res;

  call({
    String? id,
    int? number,
    int? discNumber,
    Fragment$fragmentPlaylistItem$track$artist? artist,
    Fragment$fragmentPlaylistItem$track$album? album,
    List<Fragment$fragmentMetadata>? metadata,
    List<Fragment$fragmentMediaFiles>? mediaFile,
    int? rating,
    String? $__typename,
  }) => _res;

  CopyWith$Fragment$fragmentPlaylistItem$track$artist<TRes> get artist =>
      CopyWith$Fragment$fragmentPlaylistItem$track$artist.stub(_res);

  CopyWith$Fragment$fragmentPlaylistItem$track$album<TRes> get album =>
      CopyWith$Fragment$fragmentPlaylistItem$track$album.stub(_res);

  metadata(_fn) => _res;

  mediaFile(_fn) => _res;
}

class Fragment$fragmentPlaylistItem$track$artist {
  Fragment$fragmentPlaylistItem$track$artist({
    required this.id,
    required this.name,
    this.$__typename = 'Person',
  });

  factory Fragment$fragmentPlaylistItem$track$artist.fromJson(
    Map<String, dynamic> json,
  ) {
    final l$id = json['id'];
    final l$name = json['name'];
    final l$$__typename = json['__typename'];
    return Fragment$fragmentPlaylistItem$track$artist(
      id: (l$id as String),
      name: (l$name as String),
      $__typename: (l$$__typename as String),
    );
  }

  final String id;

  final String name;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$id = id;
    _resultData['id'] = l$id;
    final l$name = name;
    _resultData['name'] = l$name;
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$id = id;
    final l$name = name;
    final l$$__typename = $__typename;
    return Object.hashAll([l$id, l$name, l$$__typename]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Fragment$fragmentPlaylistItem$track$artist ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$id = id;
    final lOther$id = other.id;
    if (l$id != lOther$id) {
      return false;
    }
    final l$name = name;
    final lOther$name = other.name;
    if (l$name != lOther$name) {
      return false;
    }
    final l$$__typename = $__typename;
    final lOther$$__typename = other.$__typename;
    if (l$$__typename != lOther$$__typename) {
      return false;
    }
    return true;
  }
}

extension UtilityExtension$Fragment$fragmentPlaylistItem$track$artist
    on Fragment$fragmentPlaylistItem$track$artist {
  CopyWith$Fragment$fragmentPlaylistItem$track$artist<
    Fragment$fragmentPlaylistItem$track$artist
  >
  get copyWith =>
      CopyWith$Fragment$fragmentPlaylistItem$track$artist(this, (i) => i);
}

abstract class CopyWith$Fragment$fragmentPlaylistItem$track$artist<TRes> {
  factory CopyWith$Fragment$fragmentPlaylistItem$track$artist(
    Fragment$fragmentPlaylistItem$track$artist instance,
    TRes Function(Fragment$fragmentPlaylistItem$track$artist) then,
  ) = _CopyWithImpl$Fragment$fragmentPlaylistItem$track$artist;

  factory CopyWith$Fragment$fragmentPlaylistItem$track$artist.stub(TRes res) =
      _CopyWithStubImpl$Fragment$fragmentPlaylistItem$track$artist;

  TRes call({String? id, String? name, String? $__typename});
}

class _CopyWithImpl$Fragment$fragmentPlaylistItem$track$artist<TRes>
    implements CopyWith$Fragment$fragmentPlaylistItem$track$artist<TRes> {
  _CopyWithImpl$Fragment$fragmentPlaylistItem$track$artist(
    this._instance,
    this._then,
  );

  final Fragment$fragmentPlaylistItem$track$artist _instance;

  final TRes Function(Fragment$fragmentPlaylistItem$track$artist) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? id = _undefined,
    Object? name = _undefined,
    Object? $__typename = _undefined,
  }) => _then(
    Fragment$fragmentPlaylistItem$track$artist(
      id: id == _undefined || id == null ? _instance.id : (id as String),
      name: name == _undefined || name == null
          ? _instance.name
          : (name as String),
      $__typename: $__typename == _undefined || $__typename == null
          ? _instance.$__typename
          : ($__typename as String),
    ),
  );
}

class _CopyWithStubImpl$Fragment$fragmentPlaylistItem$track$artist<TRes>
    implements CopyWith$Fragment$fragmentPlaylistItem$track$artist<TRes> {
  _CopyWithStubImpl$Fragment$fragmentPlaylistItem$track$artist(this._res);

  TRes _res;

  call({String? id, String? name, String? $__typename}) => _res;
}

class Fragment$fragmentPlaylistItem$track$album {
  Fragment$fragmentPlaylistItem$track$album({
    required this.id,
    required this.name,
    this.images,
    this.$__typename = 'Album',
  });

  factory Fragment$fragmentPlaylistItem$track$album.fromJson(
    Map<String, dynamic> json,
  ) {
    final l$id = json['id'];
    final l$name = json['name'];
    final l$images = json['images'];
    final l$$__typename = json['__typename'];
    return Fragment$fragmentPlaylistItem$track$album(
      id: (l$id as String),
      name: (l$name as String),
      images: (l$images as List<dynamic>?)
          ?.map(
            (e) =>
                Fragment$fragmentImages.fromJson((e as Map<String, dynamic>)),
          )
          .toList(),
      $__typename: (l$$__typename as String),
    );
  }

  final String id;

  final String name;

  final List<Fragment$fragmentImages>? images;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$id = id;
    _resultData['id'] = l$id;
    final l$name = name;
    _resultData['name'] = l$name;
    final l$images = images;
    _resultData['images'] = l$images?.map((e) => e.toJson()).toList();
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$id = id;
    final l$name = name;
    final l$images = images;
    final l$$__typename = $__typename;
    return Object.hashAll([
      l$id,
      l$name,
      l$images == null ? null : Object.hashAll(l$images.map((v) => v)),
      l$$__typename,
    ]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Fragment$fragmentPlaylistItem$track$album ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$id = id;
    final lOther$id = other.id;
    if (l$id != lOther$id) {
      return false;
    }
    final l$name = name;
    final lOther$name = other.name;
    if (l$name != lOther$name) {
      return false;
    }
    final l$images = images;
    final lOther$images = other.images;
    if (l$images != null && lOther$images != null) {
      if (l$images.length != lOther$images.length) {
        return false;
      }
      for (int i = 0; i < l$images.length; i++) {
        final l$images$entry = l$images[i];
        final lOther$images$entry = lOther$images[i];
        if (l$images$entry != lOther$images$entry) {
          return false;
        }
      }
    } else if (l$images != lOther$images) {
      return false;
    }
    final l$$__typename = $__typename;
    final lOther$$__typename = other.$__typename;
    if (l$$__typename != lOther$$__typename) {
      return false;
    }
    return true;
  }
}

extension UtilityExtension$Fragment$fragmentPlaylistItem$track$album
    on Fragment$fragmentPlaylistItem$track$album {
  CopyWith$Fragment$fragmentPlaylistItem$track$album<
    Fragment$fragmentPlaylistItem$track$album
  >
  get copyWith =>
      CopyWith$Fragment$fragmentPlaylistItem$track$album(this, (i) => i);
}

abstract class CopyWith$Fragment$fragmentPlaylistItem$track$album<TRes> {
  factory CopyWith$Fragment$fragmentPlaylistItem$track$album(
    Fragment$fragmentPlaylistItem$track$album instance,
    TRes Function(Fragment$fragmentPlaylistItem$track$album) then,
  ) = _CopyWithImpl$Fragment$fragmentPlaylistItem$track$album;

  factory CopyWith$Fragment$fragmentPlaylistItem$track$album.stub(TRes res) =
      _CopyWithStubImpl$Fragment$fragmentPlaylistItem$track$album;

  TRes call({
    String? id,
    String? name,
    List<Fragment$fragmentImages>? images,
    String? $__typename,
  });
  TRes images(
    Iterable<Fragment$fragmentImages>? Function(
      Iterable<CopyWith$Fragment$fragmentImages<Fragment$fragmentImages>>?,
    )
    _fn,
  );
}

class _CopyWithImpl$Fragment$fragmentPlaylistItem$track$album<TRes>
    implements CopyWith$Fragment$fragmentPlaylistItem$track$album<TRes> {
  _CopyWithImpl$Fragment$fragmentPlaylistItem$track$album(
    this._instance,
    this._then,
  );

  final Fragment$fragmentPlaylistItem$track$album _instance;

  final TRes Function(Fragment$fragmentPlaylistItem$track$album) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? id = _undefined,
    Object? name = _undefined,
    Object? images = _undefined,
    Object? $__typename = _undefined,
  }) => _then(
    Fragment$fragmentPlaylistItem$track$album(
      id: id == _undefined || id == null ? _instance.id : (id as String),
      name: name == _undefined || name == null
          ? _instance.name
          : (name as String),
      images: images == _undefined
          ? _instance.images
          : (images as List<Fragment$fragmentImages>?),
      $__typename: $__typename == _undefined || $__typename == null
          ? _instance.$__typename
          : ($__typename as String),
    ),
  );

  TRes images(
    Iterable<Fragment$fragmentImages>? Function(
      Iterable<CopyWith$Fragment$fragmentImages<Fragment$fragmentImages>>?,
    )
    _fn,
  ) => call(
    images: _fn(
      _instance.images?.map(
        (e) => CopyWith$Fragment$fragmentImages(e, (i) => i),
      ),
    )?.toList(),
  );
}

class _CopyWithStubImpl$Fragment$fragmentPlaylistItem$track$album<TRes>
    implements CopyWith$Fragment$fragmentPlaylistItem$track$album<TRes> {
  _CopyWithStubImpl$Fragment$fragmentPlaylistItem$track$album(this._res);

  TRes _res;

  call({
    String? id,
    String? name,
    List<Fragment$fragmentImages>? images,
    String? $__typename,
  }) => _res;

  images(_fn) => _res;
}

class Fragment$fragmentPlaylistItem$podcastEpisode {
  Fragment$fragmentPlaylistItem$podcastEpisode({
    required this.id,
    this.publishedAt,
    required this.podcast,
    this.metadata,
    this.mediaFile,
    this.watchStatus,
    this.$__typename = 'PodcastEpisode',
  });

  factory Fragment$fragmentPlaylistItem$podcastEpisode.fromJson(
    Map<String, dynamic> json,
  ) {
    final l$id = json['id'];
    final l$publishedAt = json['publishedAt'];
    final l$podcast = json['podcast'];
    final l$metadata = json['metadata'];
    final l$mediaFile = json['mediaFile'];
    final l$watchStatus = json['watchStatus'];
    final l$$__typename = json['__typename'];
    return Fragment$fragmentPlaylistItem$podcastEpisode(
      id: (l$id as String),
      publishedAt: (l$publishedAt as String?),
      podcast: Fragment$fragmentPlaylistItem$podcastEpisode$podcast.fromJson(
        (l$podcast as Map<String, dynamic>),
      ),
      metadata: (l$metadata as List<dynamic>?)
          ?.map(
            (e) =>
                Fragment$fragmentMetadata.fromJson((e as Map<String, dynamic>)),
          )
          .toList(),
      mediaFile: (l$mediaFile as List<dynamic>?)
          ?.map(
            (e) => Fragment$fragmentMediaFiles.fromJson(
              (e as Map<String, dynamic>),
            ),
          )
          .toList(),
      watchStatus: (l$watchStatus as List<dynamic>?)
          ?.map(
            (e) => Fragment$fragmentWatchStatus.fromJson(
              (e as Map<String, dynamic>),
            ),
          )
          .toList(),
      $__typename: (l$$__typename as String),
    );
  }

  final String id;

  final String? publishedAt;

  final Fragment$fragmentPlaylistItem$podcastEpisode$podcast podcast;

  final List<Fragment$fragmentMetadata>? metadata;

  final List<Fragment$fragmentMediaFiles>? mediaFile;

  final List<Fragment$fragmentWatchStatus>? watchStatus;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$id = id;
    _resultData['id'] = l$id;
    final l$publishedAt = publishedAt;
    _resultData['publishedAt'] = l$publishedAt;
    final l$podcast = podcast;
    _resultData['podcast'] = l$podcast.toJson();
    final l$metadata = metadata;
    _resultData['metadata'] = l$metadata?.map((e) => e.toJson()).toList();
    final l$mediaFile = mediaFile;
    _resultData['mediaFile'] = l$mediaFile?.map((e) => e.toJson()).toList();
    final l$watchStatus = watchStatus;
    _resultData['watchStatus'] = l$watchStatus?.map((e) => e.toJson()).toList();
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$id = id;
    final l$publishedAt = publishedAt;
    final l$podcast = podcast;
    final l$metadata = metadata;
    final l$mediaFile = mediaFile;
    final l$watchStatus = watchStatus;
    final l$$__typename = $__typename;
    return Object.hashAll([
      l$id,
      l$publishedAt,
      l$podcast,
      l$metadata == null ? null : Object.hashAll(l$metadata.map((v) => v)),
      l$mediaFile == null ? null : Object.hashAll(l$mediaFile.map((v) => v)),
      l$watchStatus == null
          ? null
          : Object.hashAll(l$watchStatus.map((v) => v)),
      l$$__typename,
    ]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Fragment$fragmentPlaylistItem$podcastEpisode ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$id = id;
    final lOther$id = other.id;
    if (l$id != lOther$id) {
      return false;
    }
    final l$publishedAt = publishedAt;
    final lOther$publishedAt = other.publishedAt;
    if (l$publishedAt != lOther$publishedAt) {
      return false;
    }
    final l$podcast = podcast;
    final lOther$podcast = other.podcast;
    if (l$podcast != lOther$podcast) {
      return false;
    }
    final l$metadata = metadata;
    final lOther$metadata = other.metadata;
    if (l$metadata != null && lOther$metadata != null) {
      if (l$metadata.length != lOther$metadata.length) {
        return false;
      }
      for (int i = 0; i < l$metadata.length; i++) {
        final l$metadata$entry = l$metadata[i];
        final lOther$metadata$entry = lOther$metadata[i];
        if (l$metadata$entry != lOther$metadata$entry) {
          return false;
        }
      }
    } else if (l$metadata != lOther$metadata) {
      return false;
    }
    final l$mediaFile = mediaFile;
    final lOther$mediaFile = other.mediaFile;
    if (l$mediaFile != null && lOther$mediaFile != null) {
      if (l$mediaFile.length != lOther$mediaFile.length) {
        return false;
      }
      for (int i = 0; i < l$mediaFile.length; i++) {
        final l$mediaFile$entry = l$mediaFile[i];
        final lOther$mediaFile$entry = lOther$mediaFile[i];
        if (l$mediaFile$entry != lOther$mediaFile$entry) {
          return false;
        }
      }
    } else if (l$mediaFile != lOther$mediaFile) {
      return false;
    }
    final l$watchStatus = watchStatus;
    final lOther$watchStatus = other.watchStatus;
    if (l$watchStatus != null && lOther$watchStatus != null) {
      if (l$watchStatus.length != lOther$watchStatus.length) {
        return false;
      }
      for (int i = 0; i < l$watchStatus.length; i++) {
        final l$watchStatus$entry = l$watchStatus[i];
        final lOther$watchStatus$entry = lOther$watchStatus[i];
        if (l$watchStatus$entry != lOther$watchStatus$entry) {
          return false;
        }
      }
    } else if (l$watchStatus != lOther$watchStatus) {
      return false;
    }
    final l$$__typename = $__typename;
    final lOther$$__typename = other.$__typename;
    if (l$$__typename != lOther$$__typename) {
      return false;
    }
    return true;
  }
}

extension UtilityExtension$Fragment$fragmentPlaylistItem$podcastEpisode
    on Fragment$fragmentPlaylistItem$podcastEpisode {
  CopyWith$Fragment$fragmentPlaylistItem$podcastEpisode<
    Fragment$fragmentPlaylistItem$podcastEpisode
  >
  get copyWith =>
      CopyWith$Fragment$fragmentPlaylistItem$podcastEpisode(this, (i) => i);
}

abstract class CopyWith$Fragment$fragmentPlaylistItem$podcastEpisode<TRes> {
  factory CopyWith$Fragment$fragmentPlaylistItem$podcastEpisode(
    Fragment$fragmentPlaylistItem$podcastEpisode instance,
    TRes Function(Fragment$fragmentPlaylistItem$podcastEpisode) then,
  ) = _CopyWithImpl$Fragment$fragmentPlaylistItem$podcastEpisode;

  factory CopyWith$Fragment$fragmentPlaylistItem$podcastEpisode.stub(TRes res) =
      _CopyWithStubImpl$Fragment$fragmentPlaylistItem$podcastEpisode;

  TRes call({
    String? id,
    String? publishedAt,
    Fragment$fragmentPlaylistItem$podcastEpisode$podcast? podcast,
    List<Fragment$fragmentMetadata>? metadata,
    List<Fragment$fragmentMediaFiles>? mediaFile,
    List<Fragment$fragmentWatchStatus>? watchStatus,
    String? $__typename,
  });
  CopyWith$Fragment$fragmentPlaylistItem$podcastEpisode$podcast<TRes>
  get podcast;
  TRes metadata(
    Iterable<Fragment$fragmentMetadata>? Function(
      Iterable<CopyWith$Fragment$fragmentMetadata<Fragment$fragmentMetadata>>?,
    )
    _fn,
  );
  TRes mediaFile(
    Iterable<Fragment$fragmentMediaFiles>? Function(
      Iterable<
        CopyWith$Fragment$fragmentMediaFiles<Fragment$fragmentMediaFiles>
      >?,
    )
    _fn,
  );
  TRes watchStatus(
    Iterable<Fragment$fragmentWatchStatus>? Function(
      Iterable<
        CopyWith$Fragment$fragmentWatchStatus<Fragment$fragmentWatchStatus>
      >?,
    )
    _fn,
  );
}

class _CopyWithImpl$Fragment$fragmentPlaylistItem$podcastEpisode<TRes>
    implements CopyWith$Fragment$fragmentPlaylistItem$podcastEpisode<TRes> {
  _CopyWithImpl$Fragment$fragmentPlaylistItem$podcastEpisode(
    this._instance,
    this._then,
  );

  final Fragment$fragmentPlaylistItem$podcastEpisode _instance;

  final TRes Function(Fragment$fragmentPlaylistItem$podcastEpisode) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? id = _undefined,
    Object? publishedAt = _undefined,
    Object? podcast = _undefined,
    Object? metadata = _undefined,
    Object? mediaFile = _undefined,
    Object? watchStatus = _undefined,
    Object? $__typename = _undefined,
  }) => _then(
    Fragment$fragmentPlaylistItem$podcastEpisode(
      id: id == _undefined || id == null ? _instance.id : (id as String),
      publishedAt: publishedAt == _undefined
          ? _instance.publishedAt
          : (publishedAt as String?),
      podcast: podcast == _undefined || podcast == null
          ? _instance.podcast
          : (podcast as Fragment$fragmentPlaylistItem$podcastEpisode$podcast),
      metadata: metadata == _undefined
          ? _instance.metadata
          : (metadata as List<Fragment$fragmentMetadata>?),
      mediaFile: mediaFile == _undefined
          ? _instance.mediaFile
          : (mediaFile as List<Fragment$fragmentMediaFiles>?),
      watchStatus: watchStatus == _undefined
          ? _instance.watchStatus
          : (watchStatus as List<Fragment$fragmentWatchStatus>?),
      $__typename: $__typename == _undefined || $__typename == null
          ? _instance.$__typename
          : ($__typename as String),
    ),
  );

  CopyWith$Fragment$fragmentPlaylistItem$podcastEpisode$podcast<TRes>
  get podcast {
    final local$podcast = _instance.podcast;
    return CopyWith$Fragment$fragmentPlaylistItem$podcastEpisode$podcast(
      local$podcast,
      (e) => call(podcast: e),
    );
  }

  TRes metadata(
    Iterable<Fragment$fragmentMetadata>? Function(
      Iterable<CopyWith$Fragment$fragmentMetadata<Fragment$fragmentMetadata>>?,
    )
    _fn,
  ) => call(
    metadata: _fn(
      _instance.metadata?.map(
        (e) => CopyWith$Fragment$fragmentMetadata(e, (i) => i),
      ),
    )?.toList(),
  );

  TRes mediaFile(
    Iterable<Fragment$fragmentMediaFiles>? Function(
      Iterable<
        CopyWith$Fragment$fragmentMediaFiles<Fragment$fragmentMediaFiles>
      >?,
    )
    _fn,
  ) => call(
    mediaFile: _fn(
      _instance.mediaFile?.map(
        (e) => CopyWith$Fragment$fragmentMediaFiles(e, (i) => i),
      ),
    )?.toList(),
  );

  TRes watchStatus(
    Iterable<Fragment$fragmentWatchStatus>? Function(
      Iterable<
        CopyWith$Fragment$fragmentWatchStatus<Fragment$fragmentWatchStatus>
      >?,
    )
    _fn,
  ) => call(
    watchStatus: _fn(
      _instance.watchStatus?.map(
        (e) => CopyWith$Fragment$fragmentWatchStatus(e, (i) => i),
      ),
    )?.toList(),
  );
}

class _CopyWithStubImpl$Fragment$fragmentPlaylistItem$podcastEpisode<TRes>
    implements CopyWith$Fragment$fragmentPlaylistItem$podcastEpisode<TRes> {
  _CopyWithStubImpl$Fragment$fragmentPlaylistItem$podcastEpisode(this._res);

  TRes _res;

  call({
    String? id,
    String? publishedAt,
    Fragment$fragmentPlaylistItem$podcastEpisode$podcast? podcast,
    List<Fragment$fragmentMetadata>? metadata,
    List<Fragment$fragmentMediaFiles>? mediaFile,
    List<Fragment$fragmentWatchStatus>? watchStatus,
    String? $__typename,
  }) => _res;

  CopyWith$Fragment$fragmentPlaylistItem$podcastEpisode$podcast<TRes>
  get podcast =>
      CopyWith$Fragment$fragmentPlaylistItem$podcastEpisode$podcast.stub(_res);

  metadata(_fn) => _res;

  mediaFile(_fn) => _res;

  watchStatus(_fn) => _res;
}

class Fragment$fragmentPlaylistItem$podcastEpisode$podcast {
  Fragment$fragmentPlaylistItem$podcastEpisode$podcast({
    required this.id,
    required this.title,
    this.author,
    this.images,
    this.$__typename = 'Podcast',
  });

  factory Fragment$fragmentPlaylistItem$podcastEpisode$podcast.fromJson(
    Map<String, dynamic> json,
  ) {
    final l$id = json['id'];
    final l$title = json['title'];
    final l$author = json['author'];
    final l$images = json['images'];
    final l$$__typename = json['__typename'];
    return Fragment$fragmentPlaylistItem$podcastEpisode$podcast(
      id: (l$id as String),
      title: (l$title as String),
      author: (l$author as String?),
      images: (l$images as List<dynamic>?)
          ?.map(
            (e) =>
                Fragment$fragmentImages.fromJson((e as Map<String, dynamic>)),
          )
          .toList(),
      $__typename: (l$$__typename as String),
    );
  }

  final String id;

  final String title;

  final String? author;

  final List<Fragment$fragmentImages>? images;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$id = id;
    _resultData['id'] = l$id;
    final l$title = title;
    _resultData['title'] = l$title;
    final l$author = author;
    _resultData['author'] = l$author;
    final l$images = images;
    _resultData['images'] = l$images?.map((e) => e.toJson()).toList();
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$id = id;
    final l$title = title;
    final l$author = author;
    final l$images = images;
    final l$$__typename = $__typename;
    return Object.hashAll([
      l$id,
      l$title,
      l$author,
      l$images == null ? null : Object.hashAll(l$images.map((v) => v)),
      l$$__typename,
    ]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Fragment$fragmentPlaylistItem$podcastEpisode$podcast ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$id = id;
    final lOther$id = other.id;
    if (l$id != lOther$id) {
      return false;
    }
    final l$title = title;
    final lOther$title = other.title;
    if (l$title != lOther$title) {
      return false;
    }
    final l$author = author;
    final lOther$author = other.author;
    if (l$author != lOther$author) {
      return false;
    }
    final l$images = images;
    final lOther$images = other.images;
    if (l$images != null && lOther$images != null) {
      if (l$images.length != lOther$images.length) {
        return false;
      }
      for (int i = 0; i < l$images.length; i++) {
        final l$images$entry = l$images[i];
        final lOther$images$entry = lOther$images[i];
        if (l$images$entry != lOther$images$entry) {
          return false;
        }
      }
    } else if (l$images != lOther$images) {
      return false;
    }
    final l$$__typename = $__typename;
    final lOther$$__typename = other.$__typename;
    if (l$$__typename != lOther$$__typename) {
      return false;
    }
    return true;
  }
}

extension UtilityExtension$Fragment$fragmentPlaylistItem$podcastEpisode$podcast
    on Fragment$fragmentPlaylistItem$podcastEpisode$podcast {
  CopyWith$Fragment$fragmentPlaylistItem$podcastEpisode$podcast<
    Fragment$fragmentPlaylistItem$podcastEpisode$podcast
  >
  get copyWith => CopyWith$Fragment$fragmentPlaylistItem$podcastEpisode$podcast(
    this,
    (i) => i,
  );
}

abstract class CopyWith$Fragment$fragmentPlaylistItem$podcastEpisode$podcast<
  TRes
> {
  factory CopyWith$Fragment$fragmentPlaylistItem$podcastEpisode$podcast(
    Fragment$fragmentPlaylistItem$podcastEpisode$podcast instance,
    TRes Function(Fragment$fragmentPlaylistItem$podcastEpisode$podcast) then,
  ) = _CopyWithImpl$Fragment$fragmentPlaylistItem$podcastEpisode$podcast;

  factory CopyWith$Fragment$fragmentPlaylistItem$podcastEpisode$podcast.stub(
    TRes res,
  ) = _CopyWithStubImpl$Fragment$fragmentPlaylistItem$podcastEpisode$podcast;

  TRes call({
    String? id,
    String? title,
    String? author,
    List<Fragment$fragmentImages>? images,
    String? $__typename,
  });
  TRes images(
    Iterable<Fragment$fragmentImages>? Function(
      Iterable<CopyWith$Fragment$fragmentImages<Fragment$fragmentImages>>?,
    )
    _fn,
  );
}

class _CopyWithImpl$Fragment$fragmentPlaylistItem$podcastEpisode$podcast<TRes>
    implements
        CopyWith$Fragment$fragmentPlaylistItem$podcastEpisode$podcast<TRes> {
  _CopyWithImpl$Fragment$fragmentPlaylistItem$podcastEpisode$podcast(
    this._instance,
    this._then,
  );

  final Fragment$fragmentPlaylistItem$podcastEpisode$podcast _instance;

  final TRes Function(Fragment$fragmentPlaylistItem$podcastEpisode$podcast)
  _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? id = _undefined,
    Object? title = _undefined,
    Object? author = _undefined,
    Object? images = _undefined,
    Object? $__typename = _undefined,
  }) => _then(
    Fragment$fragmentPlaylistItem$podcastEpisode$podcast(
      id: id == _undefined || id == null ? _instance.id : (id as String),
      title: title == _undefined || title == null
          ? _instance.title
          : (title as String),
      author: author == _undefined ? _instance.author : (author as String?),
      images: images == _undefined
          ? _instance.images
          : (images as List<Fragment$fragmentImages>?),
      $__typename: $__typename == _undefined || $__typename == null
          ? _instance.$__typename
          : ($__typename as String),
    ),
  );

  TRes images(
    Iterable<Fragment$fragmentImages>? Function(
      Iterable<CopyWith$Fragment$fragmentImages<Fragment$fragmentImages>>?,
    )
    _fn,
  ) => call(
    images: _fn(
      _instance.images?.map(
        (e) => CopyWith$Fragment$fragmentImages(e, (i) => i),
      ),
    )?.toList(),
  );
}

class _CopyWithStubImpl$Fragment$fragmentPlaylistItem$podcastEpisode$podcast<
  TRes
>
    implements
        CopyWith$Fragment$fragmentPlaylistItem$podcastEpisode$podcast<TRes> {
  _CopyWithStubImpl$Fragment$fragmentPlaylistItem$podcastEpisode$podcast(
    this._res,
  );

  TRes _res;

  call({
    String? id,
    String? title,
    String? author,
    List<Fragment$fragmentImages>? images,
    String? $__typename,
  }) => _res;

  images(_fn) => _res;
}

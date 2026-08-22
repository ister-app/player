import 'fragmentAlbum.graphql.dart';
import 'fragmentImages.graphql.dart';
import 'fragmentMetadata.graphql.dart';
import 'fragmentTrack.graphql.dart';

import 'package:gql/ast.dart';

class Variables$Query$recentlyAddedTracksByArtist {
  factory Variables$Query$recentlyAddedTracksByArtist({String? id}) =>
      Variables$Query$recentlyAddedTracksByArtist._({
        if (id != null) r'id': id,
      });

  Variables$Query$recentlyAddedTracksByArtist._(this._$data);

  factory Variables$Query$recentlyAddedTracksByArtist.fromJson(
    Map<String, dynamic> data,
  ) {
    final result$data = <String, dynamic>{};
    if (data.containsKey('id')) {
      final l$id = data['id'];
      result$data['id'] = (l$id as String?);
    }
    return Variables$Query$recentlyAddedTracksByArtist._(result$data);
  }

  Map<String, dynamic> _$data;

  String? get id => (_$data['id'] as String?);

  Map<String, dynamic> toJson() {
    final result$data = <String, dynamic>{};
    if (_$data.containsKey('id')) {
      final l$id = id;
      result$data['id'] = l$id;
    }
    return result$data;
  }

  CopyWith$Variables$Query$recentlyAddedTracksByArtist<
    Variables$Query$recentlyAddedTracksByArtist
  >
  get copyWith =>
      CopyWith$Variables$Query$recentlyAddedTracksByArtist(this, (i) => i);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Variables$Query$recentlyAddedTracksByArtist ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$id = id;
    final lOther$id = other.id;
    if (_$data.containsKey('id') != other._$data.containsKey('id')) {
      return false;
    }
    if (l$id != lOther$id) {
      return false;
    }
    return true;
  }

  @override
  int get hashCode {
    final l$id = id;
    return Object.hashAll([_$data.containsKey('id') ? l$id : const {}]);
  }
}

abstract class CopyWith$Variables$Query$recentlyAddedTracksByArtist<TRes> {
  factory CopyWith$Variables$Query$recentlyAddedTracksByArtist(
    Variables$Query$recentlyAddedTracksByArtist instance,
    TRes Function(Variables$Query$recentlyAddedTracksByArtist) then,
  ) = _CopyWithImpl$Variables$Query$recentlyAddedTracksByArtist;

  factory CopyWith$Variables$Query$recentlyAddedTracksByArtist.stub(TRes res) =
      _CopyWithStubImpl$Variables$Query$recentlyAddedTracksByArtist;

  TRes call({String? id});
}

class _CopyWithImpl$Variables$Query$recentlyAddedTracksByArtist<TRes>
    implements CopyWith$Variables$Query$recentlyAddedTracksByArtist<TRes> {
  _CopyWithImpl$Variables$Query$recentlyAddedTracksByArtist(
    this._instance,
    this._then,
  );

  final Variables$Query$recentlyAddedTracksByArtist _instance;

  final TRes Function(Variables$Query$recentlyAddedTracksByArtist) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({Object? id = _undefined}) => _then(
    Variables$Query$recentlyAddedTracksByArtist._({
      ..._instance._$data,
      if (id != _undefined) 'id': (id as String?),
    }),
  );
}

class _CopyWithStubImpl$Variables$Query$recentlyAddedTracksByArtist<TRes>
    implements CopyWith$Variables$Query$recentlyAddedTracksByArtist<TRes> {
  _CopyWithStubImpl$Variables$Query$recentlyAddedTracksByArtist(this._res);

  TRes _res;

  call({String? id}) => _res;
}

class Query$recentlyAddedTracksByArtist {
  Query$recentlyAddedTracksByArtist({this.tracks, this.$__typename = 'Query'});

  factory Query$recentlyAddedTracksByArtist.fromJson(
    Map<String, dynamic> json,
  ) {
    final l$tracks = json['tracks'];
    final l$$__typename = json['__typename'];
    return Query$recentlyAddedTracksByArtist(
      tracks: l$tracks == null
          ? null
          : Query$recentlyAddedTracksByArtist$tracks.fromJson(
              (l$tracks as Map<String, dynamic>),
            ),
      $__typename: (l$$__typename as String),
    );
  }

  final Query$recentlyAddedTracksByArtist$tracks? tracks;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$tracks = tracks;
    _resultData['tracks'] = l$tracks?.toJson();
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$tracks = tracks;
    final l$$__typename = $__typename;
    return Object.hashAll([l$tracks, l$$__typename]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Query$recentlyAddedTracksByArtist ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$tracks = tracks;
    final lOther$tracks = other.tracks;
    if (l$tracks != lOther$tracks) {
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

extension UtilityExtension$Query$recentlyAddedTracksByArtist
    on Query$recentlyAddedTracksByArtist {
  CopyWith$Query$recentlyAddedTracksByArtist<Query$recentlyAddedTracksByArtist>
  get copyWith => CopyWith$Query$recentlyAddedTracksByArtist(this, (i) => i);
}

abstract class CopyWith$Query$recentlyAddedTracksByArtist<TRes> {
  factory CopyWith$Query$recentlyAddedTracksByArtist(
    Query$recentlyAddedTracksByArtist instance,
    TRes Function(Query$recentlyAddedTracksByArtist) then,
  ) = _CopyWithImpl$Query$recentlyAddedTracksByArtist;

  factory CopyWith$Query$recentlyAddedTracksByArtist.stub(TRes res) =
      _CopyWithStubImpl$Query$recentlyAddedTracksByArtist;

  TRes call({
    Query$recentlyAddedTracksByArtist$tracks? tracks,
    String? $__typename,
  });
  CopyWith$Query$recentlyAddedTracksByArtist$tracks<TRes> get tracks;
}

class _CopyWithImpl$Query$recentlyAddedTracksByArtist<TRes>
    implements CopyWith$Query$recentlyAddedTracksByArtist<TRes> {
  _CopyWithImpl$Query$recentlyAddedTracksByArtist(this._instance, this._then);

  final Query$recentlyAddedTracksByArtist _instance;

  final TRes Function(Query$recentlyAddedTracksByArtist) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({Object? tracks = _undefined, Object? $__typename = _undefined}) =>
      _then(
        Query$recentlyAddedTracksByArtist(
          tracks: tracks == _undefined
              ? _instance.tracks
              : (tracks as Query$recentlyAddedTracksByArtist$tracks?),
          $__typename: $__typename == _undefined || $__typename == null
              ? _instance.$__typename
              : ($__typename as String),
        ),
      );

  CopyWith$Query$recentlyAddedTracksByArtist$tracks<TRes> get tracks {
    final local$tracks = _instance.tracks;
    return local$tracks == null
        ? CopyWith$Query$recentlyAddedTracksByArtist$tracks.stub(
            _then(_instance),
          )
        : CopyWith$Query$recentlyAddedTracksByArtist$tracks(
            local$tracks,
            (e) => call(tracks: e),
          );
  }
}

class _CopyWithStubImpl$Query$recentlyAddedTracksByArtist<TRes>
    implements CopyWith$Query$recentlyAddedTracksByArtist<TRes> {
  _CopyWithStubImpl$Query$recentlyAddedTracksByArtist(this._res);

  TRes _res;

  call({
    Query$recentlyAddedTracksByArtist$tracks? tracks,
    String? $__typename,
  }) => _res;

  CopyWith$Query$recentlyAddedTracksByArtist$tracks<TRes> get tracks =>
      CopyWith$Query$recentlyAddedTracksByArtist$tracks.stub(_res);
}

const documentNodeQueryrecentlyAddedTracksByArtist = DocumentNode(
  definitions: [
    OperationDefinitionNode(
      type: OperationType.query,
      name: NameNode(value: 'recentlyAddedTracksByArtist'),
      variableDefinitions: [
        VariableDefinitionNode(
          variable: VariableNode(name: NameNode(value: 'id')),
          type: NamedTypeNode(name: NameNode(value: 'ID'), isNonNull: false),
          defaultValue: DefaultValueNode(value: null),
          directives: [],
        ),
      ],
      directives: [],
      selectionSet: SelectionSetNode(
        selections: [
          FieldNode(
            name: NameNode(value: 'tracks'),
            alias: null,
            arguments: [
              ArgumentNode(
                name: NameNode(value: 'artistId'),
                value: VariableNode(name: NameNode(value: 'id')),
              ),
              ArgumentNode(
                name: NameNode(value: 'sorting'),
                value: EnumValueNode(name: NameNode(value: 'DATE_CREATED')),
              ),
              ArgumentNode(
                name: NameNode(value: 'sortingOrder'),
                value: EnumValueNode(name: NameNode(value: 'DESCENDING')),
              ),
              ArgumentNode(
                name: NameNode(value: 'page'),
                value: IntValueNode(value: '0'),
              ),
              ArgumentNode(
                name: NameNode(value: 'size'),
                value: IntValueNode(value: '10'),
              ),
            ],
            directives: [],
            selectionSet: SelectionSetNode(
              selections: [
                FieldNode(
                  name: NameNode(value: 'content'),
                  alias: null,
                  arguments: [],
                  directives: [],
                  selectionSet: SelectionSetNode(
                    selections: [
                      FragmentSpreadNode(
                        name: NameNode(value: 'fragmentTrack'),
                        directives: [],
                      ),
                      FieldNode(
                        name: NameNode(value: 'album'),
                        alias: null,
                        arguments: [],
                        directives: [],
                        selectionSet: SelectionSetNode(
                          selections: [
                            FragmentSpreadNode(
                              name: NameNode(value: 'fragmentAlbum'),
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
                  name: NameNode(value: 'totalPages'),
                  alias: null,
                  arguments: [],
                  directives: [],
                  selectionSet: null,
                ),
                FieldNode(
                  name: NameNode(value: 'totalElements'),
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
                  name: NameNode(value: 'size'),
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
            name: NameNode(value: '__typename'),
            alias: null,
            arguments: [],
            directives: [],
            selectionSet: null,
          ),
        ],
      ),
    ),
    fragmentDefinitionfragmentTrack,
    fragmentDefinitionfragmentMetadata,
    fragmentDefinitionfragmentAlbum,
    fragmentDefinitionfragmentImages,
  ],
);

class Query$recentlyAddedTracksByArtist$tracks {
  Query$recentlyAddedTracksByArtist$tracks({
    required this.content,
    required this.totalPages,
    required this.totalElements,
    required this.number,
    required this.size,
    this.$__typename = 'TrackPage',
  });

  factory Query$recentlyAddedTracksByArtist$tracks.fromJson(
    Map<String, dynamic> json,
  ) {
    final l$content = json['content'];
    final l$totalPages = json['totalPages'];
    final l$totalElements = json['totalElements'];
    final l$number = json['number'];
    final l$size = json['size'];
    final l$$__typename = json['__typename'];
    return Query$recentlyAddedTracksByArtist$tracks(
      content: (l$content as List<dynamic>)
          .map(
            (e) => Query$recentlyAddedTracksByArtist$tracks$content.fromJson(
              (e as Map<String, dynamic>),
            ),
          )
          .toList(),
      totalPages: (l$totalPages as int),
      totalElements: (l$totalElements as int),
      number: (l$number as int),
      size: (l$size as int),
      $__typename: (l$$__typename as String),
    );
  }

  final List<Query$recentlyAddedTracksByArtist$tracks$content> content;

  final int totalPages;

  final int totalElements;

  final int number;

  final int size;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$content = content;
    _resultData['content'] = l$content.map((e) => e.toJson()).toList();
    final l$totalPages = totalPages;
    _resultData['totalPages'] = l$totalPages;
    final l$totalElements = totalElements;
    _resultData['totalElements'] = l$totalElements;
    final l$number = number;
    _resultData['number'] = l$number;
    final l$size = size;
    _resultData['size'] = l$size;
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$content = content;
    final l$totalPages = totalPages;
    final l$totalElements = totalElements;
    final l$number = number;
    final l$size = size;
    final l$$__typename = $__typename;
    return Object.hashAll([
      Object.hashAll(l$content.map((v) => v)),
      l$totalPages,
      l$totalElements,
      l$number,
      l$size,
      l$$__typename,
    ]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Query$recentlyAddedTracksByArtist$tracks ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$content = content;
    final lOther$content = other.content;
    if (l$content.length != lOther$content.length) {
      return false;
    }
    for (int i = 0; i < l$content.length; i++) {
      final l$content$entry = l$content[i];
      final lOther$content$entry = lOther$content[i];
      if (l$content$entry != lOther$content$entry) {
        return false;
      }
    }
    final l$totalPages = totalPages;
    final lOther$totalPages = other.totalPages;
    if (l$totalPages != lOther$totalPages) {
      return false;
    }
    final l$totalElements = totalElements;
    final lOther$totalElements = other.totalElements;
    if (l$totalElements != lOther$totalElements) {
      return false;
    }
    final l$number = number;
    final lOther$number = other.number;
    if (l$number != lOther$number) {
      return false;
    }
    final l$size = size;
    final lOther$size = other.size;
    if (l$size != lOther$size) {
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

extension UtilityExtension$Query$recentlyAddedTracksByArtist$tracks
    on Query$recentlyAddedTracksByArtist$tracks {
  CopyWith$Query$recentlyAddedTracksByArtist$tracks<
    Query$recentlyAddedTracksByArtist$tracks
  >
  get copyWith =>
      CopyWith$Query$recentlyAddedTracksByArtist$tracks(this, (i) => i);
}

abstract class CopyWith$Query$recentlyAddedTracksByArtist$tracks<TRes> {
  factory CopyWith$Query$recentlyAddedTracksByArtist$tracks(
    Query$recentlyAddedTracksByArtist$tracks instance,
    TRes Function(Query$recentlyAddedTracksByArtist$tracks) then,
  ) = _CopyWithImpl$Query$recentlyAddedTracksByArtist$tracks;

  factory CopyWith$Query$recentlyAddedTracksByArtist$tracks.stub(TRes res) =
      _CopyWithStubImpl$Query$recentlyAddedTracksByArtist$tracks;

  TRes call({
    List<Query$recentlyAddedTracksByArtist$tracks$content>? content,
    int? totalPages,
    int? totalElements,
    int? number,
    int? size,
    String? $__typename,
  });
  TRes content(
    Iterable<Query$recentlyAddedTracksByArtist$tracks$content> Function(
      Iterable<
        CopyWith$Query$recentlyAddedTracksByArtist$tracks$content<
          Query$recentlyAddedTracksByArtist$tracks$content
        >
      >,
    )
    _fn,
  );
}

class _CopyWithImpl$Query$recentlyAddedTracksByArtist$tracks<TRes>
    implements CopyWith$Query$recentlyAddedTracksByArtist$tracks<TRes> {
  _CopyWithImpl$Query$recentlyAddedTracksByArtist$tracks(
    this._instance,
    this._then,
  );

  final Query$recentlyAddedTracksByArtist$tracks _instance;

  final TRes Function(Query$recentlyAddedTracksByArtist$tracks) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? content = _undefined,
    Object? totalPages = _undefined,
    Object? totalElements = _undefined,
    Object? number = _undefined,
    Object? size = _undefined,
    Object? $__typename = _undefined,
  }) => _then(
    Query$recentlyAddedTracksByArtist$tracks(
      content: content == _undefined || content == null
          ? _instance.content
          : (content as List<Query$recentlyAddedTracksByArtist$tracks$content>),
      totalPages: totalPages == _undefined || totalPages == null
          ? _instance.totalPages
          : (totalPages as int),
      totalElements: totalElements == _undefined || totalElements == null
          ? _instance.totalElements
          : (totalElements as int),
      number: number == _undefined || number == null
          ? _instance.number
          : (number as int),
      size: size == _undefined || size == null ? _instance.size : (size as int),
      $__typename: $__typename == _undefined || $__typename == null
          ? _instance.$__typename
          : ($__typename as String),
    ),
  );

  TRes content(
    Iterable<Query$recentlyAddedTracksByArtist$tracks$content> Function(
      Iterable<
        CopyWith$Query$recentlyAddedTracksByArtist$tracks$content<
          Query$recentlyAddedTracksByArtist$tracks$content
        >
      >,
    )
    _fn,
  ) => call(
    content: _fn(
      _instance.content.map(
        (e) => CopyWith$Query$recentlyAddedTracksByArtist$tracks$content(
          e,
          (i) => i,
        ),
      ),
    ).toList(),
  );
}

class _CopyWithStubImpl$Query$recentlyAddedTracksByArtist$tracks<TRes>
    implements CopyWith$Query$recentlyAddedTracksByArtist$tracks<TRes> {
  _CopyWithStubImpl$Query$recentlyAddedTracksByArtist$tracks(this._res);

  TRes _res;

  call({
    List<Query$recentlyAddedTracksByArtist$tracks$content>? content,
    int? totalPages,
    int? totalElements,
    int? number,
    int? size,
    String? $__typename,
  }) => _res;

  content(_fn) => _res;
}

class Query$recentlyAddedTracksByArtist$tracks$content
    implements Fragment$fragmentTrack {
  Query$recentlyAddedTracksByArtist$tracks$content({
    required this.id,
    required this.number,
    required this.discNumber,
    required this.artist,
    this.metadata,
    this.mediaFile,
    this.rating,
    this.$__typename = 'Track',
    required this.album,
  });

  factory Query$recentlyAddedTracksByArtist$tracks$content.fromJson(
    Map<String, dynamic> json,
  ) {
    final l$id = json['id'];
    final l$number = json['number'];
    final l$discNumber = json['discNumber'];
    final l$artist = json['artist'];
    final l$metadata = json['metadata'];
    final l$mediaFile = json['mediaFile'];
    final l$rating = json['rating'];
    final l$$__typename = json['__typename'];
    final l$album = json['album'];
    return Query$recentlyAddedTracksByArtist$tracks$content(
      id: (l$id as String),
      number: (l$number as int),
      discNumber: (l$discNumber as int),
      artist: Query$recentlyAddedTracksByArtist$tracks$content$artist.fromJson(
        (l$artist as Map<String, dynamic>),
      ),
      metadata: (l$metadata as List<dynamic>?)
          ?.map(
            (e) =>
                Fragment$fragmentMetadata.fromJson((e as Map<String, dynamic>)),
          )
          .toList(),
      mediaFile: (l$mediaFile as List<dynamic>?)
          ?.map(
            (e) =>
                Query$recentlyAddedTracksByArtist$tracks$content$mediaFile.fromJson(
                  (e as Map<String, dynamic>),
                ),
          )
          .toList(),
      rating: (l$rating as int?),
      $__typename: (l$$__typename as String),
      album: Fragment$fragmentAlbum.fromJson((l$album as Map<String, dynamic>)),
    );
  }

  final String id;

  final int number;

  final int discNumber;

  final Query$recentlyAddedTracksByArtist$tracks$content$artist artist;

  final List<Fragment$fragmentMetadata>? metadata;

  final List<Query$recentlyAddedTracksByArtist$tracks$content$mediaFile>?
  mediaFile;

  final int? rating;

  final String $__typename;

  final Fragment$fragmentAlbum album;

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
    final l$metadata = metadata;
    _resultData['metadata'] = l$metadata?.map((e) => e.toJson()).toList();
    final l$mediaFile = mediaFile;
    _resultData['mediaFile'] = l$mediaFile?.map((e) => e.toJson()).toList();
    final l$rating = rating;
    _resultData['rating'] = l$rating;
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    final l$album = album;
    _resultData['album'] = l$album.toJson();
    return _resultData;
  }

  @override
  int get hashCode {
    final l$id = id;
    final l$number = number;
    final l$discNumber = discNumber;
    final l$artist = artist;
    final l$metadata = metadata;
    final l$mediaFile = mediaFile;
    final l$rating = rating;
    final l$$__typename = $__typename;
    final l$album = album;
    return Object.hashAll([
      l$id,
      l$number,
      l$discNumber,
      l$artist,
      l$metadata == null ? null : Object.hashAll(l$metadata.map((v) => v)),
      l$mediaFile == null ? null : Object.hashAll(l$mediaFile.map((v) => v)),
      l$rating,
      l$$__typename,
      l$album,
    ]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Query$recentlyAddedTracksByArtist$tracks$content ||
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
    final l$album = album;
    final lOther$album = other.album;
    if (l$album != lOther$album) {
      return false;
    }
    return true;
  }
}

extension UtilityExtension$Query$recentlyAddedTracksByArtist$tracks$content
    on Query$recentlyAddedTracksByArtist$tracks$content {
  CopyWith$Query$recentlyAddedTracksByArtist$tracks$content<
    Query$recentlyAddedTracksByArtist$tracks$content
  >
  get copyWith =>
      CopyWith$Query$recentlyAddedTracksByArtist$tracks$content(this, (i) => i);
}

abstract class CopyWith$Query$recentlyAddedTracksByArtist$tracks$content<TRes> {
  factory CopyWith$Query$recentlyAddedTracksByArtist$tracks$content(
    Query$recentlyAddedTracksByArtist$tracks$content instance,
    TRes Function(Query$recentlyAddedTracksByArtist$tracks$content) then,
  ) = _CopyWithImpl$Query$recentlyAddedTracksByArtist$tracks$content;

  factory CopyWith$Query$recentlyAddedTracksByArtist$tracks$content.stub(
    TRes res,
  ) = _CopyWithStubImpl$Query$recentlyAddedTracksByArtist$tracks$content;

  TRes call({
    String? id,
    int? number,
    int? discNumber,
    Query$recentlyAddedTracksByArtist$tracks$content$artist? artist,
    List<Fragment$fragmentMetadata>? metadata,
    List<Query$recentlyAddedTracksByArtist$tracks$content$mediaFile>? mediaFile,
    int? rating,
    String? $__typename,
    Fragment$fragmentAlbum? album,
  });
  CopyWith$Query$recentlyAddedTracksByArtist$tracks$content$artist<TRes>
  get artist;
  TRes metadata(
    Iterable<Fragment$fragmentMetadata>? Function(
      Iterable<CopyWith$Fragment$fragmentMetadata<Fragment$fragmentMetadata>>?,
    )
    _fn,
  );
  TRes mediaFile(
    Iterable<Query$recentlyAddedTracksByArtist$tracks$content$mediaFile>?
    Function(
      Iterable<
        CopyWith$Query$recentlyAddedTracksByArtist$tracks$content$mediaFile<
          Query$recentlyAddedTracksByArtist$tracks$content$mediaFile
        >
      >?,
    )
    _fn,
  );
  CopyWith$Fragment$fragmentAlbum<TRes> get album;
}

class _CopyWithImpl$Query$recentlyAddedTracksByArtist$tracks$content<TRes>
    implements CopyWith$Query$recentlyAddedTracksByArtist$tracks$content<TRes> {
  _CopyWithImpl$Query$recentlyAddedTracksByArtist$tracks$content(
    this._instance,
    this._then,
  );

  final Query$recentlyAddedTracksByArtist$tracks$content _instance;

  final TRes Function(Query$recentlyAddedTracksByArtist$tracks$content) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? id = _undefined,
    Object? number = _undefined,
    Object? discNumber = _undefined,
    Object? artist = _undefined,
    Object? metadata = _undefined,
    Object? mediaFile = _undefined,
    Object? rating = _undefined,
    Object? $__typename = _undefined,
    Object? album = _undefined,
  }) => _then(
    Query$recentlyAddedTracksByArtist$tracks$content(
      id: id == _undefined || id == null ? _instance.id : (id as String),
      number: number == _undefined || number == null
          ? _instance.number
          : (number as int),
      discNumber: discNumber == _undefined || discNumber == null
          ? _instance.discNumber
          : (discNumber as int),
      artist: artist == _undefined || artist == null
          ? _instance.artist
          : (artist as Query$recentlyAddedTracksByArtist$tracks$content$artist),
      metadata: metadata == _undefined
          ? _instance.metadata
          : (metadata as List<Fragment$fragmentMetadata>?),
      mediaFile: mediaFile == _undefined
          ? _instance.mediaFile
          : (mediaFile
                as List<
                  Query$recentlyAddedTracksByArtist$tracks$content$mediaFile
                >?),
      rating: rating == _undefined ? _instance.rating : (rating as int?),
      $__typename: $__typename == _undefined || $__typename == null
          ? _instance.$__typename
          : ($__typename as String),
      album: album == _undefined || album == null
          ? _instance.album
          : (album as Fragment$fragmentAlbum),
    ),
  );

  CopyWith$Query$recentlyAddedTracksByArtist$tracks$content$artist<TRes>
  get artist {
    final local$artist = _instance.artist;
    return CopyWith$Query$recentlyAddedTracksByArtist$tracks$content$artist(
      local$artist,
      (e) => call(artist: e),
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
    Iterable<Query$recentlyAddedTracksByArtist$tracks$content$mediaFile>?
    Function(
      Iterable<
        CopyWith$Query$recentlyAddedTracksByArtist$tracks$content$mediaFile<
          Query$recentlyAddedTracksByArtist$tracks$content$mediaFile
        >
      >?,
    )
    _fn,
  ) => call(
    mediaFile: _fn(
      _instance.mediaFile?.map(
        (e) =>
            CopyWith$Query$recentlyAddedTracksByArtist$tracks$content$mediaFile(
              e,
              (i) => i,
            ),
      ),
    )?.toList(),
  );

  CopyWith$Fragment$fragmentAlbum<TRes> get album {
    final local$album = _instance.album;
    return CopyWith$Fragment$fragmentAlbum(local$album, (e) => call(album: e));
  }
}

class _CopyWithStubImpl$Query$recentlyAddedTracksByArtist$tracks$content<TRes>
    implements CopyWith$Query$recentlyAddedTracksByArtist$tracks$content<TRes> {
  _CopyWithStubImpl$Query$recentlyAddedTracksByArtist$tracks$content(this._res);

  TRes _res;

  call({
    String? id,
    int? number,
    int? discNumber,
    Query$recentlyAddedTracksByArtist$tracks$content$artist? artist,
    List<Fragment$fragmentMetadata>? metadata,
    List<Query$recentlyAddedTracksByArtist$tracks$content$mediaFile>? mediaFile,
    int? rating,
    String? $__typename,
    Fragment$fragmentAlbum? album,
  }) => _res;

  CopyWith$Query$recentlyAddedTracksByArtist$tracks$content$artist<TRes>
  get artist =>
      CopyWith$Query$recentlyAddedTracksByArtist$tracks$content$artist.stub(
        _res,
      );

  metadata(_fn) => _res;

  mediaFile(_fn) => _res;

  CopyWith$Fragment$fragmentAlbum<TRes> get album =>
      CopyWith$Fragment$fragmentAlbum.stub(_res);
}

class Query$recentlyAddedTracksByArtist$tracks$content$artist
    implements Fragment$fragmentTrack$artist {
  Query$recentlyAddedTracksByArtist$tracks$content$artist({
    required this.id,
    required this.name,
    this.$__typename = 'Person',
  });

  factory Query$recentlyAddedTracksByArtist$tracks$content$artist.fromJson(
    Map<String, dynamic> json,
  ) {
    final l$id = json['id'];
    final l$name = json['name'];
    final l$$__typename = json['__typename'];
    return Query$recentlyAddedTracksByArtist$tracks$content$artist(
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
    if (other is! Query$recentlyAddedTracksByArtist$tracks$content$artist ||
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

extension UtilityExtension$Query$recentlyAddedTracksByArtist$tracks$content$artist
    on Query$recentlyAddedTracksByArtist$tracks$content$artist {
  CopyWith$Query$recentlyAddedTracksByArtist$tracks$content$artist<
    Query$recentlyAddedTracksByArtist$tracks$content$artist
  >
  get copyWith =>
      CopyWith$Query$recentlyAddedTracksByArtist$tracks$content$artist(
        this,
        (i) => i,
      );
}

abstract class CopyWith$Query$recentlyAddedTracksByArtist$tracks$content$artist<
  TRes
> {
  factory CopyWith$Query$recentlyAddedTracksByArtist$tracks$content$artist(
    Query$recentlyAddedTracksByArtist$tracks$content$artist instance,
    TRes Function(Query$recentlyAddedTracksByArtist$tracks$content$artist) then,
  ) = _CopyWithImpl$Query$recentlyAddedTracksByArtist$tracks$content$artist;

  factory CopyWith$Query$recentlyAddedTracksByArtist$tracks$content$artist.stub(
    TRes res,
  ) = _CopyWithStubImpl$Query$recentlyAddedTracksByArtist$tracks$content$artist;

  TRes call({String? id, String? name, String? $__typename});
}

class _CopyWithImpl$Query$recentlyAddedTracksByArtist$tracks$content$artist<
  TRes
>
    implements
        CopyWith$Query$recentlyAddedTracksByArtist$tracks$content$artist<TRes> {
  _CopyWithImpl$Query$recentlyAddedTracksByArtist$tracks$content$artist(
    this._instance,
    this._then,
  );

  final Query$recentlyAddedTracksByArtist$tracks$content$artist _instance;

  final TRes Function(Query$recentlyAddedTracksByArtist$tracks$content$artist)
  _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? id = _undefined,
    Object? name = _undefined,
    Object? $__typename = _undefined,
  }) => _then(
    Query$recentlyAddedTracksByArtist$tracks$content$artist(
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

class _CopyWithStubImpl$Query$recentlyAddedTracksByArtist$tracks$content$artist<
  TRes
>
    implements
        CopyWith$Query$recentlyAddedTracksByArtist$tracks$content$artist<TRes> {
  _CopyWithStubImpl$Query$recentlyAddedTracksByArtist$tracks$content$artist(
    this._res,
  );

  TRes _res;

  call({String? id, String? name, String? $__typename}) => _res;
}

class Query$recentlyAddedTracksByArtist$tracks$content$mediaFile
    implements Fragment$fragmentTrack$mediaFile {
  Query$recentlyAddedTracksByArtist$tracks$content$mediaFile({
    this.durationInMilliseconds,
    this.$__typename = 'MediaFile',
  });

  factory Query$recentlyAddedTracksByArtist$tracks$content$mediaFile.fromJson(
    Map<String, dynamic> json,
  ) {
    final l$durationInMilliseconds = json['durationInMilliseconds'];
    final l$$__typename = json['__typename'];
    return Query$recentlyAddedTracksByArtist$tracks$content$mediaFile(
      durationInMilliseconds: (l$durationInMilliseconds as int?),
      $__typename: (l$$__typename as String),
    );
  }

  final int? durationInMilliseconds;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$durationInMilliseconds = durationInMilliseconds;
    _resultData['durationInMilliseconds'] = l$durationInMilliseconds;
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$durationInMilliseconds = durationInMilliseconds;
    final l$$__typename = $__typename;
    return Object.hashAll([l$durationInMilliseconds, l$$__typename]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Query$recentlyAddedTracksByArtist$tracks$content$mediaFile ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$durationInMilliseconds = durationInMilliseconds;
    final lOther$durationInMilliseconds = other.durationInMilliseconds;
    if (l$durationInMilliseconds != lOther$durationInMilliseconds) {
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

extension UtilityExtension$Query$recentlyAddedTracksByArtist$tracks$content$mediaFile
    on Query$recentlyAddedTracksByArtist$tracks$content$mediaFile {
  CopyWith$Query$recentlyAddedTracksByArtist$tracks$content$mediaFile<
    Query$recentlyAddedTracksByArtist$tracks$content$mediaFile
  >
  get copyWith =>
      CopyWith$Query$recentlyAddedTracksByArtist$tracks$content$mediaFile(
        this,
        (i) => i,
      );
}

abstract class CopyWith$Query$recentlyAddedTracksByArtist$tracks$content$mediaFile<
  TRes
> {
  factory CopyWith$Query$recentlyAddedTracksByArtist$tracks$content$mediaFile(
    Query$recentlyAddedTracksByArtist$tracks$content$mediaFile instance,
    TRes Function(Query$recentlyAddedTracksByArtist$tracks$content$mediaFile)
    then,
  ) = _CopyWithImpl$Query$recentlyAddedTracksByArtist$tracks$content$mediaFile;

  factory CopyWith$Query$recentlyAddedTracksByArtist$tracks$content$mediaFile.stub(
    TRes res,
  ) = _CopyWithStubImpl$Query$recentlyAddedTracksByArtist$tracks$content$mediaFile;

  TRes call({int? durationInMilliseconds, String? $__typename});
}

class _CopyWithImpl$Query$recentlyAddedTracksByArtist$tracks$content$mediaFile<
  TRes
>
    implements
        CopyWith$Query$recentlyAddedTracksByArtist$tracks$content$mediaFile<
          TRes
        > {
  _CopyWithImpl$Query$recentlyAddedTracksByArtist$tracks$content$mediaFile(
    this._instance,
    this._then,
  );

  final Query$recentlyAddedTracksByArtist$tracks$content$mediaFile _instance;

  final TRes Function(
    Query$recentlyAddedTracksByArtist$tracks$content$mediaFile,
  )
  _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? durationInMilliseconds = _undefined,
    Object? $__typename = _undefined,
  }) => _then(
    Query$recentlyAddedTracksByArtist$tracks$content$mediaFile(
      durationInMilliseconds: durationInMilliseconds == _undefined
          ? _instance.durationInMilliseconds
          : (durationInMilliseconds as int?),
      $__typename: $__typename == _undefined || $__typename == null
          ? _instance.$__typename
          : ($__typename as String),
    ),
  );
}

class _CopyWithStubImpl$Query$recentlyAddedTracksByArtist$tracks$content$mediaFile<
  TRes
>
    implements
        CopyWith$Query$recentlyAddedTracksByArtist$tracks$content$mediaFile<
          TRes
        > {
  _CopyWithStubImpl$Query$recentlyAddedTracksByArtist$tracks$content$mediaFile(
    this._res,
  );

  TRes _res;

  call({int? durationInMilliseconds, String? $__typename}) => _res;
}

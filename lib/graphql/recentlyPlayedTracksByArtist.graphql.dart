import 'fragmentAlbum.graphql.dart';
import 'fragmentImages.graphql.dart';
import 'fragmentMetadata.graphql.dart';
import 'fragmentTrack.graphql.dart';

import 'package:gql/ast.dart';

class Variables$Query$recentlyPlayedTracksByArtist {
  factory Variables$Query$recentlyPlayedTracksByArtist({String? id}) =>
      Variables$Query$recentlyPlayedTracksByArtist._({
        if (id != null) r'id': id,
      });

  Variables$Query$recentlyPlayedTracksByArtist._(this._$data);

  factory Variables$Query$recentlyPlayedTracksByArtist.fromJson(
    Map<String, dynamic> data,
  ) {
    final result$data = <String, dynamic>{};
    if (data.containsKey('id')) {
      final l$id = data['id'];
      result$data['id'] = (l$id as String?);
    }
    return Variables$Query$recentlyPlayedTracksByArtist._(result$data);
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

  CopyWith$Variables$Query$recentlyPlayedTracksByArtist<
    Variables$Query$recentlyPlayedTracksByArtist
  >
  get copyWith =>
      CopyWith$Variables$Query$recentlyPlayedTracksByArtist(this, (i) => i);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Variables$Query$recentlyPlayedTracksByArtist ||
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

abstract class CopyWith$Variables$Query$recentlyPlayedTracksByArtist<TRes> {
  factory CopyWith$Variables$Query$recentlyPlayedTracksByArtist(
    Variables$Query$recentlyPlayedTracksByArtist instance,
    TRes Function(Variables$Query$recentlyPlayedTracksByArtist) then,
  ) = _CopyWithImpl$Variables$Query$recentlyPlayedTracksByArtist;

  factory CopyWith$Variables$Query$recentlyPlayedTracksByArtist.stub(TRes res) =
      _CopyWithStubImpl$Variables$Query$recentlyPlayedTracksByArtist;

  TRes call({String? id});
}

class _CopyWithImpl$Variables$Query$recentlyPlayedTracksByArtist<TRes>
    implements CopyWith$Variables$Query$recentlyPlayedTracksByArtist<TRes> {
  _CopyWithImpl$Variables$Query$recentlyPlayedTracksByArtist(
    this._instance,
    this._then,
  );

  final Variables$Query$recentlyPlayedTracksByArtist _instance;

  final TRes Function(Variables$Query$recentlyPlayedTracksByArtist) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({Object? id = _undefined}) => _then(
    Variables$Query$recentlyPlayedTracksByArtist._({
      ..._instance._$data,
      if (id != _undefined) 'id': (id as String?),
    }),
  );
}

class _CopyWithStubImpl$Variables$Query$recentlyPlayedTracksByArtist<TRes>
    implements CopyWith$Variables$Query$recentlyPlayedTracksByArtist<TRes> {
  _CopyWithStubImpl$Variables$Query$recentlyPlayedTracksByArtist(this._res);

  TRes _res;

  call({String? id}) => _res;
}

class Query$recentlyPlayedTracksByArtist {
  Query$recentlyPlayedTracksByArtist({
    this.personById,
    this.$__typename = 'Query',
  });

  factory Query$recentlyPlayedTracksByArtist.fromJson(
    Map<String, dynamic> json,
  ) {
    final l$personById = json['personById'];
    final l$$__typename = json['__typename'];
    return Query$recentlyPlayedTracksByArtist(
      personById: l$personById == null
          ? null
          : Query$recentlyPlayedTracksByArtist$personById.fromJson(
              (l$personById as Map<String, dynamic>),
            ),
      $__typename: (l$$__typename as String),
    );
  }

  final Query$recentlyPlayedTracksByArtist$personById? personById;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$personById = personById;
    _resultData['personById'] = l$personById?.toJson();
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$personById = personById;
    final l$$__typename = $__typename;
    return Object.hashAll([l$personById, l$$__typename]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Query$recentlyPlayedTracksByArtist ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$personById = personById;
    final lOther$personById = other.personById;
    if (l$personById != lOther$personById) {
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

extension UtilityExtension$Query$recentlyPlayedTracksByArtist
    on Query$recentlyPlayedTracksByArtist {
  CopyWith$Query$recentlyPlayedTracksByArtist<
    Query$recentlyPlayedTracksByArtist
  >
  get copyWith => CopyWith$Query$recentlyPlayedTracksByArtist(this, (i) => i);
}

abstract class CopyWith$Query$recentlyPlayedTracksByArtist<TRes> {
  factory CopyWith$Query$recentlyPlayedTracksByArtist(
    Query$recentlyPlayedTracksByArtist instance,
    TRes Function(Query$recentlyPlayedTracksByArtist) then,
  ) = _CopyWithImpl$Query$recentlyPlayedTracksByArtist;

  factory CopyWith$Query$recentlyPlayedTracksByArtist.stub(TRes res) =
      _CopyWithStubImpl$Query$recentlyPlayedTracksByArtist;

  TRes call({
    Query$recentlyPlayedTracksByArtist$personById? personById,
    String? $__typename,
  });
  CopyWith$Query$recentlyPlayedTracksByArtist$personById<TRes> get personById;
}

class _CopyWithImpl$Query$recentlyPlayedTracksByArtist<TRes>
    implements CopyWith$Query$recentlyPlayedTracksByArtist<TRes> {
  _CopyWithImpl$Query$recentlyPlayedTracksByArtist(this._instance, this._then);

  final Query$recentlyPlayedTracksByArtist _instance;

  final TRes Function(Query$recentlyPlayedTracksByArtist) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? personById = _undefined,
    Object? $__typename = _undefined,
  }) => _then(
    Query$recentlyPlayedTracksByArtist(
      personById: personById == _undefined
          ? _instance.personById
          : (personById as Query$recentlyPlayedTracksByArtist$personById?),
      $__typename: $__typename == _undefined || $__typename == null
          ? _instance.$__typename
          : ($__typename as String),
    ),
  );

  CopyWith$Query$recentlyPlayedTracksByArtist$personById<TRes> get personById {
    final local$personById = _instance.personById;
    return local$personById == null
        ? CopyWith$Query$recentlyPlayedTracksByArtist$personById.stub(
            _then(_instance),
          )
        : CopyWith$Query$recentlyPlayedTracksByArtist$personById(
            local$personById,
            (e) => call(personById: e),
          );
  }
}

class _CopyWithStubImpl$Query$recentlyPlayedTracksByArtist<TRes>
    implements CopyWith$Query$recentlyPlayedTracksByArtist<TRes> {
  _CopyWithStubImpl$Query$recentlyPlayedTracksByArtist(this._res);

  TRes _res;

  call({
    Query$recentlyPlayedTracksByArtist$personById? personById,
    String? $__typename,
  }) => _res;

  CopyWith$Query$recentlyPlayedTracksByArtist$personById<TRes> get personById =>
      CopyWith$Query$recentlyPlayedTracksByArtist$personById.stub(_res);
}

const documentNodeQueryrecentlyPlayedTracksByArtist = DocumentNode(
  definitions: [
    OperationDefinitionNode(
      type: OperationType.query,
      name: NameNode(value: 'recentlyPlayedTracksByArtist'),
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
            name: NameNode(value: 'personById'),
            alias: null,
            arguments: [
              ArgumentNode(
                name: NameNode(value: 'id'),
                value: VariableNode(name: NameNode(value: 'id')),
              ),
            ],
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
                  name: NameNode(value: 'recentlyPlayedTracks'),
                  alias: null,
                  arguments: [
                    ArgumentNode(
                      name: NameNode(value: 'limit'),
                      value: IntValueNode(value: '10'),
                    ),
                  ],
                  directives: [],
                  selectionSet: SelectionSetNode(
                    selections: [
                      FragmentSpreadNode(
                        name: NameNode(value: 'fragmentTrack'),
                        directives: [],
                      ),
                      FieldNode(
                        name: NameNode(value: 'lastPlayedAt'),
                        alias: null,
                        arguments: [],
                        directives: [],
                        selectionSet: null,
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

class Query$recentlyPlayedTracksByArtist$personById {
  Query$recentlyPlayedTracksByArtist$personById({
    required this.id,
    required this.recentlyPlayedTracks,
    this.$__typename = 'Person',
  });

  factory Query$recentlyPlayedTracksByArtist$personById.fromJson(
    Map<String, dynamic> json,
  ) {
    final l$id = json['id'];
    final l$recentlyPlayedTracks = json['recentlyPlayedTracks'];
    final l$$__typename = json['__typename'];
    return Query$recentlyPlayedTracksByArtist$personById(
      id: (l$id as String),
      recentlyPlayedTracks: (l$recentlyPlayedTracks as List<dynamic>)
          .map(
            (e) =>
                Query$recentlyPlayedTracksByArtist$personById$recentlyPlayedTracks.fromJson(
                  (e as Map<String, dynamic>),
                ),
          )
          .toList(),
      $__typename: (l$$__typename as String),
    );
  }

  final String id;

  final List<Query$recentlyPlayedTracksByArtist$personById$recentlyPlayedTracks>
  recentlyPlayedTracks;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$id = id;
    _resultData['id'] = l$id;
    final l$recentlyPlayedTracks = recentlyPlayedTracks;
    _resultData['recentlyPlayedTracks'] = l$recentlyPlayedTracks
        .map((e) => e.toJson())
        .toList();
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$id = id;
    final l$recentlyPlayedTracks = recentlyPlayedTracks;
    final l$$__typename = $__typename;
    return Object.hashAll([
      l$id,
      Object.hashAll(l$recentlyPlayedTracks.map((v) => v)),
      l$$__typename,
    ]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Query$recentlyPlayedTracksByArtist$personById ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$id = id;
    final lOther$id = other.id;
    if (l$id != lOther$id) {
      return false;
    }
    final l$recentlyPlayedTracks = recentlyPlayedTracks;
    final lOther$recentlyPlayedTracks = other.recentlyPlayedTracks;
    if (l$recentlyPlayedTracks.length != lOther$recentlyPlayedTracks.length) {
      return false;
    }
    for (int i = 0; i < l$recentlyPlayedTracks.length; i++) {
      final l$recentlyPlayedTracks$entry = l$recentlyPlayedTracks[i];
      final lOther$recentlyPlayedTracks$entry = lOther$recentlyPlayedTracks[i];
      if (l$recentlyPlayedTracks$entry != lOther$recentlyPlayedTracks$entry) {
        return false;
      }
    }
    final l$$__typename = $__typename;
    final lOther$$__typename = other.$__typename;
    if (l$$__typename != lOther$$__typename) {
      return false;
    }
    return true;
  }
}

extension UtilityExtension$Query$recentlyPlayedTracksByArtist$personById
    on Query$recentlyPlayedTracksByArtist$personById {
  CopyWith$Query$recentlyPlayedTracksByArtist$personById<
    Query$recentlyPlayedTracksByArtist$personById
  >
  get copyWith =>
      CopyWith$Query$recentlyPlayedTracksByArtist$personById(this, (i) => i);
}

abstract class CopyWith$Query$recentlyPlayedTracksByArtist$personById<TRes> {
  factory CopyWith$Query$recentlyPlayedTracksByArtist$personById(
    Query$recentlyPlayedTracksByArtist$personById instance,
    TRes Function(Query$recentlyPlayedTracksByArtist$personById) then,
  ) = _CopyWithImpl$Query$recentlyPlayedTracksByArtist$personById;

  factory CopyWith$Query$recentlyPlayedTracksByArtist$personById.stub(
    TRes res,
  ) = _CopyWithStubImpl$Query$recentlyPlayedTracksByArtist$personById;

  TRes call({
    String? id,
    List<Query$recentlyPlayedTracksByArtist$personById$recentlyPlayedTracks>?
    recentlyPlayedTracks,
    String? $__typename,
  });
  TRes recentlyPlayedTracks(
    Iterable<Query$recentlyPlayedTracksByArtist$personById$recentlyPlayedTracks>
    Function(
      Iterable<
        CopyWith$Query$recentlyPlayedTracksByArtist$personById$recentlyPlayedTracks<
          Query$recentlyPlayedTracksByArtist$personById$recentlyPlayedTracks
        >
      >,
    )
    _fn,
  );
}

class _CopyWithImpl$Query$recentlyPlayedTracksByArtist$personById<TRes>
    implements CopyWith$Query$recentlyPlayedTracksByArtist$personById<TRes> {
  _CopyWithImpl$Query$recentlyPlayedTracksByArtist$personById(
    this._instance,
    this._then,
  );

  final Query$recentlyPlayedTracksByArtist$personById _instance;

  final TRes Function(Query$recentlyPlayedTracksByArtist$personById) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? id = _undefined,
    Object? recentlyPlayedTracks = _undefined,
    Object? $__typename = _undefined,
  }) => _then(
    Query$recentlyPlayedTracksByArtist$personById(
      id: id == _undefined || id == null ? _instance.id : (id as String),
      recentlyPlayedTracks:
          recentlyPlayedTracks == _undefined || recentlyPlayedTracks == null
          ? _instance.recentlyPlayedTracks
          : (recentlyPlayedTracks
                as List<
                  Query$recentlyPlayedTracksByArtist$personById$recentlyPlayedTracks
                >),
      $__typename: $__typename == _undefined || $__typename == null
          ? _instance.$__typename
          : ($__typename as String),
    ),
  );

  TRes recentlyPlayedTracks(
    Iterable<Query$recentlyPlayedTracksByArtist$personById$recentlyPlayedTracks>
    Function(
      Iterable<
        CopyWith$Query$recentlyPlayedTracksByArtist$personById$recentlyPlayedTracks<
          Query$recentlyPlayedTracksByArtist$personById$recentlyPlayedTracks
        >
      >,
    )
    _fn,
  ) => call(
    recentlyPlayedTracks: _fn(
      _instance.recentlyPlayedTracks.map(
        (e) =>
            CopyWith$Query$recentlyPlayedTracksByArtist$personById$recentlyPlayedTracks(
              e,
              (i) => i,
            ),
      ),
    ).toList(),
  );
}

class _CopyWithStubImpl$Query$recentlyPlayedTracksByArtist$personById<TRes>
    implements CopyWith$Query$recentlyPlayedTracksByArtist$personById<TRes> {
  _CopyWithStubImpl$Query$recentlyPlayedTracksByArtist$personById(this._res);

  TRes _res;

  call({
    String? id,
    List<Query$recentlyPlayedTracksByArtist$personById$recentlyPlayedTracks>?
    recentlyPlayedTracks,
    String? $__typename,
  }) => _res;

  recentlyPlayedTracks(_fn) => _res;
}

class Query$recentlyPlayedTracksByArtist$personById$recentlyPlayedTracks
    implements Fragment$fragmentTrack {
  Query$recentlyPlayedTracksByArtist$personById$recentlyPlayedTracks({
    required this.id,
    required this.number,
    required this.discNumber,
    required this.artist,
    this.metadata,
    this.mediaFile,
    this.rating,
    this.$__typename = 'Track',
    this.lastPlayedAt,
    required this.album,
  });

  factory Query$recentlyPlayedTracksByArtist$personById$recentlyPlayedTracks.fromJson(
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
    final l$lastPlayedAt = json['lastPlayedAt'];
    final l$album = json['album'];
    return Query$recentlyPlayedTracksByArtist$personById$recentlyPlayedTracks(
      id: (l$id as String),
      number: (l$number as int),
      discNumber: (l$discNumber as int),
      artist:
          Query$recentlyPlayedTracksByArtist$personById$recentlyPlayedTracks$artist.fromJson(
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
                Query$recentlyPlayedTracksByArtist$personById$recentlyPlayedTracks$mediaFile.fromJson(
                  (e as Map<String, dynamic>),
                ),
          )
          .toList(),
      rating: (l$rating as int?),
      $__typename: (l$$__typename as String),
      lastPlayedAt: (l$lastPlayedAt as String?),
      album: Fragment$fragmentAlbum.fromJson((l$album as Map<String, dynamic>)),
    );
  }

  final String id;

  final int number;

  final int discNumber;

  final Query$recentlyPlayedTracksByArtist$personById$recentlyPlayedTracks$artist
  artist;

  final List<Fragment$fragmentMetadata>? metadata;

  final List<
    Query$recentlyPlayedTracksByArtist$personById$recentlyPlayedTracks$mediaFile
  >?
  mediaFile;

  final int? rating;

  final String $__typename;

  final String? lastPlayedAt;

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
    final l$lastPlayedAt = lastPlayedAt;
    _resultData['lastPlayedAt'] = l$lastPlayedAt;
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
    final l$lastPlayedAt = lastPlayedAt;
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
      l$lastPlayedAt,
      l$album,
    ]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other
            is! Query$recentlyPlayedTracksByArtist$personById$recentlyPlayedTracks ||
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
    final l$lastPlayedAt = lastPlayedAt;
    final lOther$lastPlayedAt = other.lastPlayedAt;
    if (l$lastPlayedAt != lOther$lastPlayedAt) {
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

extension UtilityExtension$Query$recentlyPlayedTracksByArtist$personById$recentlyPlayedTracks
    on Query$recentlyPlayedTracksByArtist$personById$recentlyPlayedTracks {
  CopyWith$Query$recentlyPlayedTracksByArtist$personById$recentlyPlayedTracks<
    Query$recentlyPlayedTracksByArtist$personById$recentlyPlayedTracks
  >
  get copyWith =>
      CopyWith$Query$recentlyPlayedTracksByArtist$personById$recentlyPlayedTracks(
        this,
        (i) => i,
      );
}

abstract class CopyWith$Query$recentlyPlayedTracksByArtist$personById$recentlyPlayedTracks<
  TRes
> {
  factory CopyWith$Query$recentlyPlayedTracksByArtist$personById$recentlyPlayedTracks(
    Query$recentlyPlayedTracksByArtist$personById$recentlyPlayedTracks instance,
    TRes Function(
      Query$recentlyPlayedTracksByArtist$personById$recentlyPlayedTracks,
    )
    then,
  ) = _CopyWithImpl$Query$recentlyPlayedTracksByArtist$personById$recentlyPlayedTracks;

  factory CopyWith$Query$recentlyPlayedTracksByArtist$personById$recentlyPlayedTracks.stub(
    TRes res,
  ) = _CopyWithStubImpl$Query$recentlyPlayedTracksByArtist$personById$recentlyPlayedTracks;

  TRes call({
    String? id,
    int? number,
    int? discNumber,
    Query$recentlyPlayedTracksByArtist$personById$recentlyPlayedTracks$artist?
    artist,
    List<Fragment$fragmentMetadata>? metadata,
    List<
      Query$recentlyPlayedTracksByArtist$personById$recentlyPlayedTracks$mediaFile
    >?
    mediaFile,
    int? rating,
    String? $__typename,
    String? lastPlayedAt,
    Fragment$fragmentAlbum? album,
  });
  CopyWith$Query$recentlyPlayedTracksByArtist$personById$recentlyPlayedTracks$artist<
    TRes
  >
  get artist;
  TRes metadata(
    Iterable<Fragment$fragmentMetadata>? Function(
      Iterable<CopyWith$Fragment$fragmentMetadata<Fragment$fragmentMetadata>>?,
    )
    _fn,
  );
  TRes mediaFile(
    Iterable<
      Query$recentlyPlayedTracksByArtist$personById$recentlyPlayedTracks$mediaFile
    >?
    Function(
      Iterable<
        CopyWith$Query$recentlyPlayedTracksByArtist$personById$recentlyPlayedTracks$mediaFile<
          Query$recentlyPlayedTracksByArtist$personById$recentlyPlayedTracks$mediaFile
        >
      >?,
    )
    _fn,
  );
  CopyWith$Fragment$fragmentAlbum<TRes> get album;
}

class _CopyWithImpl$Query$recentlyPlayedTracksByArtist$personById$recentlyPlayedTracks<
  TRes
>
    implements
        CopyWith$Query$recentlyPlayedTracksByArtist$personById$recentlyPlayedTracks<
          TRes
        > {
  _CopyWithImpl$Query$recentlyPlayedTracksByArtist$personById$recentlyPlayedTracks(
    this._instance,
    this._then,
  );

  final Query$recentlyPlayedTracksByArtist$personById$recentlyPlayedTracks
  _instance;

  final TRes Function(
    Query$recentlyPlayedTracksByArtist$personById$recentlyPlayedTracks,
  )
  _then;

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
    Object? lastPlayedAt = _undefined,
    Object? album = _undefined,
  }) => _then(
    Query$recentlyPlayedTracksByArtist$personById$recentlyPlayedTracks(
      id: id == _undefined || id == null ? _instance.id : (id as String),
      number: number == _undefined || number == null
          ? _instance.number
          : (number as int),
      discNumber: discNumber == _undefined || discNumber == null
          ? _instance.discNumber
          : (discNumber as int),
      artist: artist == _undefined || artist == null
          ? _instance.artist
          : (artist
                as Query$recentlyPlayedTracksByArtist$personById$recentlyPlayedTracks$artist),
      metadata: metadata == _undefined
          ? _instance.metadata
          : (metadata as List<Fragment$fragmentMetadata>?),
      mediaFile: mediaFile == _undefined
          ? _instance.mediaFile
          : (mediaFile
                as List<
                  Query$recentlyPlayedTracksByArtist$personById$recentlyPlayedTracks$mediaFile
                >?),
      rating: rating == _undefined ? _instance.rating : (rating as int?),
      $__typename: $__typename == _undefined || $__typename == null
          ? _instance.$__typename
          : ($__typename as String),
      lastPlayedAt: lastPlayedAt == _undefined
          ? _instance.lastPlayedAt
          : (lastPlayedAt as String?),
      album: album == _undefined || album == null
          ? _instance.album
          : (album as Fragment$fragmentAlbum),
    ),
  );

  CopyWith$Query$recentlyPlayedTracksByArtist$personById$recentlyPlayedTracks$artist<
    TRes
  >
  get artist {
    final local$artist = _instance.artist;
    return CopyWith$Query$recentlyPlayedTracksByArtist$personById$recentlyPlayedTracks$artist(
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
    Iterable<
      Query$recentlyPlayedTracksByArtist$personById$recentlyPlayedTracks$mediaFile
    >?
    Function(
      Iterable<
        CopyWith$Query$recentlyPlayedTracksByArtist$personById$recentlyPlayedTracks$mediaFile<
          Query$recentlyPlayedTracksByArtist$personById$recentlyPlayedTracks$mediaFile
        >
      >?,
    )
    _fn,
  ) => call(
    mediaFile: _fn(
      _instance.mediaFile?.map(
        (e) =>
            CopyWith$Query$recentlyPlayedTracksByArtist$personById$recentlyPlayedTracks$mediaFile(
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

class _CopyWithStubImpl$Query$recentlyPlayedTracksByArtist$personById$recentlyPlayedTracks<
  TRes
>
    implements
        CopyWith$Query$recentlyPlayedTracksByArtist$personById$recentlyPlayedTracks<
          TRes
        > {
  _CopyWithStubImpl$Query$recentlyPlayedTracksByArtist$personById$recentlyPlayedTracks(
    this._res,
  );

  TRes _res;

  call({
    String? id,
    int? number,
    int? discNumber,
    Query$recentlyPlayedTracksByArtist$personById$recentlyPlayedTracks$artist?
    artist,
    List<Fragment$fragmentMetadata>? metadata,
    List<
      Query$recentlyPlayedTracksByArtist$personById$recentlyPlayedTracks$mediaFile
    >?
    mediaFile,
    int? rating,
    String? $__typename,
    String? lastPlayedAt,
    Fragment$fragmentAlbum? album,
  }) => _res;

  CopyWith$Query$recentlyPlayedTracksByArtist$personById$recentlyPlayedTracks$artist<
    TRes
  >
  get artist =>
      CopyWith$Query$recentlyPlayedTracksByArtist$personById$recentlyPlayedTracks$artist.stub(
        _res,
      );

  metadata(_fn) => _res;

  mediaFile(_fn) => _res;

  CopyWith$Fragment$fragmentAlbum<TRes> get album =>
      CopyWith$Fragment$fragmentAlbum.stub(_res);
}

class Query$recentlyPlayedTracksByArtist$personById$recentlyPlayedTracks$artist
    implements Fragment$fragmentTrack$artist {
  Query$recentlyPlayedTracksByArtist$personById$recentlyPlayedTracks$artist({
    required this.id,
    required this.name,
    this.$__typename = 'Person',
  });

  factory Query$recentlyPlayedTracksByArtist$personById$recentlyPlayedTracks$artist.fromJson(
    Map<String, dynamic> json,
  ) {
    final l$id = json['id'];
    final l$name = json['name'];
    final l$$__typename = json['__typename'];
    return Query$recentlyPlayedTracksByArtist$personById$recentlyPlayedTracks$artist(
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
    if (other
            is! Query$recentlyPlayedTracksByArtist$personById$recentlyPlayedTracks$artist ||
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

extension UtilityExtension$Query$recentlyPlayedTracksByArtist$personById$recentlyPlayedTracks$artist
    on Query$recentlyPlayedTracksByArtist$personById$recentlyPlayedTracks$artist {
  CopyWith$Query$recentlyPlayedTracksByArtist$personById$recentlyPlayedTracks$artist<
    Query$recentlyPlayedTracksByArtist$personById$recentlyPlayedTracks$artist
  >
  get copyWith =>
      CopyWith$Query$recentlyPlayedTracksByArtist$personById$recentlyPlayedTracks$artist(
        this,
        (i) => i,
      );
}

abstract class CopyWith$Query$recentlyPlayedTracksByArtist$personById$recentlyPlayedTracks$artist<
  TRes
> {
  factory CopyWith$Query$recentlyPlayedTracksByArtist$personById$recentlyPlayedTracks$artist(
    Query$recentlyPlayedTracksByArtist$personById$recentlyPlayedTracks$artist
    instance,
    TRes Function(
      Query$recentlyPlayedTracksByArtist$personById$recentlyPlayedTracks$artist,
    )
    then,
  ) = _CopyWithImpl$Query$recentlyPlayedTracksByArtist$personById$recentlyPlayedTracks$artist;

  factory CopyWith$Query$recentlyPlayedTracksByArtist$personById$recentlyPlayedTracks$artist.stub(
    TRes res,
  ) = _CopyWithStubImpl$Query$recentlyPlayedTracksByArtist$personById$recentlyPlayedTracks$artist;

  TRes call({String? id, String? name, String? $__typename});
}

class _CopyWithImpl$Query$recentlyPlayedTracksByArtist$personById$recentlyPlayedTracks$artist<
  TRes
>
    implements
        CopyWith$Query$recentlyPlayedTracksByArtist$personById$recentlyPlayedTracks$artist<
          TRes
        > {
  _CopyWithImpl$Query$recentlyPlayedTracksByArtist$personById$recentlyPlayedTracks$artist(
    this._instance,
    this._then,
  );

  final Query$recentlyPlayedTracksByArtist$personById$recentlyPlayedTracks$artist
  _instance;

  final TRes Function(
    Query$recentlyPlayedTracksByArtist$personById$recentlyPlayedTracks$artist,
  )
  _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? id = _undefined,
    Object? name = _undefined,
    Object? $__typename = _undefined,
  }) => _then(
    Query$recentlyPlayedTracksByArtist$personById$recentlyPlayedTracks$artist(
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

class _CopyWithStubImpl$Query$recentlyPlayedTracksByArtist$personById$recentlyPlayedTracks$artist<
  TRes
>
    implements
        CopyWith$Query$recentlyPlayedTracksByArtist$personById$recentlyPlayedTracks$artist<
          TRes
        > {
  _CopyWithStubImpl$Query$recentlyPlayedTracksByArtist$personById$recentlyPlayedTracks$artist(
    this._res,
  );

  TRes _res;

  call({String? id, String? name, String? $__typename}) => _res;
}

class Query$recentlyPlayedTracksByArtist$personById$recentlyPlayedTracks$mediaFile
    implements Fragment$fragmentTrack$mediaFile {
  Query$recentlyPlayedTracksByArtist$personById$recentlyPlayedTracks$mediaFile({
    this.durationInMilliseconds,
    this.$__typename = 'MediaFile',
  });

  factory Query$recentlyPlayedTracksByArtist$personById$recentlyPlayedTracks$mediaFile.fromJson(
    Map<String, dynamic> json,
  ) {
    final l$durationInMilliseconds = json['durationInMilliseconds'];
    final l$$__typename = json['__typename'];
    return Query$recentlyPlayedTracksByArtist$personById$recentlyPlayedTracks$mediaFile(
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
    if (other
            is! Query$recentlyPlayedTracksByArtist$personById$recentlyPlayedTracks$mediaFile ||
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

extension UtilityExtension$Query$recentlyPlayedTracksByArtist$personById$recentlyPlayedTracks$mediaFile
    on Query$recentlyPlayedTracksByArtist$personById$recentlyPlayedTracks$mediaFile {
  CopyWith$Query$recentlyPlayedTracksByArtist$personById$recentlyPlayedTracks$mediaFile<
    Query$recentlyPlayedTracksByArtist$personById$recentlyPlayedTracks$mediaFile
  >
  get copyWith =>
      CopyWith$Query$recentlyPlayedTracksByArtist$personById$recentlyPlayedTracks$mediaFile(
        this,
        (i) => i,
      );
}

abstract class CopyWith$Query$recentlyPlayedTracksByArtist$personById$recentlyPlayedTracks$mediaFile<
  TRes
> {
  factory CopyWith$Query$recentlyPlayedTracksByArtist$personById$recentlyPlayedTracks$mediaFile(
    Query$recentlyPlayedTracksByArtist$personById$recentlyPlayedTracks$mediaFile
    instance,
    TRes Function(
      Query$recentlyPlayedTracksByArtist$personById$recentlyPlayedTracks$mediaFile,
    )
    then,
  ) = _CopyWithImpl$Query$recentlyPlayedTracksByArtist$personById$recentlyPlayedTracks$mediaFile;

  factory CopyWith$Query$recentlyPlayedTracksByArtist$personById$recentlyPlayedTracks$mediaFile.stub(
    TRes res,
  ) = _CopyWithStubImpl$Query$recentlyPlayedTracksByArtist$personById$recentlyPlayedTracks$mediaFile;

  TRes call({int? durationInMilliseconds, String? $__typename});
}

class _CopyWithImpl$Query$recentlyPlayedTracksByArtist$personById$recentlyPlayedTracks$mediaFile<
  TRes
>
    implements
        CopyWith$Query$recentlyPlayedTracksByArtist$personById$recentlyPlayedTracks$mediaFile<
          TRes
        > {
  _CopyWithImpl$Query$recentlyPlayedTracksByArtist$personById$recentlyPlayedTracks$mediaFile(
    this._instance,
    this._then,
  );

  final Query$recentlyPlayedTracksByArtist$personById$recentlyPlayedTracks$mediaFile
  _instance;

  final TRes Function(
    Query$recentlyPlayedTracksByArtist$personById$recentlyPlayedTracks$mediaFile,
  )
  _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? durationInMilliseconds = _undefined,
    Object? $__typename = _undefined,
  }) => _then(
    Query$recentlyPlayedTracksByArtist$personById$recentlyPlayedTracks$mediaFile(
      durationInMilliseconds: durationInMilliseconds == _undefined
          ? _instance.durationInMilliseconds
          : (durationInMilliseconds as int?),
      $__typename: $__typename == _undefined || $__typename == null
          ? _instance.$__typename
          : ($__typename as String),
    ),
  );
}

class _CopyWithStubImpl$Query$recentlyPlayedTracksByArtist$personById$recentlyPlayedTracks$mediaFile<
  TRes
>
    implements
        CopyWith$Query$recentlyPlayedTracksByArtist$personById$recentlyPlayedTracks$mediaFile<
          TRes
        > {
  _CopyWithStubImpl$Query$recentlyPlayedTracksByArtist$personById$recentlyPlayedTracks$mediaFile(
    this._res,
  );

  TRes _res;

  call({int? durationInMilliseconds, String? $__typename}) => _res;
}

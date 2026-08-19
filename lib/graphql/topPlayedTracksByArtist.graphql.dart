import 'fragmentAlbum.graphql.dart';
import 'fragmentImages.graphql.dart';
import 'fragmentMetadata.graphql.dart';
import 'fragmentTrack.graphql.dart';

import 'package:gql/ast.dart';

class Variables$Query$topPlayedTracksByArtist {
  factory Variables$Query$topPlayedTracksByArtist({String? id}) =>
      Variables$Query$topPlayedTracksByArtist._({if (id != null) r'id': id});

  Variables$Query$topPlayedTracksByArtist._(this._$data);

  factory Variables$Query$topPlayedTracksByArtist.fromJson(
    Map<String, dynamic> data,
  ) {
    final result$data = <String, dynamic>{};
    if (data.containsKey('id')) {
      final l$id = data['id'];
      result$data['id'] = (l$id as String?);
    }
    return Variables$Query$topPlayedTracksByArtist._(result$data);
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

  CopyWith$Variables$Query$topPlayedTracksByArtist<
    Variables$Query$topPlayedTracksByArtist
  >
  get copyWith =>
      CopyWith$Variables$Query$topPlayedTracksByArtist(this, (i) => i);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Variables$Query$topPlayedTracksByArtist ||
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

abstract class CopyWith$Variables$Query$topPlayedTracksByArtist<TRes> {
  factory CopyWith$Variables$Query$topPlayedTracksByArtist(
    Variables$Query$topPlayedTracksByArtist instance,
    TRes Function(Variables$Query$topPlayedTracksByArtist) then,
  ) = _CopyWithImpl$Variables$Query$topPlayedTracksByArtist;

  factory CopyWith$Variables$Query$topPlayedTracksByArtist.stub(TRes res) =
      _CopyWithStubImpl$Variables$Query$topPlayedTracksByArtist;

  TRes call({String? id});
}

class _CopyWithImpl$Variables$Query$topPlayedTracksByArtist<TRes>
    implements CopyWith$Variables$Query$topPlayedTracksByArtist<TRes> {
  _CopyWithImpl$Variables$Query$topPlayedTracksByArtist(
    this._instance,
    this._then,
  );

  final Variables$Query$topPlayedTracksByArtist _instance;

  final TRes Function(Variables$Query$topPlayedTracksByArtist) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({Object? id = _undefined}) => _then(
    Variables$Query$topPlayedTracksByArtist._({
      ..._instance._$data,
      if (id != _undefined) 'id': (id as String?),
    }),
  );
}

class _CopyWithStubImpl$Variables$Query$topPlayedTracksByArtist<TRes>
    implements CopyWith$Variables$Query$topPlayedTracksByArtist<TRes> {
  _CopyWithStubImpl$Variables$Query$topPlayedTracksByArtist(this._res);

  TRes _res;

  call({String? id}) => _res;
}

class Query$topPlayedTracksByArtist {
  Query$topPlayedTracksByArtist({this.personById, this.$__typename = 'Query'});

  factory Query$topPlayedTracksByArtist.fromJson(Map<String, dynamic> json) {
    final l$personById = json['personById'];
    final l$$__typename = json['__typename'];
    return Query$topPlayedTracksByArtist(
      personById: l$personById == null
          ? null
          : Query$topPlayedTracksByArtist$personById.fromJson(
              (l$personById as Map<String, dynamic>),
            ),
      $__typename: (l$$__typename as String),
    );
  }

  final Query$topPlayedTracksByArtist$personById? personById;

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
    if (other is! Query$topPlayedTracksByArtist ||
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

extension UtilityExtension$Query$topPlayedTracksByArtist
    on Query$topPlayedTracksByArtist {
  CopyWith$Query$topPlayedTracksByArtist<Query$topPlayedTracksByArtist>
  get copyWith => CopyWith$Query$topPlayedTracksByArtist(this, (i) => i);
}

abstract class CopyWith$Query$topPlayedTracksByArtist<TRes> {
  factory CopyWith$Query$topPlayedTracksByArtist(
    Query$topPlayedTracksByArtist instance,
    TRes Function(Query$topPlayedTracksByArtist) then,
  ) = _CopyWithImpl$Query$topPlayedTracksByArtist;

  factory CopyWith$Query$topPlayedTracksByArtist.stub(TRes res) =
      _CopyWithStubImpl$Query$topPlayedTracksByArtist;

  TRes call({
    Query$topPlayedTracksByArtist$personById? personById,
    String? $__typename,
  });
  CopyWith$Query$topPlayedTracksByArtist$personById<TRes> get personById;
}

class _CopyWithImpl$Query$topPlayedTracksByArtist<TRes>
    implements CopyWith$Query$topPlayedTracksByArtist<TRes> {
  _CopyWithImpl$Query$topPlayedTracksByArtist(this._instance, this._then);

  final Query$topPlayedTracksByArtist _instance;

  final TRes Function(Query$topPlayedTracksByArtist) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? personById = _undefined,
    Object? $__typename = _undefined,
  }) => _then(
    Query$topPlayedTracksByArtist(
      personById: personById == _undefined
          ? _instance.personById
          : (personById as Query$topPlayedTracksByArtist$personById?),
      $__typename: $__typename == _undefined || $__typename == null
          ? _instance.$__typename
          : ($__typename as String),
    ),
  );

  CopyWith$Query$topPlayedTracksByArtist$personById<TRes> get personById {
    final local$personById = _instance.personById;
    return local$personById == null
        ? CopyWith$Query$topPlayedTracksByArtist$personById.stub(
            _then(_instance),
          )
        : CopyWith$Query$topPlayedTracksByArtist$personById(
            local$personById,
            (e) => call(personById: e),
          );
  }
}

class _CopyWithStubImpl$Query$topPlayedTracksByArtist<TRes>
    implements CopyWith$Query$topPlayedTracksByArtist<TRes> {
  _CopyWithStubImpl$Query$topPlayedTracksByArtist(this._res);

  TRes _res;

  call({
    Query$topPlayedTracksByArtist$personById? personById,
    String? $__typename,
  }) => _res;

  CopyWith$Query$topPlayedTracksByArtist$personById<TRes> get personById =>
      CopyWith$Query$topPlayedTracksByArtist$personById.stub(_res);
}

const documentNodeQuerytopPlayedTracksByArtist = DocumentNode(
  definitions: [
    OperationDefinitionNode(
      type: OperationType.query,
      name: NameNode(value: 'topPlayedTracksByArtist'),
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
                  name: NameNode(value: 'topPlayedTracks'),
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
                        name: NameNode(value: 'playCount'),
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

class Query$topPlayedTracksByArtist$personById {
  Query$topPlayedTracksByArtist$personById({
    required this.id,
    required this.topPlayedTracks,
    this.$__typename = 'Person',
  });

  factory Query$topPlayedTracksByArtist$personById.fromJson(
    Map<String, dynamic> json,
  ) {
    final l$id = json['id'];
    final l$topPlayedTracks = json['topPlayedTracks'];
    final l$$__typename = json['__typename'];
    return Query$topPlayedTracksByArtist$personById(
      id: (l$id as String),
      topPlayedTracks: (l$topPlayedTracks as List<dynamic>)
          .map(
            (e) =>
                Query$topPlayedTracksByArtist$personById$topPlayedTracks.fromJson(
                  (e as Map<String, dynamic>),
                ),
          )
          .toList(),
      $__typename: (l$$__typename as String),
    );
  }

  final String id;

  final List<Query$topPlayedTracksByArtist$personById$topPlayedTracks>
  topPlayedTracks;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$id = id;
    _resultData['id'] = l$id;
    final l$topPlayedTracks = topPlayedTracks;
    _resultData['topPlayedTracks'] = l$topPlayedTracks
        .map((e) => e.toJson())
        .toList();
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$id = id;
    final l$topPlayedTracks = topPlayedTracks;
    final l$$__typename = $__typename;
    return Object.hashAll([
      l$id,
      Object.hashAll(l$topPlayedTracks.map((v) => v)),
      l$$__typename,
    ]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Query$topPlayedTracksByArtist$personById ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$id = id;
    final lOther$id = other.id;
    if (l$id != lOther$id) {
      return false;
    }
    final l$topPlayedTracks = topPlayedTracks;
    final lOther$topPlayedTracks = other.topPlayedTracks;
    if (l$topPlayedTracks.length != lOther$topPlayedTracks.length) {
      return false;
    }
    for (int i = 0; i < l$topPlayedTracks.length; i++) {
      final l$topPlayedTracks$entry = l$topPlayedTracks[i];
      final lOther$topPlayedTracks$entry = lOther$topPlayedTracks[i];
      if (l$topPlayedTracks$entry != lOther$topPlayedTracks$entry) {
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

extension UtilityExtension$Query$topPlayedTracksByArtist$personById
    on Query$topPlayedTracksByArtist$personById {
  CopyWith$Query$topPlayedTracksByArtist$personById<
    Query$topPlayedTracksByArtist$personById
  >
  get copyWith =>
      CopyWith$Query$topPlayedTracksByArtist$personById(this, (i) => i);
}

abstract class CopyWith$Query$topPlayedTracksByArtist$personById<TRes> {
  factory CopyWith$Query$topPlayedTracksByArtist$personById(
    Query$topPlayedTracksByArtist$personById instance,
    TRes Function(Query$topPlayedTracksByArtist$personById) then,
  ) = _CopyWithImpl$Query$topPlayedTracksByArtist$personById;

  factory CopyWith$Query$topPlayedTracksByArtist$personById.stub(TRes res) =
      _CopyWithStubImpl$Query$topPlayedTracksByArtist$personById;

  TRes call({
    String? id,
    List<Query$topPlayedTracksByArtist$personById$topPlayedTracks>?
    topPlayedTracks,
    String? $__typename,
  });
  TRes topPlayedTracks(
    Iterable<Query$topPlayedTracksByArtist$personById$topPlayedTracks> Function(
      Iterable<
        CopyWith$Query$topPlayedTracksByArtist$personById$topPlayedTracks<
          Query$topPlayedTracksByArtist$personById$topPlayedTracks
        >
      >,
    )
    _fn,
  );
}

class _CopyWithImpl$Query$topPlayedTracksByArtist$personById<TRes>
    implements CopyWith$Query$topPlayedTracksByArtist$personById<TRes> {
  _CopyWithImpl$Query$topPlayedTracksByArtist$personById(
    this._instance,
    this._then,
  );

  final Query$topPlayedTracksByArtist$personById _instance;

  final TRes Function(Query$topPlayedTracksByArtist$personById) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? id = _undefined,
    Object? topPlayedTracks = _undefined,
    Object? $__typename = _undefined,
  }) => _then(
    Query$topPlayedTracksByArtist$personById(
      id: id == _undefined || id == null ? _instance.id : (id as String),
      topPlayedTracks: topPlayedTracks == _undefined || topPlayedTracks == null
          ? _instance.topPlayedTracks
          : (topPlayedTracks
                as List<
                  Query$topPlayedTracksByArtist$personById$topPlayedTracks
                >),
      $__typename: $__typename == _undefined || $__typename == null
          ? _instance.$__typename
          : ($__typename as String),
    ),
  );

  TRes topPlayedTracks(
    Iterable<Query$topPlayedTracksByArtist$personById$topPlayedTracks> Function(
      Iterable<
        CopyWith$Query$topPlayedTracksByArtist$personById$topPlayedTracks<
          Query$topPlayedTracksByArtist$personById$topPlayedTracks
        >
      >,
    )
    _fn,
  ) => call(
    topPlayedTracks: _fn(
      _instance.topPlayedTracks.map(
        (e) =>
            CopyWith$Query$topPlayedTracksByArtist$personById$topPlayedTracks(
              e,
              (i) => i,
            ),
      ),
    ).toList(),
  );
}

class _CopyWithStubImpl$Query$topPlayedTracksByArtist$personById<TRes>
    implements CopyWith$Query$topPlayedTracksByArtist$personById<TRes> {
  _CopyWithStubImpl$Query$topPlayedTracksByArtist$personById(this._res);

  TRes _res;

  call({
    String? id,
    List<Query$topPlayedTracksByArtist$personById$topPlayedTracks>?
    topPlayedTracks,
    String? $__typename,
  }) => _res;

  topPlayedTracks(_fn) => _res;
}

class Query$topPlayedTracksByArtist$personById$topPlayedTracks
    implements Fragment$fragmentTrack {
  Query$topPlayedTracksByArtist$personById$topPlayedTracks({
    required this.id,
    required this.number,
    required this.discNumber,
    required this.artist,
    this.metadata,
    this.mediaFile,
    this.rating,
    this.$__typename = 'Track',
    this.playCount,
    required this.album,
  });

  factory Query$topPlayedTracksByArtist$personById$topPlayedTracks.fromJson(
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
    final l$playCount = json['playCount'];
    final l$album = json['album'];
    return Query$topPlayedTracksByArtist$personById$topPlayedTracks(
      id: (l$id as String),
      number: (l$number as int),
      discNumber: (l$discNumber as int),
      artist:
          Query$topPlayedTracksByArtist$personById$topPlayedTracks$artist.fromJson(
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
                Query$topPlayedTracksByArtist$personById$topPlayedTracks$mediaFile.fromJson(
                  (e as Map<String, dynamic>),
                ),
          )
          .toList(),
      rating: (l$rating as int?),
      $__typename: (l$$__typename as String),
      playCount: (l$playCount as int?),
      album: Fragment$fragmentAlbum.fromJson((l$album as Map<String, dynamic>)),
    );
  }

  final String id;

  final int number;

  final int discNumber;

  final Query$topPlayedTracksByArtist$personById$topPlayedTracks$artist artist;

  final List<Fragment$fragmentMetadata>? metadata;

  final List<
    Query$topPlayedTracksByArtist$personById$topPlayedTracks$mediaFile
  >?
  mediaFile;

  final int? rating;

  final String $__typename;

  final int? playCount;

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
    final l$playCount = playCount;
    _resultData['playCount'] = l$playCount;
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
    final l$playCount = playCount;
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
      l$playCount,
      l$album,
    ]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Query$topPlayedTracksByArtist$personById$topPlayedTracks ||
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
    final l$playCount = playCount;
    final lOther$playCount = other.playCount;
    if (l$playCount != lOther$playCount) {
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

extension UtilityExtension$Query$topPlayedTracksByArtist$personById$topPlayedTracks
    on Query$topPlayedTracksByArtist$personById$topPlayedTracks {
  CopyWith$Query$topPlayedTracksByArtist$personById$topPlayedTracks<
    Query$topPlayedTracksByArtist$personById$topPlayedTracks
  >
  get copyWith =>
      CopyWith$Query$topPlayedTracksByArtist$personById$topPlayedTracks(
        this,
        (i) => i,
      );
}

abstract class CopyWith$Query$topPlayedTracksByArtist$personById$topPlayedTracks<
  TRes
> {
  factory CopyWith$Query$topPlayedTracksByArtist$personById$topPlayedTracks(
    Query$topPlayedTracksByArtist$personById$topPlayedTracks instance,
    TRes Function(Query$topPlayedTracksByArtist$personById$topPlayedTracks)
    then,
  ) = _CopyWithImpl$Query$topPlayedTracksByArtist$personById$topPlayedTracks;

  factory CopyWith$Query$topPlayedTracksByArtist$personById$topPlayedTracks.stub(
    TRes res,
  ) = _CopyWithStubImpl$Query$topPlayedTracksByArtist$personById$topPlayedTracks;

  TRes call({
    String? id,
    int? number,
    int? discNumber,
    Query$topPlayedTracksByArtist$personById$topPlayedTracks$artist? artist,
    List<Fragment$fragmentMetadata>? metadata,
    List<Query$topPlayedTracksByArtist$personById$topPlayedTracks$mediaFile>?
    mediaFile,
    int? rating,
    String? $__typename,
    int? playCount,
    Fragment$fragmentAlbum? album,
  });
  CopyWith$Query$topPlayedTracksByArtist$personById$topPlayedTracks$artist<TRes>
  get artist;
  TRes metadata(
    Iterable<Fragment$fragmentMetadata>? Function(
      Iterable<CopyWith$Fragment$fragmentMetadata<Fragment$fragmentMetadata>>?,
    )
    _fn,
  );
  TRes mediaFile(
    Iterable<
      Query$topPlayedTracksByArtist$personById$topPlayedTracks$mediaFile
    >?
    Function(
      Iterable<
        CopyWith$Query$topPlayedTracksByArtist$personById$topPlayedTracks$mediaFile<
          Query$topPlayedTracksByArtist$personById$topPlayedTracks$mediaFile
        >
      >?,
    )
    _fn,
  );
  CopyWith$Fragment$fragmentAlbum<TRes> get album;
}

class _CopyWithImpl$Query$topPlayedTracksByArtist$personById$topPlayedTracks<
  TRes
>
    implements
        CopyWith$Query$topPlayedTracksByArtist$personById$topPlayedTracks<
          TRes
        > {
  _CopyWithImpl$Query$topPlayedTracksByArtist$personById$topPlayedTracks(
    this._instance,
    this._then,
  );

  final Query$topPlayedTracksByArtist$personById$topPlayedTracks _instance;

  final TRes Function(Query$topPlayedTracksByArtist$personById$topPlayedTracks)
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
    Object? playCount = _undefined,
    Object? album = _undefined,
  }) => _then(
    Query$topPlayedTracksByArtist$personById$topPlayedTracks(
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
                as Query$topPlayedTracksByArtist$personById$topPlayedTracks$artist),
      metadata: metadata == _undefined
          ? _instance.metadata
          : (metadata as List<Fragment$fragmentMetadata>?),
      mediaFile: mediaFile == _undefined
          ? _instance.mediaFile
          : (mediaFile
                as List<
                  Query$topPlayedTracksByArtist$personById$topPlayedTracks$mediaFile
                >?),
      rating: rating == _undefined ? _instance.rating : (rating as int?),
      $__typename: $__typename == _undefined || $__typename == null
          ? _instance.$__typename
          : ($__typename as String),
      playCount: playCount == _undefined
          ? _instance.playCount
          : (playCount as int?),
      album: album == _undefined || album == null
          ? _instance.album
          : (album as Fragment$fragmentAlbum),
    ),
  );

  CopyWith$Query$topPlayedTracksByArtist$personById$topPlayedTracks$artist<TRes>
  get artist {
    final local$artist = _instance.artist;
    return CopyWith$Query$topPlayedTracksByArtist$personById$topPlayedTracks$artist(
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
      Query$topPlayedTracksByArtist$personById$topPlayedTracks$mediaFile
    >?
    Function(
      Iterable<
        CopyWith$Query$topPlayedTracksByArtist$personById$topPlayedTracks$mediaFile<
          Query$topPlayedTracksByArtist$personById$topPlayedTracks$mediaFile
        >
      >?,
    )
    _fn,
  ) => call(
    mediaFile: _fn(
      _instance.mediaFile?.map(
        (e) =>
            CopyWith$Query$topPlayedTracksByArtist$personById$topPlayedTracks$mediaFile(
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

class _CopyWithStubImpl$Query$topPlayedTracksByArtist$personById$topPlayedTracks<
  TRes
>
    implements
        CopyWith$Query$topPlayedTracksByArtist$personById$topPlayedTracks<
          TRes
        > {
  _CopyWithStubImpl$Query$topPlayedTracksByArtist$personById$topPlayedTracks(
    this._res,
  );

  TRes _res;

  call({
    String? id,
    int? number,
    int? discNumber,
    Query$topPlayedTracksByArtist$personById$topPlayedTracks$artist? artist,
    List<Fragment$fragmentMetadata>? metadata,
    List<Query$topPlayedTracksByArtist$personById$topPlayedTracks$mediaFile>?
    mediaFile,
    int? rating,
    String? $__typename,
    int? playCount,
    Fragment$fragmentAlbum? album,
  }) => _res;

  CopyWith$Query$topPlayedTracksByArtist$personById$topPlayedTracks$artist<TRes>
  get artist =>
      CopyWith$Query$topPlayedTracksByArtist$personById$topPlayedTracks$artist.stub(
        _res,
      );

  metadata(_fn) => _res;

  mediaFile(_fn) => _res;

  CopyWith$Fragment$fragmentAlbum<TRes> get album =>
      CopyWith$Fragment$fragmentAlbum.stub(_res);
}

class Query$topPlayedTracksByArtist$personById$topPlayedTracks$artist
    implements Fragment$fragmentTrack$artist {
  Query$topPlayedTracksByArtist$personById$topPlayedTracks$artist({
    required this.id,
    required this.name,
    this.$__typename = 'Person',
  });

  factory Query$topPlayedTracksByArtist$personById$topPlayedTracks$artist.fromJson(
    Map<String, dynamic> json,
  ) {
    final l$id = json['id'];
    final l$name = json['name'];
    final l$$__typename = json['__typename'];
    return Query$topPlayedTracksByArtist$personById$topPlayedTracks$artist(
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
            is! Query$topPlayedTracksByArtist$personById$topPlayedTracks$artist ||
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

extension UtilityExtension$Query$topPlayedTracksByArtist$personById$topPlayedTracks$artist
    on Query$topPlayedTracksByArtist$personById$topPlayedTracks$artist {
  CopyWith$Query$topPlayedTracksByArtist$personById$topPlayedTracks$artist<
    Query$topPlayedTracksByArtist$personById$topPlayedTracks$artist
  >
  get copyWith =>
      CopyWith$Query$topPlayedTracksByArtist$personById$topPlayedTracks$artist(
        this,
        (i) => i,
      );
}

abstract class CopyWith$Query$topPlayedTracksByArtist$personById$topPlayedTracks$artist<
  TRes
> {
  factory CopyWith$Query$topPlayedTracksByArtist$personById$topPlayedTracks$artist(
    Query$topPlayedTracksByArtist$personById$topPlayedTracks$artist instance,
    TRes Function(
      Query$topPlayedTracksByArtist$personById$topPlayedTracks$artist,
    )
    then,
  ) = _CopyWithImpl$Query$topPlayedTracksByArtist$personById$topPlayedTracks$artist;

  factory CopyWith$Query$topPlayedTracksByArtist$personById$topPlayedTracks$artist.stub(
    TRes res,
  ) = _CopyWithStubImpl$Query$topPlayedTracksByArtist$personById$topPlayedTracks$artist;

  TRes call({String? id, String? name, String? $__typename});
}

class _CopyWithImpl$Query$topPlayedTracksByArtist$personById$topPlayedTracks$artist<
  TRes
>
    implements
        CopyWith$Query$topPlayedTracksByArtist$personById$topPlayedTracks$artist<
          TRes
        > {
  _CopyWithImpl$Query$topPlayedTracksByArtist$personById$topPlayedTracks$artist(
    this._instance,
    this._then,
  );

  final Query$topPlayedTracksByArtist$personById$topPlayedTracks$artist
  _instance;

  final TRes Function(
    Query$topPlayedTracksByArtist$personById$topPlayedTracks$artist,
  )
  _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? id = _undefined,
    Object? name = _undefined,
    Object? $__typename = _undefined,
  }) => _then(
    Query$topPlayedTracksByArtist$personById$topPlayedTracks$artist(
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

class _CopyWithStubImpl$Query$topPlayedTracksByArtist$personById$topPlayedTracks$artist<
  TRes
>
    implements
        CopyWith$Query$topPlayedTracksByArtist$personById$topPlayedTracks$artist<
          TRes
        > {
  _CopyWithStubImpl$Query$topPlayedTracksByArtist$personById$topPlayedTracks$artist(
    this._res,
  );

  TRes _res;

  call({String? id, String? name, String? $__typename}) => _res;
}

class Query$topPlayedTracksByArtist$personById$topPlayedTracks$mediaFile
    implements Fragment$fragmentTrack$mediaFile {
  Query$topPlayedTracksByArtist$personById$topPlayedTracks$mediaFile({
    this.durationInMilliseconds,
    this.$__typename = 'MediaFile',
  });

  factory Query$topPlayedTracksByArtist$personById$topPlayedTracks$mediaFile.fromJson(
    Map<String, dynamic> json,
  ) {
    final l$durationInMilliseconds = json['durationInMilliseconds'];
    final l$$__typename = json['__typename'];
    return Query$topPlayedTracksByArtist$personById$topPlayedTracks$mediaFile(
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
            is! Query$topPlayedTracksByArtist$personById$topPlayedTracks$mediaFile ||
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

extension UtilityExtension$Query$topPlayedTracksByArtist$personById$topPlayedTracks$mediaFile
    on Query$topPlayedTracksByArtist$personById$topPlayedTracks$mediaFile {
  CopyWith$Query$topPlayedTracksByArtist$personById$topPlayedTracks$mediaFile<
    Query$topPlayedTracksByArtist$personById$topPlayedTracks$mediaFile
  >
  get copyWith =>
      CopyWith$Query$topPlayedTracksByArtist$personById$topPlayedTracks$mediaFile(
        this,
        (i) => i,
      );
}

abstract class CopyWith$Query$topPlayedTracksByArtist$personById$topPlayedTracks$mediaFile<
  TRes
> {
  factory CopyWith$Query$topPlayedTracksByArtist$personById$topPlayedTracks$mediaFile(
    Query$topPlayedTracksByArtist$personById$topPlayedTracks$mediaFile instance,
    TRes Function(
      Query$topPlayedTracksByArtist$personById$topPlayedTracks$mediaFile,
    )
    then,
  ) = _CopyWithImpl$Query$topPlayedTracksByArtist$personById$topPlayedTracks$mediaFile;

  factory CopyWith$Query$topPlayedTracksByArtist$personById$topPlayedTracks$mediaFile.stub(
    TRes res,
  ) = _CopyWithStubImpl$Query$topPlayedTracksByArtist$personById$topPlayedTracks$mediaFile;

  TRes call({int? durationInMilliseconds, String? $__typename});
}

class _CopyWithImpl$Query$topPlayedTracksByArtist$personById$topPlayedTracks$mediaFile<
  TRes
>
    implements
        CopyWith$Query$topPlayedTracksByArtist$personById$topPlayedTracks$mediaFile<
          TRes
        > {
  _CopyWithImpl$Query$topPlayedTracksByArtist$personById$topPlayedTracks$mediaFile(
    this._instance,
    this._then,
  );

  final Query$topPlayedTracksByArtist$personById$topPlayedTracks$mediaFile
  _instance;

  final TRes Function(
    Query$topPlayedTracksByArtist$personById$topPlayedTracks$mediaFile,
  )
  _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? durationInMilliseconds = _undefined,
    Object? $__typename = _undefined,
  }) => _then(
    Query$topPlayedTracksByArtist$personById$topPlayedTracks$mediaFile(
      durationInMilliseconds: durationInMilliseconds == _undefined
          ? _instance.durationInMilliseconds
          : (durationInMilliseconds as int?),
      $__typename: $__typename == _undefined || $__typename == null
          ? _instance.$__typename
          : ($__typename as String),
    ),
  );
}

class _CopyWithStubImpl$Query$topPlayedTracksByArtist$personById$topPlayedTracks$mediaFile<
  TRes
>
    implements
        CopyWith$Query$topPlayedTracksByArtist$personById$topPlayedTracks$mediaFile<
          TRes
        > {
  _CopyWithStubImpl$Query$topPlayedTracksByArtist$personById$topPlayedTracks$mediaFile(
    this._res,
  );

  TRes _res;

  call({int? durationInMilliseconds, String? $__typename}) => _res;
}

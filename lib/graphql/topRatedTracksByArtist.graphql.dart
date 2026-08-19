import 'fragmentAlbum.graphql.dart';
import 'fragmentImages.graphql.dart';
import 'fragmentMetadata.graphql.dart';
import 'fragmentTrack.graphql.dart';

import 'package:gql/ast.dart';

class Variables$Query$topRatedTracksByArtist {
  factory Variables$Query$topRatedTracksByArtist({String? id}) =>
      Variables$Query$topRatedTracksByArtist._({if (id != null) r'id': id});

  Variables$Query$topRatedTracksByArtist._(this._$data);

  factory Variables$Query$topRatedTracksByArtist.fromJson(
    Map<String, dynamic> data,
  ) {
    final result$data = <String, dynamic>{};
    if (data.containsKey('id')) {
      final l$id = data['id'];
      result$data['id'] = (l$id as String?);
    }
    return Variables$Query$topRatedTracksByArtist._(result$data);
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

  CopyWith$Variables$Query$topRatedTracksByArtist<
    Variables$Query$topRatedTracksByArtist
  >
  get copyWith =>
      CopyWith$Variables$Query$topRatedTracksByArtist(this, (i) => i);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Variables$Query$topRatedTracksByArtist ||
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

abstract class CopyWith$Variables$Query$topRatedTracksByArtist<TRes> {
  factory CopyWith$Variables$Query$topRatedTracksByArtist(
    Variables$Query$topRatedTracksByArtist instance,
    TRes Function(Variables$Query$topRatedTracksByArtist) then,
  ) = _CopyWithImpl$Variables$Query$topRatedTracksByArtist;

  factory CopyWith$Variables$Query$topRatedTracksByArtist.stub(TRes res) =
      _CopyWithStubImpl$Variables$Query$topRatedTracksByArtist;

  TRes call({String? id});
}

class _CopyWithImpl$Variables$Query$topRatedTracksByArtist<TRes>
    implements CopyWith$Variables$Query$topRatedTracksByArtist<TRes> {
  _CopyWithImpl$Variables$Query$topRatedTracksByArtist(
    this._instance,
    this._then,
  );

  final Variables$Query$topRatedTracksByArtist _instance;

  final TRes Function(Variables$Query$topRatedTracksByArtist) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({Object? id = _undefined}) => _then(
    Variables$Query$topRatedTracksByArtist._({
      ..._instance._$data,
      if (id != _undefined) 'id': (id as String?),
    }),
  );
}

class _CopyWithStubImpl$Variables$Query$topRatedTracksByArtist<TRes>
    implements CopyWith$Variables$Query$topRatedTracksByArtist<TRes> {
  _CopyWithStubImpl$Variables$Query$topRatedTracksByArtist(this._res);

  TRes _res;

  call({String? id}) => _res;
}

class Query$topRatedTracksByArtist {
  Query$topRatedTracksByArtist({this.personById, this.$__typename = 'Query'});

  factory Query$topRatedTracksByArtist.fromJson(Map<String, dynamic> json) {
    final l$personById = json['personById'];
    final l$$__typename = json['__typename'];
    return Query$topRatedTracksByArtist(
      personById: l$personById == null
          ? null
          : Query$topRatedTracksByArtist$personById.fromJson(
              (l$personById as Map<String, dynamic>),
            ),
      $__typename: (l$$__typename as String),
    );
  }

  final Query$topRatedTracksByArtist$personById? personById;

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
    if (other is! Query$topRatedTracksByArtist ||
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

extension UtilityExtension$Query$topRatedTracksByArtist
    on Query$topRatedTracksByArtist {
  CopyWith$Query$topRatedTracksByArtist<Query$topRatedTracksByArtist>
  get copyWith => CopyWith$Query$topRatedTracksByArtist(this, (i) => i);
}

abstract class CopyWith$Query$topRatedTracksByArtist<TRes> {
  factory CopyWith$Query$topRatedTracksByArtist(
    Query$topRatedTracksByArtist instance,
    TRes Function(Query$topRatedTracksByArtist) then,
  ) = _CopyWithImpl$Query$topRatedTracksByArtist;

  factory CopyWith$Query$topRatedTracksByArtist.stub(TRes res) =
      _CopyWithStubImpl$Query$topRatedTracksByArtist;

  TRes call({
    Query$topRatedTracksByArtist$personById? personById,
    String? $__typename,
  });
  CopyWith$Query$topRatedTracksByArtist$personById<TRes> get personById;
}

class _CopyWithImpl$Query$topRatedTracksByArtist<TRes>
    implements CopyWith$Query$topRatedTracksByArtist<TRes> {
  _CopyWithImpl$Query$topRatedTracksByArtist(this._instance, this._then);

  final Query$topRatedTracksByArtist _instance;

  final TRes Function(Query$topRatedTracksByArtist) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? personById = _undefined,
    Object? $__typename = _undefined,
  }) => _then(
    Query$topRatedTracksByArtist(
      personById: personById == _undefined
          ? _instance.personById
          : (personById as Query$topRatedTracksByArtist$personById?),
      $__typename: $__typename == _undefined || $__typename == null
          ? _instance.$__typename
          : ($__typename as String),
    ),
  );

  CopyWith$Query$topRatedTracksByArtist$personById<TRes> get personById {
    final local$personById = _instance.personById;
    return local$personById == null
        ? CopyWith$Query$topRatedTracksByArtist$personById.stub(
            _then(_instance),
          )
        : CopyWith$Query$topRatedTracksByArtist$personById(
            local$personById,
            (e) => call(personById: e),
          );
  }
}

class _CopyWithStubImpl$Query$topRatedTracksByArtist<TRes>
    implements CopyWith$Query$topRatedTracksByArtist<TRes> {
  _CopyWithStubImpl$Query$topRatedTracksByArtist(this._res);

  TRes _res;

  call({
    Query$topRatedTracksByArtist$personById? personById,
    String? $__typename,
  }) => _res;

  CopyWith$Query$topRatedTracksByArtist$personById<TRes> get personById =>
      CopyWith$Query$topRatedTracksByArtist$personById.stub(_res);
}

const documentNodeQuerytopRatedTracksByArtist = DocumentNode(
  definitions: [
    OperationDefinitionNode(
      type: OperationType.query,
      name: NameNode(value: 'topRatedTracksByArtist'),
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
                  name: NameNode(value: 'topRatedTracks'),
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

class Query$topRatedTracksByArtist$personById {
  Query$topRatedTracksByArtist$personById({
    required this.id,
    required this.topRatedTracks,
    this.$__typename = 'Person',
  });

  factory Query$topRatedTracksByArtist$personById.fromJson(
    Map<String, dynamic> json,
  ) {
    final l$id = json['id'];
    final l$topRatedTracks = json['topRatedTracks'];
    final l$$__typename = json['__typename'];
    return Query$topRatedTracksByArtist$personById(
      id: (l$id as String),
      topRatedTracks: (l$topRatedTracks as List<dynamic>)
          .map(
            (e) =>
                Query$topRatedTracksByArtist$personById$topRatedTracks.fromJson(
                  (e as Map<String, dynamic>),
                ),
          )
          .toList(),
      $__typename: (l$$__typename as String),
    );
  }

  final String id;

  final List<Query$topRatedTracksByArtist$personById$topRatedTracks>
  topRatedTracks;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$id = id;
    _resultData['id'] = l$id;
    final l$topRatedTracks = topRatedTracks;
    _resultData['topRatedTracks'] = l$topRatedTracks
        .map((e) => e.toJson())
        .toList();
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$id = id;
    final l$topRatedTracks = topRatedTracks;
    final l$$__typename = $__typename;
    return Object.hashAll([
      l$id,
      Object.hashAll(l$topRatedTracks.map((v) => v)),
      l$$__typename,
    ]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Query$topRatedTracksByArtist$personById ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$id = id;
    final lOther$id = other.id;
    if (l$id != lOther$id) {
      return false;
    }
    final l$topRatedTracks = topRatedTracks;
    final lOther$topRatedTracks = other.topRatedTracks;
    if (l$topRatedTracks.length != lOther$topRatedTracks.length) {
      return false;
    }
    for (int i = 0; i < l$topRatedTracks.length; i++) {
      final l$topRatedTracks$entry = l$topRatedTracks[i];
      final lOther$topRatedTracks$entry = lOther$topRatedTracks[i];
      if (l$topRatedTracks$entry != lOther$topRatedTracks$entry) {
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

extension UtilityExtension$Query$topRatedTracksByArtist$personById
    on Query$topRatedTracksByArtist$personById {
  CopyWith$Query$topRatedTracksByArtist$personById<
    Query$topRatedTracksByArtist$personById
  >
  get copyWith =>
      CopyWith$Query$topRatedTracksByArtist$personById(this, (i) => i);
}

abstract class CopyWith$Query$topRatedTracksByArtist$personById<TRes> {
  factory CopyWith$Query$topRatedTracksByArtist$personById(
    Query$topRatedTracksByArtist$personById instance,
    TRes Function(Query$topRatedTracksByArtist$personById) then,
  ) = _CopyWithImpl$Query$topRatedTracksByArtist$personById;

  factory CopyWith$Query$topRatedTracksByArtist$personById.stub(TRes res) =
      _CopyWithStubImpl$Query$topRatedTracksByArtist$personById;

  TRes call({
    String? id,
    List<Query$topRatedTracksByArtist$personById$topRatedTracks>?
    topRatedTracks,
    String? $__typename,
  });
  TRes topRatedTracks(
    Iterable<Query$topRatedTracksByArtist$personById$topRatedTracks> Function(
      Iterable<
        CopyWith$Query$topRatedTracksByArtist$personById$topRatedTracks<
          Query$topRatedTracksByArtist$personById$topRatedTracks
        >
      >,
    )
    _fn,
  );
}

class _CopyWithImpl$Query$topRatedTracksByArtist$personById<TRes>
    implements CopyWith$Query$topRatedTracksByArtist$personById<TRes> {
  _CopyWithImpl$Query$topRatedTracksByArtist$personById(
    this._instance,
    this._then,
  );

  final Query$topRatedTracksByArtist$personById _instance;

  final TRes Function(Query$topRatedTracksByArtist$personById) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? id = _undefined,
    Object? topRatedTracks = _undefined,
    Object? $__typename = _undefined,
  }) => _then(
    Query$topRatedTracksByArtist$personById(
      id: id == _undefined || id == null ? _instance.id : (id as String),
      topRatedTracks: topRatedTracks == _undefined || topRatedTracks == null
          ? _instance.topRatedTracks
          : (topRatedTracks
                as List<
                  Query$topRatedTracksByArtist$personById$topRatedTracks
                >),
      $__typename: $__typename == _undefined || $__typename == null
          ? _instance.$__typename
          : ($__typename as String),
    ),
  );

  TRes topRatedTracks(
    Iterable<Query$topRatedTracksByArtist$personById$topRatedTracks> Function(
      Iterable<
        CopyWith$Query$topRatedTracksByArtist$personById$topRatedTracks<
          Query$topRatedTracksByArtist$personById$topRatedTracks
        >
      >,
    )
    _fn,
  ) => call(
    topRatedTracks: _fn(
      _instance.topRatedTracks.map(
        (e) => CopyWith$Query$topRatedTracksByArtist$personById$topRatedTracks(
          e,
          (i) => i,
        ),
      ),
    ).toList(),
  );
}

class _CopyWithStubImpl$Query$topRatedTracksByArtist$personById<TRes>
    implements CopyWith$Query$topRatedTracksByArtist$personById<TRes> {
  _CopyWithStubImpl$Query$topRatedTracksByArtist$personById(this._res);

  TRes _res;

  call({
    String? id,
    List<Query$topRatedTracksByArtist$personById$topRatedTracks>?
    topRatedTracks,
    String? $__typename,
  }) => _res;

  topRatedTracks(_fn) => _res;
}

class Query$topRatedTracksByArtist$personById$topRatedTracks
    implements Fragment$fragmentTrack {
  Query$topRatedTracksByArtist$personById$topRatedTracks({
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

  factory Query$topRatedTracksByArtist$personById$topRatedTracks.fromJson(
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
    return Query$topRatedTracksByArtist$personById$topRatedTracks(
      id: (l$id as String),
      number: (l$number as int),
      discNumber: (l$discNumber as int),
      artist:
          Query$topRatedTracksByArtist$personById$topRatedTracks$artist.fromJson(
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
                Query$topRatedTracksByArtist$personById$topRatedTracks$mediaFile.fromJson(
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

  final Query$topRatedTracksByArtist$personById$topRatedTracks$artist artist;

  final List<Fragment$fragmentMetadata>? metadata;

  final List<Query$topRatedTracksByArtist$personById$topRatedTracks$mediaFile>?
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
    if (other is! Query$topRatedTracksByArtist$personById$topRatedTracks ||
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

extension UtilityExtension$Query$topRatedTracksByArtist$personById$topRatedTracks
    on Query$topRatedTracksByArtist$personById$topRatedTracks {
  CopyWith$Query$topRatedTracksByArtist$personById$topRatedTracks<
    Query$topRatedTracksByArtist$personById$topRatedTracks
  >
  get copyWith =>
      CopyWith$Query$topRatedTracksByArtist$personById$topRatedTracks(
        this,
        (i) => i,
      );
}

abstract class CopyWith$Query$topRatedTracksByArtist$personById$topRatedTracks<
  TRes
> {
  factory CopyWith$Query$topRatedTracksByArtist$personById$topRatedTracks(
    Query$topRatedTracksByArtist$personById$topRatedTracks instance,
    TRes Function(Query$topRatedTracksByArtist$personById$topRatedTracks) then,
  ) = _CopyWithImpl$Query$topRatedTracksByArtist$personById$topRatedTracks;

  factory CopyWith$Query$topRatedTracksByArtist$personById$topRatedTracks.stub(
    TRes res,
  ) = _CopyWithStubImpl$Query$topRatedTracksByArtist$personById$topRatedTracks;

  TRes call({
    String? id,
    int? number,
    int? discNumber,
    Query$topRatedTracksByArtist$personById$topRatedTracks$artist? artist,
    List<Fragment$fragmentMetadata>? metadata,
    List<Query$topRatedTracksByArtist$personById$topRatedTracks$mediaFile>?
    mediaFile,
    int? rating,
    String? $__typename,
    Fragment$fragmentAlbum? album,
  });
  CopyWith$Query$topRatedTracksByArtist$personById$topRatedTracks$artist<TRes>
  get artist;
  TRes metadata(
    Iterable<Fragment$fragmentMetadata>? Function(
      Iterable<CopyWith$Fragment$fragmentMetadata<Fragment$fragmentMetadata>>?,
    )
    _fn,
  );
  TRes mediaFile(
    Iterable<Query$topRatedTracksByArtist$personById$topRatedTracks$mediaFile>?
    Function(
      Iterable<
        CopyWith$Query$topRatedTracksByArtist$personById$topRatedTracks$mediaFile<
          Query$topRatedTracksByArtist$personById$topRatedTracks$mediaFile
        >
      >?,
    )
    _fn,
  );
  CopyWith$Fragment$fragmentAlbum<TRes> get album;
}

class _CopyWithImpl$Query$topRatedTracksByArtist$personById$topRatedTracks<TRes>
    implements
        CopyWith$Query$topRatedTracksByArtist$personById$topRatedTracks<TRes> {
  _CopyWithImpl$Query$topRatedTracksByArtist$personById$topRatedTracks(
    this._instance,
    this._then,
  );

  final Query$topRatedTracksByArtist$personById$topRatedTracks _instance;

  final TRes Function(Query$topRatedTracksByArtist$personById$topRatedTracks)
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
    Object? album = _undefined,
  }) => _then(
    Query$topRatedTracksByArtist$personById$topRatedTracks(
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
                as Query$topRatedTracksByArtist$personById$topRatedTracks$artist),
      metadata: metadata == _undefined
          ? _instance.metadata
          : (metadata as List<Fragment$fragmentMetadata>?),
      mediaFile: mediaFile == _undefined
          ? _instance.mediaFile
          : (mediaFile
                as List<
                  Query$topRatedTracksByArtist$personById$topRatedTracks$mediaFile
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

  CopyWith$Query$topRatedTracksByArtist$personById$topRatedTracks$artist<TRes>
  get artist {
    final local$artist = _instance.artist;
    return CopyWith$Query$topRatedTracksByArtist$personById$topRatedTracks$artist(
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
    Iterable<Query$topRatedTracksByArtist$personById$topRatedTracks$mediaFile>?
    Function(
      Iterable<
        CopyWith$Query$topRatedTracksByArtist$personById$topRatedTracks$mediaFile<
          Query$topRatedTracksByArtist$personById$topRatedTracks$mediaFile
        >
      >?,
    )
    _fn,
  ) => call(
    mediaFile: _fn(
      _instance.mediaFile?.map(
        (e) =>
            CopyWith$Query$topRatedTracksByArtist$personById$topRatedTracks$mediaFile(
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

class _CopyWithStubImpl$Query$topRatedTracksByArtist$personById$topRatedTracks<
  TRes
>
    implements
        CopyWith$Query$topRatedTracksByArtist$personById$topRatedTracks<TRes> {
  _CopyWithStubImpl$Query$topRatedTracksByArtist$personById$topRatedTracks(
    this._res,
  );

  TRes _res;

  call({
    String? id,
    int? number,
    int? discNumber,
    Query$topRatedTracksByArtist$personById$topRatedTracks$artist? artist,
    List<Fragment$fragmentMetadata>? metadata,
    List<Query$topRatedTracksByArtist$personById$topRatedTracks$mediaFile>?
    mediaFile,
    int? rating,
    String? $__typename,
    Fragment$fragmentAlbum? album,
  }) => _res;

  CopyWith$Query$topRatedTracksByArtist$personById$topRatedTracks$artist<TRes>
  get artist =>
      CopyWith$Query$topRatedTracksByArtist$personById$topRatedTracks$artist.stub(
        _res,
      );

  metadata(_fn) => _res;

  mediaFile(_fn) => _res;

  CopyWith$Fragment$fragmentAlbum<TRes> get album =>
      CopyWith$Fragment$fragmentAlbum.stub(_res);
}

class Query$topRatedTracksByArtist$personById$topRatedTracks$artist
    implements Fragment$fragmentTrack$artist {
  Query$topRatedTracksByArtist$personById$topRatedTracks$artist({
    required this.id,
    required this.name,
    this.$__typename = 'Person',
  });

  factory Query$topRatedTracksByArtist$personById$topRatedTracks$artist.fromJson(
    Map<String, dynamic> json,
  ) {
    final l$id = json['id'];
    final l$name = json['name'];
    final l$$__typename = json['__typename'];
    return Query$topRatedTracksByArtist$personById$topRatedTracks$artist(
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
            is! Query$topRatedTracksByArtist$personById$topRatedTracks$artist ||
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

extension UtilityExtension$Query$topRatedTracksByArtist$personById$topRatedTracks$artist
    on Query$topRatedTracksByArtist$personById$topRatedTracks$artist {
  CopyWith$Query$topRatedTracksByArtist$personById$topRatedTracks$artist<
    Query$topRatedTracksByArtist$personById$topRatedTracks$artist
  >
  get copyWith =>
      CopyWith$Query$topRatedTracksByArtist$personById$topRatedTracks$artist(
        this,
        (i) => i,
      );
}

abstract class CopyWith$Query$topRatedTracksByArtist$personById$topRatedTracks$artist<
  TRes
> {
  factory CopyWith$Query$topRatedTracksByArtist$personById$topRatedTracks$artist(
    Query$topRatedTracksByArtist$personById$topRatedTracks$artist instance,
    TRes Function(Query$topRatedTracksByArtist$personById$topRatedTracks$artist)
    then,
  ) = _CopyWithImpl$Query$topRatedTracksByArtist$personById$topRatedTracks$artist;

  factory CopyWith$Query$topRatedTracksByArtist$personById$topRatedTracks$artist.stub(
    TRes res,
  ) = _CopyWithStubImpl$Query$topRatedTracksByArtist$personById$topRatedTracks$artist;

  TRes call({String? id, String? name, String? $__typename});
}

class _CopyWithImpl$Query$topRatedTracksByArtist$personById$topRatedTracks$artist<
  TRes
>
    implements
        CopyWith$Query$topRatedTracksByArtist$personById$topRatedTracks$artist<
          TRes
        > {
  _CopyWithImpl$Query$topRatedTracksByArtist$personById$topRatedTracks$artist(
    this._instance,
    this._then,
  );

  final Query$topRatedTracksByArtist$personById$topRatedTracks$artist _instance;

  final TRes Function(
    Query$topRatedTracksByArtist$personById$topRatedTracks$artist,
  )
  _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? id = _undefined,
    Object? name = _undefined,
    Object? $__typename = _undefined,
  }) => _then(
    Query$topRatedTracksByArtist$personById$topRatedTracks$artist(
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

class _CopyWithStubImpl$Query$topRatedTracksByArtist$personById$topRatedTracks$artist<
  TRes
>
    implements
        CopyWith$Query$topRatedTracksByArtist$personById$topRatedTracks$artist<
          TRes
        > {
  _CopyWithStubImpl$Query$topRatedTracksByArtist$personById$topRatedTracks$artist(
    this._res,
  );

  TRes _res;

  call({String? id, String? name, String? $__typename}) => _res;
}

class Query$topRatedTracksByArtist$personById$topRatedTracks$mediaFile
    implements Fragment$fragmentTrack$mediaFile {
  Query$topRatedTracksByArtist$personById$topRatedTracks$mediaFile({
    this.durationInMilliseconds,
    this.$__typename = 'MediaFile',
  });

  factory Query$topRatedTracksByArtist$personById$topRatedTracks$mediaFile.fromJson(
    Map<String, dynamic> json,
  ) {
    final l$durationInMilliseconds = json['durationInMilliseconds'];
    final l$$__typename = json['__typename'];
    return Query$topRatedTracksByArtist$personById$topRatedTracks$mediaFile(
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
            is! Query$topRatedTracksByArtist$personById$topRatedTracks$mediaFile ||
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

extension UtilityExtension$Query$topRatedTracksByArtist$personById$topRatedTracks$mediaFile
    on Query$topRatedTracksByArtist$personById$topRatedTracks$mediaFile {
  CopyWith$Query$topRatedTracksByArtist$personById$topRatedTracks$mediaFile<
    Query$topRatedTracksByArtist$personById$topRatedTracks$mediaFile
  >
  get copyWith =>
      CopyWith$Query$topRatedTracksByArtist$personById$topRatedTracks$mediaFile(
        this,
        (i) => i,
      );
}

abstract class CopyWith$Query$topRatedTracksByArtist$personById$topRatedTracks$mediaFile<
  TRes
> {
  factory CopyWith$Query$topRatedTracksByArtist$personById$topRatedTracks$mediaFile(
    Query$topRatedTracksByArtist$personById$topRatedTracks$mediaFile instance,
    TRes Function(
      Query$topRatedTracksByArtist$personById$topRatedTracks$mediaFile,
    )
    then,
  ) = _CopyWithImpl$Query$topRatedTracksByArtist$personById$topRatedTracks$mediaFile;

  factory CopyWith$Query$topRatedTracksByArtist$personById$topRatedTracks$mediaFile.stub(
    TRes res,
  ) = _CopyWithStubImpl$Query$topRatedTracksByArtist$personById$topRatedTracks$mediaFile;

  TRes call({int? durationInMilliseconds, String? $__typename});
}

class _CopyWithImpl$Query$topRatedTracksByArtist$personById$topRatedTracks$mediaFile<
  TRes
>
    implements
        CopyWith$Query$topRatedTracksByArtist$personById$topRatedTracks$mediaFile<
          TRes
        > {
  _CopyWithImpl$Query$topRatedTracksByArtist$personById$topRatedTracks$mediaFile(
    this._instance,
    this._then,
  );

  final Query$topRatedTracksByArtist$personById$topRatedTracks$mediaFile
  _instance;

  final TRes Function(
    Query$topRatedTracksByArtist$personById$topRatedTracks$mediaFile,
  )
  _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? durationInMilliseconds = _undefined,
    Object? $__typename = _undefined,
  }) => _then(
    Query$topRatedTracksByArtist$personById$topRatedTracks$mediaFile(
      durationInMilliseconds: durationInMilliseconds == _undefined
          ? _instance.durationInMilliseconds
          : (durationInMilliseconds as int?),
      $__typename: $__typename == _undefined || $__typename == null
          ? _instance.$__typename
          : ($__typename as String),
    ),
  );
}

class _CopyWithStubImpl$Query$topRatedTracksByArtist$personById$topRatedTracks$mediaFile<
  TRes
>
    implements
        CopyWith$Query$topRatedTracksByArtist$personById$topRatedTracks$mediaFile<
          TRes
        > {
  _CopyWithStubImpl$Query$topRatedTracksByArtist$personById$topRatedTracks$mediaFile(
    this._res,
  );

  TRes _res;

  call({int? durationInMilliseconds, String? $__typename}) => _res;
}

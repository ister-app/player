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
  Query$recentlyAddedTracksByArtist({
    this.personById,
    this.$__typename = 'Query',
  });

  factory Query$recentlyAddedTracksByArtist.fromJson(
    Map<String, dynamic> json,
  ) {
    final l$personById = json['personById'];
    final l$$__typename = json['__typename'];
    return Query$recentlyAddedTracksByArtist(
      personById: l$personById == null
          ? null
          : Query$recentlyAddedTracksByArtist$personById.fromJson(
              (l$personById as Map<String, dynamic>),
            ),
      $__typename: (l$$__typename as String),
    );
  }

  final Query$recentlyAddedTracksByArtist$personById? personById;

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
    if (other is! Query$recentlyAddedTracksByArtist ||
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
    Query$recentlyAddedTracksByArtist$personById? personById,
    String? $__typename,
  });
  CopyWith$Query$recentlyAddedTracksByArtist$personById<TRes> get personById;
}

class _CopyWithImpl$Query$recentlyAddedTracksByArtist<TRes>
    implements CopyWith$Query$recentlyAddedTracksByArtist<TRes> {
  _CopyWithImpl$Query$recentlyAddedTracksByArtist(this._instance, this._then);

  final Query$recentlyAddedTracksByArtist _instance;

  final TRes Function(Query$recentlyAddedTracksByArtist) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? personById = _undefined,
    Object? $__typename = _undefined,
  }) => _then(
    Query$recentlyAddedTracksByArtist(
      personById: personById == _undefined
          ? _instance.personById
          : (personById as Query$recentlyAddedTracksByArtist$personById?),
      $__typename: $__typename == _undefined || $__typename == null
          ? _instance.$__typename
          : ($__typename as String),
    ),
  );

  CopyWith$Query$recentlyAddedTracksByArtist$personById<TRes> get personById {
    final local$personById = _instance.personById;
    return local$personById == null
        ? CopyWith$Query$recentlyAddedTracksByArtist$personById.stub(
            _then(_instance),
          )
        : CopyWith$Query$recentlyAddedTracksByArtist$personById(
            local$personById,
            (e) => call(personById: e),
          );
  }
}

class _CopyWithStubImpl$Query$recentlyAddedTracksByArtist<TRes>
    implements CopyWith$Query$recentlyAddedTracksByArtist<TRes> {
  _CopyWithStubImpl$Query$recentlyAddedTracksByArtist(this._res);

  TRes _res;

  call({
    Query$recentlyAddedTracksByArtist$personById? personById,
    String? $__typename,
  }) => _res;

  CopyWith$Query$recentlyAddedTracksByArtist$personById<TRes> get personById =>
      CopyWith$Query$recentlyAddedTracksByArtist$personById.stub(_res);
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
                  name: NameNode(value: 'recentlyAddedTracks'),
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
                        name: NameNode(value: 'dateAdded'),
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

class Query$recentlyAddedTracksByArtist$personById {
  Query$recentlyAddedTracksByArtist$personById({
    required this.id,
    required this.recentlyAddedTracks,
    this.$__typename = 'Person',
  });

  factory Query$recentlyAddedTracksByArtist$personById.fromJson(
    Map<String, dynamic> json,
  ) {
    final l$id = json['id'];
    final l$recentlyAddedTracks = json['recentlyAddedTracks'];
    final l$$__typename = json['__typename'];
    return Query$recentlyAddedTracksByArtist$personById(
      id: (l$id as String),
      recentlyAddedTracks: (l$recentlyAddedTracks as List<dynamic>)
          .map(
            (e) =>
                Query$recentlyAddedTracksByArtist$personById$recentlyAddedTracks.fromJson(
                  (e as Map<String, dynamic>),
                ),
          )
          .toList(),
      $__typename: (l$$__typename as String),
    );
  }

  final String id;

  final List<Query$recentlyAddedTracksByArtist$personById$recentlyAddedTracks>
  recentlyAddedTracks;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$id = id;
    _resultData['id'] = l$id;
    final l$recentlyAddedTracks = recentlyAddedTracks;
    _resultData['recentlyAddedTracks'] = l$recentlyAddedTracks
        .map((e) => e.toJson())
        .toList();
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$id = id;
    final l$recentlyAddedTracks = recentlyAddedTracks;
    final l$$__typename = $__typename;
    return Object.hashAll([
      l$id,
      Object.hashAll(l$recentlyAddedTracks.map((v) => v)),
      l$$__typename,
    ]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Query$recentlyAddedTracksByArtist$personById ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$id = id;
    final lOther$id = other.id;
    if (l$id != lOther$id) {
      return false;
    }
    final l$recentlyAddedTracks = recentlyAddedTracks;
    final lOther$recentlyAddedTracks = other.recentlyAddedTracks;
    if (l$recentlyAddedTracks.length != lOther$recentlyAddedTracks.length) {
      return false;
    }
    for (int i = 0; i < l$recentlyAddedTracks.length; i++) {
      final l$recentlyAddedTracks$entry = l$recentlyAddedTracks[i];
      final lOther$recentlyAddedTracks$entry = lOther$recentlyAddedTracks[i];
      if (l$recentlyAddedTracks$entry != lOther$recentlyAddedTracks$entry) {
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

extension UtilityExtension$Query$recentlyAddedTracksByArtist$personById
    on Query$recentlyAddedTracksByArtist$personById {
  CopyWith$Query$recentlyAddedTracksByArtist$personById<
    Query$recentlyAddedTracksByArtist$personById
  >
  get copyWith =>
      CopyWith$Query$recentlyAddedTracksByArtist$personById(this, (i) => i);
}

abstract class CopyWith$Query$recentlyAddedTracksByArtist$personById<TRes> {
  factory CopyWith$Query$recentlyAddedTracksByArtist$personById(
    Query$recentlyAddedTracksByArtist$personById instance,
    TRes Function(Query$recentlyAddedTracksByArtist$personById) then,
  ) = _CopyWithImpl$Query$recentlyAddedTracksByArtist$personById;

  factory CopyWith$Query$recentlyAddedTracksByArtist$personById.stub(TRes res) =
      _CopyWithStubImpl$Query$recentlyAddedTracksByArtist$personById;

  TRes call({
    String? id,
    List<Query$recentlyAddedTracksByArtist$personById$recentlyAddedTracks>?
    recentlyAddedTracks,
    String? $__typename,
  });
  TRes recentlyAddedTracks(
    Iterable<Query$recentlyAddedTracksByArtist$personById$recentlyAddedTracks>
    Function(
      Iterable<
        CopyWith$Query$recentlyAddedTracksByArtist$personById$recentlyAddedTracks<
          Query$recentlyAddedTracksByArtist$personById$recentlyAddedTracks
        >
      >,
    )
    _fn,
  );
}

class _CopyWithImpl$Query$recentlyAddedTracksByArtist$personById<TRes>
    implements CopyWith$Query$recentlyAddedTracksByArtist$personById<TRes> {
  _CopyWithImpl$Query$recentlyAddedTracksByArtist$personById(
    this._instance,
    this._then,
  );

  final Query$recentlyAddedTracksByArtist$personById _instance;

  final TRes Function(Query$recentlyAddedTracksByArtist$personById) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? id = _undefined,
    Object? recentlyAddedTracks = _undefined,
    Object? $__typename = _undefined,
  }) => _then(
    Query$recentlyAddedTracksByArtist$personById(
      id: id == _undefined || id == null ? _instance.id : (id as String),
      recentlyAddedTracks:
          recentlyAddedTracks == _undefined || recentlyAddedTracks == null
          ? _instance.recentlyAddedTracks
          : (recentlyAddedTracks
                as List<
                  Query$recentlyAddedTracksByArtist$personById$recentlyAddedTracks
                >),
      $__typename: $__typename == _undefined || $__typename == null
          ? _instance.$__typename
          : ($__typename as String),
    ),
  );

  TRes recentlyAddedTracks(
    Iterable<Query$recentlyAddedTracksByArtist$personById$recentlyAddedTracks>
    Function(
      Iterable<
        CopyWith$Query$recentlyAddedTracksByArtist$personById$recentlyAddedTracks<
          Query$recentlyAddedTracksByArtist$personById$recentlyAddedTracks
        >
      >,
    )
    _fn,
  ) => call(
    recentlyAddedTracks: _fn(
      _instance.recentlyAddedTracks.map(
        (e) =>
            CopyWith$Query$recentlyAddedTracksByArtist$personById$recentlyAddedTracks(
              e,
              (i) => i,
            ),
      ),
    ).toList(),
  );
}

class _CopyWithStubImpl$Query$recentlyAddedTracksByArtist$personById<TRes>
    implements CopyWith$Query$recentlyAddedTracksByArtist$personById<TRes> {
  _CopyWithStubImpl$Query$recentlyAddedTracksByArtist$personById(this._res);

  TRes _res;

  call({
    String? id,
    List<Query$recentlyAddedTracksByArtist$personById$recentlyAddedTracks>?
    recentlyAddedTracks,
    String? $__typename,
  }) => _res;

  recentlyAddedTracks(_fn) => _res;
}

class Query$recentlyAddedTracksByArtist$personById$recentlyAddedTracks
    implements Fragment$fragmentTrack {
  Query$recentlyAddedTracksByArtist$personById$recentlyAddedTracks({
    required this.id,
    required this.number,
    required this.discNumber,
    required this.artist,
    this.metadata,
    this.mediaFile,
    this.rating,
    this.$__typename = 'Track',
    this.dateAdded,
    required this.album,
  });

  factory Query$recentlyAddedTracksByArtist$personById$recentlyAddedTracks.fromJson(
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
    final l$dateAdded = json['dateAdded'];
    final l$album = json['album'];
    return Query$recentlyAddedTracksByArtist$personById$recentlyAddedTracks(
      id: (l$id as String),
      number: (l$number as int),
      discNumber: (l$discNumber as int),
      artist:
          Query$recentlyAddedTracksByArtist$personById$recentlyAddedTracks$artist.fromJson(
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
                Query$recentlyAddedTracksByArtist$personById$recentlyAddedTracks$mediaFile.fromJson(
                  (e as Map<String, dynamic>),
                ),
          )
          .toList(),
      rating: (l$rating as int?),
      $__typename: (l$$__typename as String),
      dateAdded: (l$dateAdded as String?),
      album: Fragment$fragmentAlbum.fromJson((l$album as Map<String, dynamic>)),
    );
  }

  final String id;

  final int number;

  final int discNumber;

  final Query$recentlyAddedTracksByArtist$personById$recentlyAddedTracks$artist
  artist;

  final List<Fragment$fragmentMetadata>? metadata;

  final List<
    Query$recentlyAddedTracksByArtist$personById$recentlyAddedTracks$mediaFile
  >?
  mediaFile;

  final int? rating;

  final String $__typename;

  final String? dateAdded;

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
    final l$dateAdded = dateAdded;
    _resultData['dateAdded'] = l$dateAdded;
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
    final l$dateAdded = dateAdded;
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
      l$dateAdded,
      l$album,
    ]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other
            is! Query$recentlyAddedTracksByArtist$personById$recentlyAddedTracks ||
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
    final l$dateAdded = dateAdded;
    final lOther$dateAdded = other.dateAdded;
    if (l$dateAdded != lOther$dateAdded) {
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

extension UtilityExtension$Query$recentlyAddedTracksByArtist$personById$recentlyAddedTracks
    on Query$recentlyAddedTracksByArtist$personById$recentlyAddedTracks {
  CopyWith$Query$recentlyAddedTracksByArtist$personById$recentlyAddedTracks<
    Query$recentlyAddedTracksByArtist$personById$recentlyAddedTracks
  >
  get copyWith =>
      CopyWith$Query$recentlyAddedTracksByArtist$personById$recentlyAddedTracks(
        this,
        (i) => i,
      );
}

abstract class CopyWith$Query$recentlyAddedTracksByArtist$personById$recentlyAddedTracks<
  TRes
> {
  factory CopyWith$Query$recentlyAddedTracksByArtist$personById$recentlyAddedTracks(
    Query$recentlyAddedTracksByArtist$personById$recentlyAddedTracks instance,
    TRes Function(
      Query$recentlyAddedTracksByArtist$personById$recentlyAddedTracks,
    )
    then,
  ) = _CopyWithImpl$Query$recentlyAddedTracksByArtist$personById$recentlyAddedTracks;

  factory CopyWith$Query$recentlyAddedTracksByArtist$personById$recentlyAddedTracks.stub(
    TRes res,
  ) = _CopyWithStubImpl$Query$recentlyAddedTracksByArtist$personById$recentlyAddedTracks;

  TRes call({
    String? id,
    int? number,
    int? discNumber,
    Query$recentlyAddedTracksByArtist$personById$recentlyAddedTracks$artist?
    artist,
    List<Fragment$fragmentMetadata>? metadata,
    List<
      Query$recentlyAddedTracksByArtist$personById$recentlyAddedTracks$mediaFile
    >?
    mediaFile,
    int? rating,
    String? $__typename,
    String? dateAdded,
    Fragment$fragmentAlbum? album,
  });
  CopyWith$Query$recentlyAddedTracksByArtist$personById$recentlyAddedTracks$artist<
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
      Query$recentlyAddedTracksByArtist$personById$recentlyAddedTracks$mediaFile
    >?
    Function(
      Iterable<
        CopyWith$Query$recentlyAddedTracksByArtist$personById$recentlyAddedTracks$mediaFile<
          Query$recentlyAddedTracksByArtist$personById$recentlyAddedTracks$mediaFile
        >
      >?,
    )
    _fn,
  );
  CopyWith$Fragment$fragmentAlbum<TRes> get album;
}

class _CopyWithImpl$Query$recentlyAddedTracksByArtist$personById$recentlyAddedTracks<
  TRes
>
    implements
        CopyWith$Query$recentlyAddedTracksByArtist$personById$recentlyAddedTracks<
          TRes
        > {
  _CopyWithImpl$Query$recentlyAddedTracksByArtist$personById$recentlyAddedTracks(
    this._instance,
    this._then,
  );

  final Query$recentlyAddedTracksByArtist$personById$recentlyAddedTracks
  _instance;

  final TRes Function(
    Query$recentlyAddedTracksByArtist$personById$recentlyAddedTracks,
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
    Object? dateAdded = _undefined,
    Object? album = _undefined,
  }) => _then(
    Query$recentlyAddedTracksByArtist$personById$recentlyAddedTracks(
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
                as Query$recentlyAddedTracksByArtist$personById$recentlyAddedTracks$artist),
      metadata: metadata == _undefined
          ? _instance.metadata
          : (metadata as List<Fragment$fragmentMetadata>?),
      mediaFile: mediaFile == _undefined
          ? _instance.mediaFile
          : (mediaFile
                as List<
                  Query$recentlyAddedTracksByArtist$personById$recentlyAddedTracks$mediaFile
                >?),
      rating: rating == _undefined ? _instance.rating : (rating as int?),
      $__typename: $__typename == _undefined || $__typename == null
          ? _instance.$__typename
          : ($__typename as String),
      dateAdded: dateAdded == _undefined
          ? _instance.dateAdded
          : (dateAdded as String?),
      album: album == _undefined || album == null
          ? _instance.album
          : (album as Fragment$fragmentAlbum),
    ),
  );

  CopyWith$Query$recentlyAddedTracksByArtist$personById$recentlyAddedTracks$artist<
    TRes
  >
  get artist {
    final local$artist = _instance.artist;
    return CopyWith$Query$recentlyAddedTracksByArtist$personById$recentlyAddedTracks$artist(
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
      Query$recentlyAddedTracksByArtist$personById$recentlyAddedTracks$mediaFile
    >?
    Function(
      Iterable<
        CopyWith$Query$recentlyAddedTracksByArtist$personById$recentlyAddedTracks$mediaFile<
          Query$recentlyAddedTracksByArtist$personById$recentlyAddedTracks$mediaFile
        >
      >?,
    )
    _fn,
  ) => call(
    mediaFile: _fn(
      _instance.mediaFile?.map(
        (e) =>
            CopyWith$Query$recentlyAddedTracksByArtist$personById$recentlyAddedTracks$mediaFile(
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

class _CopyWithStubImpl$Query$recentlyAddedTracksByArtist$personById$recentlyAddedTracks<
  TRes
>
    implements
        CopyWith$Query$recentlyAddedTracksByArtist$personById$recentlyAddedTracks<
          TRes
        > {
  _CopyWithStubImpl$Query$recentlyAddedTracksByArtist$personById$recentlyAddedTracks(
    this._res,
  );

  TRes _res;

  call({
    String? id,
    int? number,
    int? discNumber,
    Query$recentlyAddedTracksByArtist$personById$recentlyAddedTracks$artist?
    artist,
    List<Fragment$fragmentMetadata>? metadata,
    List<
      Query$recentlyAddedTracksByArtist$personById$recentlyAddedTracks$mediaFile
    >?
    mediaFile,
    int? rating,
    String? $__typename,
    String? dateAdded,
    Fragment$fragmentAlbum? album,
  }) => _res;

  CopyWith$Query$recentlyAddedTracksByArtist$personById$recentlyAddedTracks$artist<
    TRes
  >
  get artist =>
      CopyWith$Query$recentlyAddedTracksByArtist$personById$recentlyAddedTracks$artist.stub(
        _res,
      );

  metadata(_fn) => _res;

  mediaFile(_fn) => _res;

  CopyWith$Fragment$fragmentAlbum<TRes> get album =>
      CopyWith$Fragment$fragmentAlbum.stub(_res);
}

class Query$recentlyAddedTracksByArtist$personById$recentlyAddedTracks$artist
    implements Fragment$fragmentTrack$artist {
  Query$recentlyAddedTracksByArtist$personById$recentlyAddedTracks$artist({
    required this.id,
    required this.name,
    this.$__typename = 'Person',
  });

  factory Query$recentlyAddedTracksByArtist$personById$recentlyAddedTracks$artist.fromJson(
    Map<String, dynamic> json,
  ) {
    final l$id = json['id'];
    final l$name = json['name'];
    final l$$__typename = json['__typename'];
    return Query$recentlyAddedTracksByArtist$personById$recentlyAddedTracks$artist(
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
            is! Query$recentlyAddedTracksByArtist$personById$recentlyAddedTracks$artist ||
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

extension UtilityExtension$Query$recentlyAddedTracksByArtist$personById$recentlyAddedTracks$artist
    on Query$recentlyAddedTracksByArtist$personById$recentlyAddedTracks$artist {
  CopyWith$Query$recentlyAddedTracksByArtist$personById$recentlyAddedTracks$artist<
    Query$recentlyAddedTracksByArtist$personById$recentlyAddedTracks$artist
  >
  get copyWith =>
      CopyWith$Query$recentlyAddedTracksByArtist$personById$recentlyAddedTracks$artist(
        this,
        (i) => i,
      );
}

abstract class CopyWith$Query$recentlyAddedTracksByArtist$personById$recentlyAddedTracks$artist<
  TRes
> {
  factory CopyWith$Query$recentlyAddedTracksByArtist$personById$recentlyAddedTracks$artist(
    Query$recentlyAddedTracksByArtist$personById$recentlyAddedTracks$artist
    instance,
    TRes Function(
      Query$recentlyAddedTracksByArtist$personById$recentlyAddedTracks$artist,
    )
    then,
  ) = _CopyWithImpl$Query$recentlyAddedTracksByArtist$personById$recentlyAddedTracks$artist;

  factory CopyWith$Query$recentlyAddedTracksByArtist$personById$recentlyAddedTracks$artist.stub(
    TRes res,
  ) = _CopyWithStubImpl$Query$recentlyAddedTracksByArtist$personById$recentlyAddedTracks$artist;

  TRes call({String? id, String? name, String? $__typename});
}

class _CopyWithImpl$Query$recentlyAddedTracksByArtist$personById$recentlyAddedTracks$artist<
  TRes
>
    implements
        CopyWith$Query$recentlyAddedTracksByArtist$personById$recentlyAddedTracks$artist<
          TRes
        > {
  _CopyWithImpl$Query$recentlyAddedTracksByArtist$personById$recentlyAddedTracks$artist(
    this._instance,
    this._then,
  );

  final Query$recentlyAddedTracksByArtist$personById$recentlyAddedTracks$artist
  _instance;

  final TRes Function(
    Query$recentlyAddedTracksByArtist$personById$recentlyAddedTracks$artist,
  )
  _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? id = _undefined,
    Object? name = _undefined,
    Object? $__typename = _undefined,
  }) => _then(
    Query$recentlyAddedTracksByArtist$personById$recentlyAddedTracks$artist(
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

class _CopyWithStubImpl$Query$recentlyAddedTracksByArtist$personById$recentlyAddedTracks$artist<
  TRes
>
    implements
        CopyWith$Query$recentlyAddedTracksByArtist$personById$recentlyAddedTracks$artist<
          TRes
        > {
  _CopyWithStubImpl$Query$recentlyAddedTracksByArtist$personById$recentlyAddedTracks$artist(
    this._res,
  );

  TRes _res;

  call({String? id, String? name, String? $__typename}) => _res;
}

class Query$recentlyAddedTracksByArtist$personById$recentlyAddedTracks$mediaFile
    implements Fragment$fragmentTrack$mediaFile {
  Query$recentlyAddedTracksByArtist$personById$recentlyAddedTracks$mediaFile({
    this.durationInMilliseconds,
    this.$__typename = 'MediaFile',
  });

  factory Query$recentlyAddedTracksByArtist$personById$recentlyAddedTracks$mediaFile.fromJson(
    Map<String, dynamic> json,
  ) {
    final l$durationInMilliseconds = json['durationInMilliseconds'];
    final l$$__typename = json['__typename'];
    return Query$recentlyAddedTracksByArtist$personById$recentlyAddedTracks$mediaFile(
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
            is! Query$recentlyAddedTracksByArtist$personById$recentlyAddedTracks$mediaFile ||
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

extension UtilityExtension$Query$recentlyAddedTracksByArtist$personById$recentlyAddedTracks$mediaFile
    on Query$recentlyAddedTracksByArtist$personById$recentlyAddedTracks$mediaFile {
  CopyWith$Query$recentlyAddedTracksByArtist$personById$recentlyAddedTracks$mediaFile<
    Query$recentlyAddedTracksByArtist$personById$recentlyAddedTracks$mediaFile
  >
  get copyWith =>
      CopyWith$Query$recentlyAddedTracksByArtist$personById$recentlyAddedTracks$mediaFile(
        this,
        (i) => i,
      );
}

abstract class CopyWith$Query$recentlyAddedTracksByArtist$personById$recentlyAddedTracks$mediaFile<
  TRes
> {
  factory CopyWith$Query$recentlyAddedTracksByArtist$personById$recentlyAddedTracks$mediaFile(
    Query$recentlyAddedTracksByArtist$personById$recentlyAddedTracks$mediaFile
    instance,
    TRes Function(
      Query$recentlyAddedTracksByArtist$personById$recentlyAddedTracks$mediaFile,
    )
    then,
  ) = _CopyWithImpl$Query$recentlyAddedTracksByArtist$personById$recentlyAddedTracks$mediaFile;

  factory CopyWith$Query$recentlyAddedTracksByArtist$personById$recentlyAddedTracks$mediaFile.stub(
    TRes res,
  ) = _CopyWithStubImpl$Query$recentlyAddedTracksByArtist$personById$recentlyAddedTracks$mediaFile;

  TRes call({int? durationInMilliseconds, String? $__typename});
}

class _CopyWithImpl$Query$recentlyAddedTracksByArtist$personById$recentlyAddedTracks$mediaFile<
  TRes
>
    implements
        CopyWith$Query$recentlyAddedTracksByArtist$personById$recentlyAddedTracks$mediaFile<
          TRes
        > {
  _CopyWithImpl$Query$recentlyAddedTracksByArtist$personById$recentlyAddedTracks$mediaFile(
    this._instance,
    this._then,
  );

  final Query$recentlyAddedTracksByArtist$personById$recentlyAddedTracks$mediaFile
  _instance;

  final TRes Function(
    Query$recentlyAddedTracksByArtist$personById$recentlyAddedTracks$mediaFile,
  )
  _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? durationInMilliseconds = _undefined,
    Object? $__typename = _undefined,
  }) => _then(
    Query$recentlyAddedTracksByArtist$personById$recentlyAddedTracks$mediaFile(
      durationInMilliseconds: durationInMilliseconds == _undefined
          ? _instance.durationInMilliseconds
          : (durationInMilliseconds as int?),
      $__typename: $__typename == _undefined || $__typename == null
          ? _instance.$__typename
          : ($__typename as String),
    ),
  );
}

class _CopyWithStubImpl$Query$recentlyAddedTracksByArtist$personById$recentlyAddedTracks$mediaFile<
  TRes
>
    implements
        CopyWith$Query$recentlyAddedTracksByArtist$personById$recentlyAddedTracks$mediaFile<
          TRes
        > {
  _CopyWithStubImpl$Query$recentlyAddedTracksByArtist$personById$recentlyAddedTracks$mediaFile(
    this._res,
  );

  TRes _res;

  call({int? durationInMilliseconds, String? $__typename}) => _res;
}

import 'fragmentAlbum.graphql.dart';
import 'fragmentImages.graphql.dart';
import 'fragmentMetadata.graphql.dart';
import 'fragmentTrack.graphql.dart';
import 'package:gql/ast.dart';

class Variables$Query$albumById {
  factory Variables$Query$albumById({String? id}) =>
      Variables$Query$albumById._({if (id != null) r'id': id});

  Variables$Query$albumById._(this._$data);

  factory Variables$Query$albumById.fromJson(Map<String, dynamic> data) {
    final result$data = <String, dynamic>{};
    if (data.containsKey('id')) {
      final l$id = data['id'];
      result$data['id'] = (l$id as String?);
    }
    return Variables$Query$albumById._(result$data);
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

  CopyWith$Variables$Query$albumById<Variables$Query$albumById> get copyWith =>
      CopyWith$Variables$Query$albumById(this, (i) => i);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Variables$Query$albumById ||
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

abstract class CopyWith$Variables$Query$albumById<TRes> {
  factory CopyWith$Variables$Query$albumById(
    Variables$Query$albumById instance,
    TRes Function(Variables$Query$albumById) then,
  ) = _CopyWithImpl$Variables$Query$albumById;

  factory CopyWith$Variables$Query$albumById.stub(TRes res) =
      _CopyWithStubImpl$Variables$Query$albumById;

  TRes call({String? id});
}

class _CopyWithImpl$Variables$Query$albumById<TRes>
    implements CopyWith$Variables$Query$albumById<TRes> {
  _CopyWithImpl$Variables$Query$albumById(this._instance, this._then);

  final Variables$Query$albumById _instance;

  final TRes Function(Variables$Query$albumById) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({Object? id = _undefined}) => _then(
    Variables$Query$albumById._({
      ..._instance._$data,
      if (id != _undefined) 'id': (id as String?),
    }),
  );
}

class _CopyWithStubImpl$Variables$Query$albumById<TRes>
    implements CopyWith$Variables$Query$albumById<TRes> {
  _CopyWithStubImpl$Variables$Query$albumById(this._res);

  TRes _res;

  call({String? id}) => _res;
}

class Query$albumById {
  Query$albumById({this.albumById, this.$__typename = 'Query'});

  factory Query$albumById.fromJson(Map<String, dynamic> json) {
    final l$albumById = json['albumById'];
    final l$$__typename = json['__typename'];
    return Query$albumById(
      albumById: l$albumById == null
          ? null
          : Query$albumById$albumById.fromJson(
              (l$albumById as Map<String, dynamic>),
            ),
      $__typename: (l$$__typename as String),
    );
  }

  final Query$albumById$albumById? albumById;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$albumById = albumById;
    _resultData['albumById'] = l$albumById?.toJson();
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$albumById = albumById;
    final l$$__typename = $__typename;
    return Object.hashAll([l$albumById, l$$__typename]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Query$albumById || runtimeType != other.runtimeType) {
      return false;
    }
    final l$albumById = albumById;
    final lOther$albumById = other.albumById;
    if (l$albumById != lOther$albumById) {
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

extension UtilityExtension$Query$albumById on Query$albumById {
  CopyWith$Query$albumById<Query$albumById> get copyWith =>
      CopyWith$Query$albumById(this, (i) => i);
}

abstract class CopyWith$Query$albumById<TRes> {
  factory CopyWith$Query$albumById(
    Query$albumById instance,
    TRes Function(Query$albumById) then,
  ) = _CopyWithImpl$Query$albumById;

  factory CopyWith$Query$albumById.stub(TRes res) =
      _CopyWithStubImpl$Query$albumById;

  TRes call({Query$albumById$albumById? albumById, String? $__typename});
  CopyWith$Query$albumById$albumById<TRes> get albumById;
}

class _CopyWithImpl$Query$albumById<TRes>
    implements CopyWith$Query$albumById<TRes> {
  _CopyWithImpl$Query$albumById(this._instance, this._then);

  final Query$albumById _instance;

  final TRes Function(Query$albumById) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? albumById = _undefined,
    Object? $__typename = _undefined,
  }) => _then(
    Query$albumById(
      albumById: albumById == _undefined
          ? _instance.albumById
          : (albumById as Query$albumById$albumById?),
      $__typename: $__typename == _undefined || $__typename == null
          ? _instance.$__typename
          : ($__typename as String),
    ),
  );

  CopyWith$Query$albumById$albumById<TRes> get albumById {
    final local$albumById = _instance.albumById;
    return local$albumById == null
        ? CopyWith$Query$albumById$albumById.stub(_then(_instance))
        : CopyWith$Query$albumById$albumById(
            local$albumById,
            (e) => call(albumById: e),
          );
  }
}

class _CopyWithStubImpl$Query$albumById<TRes>
    implements CopyWith$Query$albumById<TRes> {
  _CopyWithStubImpl$Query$albumById(this._res);

  TRes _res;

  call({Query$albumById$albumById? albumById, String? $__typename}) => _res;

  CopyWith$Query$albumById$albumById<TRes> get albumById =>
      CopyWith$Query$albumById$albumById.stub(_res);
}

const documentNodeQueryalbumById = DocumentNode(
  definitions: [
    OperationDefinitionNode(
      type: OperationType.query,
      name: NameNode(value: 'albumById'),
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
            name: NameNode(value: 'albumById'),
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
                FragmentSpreadNode(
                  name: NameNode(value: 'fragmentAlbum'),
                  directives: [],
                ),
                FieldNode(
                  name: NameNode(value: 'tracks'),
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
    fragmentDefinitionfragmentAlbum,
    fragmentDefinitionfragmentImages,
    fragmentDefinitionfragmentMetadata,
    fragmentDefinitionfragmentTrack,
  ],
);

class Query$albumById$albumById implements Fragment$fragmentAlbum {
  Query$albumById$albumById({
    required this.id,
    required this.name,
    required this.releaseYear,
    required this.artist,
    this.images,
    this.metadata,
    this.$__typename = 'Album',
    this.tracks,
  });

  factory Query$albumById$albumById.fromJson(Map<String, dynamic> json) {
    final l$id = json['id'];
    final l$name = json['name'];
    final l$releaseYear = json['releaseYear'];
    final l$artist = json['artist'];
    final l$images = json['images'];
    final l$metadata = json['metadata'];
    final l$$__typename = json['__typename'];
    final l$tracks = json['tracks'];
    return Query$albumById$albumById(
      id: (l$id as String),
      name: (l$name as String),
      releaseYear: (l$releaseYear as int),
      artist: Query$albumById$albumById$artist.fromJson(
        (l$artist as Map<String, dynamic>),
      ),
      images: (l$images as List<dynamic>?)
          ?.map(
            (e) =>
                Fragment$fragmentImages.fromJson((e as Map<String, dynamic>)),
          )
          .toList(),
      metadata: (l$metadata as List<dynamic>?)
          ?.map(
            (e) =>
                Fragment$fragmentMetadata.fromJson((e as Map<String, dynamic>)),
          )
          .toList(),
      $__typename: (l$$__typename as String),
      tracks: (l$tracks as List<dynamic>?)
          ?.map(
            (e) => Fragment$fragmentTrack.fromJson((e as Map<String, dynamic>)),
          )
          .toList(),
    );
  }

  final String id;

  final String name;

  final int releaseYear;

  final Query$albumById$albumById$artist artist;

  final List<Fragment$fragmentImages>? images;

  final List<Fragment$fragmentMetadata>? metadata;

  final String $__typename;

  final List<Fragment$fragmentTrack>? tracks;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$id = id;
    _resultData['id'] = l$id;
    final l$name = name;
    _resultData['name'] = l$name;
    final l$releaseYear = releaseYear;
    _resultData['releaseYear'] = l$releaseYear;
    final l$artist = artist;
    _resultData['artist'] = l$artist.toJson();
    final l$images = images;
    _resultData['images'] = l$images?.map((e) => e.toJson()).toList();
    final l$metadata = metadata;
    _resultData['metadata'] = l$metadata?.map((e) => e.toJson()).toList();
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    final l$tracks = tracks;
    _resultData['tracks'] = l$tracks?.map((e) => e.toJson()).toList();
    return _resultData;
  }

  @override
  int get hashCode {
    final l$id = id;
    final l$name = name;
    final l$releaseYear = releaseYear;
    final l$artist = artist;
    final l$images = images;
    final l$metadata = metadata;
    final l$$__typename = $__typename;
    final l$tracks = tracks;
    return Object.hashAll([
      l$id,
      l$name,
      l$releaseYear,
      l$artist,
      l$images == null ? null : Object.hashAll(l$images.map((v) => v)),
      l$metadata == null ? null : Object.hashAll(l$metadata.map((v) => v)),
      l$$__typename,
      l$tracks == null ? null : Object.hashAll(l$tracks.map((v) => v)),
    ]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Query$albumById$albumById ||
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
    final l$releaseYear = releaseYear;
    final lOther$releaseYear = other.releaseYear;
    if (l$releaseYear != lOther$releaseYear) {
      return false;
    }
    final l$artist = artist;
    final lOther$artist = other.artist;
    if (l$artist != lOther$artist) {
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
    final l$$__typename = $__typename;
    final lOther$$__typename = other.$__typename;
    if (l$$__typename != lOther$$__typename) {
      return false;
    }
    final l$tracks = tracks;
    final lOther$tracks = other.tracks;
    if (l$tracks != null && lOther$tracks != null) {
      if (l$tracks.length != lOther$tracks.length) {
        return false;
      }
      for (int i = 0; i < l$tracks.length; i++) {
        final l$tracks$entry = l$tracks[i];
        final lOther$tracks$entry = lOther$tracks[i];
        if (l$tracks$entry != lOther$tracks$entry) {
          return false;
        }
      }
    } else if (l$tracks != lOther$tracks) {
      return false;
    }
    return true;
  }
}

extension UtilityExtension$Query$albumById$albumById
    on Query$albumById$albumById {
  CopyWith$Query$albumById$albumById<Query$albumById$albumById> get copyWith =>
      CopyWith$Query$albumById$albumById(this, (i) => i);
}

abstract class CopyWith$Query$albumById$albumById<TRes> {
  factory CopyWith$Query$albumById$albumById(
    Query$albumById$albumById instance,
    TRes Function(Query$albumById$albumById) then,
  ) = _CopyWithImpl$Query$albumById$albumById;

  factory CopyWith$Query$albumById$albumById.stub(TRes res) =
      _CopyWithStubImpl$Query$albumById$albumById;

  TRes call({
    String? id,
    String? name,
    int? releaseYear,
    Query$albumById$albumById$artist? artist,
    List<Fragment$fragmentImages>? images,
    List<Fragment$fragmentMetadata>? metadata,
    String? $__typename,
    List<Fragment$fragmentTrack>? tracks,
  });
  CopyWith$Query$albumById$albumById$artist<TRes> get artist;
  TRes images(
    Iterable<Fragment$fragmentImages>? Function(
      Iterable<CopyWith$Fragment$fragmentImages<Fragment$fragmentImages>>?,
    )
    _fn,
  );
  TRes metadata(
    Iterable<Fragment$fragmentMetadata>? Function(
      Iterable<CopyWith$Fragment$fragmentMetadata<Fragment$fragmentMetadata>>?,
    )
    _fn,
  );
  TRes tracks(
    Iterable<Fragment$fragmentTrack>? Function(
      Iterable<CopyWith$Fragment$fragmentTrack<Fragment$fragmentTrack>>?,
    )
    _fn,
  );
}

class _CopyWithImpl$Query$albumById$albumById<TRes>
    implements CopyWith$Query$albumById$albumById<TRes> {
  _CopyWithImpl$Query$albumById$albumById(this._instance, this._then);

  final Query$albumById$albumById _instance;

  final TRes Function(Query$albumById$albumById) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? id = _undefined,
    Object? name = _undefined,
    Object? releaseYear = _undefined,
    Object? artist = _undefined,
    Object? images = _undefined,
    Object? metadata = _undefined,
    Object? $__typename = _undefined,
    Object? tracks = _undefined,
  }) => _then(
    Query$albumById$albumById(
      id: id == _undefined || id == null ? _instance.id : (id as String),
      name: name == _undefined || name == null
          ? _instance.name
          : (name as String),
      releaseYear: releaseYear == _undefined || releaseYear == null
          ? _instance.releaseYear
          : (releaseYear as int),
      artist: artist == _undefined || artist == null
          ? _instance.artist
          : (artist as Query$albumById$albumById$artist),
      images: images == _undefined
          ? _instance.images
          : (images as List<Fragment$fragmentImages>?),
      metadata: metadata == _undefined
          ? _instance.metadata
          : (metadata as List<Fragment$fragmentMetadata>?),
      $__typename: $__typename == _undefined || $__typename == null
          ? _instance.$__typename
          : ($__typename as String),
      tracks: tracks == _undefined
          ? _instance.tracks
          : (tracks as List<Fragment$fragmentTrack>?),
    ),
  );

  CopyWith$Query$albumById$albumById$artist<TRes> get artist {
    final local$artist = _instance.artist;
    return CopyWith$Query$albumById$albumById$artist(
      local$artist,
      (e) => call(artist: e),
    );
  }

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

  TRes tracks(
    Iterable<Fragment$fragmentTrack>? Function(
      Iterable<CopyWith$Fragment$fragmentTrack<Fragment$fragmentTrack>>?,
    )
    _fn,
  ) => call(
    tracks: _fn(
      _instance.tracks?.map(
        (e) => CopyWith$Fragment$fragmentTrack(e, (i) => i),
      ),
    )?.toList(),
  );
}

class _CopyWithStubImpl$Query$albumById$albumById<TRes>
    implements CopyWith$Query$albumById$albumById<TRes> {
  _CopyWithStubImpl$Query$albumById$albumById(this._res);

  TRes _res;

  call({
    String? id,
    String? name,
    int? releaseYear,
    Query$albumById$albumById$artist? artist,
    List<Fragment$fragmentImages>? images,
    List<Fragment$fragmentMetadata>? metadata,
    String? $__typename,
    List<Fragment$fragmentTrack>? tracks,
  }) => _res;

  CopyWith$Query$albumById$albumById$artist<TRes> get artist =>
      CopyWith$Query$albumById$albumById$artist.stub(_res);

  images(_fn) => _res;

  metadata(_fn) => _res;

  tracks(_fn) => _res;
}

class Query$albumById$albumById$artist
    implements Fragment$fragmentAlbum$artist {
  Query$albumById$albumById$artist({
    required this.id,
    required this.name,
    this.$__typename = 'Artist',
  });

  factory Query$albumById$albumById$artist.fromJson(Map<String, dynamic> json) {
    final l$id = json['id'];
    final l$name = json['name'];
    final l$$__typename = json['__typename'];
    return Query$albumById$albumById$artist(
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
    if (other is! Query$albumById$albumById$artist ||
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

extension UtilityExtension$Query$albumById$albumById$artist
    on Query$albumById$albumById$artist {
  CopyWith$Query$albumById$albumById$artist<Query$albumById$albumById$artist>
  get copyWith => CopyWith$Query$albumById$albumById$artist(this, (i) => i);
}

abstract class CopyWith$Query$albumById$albumById$artist<TRes> {
  factory CopyWith$Query$albumById$albumById$artist(
    Query$albumById$albumById$artist instance,
    TRes Function(Query$albumById$albumById$artist) then,
  ) = _CopyWithImpl$Query$albumById$albumById$artist;

  factory CopyWith$Query$albumById$albumById$artist.stub(TRes res) =
      _CopyWithStubImpl$Query$albumById$albumById$artist;

  TRes call({String? id, String? name, String? $__typename});
}

class _CopyWithImpl$Query$albumById$albumById$artist<TRes>
    implements CopyWith$Query$albumById$albumById$artist<TRes> {
  _CopyWithImpl$Query$albumById$albumById$artist(this._instance, this._then);

  final Query$albumById$albumById$artist _instance;

  final TRes Function(Query$albumById$albumById$artist) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? id = _undefined,
    Object? name = _undefined,
    Object? $__typename = _undefined,
  }) => _then(
    Query$albumById$albumById$artist(
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

class _CopyWithStubImpl$Query$albumById$albumById$artist<TRes>
    implements CopyWith$Query$albumById$albumById$artist<TRes> {
  _CopyWithStubImpl$Query$albumById$albumById$artist(this._res);

  TRes _res;

  call({String? id, String? name, String? $__typename}) => _res;
}

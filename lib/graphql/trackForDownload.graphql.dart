import 'fragmentImages.graphql.dart';
import 'fragmentMediafiles.graphql.dart';
import 'fragmentMetadata.graphql.dart';

import 'package:gql/ast.dart';

class Variables$Query$trackForDownload {
  factory Variables$Query$trackForDownload({String? id}) =>
      Variables$Query$trackForDownload._({if (id != null) r'id': id});

  Variables$Query$trackForDownload._(this._$data);

  factory Variables$Query$trackForDownload.fromJson(Map<String, dynamic> data) {
    final result$data = <String, dynamic>{};
    if (data.containsKey('id')) {
      final l$id = data['id'];
      result$data['id'] = (l$id as String?);
    }
    return Variables$Query$trackForDownload._(result$data);
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

  CopyWith$Variables$Query$trackForDownload<Variables$Query$trackForDownload>
  get copyWith => CopyWith$Variables$Query$trackForDownload(this, (i) => i);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Variables$Query$trackForDownload ||
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

abstract class CopyWith$Variables$Query$trackForDownload<TRes> {
  factory CopyWith$Variables$Query$trackForDownload(
    Variables$Query$trackForDownload instance,
    TRes Function(Variables$Query$trackForDownload) then,
  ) = _CopyWithImpl$Variables$Query$trackForDownload;

  factory CopyWith$Variables$Query$trackForDownload.stub(TRes res) =
      _CopyWithStubImpl$Variables$Query$trackForDownload;

  TRes call({String? id});
}

class _CopyWithImpl$Variables$Query$trackForDownload<TRes>
    implements CopyWith$Variables$Query$trackForDownload<TRes> {
  _CopyWithImpl$Variables$Query$trackForDownload(this._instance, this._then);

  final Variables$Query$trackForDownload _instance;

  final TRes Function(Variables$Query$trackForDownload) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({Object? id = _undefined}) => _then(
    Variables$Query$trackForDownload._({
      ..._instance._$data,
      if (id != _undefined) 'id': (id as String?),
    }),
  );
}

class _CopyWithStubImpl$Variables$Query$trackForDownload<TRes>
    implements CopyWith$Variables$Query$trackForDownload<TRes> {
  _CopyWithStubImpl$Variables$Query$trackForDownload(this._res);

  TRes _res;

  call({String? id}) => _res;
}

class Query$trackForDownload {
  Query$trackForDownload({this.trackById, this.$__typename = 'Query'});

  factory Query$trackForDownload.fromJson(Map<String, dynamic> json) {
    final l$trackById = json['trackById'];
    final l$$__typename = json['__typename'];
    return Query$trackForDownload(
      trackById: l$trackById == null
          ? null
          : Query$trackForDownload$trackById.fromJson(
              (l$trackById as Map<String, dynamic>),
            ),
      $__typename: (l$$__typename as String),
    );
  }

  final Query$trackForDownload$trackById? trackById;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$trackById = trackById;
    _resultData['trackById'] = l$trackById?.toJson();
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$trackById = trackById;
    final l$$__typename = $__typename;
    return Object.hashAll([l$trackById, l$$__typename]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Query$trackForDownload || runtimeType != other.runtimeType) {
      return false;
    }
    final l$trackById = trackById;
    final lOther$trackById = other.trackById;
    if (l$trackById != lOther$trackById) {
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

extension UtilityExtension$Query$trackForDownload on Query$trackForDownload {
  CopyWith$Query$trackForDownload<Query$trackForDownload> get copyWith =>
      CopyWith$Query$trackForDownload(this, (i) => i);
}

abstract class CopyWith$Query$trackForDownload<TRes> {
  factory CopyWith$Query$trackForDownload(
    Query$trackForDownload instance,
    TRes Function(Query$trackForDownload) then,
  ) = _CopyWithImpl$Query$trackForDownload;

  factory CopyWith$Query$trackForDownload.stub(TRes res) =
      _CopyWithStubImpl$Query$trackForDownload;

  TRes call({Query$trackForDownload$trackById? trackById, String? $__typename});
  CopyWith$Query$trackForDownload$trackById<TRes> get trackById;
}

class _CopyWithImpl$Query$trackForDownload<TRes>
    implements CopyWith$Query$trackForDownload<TRes> {
  _CopyWithImpl$Query$trackForDownload(this._instance, this._then);

  final Query$trackForDownload _instance;

  final TRes Function(Query$trackForDownload) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? trackById = _undefined,
    Object? $__typename = _undefined,
  }) => _then(
    Query$trackForDownload(
      trackById: trackById == _undefined
          ? _instance.trackById
          : (trackById as Query$trackForDownload$trackById?),
      $__typename: $__typename == _undefined || $__typename == null
          ? _instance.$__typename
          : ($__typename as String),
    ),
  );

  CopyWith$Query$trackForDownload$trackById<TRes> get trackById {
    final local$trackById = _instance.trackById;
    return local$trackById == null
        ? CopyWith$Query$trackForDownload$trackById.stub(_then(_instance))
        : CopyWith$Query$trackForDownload$trackById(
            local$trackById,
            (e) => call(trackById: e),
          );
  }
}

class _CopyWithStubImpl$Query$trackForDownload<TRes>
    implements CopyWith$Query$trackForDownload<TRes> {
  _CopyWithStubImpl$Query$trackForDownload(this._res);

  TRes _res;

  call({Query$trackForDownload$trackById? trackById, String? $__typename}) =>
      _res;

  CopyWith$Query$trackForDownload$trackById<TRes> get trackById =>
      CopyWith$Query$trackForDownload$trackById.stub(_res);
}

const documentNodeQuerytrackForDownload = DocumentNode(
  definitions: [
    OperationDefinitionNode(
      type: OperationType.query,
      name: NameNode(value: 'trackForDownload'),
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
            name: NameNode(value: 'trackById'),
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
            name: NameNode(value: '__typename'),
            alias: null,
            arguments: [],
            directives: [],
            selectionSet: null,
          ),
        ],
      ),
    ),
    fragmentDefinitionfragmentImages,
    fragmentDefinitionfragmentMetadata,
    fragmentDefinitionfragmentMediaFiles,
  ],
);

class Query$trackForDownload$trackById {
  Query$trackForDownload$trackById({
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

  factory Query$trackForDownload$trackById.fromJson(Map<String, dynamic> json) {
    final l$id = json['id'];
    final l$number = json['number'];
    final l$discNumber = json['discNumber'];
    final l$artist = json['artist'];
    final l$album = json['album'];
    final l$metadata = json['metadata'];
    final l$mediaFile = json['mediaFile'];
    final l$rating = json['rating'];
    final l$$__typename = json['__typename'];
    return Query$trackForDownload$trackById(
      id: (l$id as String),
      number: (l$number as int),
      discNumber: (l$discNumber as int),
      artist: Query$trackForDownload$trackById$artist.fromJson(
        (l$artist as Map<String, dynamic>),
      ),
      album: Query$trackForDownload$trackById$album.fromJson(
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

  final Query$trackForDownload$trackById$artist artist;

  final Query$trackForDownload$trackById$album album;

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
    if (other is! Query$trackForDownload$trackById ||
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

extension UtilityExtension$Query$trackForDownload$trackById
    on Query$trackForDownload$trackById {
  CopyWith$Query$trackForDownload$trackById<Query$trackForDownload$trackById>
  get copyWith => CopyWith$Query$trackForDownload$trackById(this, (i) => i);
}

abstract class CopyWith$Query$trackForDownload$trackById<TRes> {
  factory CopyWith$Query$trackForDownload$trackById(
    Query$trackForDownload$trackById instance,
    TRes Function(Query$trackForDownload$trackById) then,
  ) = _CopyWithImpl$Query$trackForDownload$trackById;

  factory CopyWith$Query$trackForDownload$trackById.stub(TRes res) =
      _CopyWithStubImpl$Query$trackForDownload$trackById;

  TRes call({
    String? id,
    int? number,
    int? discNumber,
    Query$trackForDownload$trackById$artist? artist,
    Query$trackForDownload$trackById$album? album,
    List<Fragment$fragmentMetadata>? metadata,
    List<Fragment$fragmentMediaFiles>? mediaFile,
    int? rating,
    String? $__typename,
  });
  CopyWith$Query$trackForDownload$trackById$artist<TRes> get artist;
  CopyWith$Query$trackForDownload$trackById$album<TRes> get album;
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

class _CopyWithImpl$Query$trackForDownload$trackById<TRes>
    implements CopyWith$Query$trackForDownload$trackById<TRes> {
  _CopyWithImpl$Query$trackForDownload$trackById(this._instance, this._then);

  final Query$trackForDownload$trackById _instance;

  final TRes Function(Query$trackForDownload$trackById) _then;

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
    Query$trackForDownload$trackById(
      id: id == _undefined || id == null ? _instance.id : (id as String),
      number: number == _undefined || number == null
          ? _instance.number
          : (number as int),
      discNumber: discNumber == _undefined || discNumber == null
          ? _instance.discNumber
          : (discNumber as int),
      artist: artist == _undefined || artist == null
          ? _instance.artist
          : (artist as Query$trackForDownload$trackById$artist),
      album: album == _undefined || album == null
          ? _instance.album
          : (album as Query$trackForDownload$trackById$album),
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

  CopyWith$Query$trackForDownload$trackById$artist<TRes> get artist {
    final local$artist = _instance.artist;
    return CopyWith$Query$trackForDownload$trackById$artist(
      local$artist,
      (e) => call(artist: e),
    );
  }

  CopyWith$Query$trackForDownload$trackById$album<TRes> get album {
    final local$album = _instance.album;
    return CopyWith$Query$trackForDownload$trackById$album(
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

class _CopyWithStubImpl$Query$trackForDownload$trackById<TRes>
    implements CopyWith$Query$trackForDownload$trackById<TRes> {
  _CopyWithStubImpl$Query$trackForDownload$trackById(this._res);

  TRes _res;

  call({
    String? id,
    int? number,
    int? discNumber,
    Query$trackForDownload$trackById$artist? artist,
    Query$trackForDownload$trackById$album? album,
    List<Fragment$fragmentMetadata>? metadata,
    List<Fragment$fragmentMediaFiles>? mediaFile,
    int? rating,
    String? $__typename,
  }) => _res;

  CopyWith$Query$trackForDownload$trackById$artist<TRes> get artist =>
      CopyWith$Query$trackForDownload$trackById$artist.stub(_res);

  CopyWith$Query$trackForDownload$trackById$album<TRes> get album =>
      CopyWith$Query$trackForDownload$trackById$album.stub(_res);

  metadata(_fn) => _res;

  mediaFile(_fn) => _res;
}

class Query$trackForDownload$trackById$artist {
  Query$trackForDownload$trackById$artist({
    required this.id,
    required this.name,
    this.$__typename = 'Person',
  });

  factory Query$trackForDownload$trackById$artist.fromJson(
    Map<String, dynamic> json,
  ) {
    final l$id = json['id'];
    final l$name = json['name'];
    final l$$__typename = json['__typename'];
    return Query$trackForDownload$trackById$artist(
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
    if (other is! Query$trackForDownload$trackById$artist ||
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

extension UtilityExtension$Query$trackForDownload$trackById$artist
    on Query$trackForDownload$trackById$artist {
  CopyWith$Query$trackForDownload$trackById$artist<
    Query$trackForDownload$trackById$artist
  >
  get copyWith =>
      CopyWith$Query$trackForDownload$trackById$artist(this, (i) => i);
}

abstract class CopyWith$Query$trackForDownload$trackById$artist<TRes> {
  factory CopyWith$Query$trackForDownload$trackById$artist(
    Query$trackForDownload$trackById$artist instance,
    TRes Function(Query$trackForDownload$trackById$artist) then,
  ) = _CopyWithImpl$Query$trackForDownload$trackById$artist;

  factory CopyWith$Query$trackForDownload$trackById$artist.stub(TRes res) =
      _CopyWithStubImpl$Query$trackForDownload$trackById$artist;

  TRes call({String? id, String? name, String? $__typename});
}

class _CopyWithImpl$Query$trackForDownload$trackById$artist<TRes>
    implements CopyWith$Query$trackForDownload$trackById$artist<TRes> {
  _CopyWithImpl$Query$trackForDownload$trackById$artist(
    this._instance,
    this._then,
  );

  final Query$trackForDownload$trackById$artist _instance;

  final TRes Function(Query$trackForDownload$trackById$artist) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? id = _undefined,
    Object? name = _undefined,
    Object? $__typename = _undefined,
  }) => _then(
    Query$trackForDownload$trackById$artist(
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

class _CopyWithStubImpl$Query$trackForDownload$trackById$artist<TRes>
    implements CopyWith$Query$trackForDownload$trackById$artist<TRes> {
  _CopyWithStubImpl$Query$trackForDownload$trackById$artist(this._res);

  TRes _res;

  call({String? id, String? name, String? $__typename}) => _res;
}

class Query$trackForDownload$trackById$album {
  Query$trackForDownload$trackById$album({
    required this.id,
    required this.name,
    this.images,
    this.$__typename = 'Album',
  });

  factory Query$trackForDownload$trackById$album.fromJson(
    Map<String, dynamic> json,
  ) {
    final l$id = json['id'];
    final l$name = json['name'];
    final l$images = json['images'];
    final l$$__typename = json['__typename'];
    return Query$trackForDownload$trackById$album(
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
    if (other is! Query$trackForDownload$trackById$album ||
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

extension UtilityExtension$Query$trackForDownload$trackById$album
    on Query$trackForDownload$trackById$album {
  CopyWith$Query$trackForDownload$trackById$album<
    Query$trackForDownload$trackById$album
  >
  get copyWith =>
      CopyWith$Query$trackForDownload$trackById$album(this, (i) => i);
}

abstract class CopyWith$Query$trackForDownload$trackById$album<TRes> {
  factory CopyWith$Query$trackForDownload$trackById$album(
    Query$trackForDownload$trackById$album instance,
    TRes Function(Query$trackForDownload$trackById$album) then,
  ) = _CopyWithImpl$Query$trackForDownload$trackById$album;

  factory CopyWith$Query$trackForDownload$trackById$album.stub(TRes res) =
      _CopyWithStubImpl$Query$trackForDownload$trackById$album;

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

class _CopyWithImpl$Query$trackForDownload$trackById$album<TRes>
    implements CopyWith$Query$trackForDownload$trackById$album<TRes> {
  _CopyWithImpl$Query$trackForDownload$trackById$album(
    this._instance,
    this._then,
  );

  final Query$trackForDownload$trackById$album _instance;

  final TRes Function(Query$trackForDownload$trackById$album) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? id = _undefined,
    Object? name = _undefined,
    Object? images = _undefined,
    Object? $__typename = _undefined,
  }) => _then(
    Query$trackForDownload$trackById$album(
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

class _CopyWithStubImpl$Query$trackForDownload$trackById$album<TRes>
    implements CopyWith$Query$trackForDownload$trackById$album<TRes> {
  _CopyWithStubImpl$Query$trackForDownload$trackById$album(this._res);

  TRes _res;

  call({
    String? id,
    String? name,
    List<Fragment$fragmentImages>? images,
    String? $__typename,
  }) => _res;

  images(_fn) => _res;
}

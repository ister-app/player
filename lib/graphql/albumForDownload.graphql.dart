import 'fragmentImages.graphql.dart';
import 'fragmentMediafiles.graphql.dart';
import 'fragmentMetadata.graphql.dart';

import 'package:gql/ast.dart';

class Variables$Query$albumForDownload {
  factory Variables$Query$albumForDownload({String? id}) =>
      Variables$Query$albumForDownload._({if (id != null) r'id': id});

  Variables$Query$albumForDownload._(this._$data);

  factory Variables$Query$albumForDownload.fromJson(Map<String, dynamic> data) {
    final result$data = <String, dynamic>{};
    if (data.containsKey('id')) {
      final l$id = data['id'];
      result$data['id'] = (l$id as String?);
    }
    return Variables$Query$albumForDownload._(result$data);
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

  CopyWith$Variables$Query$albumForDownload<Variables$Query$albumForDownload>
  get copyWith => CopyWith$Variables$Query$albumForDownload(this, (i) => i);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Variables$Query$albumForDownload ||
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

abstract class CopyWith$Variables$Query$albumForDownload<TRes> {
  factory CopyWith$Variables$Query$albumForDownload(
    Variables$Query$albumForDownload instance,
    TRes Function(Variables$Query$albumForDownload) then,
  ) = _CopyWithImpl$Variables$Query$albumForDownload;

  factory CopyWith$Variables$Query$albumForDownload.stub(TRes res) =
      _CopyWithStubImpl$Variables$Query$albumForDownload;

  TRes call({String? id});
}

class _CopyWithImpl$Variables$Query$albumForDownload<TRes>
    implements CopyWith$Variables$Query$albumForDownload<TRes> {
  _CopyWithImpl$Variables$Query$albumForDownload(this._instance, this._then);

  final Variables$Query$albumForDownload _instance;

  final TRes Function(Variables$Query$albumForDownload) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({Object? id = _undefined}) => _then(
    Variables$Query$albumForDownload._({
      ..._instance._$data,
      if (id != _undefined) 'id': (id as String?),
    }),
  );
}

class _CopyWithStubImpl$Variables$Query$albumForDownload<TRes>
    implements CopyWith$Variables$Query$albumForDownload<TRes> {
  _CopyWithStubImpl$Variables$Query$albumForDownload(this._res);

  TRes _res;

  call({String? id}) => _res;
}

class Query$albumForDownload {
  Query$albumForDownload({this.albumById, this.$__typename = 'Query'});

  factory Query$albumForDownload.fromJson(Map<String, dynamic> json) {
    final l$albumById = json['albumById'];
    final l$$__typename = json['__typename'];
    return Query$albumForDownload(
      albumById: l$albumById == null
          ? null
          : Query$albumForDownload$albumById.fromJson(
              (l$albumById as Map<String, dynamic>),
            ),
      $__typename: (l$$__typename as String),
    );
  }

  final Query$albumForDownload$albumById? albumById;

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
    if (other is! Query$albumForDownload || runtimeType != other.runtimeType) {
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

extension UtilityExtension$Query$albumForDownload on Query$albumForDownload {
  CopyWith$Query$albumForDownload<Query$albumForDownload> get copyWith =>
      CopyWith$Query$albumForDownload(this, (i) => i);
}

abstract class CopyWith$Query$albumForDownload<TRes> {
  factory CopyWith$Query$albumForDownload(
    Query$albumForDownload instance,
    TRes Function(Query$albumForDownload) then,
  ) = _CopyWithImpl$Query$albumForDownload;

  factory CopyWith$Query$albumForDownload.stub(TRes res) =
      _CopyWithStubImpl$Query$albumForDownload;

  TRes call({Query$albumForDownload$albumById? albumById, String? $__typename});
  CopyWith$Query$albumForDownload$albumById<TRes> get albumById;
}

class _CopyWithImpl$Query$albumForDownload<TRes>
    implements CopyWith$Query$albumForDownload<TRes> {
  _CopyWithImpl$Query$albumForDownload(this._instance, this._then);

  final Query$albumForDownload _instance;

  final TRes Function(Query$albumForDownload) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? albumById = _undefined,
    Object? $__typename = _undefined,
  }) => _then(
    Query$albumForDownload(
      albumById: albumById == _undefined
          ? _instance.albumById
          : (albumById as Query$albumForDownload$albumById?),
      $__typename: $__typename == _undefined || $__typename == null
          ? _instance.$__typename
          : ($__typename as String),
    ),
  );

  CopyWith$Query$albumForDownload$albumById<TRes> get albumById {
    final local$albumById = _instance.albumById;
    return local$albumById == null
        ? CopyWith$Query$albumForDownload$albumById.stub(_then(_instance))
        : CopyWith$Query$albumForDownload$albumById(
            local$albumById,
            (e) => call(albumById: e),
          );
  }
}

class _CopyWithStubImpl$Query$albumForDownload<TRes>
    implements CopyWith$Query$albumForDownload<TRes> {
  _CopyWithStubImpl$Query$albumForDownload(this._res);

  TRes _res;

  call({Query$albumForDownload$albumById? albumById, String? $__typename}) =>
      _res;

  CopyWith$Query$albumForDownload$albumById<TRes> get albumById =>
      CopyWith$Query$albumForDownload$albumById.stub(_res);
}

const documentNodeQueryalbumForDownload = DocumentNode(
  definitions: [
    OperationDefinitionNode(
      type: OperationType.query,
      name: NameNode(value: 'albumForDownload'),
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
                  name: NameNode(value: 'tracks'),
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

class Query$albumForDownload$albumById {
  Query$albumForDownload$albumById({
    required this.id,
    required this.name,
    this.images,
    this.tracks,
    this.$__typename = 'Album',
  });

  factory Query$albumForDownload$albumById.fromJson(Map<String, dynamic> json) {
    final l$id = json['id'];
    final l$name = json['name'];
    final l$images = json['images'];
    final l$tracks = json['tracks'];
    final l$$__typename = json['__typename'];
    return Query$albumForDownload$albumById(
      id: (l$id as String),
      name: (l$name as String),
      images: (l$images as List<dynamic>?)
          ?.map(
            (e) =>
                Fragment$fragmentImages.fromJson((e as Map<String, dynamic>)),
          )
          .toList(),
      tracks: (l$tracks as List<dynamic>?)
          ?.map(
            (e) => Query$albumForDownload$albumById$tracks.fromJson(
              (e as Map<String, dynamic>),
            ),
          )
          .toList(),
      $__typename: (l$$__typename as String),
    );
  }

  final String id;

  final String name;

  final List<Fragment$fragmentImages>? images;

  final List<Query$albumForDownload$albumById$tracks>? tracks;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$id = id;
    _resultData['id'] = l$id;
    final l$name = name;
    _resultData['name'] = l$name;
    final l$images = images;
    _resultData['images'] = l$images?.map((e) => e.toJson()).toList();
    final l$tracks = tracks;
    _resultData['tracks'] = l$tracks?.map((e) => e.toJson()).toList();
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$id = id;
    final l$name = name;
    final l$images = images;
    final l$tracks = tracks;
    final l$$__typename = $__typename;
    return Object.hashAll([
      l$id,
      l$name,
      l$images == null ? null : Object.hashAll(l$images.map((v) => v)),
      l$tracks == null ? null : Object.hashAll(l$tracks.map((v) => v)),
      l$$__typename,
    ]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Query$albumForDownload$albumById ||
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
    final l$$__typename = $__typename;
    final lOther$$__typename = other.$__typename;
    if (l$$__typename != lOther$$__typename) {
      return false;
    }
    return true;
  }
}

extension UtilityExtension$Query$albumForDownload$albumById
    on Query$albumForDownload$albumById {
  CopyWith$Query$albumForDownload$albumById<Query$albumForDownload$albumById>
  get copyWith => CopyWith$Query$albumForDownload$albumById(this, (i) => i);
}

abstract class CopyWith$Query$albumForDownload$albumById<TRes> {
  factory CopyWith$Query$albumForDownload$albumById(
    Query$albumForDownload$albumById instance,
    TRes Function(Query$albumForDownload$albumById) then,
  ) = _CopyWithImpl$Query$albumForDownload$albumById;

  factory CopyWith$Query$albumForDownload$albumById.stub(TRes res) =
      _CopyWithStubImpl$Query$albumForDownload$albumById;

  TRes call({
    String? id,
    String? name,
    List<Fragment$fragmentImages>? images,
    List<Query$albumForDownload$albumById$tracks>? tracks,
    String? $__typename,
  });
  TRes images(
    Iterable<Fragment$fragmentImages>? Function(
      Iterable<CopyWith$Fragment$fragmentImages<Fragment$fragmentImages>>?,
    )
    _fn,
  );
  TRes tracks(
    Iterable<Query$albumForDownload$albumById$tracks>? Function(
      Iterable<
        CopyWith$Query$albumForDownload$albumById$tracks<
          Query$albumForDownload$albumById$tracks
        >
      >?,
    )
    _fn,
  );
}

class _CopyWithImpl$Query$albumForDownload$albumById<TRes>
    implements CopyWith$Query$albumForDownload$albumById<TRes> {
  _CopyWithImpl$Query$albumForDownload$albumById(this._instance, this._then);

  final Query$albumForDownload$albumById _instance;

  final TRes Function(Query$albumForDownload$albumById) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? id = _undefined,
    Object? name = _undefined,
    Object? images = _undefined,
    Object? tracks = _undefined,
    Object? $__typename = _undefined,
  }) => _then(
    Query$albumForDownload$albumById(
      id: id == _undefined || id == null ? _instance.id : (id as String),
      name: name == _undefined || name == null
          ? _instance.name
          : (name as String),
      images: images == _undefined
          ? _instance.images
          : (images as List<Fragment$fragmentImages>?),
      tracks: tracks == _undefined
          ? _instance.tracks
          : (tracks as List<Query$albumForDownload$albumById$tracks>?),
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

  TRes tracks(
    Iterable<Query$albumForDownload$albumById$tracks>? Function(
      Iterable<
        CopyWith$Query$albumForDownload$albumById$tracks<
          Query$albumForDownload$albumById$tracks
        >
      >?,
    )
    _fn,
  ) => call(
    tracks: _fn(
      _instance.tracks?.map(
        (e) => CopyWith$Query$albumForDownload$albumById$tracks(e, (i) => i),
      ),
    )?.toList(),
  );
}

class _CopyWithStubImpl$Query$albumForDownload$albumById<TRes>
    implements CopyWith$Query$albumForDownload$albumById<TRes> {
  _CopyWithStubImpl$Query$albumForDownload$albumById(this._res);

  TRes _res;

  call({
    String? id,
    String? name,
    List<Fragment$fragmentImages>? images,
    List<Query$albumForDownload$albumById$tracks>? tracks,
    String? $__typename,
  }) => _res;

  images(_fn) => _res;

  tracks(_fn) => _res;
}

class Query$albumForDownload$albumById$tracks {
  Query$albumForDownload$albumById$tracks({
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

  factory Query$albumForDownload$albumById$tracks.fromJson(
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
    return Query$albumForDownload$albumById$tracks(
      id: (l$id as String),
      number: (l$number as int),
      discNumber: (l$discNumber as int),
      artist: Query$albumForDownload$albumById$tracks$artist.fromJson(
        (l$artist as Map<String, dynamic>),
      ),
      album: Query$albumForDownload$albumById$tracks$album.fromJson(
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

  final Query$albumForDownload$albumById$tracks$artist artist;

  final Query$albumForDownload$albumById$tracks$album album;

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
    if (other is! Query$albumForDownload$albumById$tracks ||
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

extension UtilityExtension$Query$albumForDownload$albumById$tracks
    on Query$albumForDownload$albumById$tracks {
  CopyWith$Query$albumForDownload$albumById$tracks<
    Query$albumForDownload$albumById$tracks
  >
  get copyWith =>
      CopyWith$Query$albumForDownload$albumById$tracks(this, (i) => i);
}

abstract class CopyWith$Query$albumForDownload$albumById$tracks<TRes> {
  factory CopyWith$Query$albumForDownload$albumById$tracks(
    Query$albumForDownload$albumById$tracks instance,
    TRes Function(Query$albumForDownload$albumById$tracks) then,
  ) = _CopyWithImpl$Query$albumForDownload$albumById$tracks;

  factory CopyWith$Query$albumForDownload$albumById$tracks.stub(TRes res) =
      _CopyWithStubImpl$Query$albumForDownload$albumById$tracks;

  TRes call({
    String? id,
    int? number,
    int? discNumber,
    Query$albumForDownload$albumById$tracks$artist? artist,
    Query$albumForDownload$albumById$tracks$album? album,
    List<Fragment$fragmentMetadata>? metadata,
    List<Fragment$fragmentMediaFiles>? mediaFile,
    int? rating,
    String? $__typename,
  });
  CopyWith$Query$albumForDownload$albumById$tracks$artist<TRes> get artist;
  CopyWith$Query$albumForDownload$albumById$tracks$album<TRes> get album;
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

class _CopyWithImpl$Query$albumForDownload$albumById$tracks<TRes>
    implements CopyWith$Query$albumForDownload$albumById$tracks<TRes> {
  _CopyWithImpl$Query$albumForDownload$albumById$tracks(
    this._instance,
    this._then,
  );

  final Query$albumForDownload$albumById$tracks _instance;

  final TRes Function(Query$albumForDownload$albumById$tracks) _then;

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
    Query$albumForDownload$albumById$tracks(
      id: id == _undefined || id == null ? _instance.id : (id as String),
      number: number == _undefined || number == null
          ? _instance.number
          : (number as int),
      discNumber: discNumber == _undefined || discNumber == null
          ? _instance.discNumber
          : (discNumber as int),
      artist: artist == _undefined || artist == null
          ? _instance.artist
          : (artist as Query$albumForDownload$albumById$tracks$artist),
      album: album == _undefined || album == null
          ? _instance.album
          : (album as Query$albumForDownload$albumById$tracks$album),
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

  CopyWith$Query$albumForDownload$albumById$tracks$artist<TRes> get artist {
    final local$artist = _instance.artist;
    return CopyWith$Query$albumForDownload$albumById$tracks$artist(
      local$artist,
      (e) => call(artist: e),
    );
  }

  CopyWith$Query$albumForDownload$albumById$tracks$album<TRes> get album {
    final local$album = _instance.album;
    return CopyWith$Query$albumForDownload$albumById$tracks$album(
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

class _CopyWithStubImpl$Query$albumForDownload$albumById$tracks<TRes>
    implements CopyWith$Query$albumForDownload$albumById$tracks<TRes> {
  _CopyWithStubImpl$Query$albumForDownload$albumById$tracks(this._res);

  TRes _res;

  call({
    String? id,
    int? number,
    int? discNumber,
    Query$albumForDownload$albumById$tracks$artist? artist,
    Query$albumForDownload$albumById$tracks$album? album,
    List<Fragment$fragmentMetadata>? metadata,
    List<Fragment$fragmentMediaFiles>? mediaFile,
    int? rating,
    String? $__typename,
  }) => _res;

  CopyWith$Query$albumForDownload$albumById$tracks$artist<TRes> get artist =>
      CopyWith$Query$albumForDownload$albumById$tracks$artist.stub(_res);

  CopyWith$Query$albumForDownload$albumById$tracks$album<TRes> get album =>
      CopyWith$Query$albumForDownload$albumById$tracks$album.stub(_res);

  metadata(_fn) => _res;

  mediaFile(_fn) => _res;
}

class Query$albumForDownload$albumById$tracks$artist {
  Query$albumForDownload$albumById$tracks$artist({
    required this.id,
    required this.name,
    this.$__typename = 'Person',
  });

  factory Query$albumForDownload$albumById$tracks$artist.fromJson(
    Map<String, dynamic> json,
  ) {
    final l$id = json['id'];
    final l$name = json['name'];
    final l$$__typename = json['__typename'];
    return Query$albumForDownload$albumById$tracks$artist(
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
    if (other is! Query$albumForDownload$albumById$tracks$artist ||
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

extension UtilityExtension$Query$albumForDownload$albumById$tracks$artist
    on Query$albumForDownload$albumById$tracks$artist {
  CopyWith$Query$albumForDownload$albumById$tracks$artist<
    Query$albumForDownload$albumById$tracks$artist
  >
  get copyWith =>
      CopyWith$Query$albumForDownload$albumById$tracks$artist(this, (i) => i);
}

abstract class CopyWith$Query$albumForDownload$albumById$tracks$artist<TRes> {
  factory CopyWith$Query$albumForDownload$albumById$tracks$artist(
    Query$albumForDownload$albumById$tracks$artist instance,
    TRes Function(Query$albumForDownload$albumById$tracks$artist) then,
  ) = _CopyWithImpl$Query$albumForDownload$albumById$tracks$artist;

  factory CopyWith$Query$albumForDownload$albumById$tracks$artist.stub(
    TRes res,
  ) = _CopyWithStubImpl$Query$albumForDownload$albumById$tracks$artist;

  TRes call({String? id, String? name, String? $__typename});
}

class _CopyWithImpl$Query$albumForDownload$albumById$tracks$artist<TRes>
    implements CopyWith$Query$albumForDownload$albumById$tracks$artist<TRes> {
  _CopyWithImpl$Query$albumForDownload$albumById$tracks$artist(
    this._instance,
    this._then,
  );

  final Query$albumForDownload$albumById$tracks$artist _instance;

  final TRes Function(Query$albumForDownload$albumById$tracks$artist) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? id = _undefined,
    Object? name = _undefined,
    Object? $__typename = _undefined,
  }) => _then(
    Query$albumForDownload$albumById$tracks$artist(
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

class _CopyWithStubImpl$Query$albumForDownload$albumById$tracks$artist<TRes>
    implements CopyWith$Query$albumForDownload$albumById$tracks$artist<TRes> {
  _CopyWithStubImpl$Query$albumForDownload$albumById$tracks$artist(this._res);

  TRes _res;

  call({String? id, String? name, String? $__typename}) => _res;
}

class Query$albumForDownload$albumById$tracks$album {
  Query$albumForDownload$albumById$tracks$album({
    required this.id,
    required this.name,
    this.images,
    this.$__typename = 'Album',
  });

  factory Query$albumForDownload$albumById$tracks$album.fromJson(
    Map<String, dynamic> json,
  ) {
    final l$id = json['id'];
    final l$name = json['name'];
    final l$images = json['images'];
    final l$$__typename = json['__typename'];
    return Query$albumForDownload$albumById$tracks$album(
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
    if (other is! Query$albumForDownload$albumById$tracks$album ||
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

extension UtilityExtension$Query$albumForDownload$albumById$tracks$album
    on Query$albumForDownload$albumById$tracks$album {
  CopyWith$Query$albumForDownload$albumById$tracks$album<
    Query$albumForDownload$albumById$tracks$album
  >
  get copyWith =>
      CopyWith$Query$albumForDownload$albumById$tracks$album(this, (i) => i);
}

abstract class CopyWith$Query$albumForDownload$albumById$tracks$album<TRes> {
  factory CopyWith$Query$albumForDownload$albumById$tracks$album(
    Query$albumForDownload$albumById$tracks$album instance,
    TRes Function(Query$albumForDownload$albumById$tracks$album) then,
  ) = _CopyWithImpl$Query$albumForDownload$albumById$tracks$album;

  factory CopyWith$Query$albumForDownload$albumById$tracks$album.stub(
    TRes res,
  ) = _CopyWithStubImpl$Query$albumForDownload$albumById$tracks$album;

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

class _CopyWithImpl$Query$albumForDownload$albumById$tracks$album<TRes>
    implements CopyWith$Query$albumForDownload$albumById$tracks$album<TRes> {
  _CopyWithImpl$Query$albumForDownload$albumById$tracks$album(
    this._instance,
    this._then,
  );

  final Query$albumForDownload$albumById$tracks$album _instance;

  final TRes Function(Query$albumForDownload$albumById$tracks$album) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? id = _undefined,
    Object? name = _undefined,
    Object? images = _undefined,
    Object? $__typename = _undefined,
  }) => _then(
    Query$albumForDownload$albumById$tracks$album(
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

class _CopyWithStubImpl$Query$albumForDownload$albumById$tracks$album<TRes>
    implements CopyWith$Query$albumForDownload$albumById$tracks$album<TRes> {
  _CopyWithStubImpl$Query$albumForDownload$albumById$tracks$album(this._res);

  TRes _res;

  call({
    String? id,
    String? name,
    List<Fragment$fragmentImages>? images,
    String? $__typename,
  }) => _res;

  images(_fn) => _res;
}

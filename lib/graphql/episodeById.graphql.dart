import 'fragmentImages.graphql.dart';
import 'fragmentMetadata.graphql.dart';
import 'package:gql/ast.dart';

class Variables$Query$episodeById {
  factory Variables$Query$episodeById({required String id}) =>
      Variables$Query$episodeById._({r'id': id});

  Variables$Query$episodeById._(this._$data);

  factory Variables$Query$episodeById.fromJson(Map<String, dynamic> data) {
    final result$data = <String, dynamic>{};
    final l$id = data['id'];
    result$data['id'] = (l$id as String);
    return Variables$Query$episodeById._(result$data);
  }

  Map<String, dynamic> _$data;

  String get id => (_$data['id'] as String);

  Map<String, dynamic> toJson() {
    final result$data = <String, dynamic>{};
    final l$id = id;
    result$data['id'] = l$id;
    return result$data;
  }

  CopyWith$Variables$Query$episodeById<Variables$Query$episodeById>
  get copyWith => CopyWith$Variables$Query$episodeById(this, (i) => i);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Variables$Query$episodeById ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$id = id;
    final lOther$id = other.id;
    if (l$id != lOther$id) {
      return false;
    }
    return true;
  }

  @override
  int get hashCode {
    final l$id = id;
    return Object.hashAll([l$id]);
  }
}

abstract class CopyWith$Variables$Query$episodeById<TRes> {
  factory CopyWith$Variables$Query$episodeById(
    Variables$Query$episodeById instance,
    TRes Function(Variables$Query$episodeById) then,
  ) = _CopyWithImpl$Variables$Query$episodeById;

  factory CopyWith$Variables$Query$episodeById.stub(TRes res) =
      _CopyWithStubImpl$Variables$Query$episodeById;

  TRes call({String? id});
}

class _CopyWithImpl$Variables$Query$episodeById<TRes>
    implements CopyWith$Variables$Query$episodeById<TRes> {
  _CopyWithImpl$Variables$Query$episodeById(this._instance, this._then);

  final Variables$Query$episodeById _instance;

  final TRes Function(Variables$Query$episodeById) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({Object? id = _undefined}) => _then(
    Variables$Query$episodeById._({
      ..._instance._$data,
      if (id != _undefined && id != null) 'id': (id as String),
    }),
  );
}

class _CopyWithStubImpl$Variables$Query$episodeById<TRes>
    implements CopyWith$Variables$Query$episodeById<TRes> {
  _CopyWithStubImpl$Variables$Query$episodeById(this._res);

  TRes _res;

  call({String? id}) => _res;
}

class Query$episodeById {
  Query$episodeById({this.episodeById, this.$__typename = 'Query'});

  factory Query$episodeById.fromJson(Map<String, dynamic> json) {
    final l$episodeById = json['episodeById'];
    final l$$__typename = json['__typename'];
    return Query$episodeById(
      episodeById: l$episodeById == null
          ? null
          : Query$episodeById$episodeById.fromJson(
              (l$episodeById as Map<String, dynamic>),
            ),
      $__typename: (l$$__typename as String),
    );
  }

  final Query$episodeById$episodeById? episodeById;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$episodeById = episodeById;
    _resultData['episodeById'] = l$episodeById?.toJson();
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$episodeById = episodeById;
    final l$$__typename = $__typename;
    return Object.hashAll([l$episodeById, l$$__typename]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Query$episodeById || runtimeType != other.runtimeType) {
      return false;
    }
    final l$episodeById = episodeById;
    final lOther$episodeById = other.episodeById;
    if (l$episodeById != lOther$episodeById) {
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

extension UtilityExtension$Query$episodeById on Query$episodeById {
  CopyWith$Query$episodeById<Query$episodeById> get copyWith =>
      CopyWith$Query$episodeById(this, (i) => i);
}

abstract class CopyWith$Query$episodeById<TRes> {
  factory CopyWith$Query$episodeById(
    Query$episodeById instance,
    TRes Function(Query$episodeById) then,
  ) = _CopyWithImpl$Query$episodeById;

  factory CopyWith$Query$episodeById.stub(TRes res) =
      _CopyWithStubImpl$Query$episodeById;

  TRes call({Query$episodeById$episodeById? episodeById, String? $__typename});
  CopyWith$Query$episodeById$episodeById<TRes> get episodeById;
}

class _CopyWithImpl$Query$episodeById<TRes>
    implements CopyWith$Query$episodeById<TRes> {
  _CopyWithImpl$Query$episodeById(this._instance, this._then);

  final Query$episodeById _instance;

  final TRes Function(Query$episodeById) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? episodeById = _undefined,
    Object? $__typename = _undefined,
  }) => _then(
    Query$episodeById(
      episodeById: episodeById == _undefined
          ? _instance.episodeById
          : (episodeById as Query$episodeById$episodeById?),
      $__typename: $__typename == _undefined || $__typename == null
          ? _instance.$__typename
          : ($__typename as String),
    ),
  );

  CopyWith$Query$episodeById$episodeById<TRes> get episodeById {
    final local$episodeById = _instance.episodeById;
    return local$episodeById == null
        ? CopyWith$Query$episodeById$episodeById.stub(_then(_instance))
        : CopyWith$Query$episodeById$episodeById(
            local$episodeById,
            (e) => call(episodeById: e),
          );
  }
}

class _CopyWithStubImpl$Query$episodeById<TRes>
    implements CopyWith$Query$episodeById<TRes> {
  _CopyWithStubImpl$Query$episodeById(this._res);

  TRes _res;

  call({Query$episodeById$episodeById? episodeById, String? $__typename}) =>
      _res;

  CopyWith$Query$episodeById$episodeById<TRes> get episodeById =>
      CopyWith$Query$episodeById$episodeById.stub(_res);
}

const documentNodeQueryepisodeById = DocumentNode(
  definitions: [
    OperationDefinitionNode(
      type: OperationType.query,
      name: NameNode(value: 'episodeById'),
      variableDefinitions: [
        VariableDefinitionNode(
          variable: VariableNode(name: NameNode(value: 'id')),
          type: NamedTypeNode(name: NameNode(value: 'ID'), isNonNull: true),
          defaultValue: DefaultValueNode(value: null),
          directives: [],
        ),
      ],
      directives: [],
      selectionSet: SelectionSetNode(
        selections: [
          FieldNode(
            name: NameNode(value: 'episodeById'),
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
                  name: NameNode(value: 'show'),
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
                  name: NameNode(value: 'season'),
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
                  name: NameNode(value: 'watchStatus'),
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
                        name: NameNode(value: 'playQueueItemId'),
                        alias: null,
                        arguments: [],
                        directives: [],
                        selectionSet: null,
                      ),
                      FieldNode(
                        name: NameNode(value: 'progressInMilliseconds'),
                        alias: null,
                        arguments: [],
                        directives: [],
                        selectionSet: null,
                      ),
                      FieldNode(
                        name: NameNode(value: 'watched'),
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
                  name: NameNode(value: 'mediaFile'),
                  alias: null,
                  arguments: [],
                  directives: [],
                  selectionSet: SelectionSetNode(
                    selections: [
                      FieldNode(
                        name: NameNode(value: 'durationInMilliseconds'),
                        alias: null,
                        arguments: [],
                        directives: [],
                        selectionSet: null,
                      ),
                      FieldNode(
                        name: NameNode(value: 'id'),
                        alias: null,
                        arguments: [],
                        directives: [],
                        selectionSet: null,
                      ),
                      FieldNode(
                        name: NameNode(value: 'path'),
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
                        name: NameNode(value: 'mediaFileStreams'),
                        alias: null,
                        arguments: [],
                        directives: [],
                        selectionSet: SelectionSetNode(
                          selections: [
                            FieldNode(
                              name: NameNode(value: 'codecName'),
                              alias: null,
                              arguments: [],
                              directives: [],
                              selectionSet: null,
                            ),
                            FieldNode(
                              name: NameNode(value: 'codecType'),
                              alias: null,
                              arguments: [],
                              directives: [],
                              selectionSet: null,
                            ),
                            FieldNode(
                              name: NameNode(value: 'height'),
                              alias: null,
                              arguments: [],
                              directives: [],
                              selectionSet: null,
                            ),
                            FieldNode(
                              name: NameNode(value: 'id'),
                              alias: null,
                              arguments: [],
                              directives: [],
                              selectionSet: null,
                            ),
                            FieldNode(
                              name: NameNode(value: 'language'),
                              alias: null,
                              arguments: [],
                              directives: [],
                              selectionSet: null,
                            ),
                            FieldNode(
                              name: NameNode(value: 'path'),
                              alias: null,
                              arguments: [],
                              directives: [],
                              selectionSet: null,
                            ),
                            FieldNode(
                              name: NameNode(value: 'streamIndex'),
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
                              name: NameNode(value: 'width'),
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
    fragmentDefinitionfragmentMetadata,
    fragmentDefinitionfragmentImages,
  ],
);

class Query$episodeById$episodeById {
  Query$episodeById$episodeById({
    required this.id,
    this.number,
    this.$show,
    this.season,
    this.metadata,
    this.images,
    this.watchStatus,
    this.mediaFile,
    this.$__typename = 'Episode',
  });

  factory Query$episodeById$episodeById.fromJson(Map<String, dynamic> json) {
    final l$id = json['id'];
    final l$number = json['number'];
    final l$$show = json['show'];
    final l$season = json['season'];
    final l$metadata = json['metadata'];
    final l$images = json['images'];
    final l$watchStatus = json['watchStatus'];
    final l$mediaFile = json['mediaFile'];
    final l$$__typename = json['__typename'];
    return Query$episodeById$episodeById(
      id: (l$id as String),
      number: (l$number as int?),
      $show: l$$show == null
          ? null
          : Query$episodeById$episodeById$show.fromJson(
              (l$$show as Map<String, dynamic>),
            ),
      season: l$season == null
          ? null
          : Query$episodeById$episodeById$season.fromJson(
              (l$season as Map<String, dynamic>),
            ),
      metadata: (l$metadata as List<dynamic>?)
          ?.map(
            (e) =>
                Fragment$fragmentMetadata.fromJson((e as Map<String, dynamic>)),
          )
          .toList(),
      images: (l$images as List<dynamic>?)
          ?.map(
            (e) =>
                Fragment$fragmentImages.fromJson((e as Map<String, dynamic>)),
          )
          .toList(),
      watchStatus: (l$watchStatus as List<dynamic>?)
          ?.map(
            (e) => Query$episodeById$episodeById$watchStatus.fromJson(
              (e as Map<String, dynamic>),
            ),
          )
          .toList(),
      mediaFile: (l$mediaFile as List<dynamic>?)
          ?.map(
            (e) => Query$episodeById$episodeById$mediaFile.fromJson(
              (e as Map<String, dynamic>),
            ),
          )
          .toList(),
      $__typename: (l$$__typename as String),
    );
  }

  final String id;

  final int? number;

  final Query$episodeById$episodeById$show? $show;

  final Query$episodeById$episodeById$season? season;

  final List<Fragment$fragmentMetadata>? metadata;

  final List<Fragment$fragmentImages>? images;

  final List<Query$episodeById$episodeById$watchStatus>? watchStatus;

  final List<Query$episodeById$episodeById$mediaFile>? mediaFile;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$id = id;
    _resultData['id'] = l$id;
    final l$number = number;
    _resultData['number'] = l$number;
    final l$$show = $show;
    _resultData['show'] = l$$show?.toJson();
    final l$season = season;
    _resultData['season'] = l$season?.toJson();
    final l$metadata = metadata;
    _resultData['metadata'] = l$metadata?.map((e) => e.toJson()).toList();
    final l$images = images;
    _resultData['images'] = l$images?.map((e) => e.toJson()).toList();
    final l$watchStatus = watchStatus;
    _resultData['watchStatus'] = l$watchStatus?.map((e) => e.toJson()).toList();
    final l$mediaFile = mediaFile;
    _resultData['mediaFile'] = l$mediaFile?.map((e) => e.toJson()).toList();
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$id = id;
    final l$number = number;
    final l$$show = $show;
    final l$season = season;
    final l$metadata = metadata;
    final l$images = images;
    final l$watchStatus = watchStatus;
    final l$mediaFile = mediaFile;
    final l$$__typename = $__typename;
    return Object.hashAll([
      l$id,
      l$number,
      l$$show,
      l$season,
      l$metadata == null ? null : Object.hashAll(l$metadata.map((v) => v)),
      l$images == null ? null : Object.hashAll(l$images.map((v) => v)),
      l$watchStatus == null
          ? null
          : Object.hashAll(l$watchStatus.map((v) => v)),
      l$mediaFile == null ? null : Object.hashAll(l$mediaFile.map((v) => v)),
      l$$__typename,
    ]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Query$episodeById$episodeById ||
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
    final l$$show = $show;
    final lOther$$show = other.$show;
    if (l$$show != lOther$$show) {
      return false;
    }
    final l$season = season;
    final lOther$season = other.season;
    if (l$season != lOther$season) {
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
    final l$$__typename = $__typename;
    final lOther$$__typename = other.$__typename;
    if (l$$__typename != lOther$$__typename) {
      return false;
    }
    return true;
  }
}

extension UtilityExtension$Query$episodeById$episodeById
    on Query$episodeById$episodeById {
  CopyWith$Query$episodeById$episodeById<Query$episodeById$episodeById>
  get copyWith => CopyWith$Query$episodeById$episodeById(this, (i) => i);
}

abstract class CopyWith$Query$episodeById$episodeById<TRes> {
  factory CopyWith$Query$episodeById$episodeById(
    Query$episodeById$episodeById instance,
    TRes Function(Query$episodeById$episodeById) then,
  ) = _CopyWithImpl$Query$episodeById$episodeById;

  factory CopyWith$Query$episodeById$episodeById.stub(TRes res) =
      _CopyWithStubImpl$Query$episodeById$episodeById;

  TRes call({
    String? id,
    int? number,
    Query$episodeById$episodeById$show? $show,
    Query$episodeById$episodeById$season? season,
    List<Fragment$fragmentMetadata>? metadata,
    List<Fragment$fragmentImages>? images,
    List<Query$episodeById$episodeById$watchStatus>? watchStatus,
    List<Query$episodeById$episodeById$mediaFile>? mediaFile,
    String? $__typename,
  });
  CopyWith$Query$episodeById$episodeById$show<TRes> get $show;
  CopyWith$Query$episodeById$episodeById$season<TRes> get season;
  TRes metadata(
    Iterable<Fragment$fragmentMetadata>? Function(
      Iterable<CopyWith$Fragment$fragmentMetadata<Fragment$fragmentMetadata>>?,
    )
    _fn,
  );
  TRes images(
    Iterable<Fragment$fragmentImages>? Function(
      Iterable<CopyWith$Fragment$fragmentImages<Fragment$fragmentImages>>?,
    )
    _fn,
  );
  TRes watchStatus(
    Iterable<Query$episodeById$episodeById$watchStatus>? Function(
      Iterable<
        CopyWith$Query$episodeById$episodeById$watchStatus<
          Query$episodeById$episodeById$watchStatus
        >
      >?,
    )
    _fn,
  );
  TRes mediaFile(
    Iterable<Query$episodeById$episodeById$mediaFile>? Function(
      Iterable<
        CopyWith$Query$episodeById$episodeById$mediaFile<
          Query$episodeById$episodeById$mediaFile
        >
      >?,
    )
    _fn,
  );
}

class _CopyWithImpl$Query$episodeById$episodeById<TRes>
    implements CopyWith$Query$episodeById$episodeById<TRes> {
  _CopyWithImpl$Query$episodeById$episodeById(this._instance, this._then);

  final Query$episodeById$episodeById _instance;

  final TRes Function(Query$episodeById$episodeById) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? id = _undefined,
    Object? number = _undefined,
    Object? $show = _undefined,
    Object? season = _undefined,
    Object? metadata = _undefined,
    Object? images = _undefined,
    Object? watchStatus = _undefined,
    Object? mediaFile = _undefined,
    Object? $__typename = _undefined,
  }) => _then(
    Query$episodeById$episodeById(
      id: id == _undefined || id == null ? _instance.id : (id as String),
      number: number == _undefined ? _instance.number : (number as int?),
      $show: $show == _undefined
          ? _instance.$show
          : ($show as Query$episodeById$episodeById$show?),
      season: season == _undefined
          ? _instance.season
          : (season as Query$episodeById$episodeById$season?),
      metadata: metadata == _undefined
          ? _instance.metadata
          : (metadata as List<Fragment$fragmentMetadata>?),
      images: images == _undefined
          ? _instance.images
          : (images as List<Fragment$fragmentImages>?),
      watchStatus: watchStatus == _undefined
          ? _instance.watchStatus
          : (watchStatus as List<Query$episodeById$episodeById$watchStatus>?),
      mediaFile: mediaFile == _undefined
          ? _instance.mediaFile
          : (mediaFile as List<Query$episodeById$episodeById$mediaFile>?),
      $__typename: $__typename == _undefined || $__typename == null
          ? _instance.$__typename
          : ($__typename as String),
    ),
  );

  CopyWith$Query$episodeById$episodeById$show<TRes> get $show {
    final local$$show = _instance.$show;
    return local$$show == null
        ? CopyWith$Query$episodeById$episodeById$show.stub(_then(_instance))
        : CopyWith$Query$episodeById$episodeById$show(
            local$$show,
            (e) => call($show: e),
          );
  }

  CopyWith$Query$episodeById$episodeById$season<TRes> get season {
    final local$season = _instance.season;
    return local$season == null
        ? CopyWith$Query$episodeById$episodeById$season.stub(_then(_instance))
        : CopyWith$Query$episodeById$episodeById$season(
            local$season,
            (e) => call(season: e),
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

  TRes watchStatus(
    Iterable<Query$episodeById$episodeById$watchStatus>? Function(
      Iterable<
        CopyWith$Query$episodeById$episodeById$watchStatus<
          Query$episodeById$episodeById$watchStatus
        >
      >?,
    )
    _fn,
  ) => call(
    watchStatus: _fn(
      _instance.watchStatus?.map(
        (e) => CopyWith$Query$episodeById$episodeById$watchStatus(e, (i) => i),
      ),
    )?.toList(),
  );

  TRes mediaFile(
    Iterable<Query$episodeById$episodeById$mediaFile>? Function(
      Iterable<
        CopyWith$Query$episodeById$episodeById$mediaFile<
          Query$episodeById$episodeById$mediaFile
        >
      >?,
    )
    _fn,
  ) => call(
    mediaFile: _fn(
      _instance.mediaFile?.map(
        (e) => CopyWith$Query$episodeById$episodeById$mediaFile(e, (i) => i),
      ),
    )?.toList(),
  );
}

class _CopyWithStubImpl$Query$episodeById$episodeById<TRes>
    implements CopyWith$Query$episodeById$episodeById<TRes> {
  _CopyWithStubImpl$Query$episodeById$episodeById(this._res);

  TRes _res;

  call({
    String? id,
    int? number,
    Query$episodeById$episodeById$show? $show,
    Query$episodeById$episodeById$season? season,
    List<Fragment$fragmentMetadata>? metadata,
    List<Fragment$fragmentImages>? images,
    List<Query$episodeById$episodeById$watchStatus>? watchStatus,
    List<Query$episodeById$episodeById$mediaFile>? mediaFile,
    String? $__typename,
  }) => _res;

  CopyWith$Query$episodeById$episodeById$show<TRes> get $show =>
      CopyWith$Query$episodeById$episodeById$show.stub(_res);

  CopyWith$Query$episodeById$episodeById$season<TRes> get season =>
      CopyWith$Query$episodeById$episodeById$season.stub(_res);

  metadata(_fn) => _res;

  images(_fn) => _res;

  watchStatus(_fn) => _res;

  mediaFile(_fn) => _res;
}

class Query$episodeById$episodeById$show {
  Query$episodeById$episodeById$show({
    required this.id,
    this.$__typename = 'Show',
  });

  factory Query$episodeById$episodeById$show.fromJson(
    Map<String, dynamic> json,
  ) {
    final l$id = json['id'];
    final l$$__typename = json['__typename'];
    return Query$episodeById$episodeById$show(
      id: (l$id as String),
      $__typename: (l$$__typename as String),
    );
  }

  final String id;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$id = id;
    _resultData['id'] = l$id;
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$id = id;
    final l$$__typename = $__typename;
    return Object.hashAll([l$id, l$$__typename]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Query$episodeById$episodeById$show ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$id = id;
    final lOther$id = other.id;
    if (l$id != lOther$id) {
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

extension UtilityExtension$Query$episodeById$episodeById$show
    on Query$episodeById$episodeById$show {
  CopyWith$Query$episodeById$episodeById$show<
    Query$episodeById$episodeById$show
  >
  get copyWith => CopyWith$Query$episodeById$episodeById$show(this, (i) => i);
}

abstract class CopyWith$Query$episodeById$episodeById$show<TRes> {
  factory CopyWith$Query$episodeById$episodeById$show(
    Query$episodeById$episodeById$show instance,
    TRes Function(Query$episodeById$episodeById$show) then,
  ) = _CopyWithImpl$Query$episodeById$episodeById$show;

  factory CopyWith$Query$episodeById$episodeById$show.stub(TRes res) =
      _CopyWithStubImpl$Query$episodeById$episodeById$show;

  TRes call({String? id, String? $__typename});
}

class _CopyWithImpl$Query$episodeById$episodeById$show<TRes>
    implements CopyWith$Query$episodeById$episodeById$show<TRes> {
  _CopyWithImpl$Query$episodeById$episodeById$show(this._instance, this._then);

  final Query$episodeById$episodeById$show _instance;

  final TRes Function(Query$episodeById$episodeById$show) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({Object? id = _undefined, Object? $__typename = _undefined}) =>
      _then(
        Query$episodeById$episodeById$show(
          id: id == _undefined || id == null ? _instance.id : (id as String),
          $__typename: $__typename == _undefined || $__typename == null
              ? _instance.$__typename
              : ($__typename as String),
        ),
      );
}

class _CopyWithStubImpl$Query$episodeById$episodeById$show<TRes>
    implements CopyWith$Query$episodeById$episodeById$show<TRes> {
  _CopyWithStubImpl$Query$episodeById$episodeById$show(this._res);

  TRes _res;

  call({String? id, String? $__typename}) => _res;
}

class Query$episodeById$episodeById$season {
  Query$episodeById$episodeById$season({
    required this.id,
    this.$__typename = 'Season',
  });

  factory Query$episodeById$episodeById$season.fromJson(
    Map<String, dynamic> json,
  ) {
    final l$id = json['id'];
    final l$$__typename = json['__typename'];
    return Query$episodeById$episodeById$season(
      id: (l$id as String),
      $__typename: (l$$__typename as String),
    );
  }

  final String id;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$id = id;
    _resultData['id'] = l$id;
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$id = id;
    final l$$__typename = $__typename;
    return Object.hashAll([l$id, l$$__typename]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Query$episodeById$episodeById$season ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$id = id;
    final lOther$id = other.id;
    if (l$id != lOther$id) {
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

extension UtilityExtension$Query$episodeById$episodeById$season
    on Query$episodeById$episodeById$season {
  CopyWith$Query$episodeById$episodeById$season<
    Query$episodeById$episodeById$season
  >
  get copyWith => CopyWith$Query$episodeById$episodeById$season(this, (i) => i);
}

abstract class CopyWith$Query$episodeById$episodeById$season<TRes> {
  factory CopyWith$Query$episodeById$episodeById$season(
    Query$episodeById$episodeById$season instance,
    TRes Function(Query$episodeById$episodeById$season) then,
  ) = _CopyWithImpl$Query$episodeById$episodeById$season;

  factory CopyWith$Query$episodeById$episodeById$season.stub(TRes res) =
      _CopyWithStubImpl$Query$episodeById$episodeById$season;

  TRes call({String? id, String? $__typename});
}

class _CopyWithImpl$Query$episodeById$episodeById$season<TRes>
    implements CopyWith$Query$episodeById$episodeById$season<TRes> {
  _CopyWithImpl$Query$episodeById$episodeById$season(
    this._instance,
    this._then,
  );

  final Query$episodeById$episodeById$season _instance;

  final TRes Function(Query$episodeById$episodeById$season) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({Object? id = _undefined, Object? $__typename = _undefined}) =>
      _then(
        Query$episodeById$episodeById$season(
          id: id == _undefined || id == null ? _instance.id : (id as String),
          $__typename: $__typename == _undefined || $__typename == null
              ? _instance.$__typename
              : ($__typename as String),
        ),
      );
}

class _CopyWithStubImpl$Query$episodeById$episodeById$season<TRes>
    implements CopyWith$Query$episodeById$episodeById$season<TRes> {
  _CopyWithStubImpl$Query$episodeById$episodeById$season(this._res);

  TRes _res;

  call({String? id, String? $__typename}) => _res;
}

class Query$episodeById$episodeById$watchStatus {
  Query$episodeById$episodeById$watchStatus({
    required this.id,
    required this.playQueueItemId,
    required this.progressInMilliseconds,
    required this.watched,
    this.$__typename = 'WatchStatus',
  });

  factory Query$episodeById$episodeById$watchStatus.fromJson(
    Map<String, dynamic> json,
  ) {
    final l$id = json['id'];
    final l$playQueueItemId = json['playQueueItemId'];
    final l$progressInMilliseconds = json['progressInMilliseconds'];
    final l$watched = json['watched'];
    final l$$__typename = json['__typename'];
    return Query$episodeById$episodeById$watchStatus(
      id: (l$id as String),
      playQueueItemId: (l$playQueueItemId as String),
      progressInMilliseconds: (l$progressInMilliseconds as int),
      watched: (l$watched as bool),
      $__typename: (l$$__typename as String),
    );
  }

  final String id;

  final String playQueueItemId;

  final int progressInMilliseconds;

  final bool watched;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$id = id;
    _resultData['id'] = l$id;
    final l$playQueueItemId = playQueueItemId;
    _resultData['playQueueItemId'] = l$playQueueItemId;
    final l$progressInMilliseconds = progressInMilliseconds;
    _resultData['progressInMilliseconds'] = l$progressInMilliseconds;
    final l$watched = watched;
    _resultData['watched'] = l$watched;
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$id = id;
    final l$playQueueItemId = playQueueItemId;
    final l$progressInMilliseconds = progressInMilliseconds;
    final l$watched = watched;
    final l$$__typename = $__typename;
    return Object.hashAll([
      l$id,
      l$playQueueItemId,
      l$progressInMilliseconds,
      l$watched,
      l$$__typename,
    ]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Query$episodeById$episodeById$watchStatus ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$id = id;
    final lOther$id = other.id;
    if (l$id != lOther$id) {
      return false;
    }
    final l$playQueueItemId = playQueueItemId;
    final lOther$playQueueItemId = other.playQueueItemId;
    if (l$playQueueItemId != lOther$playQueueItemId) {
      return false;
    }
    final l$progressInMilliseconds = progressInMilliseconds;
    final lOther$progressInMilliseconds = other.progressInMilliseconds;
    if (l$progressInMilliseconds != lOther$progressInMilliseconds) {
      return false;
    }
    final l$watched = watched;
    final lOther$watched = other.watched;
    if (l$watched != lOther$watched) {
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

extension UtilityExtension$Query$episodeById$episodeById$watchStatus
    on Query$episodeById$episodeById$watchStatus {
  CopyWith$Query$episodeById$episodeById$watchStatus<
    Query$episodeById$episodeById$watchStatus
  >
  get copyWith =>
      CopyWith$Query$episodeById$episodeById$watchStatus(this, (i) => i);
}

abstract class CopyWith$Query$episodeById$episodeById$watchStatus<TRes> {
  factory CopyWith$Query$episodeById$episodeById$watchStatus(
    Query$episodeById$episodeById$watchStatus instance,
    TRes Function(Query$episodeById$episodeById$watchStatus) then,
  ) = _CopyWithImpl$Query$episodeById$episodeById$watchStatus;

  factory CopyWith$Query$episodeById$episodeById$watchStatus.stub(TRes res) =
      _CopyWithStubImpl$Query$episodeById$episodeById$watchStatus;

  TRes call({
    String? id,
    String? playQueueItemId,
    int? progressInMilliseconds,
    bool? watched,
    String? $__typename,
  });
}

class _CopyWithImpl$Query$episodeById$episodeById$watchStatus<TRes>
    implements CopyWith$Query$episodeById$episodeById$watchStatus<TRes> {
  _CopyWithImpl$Query$episodeById$episodeById$watchStatus(
    this._instance,
    this._then,
  );

  final Query$episodeById$episodeById$watchStatus _instance;

  final TRes Function(Query$episodeById$episodeById$watchStatus) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? id = _undefined,
    Object? playQueueItemId = _undefined,
    Object? progressInMilliseconds = _undefined,
    Object? watched = _undefined,
    Object? $__typename = _undefined,
  }) => _then(
    Query$episodeById$episodeById$watchStatus(
      id: id == _undefined || id == null ? _instance.id : (id as String),
      playQueueItemId: playQueueItemId == _undefined || playQueueItemId == null
          ? _instance.playQueueItemId
          : (playQueueItemId as String),
      progressInMilliseconds:
          progressInMilliseconds == _undefined || progressInMilliseconds == null
          ? _instance.progressInMilliseconds
          : (progressInMilliseconds as int),
      watched: watched == _undefined || watched == null
          ? _instance.watched
          : (watched as bool),
      $__typename: $__typename == _undefined || $__typename == null
          ? _instance.$__typename
          : ($__typename as String),
    ),
  );
}

class _CopyWithStubImpl$Query$episodeById$episodeById$watchStatus<TRes>
    implements CopyWith$Query$episodeById$episodeById$watchStatus<TRes> {
  _CopyWithStubImpl$Query$episodeById$episodeById$watchStatus(this._res);

  TRes _res;

  call({
    String? id,
    String? playQueueItemId,
    int? progressInMilliseconds,
    bool? watched,
    String? $__typename,
  }) => _res;
}

class Query$episodeById$episodeById$mediaFile {
  Query$episodeById$episodeById$mediaFile({
    this.durationInMilliseconds,
    required this.id,
    required this.path,
    required this.size,
    this.mediaFileStreams,
    this.$__typename = 'MediaFile',
  });

  factory Query$episodeById$episodeById$mediaFile.fromJson(
    Map<String, dynamic> json,
  ) {
    final l$durationInMilliseconds = json['durationInMilliseconds'];
    final l$id = json['id'];
    final l$path = json['path'];
    final l$size = json['size'];
    final l$mediaFileStreams = json['mediaFileStreams'];
    final l$$__typename = json['__typename'];
    return Query$episodeById$episodeById$mediaFile(
      durationInMilliseconds: (l$durationInMilliseconds as int?),
      id: (l$id as String),
      path: (l$path as String),
      size: (l$size as num).toDouble(),
      mediaFileStreams: (l$mediaFileStreams as List<dynamic>?)
          ?.map(
            (e) => e == null
                ? null
                : Query$episodeById$episodeById$mediaFile$mediaFileStreams.fromJson(
                    (e as Map<String, dynamic>),
                  ),
          )
          .toList(),
      $__typename: (l$$__typename as String),
    );
  }

  final int? durationInMilliseconds;

  final String id;

  final String path;

  final double size;

  final List<Query$episodeById$episodeById$mediaFile$mediaFileStreams?>?
  mediaFileStreams;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$durationInMilliseconds = durationInMilliseconds;
    _resultData['durationInMilliseconds'] = l$durationInMilliseconds;
    final l$id = id;
    _resultData['id'] = l$id;
    final l$path = path;
    _resultData['path'] = l$path;
    final l$size = size;
    _resultData['size'] = l$size;
    final l$mediaFileStreams = mediaFileStreams;
    _resultData['mediaFileStreams'] = l$mediaFileStreams
        ?.map((e) => e?.toJson())
        .toList();
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$durationInMilliseconds = durationInMilliseconds;
    final l$id = id;
    final l$path = path;
    final l$size = size;
    final l$mediaFileStreams = mediaFileStreams;
    final l$$__typename = $__typename;
    return Object.hashAll([
      l$durationInMilliseconds,
      l$id,
      l$path,
      l$size,
      l$mediaFileStreams == null
          ? null
          : Object.hashAll(l$mediaFileStreams.map((v) => v)),
      l$$__typename,
    ]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Query$episodeById$episodeById$mediaFile ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$durationInMilliseconds = durationInMilliseconds;
    final lOther$durationInMilliseconds = other.durationInMilliseconds;
    if (l$durationInMilliseconds != lOther$durationInMilliseconds) {
      return false;
    }
    final l$id = id;
    final lOther$id = other.id;
    if (l$id != lOther$id) {
      return false;
    }
    final l$path = path;
    final lOther$path = other.path;
    if (l$path != lOther$path) {
      return false;
    }
    final l$size = size;
    final lOther$size = other.size;
    if (l$size != lOther$size) {
      return false;
    }
    final l$mediaFileStreams = mediaFileStreams;
    final lOther$mediaFileStreams = other.mediaFileStreams;
    if (l$mediaFileStreams != null && lOther$mediaFileStreams != null) {
      if (l$mediaFileStreams.length != lOther$mediaFileStreams.length) {
        return false;
      }
      for (int i = 0; i < l$mediaFileStreams.length; i++) {
        final l$mediaFileStreams$entry = l$mediaFileStreams[i];
        final lOther$mediaFileStreams$entry = lOther$mediaFileStreams[i];
        if (l$mediaFileStreams$entry != lOther$mediaFileStreams$entry) {
          return false;
        }
      }
    } else if (l$mediaFileStreams != lOther$mediaFileStreams) {
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

extension UtilityExtension$Query$episodeById$episodeById$mediaFile
    on Query$episodeById$episodeById$mediaFile {
  CopyWith$Query$episodeById$episodeById$mediaFile<
    Query$episodeById$episodeById$mediaFile
  >
  get copyWith =>
      CopyWith$Query$episodeById$episodeById$mediaFile(this, (i) => i);
}

abstract class CopyWith$Query$episodeById$episodeById$mediaFile<TRes> {
  factory CopyWith$Query$episodeById$episodeById$mediaFile(
    Query$episodeById$episodeById$mediaFile instance,
    TRes Function(Query$episodeById$episodeById$mediaFile) then,
  ) = _CopyWithImpl$Query$episodeById$episodeById$mediaFile;

  factory CopyWith$Query$episodeById$episodeById$mediaFile.stub(TRes res) =
      _CopyWithStubImpl$Query$episodeById$episodeById$mediaFile;

  TRes call({
    int? durationInMilliseconds,
    String? id,
    String? path,
    double? size,
    List<Query$episodeById$episodeById$mediaFile$mediaFileStreams?>?
    mediaFileStreams,
    String? $__typename,
  });
  TRes mediaFileStreams(
    Iterable<Query$episodeById$episodeById$mediaFile$mediaFileStreams?>?
    Function(
      Iterable<
        CopyWith$Query$episodeById$episodeById$mediaFile$mediaFileStreams<
          Query$episodeById$episodeById$mediaFile$mediaFileStreams
        >?
      >?,
    )
    _fn,
  );
}

class _CopyWithImpl$Query$episodeById$episodeById$mediaFile<TRes>
    implements CopyWith$Query$episodeById$episodeById$mediaFile<TRes> {
  _CopyWithImpl$Query$episodeById$episodeById$mediaFile(
    this._instance,
    this._then,
  );

  final Query$episodeById$episodeById$mediaFile _instance;

  final TRes Function(Query$episodeById$episodeById$mediaFile) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? durationInMilliseconds = _undefined,
    Object? id = _undefined,
    Object? path = _undefined,
    Object? size = _undefined,
    Object? mediaFileStreams = _undefined,
    Object? $__typename = _undefined,
  }) => _then(
    Query$episodeById$episodeById$mediaFile(
      durationInMilliseconds: durationInMilliseconds == _undefined
          ? _instance.durationInMilliseconds
          : (durationInMilliseconds as int?),
      id: id == _undefined || id == null ? _instance.id : (id as String),
      path: path == _undefined || path == null
          ? _instance.path
          : (path as String),
      size: size == _undefined || size == null
          ? _instance.size
          : (size as double),
      mediaFileStreams: mediaFileStreams == _undefined
          ? _instance.mediaFileStreams
          : (mediaFileStreams
                as List<
                  Query$episodeById$episodeById$mediaFile$mediaFileStreams?
                >?),
      $__typename: $__typename == _undefined || $__typename == null
          ? _instance.$__typename
          : ($__typename as String),
    ),
  );

  TRes mediaFileStreams(
    Iterable<Query$episodeById$episodeById$mediaFile$mediaFileStreams?>?
    Function(
      Iterable<
        CopyWith$Query$episodeById$episodeById$mediaFile$mediaFileStreams<
          Query$episodeById$episodeById$mediaFile$mediaFileStreams
        >?
      >?,
    )
    _fn,
  ) => call(
    mediaFileStreams: _fn(
      _instance.mediaFileStreams?.map(
        (e) => e == null
            ? null
            : CopyWith$Query$episodeById$episodeById$mediaFile$mediaFileStreams(
                e,
                (i) => i,
              ),
      ),
    )?.toList(),
  );
}

class _CopyWithStubImpl$Query$episodeById$episodeById$mediaFile<TRes>
    implements CopyWith$Query$episodeById$episodeById$mediaFile<TRes> {
  _CopyWithStubImpl$Query$episodeById$episodeById$mediaFile(this._res);

  TRes _res;

  call({
    int? durationInMilliseconds,
    String? id,
    String? path,
    double? size,
    List<Query$episodeById$episodeById$mediaFile$mediaFileStreams?>?
    mediaFileStreams,
    String? $__typename,
  }) => _res;

  mediaFileStreams(_fn) => _res;
}

class Query$episodeById$episodeById$mediaFile$mediaFileStreams {
  Query$episodeById$episodeById$mediaFile$mediaFileStreams({
    required this.codecName,
    required this.codecType,
    required this.height,
    required this.id,
    this.language,
    required this.path,
    this.streamIndex,
    this.title,
    required this.width,
    this.$__typename = 'MediaFileStream',
  });

  factory Query$episodeById$episodeById$mediaFile$mediaFileStreams.fromJson(
    Map<String, dynamic> json,
  ) {
    final l$codecName = json['codecName'];
    final l$codecType = json['codecType'];
    final l$height = json['height'];
    final l$id = json['id'];
    final l$language = json['language'];
    final l$path = json['path'];
    final l$streamIndex = json['streamIndex'];
    final l$title = json['title'];
    final l$width = json['width'];
    final l$$__typename = json['__typename'];
    return Query$episodeById$episodeById$mediaFile$mediaFileStreams(
      codecName: (l$codecName as String),
      codecType: (l$codecType as String),
      height: (l$height as int),
      id: (l$id as String),
      language: (l$language as String?),
      path: (l$path as String),
      streamIndex: (l$streamIndex as int?),
      title: (l$title as String?),
      width: (l$width as int),
      $__typename: (l$$__typename as String),
    );
  }

  final String codecName;

  final String codecType;

  final int height;

  final String id;

  final String? language;

  final String path;

  final int? streamIndex;

  final String? title;

  final int width;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$codecName = codecName;
    _resultData['codecName'] = l$codecName;
    final l$codecType = codecType;
    _resultData['codecType'] = l$codecType;
    final l$height = height;
    _resultData['height'] = l$height;
    final l$id = id;
    _resultData['id'] = l$id;
    final l$language = language;
    _resultData['language'] = l$language;
    final l$path = path;
    _resultData['path'] = l$path;
    final l$streamIndex = streamIndex;
    _resultData['streamIndex'] = l$streamIndex;
    final l$title = title;
    _resultData['title'] = l$title;
    final l$width = width;
    _resultData['width'] = l$width;
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$codecName = codecName;
    final l$codecType = codecType;
    final l$height = height;
    final l$id = id;
    final l$language = language;
    final l$path = path;
    final l$streamIndex = streamIndex;
    final l$title = title;
    final l$width = width;
    final l$$__typename = $__typename;
    return Object.hashAll([
      l$codecName,
      l$codecType,
      l$height,
      l$id,
      l$language,
      l$path,
      l$streamIndex,
      l$title,
      l$width,
      l$$__typename,
    ]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Query$episodeById$episodeById$mediaFile$mediaFileStreams ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$codecName = codecName;
    final lOther$codecName = other.codecName;
    if (l$codecName != lOther$codecName) {
      return false;
    }
    final l$codecType = codecType;
    final lOther$codecType = other.codecType;
    if (l$codecType != lOther$codecType) {
      return false;
    }
    final l$height = height;
    final lOther$height = other.height;
    if (l$height != lOther$height) {
      return false;
    }
    final l$id = id;
    final lOther$id = other.id;
    if (l$id != lOther$id) {
      return false;
    }
    final l$language = language;
    final lOther$language = other.language;
    if (l$language != lOther$language) {
      return false;
    }
    final l$path = path;
    final lOther$path = other.path;
    if (l$path != lOther$path) {
      return false;
    }
    final l$streamIndex = streamIndex;
    final lOther$streamIndex = other.streamIndex;
    if (l$streamIndex != lOther$streamIndex) {
      return false;
    }
    final l$title = title;
    final lOther$title = other.title;
    if (l$title != lOther$title) {
      return false;
    }
    final l$width = width;
    final lOther$width = other.width;
    if (l$width != lOther$width) {
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

extension UtilityExtension$Query$episodeById$episodeById$mediaFile$mediaFileStreams
    on Query$episodeById$episodeById$mediaFile$mediaFileStreams {
  CopyWith$Query$episodeById$episodeById$mediaFile$mediaFileStreams<
    Query$episodeById$episodeById$mediaFile$mediaFileStreams
  >
  get copyWith =>
      CopyWith$Query$episodeById$episodeById$mediaFile$mediaFileStreams(
        this,
        (i) => i,
      );
}

abstract class CopyWith$Query$episodeById$episodeById$mediaFile$mediaFileStreams<
  TRes
> {
  factory CopyWith$Query$episodeById$episodeById$mediaFile$mediaFileStreams(
    Query$episodeById$episodeById$mediaFile$mediaFileStreams instance,
    TRes Function(Query$episodeById$episodeById$mediaFile$mediaFileStreams)
    then,
  ) = _CopyWithImpl$Query$episodeById$episodeById$mediaFile$mediaFileStreams;

  factory CopyWith$Query$episodeById$episodeById$mediaFile$mediaFileStreams.stub(
    TRes res,
  ) = _CopyWithStubImpl$Query$episodeById$episodeById$mediaFile$mediaFileStreams;

  TRes call({
    String? codecName,
    String? codecType,
    int? height,
    String? id,
    String? language,
    String? path,
    int? streamIndex,
    String? title,
    int? width,
    String? $__typename,
  });
}

class _CopyWithImpl$Query$episodeById$episodeById$mediaFile$mediaFileStreams<
  TRes
>
    implements
        CopyWith$Query$episodeById$episodeById$mediaFile$mediaFileStreams<
          TRes
        > {
  _CopyWithImpl$Query$episodeById$episodeById$mediaFile$mediaFileStreams(
    this._instance,
    this._then,
  );

  final Query$episodeById$episodeById$mediaFile$mediaFileStreams _instance;

  final TRes Function(Query$episodeById$episodeById$mediaFile$mediaFileStreams)
  _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? codecName = _undefined,
    Object? codecType = _undefined,
    Object? height = _undefined,
    Object? id = _undefined,
    Object? language = _undefined,
    Object? path = _undefined,
    Object? streamIndex = _undefined,
    Object? title = _undefined,
    Object? width = _undefined,
    Object? $__typename = _undefined,
  }) => _then(
    Query$episodeById$episodeById$mediaFile$mediaFileStreams(
      codecName: codecName == _undefined || codecName == null
          ? _instance.codecName
          : (codecName as String),
      codecType: codecType == _undefined || codecType == null
          ? _instance.codecType
          : (codecType as String),
      height: height == _undefined || height == null
          ? _instance.height
          : (height as int),
      id: id == _undefined || id == null ? _instance.id : (id as String),
      language: language == _undefined
          ? _instance.language
          : (language as String?),
      path: path == _undefined || path == null
          ? _instance.path
          : (path as String),
      streamIndex: streamIndex == _undefined
          ? _instance.streamIndex
          : (streamIndex as int?),
      title: title == _undefined ? _instance.title : (title as String?),
      width: width == _undefined || width == null
          ? _instance.width
          : (width as int),
      $__typename: $__typename == _undefined || $__typename == null
          ? _instance.$__typename
          : ($__typename as String),
    ),
  );
}

class _CopyWithStubImpl$Query$episodeById$episodeById$mediaFile$mediaFileStreams<
  TRes
>
    implements
        CopyWith$Query$episodeById$episodeById$mediaFile$mediaFileStreams<
          TRes
        > {
  _CopyWithStubImpl$Query$episodeById$episodeById$mediaFile$mediaFileStreams(
    this._res,
  );

  TRes _res;

  call({
    String? codecName,
    String? codecType,
    int? height,
    String? id,
    String? language,
    String? path,
    int? streamIndex,
    String? title,
    int? width,
    String? $__typename,
  }) => _res;
}

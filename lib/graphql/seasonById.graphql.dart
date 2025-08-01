import 'fragmentImages.graphql.dart';
import 'fragmentMetadata.graphql.dart';
import 'package:gql/ast.dart';

class Variables$Query$seasonById {
  factory Variables$Query$seasonById({required String id}) =>
      Variables$Query$seasonById._({
        r'id': id,
      });

  Variables$Query$seasonById._(this._$data);

  factory Variables$Query$seasonById.fromJson(Map<String, dynamic> data) {
    final result$data = <String, dynamic>{};
    final l$id = data['id'];
    result$data['id'] = (l$id as String);
    return Variables$Query$seasonById._(result$data);
  }

  Map<String, dynamic> _$data;

  String get id => (_$data['id'] as String);

  Map<String, dynamic> toJson() {
    final result$data = <String, dynamic>{};
    final l$id = id;
    result$data['id'] = l$id;
    return result$data;
  }

  CopyWith$Variables$Query$seasonById<Variables$Query$seasonById>
      get copyWith => CopyWith$Variables$Query$seasonById(
            this,
            (i) => i,
          );

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Variables$Query$seasonById ||
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

abstract class CopyWith$Variables$Query$seasonById<TRes> {
  factory CopyWith$Variables$Query$seasonById(
    Variables$Query$seasonById instance,
    TRes Function(Variables$Query$seasonById) then,
  ) = _CopyWithImpl$Variables$Query$seasonById;

  factory CopyWith$Variables$Query$seasonById.stub(TRes res) =
      _CopyWithStubImpl$Variables$Query$seasonById;

  TRes call({String? id});
}

class _CopyWithImpl$Variables$Query$seasonById<TRes>
    implements CopyWith$Variables$Query$seasonById<TRes> {
  _CopyWithImpl$Variables$Query$seasonById(
    this._instance,
    this._then,
  );

  final Variables$Query$seasonById _instance;

  final TRes Function(Variables$Query$seasonById) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({Object? id = _undefined}) => _then(Variables$Query$seasonById._({
        ..._instance._$data,
        if (id != _undefined && id != null) 'id': (id as String),
      }));
}

class _CopyWithStubImpl$Variables$Query$seasonById<TRes>
    implements CopyWith$Variables$Query$seasonById<TRes> {
  _CopyWithStubImpl$Variables$Query$seasonById(this._res);

  TRes _res;

  call({String? id}) => _res;
}

class Query$seasonById {
  Query$seasonById({
    this.seasonById,
    this.$__typename = 'Query',
  });

  factory Query$seasonById.fromJson(Map<String, dynamic> json) {
    final l$seasonById = json['seasonById'];
    final l$$__typename = json['__typename'];
    return Query$seasonById(
      seasonById: l$seasonById == null
          ? null
          : Query$seasonById$seasonById.fromJson(
              (l$seasonById as Map<String, dynamic>)),
      $__typename: (l$$__typename as String),
    );
  }

  final Query$seasonById$seasonById? seasonById;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$seasonById = seasonById;
    _resultData['seasonById'] = l$seasonById?.toJson();
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$seasonById = seasonById;
    final l$$__typename = $__typename;
    return Object.hashAll([
      l$seasonById,
      l$$__typename,
    ]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Query$seasonById || runtimeType != other.runtimeType) {
      return false;
    }
    final l$seasonById = seasonById;
    final lOther$seasonById = other.seasonById;
    if (l$seasonById != lOther$seasonById) {
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

extension UtilityExtension$Query$seasonById on Query$seasonById {
  CopyWith$Query$seasonById<Query$seasonById> get copyWith =>
      CopyWith$Query$seasonById(
        this,
        (i) => i,
      );
}

abstract class CopyWith$Query$seasonById<TRes> {
  factory CopyWith$Query$seasonById(
    Query$seasonById instance,
    TRes Function(Query$seasonById) then,
  ) = _CopyWithImpl$Query$seasonById;

  factory CopyWith$Query$seasonById.stub(TRes res) =
      _CopyWithStubImpl$Query$seasonById;

  TRes call({
    Query$seasonById$seasonById? seasonById,
    String? $__typename,
  });
  CopyWith$Query$seasonById$seasonById<TRes> get seasonById;
}

class _CopyWithImpl$Query$seasonById<TRes>
    implements CopyWith$Query$seasonById<TRes> {
  _CopyWithImpl$Query$seasonById(
    this._instance,
    this._then,
  );

  final Query$seasonById _instance;

  final TRes Function(Query$seasonById) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? seasonById = _undefined,
    Object? $__typename = _undefined,
  }) =>
      _then(Query$seasonById(
        seasonById: seasonById == _undefined
            ? _instance.seasonById
            : (seasonById as Query$seasonById$seasonById?),
        $__typename: $__typename == _undefined || $__typename == null
            ? _instance.$__typename
            : ($__typename as String),
      ));

  CopyWith$Query$seasonById$seasonById<TRes> get seasonById {
    final local$seasonById = _instance.seasonById;
    return local$seasonById == null
        ? CopyWith$Query$seasonById$seasonById.stub(_then(_instance))
        : CopyWith$Query$seasonById$seasonById(
            local$seasonById, (e) => call(seasonById: e));
  }
}

class _CopyWithStubImpl$Query$seasonById<TRes>
    implements CopyWith$Query$seasonById<TRes> {
  _CopyWithStubImpl$Query$seasonById(this._res);

  TRes _res;

  call({
    Query$seasonById$seasonById? seasonById,
    String? $__typename,
  }) =>
      _res;

  CopyWith$Query$seasonById$seasonById<TRes> get seasonById =>
      CopyWith$Query$seasonById$seasonById.stub(_res);
}

const documentNodeQueryseasonById = DocumentNode(definitions: [
  OperationDefinitionNode(
    type: OperationType.query,
    name: NameNode(value: 'seasonById'),
    variableDefinitions: [
      VariableDefinitionNode(
        variable: VariableNode(name: NameNode(value: 'id')),
        type: NamedTypeNode(
          name: NameNode(value: 'ID'),
          isNonNull: true,
        ),
        defaultValue: DefaultValueNode(value: null),
        directives: [],
      )
    ],
    directives: [],
    selectionSet: SelectionSetNode(selections: [
      FieldNode(
        name: NameNode(value: 'seasonById'),
        alias: null,
        arguments: [
          ArgumentNode(
            name: NameNode(value: 'id'),
            value: VariableNode(name: NameNode(value: 'id')),
          )
        ],
        directives: [],
        selectionSet: SelectionSetNode(selections: [
          FieldNode(
            name: NameNode(value: 'episodes'),
            alias: null,
            arguments: [],
            directives: [],
            selectionSet: SelectionSetNode(selections: [
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
                name: NameNode(value: 'metadata'),
                alias: null,
                arguments: [],
                directives: [],
                selectionSet: SelectionSetNode(selections: [
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
                ]),
              ),
              FieldNode(
                name: NameNode(value: 'show'),
                alias: null,
                arguments: [],
                directives: [],
                selectionSet: SelectionSetNode(selections: [
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
                ]),
              ),
              FieldNode(
                name: NameNode(value: 'images'),
                alias: null,
                arguments: [],
                directives: [],
                selectionSet: SelectionSetNode(selections: [
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
                ]),
              ),
              FieldNode(
                name: NameNode(value: 'watchStatus'),
                alias: null,
                arguments: [],
                directives: [],
                selectionSet: SelectionSetNode(selections: [
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
                ]),
              ),
              FieldNode(
                name: NameNode(value: 'mediaFile'),
                alias: null,
                arguments: [],
                directives: [],
                selectionSet: SelectionSetNode(selections: [
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
                    name: NameNode(value: '__typename'),
                    alias: null,
                    arguments: [],
                    directives: [],
                    selectionSet: null,
                  ),
                ]),
              ),
              FieldNode(
                name: NameNode(value: '__typename'),
                alias: null,
                arguments: [],
                directives: [],
                selectionSet: null,
              ),
            ]),
          ),
          FieldNode(
            name: NameNode(value: '__typename'),
            alias: null,
            arguments: [],
            directives: [],
            selectionSet: null,
          ),
        ]),
      ),
      FieldNode(
        name: NameNode(value: '__typename'),
        alias: null,
        arguments: [],
        directives: [],
        selectionSet: null,
      ),
    ]),
  ),
  fragmentDefinitionfragmentMetadata,
  fragmentDefinitionfragmentImages,
]);

class Query$seasonById$seasonById {
  Query$seasonById$seasonById({
    this.episodes,
    this.$__typename = 'Season',
  });

  factory Query$seasonById$seasonById.fromJson(Map<String, dynamic> json) {
    final l$episodes = json['episodes'];
    final l$$__typename = json['__typename'];
    return Query$seasonById$seasonById(
      episodes: (l$episodes as List<dynamic>?)
          ?.map((e) => Query$seasonById$seasonById$episodes.fromJson(
              (e as Map<String, dynamic>)))
          .toList(),
      $__typename: (l$$__typename as String),
    );
  }

  final List<Query$seasonById$seasonById$episodes>? episodes;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$episodes = episodes;
    _resultData['episodes'] = l$episodes?.map((e) => e.toJson()).toList();
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$episodes = episodes;
    final l$$__typename = $__typename;
    return Object.hashAll([
      l$episodes == null ? null : Object.hashAll(l$episodes.map((v) => v)),
      l$$__typename,
    ]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Query$seasonById$seasonById ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$episodes = episodes;
    final lOther$episodes = other.episodes;
    if (l$episodes != null && lOther$episodes != null) {
      if (l$episodes.length != lOther$episodes.length) {
        return false;
      }
      for (int i = 0; i < l$episodes.length; i++) {
        final l$episodes$entry = l$episodes[i];
        final lOther$episodes$entry = lOther$episodes[i];
        if (l$episodes$entry != lOther$episodes$entry) {
          return false;
        }
      }
    } else if (l$episodes != lOther$episodes) {
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

extension UtilityExtension$Query$seasonById$seasonById
    on Query$seasonById$seasonById {
  CopyWith$Query$seasonById$seasonById<Query$seasonById$seasonById>
      get copyWith => CopyWith$Query$seasonById$seasonById(
            this,
            (i) => i,
          );
}

abstract class CopyWith$Query$seasonById$seasonById<TRes> {
  factory CopyWith$Query$seasonById$seasonById(
    Query$seasonById$seasonById instance,
    TRes Function(Query$seasonById$seasonById) then,
  ) = _CopyWithImpl$Query$seasonById$seasonById;

  factory CopyWith$Query$seasonById$seasonById.stub(TRes res) =
      _CopyWithStubImpl$Query$seasonById$seasonById;

  TRes call({
    List<Query$seasonById$seasonById$episodes>? episodes,
    String? $__typename,
  });
  TRes episodes(
      Iterable<Query$seasonById$seasonById$episodes>? Function(
              Iterable<
                  CopyWith$Query$seasonById$seasonById$episodes<
                      Query$seasonById$seasonById$episodes>>?)
          _fn);
}

class _CopyWithImpl$Query$seasonById$seasonById<TRes>
    implements CopyWith$Query$seasonById$seasonById<TRes> {
  _CopyWithImpl$Query$seasonById$seasonById(
    this._instance,
    this._then,
  );

  final Query$seasonById$seasonById _instance;

  final TRes Function(Query$seasonById$seasonById) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? episodes = _undefined,
    Object? $__typename = _undefined,
  }) =>
      _then(Query$seasonById$seasonById(
        episodes: episodes == _undefined
            ? _instance.episodes
            : (episodes as List<Query$seasonById$seasonById$episodes>?),
        $__typename: $__typename == _undefined || $__typename == null
            ? _instance.$__typename
            : ($__typename as String),
      ));

  TRes episodes(
          Iterable<Query$seasonById$seasonById$episodes>? Function(
                  Iterable<
                      CopyWith$Query$seasonById$seasonById$episodes<
                          Query$seasonById$seasonById$episodes>>?)
              _fn) =>
      call(
          episodes: _fn(_instance.episodes
              ?.map((e) => CopyWith$Query$seasonById$seasonById$episodes(
                    e,
                    (i) => i,
                  )))?.toList());
}

class _CopyWithStubImpl$Query$seasonById$seasonById<TRes>
    implements CopyWith$Query$seasonById$seasonById<TRes> {
  _CopyWithStubImpl$Query$seasonById$seasonById(this._res);

  TRes _res;

  call({
    List<Query$seasonById$seasonById$episodes>? episodes,
    String? $__typename,
  }) =>
      _res;

  episodes(_fn) => _res;
}

class Query$seasonById$seasonById$episodes {
  Query$seasonById$seasonById$episodes({
    required this.id,
    this.number,
    this.metadata,
    this.$show,
    this.images,
    this.watchStatus,
    this.mediaFile,
    this.$__typename = 'Episode',
  });

  factory Query$seasonById$seasonById$episodes.fromJson(
      Map<String, dynamic> json) {
    final l$id = json['id'];
    final l$number = json['number'];
    final l$metadata = json['metadata'];
    final l$$show = json['show'];
    final l$images = json['images'];
    final l$watchStatus = json['watchStatus'];
    final l$mediaFile = json['mediaFile'];
    final l$$__typename = json['__typename'];
    return Query$seasonById$seasonById$episodes(
      id: (l$id as String),
      number: (l$number as int?),
      metadata: (l$metadata as List<dynamic>?)
          ?.map((e) =>
              Fragment$fragmentMetadata.fromJson((e as Map<String, dynamic>)))
          .toList(),
      $show: l$$show == null
          ? null
          : Query$seasonById$seasonById$episodes$show.fromJson(
              (l$$show as Map<String, dynamic>)),
      images: (l$images as List<dynamic>?)
          ?.map((e) =>
              Fragment$fragmentImages.fromJson((e as Map<String, dynamic>)))
          .toList(),
      watchStatus: (l$watchStatus as List<dynamic>?)
          ?.map((e) =>
              Query$seasonById$seasonById$episodes$watchStatus.fromJson(
                  (e as Map<String, dynamic>)))
          .toList(),
      mediaFile: (l$mediaFile as List<dynamic>?)
          ?.map((e) => Query$seasonById$seasonById$episodes$mediaFile.fromJson(
              (e as Map<String, dynamic>)))
          .toList(),
      $__typename: (l$$__typename as String),
    );
  }

  final String id;

  final int? number;

  final List<Fragment$fragmentMetadata>? metadata;

  final Query$seasonById$seasonById$episodes$show? $show;

  final List<Fragment$fragmentImages>? images;

  final List<Query$seasonById$seasonById$episodes$watchStatus>? watchStatus;

  final List<Query$seasonById$seasonById$episodes$mediaFile>? mediaFile;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$id = id;
    _resultData['id'] = l$id;
    final l$number = number;
    _resultData['number'] = l$number;
    final l$metadata = metadata;
    _resultData['metadata'] = l$metadata?.map((e) => e.toJson()).toList();
    final l$$show = $show;
    _resultData['show'] = l$$show?.toJson();
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
    final l$metadata = metadata;
    final l$$show = $show;
    final l$images = images;
    final l$watchStatus = watchStatus;
    final l$mediaFile = mediaFile;
    final l$$__typename = $__typename;
    return Object.hashAll([
      l$id,
      l$number,
      l$metadata == null ? null : Object.hashAll(l$metadata.map((v) => v)),
      l$$show,
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
    if (other is! Query$seasonById$seasonById$episodes ||
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
    final l$$show = $show;
    final lOther$$show = other.$show;
    if (l$$show != lOther$$show) {
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

extension UtilityExtension$Query$seasonById$seasonById$episodes
    on Query$seasonById$seasonById$episodes {
  CopyWith$Query$seasonById$seasonById$episodes<
          Query$seasonById$seasonById$episodes>
      get copyWith => CopyWith$Query$seasonById$seasonById$episodes(
            this,
            (i) => i,
          );
}

abstract class CopyWith$Query$seasonById$seasonById$episodes<TRes> {
  factory CopyWith$Query$seasonById$seasonById$episodes(
    Query$seasonById$seasonById$episodes instance,
    TRes Function(Query$seasonById$seasonById$episodes) then,
  ) = _CopyWithImpl$Query$seasonById$seasonById$episodes;

  factory CopyWith$Query$seasonById$seasonById$episodes.stub(TRes res) =
      _CopyWithStubImpl$Query$seasonById$seasonById$episodes;

  TRes call({
    String? id,
    int? number,
    List<Fragment$fragmentMetadata>? metadata,
    Query$seasonById$seasonById$episodes$show? $show,
    List<Fragment$fragmentImages>? images,
    List<Query$seasonById$seasonById$episodes$watchStatus>? watchStatus,
    List<Query$seasonById$seasonById$episodes$mediaFile>? mediaFile,
    String? $__typename,
  });
  TRes metadata(
      Iterable<Fragment$fragmentMetadata>? Function(
              Iterable<
                  CopyWith$Fragment$fragmentMetadata<
                      Fragment$fragmentMetadata>>?)
          _fn);
  CopyWith$Query$seasonById$seasonById$episodes$show<TRes> get $show;
  TRes images(
      Iterable<Fragment$fragmentImages>? Function(
              Iterable<
                  CopyWith$Fragment$fragmentImages<Fragment$fragmentImages>>?)
          _fn);
  TRes watchStatus(
      Iterable<Query$seasonById$seasonById$episodes$watchStatus>? Function(
              Iterable<
                  CopyWith$Query$seasonById$seasonById$episodes$watchStatus<
                      Query$seasonById$seasonById$episodes$watchStatus>>?)
          _fn);
  TRes mediaFile(
      Iterable<Query$seasonById$seasonById$episodes$mediaFile>? Function(
              Iterable<
                  CopyWith$Query$seasonById$seasonById$episodes$mediaFile<
                      Query$seasonById$seasonById$episodes$mediaFile>>?)
          _fn);
}

class _CopyWithImpl$Query$seasonById$seasonById$episodes<TRes>
    implements CopyWith$Query$seasonById$seasonById$episodes<TRes> {
  _CopyWithImpl$Query$seasonById$seasonById$episodes(
    this._instance,
    this._then,
  );

  final Query$seasonById$seasonById$episodes _instance;

  final TRes Function(Query$seasonById$seasonById$episodes) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? id = _undefined,
    Object? number = _undefined,
    Object? metadata = _undefined,
    Object? $show = _undefined,
    Object? images = _undefined,
    Object? watchStatus = _undefined,
    Object? mediaFile = _undefined,
    Object? $__typename = _undefined,
  }) =>
      _then(Query$seasonById$seasonById$episodes(
        id: id == _undefined || id == null ? _instance.id : (id as String),
        number: number == _undefined ? _instance.number : (number as int?),
        metadata: metadata == _undefined
            ? _instance.metadata
            : (metadata as List<Fragment$fragmentMetadata>?),
        $show: $show == _undefined
            ? _instance.$show
            : ($show as Query$seasonById$seasonById$episodes$show?),
        images: images == _undefined
            ? _instance.images
            : (images as List<Fragment$fragmentImages>?),
        watchStatus: watchStatus == _undefined
            ? _instance.watchStatus
            : (watchStatus
                as List<Query$seasonById$seasonById$episodes$watchStatus>?),
        mediaFile: mediaFile == _undefined
            ? _instance.mediaFile
            : (mediaFile
                as List<Query$seasonById$seasonById$episodes$mediaFile>?),
        $__typename: $__typename == _undefined || $__typename == null
            ? _instance.$__typename
            : ($__typename as String),
      ));

  TRes metadata(
          Iterable<Fragment$fragmentMetadata>? Function(
                  Iterable<
                      CopyWith$Fragment$fragmentMetadata<
                          Fragment$fragmentMetadata>>?)
              _fn) =>
      call(
          metadata: _fn(
              _instance.metadata?.map((e) => CopyWith$Fragment$fragmentMetadata(
                    e,
                    (i) => i,
                  )))?.toList());

  CopyWith$Query$seasonById$seasonById$episodes$show<TRes> get $show {
    final local$$show = _instance.$show;
    return local$$show == null
        ? CopyWith$Query$seasonById$seasonById$episodes$show.stub(
            _then(_instance))
        : CopyWith$Query$seasonById$seasonById$episodes$show(
            local$$show, (e) => call($show: e));
  }

  TRes images(
          Iterable<Fragment$fragmentImages>? Function(
                  Iterable<
                      CopyWith$Fragment$fragmentImages<
                          Fragment$fragmentImages>>?)
              _fn) =>
      call(
          images:
              _fn(_instance.images?.map((e) => CopyWith$Fragment$fragmentImages(
                    e,
                    (i) => i,
                  )))?.toList());

  TRes watchStatus(
          Iterable<Query$seasonById$seasonById$episodes$watchStatus>? Function(
                  Iterable<
                      CopyWith$Query$seasonById$seasonById$episodes$watchStatus<
                          Query$seasonById$seasonById$episodes$watchStatus>>?)
              _fn) =>
      call(
          watchStatus: _fn(_instance.watchStatus?.map(
              (e) => CopyWith$Query$seasonById$seasonById$episodes$watchStatus(
                    e,
                    (i) => i,
                  )))?.toList());

  TRes mediaFile(
          Iterable<Query$seasonById$seasonById$episodes$mediaFile>? Function(
                  Iterable<
                      CopyWith$Query$seasonById$seasonById$episodes$mediaFile<
                          Query$seasonById$seasonById$episodes$mediaFile>>?)
              _fn) =>
      call(
          mediaFile: _fn(_instance.mediaFile?.map(
              (e) => CopyWith$Query$seasonById$seasonById$episodes$mediaFile(
                    e,
                    (i) => i,
                  )))?.toList());
}

class _CopyWithStubImpl$Query$seasonById$seasonById$episodes<TRes>
    implements CopyWith$Query$seasonById$seasonById$episodes<TRes> {
  _CopyWithStubImpl$Query$seasonById$seasonById$episodes(this._res);

  TRes _res;

  call({
    String? id,
    int? number,
    List<Fragment$fragmentMetadata>? metadata,
    Query$seasonById$seasonById$episodes$show? $show,
    List<Fragment$fragmentImages>? images,
    List<Query$seasonById$seasonById$episodes$watchStatus>? watchStatus,
    List<Query$seasonById$seasonById$episodes$mediaFile>? mediaFile,
    String? $__typename,
  }) =>
      _res;

  metadata(_fn) => _res;

  CopyWith$Query$seasonById$seasonById$episodes$show<TRes> get $show =>
      CopyWith$Query$seasonById$seasonById$episodes$show.stub(_res);

  images(_fn) => _res;

  watchStatus(_fn) => _res;

  mediaFile(_fn) => _res;
}

class Query$seasonById$seasonById$episodes$show {
  Query$seasonById$seasonById$episodes$show({
    required this.id,
    this.$__typename = 'Show',
  });

  factory Query$seasonById$seasonById$episodes$show.fromJson(
      Map<String, dynamic> json) {
    final l$id = json['id'];
    final l$$__typename = json['__typename'];
    return Query$seasonById$seasonById$episodes$show(
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
    return Object.hashAll([
      l$id,
      l$$__typename,
    ]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Query$seasonById$seasonById$episodes$show ||
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

extension UtilityExtension$Query$seasonById$seasonById$episodes$show
    on Query$seasonById$seasonById$episodes$show {
  CopyWith$Query$seasonById$seasonById$episodes$show<
          Query$seasonById$seasonById$episodes$show>
      get copyWith => CopyWith$Query$seasonById$seasonById$episodes$show(
            this,
            (i) => i,
          );
}

abstract class CopyWith$Query$seasonById$seasonById$episodes$show<TRes> {
  factory CopyWith$Query$seasonById$seasonById$episodes$show(
    Query$seasonById$seasonById$episodes$show instance,
    TRes Function(Query$seasonById$seasonById$episodes$show) then,
  ) = _CopyWithImpl$Query$seasonById$seasonById$episodes$show;

  factory CopyWith$Query$seasonById$seasonById$episodes$show.stub(TRes res) =
      _CopyWithStubImpl$Query$seasonById$seasonById$episodes$show;

  TRes call({
    String? id,
    String? $__typename,
  });
}

class _CopyWithImpl$Query$seasonById$seasonById$episodes$show<TRes>
    implements CopyWith$Query$seasonById$seasonById$episodes$show<TRes> {
  _CopyWithImpl$Query$seasonById$seasonById$episodes$show(
    this._instance,
    this._then,
  );

  final Query$seasonById$seasonById$episodes$show _instance;

  final TRes Function(Query$seasonById$seasonById$episodes$show) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? id = _undefined,
    Object? $__typename = _undefined,
  }) =>
      _then(Query$seasonById$seasonById$episodes$show(
        id: id == _undefined || id == null ? _instance.id : (id as String),
        $__typename: $__typename == _undefined || $__typename == null
            ? _instance.$__typename
            : ($__typename as String),
      ));
}

class _CopyWithStubImpl$Query$seasonById$seasonById$episodes$show<TRes>
    implements CopyWith$Query$seasonById$seasonById$episodes$show<TRes> {
  _CopyWithStubImpl$Query$seasonById$seasonById$episodes$show(this._res);

  TRes _res;

  call({
    String? id,
    String? $__typename,
  }) =>
      _res;
}

class Query$seasonById$seasonById$episodes$watchStatus {
  Query$seasonById$seasonById$episodes$watchStatus({
    required this.id,
    required this.playQueueItemId,
    required this.progressInMilliseconds,
    required this.watched,
    this.$__typename = 'WatchStatus',
  });

  factory Query$seasonById$seasonById$episodes$watchStatus.fromJson(
      Map<String, dynamic> json) {
    final l$id = json['id'];
    final l$playQueueItemId = json['playQueueItemId'];
    final l$progressInMilliseconds = json['progressInMilliseconds'];
    final l$watched = json['watched'];
    final l$$__typename = json['__typename'];
    return Query$seasonById$seasonById$episodes$watchStatus(
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
    if (other is! Query$seasonById$seasonById$episodes$watchStatus ||
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

extension UtilityExtension$Query$seasonById$seasonById$episodes$watchStatus
    on Query$seasonById$seasonById$episodes$watchStatus {
  CopyWith$Query$seasonById$seasonById$episodes$watchStatus<
          Query$seasonById$seasonById$episodes$watchStatus>
      get copyWith => CopyWith$Query$seasonById$seasonById$episodes$watchStatus(
            this,
            (i) => i,
          );
}

abstract class CopyWith$Query$seasonById$seasonById$episodes$watchStatus<TRes> {
  factory CopyWith$Query$seasonById$seasonById$episodes$watchStatus(
    Query$seasonById$seasonById$episodes$watchStatus instance,
    TRes Function(Query$seasonById$seasonById$episodes$watchStatus) then,
  ) = _CopyWithImpl$Query$seasonById$seasonById$episodes$watchStatus;

  factory CopyWith$Query$seasonById$seasonById$episodes$watchStatus.stub(
          TRes res) =
      _CopyWithStubImpl$Query$seasonById$seasonById$episodes$watchStatus;

  TRes call({
    String? id,
    String? playQueueItemId,
    int? progressInMilliseconds,
    bool? watched,
    String? $__typename,
  });
}

class _CopyWithImpl$Query$seasonById$seasonById$episodes$watchStatus<TRes>
    implements CopyWith$Query$seasonById$seasonById$episodes$watchStatus<TRes> {
  _CopyWithImpl$Query$seasonById$seasonById$episodes$watchStatus(
    this._instance,
    this._then,
  );

  final Query$seasonById$seasonById$episodes$watchStatus _instance;

  final TRes Function(Query$seasonById$seasonById$episodes$watchStatus) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? id = _undefined,
    Object? playQueueItemId = _undefined,
    Object? progressInMilliseconds = _undefined,
    Object? watched = _undefined,
    Object? $__typename = _undefined,
  }) =>
      _then(Query$seasonById$seasonById$episodes$watchStatus(
        id: id == _undefined || id == null ? _instance.id : (id as String),
        playQueueItemId:
            playQueueItemId == _undefined || playQueueItemId == null
                ? _instance.playQueueItemId
                : (playQueueItemId as String),
        progressInMilliseconds: progressInMilliseconds == _undefined ||
                progressInMilliseconds == null
            ? _instance.progressInMilliseconds
            : (progressInMilliseconds as int),
        watched: watched == _undefined || watched == null
            ? _instance.watched
            : (watched as bool),
        $__typename: $__typename == _undefined || $__typename == null
            ? _instance.$__typename
            : ($__typename as String),
      ));
}

class _CopyWithStubImpl$Query$seasonById$seasonById$episodes$watchStatus<TRes>
    implements CopyWith$Query$seasonById$seasonById$episodes$watchStatus<TRes> {
  _CopyWithStubImpl$Query$seasonById$seasonById$episodes$watchStatus(this._res);

  TRes _res;

  call({
    String? id,
    String? playQueueItemId,
    int? progressInMilliseconds,
    bool? watched,
    String? $__typename,
  }) =>
      _res;
}

class Query$seasonById$seasonById$episodes$mediaFile {
  Query$seasonById$seasonById$episodes$mediaFile({
    this.durationInMilliseconds,
    required this.id,
    required this.path,
    required this.size,
    this.$__typename = 'MediaFile',
  });

  factory Query$seasonById$seasonById$episodes$mediaFile.fromJson(
      Map<String, dynamic> json) {
    final l$durationInMilliseconds = json['durationInMilliseconds'];
    final l$id = json['id'];
    final l$path = json['path'];
    final l$size = json['size'];
    final l$$__typename = json['__typename'];
    return Query$seasonById$seasonById$episodes$mediaFile(
      durationInMilliseconds: (l$durationInMilliseconds as int?),
      id: (l$id as String),
      path: (l$path as String),
      size: (l$size as num).toDouble(),
      $__typename: (l$$__typename as String),
    );
  }

  final int? durationInMilliseconds;

  final String id;

  final String path;

  final double size;

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
    final l$$__typename = $__typename;
    return Object.hashAll([
      l$durationInMilliseconds,
      l$id,
      l$path,
      l$size,
      l$$__typename,
    ]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Query$seasonById$seasonById$episodes$mediaFile ||
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
    final l$$__typename = $__typename;
    final lOther$$__typename = other.$__typename;
    if (l$$__typename != lOther$$__typename) {
      return false;
    }
    return true;
  }
}

extension UtilityExtension$Query$seasonById$seasonById$episodes$mediaFile
    on Query$seasonById$seasonById$episodes$mediaFile {
  CopyWith$Query$seasonById$seasonById$episodes$mediaFile<
          Query$seasonById$seasonById$episodes$mediaFile>
      get copyWith => CopyWith$Query$seasonById$seasonById$episodes$mediaFile(
            this,
            (i) => i,
          );
}

abstract class CopyWith$Query$seasonById$seasonById$episodes$mediaFile<TRes> {
  factory CopyWith$Query$seasonById$seasonById$episodes$mediaFile(
    Query$seasonById$seasonById$episodes$mediaFile instance,
    TRes Function(Query$seasonById$seasonById$episodes$mediaFile) then,
  ) = _CopyWithImpl$Query$seasonById$seasonById$episodes$mediaFile;

  factory CopyWith$Query$seasonById$seasonById$episodes$mediaFile.stub(
          TRes res) =
      _CopyWithStubImpl$Query$seasonById$seasonById$episodes$mediaFile;

  TRes call({
    int? durationInMilliseconds,
    String? id,
    String? path,
    double? size,
    String? $__typename,
  });
}

class _CopyWithImpl$Query$seasonById$seasonById$episodes$mediaFile<TRes>
    implements CopyWith$Query$seasonById$seasonById$episodes$mediaFile<TRes> {
  _CopyWithImpl$Query$seasonById$seasonById$episodes$mediaFile(
    this._instance,
    this._then,
  );

  final Query$seasonById$seasonById$episodes$mediaFile _instance;

  final TRes Function(Query$seasonById$seasonById$episodes$mediaFile) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? durationInMilliseconds = _undefined,
    Object? id = _undefined,
    Object? path = _undefined,
    Object? size = _undefined,
    Object? $__typename = _undefined,
  }) =>
      _then(Query$seasonById$seasonById$episodes$mediaFile(
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
        $__typename: $__typename == _undefined || $__typename == null
            ? _instance.$__typename
            : ($__typename as String),
      ));
}

class _CopyWithStubImpl$Query$seasonById$seasonById$episodes$mediaFile<TRes>
    implements CopyWith$Query$seasonById$seasonById$episodes$mediaFile<TRes> {
  _CopyWithStubImpl$Query$seasonById$seasonById$episodes$mediaFile(this._res);

  TRes _res;

  call({
    int? durationInMilliseconds,
    String? id,
    String? path,
    double? size,
    String? $__typename,
  }) =>
      _res;
}

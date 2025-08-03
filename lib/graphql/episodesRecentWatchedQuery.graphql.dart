import 'fragmentImages.graphql.dart';
import 'fragmentMetadata.graphql.dart';
import 'package:gql/ast.dart';

class Query$episodesRecentWatchedQuery {
  Query$episodesRecentWatchedQuery({
    this.episodesRecentWatched,
    this.$__typename = 'Query',
  });

  factory Query$episodesRecentWatchedQuery.fromJson(Map<String, dynamic> json) {
    final l$episodesRecentWatched = json['episodesRecentWatched'];
    final l$$__typename = json['__typename'];
    return Query$episodesRecentWatchedQuery(
      episodesRecentWatched: (l$episodesRecentWatched as List<dynamic>?)
          ?.map((e) =>
              Query$episodesRecentWatchedQuery$episodesRecentWatched.fromJson(
                  (e as Map<String, dynamic>)))
          .toList(),
      $__typename: (l$$__typename as String),
    );
  }

  final List<Query$episodesRecentWatchedQuery$episodesRecentWatched>?
      episodesRecentWatched;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$episodesRecentWatched = episodesRecentWatched;
    _resultData['episodesRecentWatched'] =
        l$episodesRecentWatched?.map((e) => e.toJson()).toList();
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$episodesRecentWatched = episodesRecentWatched;
    final l$$__typename = $__typename;
    return Object.hashAll([
      l$episodesRecentWatched == null
          ? null
          : Object.hashAll(l$episodesRecentWatched.map((v) => v)),
      l$$__typename,
    ]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Query$episodesRecentWatchedQuery ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$episodesRecentWatched = episodesRecentWatched;
    final lOther$episodesRecentWatched = other.episodesRecentWatched;
    if (l$episodesRecentWatched != null &&
        lOther$episodesRecentWatched != null) {
      if (l$episodesRecentWatched.length !=
          lOther$episodesRecentWatched.length) {
        return false;
      }
      for (int i = 0; i < l$episodesRecentWatched.length; i++) {
        final l$episodesRecentWatched$entry = l$episodesRecentWatched[i];
        final lOther$episodesRecentWatched$entry =
            lOther$episodesRecentWatched[i];
        if (l$episodesRecentWatched$entry !=
            lOther$episodesRecentWatched$entry) {
          return false;
        }
      }
    } else if (l$episodesRecentWatched != lOther$episodesRecentWatched) {
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

extension UtilityExtension$Query$episodesRecentWatchedQuery
    on Query$episodesRecentWatchedQuery {
  CopyWith$Query$episodesRecentWatchedQuery<Query$episodesRecentWatchedQuery>
      get copyWith => CopyWith$Query$episodesRecentWatchedQuery(
            this,
            (i) => i,
          );
}

abstract class CopyWith$Query$episodesRecentWatchedQuery<TRes> {
  factory CopyWith$Query$episodesRecentWatchedQuery(
    Query$episodesRecentWatchedQuery instance,
    TRes Function(Query$episodesRecentWatchedQuery) then,
  ) = _CopyWithImpl$Query$episodesRecentWatchedQuery;

  factory CopyWith$Query$episodesRecentWatchedQuery.stub(TRes res) =
      _CopyWithStubImpl$Query$episodesRecentWatchedQuery;

  TRes call({
    List<Query$episodesRecentWatchedQuery$episodesRecentWatched>?
        episodesRecentWatched,
    String? $__typename,
  });
  TRes episodesRecentWatched(
      Iterable<Query$episodesRecentWatchedQuery$episodesRecentWatched>? Function(
              Iterable<
                  CopyWith$Query$episodesRecentWatchedQuery$episodesRecentWatched<
                      Query$episodesRecentWatchedQuery$episodesRecentWatched>>?)
          _fn);
}

class _CopyWithImpl$Query$episodesRecentWatchedQuery<TRes>
    implements CopyWith$Query$episodesRecentWatchedQuery<TRes> {
  _CopyWithImpl$Query$episodesRecentWatchedQuery(
    this._instance,
    this._then,
  );

  final Query$episodesRecentWatchedQuery _instance;

  final TRes Function(Query$episodesRecentWatchedQuery) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? episodesRecentWatched = _undefined,
    Object? $__typename = _undefined,
  }) =>
      _then(Query$episodesRecentWatchedQuery(
        episodesRecentWatched: episodesRecentWatched == _undefined
            ? _instance.episodesRecentWatched
            : (episodesRecentWatched as List<
                Query$episodesRecentWatchedQuery$episodesRecentWatched>?),
        $__typename: $__typename == _undefined || $__typename == null
            ? _instance.$__typename
            : ($__typename as String),
      ));

  TRes episodesRecentWatched(
          Iterable<Query$episodesRecentWatchedQuery$episodesRecentWatched>? Function(
                  Iterable<
                      CopyWith$Query$episodesRecentWatchedQuery$episodesRecentWatched<
                          Query$episodesRecentWatchedQuery$episodesRecentWatched>>?)
              _fn) =>
      call(
          episodesRecentWatched: _fn(_instance.episodesRecentWatched?.map((e) =>
              CopyWith$Query$episodesRecentWatchedQuery$episodesRecentWatched(
                e,
                (i) => i,
              )))?.toList());
}

class _CopyWithStubImpl$Query$episodesRecentWatchedQuery<TRes>
    implements CopyWith$Query$episodesRecentWatchedQuery<TRes> {
  _CopyWithStubImpl$Query$episodesRecentWatchedQuery(this._res);

  TRes _res;

  call({
    List<Query$episodesRecentWatchedQuery$episodesRecentWatched>?
        episodesRecentWatched,
    String? $__typename,
  }) =>
      _res;

  episodesRecentWatched(_fn) => _res;
}

const documentNodeQueryepisodesRecentWatchedQuery = DocumentNode(definitions: [
  OperationDefinitionNode(
    type: OperationType.query,
    name: NameNode(value: 'episodesRecentWatchedQuery'),
    variableDefinitions: [],
    directives: [],
    selectionSet: SelectionSetNode(selections: [
      FieldNode(
        name: NameNode(value: 'episodesRecentWatched'),
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
                name: NameNode(value: '__typename'),
                alias: null,
                arguments: [],
                directives: [],
                selectionSet: null,
              ),
            ]),
          ),
          FieldNode(
            name: NameNode(value: 'season'),
            alias: null,
            arguments: [],
            directives: [],
            selectionSet: SelectionSetNode(selections: [
              FieldNode(
                name: NameNode(value: 'number'),
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
                name: NameNode(value: '__typename'),
                alias: null,
                arguments: [],
                directives: [],
                selectionSet: null,
              ),
            ]),
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
            name: NameNode(value: 'mediaFile'),
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
              FieldNode(
                name: NameNode(value: 'language'),
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
                name: NameNode(value: 'type'),
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
  fragmentDefinitionfragmentMetadata,
  fragmentDefinitionfragmentImages,
]);

class Query$episodesRecentWatchedQuery$episodesRecentWatched {
  Query$episodesRecentWatchedQuery$episodesRecentWatched({
    required this.id,
    this.$show,
    this.season,
    this.watchStatus,
    this.mediaFile,
    this.number,
    this.metadata,
    this.images,
    this.$__typename = 'Episode',
  });

  factory Query$episodesRecentWatchedQuery$episodesRecentWatched.fromJson(
      Map<String, dynamic> json) {
    final l$id = json['id'];
    final l$$show = json['show'];
    final l$season = json['season'];
    final l$watchStatus = json['watchStatus'];
    final l$mediaFile = json['mediaFile'];
    final l$number = json['number'];
    final l$metadata = json['metadata'];
    final l$images = json['images'];
    final l$$__typename = json['__typename'];
    return Query$episodesRecentWatchedQuery$episodesRecentWatched(
      id: (l$id as String),
      $show: l$$show == null
          ? null
          : Query$episodesRecentWatchedQuery$episodesRecentWatched$show
              .fromJson((l$$show as Map<String, dynamic>)),
      season: l$season == null
          ? null
          : Query$episodesRecentWatchedQuery$episodesRecentWatched$season
              .fromJson((l$season as Map<String, dynamic>)),
      watchStatus: (l$watchStatus as List<dynamic>?)
          ?.map((e) =>
              Query$episodesRecentWatchedQuery$episodesRecentWatched$watchStatus
                  .fromJson((e as Map<String, dynamic>)))
          .toList(),
      mediaFile: (l$mediaFile as List<dynamic>?)
          ?.map((e) =>
              Query$episodesRecentWatchedQuery$episodesRecentWatched$mediaFile
                  .fromJson((e as Map<String, dynamic>)))
          .toList(),
      number: (l$number as int?),
      metadata: (l$metadata as List<dynamic>?)
          ?.map((e) =>
              Fragment$fragmentMetadata.fromJson((e as Map<String, dynamic>)))
          .toList(),
      images: (l$images as List<dynamic>?)
          ?.map((e) =>
              Query$episodesRecentWatchedQuery$episodesRecentWatched$images
                  .fromJson((e as Map<String, dynamic>)))
          .toList(),
      $__typename: (l$$__typename as String),
    );
  }

  final String id;

  final Query$episodesRecentWatchedQuery$episodesRecentWatched$show? $show;

  final Query$episodesRecentWatchedQuery$episodesRecentWatched$season? season;

  final List<
          Query$episodesRecentWatchedQuery$episodesRecentWatched$watchStatus>?
      watchStatus;

  final List<Query$episodesRecentWatchedQuery$episodesRecentWatched$mediaFile>?
      mediaFile;

  final int? number;

  final List<Fragment$fragmentMetadata>? metadata;

  final List<Query$episodesRecentWatchedQuery$episodesRecentWatched$images>?
      images;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$id = id;
    _resultData['id'] = l$id;
    final l$$show = $show;
    _resultData['show'] = l$$show?.toJson();
    final l$season = season;
    _resultData['season'] = l$season?.toJson();
    final l$watchStatus = watchStatus;
    _resultData['watchStatus'] = l$watchStatus?.map((e) => e.toJson()).toList();
    final l$mediaFile = mediaFile;
    _resultData['mediaFile'] = l$mediaFile?.map((e) => e.toJson()).toList();
    final l$number = number;
    _resultData['number'] = l$number;
    final l$metadata = metadata;
    _resultData['metadata'] = l$metadata?.map((e) => e.toJson()).toList();
    final l$images = images;
    _resultData['images'] = l$images?.map((e) => e.toJson()).toList();
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$id = id;
    final l$$show = $show;
    final l$season = season;
    final l$watchStatus = watchStatus;
    final l$mediaFile = mediaFile;
    final l$number = number;
    final l$metadata = metadata;
    final l$images = images;
    final l$$__typename = $__typename;
    return Object.hashAll([
      l$id,
      l$$show,
      l$season,
      l$watchStatus == null
          ? null
          : Object.hashAll(l$watchStatus.map((v) => v)),
      l$mediaFile == null ? null : Object.hashAll(l$mediaFile.map((v) => v)),
      l$number,
      l$metadata == null ? null : Object.hashAll(l$metadata.map((v) => v)),
      l$images == null ? null : Object.hashAll(l$images.map((v) => v)),
      l$$__typename,
    ]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Query$episodesRecentWatchedQuery$episodesRecentWatched ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$id = id;
    final lOther$id = other.id;
    if (l$id != lOther$id) {
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

extension UtilityExtension$Query$episodesRecentWatchedQuery$episodesRecentWatched
    on Query$episodesRecentWatchedQuery$episodesRecentWatched {
  CopyWith$Query$episodesRecentWatchedQuery$episodesRecentWatched<
          Query$episodesRecentWatchedQuery$episodesRecentWatched>
      get copyWith =>
          CopyWith$Query$episodesRecentWatchedQuery$episodesRecentWatched(
            this,
            (i) => i,
          );
}

abstract class CopyWith$Query$episodesRecentWatchedQuery$episodesRecentWatched<
    TRes> {
  factory CopyWith$Query$episodesRecentWatchedQuery$episodesRecentWatched(
    Query$episodesRecentWatchedQuery$episodesRecentWatched instance,
    TRes Function(Query$episodesRecentWatchedQuery$episodesRecentWatched) then,
  ) = _CopyWithImpl$Query$episodesRecentWatchedQuery$episodesRecentWatched;

  factory CopyWith$Query$episodesRecentWatchedQuery$episodesRecentWatched.stub(
          TRes res) =
      _CopyWithStubImpl$Query$episodesRecentWatchedQuery$episodesRecentWatched;

  TRes call({
    String? id,
    Query$episodesRecentWatchedQuery$episodesRecentWatched$show? $show,
    Query$episodesRecentWatchedQuery$episodesRecentWatched$season? season,
    List<Query$episodesRecentWatchedQuery$episodesRecentWatched$watchStatus>?
        watchStatus,
    List<Query$episodesRecentWatchedQuery$episodesRecentWatched$mediaFile>?
        mediaFile,
    int? number,
    List<Fragment$fragmentMetadata>? metadata,
    List<Query$episodesRecentWatchedQuery$episodesRecentWatched$images>? images,
    String? $__typename,
  });
  CopyWith$Query$episodesRecentWatchedQuery$episodesRecentWatched$show<TRes>
      get $show;
  CopyWith$Query$episodesRecentWatchedQuery$episodesRecentWatched$season<TRes>
      get season;
  TRes watchStatus(
      Iterable<Query$episodesRecentWatchedQuery$episodesRecentWatched$watchStatus>? Function(
              Iterable<
                  CopyWith$Query$episodesRecentWatchedQuery$episodesRecentWatched$watchStatus<
                      Query$episodesRecentWatchedQuery$episodesRecentWatched$watchStatus>>?)
          _fn);
  TRes mediaFile(
      Iterable<Query$episodesRecentWatchedQuery$episodesRecentWatched$mediaFile>? Function(
              Iterable<
                  CopyWith$Query$episodesRecentWatchedQuery$episodesRecentWatched$mediaFile<
                      Query$episodesRecentWatchedQuery$episodesRecentWatched$mediaFile>>?)
          _fn);
  TRes metadata(
      Iterable<Fragment$fragmentMetadata>? Function(
              Iterable<
                  CopyWith$Fragment$fragmentMetadata<
                      Fragment$fragmentMetadata>>?)
          _fn);
  TRes images(
      Iterable<Query$episodesRecentWatchedQuery$episodesRecentWatched$images>? Function(
              Iterable<
                  CopyWith$Query$episodesRecentWatchedQuery$episodesRecentWatched$images<
                      Query$episodesRecentWatchedQuery$episodesRecentWatched$images>>?)
          _fn);
}

class _CopyWithImpl$Query$episodesRecentWatchedQuery$episodesRecentWatched<TRes>
    implements
        CopyWith$Query$episodesRecentWatchedQuery$episodesRecentWatched<TRes> {
  _CopyWithImpl$Query$episodesRecentWatchedQuery$episodesRecentWatched(
    this._instance,
    this._then,
  );

  final Query$episodesRecentWatchedQuery$episodesRecentWatched _instance;

  final TRes Function(Query$episodesRecentWatchedQuery$episodesRecentWatched)
      _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? id = _undefined,
    Object? $show = _undefined,
    Object? season = _undefined,
    Object? watchStatus = _undefined,
    Object? mediaFile = _undefined,
    Object? number = _undefined,
    Object? metadata = _undefined,
    Object? images = _undefined,
    Object? $__typename = _undefined,
  }) =>
      _then(Query$episodesRecentWatchedQuery$episodesRecentWatched(
        id: id == _undefined || id == null ? _instance.id : (id as String),
        $show: $show == _undefined
            ? _instance.$show
            : ($show
                as Query$episodesRecentWatchedQuery$episodesRecentWatched$show?),
        season: season == _undefined
            ? _instance.season
            : (season
                as Query$episodesRecentWatchedQuery$episodesRecentWatched$season?),
        watchStatus: watchStatus == _undefined
            ? _instance.watchStatus
            : (watchStatus as List<
                Query$episodesRecentWatchedQuery$episodesRecentWatched$watchStatus>?),
        mediaFile: mediaFile == _undefined
            ? _instance.mediaFile
            : (mediaFile as List<
                Query$episodesRecentWatchedQuery$episodesRecentWatched$mediaFile>?),
        number: number == _undefined ? _instance.number : (number as int?),
        metadata: metadata == _undefined
            ? _instance.metadata
            : (metadata as List<Fragment$fragmentMetadata>?),
        images: images == _undefined
            ? _instance.images
            : (images as List<
                Query$episodesRecentWatchedQuery$episodesRecentWatched$images>?),
        $__typename: $__typename == _undefined || $__typename == null
            ? _instance.$__typename
            : ($__typename as String),
      ));

  CopyWith$Query$episodesRecentWatchedQuery$episodesRecentWatched$show<TRes>
      get $show {
    final local$$show = _instance.$show;
    return local$$show == null
        ? CopyWith$Query$episodesRecentWatchedQuery$episodesRecentWatched$show
            .stub(_then(_instance))
        : CopyWith$Query$episodesRecentWatchedQuery$episodesRecentWatched$show(
            local$$show, (e) => call($show: e));
  }

  CopyWith$Query$episodesRecentWatchedQuery$episodesRecentWatched$season<TRes>
      get season {
    final local$season = _instance.season;
    return local$season == null
        ? CopyWith$Query$episodesRecentWatchedQuery$episodesRecentWatched$season
            .stub(_then(_instance))
        : CopyWith$Query$episodesRecentWatchedQuery$episodesRecentWatched$season(
            local$season, (e) => call(season: e));
  }

  TRes watchStatus(
          Iterable<Query$episodesRecentWatchedQuery$episodesRecentWatched$watchStatus>? Function(
                  Iterable<
                      CopyWith$Query$episodesRecentWatchedQuery$episodesRecentWatched$watchStatus<
                          Query$episodesRecentWatchedQuery$episodesRecentWatched$watchStatus>>?)
              _fn) =>
      call(
          watchStatus: _fn(_instance.watchStatus?.map((e) =>
              CopyWith$Query$episodesRecentWatchedQuery$episodesRecentWatched$watchStatus(
                e,
                (i) => i,
              )))?.toList());

  TRes mediaFile(
          Iterable<Query$episodesRecentWatchedQuery$episodesRecentWatched$mediaFile>? Function(
                  Iterable<
                      CopyWith$Query$episodesRecentWatchedQuery$episodesRecentWatched$mediaFile<
                          Query$episodesRecentWatchedQuery$episodesRecentWatched$mediaFile>>?)
              _fn) =>
      call(
          mediaFile: _fn(_instance.mediaFile?.map((e) =>
              CopyWith$Query$episodesRecentWatchedQuery$episodesRecentWatched$mediaFile(
                e,
                (i) => i,
              )))?.toList());

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

  TRes images(
          Iterable<Query$episodesRecentWatchedQuery$episodesRecentWatched$images>? Function(
                  Iterable<
                      CopyWith$Query$episodesRecentWatchedQuery$episodesRecentWatched$images<
                          Query$episodesRecentWatchedQuery$episodesRecentWatched$images>>?)
              _fn) =>
      call(
          images: _fn(_instance.images?.map((e) =>
              CopyWith$Query$episodesRecentWatchedQuery$episodesRecentWatched$images(
                e,
                (i) => i,
              )))?.toList());
}

class _CopyWithStubImpl$Query$episodesRecentWatchedQuery$episodesRecentWatched<
        TRes>
    implements
        CopyWith$Query$episodesRecentWatchedQuery$episodesRecentWatched<TRes> {
  _CopyWithStubImpl$Query$episodesRecentWatchedQuery$episodesRecentWatched(
      this._res);

  TRes _res;

  call({
    String? id,
    Query$episodesRecentWatchedQuery$episodesRecentWatched$show? $show,
    Query$episodesRecentWatchedQuery$episodesRecentWatched$season? season,
    List<Query$episodesRecentWatchedQuery$episodesRecentWatched$watchStatus>?
        watchStatus,
    List<Query$episodesRecentWatchedQuery$episodesRecentWatched$mediaFile>?
        mediaFile,
    int? number,
    List<Fragment$fragmentMetadata>? metadata,
    List<Query$episodesRecentWatchedQuery$episodesRecentWatched$images>? images,
    String? $__typename,
  }) =>
      _res;

  CopyWith$Query$episodesRecentWatchedQuery$episodesRecentWatched$show<TRes>
      get $show =>
          CopyWith$Query$episodesRecentWatchedQuery$episodesRecentWatched$show
              .stub(_res);

  CopyWith$Query$episodesRecentWatchedQuery$episodesRecentWatched$season<TRes>
      get season =>
          CopyWith$Query$episodesRecentWatchedQuery$episodesRecentWatched$season
              .stub(_res);

  watchStatus(_fn) => _res;

  mediaFile(_fn) => _res;

  metadata(_fn) => _res;

  images(_fn) => _res;
}

class Query$episodesRecentWatchedQuery$episodesRecentWatched$show {
  Query$episodesRecentWatchedQuery$episodesRecentWatched$show({
    required this.id,
    this.metadata,
    this.images,
    this.$__typename = 'Show',
  });

  factory Query$episodesRecentWatchedQuery$episodesRecentWatched$show.fromJson(
      Map<String, dynamic> json) {
    final l$id = json['id'];
    final l$metadata = json['metadata'];
    final l$images = json['images'];
    final l$$__typename = json['__typename'];
    return Query$episodesRecentWatchedQuery$episodesRecentWatched$show(
      id: (l$id as String),
      metadata: (l$metadata as List<dynamic>?)
          ?.map((e) =>
              Fragment$fragmentMetadata.fromJson((e as Map<String, dynamic>)))
          .toList(),
      images: (l$images as List<dynamic>?)
          ?.map((e) =>
              Fragment$fragmentImages.fromJson((e as Map<String, dynamic>)))
          .toList(),
      $__typename: (l$$__typename as String),
    );
  }

  final String id;

  final List<Fragment$fragmentMetadata>? metadata;

  final List<Fragment$fragmentImages>? images;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$id = id;
    _resultData['id'] = l$id;
    final l$metadata = metadata;
    _resultData['metadata'] = l$metadata?.map((e) => e.toJson()).toList();
    final l$images = images;
    _resultData['images'] = l$images?.map((e) => e.toJson()).toList();
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$id = id;
    final l$metadata = metadata;
    final l$images = images;
    final l$$__typename = $__typename;
    return Object.hashAll([
      l$id,
      l$metadata == null ? null : Object.hashAll(l$metadata.map((v) => v)),
      l$images == null ? null : Object.hashAll(l$images.map((v) => v)),
      l$$__typename,
    ]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Query$episodesRecentWatchedQuery$episodesRecentWatched$show ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$id = id;
    final lOther$id = other.id;
    if (l$id != lOther$id) {
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
    final l$$__typename = $__typename;
    final lOther$$__typename = other.$__typename;
    if (l$$__typename != lOther$$__typename) {
      return false;
    }
    return true;
  }
}

extension UtilityExtension$Query$episodesRecentWatchedQuery$episodesRecentWatched$show
    on Query$episodesRecentWatchedQuery$episodesRecentWatched$show {
  CopyWith$Query$episodesRecentWatchedQuery$episodesRecentWatched$show<
          Query$episodesRecentWatchedQuery$episodesRecentWatched$show>
      get copyWith =>
          CopyWith$Query$episodesRecentWatchedQuery$episodesRecentWatched$show(
            this,
            (i) => i,
          );
}

abstract class CopyWith$Query$episodesRecentWatchedQuery$episodesRecentWatched$show<
    TRes> {
  factory CopyWith$Query$episodesRecentWatchedQuery$episodesRecentWatched$show(
    Query$episodesRecentWatchedQuery$episodesRecentWatched$show instance,
    TRes Function(Query$episodesRecentWatchedQuery$episodesRecentWatched$show)
        then,
  ) = _CopyWithImpl$Query$episodesRecentWatchedQuery$episodesRecentWatched$show;

  factory CopyWith$Query$episodesRecentWatchedQuery$episodesRecentWatched$show.stub(
          TRes res) =
      _CopyWithStubImpl$Query$episodesRecentWatchedQuery$episodesRecentWatched$show;

  TRes call({
    String? id,
    List<Fragment$fragmentMetadata>? metadata,
    List<Fragment$fragmentImages>? images,
    String? $__typename,
  });
  TRes metadata(
      Iterable<Fragment$fragmentMetadata>? Function(
              Iterable<
                  CopyWith$Fragment$fragmentMetadata<
                      Fragment$fragmentMetadata>>?)
          _fn);
  TRes images(
      Iterable<Fragment$fragmentImages>? Function(
              Iterable<
                  CopyWith$Fragment$fragmentImages<Fragment$fragmentImages>>?)
          _fn);
}

class _CopyWithImpl$Query$episodesRecentWatchedQuery$episodesRecentWatched$show<
        TRes>
    implements
        CopyWith$Query$episodesRecentWatchedQuery$episodesRecentWatched$show<
            TRes> {
  _CopyWithImpl$Query$episodesRecentWatchedQuery$episodesRecentWatched$show(
    this._instance,
    this._then,
  );

  final Query$episodesRecentWatchedQuery$episodesRecentWatched$show _instance;

  final TRes Function(
      Query$episodesRecentWatchedQuery$episodesRecentWatched$show) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? id = _undefined,
    Object? metadata = _undefined,
    Object? images = _undefined,
    Object? $__typename = _undefined,
  }) =>
      _then(Query$episodesRecentWatchedQuery$episodesRecentWatched$show(
        id: id == _undefined || id == null ? _instance.id : (id as String),
        metadata: metadata == _undefined
            ? _instance.metadata
            : (metadata as List<Fragment$fragmentMetadata>?),
        images: images == _undefined
            ? _instance.images
            : (images as List<Fragment$fragmentImages>?),
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
}

class _CopyWithStubImpl$Query$episodesRecentWatchedQuery$episodesRecentWatched$show<
        TRes>
    implements
        CopyWith$Query$episodesRecentWatchedQuery$episodesRecentWatched$show<
            TRes> {
  _CopyWithStubImpl$Query$episodesRecentWatchedQuery$episodesRecentWatched$show(
      this._res);

  TRes _res;

  call({
    String? id,
    List<Fragment$fragmentMetadata>? metadata,
    List<Fragment$fragmentImages>? images,
    String? $__typename,
  }) =>
      _res;

  metadata(_fn) => _res;

  images(_fn) => _res;
}

class Query$episodesRecentWatchedQuery$episodesRecentWatched$season {
  Query$episodesRecentWatchedQuery$episodesRecentWatched$season({
    required this.number,
    this.$__typename = 'Season',
  });

  factory Query$episodesRecentWatchedQuery$episodesRecentWatched$season.fromJson(
      Map<String, dynamic> json) {
    final l$number = json['number'];
    final l$$__typename = json['__typename'];
    return Query$episodesRecentWatchedQuery$episodesRecentWatched$season(
      number: (l$number as int),
      $__typename: (l$$__typename as String),
    );
  }

  final int number;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$number = number;
    _resultData['number'] = l$number;
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$number = number;
    final l$$__typename = $__typename;
    return Object.hashAll([
      l$number,
      l$$__typename,
    ]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other
            is! Query$episodesRecentWatchedQuery$episodesRecentWatched$season ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$number = number;
    final lOther$number = other.number;
    if (l$number != lOther$number) {
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

extension UtilityExtension$Query$episodesRecentWatchedQuery$episodesRecentWatched$season
    on Query$episodesRecentWatchedQuery$episodesRecentWatched$season {
  CopyWith$Query$episodesRecentWatchedQuery$episodesRecentWatched$season<
          Query$episodesRecentWatchedQuery$episodesRecentWatched$season>
      get copyWith =>
          CopyWith$Query$episodesRecentWatchedQuery$episodesRecentWatched$season(
            this,
            (i) => i,
          );
}

abstract class CopyWith$Query$episodesRecentWatchedQuery$episodesRecentWatched$season<
    TRes> {
  factory CopyWith$Query$episodesRecentWatchedQuery$episodesRecentWatched$season(
    Query$episodesRecentWatchedQuery$episodesRecentWatched$season instance,
    TRes Function(Query$episodesRecentWatchedQuery$episodesRecentWatched$season)
        then,
  ) = _CopyWithImpl$Query$episodesRecentWatchedQuery$episodesRecentWatched$season;

  factory CopyWith$Query$episodesRecentWatchedQuery$episodesRecentWatched$season.stub(
          TRes res) =
      _CopyWithStubImpl$Query$episodesRecentWatchedQuery$episodesRecentWatched$season;

  TRes call({
    int? number,
    String? $__typename,
  });
}

class _CopyWithImpl$Query$episodesRecentWatchedQuery$episodesRecentWatched$season<
        TRes>
    implements
        CopyWith$Query$episodesRecentWatchedQuery$episodesRecentWatched$season<
            TRes> {
  _CopyWithImpl$Query$episodesRecentWatchedQuery$episodesRecentWatched$season(
    this._instance,
    this._then,
  );

  final Query$episodesRecentWatchedQuery$episodesRecentWatched$season _instance;

  final TRes Function(
      Query$episodesRecentWatchedQuery$episodesRecentWatched$season) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? number = _undefined,
    Object? $__typename = _undefined,
  }) =>
      _then(Query$episodesRecentWatchedQuery$episodesRecentWatched$season(
        number: number == _undefined || number == null
            ? _instance.number
            : (number as int),
        $__typename: $__typename == _undefined || $__typename == null
            ? _instance.$__typename
            : ($__typename as String),
      ));
}

class _CopyWithStubImpl$Query$episodesRecentWatchedQuery$episodesRecentWatched$season<
        TRes>
    implements
        CopyWith$Query$episodesRecentWatchedQuery$episodesRecentWatched$season<
            TRes> {
  _CopyWithStubImpl$Query$episodesRecentWatchedQuery$episodesRecentWatched$season(
      this._res);

  TRes _res;

  call({
    int? number,
    String? $__typename,
  }) =>
      _res;
}

class Query$episodesRecentWatchedQuery$episodesRecentWatched$watchStatus {
  Query$episodesRecentWatchedQuery$episodesRecentWatched$watchStatus({
    required this.id,
    required this.playQueueItemId,
    required this.progressInMilliseconds,
    required this.watched,
    this.$__typename = 'WatchStatus',
  });

  factory Query$episodesRecentWatchedQuery$episodesRecentWatched$watchStatus.fromJson(
      Map<String, dynamic> json) {
    final l$id = json['id'];
    final l$playQueueItemId = json['playQueueItemId'];
    final l$progressInMilliseconds = json['progressInMilliseconds'];
    final l$watched = json['watched'];
    final l$$__typename = json['__typename'];
    return Query$episodesRecentWatchedQuery$episodesRecentWatched$watchStatus(
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
    if (other
            is! Query$episodesRecentWatchedQuery$episodesRecentWatched$watchStatus ||
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

extension UtilityExtension$Query$episodesRecentWatchedQuery$episodesRecentWatched$watchStatus
    on Query$episodesRecentWatchedQuery$episodesRecentWatched$watchStatus {
  CopyWith$Query$episodesRecentWatchedQuery$episodesRecentWatched$watchStatus<
          Query$episodesRecentWatchedQuery$episodesRecentWatched$watchStatus>
      get copyWith =>
          CopyWith$Query$episodesRecentWatchedQuery$episodesRecentWatched$watchStatus(
            this,
            (i) => i,
          );
}

abstract class CopyWith$Query$episodesRecentWatchedQuery$episodesRecentWatched$watchStatus<
    TRes> {
  factory CopyWith$Query$episodesRecentWatchedQuery$episodesRecentWatched$watchStatus(
    Query$episodesRecentWatchedQuery$episodesRecentWatched$watchStatus instance,
    TRes Function(
            Query$episodesRecentWatchedQuery$episodesRecentWatched$watchStatus)
        then,
  ) = _CopyWithImpl$Query$episodesRecentWatchedQuery$episodesRecentWatched$watchStatus;

  factory CopyWith$Query$episodesRecentWatchedQuery$episodesRecentWatched$watchStatus.stub(
          TRes res) =
      _CopyWithStubImpl$Query$episodesRecentWatchedQuery$episodesRecentWatched$watchStatus;

  TRes call({
    String? id,
    String? playQueueItemId,
    int? progressInMilliseconds,
    bool? watched,
    String? $__typename,
  });
}

class _CopyWithImpl$Query$episodesRecentWatchedQuery$episodesRecentWatched$watchStatus<
        TRes>
    implements
        CopyWith$Query$episodesRecentWatchedQuery$episodesRecentWatched$watchStatus<
            TRes> {
  _CopyWithImpl$Query$episodesRecentWatchedQuery$episodesRecentWatched$watchStatus(
    this._instance,
    this._then,
  );

  final Query$episodesRecentWatchedQuery$episodesRecentWatched$watchStatus
      _instance;

  final TRes Function(
      Query$episodesRecentWatchedQuery$episodesRecentWatched$watchStatus) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? id = _undefined,
    Object? playQueueItemId = _undefined,
    Object? progressInMilliseconds = _undefined,
    Object? watched = _undefined,
    Object? $__typename = _undefined,
  }) =>
      _then(Query$episodesRecentWatchedQuery$episodesRecentWatched$watchStatus(
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

class _CopyWithStubImpl$Query$episodesRecentWatchedQuery$episodesRecentWatched$watchStatus<
        TRes>
    implements
        CopyWith$Query$episodesRecentWatchedQuery$episodesRecentWatched$watchStatus<
            TRes> {
  _CopyWithStubImpl$Query$episodesRecentWatchedQuery$episodesRecentWatched$watchStatus(
      this._res);

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

class Query$episodesRecentWatchedQuery$episodesRecentWatched$mediaFile {
  Query$episodesRecentWatchedQuery$episodesRecentWatched$mediaFile({
    this.durationInMilliseconds,
    this.$__typename = 'MediaFile',
    required this.id,
  });

  factory Query$episodesRecentWatchedQuery$episodesRecentWatched$mediaFile.fromJson(
      Map<String, dynamic> json) {
    final l$durationInMilliseconds = json['durationInMilliseconds'];
    final l$$__typename = json['__typename'];
    final l$id = json['id'];
    return Query$episodesRecentWatchedQuery$episodesRecentWatched$mediaFile(
      durationInMilliseconds: (l$durationInMilliseconds as int?),
      $__typename: (l$$__typename as String),
      id: (l$id as String),
    );
  }

  final int? durationInMilliseconds;

  final String $__typename;

  final String id;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$durationInMilliseconds = durationInMilliseconds;
    _resultData['durationInMilliseconds'] = l$durationInMilliseconds;
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    final l$id = id;
    _resultData['id'] = l$id;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$durationInMilliseconds = durationInMilliseconds;
    final l$$__typename = $__typename;
    final l$id = id;
    return Object.hashAll([
      l$durationInMilliseconds,
      l$$__typename,
      l$id,
    ]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other
            is! Query$episodesRecentWatchedQuery$episodesRecentWatched$mediaFile ||
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
    final l$id = id;
    final lOther$id = other.id;
    if (l$id != lOther$id) {
      return false;
    }
    return true;
  }
}

extension UtilityExtension$Query$episodesRecentWatchedQuery$episodesRecentWatched$mediaFile
    on Query$episodesRecentWatchedQuery$episodesRecentWatched$mediaFile {
  CopyWith$Query$episodesRecentWatchedQuery$episodesRecentWatched$mediaFile<
          Query$episodesRecentWatchedQuery$episodesRecentWatched$mediaFile>
      get copyWith =>
          CopyWith$Query$episodesRecentWatchedQuery$episodesRecentWatched$mediaFile(
            this,
            (i) => i,
          );
}

abstract class CopyWith$Query$episodesRecentWatchedQuery$episodesRecentWatched$mediaFile<
    TRes> {
  factory CopyWith$Query$episodesRecentWatchedQuery$episodesRecentWatched$mediaFile(
    Query$episodesRecentWatchedQuery$episodesRecentWatched$mediaFile instance,
    TRes Function(
            Query$episodesRecentWatchedQuery$episodesRecentWatched$mediaFile)
        then,
  ) = _CopyWithImpl$Query$episodesRecentWatchedQuery$episodesRecentWatched$mediaFile;

  factory CopyWith$Query$episodesRecentWatchedQuery$episodesRecentWatched$mediaFile.stub(
          TRes res) =
      _CopyWithStubImpl$Query$episodesRecentWatchedQuery$episodesRecentWatched$mediaFile;

  TRes call({
    int? durationInMilliseconds,
    String? $__typename,
    String? id,
  });
}

class _CopyWithImpl$Query$episodesRecentWatchedQuery$episodesRecentWatched$mediaFile<
        TRes>
    implements
        CopyWith$Query$episodesRecentWatchedQuery$episodesRecentWatched$mediaFile<
            TRes> {
  _CopyWithImpl$Query$episodesRecentWatchedQuery$episodesRecentWatched$mediaFile(
    this._instance,
    this._then,
  );

  final Query$episodesRecentWatchedQuery$episodesRecentWatched$mediaFile
      _instance;

  final TRes Function(
      Query$episodesRecentWatchedQuery$episodesRecentWatched$mediaFile) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? durationInMilliseconds = _undefined,
    Object? $__typename = _undefined,
    Object? id = _undefined,
  }) =>
      _then(Query$episodesRecentWatchedQuery$episodesRecentWatched$mediaFile(
        durationInMilliseconds: durationInMilliseconds == _undefined
            ? _instance.durationInMilliseconds
            : (durationInMilliseconds as int?),
        $__typename: $__typename == _undefined || $__typename == null
            ? _instance.$__typename
            : ($__typename as String),
        id: id == _undefined || id == null ? _instance.id : (id as String),
      ));
}

class _CopyWithStubImpl$Query$episodesRecentWatchedQuery$episodesRecentWatched$mediaFile<
        TRes>
    implements
        CopyWith$Query$episodesRecentWatchedQuery$episodesRecentWatched$mediaFile<
            TRes> {
  _CopyWithStubImpl$Query$episodesRecentWatchedQuery$episodesRecentWatched$mediaFile(
      this._res);

  TRes _res;

  call({
    int? durationInMilliseconds,
    String? $__typename,
    String? id,
  }) =>
      _res;
}

class Query$episodesRecentWatchedQuery$episodesRecentWatched$images {
  Query$episodesRecentWatchedQuery$episodesRecentWatched$images({
    this.language,
    required this.id,
    required this.type,
    this.$__typename = 'Image',
  });

  factory Query$episodesRecentWatchedQuery$episodesRecentWatched$images.fromJson(
      Map<String, dynamic> json) {
    final l$language = json['language'];
    final l$id = json['id'];
    final l$type = json['type'];
    final l$$__typename = json['__typename'];
    return Query$episodesRecentWatchedQuery$episodesRecentWatched$images(
      language: (l$language as String?),
      id: (l$id as String),
      type: (l$type as String),
      $__typename: (l$$__typename as String),
    );
  }

  final String? language;

  final String id;

  final String type;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$language = language;
    _resultData['language'] = l$language;
    final l$id = id;
    _resultData['id'] = l$id;
    final l$type = type;
    _resultData['type'] = l$type;
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$language = language;
    final l$id = id;
    final l$type = type;
    final l$$__typename = $__typename;
    return Object.hashAll([
      l$language,
      l$id,
      l$type,
      l$$__typename,
    ]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other
            is! Query$episodesRecentWatchedQuery$episodesRecentWatched$images ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$language = language;
    final lOther$language = other.language;
    if (l$language != lOther$language) {
      return false;
    }
    final l$id = id;
    final lOther$id = other.id;
    if (l$id != lOther$id) {
      return false;
    }
    final l$type = type;
    final lOther$type = other.type;
    if (l$type != lOther$type) {
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

extension UtilityExtension$Query$episodesRecentWatchedQuery$episodesRecentWatched$images
    on Query$episodesRecentWatchedQuery$episodesRecentWatched$images {
  CopyWith$Query$episodesRecentWatchedQuery$episodesRecentWatched$images<
          Query$episodesRecentWatchedQuery$episodesRecentWatched$images>
      get copyWith =>
          CopyWith$Query$episodesRecentWatchedQuery$episodesRecentWatched$images(
            this,
            (i) => i,
          );
}

abstract class CopyWith$Query$episodesRecentWatchedQuery$episodesRecentWatched$images<
    TRes> {
  factory CopyWith$Query$episodesRecentWatchedQuery$episodesRecentWatched$images(
    Query$episodesRecentWatchedQuery$episodesRecentWatched$images instance,
    TRes Function(Query$episodesRecentWatchedQuery$episodesRecentWatched$images)
        then,
  ) = _CopyWithImpl$Query$episodesRecentWatchedQuery$episodesRecentWatched$images;

  factory CopyWith$Query$episodesRecentWatchedQuery$episodesRecentWatched$images.stub(
          TRes res) =
      _CopyWithStubImpl$Query$episodesRecentWatchedQuery$episodesRecentWatched$images;

  TRes call({
    String? language,
    String? id,
    String? type,
    String? $__typename,
  });
}

class _CopyWithImpl$Query$episodesRecentWatchedQuery$episodesRecentWatched$images<
        TRes>
    implements
        CopyWith$Query$episodesRecentWatchedQuery$episodesRecentWatched$images<
            TRes> {
  _CopyWithImpl$Query$episodesRecentWatchedQuery$episodesRecentWatched$images(
    this._instance,
    this._then,
  );

  final Query$episodesRecentWatchedQuery$episodesRecentWatched$images _instance;

  final TRes Function(
      Query$episodesRecentWatchedQuery$episodesRecentWatched$images) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? language = _undefined,
    Object? id = _undefined,
    Object? type = _undefined,
    Object? $__typename = _undefined,
  }) =>
      _then(Query$episodesRecentWatchedQuery$episodesRecentWatched$images(
        language:
            language == _undefined ? _instance.language : (language as String?),
        id: id == _undefined || id == null ? _instance.id : (id as String),
        type: type == _undefined || type == null
            ? _instance.type
            : (type as String),
        $__typename: $__typename == _undefined || $__typename == null
            ? _instance.$__typename
            : ($__typename as String),
      ));
}

class _CopyWithStubImpl$Query$episodesRecentWatchedQuery$episodesRecentWatched$images<
        TRes>
    implements
        CopyWith$Query$episodesRecentWatchedQuery$episodesRecentWatched$images<
            TRes> {
  _CopyWithStubImpl$Query$episodesRecentWatchedQuery$episodesRecentWatched$images(
      this._res);

  TRes _res;

  call({
    String? language,
    String? id,
    String? type,
    String? $__typename,
  }) =>
      _res;
}

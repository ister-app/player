import 'fragmentImages.graphql.dart';
import 'fragmentMediafiles.graphql.dart';
import 'fragmentMetadata.graphql.dart';
import 'package:gql/ast.dart';

class Fragment$fragmentEpisode {
  Fragment$fragmentEpisode({
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

  factory Fragment$fragmentEpisode.fromJson(Map<String, dynamic> json) {
    final l$id = json['id'];
    final l$number = json['number'];
    final l$$show = json['show'];
    final l$season = json['season'];
    final l$metadata = json['metadata'];
    final l$images = json['images'];
    final l$watchStatus = json['watchStatus'];
    final l$mediaFile = json['mediaFile'];
    final l$$__typename = json['__typename'];
    return Fragment$fragmentEpisode(
      id: (l$id as String),
      number: (l$number as int?),
      $show: l$$show == null
          ? null
          : Fragment$fragmentEpisode$show.fromJson(
              (l$$show as Map<String, dynamic>),
            ),
      season: l$season == null
          ? null
          : Fragment$fragmentEpisode$season.fromJson(
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
            (e) => Fragment$fragmentEpisode$watchStatus.fromJson(
              (e as Map<String, dynamic>),
            ),
          )
          .toList(),
      mediaFile: (l$mediaFile as List<dynamic>?)
          ?.map(
            (e) => Fragment$fragmentMediaFiles.fromJson(
              (e as Map<String, dynamic>),
            ),
          )
          .toList(),
      $__typename: (l$$__typename as String),
    );
  }

  final String id;

  final int? number;

  final Fragment$fragmentEpisode$show? $show;

  final Fragment$fragmentEpisode$season? season;

  final List<Fragment$fragmentMetadata>? metadata;

  final List<Fragment$fragmentImages>? images;

  final List<Fragment$fragmentEpisode$watchStatus>? watchStatus;

  final List<Fragment$fragmentMediaFiles>? mediaFile;

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
    if (other is! Fragment$fragmentEpisode ||
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

extension UtilityExtension$Fragment$fragmentEpisode
    on Fragment$fragmentEpisode {
  CopyWith$Fragment$fragmentEpisode<Fragment$fragmentEpisode> get copyWith =>
      CopyWith$Fragment$fragmentEpisode(this, (i) => i);
}

abstract class CopyWith$Fragment$fragmentEpisode<TRes> {
  factory CopyWith$Fragment$fragmentEpisode(
    Fragment$fragmentEpisode instance,
    TRes Function(Fragment$fragmentEpisode) then,
  ) = _CopyWithImpl$Fragment$fragmentEpisode;

  factory CopyWith$Fragment$fragmentEpisode.stub(TRes res) =
      _CopyWithStubImpl$Fragment$fragmentEpisode;

  TRes call({
    String? id,
    int? number,
    Fragment$fragmentEpisode$show? $show,
    Fragment$fragmentEpisode$season? season,
    List<Fragment$fragmentMetadata>? metadata,
    List<Fragment$fragmentImages>? images,
    List<Fragment$fragmentEpisode$watchStatus>? watchStatus,
    List<Fragment$fragmentMediaFiles>? mediaFile,
    String? $__typename,
  });
  CopyWith$Fragment$fragmentEpisode$show<TRes> get $show;
  CopyWith$Fragment$fragmentEpisode$season<TRes> get season;
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
    Iterable<Fragment$fragmentEpisode$watchStatus>? Function(
      Iterable<
        CopyWith$Fragment$fragmentEpisode$watchStatus<
          Fragment$fragmentEpisode$watchStatus
        >
      >?,
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

class _CopyWithImpl$Fragment$fragmentEpisode<TRes>
    implements CopyWith$Fragment$fragmentEpisode<TRes> {
  _CopyWithImpl$Fragment$fragmentEpisode(this._instance, this._then);

  final Fragment$fragmentEpisode _instance;

  final TRes Function(Fragment$fragmentEpisode) _then;

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
    Fragment$fragmentEpisode(
      id: id == _undefined || id == null ? _instance.id : (id as String),
      number: number == _undefined ? _instance.number : (number as int?),
      $show: $show == _undefined
          ? _instance.$show
          : ($show as Fragment$fragmentEpisode$show?),
      season: season == _undefined
          ? _instance.season
          : (season as Fragment$fragmentEpisode$season?),
      metadata: metadata == _undefined
          ? _instance.metadata
          : (metadata as List<Fragment$fragmentMetadata>?),
      images: images == _undefined
          ? _instance.images
          : (images as List<Fragment$fragmentImages>?),
      watchStatus: watchStatus == _undefined
          ? _instance.watchStatus
          : (watchStatus as List<Fragment$fragmentEpisode$watchStatus>?),
      mediaFile: mediaFile == _undefined
          ? _instance.mediaFile
          : (mediaFile as List<Fragment$fragmentMediaFiles>?),
      $__typename: $__typename == _undefined || $__typename == null
          ? _instance.$__typename
          : ($__typename as String),
    ),
  );

  CopyWith$Fragment$fragmentEpisode$show<TRes> get $show {
    final local$$show = _instance.$show;
    return local$$show == null
        ? CopyWith$Fragment$fragmentEpisode$show.stub(_then(_instance))
        : CopyWith$Fragment$fragmentEpisode$show(
            local$$show,
            (e) => call($show: e),
          );
  }

  CopyWith$Fragment$fragmentEpisode$season<TRes> get season {
    final local$season = _instance.season;
    return local$season == null
        ? CopyWith$Fragment$fragmentEpisode$season.stub(_then(_instance))
        : CopyWith$Fragment$fragmentEpisode$season(
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
    Iterable<Fragment$fragmentEpisode$watchStatus>? Function(
      Iterable<
        CopyWith$Fragment$fragmentEpisode$watchStatus<
          Fragment$fragmentEpisode$watchStatus
        >
      >?,
    )
    _fn,
  ) => call(
    watchStatus: _fn(
      _instance.watchStatus?.map(
        (e) => CopyWith$Fragment$fragmentEpisode$watchStatus(e, (i) => i),
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

class _CopyWithStubImpl$Fragment$fragmentEpisode<TRes>
    implements CopyWith$Fragment$fragmentEpisode<TRes> {
  _CopyWithStubImpl$Fragment$fragmentEpisode(this._res);

  TRes _res;

  call({
    String? id,
    int? number,
    Fragment$fragmentEpisode$show? $show,
    Fragment$fragmentEpisode$season? season,
    List<Fragment$fragmentMetadata>? metadata,
    List<Fragment$fragmentImages>? images,
    List<Fragment$fragmentEpisode$watchStatus>? watchStatus,
    List<Fragment$fragmentMediaFiles>? mediaFile,
    String? $__typename,
  }) => _res;

  CopyWith$Fragment$fragmentEpisode$show<TRes> get $show =>
      CopyWith$Fragment$fragmentEpisode$show.stub(_res);

  CopyWith$Fragment$fragmentEpisode$season<TRes> get season =>
      CopyWith$Fragment$fragmentEpisode$season.stub(_res);

  metadata(_fn) => _res;

  images(_fn) => _res;

  watchStatus(_fn) => _res;

  mediaFile(_fn) => _res;
}

const fragmentDefinitionfragmentEpisode = FragmentDefinitionNode(
  name: NameNode(value: 'fragmentEpisode'),
  typeCondition: TypeConditionNode(
    on: NamedTypeNode(name: NameNode(value: 'Episode'), isNonNull: false),
  ),
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
        name: NameNode(value: '__typename'),
        alias: null,
        arguments: [],
        directives: [],
        selectionSet: null,
      ),
    ],
  ),
);
const documentNodeFragmentfragmentEpisode = DocumentNode(
  definitions: [
    fragmentDefinitionfragmentEpisode,
    fragmentDefinitionfragmentMetadata,
    fragmentDefinitionfragmentImages,
    fragmentDefinitionfragmentMediaFiles,
  ],
);

class Fragment$fragmentEpisode$show {
  Fragment$fragmentEpisode$show({required this.id, this.$__typename = 'Show'});

  factory Fragment$fragmentEpisode$show.fromJson(Map<String, dynamic> json) {
    final l$id = json['id'];
    final l$$__typename = json['__typename'];
    return Fragment$fragmentEpisode$show(
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
    if (other is! Fragment$fragmentEpisode$show ||
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

extension UtilityExtension$Fragment$fragmentEpisode$show
    on Fragment$fragmentEpisode$show {
  CopyWith$Fragment$fragmentEpisode$show<Fragment$fragmentEpisode$show>
  get copyWith => CopyWith$Fragment$fragmentEpisode$show(this, (i) => i);
}

abstract class CopyWith$Fragment$fragmentEpisode$show<TRes> {
  factory CopyWith$Fragment$fragmentEpisode$show(
    Fragment$fragmentEpisode$show instance,
    TRes Function(Fragment$fragmentEpisode$show) then,
  ) = _CopyWithImpl$Fragment$fragmentEpisode$show;

  factory CopyWith$Fragment$fragmentEpisode$show.stub(TRes res) =
      _CopyWithStubImpl$Fragment$fragmentEpisode$show;

  TRes call({String? id, String? $__typename});
}

class _CopyWithImpl$Fragment$fragmentEpisode$show<TRes>
    implements CopyWith$Fragment$fragmentEpisode$show<TRes> {
  _CopyWithImpl$Fragment$fragmentEpisode$show(this._instance, this._then);

  final Fragment$fragmentEpisode$show _instance;

  final TRes Function(Fragment$fragmentEpisode$show) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({Object? id = _undefined, Object? $__typename = _undefined}) =>
      _then(
        Fragment$fragmentEpisode$show(
          id: id == _undefined || id == null ? _instance.id : (id as String),
          $__typename: $__typename == _undefined || $__typename == null
              ? _instance.$__typename
              : ($__typename as String),
        ),
      );
}

class _CopyWithStubImpl$Fragment$fragmentEpisode$show<TRes>
    implements CopyWith$Fragment$fragmentEpisode$show<TRes> {
  _CopyWithStubImpl$Fragment$fragmentEpisode$show(this._res);

  TRes _res;

  call({String? id, String? $__typename}) => _res;
}

class Fragment$fragmentEpisode$season {
  Fragment$fragmentEpisode$season({
    required this.id,
    this.$__typename = 'Season',
  });

  factory Fragment$fragmentEpisode$season.fromJson(Map<String, dynamic> json) {
    final l$id = json['id'];
    final l$$__typename = json['__typename'];
    return Fragment$fragmentEpisode$season(
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
    if (other is! Fragment$fragmentEpisode$season ||
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

extension UtilityExtension$Fragment$fragmentEpisode$season
    on Fragment$fragmentEpisode$season {
  CopyWith$Fragment$fragmentEpisode$season<Fragment$fragmentEpisode$season>
  get copyWith => CopyWith$Fragment$fragmentEpisode$season(this, (i) => i);
}

abstract class CopyWith$Fragment$fragmentEpisode$season<TRes> {
  factory CopyWith$Fragment$fragmentEpisode$season(
    Fragment$fragmentEpisode$season instance,
    TRes Function(Fragment$fragmentEpisode$season) then,
  ) = _CopyWithImpl$Fragment$fragmentEpisode$season;

  factory CopyWith$Fragment$fragmentEpisode$season.stub(TRes res) =
      _CopyWithStubImpl$Fragment$fragmentEpisode$season;

  TRes call({String? id, String? $__typename});
}

class _CopyWithImpl$Fragment$fragmentEpisode$season<TRes>
    implements CopyWith$Fragment$fragmentEpisode$season<TRes> {
  _CopyWithImpl$Fragment$fragmentEpisode$season(this._instance, this._then);

  final Fragment$fragmentEpisode$season _instance;

  final TRes Function(Fragment$fragmentEpisode$season) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({Object? id = _undefined, Object? $__typename = _undefined}) =>
      _then(
        Fragment$fragmentEpisode$season(
          id: id == _undefined || id == null ? _instance.id : (id as String),
          $__typename: $__typename == _undefined || $__typename == null
              ? _instance.$__typename
              : ($__typename as String),
        ),
      );
}

class _CopyWithStubImpl$Fragment$fragmentEpisode$season<TRes>
    implements CopyWith$Fragment$fragmentEpisode$season<TRes> {
  _CopyWithStubImpl$Fragment$fragmentEpisode$season(this._res);

  TRes _res;

  call({String? id, String? $__typename}) => _res;
}

class Fragment$fragmentEpisode$watchStatus {
  Fragment$fragmentEpisode$watchStatus({
    required this.id,
    required this.playQueueItemId,
    required this.progressInMilliseconds,
    required this.watched,
    this.$__typename = 'WatchStatus',
  });

  factory Fragment$fragmentEpisode$watchStatus.fromJson(
    Map<String, dynamic> json,
  ) {
    final l$id = json['id'];
    final l$playQueueItemId = json['playQueueItemId'];
    final l$progressInMilliseconds = json['progressInMilliseconds'];
    final l$watched = json['watched'];
    final l$$__typename = json['__typename'];
    return Fragment$fragmentEpisode$watchStatus(
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
    if (other is! Fragment$fragmentEpisode$watchStatus ||
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

extension UtilityExtension$Fragment$fragmentEpisode$watchStatus
    on Fragment$fragmentEpisode$watchStatus {
  CopyWith$Fragment$fragmentEpisode$watchStatus<
    Fragment$fragmentEpisode$watchStatus
  >
  get copyWith => CopyWith$Fragment$fragmentEpisode$watchStatus(this, (i) => i);
}

abstract class CopyWith$Fragment$fragmentEpisode$watchStatus<TRes> {
  factory CopyWith$Fragment$fragmentEpisode$watchStatus(
    Fragment$fragmentEpisode$watchStatus instance,
    TRes Function(Fragment$fragmentEpisode$watchStatus) then,
  ) = _CopyWithImpl$Fragment$fragmentEpisode$watchStatus;

  factory CopyWith$Fragment$fragmentEpisode$watchStatus.stub(TRes res) =
      _CopyWithStubImpl$Fragment$fragmentEpisode$watchStatus;

  TRes call({
    String? id,
    String? playQueueItemId,
    int? progressInMilliseconds,
    bool? watched,
    String? $__typename,
  });
}

class _CopyWithImpl$Fragment$fragmentEpisode$watchStatus<TRes>
    implements CopyWith$Fragment$fragmentEpisode$watchStatus<TRes> {
  _CopyWithImpl$Fragment$fragmentEpisode$watchStatus(
    this._instance,
    this._then,
  );

  final Fragment$fragmentEpisode$watchStatus _instance;

  final TRes Function(Fragment$fragmentEpisode$watchStatus) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? id = _undefined,
    Object? playQueueItemId = _undefined,
    Object? progressInMilliseconds = _undefined,
    Object? watched = _undefined,
    Object? $__typename = _undefined,
  }) => _then(
    Fragment$fragmentEpisode$watchStatus(
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

class _CopyWithStubImpl$Fragment$fragmentEpisode$watchStatus<TRes>
    implements CopyWith$Fragment$fragmentEpisode$watchStatus<TRes> {
  _CopyWithStubImpl$Fragment$fragmentEpisode$watchStatus(this._res);

  TRes _res;

  call({
    String? id,
    String? playQueueItemId,
    int? progressInMilliseconds,
    bool? watched,
    String? $__typename,
  }) => _res;
}

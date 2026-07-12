import 'fragmentMediafiles.graphql.dart';
import 'fragmentMetadata.graphql.dart';
import 'package:gql/ast.dart';

class Fragment$fragmentPodcastEpisode {
  Fragment$fragmentPodcastEpisode({
    required this.id,
    this.publishedAt,
    this.episodeNumber,
    this.seasonNumber,
    required this.downloaded,
    this.durationInMilliseconds,
    this.metadata,
    this.mediaFile,
    this.watchStatus,
    this.$__typename = 'PodcastEpisode',
  });

  factory Fragment$fragmentPodcastEpisode.fromJson(Map<String, dynamic> json) {
    final l$id = json['id'];
    final l$publishedAt = json['publishedAt'];
    final l$episodeNumber = json['episodeNumber'];
    final l$seasonNumber = json['seasonNumber'];
    final l$downloaded = json['downloaded'];
    final l$durationInMilliseconds = json['durationInMilliseconds'];
    final l$metadata = json['metadata'];
    final l$mediaFile = json['mediaFile'];
    final l$watchStatus = json['watchStatus'];
    final l$$__typename = json['__typename'];
    return Fragment$fragmentPodcastEpisode(
      id: (l$id as String),
      publishedAt: (l$publishedAt as String?),
      episodeNumber: (l$episodeNumber as int?),
      seasonNumber: (l$seasonNumber as int?),
      downloaded: (l$downloaded as bool),
      durationInMilliseconds: (l$durationInMilliseconds as int?),
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
      watchStatus: (l$watchStatus as List<dynamic>?)
          ?.map(
            (e) => Fragment$fragmentPodcastEpisode$watchStatus.fromJson(
              (e as Map<String, dynamic>),
            ),
          )
          .toList(),
      $__typename: (l$$__typename as String),
    );
  }

  final String id;

  final String? publishedAt;

  final int? episodeNumber;

  final int? seasonNumber;

  final bool downloaded;

  final int? durationInMilliseconds;

  final List<Fragment$fragmentMetadata>? metadata;

  final List<Fragment$fragmentMediaFiles>? mediaFile;

  final List<Fragment$fragmentPodcastEpisode$watchStatus>? watchStatus;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$id = id;
    _resultData['id'] = l$id;
    final l$publishedAt = publishedAt;
    _resultData['publishedAt'] = l$publishedAt;
    final l$episodeNumber = episodeNumber;
    _resultData['episodeNumber'] = l$episodeNumber;
    final l$seasonNumber = seasonNumber;
    _resultData['seasonNumber'] = l$seasonNumber;
    final l$downloaded = downloaded;
    _resultData['downloaded'] = l$downloaded;
    final l$durationInMilliseconds = durationInMilliseconds;
    _resultData['durationInMilliseconds'] = l$durationInMilliseconds;
    final l$metadata = metadata;
    _resultData['metadata'] = l$metadata?.map((e) => e.toJson()).toList();
    final l$mediaFile = mediaFile;
    _resultData['mediaFile'] = l$mediaFile?.map((e) => e.toJson()).toList();
    final l$watchStatus = watchStatus;
    _resultData['watchStatus'] = l$watchStatus?.map((e) => e.toJson()).toList();
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$id = id;
    final l$publishedAt = publishedAt;
    final l$episodeNumber = episodeNumber;
    final l$seasonNumber = seasonNumber;
    final l$downloaded = downloaded;
    final l$durationInMilliseconds = durationInMilliseconds;
    final l$metadata = metadata;
    final l$mediaFile = mediaFile;
    final l$watchStatus = watchStatus;
    final l$$__typename = $__typename;
    return Object.hashAll([
      l$id,
      l$publishedAt,
      l$episodeNumber,
      l$seasonNumber,
      l$downloaded,
      l$durationInMilliseconds,
      l$metadata == null ? null : Object.hashAll(l$metadata.map((v) => v)),
      l$mediaFile == null ? null : Object.hashAll(l$mediaFile.map((v) => v)),
      l$watchStatus == null
          ? null
          : Object.hashAll(l$watchStatus.map((v) => v)),
      l$$__typename,
    ]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Fragment$fragmentPodcastEpisode ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$id = id;
    final lOther$id = other.id;
    if (l$id != lOther$id) {
      return false;
    }
    final l$publishedAt = publishedAt;
    final lOther$publishedAt = other.publishedAt;
    if (l$publishedAt != lOther$publishedAt) {
      return false;
    }
    final l$episodeNumber = episodeNumber;
    final lOther$episodeNumber = other.episodeNumber;
    if (l$episodeNumber != lOther$episodeNumber) {
      return false;
    }
    final l$seasonNumber = seasonNumber;
    final lOther$seasonNumber = other.seasonNumber;
    if (l$seasonNumber != lOther$seasonNumber) {
      return false;
    }
    final l$downloaded = downloaded;
    final lOther$downloaded = other.downloaded;
    if (l$downloaded != lOther$downloaded) {
      return false;
    }
    final l$durationInMilliseconds = durationInMilliseconds;
    final lOther$durationInMilliseconds = other.durationInMilliseconds;
    if (l$durationInMilliseconds != lOther$durationInMilliseconds) {
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
    final l$$__typename = $__typename;
    final lOther$$__typename = other.$__typename;
    if (l$$__typename != lOther$$__typename) {
      return false;
    }
    return true;
  }
}

extension UtilityExtension$Fragment$fragmentPodcastEpisode
    on Fragment$fragmentPodcastEpisode {
  CopyWith$Fragment$fragmentPodcastEpisode<Fragment$fragmentPodcastEpisode>
  get copyWith => CopyWith$Fragment$fragmentPodcastEpisode(this, (i) => i);
}

abstract class CopyWith$Fragment$fragmentPodcastEpisode<TRes> {
  factory CopyWith$Fragment$fragmentPodcastEpisode(
    Fragment$fragmentPodcastEpisode instance,
    TRes Function(Fragment$fragmentPodcastEpisode) then,
  ) = _CopyWithImpl$Fragment$fragmentPodcastEpisode;

  factory CopyWith$Fragment$fragmentPodcastEpisode.stub(TRes res) =
      _CopyWithStubImpl$Fragment$fragmentPodcastEpisode;

  TRes call({
    String? id,
    String? publishedAt,
    int? episodeNumber,
    int? seasonNumber,
    bool? downloaded,
    int? durationInMilliseconds,
    List<Fragment$fragmentMetadata>? metadata,
    List<Fragment$fragmentMediaFiles>? mediaFile,
    List<Fragment$fragmentPodcastEpisode$watchStatus>? watchStatus,
    String? $__typename,
  });
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
  TRes watchStatus(
    Iterable<Fragment$fragmentPodcastEpisode$watchStatus>? Function(
      Iterable<
        CopyWith$Fragment$fragmentPodcastEpisode$watchStatus<
          Fragment$fragmentPodcastEpisode$watchStatus
        >
      >?,
    )
    _fn,
  );
}

class _CopyWithImpl$Fragment$fragmentPodcastEpisode<TRes>
    implements CopyWith$Fragment$fragmentPodcastEpisode<TRes> {
  _CopyWithImpl$Fragment$fragmentPodcastEpisode(this._instance, this._then);

  final Fragment$fragmentPodcastEpisode _instance;

  final TRes Function(Fragment$fragmentPodcastEpisode) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? id = _undefined,
    Object? publishedAt = _undefined,
    Object? episodeNumber = _undefined,
    Object? seasonNumber = _undefined,
    Object? downloaded = _undefined,
    Object? durationInMilliseconds = _undefined,
    Object? metadata = _undefined,
    Object? mediaFile = _undefined,
    Object? watchStatus = _undefined,
    Object? $__typename = _undefined,
  }) => _then(
    Fragment$fragmentPodcastEpisode(
      id: id == _undefined || id == null ? _instance.id : (id as String),
      publishedAt: publishedAt == _undefined
          ? _instance.publishedAt
          : (publishedAt as String?),
      episodeNumber: episodeNumber == _undefined
          ? _instance.episodeNumber
          : (episodeNumber as int?),
      seasonNumber: seasonNumber == _undefined
          ? _instance.seasonNumber
          : (seasonNumber as int?),
      downloaded: downloaded == _undefined || downloaded == null
          ? _instance.downloaded
          : (downloaded as bool),
      durationInMilliseconds: durationInMilliseconds == _undefined
          ? _instance.durationInMilliseconds
          : (durationInMilliseconds as int?),
      metadata: metadata == _undefined
          ? _instance.metadata
          : (metadata as List<Fragment$fragmentMetadata>?),
      mediaFile: mediaFile == _undefined
          ? _instance.mediaFile
          : (mediaFile as List<Fragment$fragmentMediaFiles>?),
      watchStatus: watchStatus == _undefined
          ? _instance.watchStatus
          : (watchStatus as List<Fragment$fragmentPodcastEpisode$watchStatus>?),
      $__typename: $__typename == _undefined || $__typename == null
          ? _instance.$__typename
          : ($__typename as String),
    ),
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

  TRes watchStatus(
    Iterable<Fragment$fragmentPodcastEpisode$watchStatus>? Function(
      Iterable<
        CopyWith$Fragment$fragmentPodcastEpisode$watchStatus<
          Fragment$fragmentPodcastEpisode$watchStatus
        >
      >?,
    )
    _fn,
  ) => call(
    watchStatus: _fn(
      _instance.watchStatus?.map(
        (e) =>
            CopyWith$Fragment$fragmentPodcastEpisode$watchStatus(e, (i) => i),
      ),
    )?.toList(),
  );
}

class _CopyWithStubImpl$Fragment$fragmentPodcastEpisode<TRes>
    implements CopyWith$Fragment$fragmentPodcastEpisode<TRes> {
  _CopyWithStubImpl$Fragment$fragmentPodcastEpisode(this._res);

  TRes _res;

  call({
    String? id,
    String? publishedAt,
    int? episodeNumber,
    int? seasonNumber,
    bool? downloaded,
    int? durationInMilliseconds,
    List<Fragment$fragmentMetadata>? metadata,
    List<Fragment$fragmentMediaFiles>? mediaFile,
    List<Fragment$fragmentPodcastEpisode$watchStatus>? watchStatus,
    String? $__typename,
  }) => _res;

  metadata(_fn) => _res;

  mediaFile(_fn) => _res;

  watchStatus(_fn) => _res;
}

const fragmentDefinitionfragmentPodcastEpisode = FragmentDefinitionNode(
  name: NameNode(value: 'fragmentPodcastEpisode'),
  typeCondition: TypeConditionNode(
    on: NamedTypeNode(
      name: NameNode(value: 'PodcastEpisode'),
      isNonNull: false,
    ),
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
        name: NameNode(value: 'publishedAt'),
        alias: null,
        arguments: [],
        directives: [],
        selectionSet: null,
      ),
      FieldNode(
        name: NameNode(value: 'episodeNumber'),
        alias: null,
        arguments: [],
        directives: [],
        selectionSet: null,
      ),
      FieldNode(
        name: NameNode(value: 'seasonNumber'),
        alias: null,
        arguments: [],
        directives: [],
        selectionSet: null,
      ),
      FieldNode(
        name: NameNode(value: 'downloaded'),
        alias: null,
        arguments: [],
        directives: [],
        selectionSet: null,
      ),
      FieldNode(
        name: NameNode(value: 'durationInMilliseconds'),
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
        name: NameNode(value: '__typename'),
        alias: null,
        arguments: [],
        directives: [],
        selectionSet: null,
      ),
    ],
  ),
);
const documentNodeFragmentfragmentPodcastEpisode = DocumentNode(
  definitions: [
    fragmentDefinitionfragmentPodcastEpisode,
    fragmentDefinitionfragmentMetadata,
    fragmentDefinitionfragmentMediaFiles,
  ],
);

class Fragment$fragmentPodcastEpisode$watchStatus {
  Fragment$fragmentPodcastEpisode$watchStatus({
    required this.id,
    required this.playQueueItemId,
    required this.progressInMilliseconds,
    required this.watched,
    this.$__typename = 'WatchStatus',
  });

  factory Fragment$fragmentPodcastEpisode$watchStatus.fromJson(
    Map<String, dynamic> json,
  ) {
    final l$id = json['id'];
    final l$playQueueItemId = json['playQueueItemId'];
    final l$progressInMilliseconds = json['progressInMilliseconds'];
    final l$watched = json['watched'];
    final l$$__typename = json['__typename'];
    return Fragment$fragmentPodcastEpisode$watchStatus(
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
    if (other is! Fragment$fragmentPodcastEpisode$watchStatus ||
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

extension UtilityExtension$Fragment$fragmentPodcastEpisode$watchStatus
    on Fragment$fragmentPodcastEpisode$watchStatus {
  CopyWith$Fragment$fragmentPodcastEpisode$watchStatus<
    Fragment$fragmentPodcastEpisode$watchStatus
  >
  get copyWith =>
      CopyWith$Fragment$fragmentPodcastEpisode$watchStatus(this, (i) => i);
}

abstract class CopyWith$Fragment$fragmentPodcastEpisode$watchStatus<TRes> {
  factory CopyWith$Fragment$fragmentPodcastEpisode$watchStatus(
    Fragment$fragmentPodcastEpisode$watchStatus instance,
    TRes Function(Fragment$fragmentPodcastEpisode$watchStatus) then,
  ) = _CopyWithImpl$Fragment$fragmentPodcastEpisode$watchStatus;

  factory CopyWith$Fragment$fragmentPodcastEpisode$watchStatus.stub(TRes res) =
      _CopyWithStubImpl$Fragment$fragmentPodcastEpisode$watchStatus;

  TRes call({
    String? id,
    String? playQueueItemId,
    int? progressInMilliseconds,
    bool? watched,
    String? $__typename,
  });
}

class _CopyWithImpl$Fragment$fragmentPodcastEpisode$watchStatus<TRes>
    implements CopyWith$Fragment$fragmentPodcastEpisode$watchStatus<TRes> {
  _CopyWithImpl$Fragment$fragmentPodcastEpisode$watchStatus(
    this._instance,
    this._then,
  );

  final Fragment$fragmentPodcastEpisode$watchStatus _instance;

  final TRes Function(Fragment$fragmentPodcastEpisode$watchStatus) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? id = _undefined,
    Object? playQueueItemId = _undefined,
    Object? progressInMilliseconds = _undefined,
    Object? watched = _undefined,
    Object? $__typename = _undefined,
  }) => _then(
    Fragment$fragmentPodcastEpisode$watchStatus(
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

class _CopyWithStubImpl$Fragment$fragmentPodcastEpisode$watchStatus<TRes>
    implements CopyWith$Fragment$fragmentPodcastEpisode$watchStatus<TRes> {
  _CopyWithStubImpl$Fragment$fragmentPodcastEpisode$watchStatus(this._res);

  TRes _res;

  call({
    String? id,
    String? playQueueItemId,
    int? progressInMilliseconds,
    bool? watched,
    String? $__typename,
  }) => _res;
}

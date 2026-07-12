import 'fragmentMetadata.graphql.dart';
import 'package:gql/ast.dart';

class Fragment$fragmentChapter {
  Fragment$fragmentChapter({
    required this.id,
    required this.number,
    this.metadata,
    this.mediaFile,
    this.watchStatus,
    this.$__typename = 'Chapter',
  });

  factory Fragment$fragmentChapter.fromJson(Map<String, dynamic> json) {
    final l$id = json['id'];
    final l$number = json['number'];
    final l$metadata = json['metadata'];
    final l$mediaFile = json['mediaFile'];
    final l$watchStatus = json['watchStatus'];
    final l$$__typename = json['__typename'];
    return Fragment$fragmentChapter(
      id: (l$id as String),
      number: (l$number as int),
      metadata: (l$metadata as List<dynamic>?)
          ?.map(
            (e) =>
                Fragment$fragmentMetadata.fromJson((e as Map<String, dynamic>)),
          )
          .toList(),
      mediaFile: (l$mediaFile as List<dynamic>?)
          ?.map(
            (e) => Fragment$fragmentChapter$mediaFile.fromJson(
              (e as Map<String, dynamic>),
            ),
          )
          .toList(),
      watchStatus: (l$watchStatus as List<dynamic>?)
          ?.map(
            (e) => Fragment$fragmentChapter$watchStatus.fromJson(
              (e as Map<String, dynamic>),
            ),
          )
          .toList(),
      $__typename: (l$$__typename as String),
    );
  }

  final String id;

  final int number;

  final List<Fragment$fragmentMetadata>? metadata;

  final List<Fragment$fragmentChapter$mediaFile>? mediaFile;

  final List<Fragment$fragmentChapter$watchStatus>? watchStatus;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$id = id;
    _resultData['id'] = l$id;
    final l$number = number;
    _resultData['number'] = l$number;
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
    final l$number = number;
    final l$metadata = metadata;
    final l$mediaFile = mediaFile;
    final l$watchStatus = watchStatus;
    final l$$__typename = $__typename;
    return Object.hashAll([
      l$id,
      l$number,
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
    if (other is! Fragment$fragmentChapter ||
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

extension UtilityExtension$Fragment$fragmentChapter
    on Fragment$fragmentChapter {
  CopyWith$Fragment$fragmentChapter<Fragment$fragmentChapter> get copyWith =>
      CopyWith$Fragment$fragmentChapter(this, (i) => i);
}

abstract class CopyWith$Fragment$fragmentChapter<TRes> {
  factory CopyWith$Fragment$fragmentChapter(
    Fragment$fragmentChapter instance,
    TRes Function(Fragment$fragmentChapter) then,
  ) = _CopyWithImpl$Fragment$fragmentChapter;

  factory CopyWith$Fragment$fragmentChapter.stub(TRes res) =
      _CopyWithStubImpl$Fragment$fragmentChapter;

  TRes call({
    String? id,
    int? number,
    List<Fragment$fragmentMetadata>? metadata,
    List<Fragment$fragmentChapter$mediaFile>? mediaFile,
    List<Fragment$fragmentChapter$watchStatus>? watchStatus,
    String? $__typename,
  });
  TRes metadata(
    Iterable<Fragment$fragmentMetadata>? Function(
      Iterable<CopyWith$Fragment$fragmentMetadata<Fragment$fragmentMetadata>>?,
    )
    _fn,
  );
  TRes mediaFile(
    Iterable<Fragment$fragmentChapter$mediaFile>? Function(
      Iterable<
        CopyWith$Fragment$fragmentChapter$mediaFile<
          Fragment$fragmentChapter$mediaFile
        >
      >?,
    )
    _fn,
  );
  TRes watchStatus(
    Iterable<Fragment$fragmentChapter$watchStatus>? Function(
      Iterable<
        CopyWith$Fragment$fragmentChapter$watchStatus<
          Fragment$fragmentChapter$watchStatus
        >
      >?,
    )
    _fn,
  );
}

class _CopyWithImpl$Fragment$fragmentChapter<TRes>
    implements CopyWith$Fragment$fragmentChapter<TRes> {
  _CopyWithImpl$Fragment$fragmentChapter(this._instance, this._then);

  final Fragment$fragmentChapter _instance;

  final TRes Function(Fragment$fragmentChapter) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? id = _undefined,
    Object? number = _undefined,
    Object? metadata = _undefined,
    Object? mediaFile = _undefined,
    Object? watchStatus = _undefined,
    Object? $__typename = _undefined,
  }) => _then(
    Fragment$fragmentChapter(
      id: id == _undefined || id == null ? _instance.id : (id as String),
      number: number == _undefined || number == null
          ? _instance.number
          : (number as int),
      metadata: metadata == _undefined
          ? _instance.metadata
          : (metadata as List<Fragment$fragmentMetadata>?),
      mediaFile: mediaFile == _undefined
          ? _instance.mediaFile
          : (mediaFile as List<Fragment$fragmentChapter$mediaFile>?),
      watchStatus: watchStatus == _undefined
          ? _instance.watchStatus
          : (watchStatus as List<Fragment$fragmentChapter$watchStatus>?),
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
    Iterable<Fragment$fragmentChapter$mediaFile>? Function(
      Iterable<
        CopyWith$Fragment$fragmentChapter$mediaFile<
          Fragment$fragmentChapter$mediaFile
        >
      >?,
    )
    _fn,
  ) => call(
    mediaFile: _fn(
      _instance.mediaFile?.map(
        (e) => CopyWith$Fragment$fragmentChapter$mediaFile(e, (i) => i),
      ),
    )?.toList(),
  );

  TRes watchStatus(
    Iterable<Fragment$fragmentChapter$watchStatus>? Function(
      Iterable<
        CopyWith$Fragment$fragmentChapter$watchStatus<
          Fragment$fragmentChapter$watchStatus
        >
      >?,
    )
    _fn,
  ) => call(
    watchStatus: _fn(
      _instance.watchStatus?.map(
        (e) => CopyWith$Fragment$fragmentChapter$watchStatus(e, (i) => i),
      ),
    )?.toList(),
  );
}

class _CopyWithStubImpl$Fragment$fragmentChapter<TRes>
    implements CopyWith$Fragment$fragmentChapter<TRes> {
  _CopyWithStubImpl$Fragment$fragmentChapter(this._res);

  TRes _res;

  call({
    String? id,
    int? number,
    List<Fragment$fragmentMetadata>? metadata,
    List<Fragment$fragmentChapter$mediaFile>? mediaFile,
    List<Fragment$fragmentChapter$watchStatus>? watchStatus,
    String? $__typename,
  }) => _res;

  metadata(_fn) => _res;

  mediaFile(_fn) => _res;

  watchStatus(_fn) => _res;
}

const fragmentDefinitionfragmentChapter = FragmentDefinitionNode(
  name: NameNode(value: 'fragmentChapter'),
  typeCondition: TypeConditionNode(
    on: NamedTypeNode(name: NameNode(value: 'Chapter'), isNonNull: false),
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
const documentNodeFragmentfragmentChapter = DocumentNode(
  definitions: [
    fragmentDefinitionfragmentChapter,
    fragmentDefinitionfragmentMetadata,
  ],
);

class Fragment$fragmentChapter$mediaFile {
  Fragment$fragmentChapter$mediaFile({
    this.durationInMilliseconds,
    this.$__typename = 'MediaFile',
  });

  factory Fragment$fragmentChapter$mediaFile.fromJson(
    Map<String, dynamic> json,
  ) {
    final l$durationInMilliseconds = json['durationInMilliseconds'];
    final l$$__typename = json['__typename'];
    return Fragment$fragmentChapter$mediaFile(
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
    if (other is! Fragment$fragmentChapter$mediaFile ||
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

extension UtilityExtension$Fragment$fragmentChapter$mediaFile
    on Fragment$fragmentChapter$mediaFile {
  CopyWith$Fragment$fragmentChapter$mediaFile<
    Fragment$fragmentChapter$mediaFile
  >
  get copyWith => CopyWith$Fragment$fragmentChapter$mediaFile(this, (i) => i);
}

abstract class CopyWith$Fragment$fragmentChapter$mediaFile<TRes> {
  factory CopyWith$Fragment$fragmentChapter$mediaFile(
    Fragment$fragmentChapter$mediaFile instance,
    TRes Function(Fragment$fragmentChapter$mediaFile) then,
  ) = _CopyWithImpl$Fragment$fragmentChapter$mediaFile;

  factory CopyWith$Fragment$fragmentChapter$mediaFile.stub(TRes res) =
      _CopyWithStubImpl$Fragment$fragmentChapter$mediaFile;

  TRes call({int? durationInMilliseconds, String? $__typename});
}

class _CopyWithImpl$Fragment$fragmentChapter$mediaFile<TRes>
    implements CopyWith$Fragment$fragmentChapter$mediaFile<TRes> {
  _CopyWithImpl$Fragment$fragmentChapter$mediaFile(this._instance, this._then);

  final Fragment$fragmentChapter$mediaFile _instance;

  final TRes Function(Fragment$fragmentChapter$mediaFile) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? durationInMilliseconds = _undefined,
    Object? $__typename = _undefined,
  }) => _then(
    Fragment$fragmentChapter$mediaFile(
      durationInMilliseconds: durationInMilliseconds == _undefined
          ? _instance.durationInMilliseconds
          : (durationInMilliseconds as int?),
      $__typename: $__typename == _undefined || $__typename == null
          ? _instance.$__typename
          : ($__typename as String),
    ),
  );
}

class _CopyWithStubImpl$Fragment$fragmentChapter$mediaFile<TRes>
    implements CopyWith$Fragment$fragmentChapter$mediaFile<TRes> {
  _CopyWithStubImpl$Fragment$fragmentChapter$mediaFile(this._res);

  TRes _res;

  call({int? durationInMilliseconds, String? $__typename}) => _res;
}

class Fragment$fragmentChapter$watchStatus {
  Fragment$fragmentChapter$watchStatus({
    required this.id,
    required this.playQueueItemId,
    required this.progressInMilliseconds,
    required this.watched,
    this.$__typename = 'WatchStatus',
  });

  factory Fragment$fragmentChapter$watchStatus.fromJson(
    Map<String, dynamic> json,
  ) {
    final l$id = json['id'];
    final l$playQueueItemId = json['playQueueItemId'];
    final l$progressInMilliseconds = json['progressInMilliseconds'];
    final l$watched = json['watched'];
    final l$$__typename = json['__typename'];
    return Fragment$fragmentChapter$watchStatus(
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
    if (other is! Fragment$fragmentChapter$watchStatus ||
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

extension UtilityExtension$Fragment$fragmentChapter$watchStatus
    on Fragment$fragmentChapter$watchStatus {
  CopyWith$Fragment$fragmentChapter$watchStatus<
    Fragment$fragmentChapter$watchStatus
  >
  get copyWith => CopyWith$Fragment$fragmentChapter$watchStatus(this, (i) => i);
}

abstract class CopyWith$Fragment$fragmentChapter$watchStatus<TRes> {
  factory CopyWith$Fragment$fragmentChapter$watchStatus(
    Fragment$fragmentChapter$watchStatus instance,
    TRes Function(Fragment$fragmentChapter$watchStatus) then,
  ) = _CopyWithImpl$Fragment$fragmentChapter$watchStatus;

  factory CopyWith$Fragment$fragmentChapter$watchStatus.stub(TRes res) =
      _CopyWithStubImpl$Fragment$fragmentChapter$watchStatus;

  TRes call({
    String? id,
    String? playQueueItemId,
    int? progressInMilliseconds,
    bool? watched,
    String? $__typename,
  });
}

class _CopyWithImpl$Fragment$fragmentChapter$watchStatus<TRes>
    implements CopyWith$Fragment$fragmentChapter$watchStatus<TRes> {
  _CopyWithImpl$Fragment$fragmentChapter$watchStatus(
    this._instance,
    this._then,
  );

  final Fragment$fragmentChapter$watchStatus _instance;

  final TRes Function(Fragment$fragmentChapter$watchStatus) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? id = _undefined,
    Object? playQueueItemId = _undefined,
    Object? progressInMilliseconds = _undefined,
    Object? watched = _undefined,
    Object? $__typename = _undefined,
  }) => _then(
    Fragment$fragmentChapter$watchStatus(
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

class _CopyWithStubImpl$Fragment$fragmentChapter$watchStatus<TRes>
    implements CopyWith$Fragment$fragmentChapter$watchStatus<TRes> {
  _CopyWithStubImpl$Fragment$fragmentChapter$watchStatus(this._res);

  TRes _res;

  call({
    String? id,
    String? playQueueItemId,
    int? progressInMilliseconds,
    bool? watched,
    String? $__typename,
  }) => _res;
}

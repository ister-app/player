import 'package:gql/ast.dart';

import 'schema.graphql.dart';

class Fragment$fragmentQueueStat {
  Fragment$fragmentQueueStat({
    required this.queue,
    required this.depth,
    required this.consumers,
    this.$__typename = 'QueueStat',
  });

  factory Fragment$fragmentQueueStat.fromJson(Map<String, dynamic> json) {
    final l$queue = json['queue'];
    final l$depth = json['depth'];
    final l$consumers = json['consumers'];
    final l$$__typename = json['__typename'];
    return Fragment$fragmentQueueStat(
      queue: (l$queue as String),
      depth: (l$depth as int),
      consumers: (l$consumers as int),
      $__typename: (l$$__typename as String),
    );
  }

  final String queue;

  final int depth;

  final int consumers;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$queue = queue;
    _resultData['queue'] = l$queue;
    final l$depth = depth;
    _resultData['depth'] = l$depth;
    final l$consumers = consumers;
    _resultData['consumers'] = l$consumers;
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$queue = queue;
    final l$depth = depth;
    final l$consumers = consumers;
    final l$$__typename = $__typename;
    return Object.hashAll([l$queue, l$depth, l$consumers, l$$__typename]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Fragment$fragmentQueueStat ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$queue = queue;
    final lOther$queue = other.queue;
    if (l$queue != lOther$queue) {
      return false;
    }
    final l$depth = depth;
    final lOther$depth = other.depth;
    if (l$depth != lOther$depth) {
      return false;
    }
    final l$consumers = consumers;
    final lOther$consumers = other.consumers;
    if (l$consumers != lOther$consumers) {
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

extension UtilityExtension$Fragment$fragmentQueueStat
    on Fragment$fragmentQueueStat {
  CopyWith$Fragment$fragmentQueueStat<Fragment$fragmentQueueStat>
  get copyWith => CopyWith$Fragment$fragmentQueueStat(this, (i) => i);
}

abstract class CopyWith$Fragment$fragmentQueueStat<TRes> {
  factory CopyWith$Fragment$fragmentQueueStat(
    Fragment$fragmentQueueStat instance,
    TRes Function(Fragment$fragmentQueueStat) then,
  ) = _CopyWithImpl$Fragment$fragmentQueueStat;

  factory CopyWith$Fragment$fragmentQueueStat.stub(TRes res) =
      _CopyWithStubImpl$Fragment$fragmentQueueStat;

  TRes call({String? queue, int? depth, int? consumers, String? $__typename});
}

class _CopyWithImpl$Fragment$fragmentQueueStat<TRes>
    implements CopyWith$Fragment$fragmentQueueStat<TRes> {
  _CopyWithImpl$Fragment$fragmentQueueStat(this._instance, this._then);

  final Fragment$fragmentQueueStat _instance;

  final TRes Function(Fragment$fragmentQueueStat) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? queue = _undefined,
    Object? depth = _undefined,
    Object? consumers = _undefined,
    Object? $__typename = _undefined,
  }) => _then(
    Fragment$fragmentQueueStat(
      queue: queue == _undefined || queue == null
          ? _instance.queue
          : (queue as String),
      depth: depth == _undefined || depth == null
          ? _instance.depth
          : (depth as int),
      consumers: consumers == _undefined || consumers == null
          ? _instance.consumers
          : (consumers as int),
      $__typename: $__typename == _undefined || $__typename == null
          ? _instance.$__typename
          : ($__typename as String),
    ),
  );
}

class _CopyWithStubImpl$Fragment$fragmentQueueStat<TRes>
    implements CopyWith$Fragment$fragmentQueueStat<TRes> {
  _CopyWithStubImpl$Fragment$fragmentQueueStat(this._res);

  TRes _res;

  call({String? queue, int? depth, int? consumers, String? $__typename}) =>
      _res;
}

const fragmentDefinitionfragmentQueueStat = FragmentDefinitionNode(
  name: NameNode(value: 'fragmentQueueStat'),
  typeCondition: TypeConditionNode(
    on: NamedTypeNode(name: NameNode(value: 'QueueStat'), isNonNull: false),
  ),
  directives: [],
  selectionSet: SelectionSetNode(
    selections: [
      FieldNode(
        name: NameNode(value: 'queue'),
        alias: null,
        arguments: [],
        directives: [],
        selectionSet: null,
      ),
      FieldNode(
        name: NameNode(value: 'depth'),
        alias: null,
        arguments: [],
        directives: [],
        selectionSet: null,
      ),
      FieldNode(
        name: NameNode(value: 'consumers'),
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
);
const documentNodeFragmentfragmentQueueStat = DocumentNode(
  definitions: [fragmentDefinitionfragmentQueueStat],
);

class Fragment$fragmentEventFailure {
  Fragment$fragmentEventFailure({
    required this.nodeName,
    required this.queue,
    this.eventType,
    this.errorMessage,
    required this.occurredAt,
    this.$__typename = 'EventFailure',
  });

  factory Fragment$fragmentEventFailure.fromJson(Map<String, dynamic> json) {
    final l$nodeName = json['nodeName'];
    final l$queue = json['queue'];
    final l$eventType = json['eventType'];
    final l$errorMessage = json['errorMessage'];
    final l$occurredAt = json['occurredAt'];
    final l$$__typename = json['__typename'];
    return Fragment$fragmentEventFailure(
      nodeName: (l$nodeName as String),
      queue: (l$queue as String),
      eventType: (l$eventType as String?),
      errorMessage: (l$errorMessage as String?),
      occurredAt: (l$occurredAt as String),
      $__typename: (l$$__typename as String),
    );
  }

  final String nodeName;

  final String queue;

  final String? eventType;

  final String? errorMessage;

  final String occurredAt;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$nodeName = nodeName;
    _resultData['nodeName'] = l$nodeName;
    final l$queue = queue;
    _resultData['queue'] = l$queue;
    final l$eventType = eventType;
    _resultData['eventType'] = l$eventType;
    final l$errorMessage = errorMessage;
    _resultData['errorMessage'] = l$errorMessage;
    final l$occurredAt = occurredAt;
    _resultData['occurredAt'] = l$occurredAt;
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$nodeName = nodeName;
    final l$queue = queue;
    final l$eventType = eventType;
    final l$errorMessage = errorMessage;
    final l$occurredAt = occurredAt;
    final l$$__typename = $__typename;
    return Object.hashAll([
      l$nodeName,
      l$queue,
      l$eventType,
      l$errorMessage,
      l$occurredAt,
      l$$__typename,
    ]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Fragment$fragmentEventFailure ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$nodeName = nodeName;
    final lOther$nodeName = other.nodeName;
    if (l$nodeName != lOther$nodeName) {
      return false;
    }
    final l$queue = queue;
    final lOther$queue = other.queue;
    if (l$queue != lOther$queue) {
      return false;
    }
    final l$eventType = eventType;
    final lOther$eventType = other.eventType;
    if (l$eventType != lOther$eventType) {
      return false;
    }
    final l$errorMessage = errorMessage;
    final lOther$errorMessage = other.errorMessage;
    if (l$errorMessage != lOther$errorMessage) {
      return false;
    }
    final l$occurredAt = occurredAt;
    final lOther$occurredAt = other.occurredAt;
    if (l$occurredAt != lOther$occurredAt) {
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

extension UtilityExtension$Fragment$fragmentEventFailure
    on Fragment$fragmentEventFailure {
  CopyWith$Fragment$fragmentEventFailure<Fragment$fragmentEventFailure>
  get copyWith => CopyWith$Fragment$fragmentEventFailure(this, (i) => i);
}

abstract class CopyWith$Fragment$fragmentEventFailure<TRes> {
  factory CopyWith$Fragment$fragmentEventFailure(
    Fragment$fragmentEventFailure instance,
    TRes Function(Fragment$fragmentEventFailure) then,
  ) = _CopyWithImpl$Fragment$fragmentEventFailure;

  factory CopyWith$Fragment$fragmentEventFailure.stub(TRes res) =
      _CopyWithStubImpl$Fragment$fragmentEventFailure;

  TRes call({
    String? nodeName,
    String? queue,
    String? eventType,
    String? errorMessage,
    String? occurredAt,
    String? $__typename,
  });
}

class _CopyWithImpl$Fragment$fragmentEventFailure<TRes>
    implements CopyWith$Fragment$fragmentEventFailure<TRes> {
  _CopyWithImpl$Fragment$fragmentEventFailure(this._instance, this._then);

  final Fragment$fragmentEventFailure _instance;

  final TRes Function(Fragment$fragmentEventFailure) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? nodeName = _undefined,
    Object? queue = _undefined,
    Object? eventType = _undefined,
    Object? errorMessage = _undefined,
    Object? occurredAt = _undefined,
    Object? $__typename = _undefined,
  }) => _then(
    Fragment$fragmentEventFailure(
      nodeName: nodeName == _undefined || nodeName == null
          ? _instance.nodeName
          : (nodeName as String),
      queue: queue == _undefined || queue == null
          ? _instance.queue
          : (queue as String),
      eventType: eventType == _undefined
          ? _instance.eventType
          : (eventType as String?),
      errorMessage: errorMessage == _undefined
          ? _instance.errorMessage
          : (errorMessage as String?),
      occurredAt: occurredAt == _undefined || occurredAt == null
          ? _instance.occurredAt
          : (occurredAt as String),
      $__typename: $__typename == _undefined || $__typename == null
          ? _instance.$__typename
          : ($__typename as String),
    ),
  );
}

class _CopyWithStubImpl$Fragment$fragmentEventFailure<TRes>
    implements CopyWith$Fragment$fragmentEventFailure<TRes> {
  _CopyWithStubImpl$Fragment$fragmentEventFailure(this._res);

  TRes _res;

  call({
    String? nodeName,
    String? queue,
    String? eventType,
    String? errorMessage,
    String? occurredAt,
    String? $__typename,
  }) => _res;
}

const fragmentDefinitionfragmentEventFailure = FragmentDefinitionNode(
  name: NameNode(value: 'fragmentEventFailure'),
  typeCondition: TypeConditionNode(
    on: NamedTypeNode(name: NameNode(value: 'EventFailure'), isNonNull: false),
  ),
  directives: [],
  selectionSet: SelectionSetNode(
    selections: [
      FieldNode(
        name: NameNode(value: 'nodeName'),
        alias: null,
        arguments: [],
        directives: [],
        selectionSet: null,
      ),
      FieldNode(
        name: NameNode(value: 'queue'),
        alias: null,
        arguments: [],
        directives: [],
        selectionSet: null,
      ),
      FieldNode(
        name: NameNode(value: 'eventType'),
        alias: null,
        arguments: [],
        directives: [],
        selectionSet: null,
      ),
      FieldNode(
        name: NameNode(value: 'errorMessage'),
        alias: null,
        arguments: [],
        directives: [],
        selectionSet: null,
      ),
      FieldNode(
        name: NameNode(value: 'occurredAt'),
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
);
const documentNodeFragmentfragmentEventFailure = DocumentNode(
  definitions: [fragmentDefinitionfragmentEventFailure],
);

class Fragment$fragmentTranscodePass {
  Fragment$fragmentTranscodePass({
    required this.nodeName,
    required this.mediaFileId,
    this.title,
    required this.quality,
    required this.background,
    required this.startedAt,
    this.context,
    this.contextType,
    this.contextId,
    this.$__typename = 'TranscodePass',
  });

  factory Fragment$fragmentTranscodePass.fromJson(Map<String, dynamic> json) {
    final l$nodeName = json['nodeName'];
    final l$mediaFileId = json['mediaFileId'];
    final l$title = json['title'];
    final l$quality = json['quality'];
    final l$background = json['background'];
    final l$startedAt = json['startedAt'];
    final l$context = json['context'];
    final l$contextType = json['contextType'];
    final l$contextId = json['contextId'];
    final l$$__typename = json['__typename'];
    return Fragment$fragmentTranscodePass(
      nodeName: (l$nodeName as String),
      mediaFileId: (l$mediaFileId as String),
      title: (l$title as String?),
      quality: (l$quality as String),
      background: (l$background as bool),
      startedAt: (l$startedAt as String),
      context: (l$context as String?),
      contextType: (l$contextType as String?),
      contextId: (l$contextId as String?),
      $__typename: (l$$__typename as String),
    );
  }

  final String nodeName;

  final String mediaFileId;

  final String? title;

  final String quality;

  final bool background;

  final String startedAt;

  final String? context;

  final String? contextType;

  final String? contextId;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$nodeName = nodeName;
    _resultData['nodeName'] = l$nodeName;
    final l$mediaFileId = mediaFileId;
    _resultData['mediaFileId'] = l$mediaFileId;
    final l$title = title;
    _resultData['title'] = l$title;
    final l$quality = quality;
    _resultData['quality'] = l$quality;
    final l$background = background;
    _resultData['background'] = l$background;
    final l$startedAt = startedAt;
    _resultData['startedAt'] = l$startedAt;
    final l$context = context;
    _resultData['context'] = l$context;
    final l$contextType = contextType;
    _resultData['contextType'] = l$contextType;
    final l$contextId = contextId;
    _resultData['contextId'] = l$contextId;
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$nodeName = nodeName;
    final l$mediaFileId = mediaFileId;
    final l$title = title;
    final l$quality = quality;
    final l$background = background;
    final l$startedAt = startedAt;
    final l$context = context;
    final l$contextType = contextType;
    final l$contextId = contextId;
    final l$$__typename = $__typename;
    return Object.hashAll([
      l$nodeName,
      l$mediaFileId,
      l$title,
      l$quality,
      l$background,
      l$startedAt,
      l$context,
      l$contextType,
      l$contextId,
      l$$__typename,
    ]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Fragment$fragmentTranscodePass ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$nodeName = nodeName;
    final lOther$nodeName = other.nodeName;
    if (l$nodeName != lOther$nodeName) {
      return false;
    }
    final l$mediaFileId = mediaFileId;
    final lOther$mediaFileId = other.mediaFileId;
    if (l$mediaFileId != lOther$mediaFileId) {
      return false;
    }
    final l$title = title;
    final lOther$title = other.title;
    if (l$title != lOther$title) {
      return false;
    }
    final l$quality = quality;
    final lOther$quality = other.quality;
    if (l$quality != lOther$quality) {
      return false;
    }
    final l$background = background;
    final lOther$background = other.background;
    if (l$background != lOther$background) {
      return false;
    }
    final l$startedAt = startedAt;
    final lOther$startedAt = other.startedAt;
    if (l$startedAt != lOther$startedAt) {
      return false;
    }
    final l$context = context;
    final lOther$context = other.context;
    if (l$context != lOther$context) {
      return false;
    }
    final l$contextType = contextType;
    final lOther$contextType = other.contextType;
    if (l$contextType != lOther$contextType) {
      return false;
    }
    final l$contextId = contextId;
    final lOther$contextId = other.contextId;
    if (l$contextId != lOther$contextId) {
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

extension UtilityExtension$Fragment$fragmentTranscodePass
    on Fragment$fragmentTranscodePass {
  CopyWith$Fragment$fragmentTranscodePass<Fragment$fragmentTranscodePass>
  get copyWith => CopyWith$Fragment$fragmentTranscodePass(this, (i) => i);
}

abstract class CopyWith$Fragment$fragmentTranscodePass<TRes> {
  factory CopyWith$Fragment$fragmentTranscodePass(
    Fragment$fragmentTranscodePass instance,
    TRes Function(Fragment$fragmentTranscodePass) then,
  ) = _CopyWithImpl$Fragment$fragmentTranscodePass;

  factory CopyWith$Fragment$fragmentTranscodePass.stub(TRes res) =
      _CopyWithStubImpl$Fragment$fragmentTranscodePass;

  TRes call({
    String? nodeName,
    String? mediaFileId,
    String? title,
    String? quality,
    bool? background,
    String? startedAt,
    String? context,
    String? contextType,
    String? contextId,
    String? $__typename,
  });
}

class _CopyWithImpl$Fragment$fragmentTranscodePass<TRes>
    implements CopyWith$Fragment$fragmentTranscodePass<TRes> {
  _CopyWithImpl$Fragment$fragmentTranscodePass(this._instance, this._then);

  final Fragment$fragmentTranscodePass _instance;

  final TRes Function(Fragment$fragmentTranscodePass) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? nodeName = _undefined,
    Object? mediaFileId = _undefined,
    Object? title = _undefined,
    Object? quality = _undefined,
    Object? background = _undefined,
    Object? startedAt = _undefined,
    Object? context = _undefined,
    Object? contextType = _undefined,
    Object? contextId = _undefined,
    Object? $__typename = _undefined,
  }) => _then(
    Fragment$fragmentTranscodePass(
      nodeName: nodeName == _undefined || nodeName == null
          ? _instance.nodeName
          : (nodeName as String),
      mediaFileId: mediaFileId == _undefined || mediaFileId == null
          ? _instance.mediaFileId
          : (mediaFileId as String),
      title: title == _undefined ? _instance.title : (title as String?),
      quality: quality == _undefined || quality == null
          ? _instance.quality
          : (quality as String),
      background: background == _undefined || background == null
          ? _instance.background
          : (background as bool),
      startedAt: startedAt == _undefined || startedAt == null
          ? _instance.startedAt
          : (startedAt as String),
      context: context == _undefined ? _instance.context : (context as String?),
      contextType: contextType == _undefined
          ? _instance.contextType
          : (contextType as String?),
      contextId: contextId == _undefined
          ? _instance.contextId
          : (contextId as String?),
      $__typename: $__typename == _undefined || $__typename == null
          ? _instance.$__typename
          : ($__typename as String),
    ),
  );
}

class _CopyWithStubImpl$Fragment$fragmentTranscodePass<TRes>
    implements CopyWith$Fragment$fragmentTranscodePass<TRes> {
  _CopyWithStubImpl$Fragment$fragmentTranscodePass(this._res);

  TRes _res;

  call({
    String? nodeName,
    String? mediaFileId,
    String? title,
    String? quality,
    bool? background,
    String? startedAt,
    String? context,
    String? contextType,
    String? contextId,
    String? $__typename,
  }) => _res;
}

const fragmentDefinitionfragmentTranscodePass = FragmentDefinitionNode(
  name: NameNode(value: 'fragmentTranscodePass'),
  typeCondition: TypeConditionNode(
    on: NamedTypeNode(name: NameNode(value: 'TranscodePass'), isNonNull: false),
  ),
  directives: [],
  selectionSet: SelectionSetNode(
    selections: [
      FieldNode(
        name: NameNode(value: 'nodeName'),
        alias: null,
        arguments: [],
        directives: [],
        selectionSet: null,
      ),
      FieldNode(
        name: NameNode(value: 'mediaFileId'),
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
        name: NameNode(value: 'quality'),
        alias: null,
        arguments: [],
        directives: [],
        selectionSet: null,
      ),
      FieldNode(
        name: NameNode(value: 'background'),
        alias: null,
        arguments: [],
        directives: [],
        selectionSet: null,
      ),
      FieldNode(
        name: NameNode(value: 'startedAt'),
        alias: null,
        arguments: [],
        directives: [],
        selectionSet: null,
      ),
      FieldNode(
        name: NameNode(value: 'context'),
        alias: null,
        arguments: [],
        directives: [],
        selectionSet: null,
      ),
      FieldNode(
        name: NameNode(value: 'contextType'),
        alias: null,
        arguments: [],
        directives: [],
        selectionSet: null,
      ),
      FieldNode(
        name: NameNode(value: 'contextId'),
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
);
const documentNodeFragmentfragmentTranscodePass = DocumentNode(
  definitions: [fragmentDefinitionfragmentTranscodePass],
);

class Fragment$fragmentNodeInfo {
  Fragment$fragmentNodeInfo({
    this.hostname,
    this.startedAt,
    this.javaVersion,
    this.availableProcessors,
    this.maxMemoryBytes,
    required this.directories,
    required this.helperDisks,
    required this.offloadJobs,
    this.$__typename = 'NodeInfo',
  });

  factory Fragment$fragmentNodeInfo.fromJson(Map<String, dynamic> json) {
    final l$hostname = json['hostname'];
    final l$startedAt = json['startedAt'];
    final l$javaVersion = json['javaVersion'];
    final l$availableProcessors = json['availableProcessors'];
    final l$maxMemoryBytes = json['maxMemoryBytes'];
    final l$directories = json['directories'];
    final l$helperDisks = json['helperDisks'];
    final l$offloadJobs = json['offloadJobs'];
    final l$$__typename = json['__typename'];
    return Fragment$fragmentNodeInfo(
      hostname: (l$hostname as String?),
      startedAt: (l$startedAt as String?),
      javaVersion: (l$javaVersion as String?),
      availableProcessors: (l$availableProcessors as int?),
      maxMemoryBytes: (l$maxMemoryBytes as num?)?.toDouble(),
      directories: (l$directories as List<dynamic>)
          .map(
            (e) => Fragment$fragmentNodeInfo$directories.fromJson(
              (e as Map<String, dynamic>),
            ),
          )
          .toList(),
      helperDisks: (l$helperDisks as List<dynamic>)
          .map(
            (e) => Fragment$fragmentNodeInfo$helperDisks.fromJson(
              (e as Map<String, dynamic>),
            ),
          )
          .toList(),
      offloadJobs: (l$offloadJobs as List<dynamic>)
          .map((e) => (e as String))
          .toList(),
      $__typename: (l$$__typename as String),
    );
  }

  final String? hostname;

  final String? startedAt;

  final String? javaVersion;

  final int? availableProcessors;

  final double? maxMemoryBytes;

  final List<Fragment$fragmentNodeInfo$directories> directories;

  final List<Fragment$fragmentNodeInfo$helperDisks> helperDisks;

  final List<String> offloadJobs;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$hostname = hostname;
    _resultData['hostname'] = l$hostname;
    final l$startedAt = startedAt;
    _resultData['startedAt'] = l$startedAt;
    final l$javaVersion = javaVersion;
    _resultData['javaVersion'] = l$javaVersion;
    final l$availableProcessors = availableProcessors;
    _resultData['availableProcessors'] = l$availableProcessors;
    final l$maxMemoryBytes = maxMemoryBytes;
    _resultData['maxMemoryBytes'] = l$maxMemoryBytes;
    final l$directories = directories;
    _resultData['directories'] = l$directories.map((e) => e.toJson()).toList();
    final l$helperDisks = helperDisks;
    _resultData['helperDisks'] = l$helperDisks.map((e) => e.toJson()).toList();
    final l$offloadJobs = offloadJobs;
    _resultData['offloadJobs'] = l$offloadJobs.map((e) => e).toList();
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$hostname = hostname;
    final l$startedAt = startedAt;
    final l$javaVersion = javaVersion;
    final l$availableProcessors = availableProcessors;
    final l$maxMemoryBytes = maxMemoryBytes;
    final l$directories = directories;
    final l$helperDisks = helperDisks;
    final l$offloadJobs = offloadJobs;
    final l$$__typename = $__typename;
    return Object.hashAll([
      l$hostname,
      l$startedAt,
      l$javaVersion,
      l$availableProcessors,
      l$maxMemoryBytes,
      Object.hashAll(l$directories.map((v) => v)),
      Object.hashAll(l$helperDisks.map((v) => v)),
      Object.hashAll(l$offloadJobs.map((v) => v)),
      l$$__typename,
    ]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Fragment$fragmentNodeInfo ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$hostname = hostname;
    final lOther$hostname = other.hostname;
    if (l$hostname != lOther$hostname) {
      return false;
    }
    final l$startedAt = startedAt;
    final lOther$startedAt = other.startedAt;
    if (l$startedAt != lOther$startedAt) {
      return false;
    }
    final l$javaVersion = javaVersion;
    final lOther$javaVersion = other.javaVersion;
    if (l$javaVersion != lOther$javaVersion) {
      return false;
    }
    final l$availableProcessors = availableProcessors;
    final lOther$availableProcessors = other.availableProcessors;
    if (l$availableProcessors != lOther$availableProcessors) {
      return false;
    }
    final l$maxMemoryBytes = maxMemoryBytes;
    final lOther$maxMemoryBytes = other.maxMemoryBytes;
    if (l$maxMemoryBytes != lOther$maxMemoryBytes) {
      return false;
    }
    final l$directories = directories;
    final lOther$directories = other.directories;
    if (l$directories.length != lOther$directories.length) {
      return false;
    }
    for (int i = 0; i < l$directories.length; i++) {
      final l$directories$entry = l$directories[i];
      final lOther$directories$entry = lOther$directories[i];
      if (l$directories$entry != lOther$directories$entry) {
        return false;
      }
    }
    final l$helperDisks = helperDisks;
    final lOther$helperDisks = other.helperDisks;
    if (l$helperDisks.length != lOther$helperDisks.length) {
      return false;
    }
    for (int i = 0; i < l$helperDisks.length; i++) {
      final l$helperDisks$entry = l$helperDisks[i];
      final lOther$helperDisks$entry = lOther$helperDisks[i];
      if (l$helperDisks$entry != lOther$helperDisks$entry) {
        return false;
      }
    }
    final l$offloadJobs = offloadJobs;
    final lOther$offloadJobs = other.offloadJobs;
    if (l$offloadJobs.length != lOther$offloadJobs.length) {
      return false;
    }
    for (int i = 0; i < l$offloadJobs.length; i++) {
      final l$offloadJobs$entry = l$offloadJobs[i];
      final lOther$offloadJobs$entry = lOther$offloadJobs[i];
      if (l$offloadJobs$entry != lOther$offloadJobs$entry) {
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

extension UtilityExtension$Fragment$fragmentNodeInfo
    on Fragment$fragmentNodeInfo {
  CopyWith$Fragment$fragmentNodeInfo<Fragment$fragmentNodeInfo> get copyWith =>
      CopyWith$Fragment$fragmentNodeInfo(this, (i) => i);
}

abstract class CopyWith$Fragment$fragmentNodeInfo<TRes> {
  factory CopyWith$Fragment$fragmentNodeInfo(
    Fragment$fragmentNodeInfo instance,
    TRes Function(Fragment$fragmentNodeInfo) then,
  ) = _CopyWithImpl$Fragment$fragmentNodeInfo;

  factory CopyWith$Fragment$fragmentNodeInfo.stub(TRes res) =
      _CopyWithStubImpl$Fragment$fragmentNodeInfo;

  TRes call({
    String? hostname,
    String? startedAt,
    String? javaVersion,
    int? availableProcessors,
    double? maxMemoryBytes,
    List<Fragment$fragmentNodeInfo$directories>? directories,
    List<Fragment$fragmentNodeInfo$helperDisks>? helperDisks,
    List<String>? offloadJobs,
    String? $__typename,
  });
  TRes directories(
    Iterable<Fragment$fragmentNodeInfo$directories> Function(
      Iterable<
        CopyWith$Fragment$fragmentNodeInfo$directories<
          Fragment$fragmentNodeInfo$directories
        >
      >,
    )
    _fn,
  );
  TRes helperDisks(
    Iterable<Fragment$fragmentNodeInfo$helperDisks> Function(
      Iterable<
        CopyWith$Fragment$fragmentNodeInfo$helperDisks<
          Fragment$fragmentNodeInfo$helperDisks
        >
      >,
    )
    _fn,
  );
}

class _CopyWithImpl$Fragment$fragmentNodeInfo<TRes>
    implements CopyWith$Fragment$fragmentNodeInfo<TRes> {
  _CopyWithImpl$Fragment$fragmentNodeInfo(this._instance, this._then);

  final Fragment$fragmentNodeInfo _instance;

  final TRes Function(Fragment$fragmentNodeInfo) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? hostname = _undefined,
    Object? startedAt = _undefined,
    Object? javaVersion = _undefined,
    Object? availableProcessors = _undefined,
    Object? maxMemoryBytes = _undefined,
    Object? directories = _undefined,
    Object? helperDisks = _undefined,
    Object? offloadJobs = _undefined,
    Object? $__typename = _undefined,
  }) => _then(
    Fragment$fragmentNodeInfo(
      hostname: hostname == _undefined
          ? _instance.hostname
          : (hostname as String?),
      startedAt: startedAt == _undefined
          ? _instance.startedAt
          : (startedAt as String?),
      javaVersion: javaVersion == _undefined
          ? _instance.javaVersion
          : (javaVersion as String?),
      availableProcessors: availableProcessors == _undefined
          ? _instance.availableProcessors
          : (availableProcessors as int?),
      maxMemoryBytes: maxMemoryBytes == _undefined
          ? _instance.maxMemoryBytes
          : (maxMemoryBytes as double?),
      directories: directories == _undefined || directories == null
          ? _instance.directories
          : (directories as List<Fragment$fragmentNodeInfo$directories>),
      helperDisks: helperDisks == _undefined || helperDisks == null
          ? _instance.helperDisks
          : (helperDisks as List<Fragment$fragmentNodeInfo$helperDisks>),
      offloadJobs: offloadJobs == _undefined || offloadJobs == null
          ? _instance.offloadJobs
          : (offloadJobs as List<String>),
      $__typename: $__typename == _undefined || $__typename == null
          ? _instance.$__typename
          : ($__typename as String),
    ),
  );

  TRes directories(
    Iterable<Fragment$fragmentNodeInfo$directories> Function(
      Iterable<
        CopyWith$Fragment$fragmentNodeInfo$directories<
          Fragment$fragmentNodeInfo$directories
        >
      >,
    )
    _fn,
  ) => call(
    directories: _fn(
      _instance.directories.map(
        (e) => CopyWith$Fragment$fragmentNodeInfo$directories(e, (i) => i),
      ),
    ).toList(),
  );

  TRes helperDisks(
    Iterable<Fragment$fragmentNodeInfo$helperDisks> Function(
      Iterable<
        CopyWith$Fragment$fragmentNodeInfo$helperDisks<
          Fragment$fragmentNodeInfo$helperDisks
        >
      >,
    )
    _fn,
  ) => call(
    helperDisks: _fn(
      _instance.helperDisks.map(
        (e) => CopyWith$Fragment$fragmentNodeInfo$helperDisks(e, (i) => i),
      ),
    ).toList(),
  );
}

class _CopyWithStubImpl$Fragment$fragmentNodeInfo<TRes>
    implements CopyWith$Fragment$fragmentNodeInfo<TRes> {
  _CopyWithStubImpl$Fragment$fragmentNodeInfo(this._res);

  TRes _res;

  call({
    String? hostname,
    String? startedAt,
    String? javaVersion,
    int? availableProcessors,
    double? maxMemoryBytes,
    List<Fragment$fragmentNodeInfo$directories>? directories,
    List<Fragment$fragmentNodeInfo$helperDisks>? helperDisks,
    List<String>? offloadJobs,
    String? $__typename,
  }) => _res;

  directories(_fn) => _res;

  helperDisks(_fn) => _res;
}

const fragmentDefinitionfragmentNodeInfo = FragmentDefinitionNode(
  name: NameNode(value: 'fragmentNodeInfo'),
  typeCondition: TypeConditionNode(
    on: NamedTypeNode(name: NameNode(value: 'NodeInfo'), isNonNull: false),
  ),
  directives: [],
  selectionSet: SelectionSetNode(
    selections: [
      FieldNode(
        name: NameNode(value: 'hostname'),
        alias: null,
        arguments: [],
        directives: [],
        selectionSet: null,
      ),
      FieldNode(
        name: NameNode(value: 'startedAt'),
        alias: null,
        arguments: [],
        directives: [],
        selectionSet: null,
      ),
      FieldNode(
        name: NameNode(value: 'javaVersion'),
        alias: null,
        arguments: [],
        directives: [],
        selectionSet: null,
      ),
      FieldNode(
        name: NameNode(value: 'availableProcessors'),
        alias: null,
        arguments: [],
        directives: [],
        selectionSet: null,
      ),
      FieldNode(
        name: NameNode(value: 'maxMemoryBytes'),
        alias: null,
        arguments: [],
        directives: [],
        selectionSet: null,
      ),
      FieldNode(
        name: NameNode(value: 'directories'),
        alias: null,
        arguments: [],
        directives: [],
        selectionSet: SelectionSetNode(
          selections: [
            FieldNode(
              name: NameNode(value: 'name'),
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
              name: NameNode(value: 'type'),
              alias: null,
              arguments: [],
              directives: [],
              selectionSet: null,
            ),
            FieldNode(
              name: NameNode(value: 'library'),
              alias: null,
              arguments: [],
              directives: [],
              selectionSet: null,
            ),
            FieldNode(
              name: NameNode(value: 'totalBytes'),
              alias: null,
              arguments: [],
              directives: [],
              selectionSet: null,
            ),
            FieldNode(
              name: NameNode(value: 'freeBytes'),
              alias: null,
              arguments: [],
              directives: [],
              selectionSet: null,
            ),
            FieldNode(
              name: NameNode(value: 'writable'),
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
        name: NameNode(value: 'helperDisks'),
        alias: null,
        arguments: [],
        directives: [],
        selectionSet: SelectionSetNode(
          selections: [
            FieldNode(
              name: NameNode(value: 'name'),
              alias: null,
              arguments: [],
              directives: [],
              selectionSet: null,
            ),
            FieldNode(
              name: NameNode(value: 'jobs'),
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
        name: NameNode(value: 'offloadJobs'),
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
);
const documentNodeFragmentfragmentNodeInfo = DocumentNode(
  definitions: [fragmentDefinitionfragmentNodeInfo],
);

class Fragment$fragmentNodeInfo$directories {
  Fragment$fragmentNodeInfo$directories({
    required this.name,
    required this.path,
    this.type,
    this.$library,
    this.totalBytes,
    this.freeBytes,
    this.writable,
    this.$__typename = 'NodeDirectory',
  });

  factory Fragment$fragmentNodeInfo$directories.fromJson(
    Map<String, dynamic> json,
  ) {
    final l$name = json['name'];
    final l$path = json['path'];
    final l$type = json['type'];
    final l$$library = json['library'];
    final l$totalBytes = json['totalBytes'];
    final l$freeBytes = json['freeBytes'];
    final l$writable = json['writable'];
    final l$$__typename = json['__typename'];
    return Fragment$fragmentNodeInfo$directories(
      name: (l$name as String),
      path: (l$path as String),
      type: (l$type as String?),
      $library: (l$$library as String?),
      totalBytes: (l$totalBytes as num?)?.toDouble(),
      freeBytes: (l$freeBytes as num?)?.toDouble(),
      writable: (l$writable as bool?),
      $__typename: (l$$__typename as String),
    );
  }

  final String name;

  final String path;

  final String? type;

  final String? $library;

  final double? totalBytes;

  final double? freeBytes;

  final bool? writable;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$name = name;
    _resultData['name'] = l$name;
    final l$path = path;
    _resultData['path'] = l$path;
    final l$type = type;
    _resultData['type'] = l$type;
    final l$$library = $library;
    _resultData['library'] = l$$library;
    final l$totalBytes = totalBytes;
    _resultData['totalBytes'] = l$totalBytes;
    final l$freeBytes = freeBytes;
    _resultData['freeBytes'] = l$freeBytes;
    final l$writable = writable;
    _resultData['writable'] = l$writable;
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$name = name;
    final l$path = path;
    final l$type = type;
    final l$$library = $library;
    final l$totalBytes = totalBytes;
    final l$freeBytes = freeBytes;
    final l$writable = writable;
    final l$$__typename = $__typename;
    return Object.hashAll([
      l$name,
      l$path,
      l$type,
      l$$library,
      l$totalBytes,
      l$freeBytes,
      l$writable,
      l$$__typename,
    ]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Fragment$fragmentNodeInfo$directories ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$name = name;
    final lOther$name = other.name;
    if (l$name != lOther$name) {
      return false;
    }
    final l$path = path;
    final lOther$path = other.path;
    if (l$path != lOther$path) {
      return false;
    }
    final l$type = type;
    final lOther$type = other.type;
    if (l$type != lOther$type) {
      return false;
    }
    final l$$library = $library;
    final lOther$$library = other.$library;
    if (l$$library != lOther$$library) {
      return false;
    }
    final l$totalBytes = totalBytes;
    final lOther$totalBytes = other.totalBytes;
    if (l$totalBytes != lOther$totalBytes) {
      return false;
    }
    final l$freeBytes = freeBytes;
    final lOther$freeBytes = other.freeBytes;
    if (l$freeBytes != lOther$freeBytes) {
      return false;
    }
    final l$writable = writable;
    final lOther$writable = other.writable;
    if (l$writable != lOther$writable) {
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

extension UtilityExtension$Fragment$fragmentNodeInfo$directories
    on Fragment$fragmentNodeInfo$directories {
  CopyWith$Fragment$fragmentNodeInfo$directories<
    Fragment$fragmentNodeInfo$directories
  >
  get copyWith =>
      CopyWith$Fragment$fragmentNodeInfo$directories(this, (i) => i);
}

abstract class CopyWith$Fragment$fragmentNodeInfo$directories<TRes> {
  factory CopyWith$Fragment$fragmentNodeInfo$directories(
    Fragment$fragmentNodeInfo$directories instance,
    TRes Function(Fragment$fragmentNodeInfo$directories) then,
  ) = _CopyWithImpl$Fragment$fragmentNodeInfo$directories;

  factory CopyWith$Fragment$fragmentNodeInfo$directories.stub(TRes res) =
      _CopyWithStubImpl$Fragment$fragmentNodeInfo$directories;

  TRes call({
    String? name,
    String? path,
    String? type,
    String? $library,
    double? totalBytes,
    double? freeBytes,
    bool? writable,
    String? $__typename,
  });
}

class _CopyWithImpl$Fragment$fragmentNodeInfo$directories<TRes>
    implements CopyWith$Fragment$fragmentNodeInfo$directories<TRes> {
  _CopyWithImpl$Fragment$fragmentNodeInfo$directories(
    this._instance,
    this._then,
  );

  final Fragment$fragmentNodeInfo$directories _instance;

  final TRes Function(Fragment$fragmentNodeInfo$directories) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? name = _undefined,
    Object? path = _undefined,
    Object? type = _undefined,
    Object? $library = _undefined,
    Object? totalBytes = _undefined,
    Object? freeBytes = _undefined,
    Object? writable = _undefined,
    Object? $__typename = _undefined,
  }) => _then(
    Fragment$fragmentNodeInfo$directories(
      name: name == _undefined || name == null
          ? _instance.name
          : (name as String),
      path: path == _undefined || path == null
          ? _instance.path
          : (path as String),
      type: type == _undefined ? _instance.type : (type as String?),
      $library: $library == _undefined
          ? _instance.$library
          : ($library as String?),
      totalBytes: totalBytes == _undefined
          ? _instance.totalBytes
          : (totalBytes as double?),
      freeBytes: freeBytes == _undefined
          ? _instance.freeBytes
          : (freeBytes as double?),
      writable: writable == _undefined
          ? _instance.writable
          : (writable as bool?),
      $__typename: $__typename == _undefined || $__typename == null
          ? _instance.$__typename
          : ($__typename as String),
    ),
  );
}

class _CopyWithStubImpl$Fragment$fragmentNodeInfo$directories<TRes>
    implements CopyWith$Fragment$fragmentNodeInfo$directories<TRes> {
  _CopyWithStubImpl$Fragment$fragmentNodeInfo$directories(this._res);

  TRes _res;

  call({
    String? name,
    String? path,
    String? type,
    String? $library,
    double? totalBytes,
    double? freeBytes,
    bool? writable,
    String? $__typename,
  }) => _res;
}

class Fragment$fragmentNodeInfo$helperDisks {
  Fragment$fragmentNodeInfo$helperDisks({
    required this.name,
    required this.jobs,
    this.$__typename = 'HelperDisk',
  });

  factory Fragment$fragmentNodeInfo$helperDisks.fromJson(
    Map<String, dynamic> json,
  ) {
    final l$name = json['name'];
    final l$jobs = json['jobs'];
    final l$$__typename = json['__typename'];
    return Fragment$fragmentNodeInfo$helperDisks(
      name: (l$name as String),
      jobs: (l$jobs as List<dynamic>).map((e) => (e as String)).toList(),
      $__typename: (l$$__typename as String),
    );
  }

  final String name;

  final List<String> jobs;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$name = name;
    _resultData['name'] = l$name;
    final l$jobs = jobs;
    _resultData['jobs'] = l$jobs.map((e) => e).toList();
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$name = name;
    final l$jobs = jobs;
    final l$$__typename = $__typename;
    return Object.hashAll([
      l$name,
      Object.hashAll(l$jobs.map((v) => v)),
      l$$__typename,
    ]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Fragment$fragmentNodeInfo$helperDisks ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$name = name;
    final lOther$name = other.name;
    if (l$name != lOther$name) {
      return false;
    }
    final l$jobs = jobs;
    final lOther$jobs = other.jobs;
    if (l$jobs.length != lOther$jobs.length) {
      return false;
    }
    for (int i = 0; i < l$jobs.length; i++) {
      final l$jobs$entry = l$jobs[i];
      final lOther$jobs$entry = lOther$jobs[i];
      if (l$jobs$entry != lOther$jobs$entry) {
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

extension UtilityExtension$Fragment$fragmentNodeInfo$helperDisks
    on Fragment$fragmentNodeInfo$helperDisks {
  CopyWith$Fragment$fragmentNodeInfo$helperDisks<
    Fragment$fragmentNodeInfo$helperDisks
  >
  get copyWith =>
      CopyWith$Fragment$fragmentNodeInfo$helperDisks(this, (i) => i);
}

abstract class CopyWith$Fragment$fragmentNodeInfo$helperDisks<TRes> {
  factory CopyWith$Fragment$fragmentNodeInfo$helperDisks(
    Fragment$fragmentNodeInfo$helperDisks instance,
    TRes Function(Fragment$fragmentNodeInfo$helperDisks) then,
  ) = _CopyWithImpl$Fragment$fragmentNodeInfo$helperDisks;

  factory CopyWith$Fragment$fragmentNodeInfo$helperDisks.stub(TRes res) =
      _CopyWithStubImpl$Fragment$fragmentNodeInfo$helperDisks;

  TRes call({String? name, List<String>? jobs, String? $__typename});
}

class _CopyWithImpl$Fragment$fragmentNodeInfo$helperDisks<TRes>
    implements CopyWith$Fragment$fragmentNodeInfo$helperDisks<TRes> {
  _CopyWithImpl$Fragment$fragmentNodeInfo$helperDisks(
    this._instance,
    this._then,
  );

  final Fragment$fragmentNodeInfo$helperDisks _instance;

  final TRes Function(Fragment$fragmentNodeInfo$helperDisks) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? name = _undefined,
    Object? jobs = _undefined,
    Object? $__typename = _undefined,
  }) => _then(
    Fragment$fragmentNodeInfo$helperDisks(
      name: name == _undefined || name == null
          ? _instance.name
          : (name as String),
      jobs: jobs == _undefined || jobs == null
          ? _instance.jobs
          : (jobs as List<String>),
      $__typename: $__typename == _undefined || $__typename == null
          ? _instance.$__typename
          : ($__typename as String),
    ),
  );
}

class _CopyWithStubImpl$Fragment$fragmentNodeInfo$helperDisks<TRes>
    implements CopyWith$Fragment$fragmentNodeInfo$helperDisks<TRes> {
  _CopyWithStubImpl$Fragment$fragmentNodeInfo$helperDisks(this._res);

  TRes _res;

  call({String? name, List<String>? jobs, String? $__typename}) => _res;
}

class Fragment$fragmentServerActivityEvent {
  Fragment$fragmentServerActivityEvent({
    required this.type,
    required this.nodeName,
    required this.timestamp,
    this.processing,
    this.processedCount,
    this.failedCount,
    this.queueStats,
    this.failure,
    this.transcodes,
    this.nodeInfo,
    this.$__typename = 'ServerActivityEvent',
  });

  factory Fragment$fragmentServerActivityEvent.fromJson(
    Map<String, dynamic> json,
  ) {
    final l$type = json['type'];
    final l$nodeName = json['nodeName'];
    final l$timestamp = json['timestamp'];
    final l$processing = json['processing'];
    final l$processedCount = json['processedCount'];
    final l$failedCount = json['failedCount'];
    final l$queueStats = json['queueStats'];
    final l$failure = json['failure'];
    final l$transcodes = json['transcodes'];
    final l$nodeInfo = json['nodeInfo'];
    final l$$__typename = json['__typename'];
    return Fragment$fragmentServerActivityEvent(
      type: fromJson$Enum$ServerActivityEventType((l$type as String)),
      nodeName: (l$nodeName as String),
      timestamp: (l$timestamp as String),
      processing: (l$processing as List<dynamic>?)
          ?.map(
            (e) => Fragment$fragmentServerActivityEvent$processing.fromJson(
              (e as Map<String, dynamic>),
            ),
          )
          .toList(),
      processedCount: (l$processedCount as int?),
      failedCount: (l$failedCount as int?),
      queueStats: (l$queueStats as List<dynamic>?)
          ?.map(
            (e) => Fragment$fragmentQueueStat.fromJson(
              (e as Map<String, dynamic>),
            ),
          )
          .toList(),
      failure: l$failure == null
          ? null
          : Fragment$fragmentEventFailure.fromJson(
              (l$failure as Map<String, dynamic>),
            ),
      transcodes: (l$transcodes as List<dynamic>?)
          ?.map(
            (e) => Fragment$fragmentTranscodePass.fromJson(
              (e as Map<String, dynamic>),
            ),
          )
          .toList(),
      nodeInfo: l$nodeInfo == null
          ? null
          : Fragment$fragmentNodeInfo.fromJson(
              (l$nodeInfo as Map<String, dynamic>),
            ),
      $__typename: (l$$__typename as String),
    );
  }

  final Enum$ServerActivityEventType type;

  final String nodeName;

  final String timestamp;

  final List<Fragment$fragmentServerActivityEvent$processing>? processing;

  final int? processedCount;

  final int? failedCount;

  final List<Fragment$fragmentQueueStat>? queueStats;

  final Fragment$fragmentEventFailure? failure;

  final List<Fragment$fragmentTranscodePass>? transcodes;

  final Fragment$fragmentNodeInfo? nodeInfo;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$type = type;
    _resultData['type'] = toJson$Enum$ServerActivityEventType(l$type);
    final l$nodeName = nodeName;
    _resultData['nodeName'] = l$nodeName;
    final l$timestamp = timestamp;
    _resultData['timestamp'] = l$timestamp;
    final l$processing = processing;
    _resultData['processing'] = l$processing?.map((e) => e.toJson()).toList();
    final l$processedCount = processedCount;
    _resultData['processedCount'] = l$processedCount;
    final l$failedCount = failedCount;
    _resultData['failedCount'] = l$failedCount;
    final l$queueStats = queueStats;
    _resultData['queueStats'] = l$queueStats?.map((e) => e.toJson()).toList();
    final l$failure = failure;
    _resultData['failure'] = l$failure?.toJson();
    final l$transcodes = transcodes;
    _resultData['transcodes'] = l$transcodes?.map((e) => e.toJson()).toList();
    final l$nodeInfo = nodeInfo;
    _resultData['nodeInfo'] = l$nodeInfo?.toJson();
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$type = type;
    final l$nodeName = nodeName;
    final l$timestamp = timestamp;
    final l$processing = processing;
    final l$processedCount = processedCount;
    final l$failedCount = failedCount;
    final l$queueStats = queueStats;
    final l$failure = failure;
    final l$transcodes = transcodes;
    final l$nodeInfo = nodeInfo;
    final l$$__typename = $__typename;
    return Object.hashAll([
      l$type,
      l$nodeName,
      l$timestamp,
      l$processing == null ? null : Object.hashAll(l$processing.map((v) => v)),
      l$processedCount,
      l$failedCount,
      l$queueStats == null ? null : Object.hashAll(l$queueStats.map((v) => v)),
      l$failure,
      l$transcodes == null ? null : Object.hashAll(l$transcodes.map((v) => v)),
      l$nodeInfo,
      l$$__typename,
    ]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Fragment$fragmentServerActivityEvent ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$type = type;
    final lOther$type = other.type;
    if (l$type != lOther$type) {
      return false;
    }
    final l$nodeName = nodeName;
    final lOther$nodeName = other.nodeName;
    if (l$nodeName != lOther$nodeName) {
      return false;
    }
    final l$timestamp = timestamp;
    final lOther$timestamp = other.timestamp;
    if (l$timestamp != lOther$timestamp) {
      return false;
    }
    final l$processing = processing;
    final lOther$processing = other.processing;
    if (l$processing != null && lOther$processing != null) {
      if (l$processing.length != lOther$processing.length) {
        return false;
      }
      for (int i = 0; i < l$processing.length; i++) {
        final l$processing$entry = l$processing[i];
        final lOther$processing$entry = lOther$processing[i];
        if (l$processing$entry != lOther$processing$entry) {
          return false;
        }
      }
    } else if (l$processing != lOther$processing) {
      return false;
    }
    final l$processedCount = processedCount;
    final lOther$processedCount = other.processedCount;
    if (l$processedCount != lOther$processedCount) {
      return false;
    }
    final l$failedCount = failedCount;
    final lOther$failedCount = other.failedCount;
    if (l$failedCount != lOther$failedCount) {
      return false;
    }
    final l$queueStats = queueStats;
    final lOther$queueStats = other.queueStats;
    if (l$queueStats != null && lOther$queueStats != null) {
      if (l$queueStats.length != lOther$queueStats.length) {
        return false;
      }
      for (int i = 0; i < l$queueStats.length; i++) {
        final l$queueStats$entry = l$queueStats[i];
        final lOther$queueStats$entry = lOther$queueStats[i];
        if (l$queueStats$entry != lOther$queueStats$entry) {
          return false;
        }
      }
    } else if (l$queueStats != lOther$queueStats) {
      return false;
    }
    final l$failure = failure;
    final lOther$failure = other.failure;
    if (l$failure != lOther$failure) {
      return false;
    }
    final l$transcodes = transcodes;
    final lOther$transcodes = other.transcodes;
    if (l$transcodes != null && lOther$transcodes != null) {
      if (l$transcodes.length != lOther$transcodes.length) {
        return false;
      }
      for (int i = 0; i < l$transcodes.length; i++) {
        final l$transcodes$entry = l$transcodes[i];
        final lOther$transcodes$entry = lOther$transcodes[i];
        if (l$transcodes$entry != lOther$transcodes$entry) {
          return false;
        }
      }
    } else if (l$transcodes != lOther$transcodes) {
      return false;
    }
    final l$nodeInfo = nodeInfo;
    final lOther$nodeInfo = other.nodeInfo;
    if (l$nodeInfo != lOther$nodeInfo) {
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

extension UtilityExtension$Fragment$fragmentServerActivityEvent
    on Fragment$fragmentServerActivityEvent {
  CopyWith$Fragment$fragmentServerActivityEvent<
    Fragment$fragmentServerActivityEvent
  >
  get copyWith => CopyWith$Fragment$fragmentServerActivityEvent(this, (i) => i);
}

abstract class CopyWith$Fragment$fragmentServerActivityEvent<TRes> {
  factory CopyWith$Fragment$fragmentServerActivityEvent(
    Fragment$fragmentServerActivityEvent instance,
    TRes Function(Fragment$fragmentServerActivityEvent) then,
  ) = _CopyWithImpl$Fragment$fragmentServerActivityEvent;

  factory CopyWith$Fragment$fragmentServerActivityEvent.stub(TRes res) =
      _CopyWithStubImpl$Fragment$fragmentServerActivityEvent;

  TRes call({
    Enum$ServerActivityEventType? type,
    String? nodeName,
    String? timestamp,
    List<Fragment$fragmentServerActivityEvent$processing>? processing,
    int? processedCount,
    int? failedCount,
    List<Fragment$fragmentQueueStat>? queueStats,
    Fragment$fragmentEventFailure? failure,
    List<Fragment$fragmentTranscodePass>? transcodes,
    Fragment$fragmentNodeInfo? nodeInfo,
    String? $__typename,
  });
  TRes processing(
    Iterable<Fragment$fragmentServerActivityEvent$processing>? Function(
      Iterable<
        CopyWith$Fragment$fragmentServerActivityEvent$processing<
          Fragment$fragmentServerActivityEvent$processing
        >
      >?,
    )
    _fn,
  );
  TRes queueStats(
    Iterable<Fragment$fragmentQueueStat>? Function(
      Iterable<
        CopyWith$Fragment$fragmentQueueStat<Fragment$fragmentQueueStat>
      >?,
    )
    _fn,
  );
  CopyWith$Fragment$fragmentEventFailure<TRes> get failure;
  TRes transcodes(
    Iterable<Fragment$fragmentTranscodePass>? Function(
      Iterable<
        CopyWith$Fragment$fragmentTranscodePass<Fragment$fragmentTranscodePass>
      >?,
    )
    _fn,
  );
  CopyWith$Fragment$fragmentNodeInfo<TRes> get nodeInfo;
}

class _CopyWithImpl$Fragment$fragmentServerActivityEvent<TRes>
    implements CopyWith$Fragment$fragmentServerActivityEvent<TRes> {
  _CopyWithImpl$Fragment$fragmentServerActivityEvent(
    this._instance,
    this._then,
  );

  final Fragment$fragmentServerActivityEvent _instance;

  final TRes Function(Fragment$fragmentServerActivityEvent) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? type = _undefined,
    Object? nodeName = _undefined,
    Object? timestamp = _undefined,
    Object? processing = _undefined,
    Object? processedCount = _undefined,
    Object? failedCount = _undefined,
    Object? queueStats = _undefined,
    Object? failure = _undefined,
    Object? transcodes = _undefined,
    Object? nodeInfo = _undefined,
    Object? $__typename = _undefined,
  }) => _then(
    Fragment$fragmentServerActivityEvent(
      type: type == _undefined || type == null
          ? _instance.type
          : (type as Enum$ServerActivityEventType),
      nodeName: nodeName == _undefined || nodeName == null
          ? _instance.nodeName
          : (nodeName as String),
      timestamp: timestamp == _undefined || timestamp == null
          ? _instance.timestamp
          : (timestamp as String),
      processing: processing == _undefined
          ? _instance.processing
          : (processing
                as List<Fragment$fragmentServerActivityEvent$processing>?),
      processedCount: processedCount == _undefined
          ? _instance.processedCount
          : (processedCount as int?),
      failedCount: failedCount == _undefined
          ? _instance.failedCount
          : (failedCount as int?),
      queueStats: queueStats == _undefined
          ? _instance.queueStats
          : (queueStats as List<Fragment$fragmentQueueStat>?),
      failure: failure == _undefined
          ? _instance.failure
          : (failure as Fragment$fragmentEventFailure?),
      transcodes: transcodes == _undefined
          ? _instance.transcodes
          : (transcodes as List<Fragment$fragmentTranscodePass>?),
      nodeInfo: nodeInfo == _undefined
          ? _instance.nodeInfo
          : (nodeInfo as Fragment$fragmentNodeInfo?),
      $__typename: $__typename == _undefined || $__typename == null
          ? _instance.$__typename
          : ($__typename as String),
    ),
  );

  TRes processing(
    Iterable<Fragment$fragmentServerActivityEvent$processing>? Function(
      Iterable<
        CopyWith$Fragment$fragmentServerActivityEvent$processing<
          Fragment$fragmentServerActivityEvent$processing
        >
      >?,
    )
    _fn,
  ) => call(
    processing: _fn(
      _instance.processing?.map(
        (e) => CopyWith$Fragment$fragmentServerActivityEvent$processing(
          e,
          (i) => i,
        ),
      ),
    )?.toList(),
  );

  TRes queueStats(
    Iterable<Fragment$fragmentQueueStat>? Function(
      Iterable<
        CopyWith$Fragment$fragmentQueueStat<Fragment$fragmentQueueStat>
      >?,
    )
    _fn,
  ) => call(
    queueStats: _fn(
      _instance.queueStats?.map(
        (e) => CopyWith$Fragment$fragmentQueueStat(e, (i) => i),
      ),
    )?.toList(),
  );

  CopyWith$Fragment$fragmentEventFailure<TRes> get failure {
    final local$failure = _instance.failure;
    return local$failure == null
        ? CopyWith$Fragment$fragmentEventFailure.stub(_then(_instance))
        : CopyWith$Fragment$fragmentEventFailure(
            local$failure,
            (e) => call(failure: e),
          );
  }

  TRes transcodes(
    Iterable<Fragment$fragmentTranscodePass>? Function(
      Iterable<
        CopyWith$Fragment$fragmentTranscodePass<Fragment$fragmentTranscodePass>
      >?,
    )
    _fn,
  ) => call(
    transcodes: _fn(
      _instance.transcodes?.map(
        (e) => CopyWith$Fragment$fragmentTranscodePass(e, (i) => i),
      ),
    )?.toList(),
  );

  CopyWith$Fragment$fragmentNodeInfo<TRes> get nodeInfo {
    final local$nodeInfo = _instance.nodeInfo;
    return local$nodeInfo == null
        ? CopyWith$Fragment$fragmentNodeInfo.stub(_then(_instance))
        : CopyWith$Fragment$fragmentNodeInfo(
            local$nodeInfo,
            (e) => call(nodeInfo: e),
          );
  }
}

class _CopyWithStubImpl$Fragment$fragmentServerActivityEvent<TRes>
    implements CopyWith$Fragment$fragmentServerActivityEvent<TRes> {
  _CopyWithStubImpl$Fragment$fragmentServerActivityEvent(this._res);

  TRes _res;

  call({
    Enum$ServerActivityEventType? type,
    String? nodeName,
    String? timestamp,
    List<Fragment$fragmentServerActivityEvent$processing>? processing,
    int? processedCount,
    int? failedCount,
    List<Fragment$fragmentQueueStat>? queueStats,
    Fragment$fragmentEventFailure? failure,
    List<Fragment$fragmentTranscodePass>? transcodes,
    Fragment$fragmentNodeInfo? nodeInfo,
    String? $__typename,
  }) => _res;

  processing(_fn) => _res;

  queueStats(_fn) => _res;

  CopyWith$Fragment$fragmentEventFailure<TRes> get failure =>
      CopyWith$Fragment$fragmentEventFailure.stub(_res);

  transcodes(_fn) => _res;

  CopyWith$Fragment$fragmentNodeInfo<TRes> get nodeInfo =>
      CopyWith$Fragment$fragmentNodeInfo.stub(_res);
}

const fragmentDefinitionfragmentServerActivityEvent = FragmentDefinitionNode(
  name: NameNode(value: 'fragmentServerActivityEvent'),
  typeCondition: TypeConditionNode(
    on: NamedTypeNode(
      name: NameNode(value: 'ServerActivityEvent'),
      isNonNull: false,
    ),
  ),
  directives: [],
  selectionSet: SelectionSetNode(
    selections: [
      FieldNode(
        name: NameNode(value: 'type'),
        alias: null,
        arguments: [],
        directives: [],
        selectionSet: null,
      ),
      FieldNode(
        name: NameNode(value: 'nodeName'),
        alias: null,
        arguments: [],
        directives: [],
        selectionSet: null,
      ),
      FieldNode(
        name: NameNode(value: 'timestamp'),
        alias: null,
        arguments: [],
        directives: [],
        selectionSet: null,
      ),
      FieldNode(
        name: NameNode(value: 'processing'),
        alias: null,
        arguments: [],
        directives: [],
        selectionSet: SelectionSetNode(
          selections: [
            FieldNode(
              name: NameNode(value: 'queue'),
              alias: null,
              arguments: [],
              directives: [],
              selectionSet: null,
            ),
            FieldNode(
              name: NameNode(value: 'eventType'),
              alias: null,
              arguments: [],
              directives: [],
              selectionSet: null,
            ),
            FieldNode(
              name: NameNode(value: 'startedAt'),
              alias: null,
              arguments: [],
              directives: [],
              selectionSet: null,
            ),
            FieldNode(
              name: NameNode(value: 'subject'),
              alias: null,
              arguments: [],
              directives: [],
              selectionSet: null,
            ),
            FieldNode(
              name: NameNode(value: 'step'),
              alias: null,
              arguments: [],
              directives: [],
              selectionSet: null,
            ),
            FieldNode(
              name: NameNode(value: 'context'),
              alias: null,
              arguments: [],
              directives: [],
              selectionSet: null,
            ),
            FieldNode(
              name: NameNode(value: 'contextType'),
              alias: null,
              arguments: [],
              directives: [],
              selectionSet: null,
            ),
            FieldNode(
              name: NameNode(value: 'contextId'),
              alias: null,
              arguments: [],
              directives: [],
              selectionSet: null,
            ),
            FieldNode(
              name: NameNode(value: 'directory'),
              alias: null,
              arguments: [],
              directives: [],
              selectionSet: null,
            ),
            FieldNode(
              name: NameNode(value: 'library'),
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
        name: NameNode(value: 'processedCount'),
        alias: null,
        arguments: [],
        directives: [],
        selectionSet: null,
      ),
      FieldNode(
        name: NameNode(value: 'failedCount'),
        alias: null,
        arguments: [],
        directives: [],
        selectionSet: null,
      ),
      FieldNode(
        name: NameNode(value: 'queueStats'),
        alias: null,
        arguments: [],
        directives: [],
        selectionSet: SelectionSetNode(
          selections: [
            FragmentSpreadNode(
              name: NameNode(value: 'fragmentQueueStat'),
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
        name: NameNode(value: 'failure'),
        alias: null,
        arguments: [],
        directives: [],
        selectionSet: SelectionSetNode(
          selections: [
            FragmentSpreadNode(
              name: NameNode(value: 'fragmentEventFailure'),
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
        name: NameNode(value: 'transcodes'),
        alias: null,
        arguments: [],
        directives: [],
        selectionSet: SelectionSetNode(
          selections: [
            FragmentSpreadNode(
              name: NameNode(value: 'fragmentTranscodePass'),
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
        name: NameNode(value: 'nodeInfo'),
        alias: null,
        arguments: [],
        directives: [],
        selectionSet: SelectionSetNode(
          selections: [
            FragmentSpreadNode(
              name: NameNode(value: 'fragmentNodeInfo'),
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
const documentNodeFragmentfragmentServerActivityEvent = DocumentNode(
  definitions: [
    fragmentDefinitionfragmentServerActivityEvent,
    fragmentDefinitionfragmentQueueStat,
    fragmentDefinitionfragmentEventFailure,
    fragmentDefinitionfragmentTranscodePass,
    fragmentDefinitionfragmentNodeInfo,
  ],
);

class Fragment$fragmentServerActivityEvent$processing {
  Fragment$fragmentServerActivityEvent$processing({
    required this.queue,
    required this.eventType,
    required this.startedAt,
    this.subject,
    this.step,
    this.context,
    this.contextType,
    this.contextId,
    this.directory,
    this.$library,
    this.$__typename = 'ProcessingItem',
  });

  factory Fragment$fragmentServerActivityEvent$processing.fromJson(
    Map<String, dynamic> json,
  ) {
    final l$queue = json['queue'];
    final l$eventType = json['eventType'];
    final l$startedAt = json['startedAt'];
    final l$subject = json['subject'];
    final l$step = json['step'];
    final l$context = json['context'];
    final l$contextType = json['contextType'];
    final l$contextId = json['contextId'];
    final l$directory = json['directory'];
    final l$$library = json['library'];
    final l$$__typename = json['__typename'];
    return Fragment$fragmentServerActivityEvent$processing(
      queue: (l$queue as String),
      eventType: (l$eventType as String),
      startedAt: (l$startedAt as String),
      subject: (l$subject as String?),
      step: (l$step as String?),
      context: (l$context as String?),
      contextType: (l$contextType as String?),
      contextId: (l$contextId as String?),
      directory: (l$directory as String?),
      $library: (l$$library as String?),
      $__typename: (l$$__typename as String),
    );
  }

  final String queue;

  final String eventType;

  final String startedAt;

  final String? subject;

  final String? step;

  final String? context;

  final String? contextType;

  final String? contextId;

  final String? directory;

  final String? $library;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$queue = queue;
    _resultData['queue'] = l$queue;
    final l$eventType = eventType;
    _resultData['eventType'] = l$eventType;
    final l$startedAt = startedAt;
    _resultData['startedAt'] = l$startedAt;
    final l$subject = subject;
    _resultData['subject'] = l$subject;
    final l$step = step;
    _resultData['step'] = l$step;
    final l$context = context;
    _resultData['context'] = l$context;
    final l$contextType = contextType;
    _resultData['contextType'] = l$contextType;
    final l$contextId = contextId;
    _resultData['contextId'] = l$contextId;
    final l$directory = directory;
    _resultData['directory'] = l$directory;
    final l$$library = $library;
    _resultData['library'] = l$$library;
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$queue = queue;
    final l$eventType = eventType;
    final l$startedAt = startedAt;
    final l$subject = subject;
    final l$step = step;
    final l$context = context;
    final l$contextType = contextType;
    final l$contextId = contextId;
    final l$directory = directory;
    final l$$library = $library;
    final l$$__typename = $__typename;
    return Object.hashAll([
      l$queue,
      l$eventType,
      l$startedAt,
      l$subject,
      l$step,
      l$context,
      l$contextType,
      l$contextId,
      l$directory,
      l$$library,
      l$$__typename,
    ]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Fragment$fragmentServerActivityEvent$processing ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$queue = queue;
    final lOther$queue = other.queue;
    if (l$queue != lOther$queue) {
      return false;
    }
    final l$eventType = eventType;
    final lOther$eventType = other.eventType;
    if (l$eventType != lOther$eventType) {
      return false;
    }
    final l$startedAt = startedAt;
    final lOther$startedAt = other.startedAt;
    if (l$startedAt != lOther$startedAt) {
      return false;
    }
    final l$subject = subject;
    final lOther$subject = other.subject;
    if (l$subject != lOther$subject) {
      return false;
    }
    final l$step = step;
    final lOther$step = other.step;
    if (l$step != lOther$step) {
      return false;
    }
    final l$context = context;
    final lOther$context = other.context;
    if (l$context != lOther$context) {
      return false;
    }
    final l$contextType = contextType;
    final lOther$contextType = other.contextType;
    if (l$contextType != lOther$contextType) {
      return false;
    }
    final l$contextId = contextId;
    final lOther$contextId = other.contextId;
    if (l$contextId != lOther$contextId) {
      return false;
    }
    final l$directory = directory;
    final lOther$directory = other.directory;
    if (l$directory != lOther$directory) {
      return false;
    }
    final l$$library = $library;
    final lOther$$library = other.$library;
    if (l$$library != lOther$$library) {
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

extension UtilityExtension$Fragment$fragmentServerActivityEvent$processing
    on Fragment$fragmentServerActivityEvent$processing {
  CopyWith$Fragment$fragmentServerActivityEvent$processing<
    Fragment$fragmentServerActivityEvent$processing
  >
  get copyWith =>
      CopyWith$Fragment$fragmentServerActivityEvent$processing(this, (i) => i);
}

abstract class CopyWith$Fragment$fragmentServerActivityEvent$processing<TRes> {
  factory CopyWith$Fragment$fragmentServerActivityEvent$processing(
    Fragment$fragmentServerActivityEvent$processing instance,
    TRes Function(Fragment$fragmentServerActivityEvent$processing) then,
  ) = _CopyWithImpl$Fragment$fragmentServerActivityEvent$processing;

  factory CopyWith$Fragment$fragmentServerActivityEvent$processing.stub(
    TRes res,
  ) = _CopyWithStubImpl$Fragment$fragmentServerActivityEvent$processing;

  TRes call({
    String? queue,
    String? eventType,
    String? startedAt,
    String? subject,
    String? step,
    String? context,
    String? contextType,
    String? contextId,
    String? directory,
    String? $library,
    String? $__typename,
  });
}

class _CopyWithImpl$Fragment$fragmentServerActivityEvent$processing<TRes>
    implements CopyWith$Fragment$fragmentServerActivityEvent$processing<TRes> {
  _CopyWithImpl$Fragment$fragmentServerActivityEvent$processing(
    this._instance,
    this._then,
  );

  final Fragment$fragmentServerActivityEvent$processing _instance;

  final TRes Function(Fragment$fragmentServerActivityEvent$processing) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? queue = _undefined,
    Object? eventType = _undefined,
    Object? startedAt = _undefined,
    Object? subject = _undefined,
    Object? step = _undefined,
    Object? context = _undefined,
    Object? contextType = _undefined,
    Object? contextId = _undefined,
    Object? directory = _undefined,
    Object? $library = _undefined,
    Object? $__typename = _undefined,
  }) => _then(
    Fragment$fragmentServerActivityEvent$processing(
      queue: queue == _undefined || queue == null
          ? _instance.queue
          : (queue as String),
      eventType: eventType == _undefined || eventType == null
          ? _instance.eventType
          : (eventType as String),
      startedAt: startedAt == _undefined || startedAt == null
          ? _instance.startedAt
          : (startedAt as String),
      subject: subject == _undefined ? _instance.subject : (subject as String?),
      step: step == _undefined ? _instance.step : (step as String?),
      context: context == _undefined ? _instance.context : (context as String?),
      contextType: contextType == _undefined
          ? _instance.contextType
          : (contextType as String?),
      contextId: contextId == _undefined
          ? _instance.contextId
          : (contextId as String?),
      directory: directory == _undefined
          ? _instance.directory
          : (directory as String?),
      $library: $library == _undefined
          ? _instance.$library
          : ($library as String?),
      $__typename: $__typename == _undefined || $__typename == null
          ? _instance.$__typename
          : ($__typename as String),
    ),
  );
}

class _CopyWithStubImpl$Fragment$fragmentServerActivityEvent$processing<TRes>
    implements CopyWith$Fragment$fragmentServerActivityEvent$processing<TRes> {
  _CopyWithStubImpl$Fragment$fragmentServerActivityEvent$processing(this._res);

  TRes _res;

  call({
    String? queue,
    String? eventType,
    String? startedAt,
    String? subject,
    String? step,
    String? context,
    String? contextType,
    String? contextId,
    String? directory,
    String? $library,
    String? $__typename,
  }) => _res;
}

class Fragment$fragmentPlaybackSession {
  Fragment$fragmentPlaybackSession({
    required this.playQueueId,
    this.playQueueItemId,
    required this.userId,
    this.userName,
    this.mediaType,
    this.mediaId,
    this.title,
    this.durationInMilliseconds,
    this.artworkImageId,
    required this.progressInMilliseconds,
    required this.playState,
    required this.nodeName,
    required this.updatedAt,
    required this.controllable,
    required this.followerCount,
    this.deviceId,
    this.deviceName,
    this.anchorPositionMs,
    this.anchorServerTimeMs,
    this.repeatMode,
    this.$__typename = 'PlaybackSession',
  });

  factory Fragment$fragmentPlaybackSession.fromJson(Map<String, dynamic> json) {
    final l$playQueueId = json['playQueueId'];
    final l$playQueueItemId = json['playQueueItemId'];
    final l$userId = json['userId'];
    final l$userName = json['userName'];
    final l$mediaType = json['mediaType'];
    final l$mediaId = json['mediaId'];
    final l$title = json['title'];
    final l$durationInMilliseconds = json['durationInMilliseconds'];
    final l$artworkImageId = json['artworkImageId'];
    final l$progressInMilliseconds = json['progressInMilliseconds'];
    final l$playState = json['playState'];
    final l$nodeName = json['nodeName'];
    final l$updatedAt = json['updatedAt'];
    final l$controllable = json['controllable'];
    final l$followerCount = json['followerCount'];
    final l$deviceId = json['deviceId'];
    final l$deviceName = json['deviceName'];
    final l$anchorPositionMs = json['anchorPositionMs'];
    final l$anchorServerTimeMs = json['anchorServerTimeMs'];
    final l$repeatMode = json['repeatMode'];
    final l$$__typename = json['__typename'];
    return Fragment$fragmentPlaybackSession(
      playQueueId: (l$playQueueId as String),
      playQueueItemId: (l$playQueueItemId as String?),
      userId: (l$userId as String),
      userName: (l$userName as String?),
      mediaType: l$mediaType == null
          ? null
          : fromJson$Enum$MediaType((l$mediaType as String)),
      mediaId: (l$mediaId as String?),
      title: (l$title as String?),
      durationInMilliseconds: (l$durationInMilliseconds as int?),
      artworkImageId: (l$artworkImageId as String?),
      progressInMilliseconds: (l$progressInMilliseconds as int),
      playState: fromJson$Enum$PlayState((l$playState as String)),
      nodeName: (l$nodeName as String),
      updatedAt: (l$updatedAt as String),
      controllable: (l$controllable as bool),
      followerCount: (l$followerCount as int),
      deviceId: (l$deviceId as String?),
      deviceName: (l$deviceName as String?),
      anchorPositionMs: (l$anchorPositionMs as int?),
      anchorServerTimeMs: (l$anchorServerTimeMs as num?)?.toDouble(),
      repeatMode: l$repeatMode == null
          ? null
          : fromJson$Enum$RepeatMode((l$repeatMode as String)),
      $__typename: (l$$__typename as String),
    );
  }

  final String playQueueId;

  final String? playQueueItemId;

  final String userId;

  final String? userName;

  final Enum$MediaType? mediaType;

  final String? mediaId;

  final String? title;

  final int? durationInMilliseconds;

  final String? artworkImageId;

  final int progressInMilliseconds;

  final Enum$PlayState playState;

  final String nodeName;

  final String updatedAt;

  final bool controllable;

  final int followerCount;

  final String? deviceId;

  final String? deviceName;

  final int? anchorPositionMs;

  final double? anchorServerTimeMs;

  final Enum$RepeatMode? repeatMode;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$playQueueId = playQueueId;
    _resultData['playQueueId'] = l$playQueueId;
    final l$playQueueItemId = playQueueItemId;
    _resultData['playQueueItemId'] = l$playQueueItemId;
    final l$userId = userId;
    _resultData['userId'] = l$userId;
    final l$userName = userName;
    _resultData['userName'] = l$userName;
    final l$mediaType = mediaType;
    _resultData['mediaType'] = l$mediaType == null
        ? null
        : toJson$Enum$MediaType(l$mediaType);
    final l$mediaId = mediaId;
    _resultData['mediaId'] = l$mediaId;
    final l$title = title;
    _resultData['title'] = l$title;
    final l$durationInMilliseconds = durationInMilliseconds;
    _resultData['durationInMilliseconds'] = l$durationInMilliseconds;
    final l$artworkImageId = artworkImageId;
    _resultData['artworkImageId'] = l$artworkImageId;
    final l$progressInMilliseconds = progressInMilliseconds;
    _resultData['progressInMilliseconds'] = l$progressInMilliseconds;
    final l$playState = playState;
    _resultData['playState'] = toJson$Enum$PlayState(l$playState);
    final l$nodeName = nodeName;
    _resultData['nodeName'] = l$nodeName;
    final l$updatedAt = updatedAt;
    _resultData['updatedAt'] = l$updatedAt;
    final l$controllable = controllable;
    _resultData['controllable'] = l$controllable;
    final l$followerCount = followerCount;
    _resultData['followerCount'] = l$followerCount;
    final l$deviceId = deviceId;
    _resultData['deviceId'] = l$deviceId;
    final l$deviceName = deviceName;
    _resultData['deviceName'] = l$deviceName;
    final l$anchorPositionMs = anchorPositionMs;
    _resultData['anchorPositionMs'] = l$anchorPositionMs;
    final l$anchorServerTimeMs = anchorServerTimeMs;
    _resultData['anchorServerTimeMs'] = l$anchorServerTimeMs;
    final l$repeatMode = repeatMode;
    _resultData['repeatMode'] = l$repeatMode == null
        ? null
        : toJson$Enum$RepeatMode(l$repeatMode);
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$playQueueId = playQueueId;
    final l$playQueueItemId = playQueueItemId;
    final l$userId = userId;
    final l$userName = userName;
    final l$mediaType = mediaType;
    final l$mediaId = mediaId;
    final l$title = title;
    final l$durationInMilliseconds = durationInMilliseconds;
    final l$artworkImageId = artworkImageId;
    final l$progressInMilliseconds = progressInMilliseconds;
    final l$playState = playState;
    final l$nodeName = nodeName;
    final l$updatedAt = updatedAt;
    final l$controllable = controllable;
    final l$followerCount = followerCount;
    final l$deviceId = deviceId;
    final l$deviceName = deviceName;
    final l$anchorPositionMs = anchorPositionMs;
    final l$anchorServerTimeMs = anchorServerTimeMs;
    final l$repeatMode = repeatMode;
    final l$$__typename = $__typename;
    return Object.hashAll([
      l$playQueueId,
      l$playQueueItemId,
      l$userId,
      l$userName,
      l$mediaType,
      l$mediaId,
      l$title,
      l$durationInMilliseconds,
      l$artworkImageId,
      l$progressInMilliseconds,
      l$playState,
      l$nodeName,
      l$updatedAt,
      l$controllable,
      l$followerCount,
      l$deviceId,
      l$deviceName,
      l$anchorPositionMs,
      l$anchorServerTimeMs,
      l$repeatMode,
      l$$__typename,
    ]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Fragment$fragmentPlaybackSession ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$playQueueId = playQueueId;
    final lOther$playQueueId = other.playQueueId;
    if (l$playQueueId != lOther$playQueueId) {
      return false;
    }
    final l$playQueueItemId = playQueueItemId;
    final lOther$playQueueItemId = other.playQueueItemId;
    if (l$playQueueItemId != lOther$playQueueItemId) {
      return false;
    }
    final l$userId = userId;
    final lOther$userId = other.userId;
    if (l$userId != lOther$userId) {
      return false;
    }
    final l$userName = userName;
    final lOther$userName = other.userName;
    if (l$userName != lOther$userName) {
      return false;
    }
    final l$mediaType = mediaType;
    final lOther$mediaType = other.mediaType;
    if (l$mediaType != lOther$mediaType) {
      return false;
    }
    final l$mediaId = mediaId;
    final lOther$mediaId = other.mediaId;
    if (l$mediaId != lOther$mediaId) {
      return false;
    }
    final l$title = title;
    final lOther$title = other.title;
    if (l$title != lOther$title) {
      return false;
    }
    final l$durationInMilliseconds = durationInMilliseconds;
    final lOther$durationInMilliseconds = other.durationInMilliseconds;
    if (l$durationInMilliseconds != lOther$durationInMilliseconds) {
      return false;
    }
    final l$artworkImageId = artworkImageId;
    final lOther$artworkImageId = other.artworkImageId;
    if (l$artworkImageId != lOther$artworkImageId) {
      return false;
    }
    final l$progressInMilliseconds = progressInMilliseconds;
    final lOther$progressInMilliseconds = other.progressInMilliseconds;
    if (l$progressInMilliseconds != lOther$progressInMilliseconds) {
      return false;
    }
    final l$playState = playState;
    final lOther$playState = other.playState;
    if (l$playState != lOther$playState) {
      return false;
    }
    final l$nodeName = nodeName;
    final lOther$nodeName = other.nodeName;
    if (l$nodeName != lOther$nodeName) {
      return false;
    }
    final l$updatedAt = updatedAt;
    final lOther$updatedAt = other.updatedAt;
    if (l$updatedAt != lOther$updatedAt) {
      return false;
    }
    final l$controllable = controllable;
    final lOther$controllable = other.controllable;
    if (l$controllable != lOther$controllable) {
      return false;
    }
    final l$followerCount = followerCount;
    final lOther$followerCount = other.followerCount;
    if (l$followerCount != lOther$followerCount) {
      return false;
    }
    final l$deviceId = deviceId;
    final lOther$deviceId = other.deviceId;
    if (l$deviceId != lOther$deviceId) {
      return false;
    }
    final l$deviceName = deviceName;
    final lOther$deviceName = other.deviceName;
    if (l$deviceName != lOther$deviceName) {
      return false;
    }
    final l$anchorPositionMs = anchorPositionMs;
    final lOther$anchorPositionMs = other.anchorPositionMs;
    if (l$anchorPositionMs != lOther$anchorPositionMs) {
      return false;
    }
    final l$anchorServerTimeMs = anchorServerTimeMs;
    final lOther$anchorServerTimeMs = other.anchorServerTimeMs;
    if (l$anchorServerTimeMs != lOther$anchorServerTimeMs) {
      return false;
    }
    final l$repeatMode = repeatMode;
    final lOther$repeatMode = other.repeatMode;
    if (l$repeatMode != lOther$repeatMode) {
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

extension UtilityExtension$Fragment$fragmentPlaybackSession
    on Fragment$fragmentPlaybackSession {
  CopyWith$Fragment$fragmentPlaybackSession<Fragment$fragmentPlaybackSession>
  get copyWith => CopyWith$Fragment$fragmentPlaybackSession(this, (i) => i);
}

abstract class CopyWith$Fragment$fragmentPlaybackSession<TRes> {
  factory CopyWith$Fragment$fragmentPlaybackSession(
    Fragment$fragmentPlaybackSession instance,
    TRes Function(Fragment$fragmentPlaybackSession) then,
  ) = _CopyWithImpl$Fragment$fragmentPlaybackSession;

  factory CopyWith$Fragment$fragmentPlaybackSession.stub(TRes res) =
      _CopyWithStubImpl$Fragment$fragmentPlaybackSession;

  TRes call({
    String? playQueueId,
    String? playQueueItemId,
    String? userId,
    String? userName,
    Enum$MediaType? mediaType,
    String? mediaId,
    String? title,
    int? durationInMilliseconds,
    String? artworkImageId,
    int? progressInMilliseconds,
    Enum$PlayState? playState,
    String? nodeName,
    String? updatedAt,
    bool? controllable,
    int? followerCount,
    String? deviceId,
    String? deviceName,
    int? anchorPositionMs,
    double? anchorServerTimeMs,
    Enum$RepeatMode? repeatMode,
    String? $__typename,
  });
}

class _CopyWithImpl$Fragment$fragmentPlaybackSession<TRes>
    implements CopyWith$Fragment$fragmentPlaybackSession<TRes> {
  _CopyWithImpl$Fragment$fragmentPlaybackSession(this._instance, this._then);

  final Fragment$fragmentPlaybackSession _instance;

  final TRes Function(Fragment$fragmentPlaybackSession) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? playQueueId = _undefined,
    Object? playQueueItemId = _undefined,
    Object? userId = _undefined,
    Object? userName = _undefined,
    Object? mediaType = _undefined,
    Object? mediaId = _undefined,
    Object? title = _undefined,
    Object? durationInMilliseconds = _undefined,
    Object? artworkImageId = _undefined,
    Object? progressInMilliseconds = _undefined,
    Object? playState = _undefined,
    Object? nodeName = _undefined,
    Object? updatedAt = _undefined,
    Object? controllable = _undefined,
    Object? followerCount = _undefined,
    Object? deviceId = _undefined,
    Object? deviceName = _undefined,
    Object? anchorPositionMs = _undefined,
    Object? anchorServerTimeMs = _undefined,
    Object? repeatMode = _undefined,
    Object? $__typename = _undefined,
  }) => _then(
    Fragment$fragmentPlaybackSession(
      playQueueId: playQueueId == _undefined || playQueueId == null
          ? _instance.playQueueId
          : (playQueueId as String),
      playQueueItemId: playQueueItemId == _undefined
          ? _instance.playQueueItemId
          : (playQueueItemId as String?),
      userId: userId == _undefined || userId == null
          ? _instance.userId
          : (userId as String),
      userName: userName == _undefined
          ? _instance.userName
          : (userName as String?),
      mediaType: mediaType == _undefined
          ? _instance.mediaType
          : (mediaType as Enum$MediaType?),
      mediaId: mediaId == _undefined ? _instance.mediaId : (mediaId as String?),
      title: title == _undefined ? _instance.title : (title as String?),
      durationInMilliseconds: durationInMilliseconds == _undefined
          ? _instance.durationInMilliseconds
          : (durationInMilliseconds as int?),
      artworkImageId: artworkImageId == _undefined
          ? _instance.artworkImageId
          : (artworkImageId as String?),
      progressInMilliseconds:
          progressInMilliseconds == _undefined || progressInMilliseconds == null
          ? _instance.progressInMilliseconds
          : (progressInMilliseconds as int),
      playState: playState == _undefined || playState == null
          ? _instance.playState
          : (playState as Enum$PlayState),
      nodeName: nodeName == _undefined || nodeName == null
          ? _instance.nodeName
          : (nodeName as String),
      updatedAt: updatedAt == _undefined || updatedAt == null
          ? _instance.updatedAt
          : (updatedAt as String),
      controllable: controllable == _undefined || controllable == null
          ? _instance.controllable
          : (controllable as bool),
      followerCount: followerCount == _undefined || followerCount == null
          ? _instance.followerCount
          : (followerCount as int),
      deviceId: deviceId == _undefined
          ? _instance.deviceId
          : (deviceId as String?),
      deviceName: deviceName == _undefined
          ? _instance.deviceName
          : (deviceName as String?),
      anchorPositionMs: anchorPositionMs == _undefined
          ? _instance.anchorPositionMs
          : (anchorPositionMs as int?),
      anchorServerTimeMs: anchorServerTimeMs == _undefined
          ? _instance.anchorServerTimeMs
          : (anchorServerTimeMs as double?),
      repeatMode: repeatMode == _undefined
          ? _instance.repeatMode
          : (repeatMode as Enum$RepeatMode?),
      $__typename: $__typename == _undefined || $__typename == null
          ? _instance.$__typename
          : ($__typename as String),
    ),
  );
}

class _CopyWithStubImpl$Fragment$fragmentPlaybackSession<TRes>
    implements CopyWith$Fragment$fragmentPlaybackSession<TRes> {
  _CopyWithStubImpl$Fragment$fragmentPlaybackSession(this._res);

  TRes _res;

  call({
    String? playQueueId,
    String? playQueueItemId,
    String? userId,
    String? userName,
    Enum$MediaType? mediaType,
    String? mediaId,
    String? title,
    int? durationInMilliseconds,
    String? artworkImageId,
    int? progressInMilliseconds,
    Enum$PlayState? playState,
    String? nodeName,
    String? updatedAt,
    bool? controllable,
    int? followerCount,
    String? deviceId,
    String? deviceName,
    int? anchorPositionMs,
    double? anchorServerTimeMs,
    Enum$RepeatMode? repeatMode,
    String? $__typename,
  }) => _res;
}

const fragmentDefinitionfragmentPlaybackSession = FragmentDefinitionNode(
  name: NameNode(value: 'fragmentPlaybackSession'),
  typeCondition: TypeConditionNode(
    on: NamedTypeNode(
      name: NameNode(value: 'PlaybackSession'),
      isNonNull: false,
    ),
  ),
  directives: [],
  selectionSet: SelectionSetNode(
    selections: [
      FieldNode(
        name: NameNode(value: 'playQueueId'),
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
        name: NameNode(value: 'userId'),
        alias: null,
        arguments: [],
        directives: [],
        selectionSet: null,
      ),
      FieldNode(
        name: NameNode(value: 'userName'),
        alias: null,
        arguments: [],
        directives: [],
        selectionSet: null,
      ),
      FieldNode(
        name: NameNode(value: 'mediaType'),
        alias: null,
        arguments: [],
        directives: [],
        selectionSet: null,
      ),
      FieldNode(
        name: NameNode(value: 'mediaId'),
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
        name: NameNode(value: 'durationInMilliseconds'),
        alias: null,
        arguments: [],
        directives: [],
        selectionSet: null,
      ),
      FieldNode(
        name: NameNode(value: 'artworkImageId'),
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
        name: NameNode(value: 'playState'),
        alias: null,
        arguments: [],
        directives: [],
        selectionSet: null,
      ),
      FieldNode(
        name: NameNode(value: 'nodeName'),
        alias: null,
        arguments: [],
        directives: [],
        selectionSet: null,
      ),
      FieldNode(
        name: NameNode(value: 'updatedAt'),
        alias: null,
        arguments: [],
        directives: [],
        selectionSet: null,
      ),
      FieldNode(
        name: NameNode(value: 'controllable'),
        alias: null,
        arguments: [],
        directives: [],
        selectionSet: null,
      ),
      FieldNode(
        name: NameNode(value: 'followerCount'),
        alias: null,
        arguments: [],
        directives: [],
        selectionSet: null,
      ),
      FieldNode(
        name: NameNode(value: 'deviceId'),
        alias: null,
        arguments: [],
        directives: [],
        selectionSet: null,
      ),
      FieldNode(
        name: NameNode(value: 'deviceName'),
        alias: null,
        arguments: [],
        directives: [],
        selectionSet: null,
      ),
      FieldNode(
        name: NameNode(value: 'anchorPositionMs'),
        alias: null,
        arguments: [],
        directives: [],
        selectionSet: null,
      ),
      FieldNode(
        name: NameNode(value: 'anchorServerTimeMs'),
        alias: null,
        arguments: [],
        directives: [],
        selectionSet: null,
      ),
      FieldNode(
        name: NameNode(value: 'repeatMode'),
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
);
const documentNodeFragmentfragmentPlaybackSession = DocumentNode(
  definitions: [fragmentDefinitionfragmentPlaybackSession],
);

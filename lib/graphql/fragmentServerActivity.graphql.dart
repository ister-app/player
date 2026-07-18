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
    String? $__typename,
  }) => _res;

  processing(_fn) => _res;

  queueStats(_fn) => _res;

  CopyWith$Fragment$fragmentEventFailure<TRes> get failure =>
      CopyWith$Fragment$fragmentEventFailure.stub(_res);
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
  ],
);

class Fragment$fragmentServerActivityEvent$processing {
  Fragment$fragmentServerActivityEvent$processing({
    required this.queue,
    required this.eventType,
    required this.startedAt,
    this.$__typename = 'ProcessingItem',
  });

  factory Fragment$fragmentServerActivityEvent$processing.fromJson(
    Map<String, dynamic> json,
  ) {
    final l$queue = json['queue'];
    final l$eventType = json['eventType'];
    final l$startedAt = json['startedAt'];
    final l$$__typename = json['__typename'];
    return Fragment$fragmentServerActivityEvent$processing(
      queue: (l$queue as String),
      eventType: (l$eventType as String),
      startedAt: (l$startedAt as String),
      $__typename: (l$$__typename as String),
    );
  }

  final String queue;

  final String eventType;

  final String startedAt;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$queue = queue;
    _resultData['queue'] = l$queue;
    final l$eventType = eventType;
    _resultData['eventType'] = l$eventType;
    final l$startedAt = startedAt;
    _resultData['startedAt'] = l$startedAt;
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$queue = queue;
    final l$eventType = eventType;
    final l$startedAt = startedAt;
    final l$$__typename = $__typename;
    return Object.hashAll([l$queue, l$eventType, l$startedAt, l$$__typename]);
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

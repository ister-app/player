import 'fragmentServerActivity.graphql.dart';
import 'package:gql/ast.dart';

class Query$serverActivitySnapshot {
  Query$serverActivitySnapshot({
    required this.serverActivitySnapshot,
    this.$__typename = 'Query',
  });

  factory Query$serverActivitySnapshot.fromJson(Map<String, dynamic> json) {
    final l$serverActivitySnapshot = json['serverActivitySnapshot'];
    final l$$__typename = json['__typename'];
    return Query$serverActivitySnapshot(
      serverActivitySnapshot:
          Query$serverActivitySnapshot$serverActivitySnapshot.fromJson(
            (l$serverActivitySnapshot as Map<String, dynamic>),
          ),
      $__typename: (l$$__typename as String),
    );
  }

  final Query$serverActivitySnapshot$serverActivitySnapshot
  serverActivitySnapshot;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$serverActivitySnapshot = serverActivitySnapshot;
    _resultData['serverActivitySnapshot'] = l$serverActivitySnapshot.toJson();
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$serverActivitySnapshot = serverActivitySnapshot;
    final l$$__typename = $__typename;
    return Object.hashAll([l$serverActivitySnapshot, l$$__typename]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Query$serverActivitySnapshot ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$serverActivitySnapshot = serverActivitySnapshot;
    final lOther$serverActivitySnapshot = other.serverActivitySnapshot;
    if (l$serverActivitySnapshot != lOther$serverActivitySnapshot) {
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

extension UtilityExtension$Query$serverActivitySnapshot
    on Query$serverActivitySnapshot {
  CopyWith$Query$serverActivitySnapshot<Query$serverActivitySnapshot>
  get copyWith => CopyWith$Query$serverActivitySnapshot(this, (i) => i);
}

abstract class CopyWith$Query$serverActivitySnapshot<TRes> {
  factory CopyWith$Query$serverActivitySnapshot(
    Query$serverActivitySnapshot instance,
    TRes Function(Query$serverActivitySnapshot) then,
  ) = _CopyWithImpl$Query$serverActivitySnapshot;

  factory CopyWith$Query$serverActivitySnapshot.stub(TRes res) =
      _CopyWithStubImpl$Query$serverActivitySnapshot;

  TRes call({
    Query$serverActivitySnapshot$serverActivitySnapshot? serverActivitySnapshot,
    String? $__typename,
  });
  CopyWith$Query$serverActivitySnapshot$serverActivitySnapshot<TRes>
  get serverActivitySnapshot;
}

class _CopyWithImpl$Query$serverActivitySnapshot<TRes>
    implements CopyWith$Query$serverActivitySnapshot<TRes> {
  _CopyWithImpl$Query$serverActivitySnapshot(this._instance, this._then);

  final Query$serverActivitySnapshot _instance;

  final TRes Function(Query$serverActivitySnapshot) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? serverActivitySnapshot = _undefined,
    Object? $__typename = _undefined,
  }) => _then(
    Query$serverActivitySnapshot(
      serverActivitySnapshot:
          serverActivitySnapshot == _undefined || serverActivitySnapshot == null
          ? _instance.serverActivitySnapshot
          : (serverActivitySnapshot
                as Query$serverActivitySnapshot$serverActivitySnapshot),
      $__typename: $__typename == _undefined || $__typename == null
          ? _instance.$__typename
          : ($__typename as String),
    ),
  );

  CopyWith$Query$serverActivitySnapshot$serverActivitySnapshot<TRes>
  get serverActivitySnapshot {
    final local$serverActivitySnapshot = _instance.serverActivitySnapshot;
    return CopyWith$Query$serverActivitySnapshot$serverActivitySnapshot(
      local$serverActivitySnapshot,
      (e) => call(serverActivitySnapshot: e),
    );
  }
}

class _CopyWithStubImpl$Query$serverActivitySnapshot<TRes>
    implements CopyWith$Query$serverActivitySnapshot<TRes> {
  _CopyWithStubImpl$Query$serverActivitySnapshot(this._res);

  TRes _res;

  call({
    Query$serverActivitySnapshot$serverActivitySnapshot? serverActivitySnapshot,
    String? $__typename,
  }) => _res;

  CopyWith$Query$serverActivitySnapshot$serverActivitySnapshot<TRes>
  get serverActivitySnapshot =>
      CopyWith$Query$serverActivitySnapshot$serverActivitySnapshot.stub(_res);
}

const documentNodeQueryserverActivitySnapshot = DocumentNode(
  definitions: [
    OperationDefinitionNode(
      type: OperationType.query,
      name: NameNode(value: 'serverActivitySnapshot'),
      variableDefinitions: [],
      directives: [],
      selectionSet: SelectionSetNode(
        selections: [
          FieldNode(
            name: NameNode(value: 'serverActivitySnapshot'),
            alias: null,
            arguments: [],
            directives: [],
            selectionSet: SelectionSetNode(
              selections: [
                FieldNode(
                  name: NameNode(value: 'nodes'),
                  alias: null,
                  arguments: [],
                  directives: [],
                  selectionSet: SelectionSetNode(
                    selections: [
                      FragmentSpreadNode(
                        name: NameNode(value: 'fragmentServerActivityEvent'),
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
                  name: NameNode(value: 'recentFailures'),
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
                  name: NameNode(value: 'nowPlaying'),
                  alias: null,
                  arguments: [],
                  directives: [],
                  selectionSet: SelectionSetNode(
                    selections: [
                      FragmentSpreadNode(
                        name: NameNode(value: 'fragmentPlaybackSession'),
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
            name: NameNode(value: '__typename'),
            alias: null,
            arguments: [],
            directives: [],
            selectionSet: null,
          ),
        ],
      ),
    ),
    fragmentDefinitionfragmentServerActivityEvent,
    fragmentDefinitionfragmentQueueStat,
    fragmentDefinitionfragmentEventFailure,
    fragmentDefinitionfragmentPlaybackSession,
  ],
);

class Query$serverActivitySnapshot$serverActivitySnapshot {
  Query$serverActivitySnapshot$serverActivitySnapshot({
    required this.nodes,
    required this.queueStats,
    required this.recentFailures,
    required this.nowPlaying,
    this.$__typename = 'ServerActivitySnapshot',
  });

  factory Query$serverActivitySnapshot$serverActivitySnapshot.fromJson(
    Map<String, dynamic> json,
  ) {
    final l$nodes = json['nodes'];
    final l$queueStats = json['queueStats'];
    final l$recentFailures = json['recentFailures'];
    final l$nowPlaying = json['nowPlaying'];
    final l$$__typename = json['__typename'];
    return Query$serverActivitySnapshot$serverActivitySnapshot(
      nodes: (l$nodes as List<dynamic>)
          .map(
            (e) => Fragment$fragmentServerActivityEvent.fromJson(
              (e as Map<String, dynamic>),
            ),
          )
          .toList(),
      queueStats: (l$queueStats as List<dynamic>)
          .map(
            (e) => Fragment$fragmentQueueStat.fromJson(
              (e as Map<String, dynamic>),
            ),
          )
          .toList(),
      recentFailures: (l$recentFailures as List<dynamic>)
          .map(
            (e) => Fragment$fragmentEventFailure.fromJson(
              (e as Map<String, dynamic>),
            ),
          )
          .toList(),
      nowPlaying: (l$nowPlaying as List<dynamic>)
          .map(
            (e) => Fragment$fragmentPlaybackSession.fromJson(
              (e as Map<String, dynamic>),
            ),
          )
          .toList(),
      $__typename: (l$$__typename as String),
    );
  }

  final List<Fragment$fragmentServerActivityEvent> nodes;

  final List<Fragment$fragmentQueueStat> queueStats;

  final List<Fragment$fragmentEventFailure> recentFailures;

  final List<Fragment$fragmentPlaybackSession> nowPlaying;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$nodes = nodes;
    _resultData['nodes'] = l$nodes.map((e) => e.toJson()).toList();
    final l$queueStats = queueStats;
    _resultData['queueStats'] = l$queueStats.map((e) => e.toJson()).toList();
    final l$recentFailures = recentFailures;
    _resultData['recentFailures'] = l$recentFailures
        .map((e) => e.toJson())
        .toList();
    final l$nowPlaying = nowPlaying;
    _resultData['nowPlaying'] = l$nowPlaying.map((e) => e.toJson()).toList();
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$nodes = nodes;
    final l$queueStats = queueStats;
    final l$recentFailures = recentFailures;
    final l$nowPlaying = nowPlaying;
    final l$$__typename = $__typename;
    return Object.hashAll([
      Object.hashAll(l$nodes.map((v) => v)),
      Object.hashAll(l$queueStats.map((v) => v)),
      Object.hashAll(l$recentFailures.map((v) => v)),
      Object.hashAll(l$nowPlaying.map((v) => v)),
      l$$__typename,
    ]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Query$serverActivitySnapshot$serverActivitySnapshot ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$nodes = nodes;
    final lOther$nodes = other.nodes;
    if (l$nodes.length != lOther$nodes.length) {
      return false;
    }
    for (int i = 0; i < l$nodes.length; i++) {
      final l$nodes$entry = l$nodes[i];
      final lOther$nodes$entry = lOther$nodes[i];
      if (l$nodes$entry != lOther$nodes$entry) {
        return false;
      }
    }
    final l$queueStats = queueStats;
    final lOther$queueStats = other.queueStats;
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
    final l$recentFailures = recentFailures;
    final lOther$recentFailures = other.recentFailures;
    if (l$recentFailures.length != lOther$recentFailures.length) {
      return false;
    }
    for (int i = 0; i < l$recentFailures.length; i++) {
      final l$recentFailures$entry = l$recentFailures[i];
      final lOther$recentFailures$entry = lOther$recentFailures[i];
      if (l$recentFailures$entry != lOther$recentFailures$entry) {
        return false;
      }
    }
    final l$nowPlaying = nowPlaying;
    final lOther$nowPlaying = other.nowPlaying;
    if (l$nowPlaying.length != lOther$nowPlaying.length) {
      return false;
    }
    for (int i = 0; i < l$nowPlaying.length; i++) {
      final l$nowPlaying$entry = l$nowPlaying[i];
      final lOther$nowPlaying$entry = lOther$nowPlaying[i];
      if (l$nowPlaying$entry != lOther$nowPlaying$entry) {
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

extension UtilityExtension$Query$serverActivitySnapshot$serverActivitySnapshot
    on Query$serverActivitySnapshot$serverActivitySnapshot {
  CopyWith$Query$serverActivitySnapshot$serverActivitySnapshot<
    Query$serverActivitySnapshot$serverActivitySnapshot
  >
  get copyWith => CopyWith$Query$serverActivitySnapshot$serverActivitySnapshot(
    this,
    (i) => i,
  );
}

abstract class CopyWith$Query$serverActivitySnapshot$serverActivitySnapshot<
  TRes
> {
  factory CopyWith$Query$serverActivitySnapshot$serverActivitySnapshot(
    Query$serverActivitySnapshot$serverActivitySnapshot instance,
    TRes Function(Query$serverActivitySnapshot$serverActivitySnapshot) then,
  ) = _CopyWithImpl$Query$serverActivitySnapshot$serverActivitySnapshot;

  factory CopyWith$Query$serverActivitySnapshot$serverActivitySnapshot.stub(
    TRes res,
  ) = _CopyWithStubImpl$Query$serverActivitySnapshot$serverActivitySnapshot;

  TRes call({
    List<Fragment$fragmentServerActivityEvent>? nodes,
    List<Fragment$fragmentQueueStat>? queueStats,
    List<Fragment$fragmentEventFailure>? recentFailures,
    List<Fragment$fragmentPlaybackSession>? nowPlaying,
    String? $__typename,
  });
  TRes nodes(
    Iterable<Fragment$fragmentServerActivityEvent> Function(
      Iterable<
        CopyWith$Fragment$fragmentServerActivityEvent<
          Fragment$fragmentServerActivityEvent
        >
      >,
    )
    _fn,
  );
  TRes queueStats(
    Iterable<Fragment$fragmentQueueStat> Function(
      Iterable<CopyWith$Fragment$fragmentQueueStat<Fragment$fragmentQueueStat>>,
    )
    _fn,
  );
  TRes recentFailures(
    Iterable<Fragment$fragmentEventFailure> Function(
      Iterable<
        CopyWith$Fragment$fragmentEventFailure<Fragment$fragmentEventFailure>
      >,
    )
    _fn,
  );
  TRes nowPlaying(
    Iterable<Fragment$fragmentPlaybackSession> Function(
      Iterable<
        CopyWith$Fragment$fragmentPlaybackSession<
          Fragment$fragmentPlaybackSession
        >
      >,
    )
    _fn,
  );
}

class _CopyWithImpl$Query$serverActivitySnapshot$serverActivitySnapshot<TRes>
    implements
        CopyWith$Query$serverActivitySnapshot$serverActivitySnapshot<TRes> {
  _CopyWithImpl$Query$serverActivitySnapshot$serverActivitySnapshot(
    this._instance,
    this._then,
  );

  final Query$serverActivitySnapshot$serverActivitySnapshot _instance;

  final TRes Function(Query$serverActivitySnapshot$serverActivitySnapshot)
  _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? nodes = _undefined,
    Object? queueStats = _undefined,
    Object? recentFailures = _undefined,
    Object? nowPlaying = _undefined,
    Object? $__typename = _undefined,
  }) => _then(
    Query$serverActivitySnapshot$serverActivitySnapshot(
      nodes: nodes == _undefined || nodes == null
          ? _instance.nodes
          : (nodes as List<Fragment$fragmentServerActivityEvent>),
      queueStats: queueStats == _undefined || queueStats == null
          ? _instance.queueStats
          : (queueStats as List<Fragment$fragmentQueueStat>),
      recentFailures: recentFailures == _undefined || recentFailures == null
          ? _instance.recentFailures
          : (recentFailures as List<Fragment$fragmentEventFailure>),
      nowPlaying: nowPlaying == _undefined || nowPlaying == null
          ? _instance.nowPlaying
          : (nowPlaying as List<Fragment$fragmentPlaybackSession>),
      $__typename: $__typename == _undefined || $__typename == null
          ? _instance.$__typename
          : ($__typename as String),
    ),
  );

  TRes nodes(
    Iterable<Fragment$fragmentServerActivityEvent> Function(
      Iterable<
        CopyWith$Fragment$fragmentServerActivityEvent<
          Fragment$fragmentServerActivityEvent
        >
      >,
    )
    _fn,
  ) => call(
    nodes: _fn(
      _instance.nodes.map(
        (e) => CopyWith$Fragment$fragmentServerActivityEvent(e, (i) => i),
      ),
    ).toList(),
  );

  TRes queueStats(
    Iterable<Fragment$fragmentQueueStat> Function(
      Iterable<CopyWith$Fragment$fragmentQueueStat<Fragment$fragmentQueueStat>>,
    )
    _fn,
  ) => call(
    queueStats: _fn(
      _instance.queueStats.map(
        (e) => CopyWith$Fragment$fragmentQueueStat(e, (i) => i),
      ),
    ).toList(),
  );

  TRes recentFailures(
    Iterable<Fragment$fragmentEventFailure> Function(
      Iterable<
        CopyWith$Fragment$fragmentEventFailure<Fragment$fragmentEventFailure>
      >,
    )
    _fn,
  ) => call(
    recentFailures: _fn(
      _instance.recentFailures.map(
        (e) => CopyWith$Fragment$fragmentEventFailure(e, (i) => i),
      ),
    ).toList(),
  );

  TRes nowPlaying(
    Iterable<Fragment$fragmentPlaybackSession> Function(
      Iterable<
        CopyWith$Fragment$fragmentPlaybackSession<
          Fragment$fragmentPlaybackSession
        >
      >,
    )
    _fn,
  ) => call(
    nowPlaying: _fn(
      _instance.nowPlaying.map(
        (e) => CopyWith$Fragment$fragmentPlaybackSession(e, (i) => i),
      ),
    ).toList(),
  );
}

class _CopyWithStubImpl$Query$serverActivitySnapshot$serverActivitySnapshot<
  TRes
>
    implements
        CopyWith$Query$serverActivitySnapshot$serverActivitySnapshot<TRes> {
  _CopyWithStubImpl$Query$serverActivitySnapshot$serverActivitySnapshot(
    this._res,
  );

  TRes _res;

  call({
    List<Fragment$fragmentServerActivityEvent>? nodes,
    List<Fragment$fragmentQueueStat>? queueStats,
    List<Fragment$fragmentEventFailure>? recentFailures,
    List<Fragment$fragmentPlaybackSession>? nowPlaying,
    String? $__typename,
  }) => _res;

  nodes(_fn) => _res;

  queueStats(_fn) => _res;

  recentFailures(_fn) => _res;

  nowPlaying(_fn) => _res;
}

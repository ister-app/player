import 'fragmentMetadata.graphql.dart';

import 'package:gql/ast.dart';

import 'schema.graphql.dart';

class Variables$Query$trackPlaybackHistory {
  factory Variables$Query$trackPlaybackHistory({
    required Enum$TrackHistoryScope scope,
    required String id,
    int? limit,
  }) => Variables$Query$trackPlaybackHistory._({
    r'scope': scope,
    r'id': id,
    if (limit != null) r'limit': limit,
  });

  Variables$Query$trackPlaybackHistory._(this._$data);

  factory Variables$Query$trackPlaybackHistory.fromJson(
    Map<String, dynamic> data,
  ) {
    final result$data = <String, dynamic>{};
    final l$scope = data['scope'];
    result$data['scope'] = fromJson$Enum$TrackHistoryScope((l$scope as String));
    final l$id = data['id'];
    result$data['id'] = (l$id as String);
    if (data.containsKey('limit')) {
      final l$limit = data['limit'];
      result$data['limit'] = (l$limit as int?);
    }
    return Variables$Query$trackPlaybackHistory._(result$data);
  }

  Map<String, dynamic> _$data;

  Enum$TrackHistoryScope get scope =>
      (_$data['scope'] as Enum$TrackHistoryScope);

  String get id => (_$data['id'] as String);

  int? get limit => (_$data['limit'] as int?);

  Map<String, dynamic> toJson() {
    final result$data = <String, dynamic>{};
    final l$scope = scope;
    result$data['scope'] = toJson$Enum$TrackHistoryScope(l$scope);
    final l$id = id;
    result$data['id'] = l$id;
    if (_$data.containsKey('limit')) {
      final l$limit = limit;
      result$data['limit'] = l$limit;
    }
    return result$data;
  }

  CopyWith$Variables$Query$trackPlaybackHistory<
    Variables$Query$trackPlaybackHistory
  >
  get copyWith => CopyWith$Variables$Query$trackPlaybackHistory(this, (i) => i);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Variables$Query$trackPlaybackHistory ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$scope = scope;
    final lOther$scope = other.scope;
    if (l$scope != lOther$scope) {
      return false;
    }
    final l$id = id;
    final lOther$id = other.id;
    if (l$id != lOther$id) {
      return false;
    }
    final l$limit = limit;
    final lOther$limit = other.limit;
    if (_$data.containsKey('limit') != other._$data.containsKey('limit')) {
      return false;
    }
    if (l$limit != lOther$limit) {
      return false;
    }
    return true;
  }

  @override
  int get hashCode {
    final l$scope = scope;
    final l$id = id;
    final l$limit = limit;
    return Object.hashAll([
      l$scope,
      l$id,
      _$data.containsKey('limit') ? l$limit : const {},
    ]);
  }
}

abstract class CopyWith$Variables$Query$trackPlaybackHistory<TRes> {
  factory CopyWith$Variables$Query$trackPlaybackHistory(
    Variables$Query$trackPlaybackHistory instance,
    TRes Function(Variables$Query$trackPlaybackHistory) then,
  ) = _CopyWithImpl$Variables$Query$trackPlaybackHistory;

  factory CopyWith$Variables$Query$trackPlaybackHistory.stub(TRes res) =
      _CopyWithStubImpl$Variables$Query$trackPlaybackHistory;

  TRes call({Enum$TrackHistoryScope? scope, String? id, int? limit});
}

class _CopyWithImpl$Variables$Query$trackPlaybackHistory<TRes>
    implements CopyWith$Variables$Query$trackPlaybackHistory<TRes> {
  _CopyWithImpl$Variables$Query$trackPlaybackHistory(
    this._instance,
    this._then,
  );

  final Variables$Query$trackPlaybackHistory _instance;

  final TRes Function(Variables$Query$trackPlaybackHistory) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? scope = _undefined,
    Object? id = _undefined,
    Object? limit = _undefined,
  }) => _then(
    Variables$Query$trackPlaybackHistory._({
      ..._instance._$data,
      if (scope != _undefined && scope != null)
        'scope': (scope as Enum$TrackHistoryScope),
      if (id != _undefined && id != null) 'id': (id as String),
      if (limit != _undefined) 'limit': (limit as int?),
    }),
  );
}

class _CopyWithStubImpl$Variables$Query$trackPlaybackHistory<TRes>
    implements CopyWith$Variables$Query$trackPlaybackHistory<TRes> {
  _CopyWithStubImpl$Variables$Query$trackPlaybackHistory(this._res);

  TRes _res;

  call({Enum$TrackHistoryScope? scope, String? id, int? limit}) => _res;
}

class Query$trackPlaybackHistory {
  Query$trackPlaybackHistory({
    required this.trackPlaybackHistory,
    this.$__typename = 'Query',
  });

  factory Query$trackPlaybackHistory.fromJson(Map<String, dynamic> json) {
    final l$trackPlaybackHistory = json['trackPlaybackHistory'];
    final l$$__typename = json['__typename'];
    return Query$trackPlaybackHistory(
      trackPlaybackHistory: (l$trackPlaybackHistory as List<dynamic>)
          .map(
            (e) => Query$trackPlaybackHistory$trackPlaybackHistory.fromJson(
              (e as Map<String, dynamic>),
            ),
          )
          .toList(),
      $__typename: (l$$__typename as String),
    );
  }

  final List<Query$trackPlaybackHistory$trackPlaybackHistory>
  trackPlaybackHistory;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$trackPlaybackHistory = trackPlaybackHistory;
    _resultData['trackPlaybackHistory'] = l$trackPlaybackHistory
        .map((e) => e.toJson())
        .toList();
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$trackPlaybackHistory = trackPlaybackHistory;
    final l$$__typename = $__typename;
    return Object.hashAll([
      Object.hashAll(l$trackPlaybackHistory.map((v) => v)),
      l$$__typename,
    ]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Query$trackPlaybackHistory ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$trackPlaybackHistory = trackPlaybackHistory;
    final lOther$trackPlaybackHistory = other.trackPlaybackHistory;
    if (l$trackPlaybackHistory.length != lOther$trackPlaybackHistory.length) {
      return false;
    }
    for (int i = 0; i < l$trackPlaybackHistory.length; i++) {
      final l$trackPlaybackHistory$entry = l$trackPlaybackHistory[i];
      final lOther$trackPlaybackHistory$entry = lOther$trackPlaybackHistory[i];
      if (l$trackPlaybackHistory$entry != lOther$trackPlaybackHistory$entry) {
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

extension UtilityExtension$Query$trackPlaybackHistory
    on Query$trackPlaybackHistory {
  CopyWith$Query$trackPlaybackHistory<Query$trackPlaybackHistory>
  get copyWith => CopyWith$Query$trackPlaybackHistory(this, (i) => i);
}

abstract class CopyWith$Query$trackPlaybackHistory<TRes> {
  factory CopyWith$Query$trackPlaybackHistory(
    Query$trackPlaybackHistory instance,
    TRes Function(Query$trackPlaybackHistory) then,
  ) = _CopyWithImpl$Query$trackPlaybackHistory;

  factory CopyWith$Query$trackPlaybackHistory.stub(TRes res) =
      _CopyWithStubImpl$Query$trackPlaybackHistory;

  TRes call({
    List<Query$trackPlaybackHistory$trackPlaybackHistory>? trackPlaybackHistory,
    String? $__typename,
  });
  TRes trackPlaybackHistory(
    Iterable<Query$trackPlaybackHistory$trackPlaybackHistory> Function(
      Iterable<
        CopyWith$Query$trackPlaybackHistory$trackPlaybackHistory<
          Query$trackPlaybackHistory$trackPlaybackHistory
        >
      >,
    )
    _fn,
  );
}

class _CopyWithImpl$Query$trackPlaybackHistory<TRes>
    implements CopyWith$Query$trackPlaybackHistory<TRes> {
  _CopyWithImpl$Query$trackPlaybackHistory(this._instance, this._then);

  final Query$trackPlaybackHistory _instance;

  final TRes Function(Query$trackPlaybackHistory) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? trackPlaybackHistory = _undefined,
    Object? $__typename = _undefined,
  }) => _then(
    Query$trackPlaybackHistory(
      trackPlaybackHistory:
          trackPlaybackHistory == _undefined || trackPlaybackHistory == null
          ? _instance.trackPlaybackHistory
          : (trackPlaybackHistory
                as List<Query$trackPlaybackHistory$trackPlaybackHistory>),
      $__typename: $__typename == _undefined || $__typename == null
          ? _instance.$__typename
          : ($__typename as String),
    ),
  );

  TRes trackPlaybackHistory(
    Iterable<Query$trackPlaybackHistory$trackPlaybackHistory> Function(
      Iterable<
        CopyWith$Query$trackPlaybackHistory$trackPlaybackHistory<
          Query$trackPlaybackHistory$trackPlaybackHistory
        >
      >,
    )
    _fn,
  ) => call(
    trackPlaybackHistory: _fn(
      _instance.trackPlaybackHistory.map(
        (e) => CopyWith$Query$trackPlaybackHistory$trackPlaybackHistory(
          e,
          (i) => i,
        ),
      ),
    ).toList(),
  );
}

class _CopyWithStubImpl$Query$trackPlaybackHistory<TRes>
    implements CopyWith$Query$trackPlaybackHistory<TRes> {
  _CopyWithStubImpl$Query$trackPlaybackHistory(this._res);

  TRes _res;

  call({
    List<Query$trackPlaybackHistory$trackPlaybackHistory>? trackPlaybackHistory,
    String? $__typename,
  }) => _res;

  trackPlaybackHistory(_fn) => _res;
}

const documentNodeQuerytrackPlaybackHistory = DocumentNode(
  definitions: [
    OperationDefinitionNode(
      type: OperationType.query,
      name: NameNode(value: 'trackPlaybackHistory'),
      variableDefinitions: [
        VariableDefinitionNode(
          variable: VariableNode(name: NameNode(value: 'scope')),
          type: NamedTypeNode(
            name: NameNode(value: 'TrackHistoryScope'),
            isNonNull: true,
          ),
          defaultValue: DefaultValueNode(value: null),
          directives: [],
        ),
        VariableDefinitionNode(
          variable: VariableNode(name: NameNode(value: 'id')),
          type: NamedTypeNode(name: NameNode(value: 'ID'), isNonNull: true),
          defaultValue: DefaultValueNode(value: null),
          directives: [],
        ),
        VariableDefinitionNode(
          variable: VariableNode(name: NameNode(value: 'limit')),
          type: NamedTypeNode(name: NameNode(value: 'Int'), isNonNull: false),
          defaultValue: DefaultValueNode(value: null),
          directives: [],
        ),
      ],
      directives: [],
      selectionSet: SelectionSetNode(
        selections: [
          FieldNode(
            name: NameNode(value: 'trackPlaybackHistory'),
            alias: null,
            arguments: [
              ArgumentNode(
                name: NameNode(value: 'scope'),
                value: VariableNode(name: NameNode(value: 'scope')),
              ),
              ArgumentNode(
                name: NameNode(value: 'id'),
                value: VariableNode(name: NameNode(value: 'id')),
              ),
              ArgumentNode(
                name: NameNode(value: 'limit'),
                value: VariableNode(name: NameNode(value: 'limit')),
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
                  name: NameNode(value: 'watched'),
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
                  name: NameNode(value: 'createdAt'),
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
                  name: NameNode(value: 'track'),
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
  ],
);

class Query$trackPlaybackHistory$trackPlaybackHistory {
  Query$trackPlaybackHistory$trackPlaybackHistory({
    required this.id,
    required this.watched,
    required this.progressInMilliseconds,
    required this.createdAt,
    required this.updatedAt,
    this.track,
    this.$__typename = 'WatchStatus',
  });

  factory Query$trackPlaybackHistory$trackPlaybackHistory.fromJson(
    Map<String, dynamic> json,
  ) {
    final l$id = json['id'];
    final l$watched = json['watched'];
    final l$progressInMilliseconds = json['progressInMilliseconds'];
    final l$createdAt = json['createdAt'];
    final l$updatedAt = json['updatedAt'];
    final l$track = json['track'];
    final l$$__typename = json['__typename'];
    return Query$trackPlaybackHistory$trackPlaybackHistory(
      id: (l$id as String),
      watched: (l$watched as bool),
      progressInMilliseconds: (l$progressInMilliseconds as int),
      createdAt: (l$createdAt as String),
      updatedAt: (l$updatedAt as String),
      track: l$track == null
          ? null
          : Query$trackPlaybackHistory$trackPlaybackHistory$track.fromJson(
              (l$track as Map<String, dynamic>),
            ),
      $__typename: (l$$__typename as String),
    );
  }

  final String id;

  final bool watched;

  final int progressInMilliseconds;

  final String createdAt;

  final String updatedAt;

  final Query$trackPlaybackHistory$trackPlaybackHistory$track? track;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$id = id;
    _resultData['id'] = l$id;
    final l$watched = watched;
    _resultData['watched'] = l$watched;
    final l$progressInMilliseconds = progressInMilliseconds;
    _resultData['progressInMilliseconds'] = l$progressInMilliseconds;
    final l$createdAt = createdAt;
    _resultData['createdAt'] = l$createdAt;
    final l$updatedAt = updatedAt;
    _resultData['updatedAt'] = l$updatedAt;
    final l$track = track;
    _resultData['track'] = l$track?.toJson();
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$id = id;
    final l$watched = watched;
    final l$progressInMilliseconds = progressInMilliseconds;
    final l$createdAt = createdAt;
    final l$updatedAt = updatedAt;
    final l$track = track;
    final l$$__typename = $__typename;
    return Object.hashAll([
      l$id,
      l$watched,
      l$progressInMilliseconds,
      l$createdAt,
      l$updatedAt,
      l$track,
      l$$__typename,
    ]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Query$trackPlaybackHistory$trackPlaybackHistory ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$id = id;
    final lOther$id = other.id;
    if (l$id != lOther$id) {
      return false;
    }
    final l$watched = watched;
    final lOther$watched = other.watched;
    if (l$watched != lOther$watched) {
      return false;
    }
    final l$progressInMilliseconds = progressInMilliseconds;
    final lOther$progressInMilliseconds = other.progressInMilliseconds;
    if (l$progressInMilliseconds != lOther$progressInMilliseconds) {
      return false;
    }
    final l$createdAt = createdAt;
    final lOther$createdAt = other.createdAt;
    if (l$createdAt != lOther$createdAt) {
      return false;
    }
    final l$updatedAt = updatedAt;
    final lOther$updatedAt = other.updatedAt;
    if (l$updatedAt != lOther$updatedAt) {
      return false;
    }
    final l$track = track;
    final lOther$track = other.track;
    if (l$track != lOther$track) {
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

extension UtilityExtension$Query$trackPlaybackHistory$trackPlaybackHistory
    on Query$trackPlaybackHistory$trackPlaybackHistory {
  CopyWith$Query$trackPlaybackHistory$trackPlaybackHistory<
    Query$trackPlaybackHistory$trackPlaybackHistory
  >
  get copyWith =>
      CopyWith$Query$trackPlaybackHistory$trackPlaybackHistory(this, (i) => i);
}

abstract class CopyWith$Query$trackPlaybackHistory$trackPlaybackHistory<TRes> {
  factory CopyWith$Query$trackPlaybackHistory$trackPlaybackHistory(
    Query$trackPlaybackHistory$trackPlaybackHistory instance,
    TRes Function(Query$trackPlaybackHistory$trackPlaybackHistory) then,
  ) = _CopyWithImpl$Query$trackPlaybackHistory$trackPlaybackHistory;

  factory CopyWith$Query$trackPlaybackHistory$trackPlaybackHistory.stub(
    TRes res,
  ) = _CopyWithStubImpl$Query$trackPlaybackHistory$trackPlaybackHistory;

  TRes call({
    String? id,
    bool? watched,
    int? progressInMilliseconds,
    String? createdAt,
    String? updatedAt,
    Query$trackPlaybackHistory$trackPlaybackHistory$track? track,
    String? $__typename,
  });
  CopyWith$Query$trackPlaybackHistory$trackPlaybackHistory$track<TRes>
  get track;
}

class _CopyWithImpl$Query$trackPlaybackHistory$trackPlaybackHistory<TRes>
    implements CopyWith$Query$trackPlaybackHistory$trackPlaybackHistory<TRes> {
  _CopyWithImpl$Query$trackPlaybackHistory$trackPlaybackHistory(
    this._instance,
    this._then,
  );

  final Query$trackPlaybackHistory$trackPlaybackHistory _instance;

  final TRes Function(Query$trackPlaybackHistory$trackPlaybackHistory) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? id = _undefined,
    Object? watched = _undefined,
    Object? progressInMilliseconds = _undefined,
    Object? createdAt = _undefined,
    Object? updatedAt = _undefined,
    Object? track = _undefined,
    Object? $__typename = _undefined,
  }) => _then(
    Query$trackPlaybackHistory$trackPlaybackHistory(
      id: id == _undefined || id == null ? _instance.id : (id as String),
      watched: watched == _undefined || watched == null
          ? _instance.watched
          : (watched as bool),
      progressInMilliseconds:
          progressInMilliseconds == _undefined || progressInMilliseconds == null
          ? _instance.progressInMilliseconds
          : (progressInMilliseconds as int),
      createdAt: createdAt == _undefined || createdAt == null
          ? _instance.createdAt
          : (createdAt as String),
      updatedAt: updatedAt == _undefined || updatedAt == null
          ? _instance.updatedAt
          : (updatedAt as String),
      track: track == _undefined
          ? _instance.track
          : (track as Query$trackPlaybackHistory$trackPlaybackHistory$track?),
      $__typename: $__typename == _undefined || $__typename == null
          ? _instance.$__typename
          : ($__typename as String),
    ),
  );

  CopyWith$Query$trackPlaybackHistory$trackPlaybackHistory$track<TRes>
  get track {
    final local$track = _instance.track;
    return local$track == null
        ? CopyWith$Query$trackPlaybackHistory$trackPlaybackHistory$track.stub(
            _then(_instance),
          )
        : CopyWith$Query$trackPlaybackHistory$trackPlaybackHistory$track(
            local$track,
            (e) => call(track: e),
          );
  }
}

class _CopyWithStubImpl$Query$trackPlaybackHistory$trackPlaybackHistory<TRes>
    implements CopyWith$Query$trackPlaybackHistory$trackPlaybackHistory<TRes> {
  _CopyWithStubImpl$Query$trackPlaybackHistory$trackPlaybackHistory(this._res);

  TRes _res;

  call({
    String? id,
    bool? watched,
    int? progressInMilliseconds,
    String? createdAt,
    String? updatedAt,
    Query$trackPlaybackHistory$trackPlaybackHistory$track? track,
    String? $__typename,
  }) => _res;

  CopyWith$Query$trackPlaybackHistory$trackPlaybackHistory$track<TRes>
  get track =>
      CopyWith$Query$trackPlaybackHistory$trackPlaybackHistory$track.stub(_res);
}

class Query$trackPlaybackHistory$trackPlaybackHistory$track {
  Query$trackPlaybackHistory$trackPlaybackHistory$track({
    required this.id,
    required this.number,
    this.metadata,
    required this.album,
    this.$__typename = 'Track',
  });

  factory Query$trackPlaybackHistory$trackPlaybackHistory$track.fromJson(
    Map<String, dynamic> json,
  ) {
    final l$id = json['id'];
    final l$number = json['number'];
    final l$metadata = json['metadata'];
    final l$album = json['album'];
    final l$$__typename = json['__typename'];
    return Query$trackPlaybackHistory$trackPlaybackHistory$track(
      id: (l$id as String),
      number: (l$number as int),
      metadata: (l$metadata as List<dynamic>?)
          ?.map(
            (e) =>
                Fragment$fragmentMetadata.fromJson((e as Map<String, dynamic>)),
          )
          .toList(),
      album:
          Query$trackPlaybackHistory$trackPlaybackHistory$track$album.fromJson(
            (l$album as Map<String, dynamic>),
          ),
      $__typename: (l$$__typename as String),
    );
  }

  final String id;

  final int number;

  final List<Fragment$fragmentMetadata>? metadata;

  final Query$trackPlaybackHistory$trackPlaybackHistory$track$album album;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$id = id;
    _resultData['id'] = l$id;
    final l$number = number;
    _resultData['number'] = l$number;
    final l$metadata = metadata;
    _resultData['metadata'] = l$metadata?.map((e) => e.toJson()).toList();
    final l$album = album;
    _resultData['album'] = l$album.toJson();
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$id = id;
    final l$number = number;
    final l$metadata = metadata;
    final l$album = album;
    final l$$__typename = $__typename;
    return Object.hashAll([
      l$id,
      l$number,
      l$metadata == null ? null : Object.hashAll(l$metadata.map((v) => v)),
      l$album,
      l$$__typename,
    ]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Query$trackPlaybackHistory$trackPlaybackHistory$track ||
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
    final l$album = album;
    final lOther$album = other.album;
    if (l$album != lOther$album) {
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

extension UtilityExtension$Query$trackPlaybackHistory$trackPlaybackHistory$track
    on Query$trackPlaybackHistory$trackPlaybackHistory$track {
  CopyWith$Query$trackPlaybackHistory$trackPlaybackHistory$track<
    Query$trackPlaybackHistory$trackPlaybackHistory$track
  >
  get copyWith =>
      CopyWith$Query$trackPlaybackHistory$trackPlaybackHistory$track(
        this,
        (i) => i,
      );
}

abstract class CopyWith$Query$trackPlaybackHistory$trackPlaybackHistory$track<
  TRes
> {
  factory CopyWith$Query$trackPlaybackHistory$trackPlaybackHistory$track(
    Query$trackPlaybackHistory$trackPlaybackHistory$track instance,
    TRes Function(Query$trackPlaybackHistory$trackPlaybackHistory$track) then,
  ) = _CopyWithImpl$Query$trackPlaybackHistory$trackPlaybackHistory$track;

  factory CopyWith$Query$trackPlaybackHistory$trackPlaybackHistory$track.stub(
    TRes res,
  ) = _CopyWithStubImpl$Query$trackPlaybackHistory$trackPlaybackHistory$track;

  TRes call({
    String? id,
    int? number,
    List<Fragment$fragmentMetadata>? metadata,
    Query$trackPlaybackHistory$trackPlaybackHistory$track$album? album,
    String? $__typename,
  });
  TRes metadata(
    Iterable<Fragment$fragmentMetadata>? Function(
      Iterable<CopyWith$Fragment$fragmentMetadata<Fragment$fragmentMetadata>>?,
    )
    _fn,
  );
  CopyWith$Query$trackPlaybackHistory$trackPlaybackHistory$track$album<TRes>
  get album;
}

class _CopyWithImpl$Query$trackPlaybackHistory$trackPlaybackHistory$track<TRes>
    implements
        CopyWith$Query$trackPlaybackHistory$trackPlaybackHistory$track<TRes> {
  _CopyWithImpl$Query$trackPlaybackHistory$trackPlaybackHistory$track(
    this._instance,
    this._then,
  );

  final Query$trackPlaybackHistory$trackPlaybackHistory$track _instance;

  final TRes Function(Query$trackPlaybackHistory$trackPlaybackHistory$track)
  _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? id = _undefined,
    Object? number = _undefined,
    Object? metadata = _undefined,
    Object? album = _undefined,
    Object? $__typename = _undefined,
  }) => _then(
    Query$trackPlaybackHistory$trackPlaybackHistory$track(
      id: id == _undefined || id == null ? _instance.id : (id as String),
      number: number == _undefined || number == null
          ? _instance.number
          : (number as int),
      metadata: metadata == _undefined
          ? _instance.metadata
          : (metadata as List<Fragment$fragmentMetadata>?),
      album: album == _undefined || album == null
          ? _instance.album
          : (album
                as Query$trackPlaybackHistory$trackPlaybackHistory$track$album),
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

  CopyWith$Query$trackPlaybackHistory$trackPlaybackHistory$track$album<TRes>
  get album {
    final local$album = _instance.album;
    return CopyWith$Query$trackPlaybackHistory$trackPlaybackHistory$track$album(
      local$album,
      (e) => call(album: e),
    );
  }
}

class _CopyWithStubImpl$Query$trackPlaybackHistory$trackPlaybackHistory$track<
  TRes
>
    implements
        CopyWith$Query$trackPlaybackHistory$trackPlaybackHistory$track<TRes> {
  _CopyWithStubImpl$Query$trackPlaybackHistory$trackPlaybackHistory$track(
    this._res,
  );

  TRes _res;

  call({
    String? id,
    int? number,
    List<Fragment$fragmentMetadata>? metadata,
    Query$trackPlaybackHistory$trackPlaybackHistory$track$album? album,
    String? $__typename,
  }) => _res;

  metadata(_fn) => _res;

  CopyWith$Query$trackPlaybackHistory$trackPlaybackHistory$track$album<TRes>
  get album =>
      CopyWith$Query$trackPlaybackHistory$trackPlaybackHistory$track$album.stub(
        _res,
      );
}

class Query$trackPlaybackHistory$trackPlaybackHistory$track$album {
  Query$trackPlaybackHistory$trackPlaybackHistory$track$album({
    required this.id,
    required this.name,
    this.metadata,
    this.$__typename = 'Album',
  });

  factory Query$trackPlaybackHistory$trackPlaybackHistory$track$album.fromJson(
    Map<String, dynamic> json,
  ) {
    final l$id = json['id'];
    final l$name = json['name'];
    final l$metadata = json['metadata'];
    final l$$__typename = json['__typename'];
    return Query$trackPlaybackHistory$trackPlaybackHistory$track$album(
      id: (l$id as String),
      name: (l$name as String),
      metadata: (l$metadata as List<dynamic>?)
          ?.map(
            (e) =>
                Fragment$fragmentMetadata.fromJson((e as Map<String, dynamic>)),
          )
          .toList(),
      $__typename: (l$$__typename as String),
    );
  }

  final String id;

  final String name;

  final List<Fragment$fragmentMetadata>? metadata;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$id = id;
    _resultData['id'] = l$id;
    final l$name = name;
    _resultData['name'] = l$name;
    final l$metadata = metadata;
    _resultData['metadata'] = l$metadata?.map((e) => e.toJson()).toList();
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$id = id;
    final l$name = name;
    final l$metadata = metadata;
    final l$$__typename = $__typename;
    return Object.hashAll([
      l$id,
      l$name,
      l$metadata == null ? null : Object.hashAll(l$metadata.map((v) => v)),
      l$$__typename,
    ]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Query$trackPlaybackHistory$trackPlaybackHistory$track$album ||
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
    final l$$__typename = $__typename;
    final lOther$$__typename = other.$__typename;
    if (l$$__typename != lOther$$__typename) {
      return false;
    }
    return true;
  }
}

extension UtilityExtension$Query$trackPlaybackHistory$trackPlaybackHistory$track$album
    on Query$trackPlaybackHistory$trackPlaybackHistory$track$album {
  CopyWith$Query$trackPlaybackHistory$trackPlaybackHistory$track$album<
    Query$trackPlaybackHistory$trackPlaybackHistory$track$album
  >
  get copyWith =>
      CopyWith$Query$trackPlaybackHistory$trackPlaybackHistory$track$album(
        this,
        (i) => i,
      );
}

abstract class CopyWith$Query$trackPlaybackHistory$trackPlaybackHistory$track$album<
  TRes
> {
  factory CopyWith$Query$trackPlaybackHistory$trackPlaybackHistory$track$album(
    Query$trackPlaybackHistory$trackPlaybackHistory$track$album instance,
    TRes Function(Query$trackPlaybackHistory$trackPlaybackHistory$track$album)
    then,
  ) = _CopyWithImpl$Query$trackPlaybackHistory$trackPlaybackHistory$track$album;

  factory CopyWith$Query$trackPlaybackHistory$trackPlaybackHistory$track$album.stub(
    TRes res,
  ) = _CopyWithStubImpl$Query$trackPlaybackHistory$trackPlaybackHistory$track$album;

  TRes call({
    String? id,
    String? name,
    List<Fragment$fragmentMetadata>? metadata,
    String? $__typename,
  });
  TRes metadata(
    Iterable<Fragment$fragmentMetadata>? Function(
      Iterable<CopyWith$Fragment$fragmentMetadata<Fragment$fragmentMetadata>>?,
    )
    _fn,
  );
}

class _CopyWithImpl$Query$trackPlaybackHistory$trackPlaybackHistory$track$album<
  TRes
>
    implements
        CopyWith$Query$trackPlaybackHistory$trackPlaybackHistory$track$album<
          TRes
        > {
  _CopyWithImpl$Query$trackPlaybackHistory$trackPlaybackHistory$track$album(
    this._instance,
    this._then,
  );

  final Query$trackPlaybackHistory$trackPlaybackHistory$track$album _instance;

  final TRes Function(
    Query$trackPlaybackHistory$trackPlaybackHistory$track$album,
  )
  _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? id = _undefined,
    Object? name = _undefined,
    Object? metadata = _undefined,
    Object? $__typename = _undefined,
  }) => _then(
    Query$trackPlaybackHistory$trackPlaybackHistory$track$album(
      id: id == _undefined || id == null ? _instance.id : (id as String),
      name: name == _undefined || name == null
          ? _instance.name
          : (name as String),
      metadata: metadata == _undefined
          ? _instance.metadata
          : (metadata as List<Fragment$fragmentMetadata>?),
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
}

class _CopyWithStubImpl$Query$trackPlaybackHistory$trackPlaybackHistory$track$album<
  TRes
>
    implements
        CopyWith$Query$trackPlaybackHistory$trackPlaybackHistory$track$album<
          TRes
        > {
  _CopyWithStubImpl$Query$trackPlaybackHistory$trackPlaybackHistory$track$album(
    this._res,
  );

  TRes _res;

  call({
    String? id,
    String? name,
    List<Fragment$fragmentMetadata>? metadata,
    String? $__typename,
  }) => _res;

  metadata(_fn) => _res;
}

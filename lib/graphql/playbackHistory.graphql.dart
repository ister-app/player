import 'package:gql/ast.dart';

import 'schema.graphql.dart';

class Variables$Query$playbackHistory {
  factory Variables$Query$playbackHistory({
    required Enum$MediaType mediaType,
    required String mediaId,
  }) => Variables$Query$playbackHistory._({
    r'mediaType': mediaType,
    r'mediaId': mediaId,
  });

  Variables$Query$playbackHistory._(this._$data);

  factory Variables$Query$playbackHistory.fromJson(Map<String, dynamic> data) {
    final result$data = <String, dynamic>{};
    final l$mediaType = data['mediaType'];
    result$data['mediaType'] = fromJson$Enum$MediaType((l$mediaType as String));
    final l$mediaId = data['mediaId'];
    result$data['mediaId'] = (l$mediaId as String);
    return Variables$Query$playbackHistory._(result$data);
  }

  Map<String, dynamic> _$data;

  Enum$MediaType get mediaType => (_$data['mediaType'] as Enum$MediaType);

  String get mediaId => (_$data['mediaId'] as String);

  Map<String, dynamic> toJson() {
    final result$data = <String, dynamic>{};
    final l$mediaType = mediaType;
    result$data['mediaType'] = toJson$Enum$MediaType(l$mediaType);
    final l$mediaId = mediaId;
    result$data['mediaId'] = l$mediaId;
    return result$data;
  }

  CopyWith$Variables$Query$playbackHistory<Variables$Query$playbackHistory>
  get copyWith => CopyWith$Variables$Query$playbackHistory(this, (i) => i);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Variables$Query$playbackHistory ||
        runtimeType != other.runtimeType) {
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
    return true;
  }

  @override
  int get hashCode {
    final l$mediaType = mediaType;
    final l$mediaId = mediaId;
    return Object.hashAll([l$mediaType, l$mediaId]);
  }
}

abstract class CopyWith$Variables$Query$playbackHistory<TRes> {
  factory CopyWith$Variables$Query$playbackHistory(
    Variables$Query$playbackHistory instance,
    TRes Function(Variables$Query$playbackHistory) then,
  ) = _CopyWithImpl$Variables$Query$playbackHistory;

  factory CopyWith$Variables$Query$playbackHistory.stub(TRes res) =
      _CopyWithStubImpl$Variables$Query$playbackHistory;

  TRes call({Enum$MediaType? mediaType, String? mediaId});
}

class _CopyWithImpl$Variables$Query$playbackHistory<TRes>
    implements CopyWith$Variables$Query$playbackHistory<TRes> {
  _CopyWithImpl$Variables$Query$playbackHistory(this._instance, this._then);

  final Variables$Query$playbackHistory _instance;

  final TRes Function(Variables$Query$playbackHistory) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({Object? mediaType = _undefined, Object? mediaId = _undefined}) =>
      _then(
        Variables$Query$playbackHistory._({
          ..._instance._$data,
          if (mediaType != _undefined && mediaType != null)
            'mediaType': (mediaType as Enum$MediaType),
          if (mediaId != _undefined && mediaId != null)
            'mediaId': (mediaId as String),
        }),
      );
}

class _CopyWithStubImpl$Variables$Query$playbackHistory<TRes>
    implements CopyWith$Variables$Query$playbackHistory<TRes> {
  _CopyWithStubImpl$Variables$Query$playbackHistory(this._res);

  TRes _res;

  call({Enum$MediaType? mediaType, String? mediaId}) => _res;
}

class Query$playbackHistory {
  Query$playbackHistory({
    required this.playbackHistory,
    this.$__typename = 'Query',
  });

  factory Query$playbackHistory.fromJson(Map<String, dynamic> json) {
    final l$playbackHistory = json['playbackHistory'];
    final l$$__typename = json['__typename'];
    return Query$playbackHistory(
      playbackHistory: (l$playbackHistory as List<dynamic>)
          .map(
            (e) => Query$playbackHistory$playbackHistory.fromJson(
              (e as Map<String, dynamic>),
            ),
          )
          .toList(),
      $__typename: (l$$__typename as String),
    );
  }

  final List<Query$playbackHistory$playbackHistory> playbackHistory;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$playbackHistory = playbackHistory;
    _resultData['playbackHistory'] = l$playbackHistory
        .map((e) => e.toJson())
        .toList();
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$playbackHistory = playbackHistory;
    final l$$__typename = $__typename;
    return Object.hashAll([
      Object.hashAll(l$playbackHistory.map((v) => v)),
      l$$__typename,
    ]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Query$playbackHistory || runtimeType != other.runtimeType) {
      return false;
    }
    final l$playbackHistory = playbackHistory;
    final lOther$playbackHistory = other.playbackHistory;
    if (l$playbackHistory.length != lOther$playbackHistory.length) {
      return false;
    }
    for (int i = 0; i < l$playbackHistory.length; i++) {
      final l$playbackHistory$entry = l$playbackHistory[i];
      final lOther$playbackHistory$entry = lOther$playbackHistory[i];
      if (l$playbackHistory$entry != lOther$playbackHistory$entry) {
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

extension UtilityExtension$Query$playbackHistory on Query$playbackHistory {
  CopyWith$Query$playbackHistory<Query$playbackHistory> get copyWith =>
      CopyWith$Query$playbackHistory(this, (i) => i);
}

abstract class CopyWith$Query$playbackHistory<TRes> {
  factory CopyWith$Query$playbackHistory(
    Query$playbackHistory instance,
    TRes Function(Query$playbackHistory) then,
  ) = _CopyWithImpl$Query$playbackHistory;

  factory CopyWith$Query$playbackHistory.stub(TRes res) =
      _CopyWithStubImpl$Query$playbackHistory;

  TRes call({
    List<Query$playbackHistory$playbackHistory>? playbackHistory,
    String? $__typename,
  });
  TRes playbackHistory(
    Iterable<Query$playbackHistory$playbackHistory> Function(
      Iterable<
        CopyWith$Query$playbackHistory$playbackHistory<
          Query$playbackHistory$playbackHistory
        >
      >,
    )
    _fn,
  );
}

class _CopyWithImpl$Query$playbackHistory<TRes>
    implements CopyWith$Query$playbackHistory<TRes> {
  _CopyWithImpl$Query$playbackHistory(this._instance, this._then);

  final Query$playbackHistory _instance;

  final TRes Function(Query$playbackHistory) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? playbackHistory = _undefined,
    Object? $__typename = _undefined,
  }) => _then(
    Query$playbackHistory(
      playbackHistory: playbackHistory == _undefined || playbackHistory == null
          ? _instance.playbackHistory
          : (playbackHistory as List<Query$playbackHistory$playbackHistory>),
      $__typename: $__typename == _undefined || $__typename == null
          ? _instance.$__typename
          : ($__typename as String),
    ),
  );

  TRes playbackHistory(
    Iterable<Query$playbackHistory$playbackHistory> Function(
      Iterable<
        CopyWith$Query$playbackHistory$playbackHistory<
          Query$playbackHistory$playbackHistory
        >
      >,
    )
    _fn,
  ) => call(
    playbackHistory: _fn(
      _instance.playbackHistory.map(
        (e) => CopyWith$Query$playbackHistory$playbackHistory(e, (i) => i),
      ),
    ).toList(),
  );
}

class _CopyWithStubImpl$Query$playbackHistory<TRes>
    implements CopyWith$Query$playbackHistory<TRes> {
  _CopyWithStubImpl$Query$playbackHistory(this._res);

  TRes _res;

  call({
    List<Query$playbackHistory$playbackHistory>? playbackHistory,
    String? $__typename,
  }) => _res;

  playbackHistory(_fn) => _res;
}

const documentNodeQueryplaybackHistory = DocumentNode(
  definitions: [
    OperationDefinitionNode(
      type: OperationType.query,
      name: NameNode(value: 'playbackHistory'),
      variableDefinitions: [
        VariableDefinitionNode(
          variable: VariableNode(name: NameNode(value: 'mediaType')),
          type: NamedTypeNode(
            name: NameNode(value: 'MediaType'),
            isNonNull: true,
          ),
          defaultValue: DefaultValueNode(value: null),
          directives: [],
        ),
        VariableDefinitionNode(
          variable: VariableNode(name: NameNode(value: 'mediaId')),
          type: NamedTypeNode(name: NameNode(value: 'ID'), isNonNull: true),
          defaultValue: DefaultValueNode(value: null),
          directives: [],
        ),
      ],
      directives: [],
      selectionSet: SelectionSetNode(
        selections: [
          FieldNode(
            name: NameNode(value: 'playbackHistory'),
            alias: null,
            arguments: [
              ArgumentNode(
                name: NameNode(value: 'mediaType'),
                value: VariableNode(name: NameNode(value: 'mediaType')),
              ),
              ArgumentNode(
                name: NameNode(value: 'mediaId'),
                value: VariableNode(name: NameNode(value: 'mediaId')),
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
                  name: NameNode(value: 'chapter'),
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
  ],
);

class Query$playbackHistory$playbackHistory {
  Query$playbackHistory$playbackHistory({
    required this.id,
    required this.watched,
    required this.progressInMilliseconds,
    required this.createdAt,
    required this.updatedAt,
    this.chapter,
    this.$__typename = 'WatchStatus',
  });

  factory Query$playbackHistory$playbackHistory.fromJson(
    Map<String, dynamic> json,
  ) {
    final l$id = json['id'];
    final l$watched = json['watched'];
    final l$progressInMilliseconds = json['progressInMilliseconds'];
    final l$createdAt = json['createdAt'];
    final l$updatedAt = json['updatedAt'];
    final l$chapter = json['chapter'];
    final l$$__typename = json['__typename'];
    return Query$playbackHistory$playbackHistory(
      id: (l$id as String),
      watched: (l$watched as bool),
      progressInMilliseconds: (l$progressInMilliseconds as int),
      createdAt: (l$createdAt as String),
      updatedAt: (l$updatedAt as String),
      chapter: l$chapter == null
          ? null
          : Query$playbackHistory$playbackHistory$chapter.fromJson(
              (l$chapter as Map<String, dynamic>),
            ),
      $__typename: (l$$__typename as String),
    );
  }

  final String id;

  final bool watched;

  final int progressInMilliseconds;

  final String createdAt;

  final String updatedAt;

  final Query$playbackHistory$playbackHistory$chapter? chapter;

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
    final l$chapter = chapter;
    _resultData['chapter'] = l$chapter?.toJson();
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
    final l$chapter = chapter;
    final l$$__typename = $__typename;
    return Object.hashAll([
      l$id,
      l$watched,
      l$progressInMilliseconds,
      l$createdAt,
      l$updatedAt,
      l$chapter,
      l$$__typename,
    ]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Query$playbackHistory$playbackHistory ||
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
    final l$chapter = chapter;
    final lOther$chapter = other.chapter;
    if (l$chapter != lOther$chapter) {
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

extension UtilityExtension$Query$playbackHistory$playbackHistory
    on Query$playbackHistory$playbackHistory {
  CopyWith$Query$playbackHistory$playbackHistory<
    Query$playbackHistory$playbackHistory
  >
  get copyWith =>
      CopyWith$Query$playbackHistory$playbackHistory(this, (i) => i);
}

abstract class CopyWith$Query$playbackHistory$playbackHistory<TRes> {
  factory CopyWith$Query$playbackHistory$playbackHistory(
    Query$playbackHistory$playbackHistory instance,
    TRes Function(Query$playbackHistory$playbackHistory) then,
  ) = _CopyWithImpl$Query$playbackHistory$playbackHistory;

  factory CopyWith$Query$playbackHistory$playbackHistory.stub(TRes res) =
      _CopyWithStubImpl$Query$playbackHistory$playbackHistory;

  TRes call({
    String? id,
    bool? watched,
    int? progressInMilliseconds,
    String? createdAt,
    String? updatedAt,
    Query$playbackHistory$playbackHistory$chapter? chapter,
    String? $__typename,
  });
  CopyWith$Query$playbackHistory$playbackHistory$chapter<TRes> get chapter;
}

class _CopyWithImpl$Query$playbackHistory$playbackHistory<TRes>
    implements CopyWith$Query$playbackHistory$playbackHistory<TRes> {
  _CopyWithImpl$Query$playbackHistory$playbackHistory(
    this._instance,
    this._then,
  );

  final Query$playbackHistory$playbackHistory _instance;

  final TRes Function(Query$playbackHistory$playbackHistory) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? id = _undefined,
    Object? watched = _undefined,
    Object? progressInMilliseconds = _undefined,
    Object? createdAt = _undefined,
    Object? updatedAt = _undefined,
    Object? chapter = _undefined,
    Object? $__typename = _undefined,
  }) => _then(
    Query$playbackHistory$playbackHistory(
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
      chapter: chapter == _undefined
          ? _instance.chapter
          : (chapter as Query$playbackHistory$playbackHistory$chapter?),
      $__typename: $__typename == _undefined || $__typename == null
          ? _instance.$__typename
          : ($__typename as String),
    ),
  );

  CopyWith$Query$playbackHistory$playbackHistory$chapter<TRes> get chapter {
    final local$chapter = _instance.chapter;
    return local$chapter == null
        ? CopyWith$Query$playbackHistory$playbackHistory$chapter.stub(
            _then(_instance),
          )
        : CopyWith$Query$playbackHistory$playbackHistory$chapter(
            local$chapter,
            (e) => call(chapter: e),
          );
  }
}

class _CopyWithStubImpl$Query$playbackHistory$playbackHistory<TRes>
    implements CopyWith$Query$playbackHistory$playbackHistory<TRes> {
  _CopyWithStubImpl$Query$playbackHistory$playbackHistory(this._res);

  TRes _res;

  call({
    String? id,
    bool? watched,
    int? progressInMilliseconds,
    String? createdAt,
    String? updatedAt,
    Query$playbackHistory$playbackHistory$chapter? chapter,
    String? $__typename,
  }) => _res;

  CopyWith$Query$playbackHistory$playbackHistory$chapter<TRes> get chapter =>
      CopyWith$Query$playbackHistory$playbackHistory$chapter.stub(_res);
}

class Query$playbackHistory$playbackHistory$chapter {
  Query$playbackHistory$playbackHistory$chapter({
    required this.id,
    required this.number,
    this.$__typename = 'Chapter',
  });

  factory Query$playbackHistory$playbackHistory$chapter.fromJson(
    Map<String, dynamic> json,
  ) {
    final l$id = json['id'];
    final l$number = json['number'];
    final l$$__typename = json['__typename'];
    return Query$playbackHistory$playbackHistory$chapter(
      id: (l$id as String),
      number: (l$number as int),
      $__typename: (l$$__typename as String),
    );
  }

  final String id;

  final int number;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$id = id;
    _resultData['id'] = l$id;
    final l$number = number;
    _resultData['number'] = l$number;
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$id = id;
    final l$number = number;
    final l$$__typename = $__typename;
    return Object.hashAll([l$id, l$number, l$$__typename]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Query$playbackHistory$playbackHistory$chapter ||
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
    final l$$__typename = $__typename;
    final lOther$$__typename = other.$__typename;
    if (l$$__typename != lOther$$__typename) {
      return false;
    }
    return true;
  }
}

extension UtilityExtension$Query$playbackHistory$playbackHistory$chapter
    on Query$playbackHistory$playbackHistory$chapter {
  CopyWith$Query$playbackHistory$playbackHistory$chapter<
    Query$playbackHistory$playbackHistory$chapter
  >
  get copyWith =>
      CopyWith$Query$playbackHistory$playbackHistory$chapter(this, (i) => i);
}

abstract class CopyWith$Query$playbackHistory$playbackHistory$chapter<TRes> {
  factory CopyWith$Query$playbackHistory$playbackHistory$chapter(
    Query$playbackHistory$playbackHistory$chapter instance,
    TRes Function(Query$playbackHistory$playbackHistory$chapter) then,
  ) = _CopyWithImpl$Query$playbackHistory$playbackHistory$chapter;

  factory CopyWith$Query$playbackHistory$playbackHistory$chapter.stub(
    TRes res,
  ) = _CopyWithStubImpl$Query$playbackHistory$playbackHistory$chapter;

  TRes call({String? id, int? number, String? $__typename});
}

class _CopyWithImpl$Query$playbackHistory$playbackHistory$chapter<TRes>
    implements CopyWith$Query$playbackHistory$playbackHistory$chapter<TRes> {
  _CopyWithImpl$Query$playbackHistory$playbackHistory$chapter(
    this._instance,
    this._then,
  );

  final Query$playbackHistory$playbackHistory$chapter _instance;

  final TRes Function(Query$playbackHistory$playbackHistory$chapter) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? id = _undefined,
    Object? number = _undefined,
    Object? $__typename = _undefined,
  }) => _then(
    Query$playbackHistory$playbackHistory$chapter(
      id: id == _undefined || id == null ? _instance.id : (id as String),
      number: number == _undefined || number == null
          ? _instance.number
          : (number as int),
      $__typename: $__typename == _undefined || $__typename == null
          ? _instance.$__typename
          : ($__typename as String),
    ),
  );
}

class _CopyWithStubImpl$Query$playbackHistory$playbackHistory$chapter<TRes>
    implements CopyWith$Query$playbackHistory$playbackHistory$chapter<TRes> {
  _CopyWithStubImpl$Query$playbackHistory$playbackHistory$chapter(this._res);

  TRes _res;

  call({String? id, int? number, String? $__typename}) => _res;
}

class Variables$Mutation$markPlayed {
  factory Variables$Mutation$markPlayed({
    required Enum$MediaType mediaType,
    required String mediaId,
  }) => Variables$Mutation$markPlayed._({
    r'mediaType': mediaType,
    r'mediaId': mediaId,
  });

  Variables$Mutation$markPlayed._(this._$data);

  factory Variables$Mutation$markPlayed.fromJson(Map<String, dynamic> data) {
    final result$data = <String, dynamic>{};
    final l$mediaType = data['mediaType'];
    result$data['mediaType'] = fromJson$Enum$MediaType((l$mediaType as String));
    final l$mediaId = data['mediaId'];
    result$data['mediaId'] = (l$mediaId as String);
    return Variables$Mutation$markPlayed._(result$data);
  }

  Map<String, dynamic> _$data;

  Enum$MediaType get mediaType => (_$data['mediaType'] as Enum$MediaType);

  String get mediaId => (_$data['mediaId'] as String);

  Map<String, dynamic> toJson() {
    final result$data = <String, dynamic>{};
    final l$mediaType = mediaType;
    result$data['mediaType'] = toJson$Enum$MediaType(l$mediaType);
    final l$mediaId = mediaId;
    result$data['mediaId'] = l$mediaId;
    return result$data;
  }

  CopyWith$Variables$Mutation$markPlayed<Variables$Mutation$markPlayed>
  get copyWith => CopyWith$Variables$Mutation$markPlayed(this, (i) => i);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Variables$Mutation$markPlayed ||
        runtimeType != other.runtimeType) {
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
    return true;
  }

  @override
  int get hashCode {
    final l$mediaType = mediaType;
    final l$mediaId = mediaId;
    return Object.hashAll([l$mediaType, l$mediaId]);
  }
}

abstract class CopyWith$Variables$Mutation$markPlayed<TRes> {
  factory CopyWith$Variables$Mutation$markPlayed(
    Variables$Mutation$markPlayed instance,
    TRes Function(Variables$Mutation$markPlayed) then,
  ) = _CopyWithImpl$Variables$Mutation$markPlayed;

  factory CopyWith$Variables$Mutation$markPlayed.stub(TRes res) =
      _CopyWithStubImpl$Variables$Mutation$markPlayed;

  TRes call({Enum$MediaType? mediaType, String? mediaId});
}

class _CopyWithImpl$Variables$Mutation$markPlayed<TRes>
    implements CopyWith$Variables$Mutation$markPlayed<TRes> {
  _CopyWithImpl$Variables$Mutation$markPlayed(this._instance, this._then);

  final Variables$Mutation$markPlayed _instance;

  final TRes Function(Variables$Mutation$markPlayed) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({Object? mediaType = _undefined, Object? mediaId = _undefined}) =>
      _then(
        Variables$Mutation$markPlayed._({
          ..._instance._$data,
          if (mediaType != _undefined && mediaType != null)
            'mediaType': (mediaType as Enum$MediaType),
          if (mediaId != _undefined && mediaId != null)
            'mediaId': (mediaId as String),
        }),
      );
}

class _CopyWithStubImpl$Variables$Mutation$markPlayed<TRes>
    implements CopyWith$Variables$Mutation$markPlayed<TRes> {
  _CopyWithStubImpl$Variables$Mutation$markPlayed(this._res);

  TRes _res;

  call({Enum$MediaType? mediaType, String? mediaId}) => _res;
}

class Mutation$markPlayed {
  Mutation$markPlayed({
    required this.markPlayed,
    this.$__typename = 'Mutation',
  });

  factory Mutation$markPlayed.fromJson(Map<String, dynamic> json) {
    final l$markPlayed = json['markPlayed'];
    final l$$__typename = json['__typename'];
    return Mutation$markPlayed(
      markPlayed: Mutation$markPlayed$markPlayed.fromJson(
        (l$markPlayed as Map<String, dynamic>),
      ),
      $__typename: (l$$__typename as String),
    );
  }

  final Mutation$markPlayed$markPlayed markPlayed;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$markPlayed = markPlayed;
    _resultData['markPlayed'] = l$markPlayed.toJson();
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$markPlayed = markPlayed;
    final l$$__typename = $__typename;
    return Object.hashAll([l$markPlayed, l$$__typename]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Mutation$markPlayed || runtimeType != other.runtimeType) {
      return false;
    }
    final l$markPlayed = markPlayed;
    final lOther$markPlayed = other.markPlayed;
    if (l$markPlayed != lOther$markPlayed) {
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

extension UtilityExtension$Mutation$markPlayed on Mutation$markPlayed {
  CopyWith$Mutation$markPlayed<Mutation$markPlayed> get copyWith =>
      CopyWith$Mutation$markPlayed(this, (i) => i);
}

abstract class CopyWith$Mutation$markPlayed<TRes> {
  factory CopyWith$Mutation$markPlayed(
    Mutation$markPlayed instance,
    TRes Function(Mutation$markPlayed) then,
  ) = _CopyWithImpl$Mutation$markPlayed;

  factory CopyWith$Mutation$markPlayed.stub(TRes res) =
      _CopyWithStubImpl$Mutation$markPlayed;

  TRes call({Mutation$markPlayed$markPlayed? markPlayed, String? $__typename});
  CopyWith$Mutation$markPlayed$markPlayed<TRes> get markPlayed;
}

class _CopyWithImpl$Mutation$markPlayed<TRes>
    implements CopyWith$Mutation$markPlayed<TRes> {
  _CopyWithImpl$Mutation$markPlayed(this._instance, this._then);

  final Mutation$markPlayed _instance;

  final TRes Function(Mutation$markPlayed) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? markPlayed = _undefined,
    Object? $__typename = _undefined,
  }) => _then(
    Mutation$markPlayed(
      markPlayed: markPlayed == _undefined || markPlayed == null
          ? _instance.markPlayed
          : (markPlayed as Mutation$markPlayed$markPlayed),
      $__typename: $__typename == _undefined || $__typename == null
          ? _instance.$__typename
          : ($__typename as String),
    ),
  );

  CopyWith$Mutation$markPlayed$markPlayed<TRes> get markPlayed {
    final local$markPlayed = _instance.markPlayed;
    return CopyWith$Mutation$markPlayed$markPlayed(
      local$markPlayed,
      (e) => call(markPlayed: e),
    );
  }
}

class _CopyWithStubImpl$Mutation$markPlayed<TRes>
    implements CopyWith$Mutation$markPlayed<TRes> {
  _CopyWithStubImpl$Mutation$markPlayed(this._res);

  TRes _res;

  call({Mutation$markPlayed$markPlayed? markPlayed, String? $__typename}) =>
      _res;

  CopyWith$Mutation$markPlayed$markPlayed<TRes> get markPlayed =>
      CopyWith$Mutation$markPlayed$markPlayed.stub(_res);
}

const documentNodeMutationmarkPlayed = DocumentNode(
  definitions: [
    OperationDefinitionNode(
      type: OperationType.mutation,
      name: NameNode(value: 'markPlayed'),
      variableDefinitions: [
        VariableDefinitionNode(
          variable: VariableNode(name: NameNode(value: 'mediaType')),
          type: NamedTypeNode(
            name: NameNode(value: 'MediaType'),
            isNonNull: true,
          ),
          defaultValue: DefaultValueNode(value: null),
          directives: [],
        ),
        VariableDefinitionNode(
          variable: VariableNode(name: NameNode(value: 'mediaId')),
          type: NamedTypeNode(name: NameNode(value: 'ID'), isNonNull: true),
          defaultValue: DefaultValueNode(value: null),
          directives: [],
        ),
      ],
      directives: [],
      selectionSet: SelectionSetNode(
        selections: [
          FieldNode(
            name: NameNode(value: 'markPlayed'),
            alias: null,
            arguments: [
              ArgumentNode(
                name: NameNode(value: 'mediaType'),
                value: VariableNode(name: NameNode(value: 'mediaType')),
              ),
              ArgumentNode(
                name: NameNode(value: 'mediaId'),
                value: VariableNode(name: NameNode(value: 'mediaId')),
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
  ],
);

class Mutation$markPlayed$markPlayed {
  Mutation$markPlayed$markPlayed({
    required this.id,
    this.$__typename = 'WatchStatus',
  });

  factory Mutation$markPlayed$markPlayed.fromJson(Map<String, dynamic> json) {
    final l$id = json['id'];
    final l$$__typename = json['__typename'];
    return Mutation$markPlayed$markPlayed(
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
    if (other is! Mutation$markPlayed$markPlayed ||
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

extension UtilityExtension$Mutation$markPlayed$markPlayed
    on Mutation$markPlayed$markPlayed {
  CopyWith$Mutation$markPlayed$markPlayed<Mutation$markPlayed$markPlayed>
  get copyWith => CopyWith$Mutation$markPlayed$markPlayed(this, (i) => i);
}

abstract class CopyWith$Mutation$markPlayed$markPlayed<TRes> {
  factory CopyWith$Mutation$markPlayed$markPlayed(
    Mutation$markPlayed$markPlayed instance,
    TRes Function(Mutation$markPlayed$markPlayed) then,
  ) = _CopyWithImpl$Mutation$markPlayed$markPlayed;

  factory CopyWith$Mutation$markPlayed$markPlayed.stub(TRes res) =
      _CopyWithStubImpl$Mutation$markPlayed$markPlayed;

  TRes call({String? id, String? $__typename});
}

class _CopyWithImpl$Mutation$markPlayed$markPlayed<TRes>
    implements CopyWith$Mutation$markPlayed$markPlayed<TRes> {
  _CopyWithImpl$Mutation$markPlayed$markPlayed(this._instance, this._then);

  final Mutation$markPlayed$markPlayed _instance;

  final TRes Function(Mutation$markPlayed$markPlayed) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({Object? id = _undefined, Object? $__typename = _undefined}) =>
      _then(
        Mutation$markPlayed$markPlayed(
          id: id == _undefined || id == null ? _instance.id : (id as String),
          $__typename: $__typename == _undefined || $__typename == null
              ? _instance.$__typename
              : ($__typename as String),
        ),
      );
}

class _CopyWithStubImpl$Mutation$markPlayed$markPlayed<TRes>
    implements CopyWith$Mutation$markPlayed$markPlayed<TRes> {
  _CopyWithStubImpl$Mutation$markPlayed$markPlayed(this._res);

  TRes _res;

  call({String? id, String? $__typename}) => _res;
}

class Variables$Mutation$deleteWatchStatus {
  factory Variables$Mutation$deleteWatchStatus({required String id}) =>
      Variables$Mutation$deleteWatchStatus._({r'id': id});

  Variables$Mutation$deleteWatchStatus._(this._$data);

  factory Variables$Mutation$deleteWatchStatus.fromJson(
    Map<String, dynamic> data,
  ) {
    final result$data = <String, dynamic>{};
    final l$id = data['id'];
    result$data['id'] = (l$id as String);
    return Variables$Mutation$deleteWatchStatus._(result$data);
  }

  Map<String, dynamic> _$data;

  String get id => (_$data['id'] as String);

  Map<String, dynamic> toJson() {
    final result$data = <String, dynamic>{};
    final l$id = id;
    result$data['id'] = l$id;
    return result$data;
  }

  CopyWith$Variables$Mutation$deleteWatchStatus<
    Variables$Mutation$deleteWatchStatus
  >
  get copyWith => CopyWith$Variables$Mutation$deleteWatchStatus(this, (i) => i);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Variables$Mutation$deleteWatchStatus ||
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

abstract class CopyWith$Variables$Mutation$deleteWatchStatus<TRes> {
  factory CopyWith$Variables$Mutation$deleteWatchStatus(
    Variables$Mutation$deleteWatchStatus instance,
    TRes Function(Variables$Mutation$deleteWatchStatus) then,
  ) = _CopyWithImpl$Variables$Mutation$deleteWatchStatus;

  factory CopyWith$Variables$Mutation$deleteWatchStatus.stub(TRes res) =
      _CopyWithStubImpl$Variables$Mutation$deleteWatchStatus;

  TRes call({String? id});
}

class _CopyWithImpl$Variables$Mutation$deleteWatchStatus<TRes>
    implements CopyWith$Variables$Mutation$deleteWatchStatus<TRes> {
  _CopyWithImpl$Variables$Mutation$deleteWatchStatus(
    this._instance,
    this._then,
  );

  final Variables$Mutation$deleteWatchStatus _instance;

  final TRes Function(Variables$Mutation$deleteWatchStatus) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({Object? id = _undefined}) => _then(
    Variables$Mutation$deleteWatchStatus._({
      ..._instance._$data,
      if (id != _undefined && id != null) 'id': (id as String),
    }),
  );
}

class _CopyWithStubImpl$Variables$Mutation$deleteWatchStatus<TRes>
    implements CopyWith$Variables$Mutation$deleteWatchStatus<TRes> {
  _CopyWithStubImpl$Variables$Mutation$deleteWatchStatus(this._res);

  TRes _res;

  call({String? id}) => _res;
}

class Mutation$deleteWatchStatus {
  Mutation$deleteWatchStatus({
    required this.deleteWatchStatus,
    this.$__typename = 'Mutation',
  });

  factory Mutation$deleteWatchStatus.fromJson(Map<String, dynamic> json) {
    final l$deleteWatchStatus = json['deleteWatchStatus'];
    final l$$__typename = json['__typename'];
    return Mutation$deleteWatchStatus(
      deleteWatchStatus: (l$deleteWatchStatus as bool),
      $__typename: (l$$__typename as String),
    );
  }

  final bool deleteWatchStatus;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$deleteWatchStatus = deleteWatchStatus;
    _resultData['deleteWatchStatus'] = l$deleteWatchStatus;
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$deleteWatchStatus = deleteWatchStatus;
    final l$$__typename = $__typename;
    return Object.hashAll([l$deleteWatchStatus, l$$__typename]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Mutation$deleteWatchStatus ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$deleteWatchStatus = deleteWatchStatus;
    final lOther$deleteWatchStatus = other.deleteWatchStatus;
    if (l$deleteWatchStatus != lOther$deleteWatchStatus) {
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

extension UtilityExtension$Mutation$deleteWatchStatus
    on Mutation$deleteWatchStatus {
  CopyWith$Mutation$deleteWatchStatus<Mutation$deleteWatchStatus>
  get copyWith => CopyWith$Mutation$deleteWatchStatus(this, (i) => i);
}

abstract class CopyWith$Mutation$deleteWatchStatus<TRes> {
  factory CopyWith$Mutation$deleteWatchStatus(
    Mutation$deleteWatchStatus instance,
    TRes Function(Mutation$deleteWatchStatus) then,
  ) = _CopyWithImpl$Mutation$deleteWatchStatus;

  factory CopyWith$Mutation$deleteWatchStatus.stub(TRes res) =
      _CopyWithStubImpl$Mutation$deleteWatchStatus;

  TRes call({bool? deleteWatchStatus, String? $__typename});
}

class _CopyWithImpl$Mutation$deleteWatchStatus<TRes>
    implements CopyWith$Mutation$deleteWatchStatus<TRes> {
  _CopyWithImpl$Mutation$deleteWatchStatus(this._instance, this._then);

  final Mutation$deleteWatchStatus _instance;

  final TRes Function(Mutation$deleteWatchStatus) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? deleteWatchStatus = _undefined,
    Object? $__typename = _undefined,
  }) => _then(
    Mutation$deleteWatchStatus(
      deleteWatchStatus:
          deleteWatchStatus == _undefined || deleteWatchStatus == null
          ? _instance.deleteWatchStatus
          : (deleteWatchStatus as bool),
      $__typename: $__typename == _undefined || $__typename == null
          ? _instance.$__typename
          : ($__typename as String),
    ),
  );
}

class _CopyWithStubImpl$Mutation$deleteWatchStatus<TRes>
    implements CopyWith$Mutation$deleteWatchStatus<TRes> {
  _CopyWithStubImpl$Mutation$deleteWatchStatus(this._res);

  TRes _res;

  call({bool? deleteWatchStatus, String? $__typename}) => _res;
}

const documentNodeMutationdeleteWatchStatus = DocumentNode(
  definitions: [
    OperationDefinitionNode(
      type: OperationType.mutation,
      name: NameNode(value: 'deleteWatchStatus'),
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
            name: NameNode(value: 'deleteWatchStatus'),
            alias: null,
            arguments: [
              ArgumentNode(
                name: NameNode(value: 'id'),
                value: VariableNode(name: NameNode(value: 'id')),
              ),
            ],
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
  ],
);

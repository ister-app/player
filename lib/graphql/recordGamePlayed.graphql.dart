import 'package:gql/ast.dart';

class Variables$Mutation$recordGamePlayed {
  factory Variables$Mutation$recordGamePlayed({
    required String gameId,
    required int durationMs,
  }) => Variables$Mutation$recordGamePlayed._({
    r'gameId': gameId,
    r'durationMs': durationMs,
  });

  Variables$Mutation$recordGamePlayed._(this._$data);

  factory Variables$Mutation$recordGamePlayed.fromJson(
    Map<String, dynamic> data,
  ) {
    final result$data = <String, dynamic>{};
    final l$gameId = data['gameId'];
    result$data['gameId'] = (l$gameId as String);
    final l$durationMs = data['durationMs'];
    result$data['durationMs'] = (l$durationMs as int);
    return Variables$Mutation$recordGamePlayed._(result$data);
  }

  Map<String, dynamic> _$data;

  String get gameId => (_$data['gameId'] as String);

  int get durationMs => (_$data['durationMs'] as int);

  Map<String, dynamic> toJson() {
    final result$data = <String, dynamic>{};
    final l$gameId = gameId;
    result$data['gameId'] = l$gameId;
    final l$durationMs = durationMs;
    result$data['durationMs'] = l$durationMs;
    return result$data;
  }

  CopyWith$Variables$Mutation$recordGamePlayed<
    Variables$Mutation$recordGamePlayed
  >
  get copyWith => CopyWith$Variables$Mutation$recordGamePlayed(this, (i) => i);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Variables$Mutation$recordGamePlayed ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$gameId = gameId;
    final lOther$gameId = other.gameId;
    if (l$gameId != lOther$gameId) {
      return false;
    }
    final l$durationMs = durationMs;
    final lOther$durationMs = other.durationMs;
    if (l$durationMs != lOther$durationMs) {
      return false;
    }
    return true;
  }

  @override
  int get hashCode {
    final l$gameId = gameId;
    final l$durationMs = durationMs;
    return Object.hashAll([l$gameId, l$durationMs]);
  }
}

abstract class CopyWith$Variables$Mutation$recordGamePlayed<TRes> {
  factory CopyWith$Variables$Mutation$recordGamePlayed(
    Variables$Mutation$recordGamePlayed instance,
    TRes Function(Variables$Mutation$recordGamePlayed) then,
  ) = _CopyWithImpl$Variables$Mutation$recordGamePlayed;

  factory CopyWith$Variables$Mutation$recordGamePlayed.stub(TRes res) =
      _CopyWithStubImpl$Variables$Mutation$recordGamePlayed;

  TRes call({String? gameId, int? durationMs});
}

class _CopyWithImpl$Variables$Mutation$recordGamePlayed<TRes>
    implements CopyWith$Variables$Mutation$recordGamePlayed<TRes> {
  _CopyWithImpl$Variables$Mutation$recordGamePlayed(this._instance, this._then);

  final Variables$Mutation$recordGamePlayed _instance;

  final TRes Function(Variables$Mutation$recordGamePlayed) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({Object? gameId = _undefined, Object? durationMs = _undefined}) =>
      _then(
        Variables$Mutation$recordGamePlayed._({
          ..._instance._$data,
          if (gameId != _undefined && gameId != null)
            'gameId': (gameId as String),
          if (durationMs != _undefined && durationMs != null)
            'durationMs': (durationMs as int),
        }),
      );
}

class _CopyWithStubImpl$Variables$Mutation$recordGamePlayed<TRes>
    implements CopyWith$Variables$Mutation$recordGamePlayed<TRes> {
  _CopyWithStubImpl$Variables$Mutation$recordGamePlayed(this._res);

  TRes _res;

  call({String? gameId, int? durationMs}) => _res;
}

class Mutation$recordGamePlayed {
  Mutation$recordGamePlayed({
    required this.recordGamePlayed,
    this.$__typename = 'Mutation',
  });

  factory Mutation$recordGamePlayed.fromJson(Map<String, dynamic> json) {
    final l$recordGamePlayed = json['recordGamePlayed'];
    final l$$__typename = json['__typename'];
    return Mutation$recordGamePlayed(
      recordGamePlayed: Mutation$recordGamePlayed$recordGamePlayed.fromJson(
        (l$recordGamePlayed as Map<String, dynamic>),
      ),
      $__typename: (l$$__typename as String),
    );
  }

  final Mutation$recordGamePlayed$recordGamePlayed recordGamePlayed;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$recordGamePlayed = recordGamePlayed;
    _resultData['recordGamePlayed'] = l$recordGamePlayed.toJson();
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$recordGamePlayed = recordGamePlayed;
    final l$$__typename = $__typename;
    return Object.hashAll([l$recordGamePlayed, l$$__typename]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Mutation$recordGamePlayed ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$recordGamePlayed = recordGamePlayed;
    final lOther$recordGamePlayed = other.recordGamePlayed;
    if (l$recordGamePlayed != lOther$recordGamePlayed) {
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

extension UtilityExtension$Mutation$recordGamePlayed
    on Mutation$recordGamePlayed {
  CopyWith$Mutation$recordGamePlayed<Mutation$recordGamePlayed> get copyWith =>
      CopyWith$Mutation$recordGamePlayed(this, (i) => i);
}

abstract class CopyWith$Mutation$recordGamePlayed<TRes> {
  factory CopyWith$Mutation$recordGamePlayed(
    Mutation$recordGamePlayed instance,
    TRes Function(Mutation$recordGamePlayed) then,
  ) = _CopyWithImpl$Mutation$recordGamePlayed;

  factory CopyWith$Mutation$recordGamePlayed.stub(TRes res) =
      _CopyWithStubImpl$Mutation$recordGamePlayed;

  TRes call({
    Mutation$recordGamePlayed$recordGamePlayed? recordGamePlayed,
    String? $__typename,
  });
  CopyWith$Mutation$recordGamePlayed$recordGamePlayed<TRes>
  get recordGamePlayed;
}

class _CopyWithImpl$Mutation$recordGamePlayed<TRes>
    implements CopyWith$Mutation$recordGamePlayed<TRes> {
  _CopyWithImpl$Mutation$recordGamePlayed(this._instance, this._then);

  final Mutation$recordGamePlayed _instance;

  final TRes Function(Mutation$recordGamePlayed) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? recordGamePlayed = _undefined,
    Object? $__typename = _undefined,
  }) => _then(
    Mutation$recordGamePlayed(
      recordGamePlayed:
          recordGamePlayed == _undefined || recordGamePlayed == null
          ? _instance.recordGamePlayed
          : (recordGamePlayed as Mutation$recordGamePlayed$recordGamePlayed),
      $__typename: $__typename == _undefined || $__typename == null
          ? _instance.$__typename
          : ($__typename as String),
    ),
  );

  CopyWith$Mutation$recordGamePlayed$recordGamePlayed<TRes>
  get recordGamePlayed {
    final local$recordGamePlayed = _instance.recordGamePlayed;
    return CopyWith$Mutation$recordGamePlayed$recordGamePlayed(
      local$recordGamePlayed,
      (e) => call(recordGamePlayed: e),
    );
  }
}

class _CopyWithStubImpl$Mutation$recordGamePlayed<TRes>
    implements CopyWith$Mutation$recordGamePlayed<TRes> {
  _CopyWithStubImpl$Mutation$recordGamePlayed(this._res);

  TRes _res;

  call({
    Mutation$recordGamePlayed$recordGamePlayed? recordGamePlayed,
    String? $__typename,
  }) => _res;

  CopyWith$Mutation$recordGamePlayed$recordGamePlayed<TRes>
  get recordGamePlayed =>
      CopyWith$Mutation$recordGamePlayed$recordGamePlayed.stub(_res);
}

const documentNodeMutationrecordGamePlayed = DocumentNode(
  definitions: [
    OperationDefinitionNode(
      type: OperationType.mutation,
      name: NameNode(value: 'recordGamePlayed'),
      variableDefinitions: [
        VariableDefinitionNode(
          variable: VariableNode(name: NameNode(value: 'gameId')),
          type: NamedTypeNode(name: NameNode(value: 'ID'), isNonNull: true),
          defaultValue: DefaultValueNode(value: null),
          directives: [],
        ),
        VariableDefinitionNode(
          variable: VariableNode(name: NameNode(value: 'durationMs')),
          type: NamedTypeNode(name: NameNode(value: 'Int'), isNonNull: true),
          defaultValue: DefaultValueNode(value: null),
          directives: [],
        ),
      ],
      directives: [],
      selectionSet: SelectionSetNode(
        selections: [
          FieldNode(
            name: NameNode(value: 'recordGamePlayed'),
            alias: null,
            arguments: [
              ArgumentNode(
                name: NameNode(value: 'gameId'),
                value: VariableNode(name: NameNode(value: 'gameId')),
              ),
              ArgumentNode(
                name: NameNode(value: 'durationMs'),
                value: VariableNode(name: NameNode(value: 'durationMs')),
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
                  name: NameNode(value: 'progressInMilliseconds'),
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

class Mutation$recordGamePlayed$recordGamePlayed {
  Mutation$recordGamePlayed$recordGamePlayed({
    required this.id,
    required this.progressInMilliseconds,
    required this.updatedAt,
    this.$__typename = 'WatchStatus',
  });

  factory Mutation$recordGamePlayed$recordGamePlayed.fromJson(
    Map<String, dynamic> json,
  ) {
    final l$id = json['id'];
    final l$progressInMilliseconds = json['progressInMilliseconds'];
    final l$updatedAt = json['updatedAt'];
    final l$$__typename = json['__typename'];
    return Mutation$recordGamePlayed$recordGamePlayed(
      id: (l$id as String),
      progressInMilliseconds: (l$progressInMilliseconds as int),
      updatedAt: (l$updatedAt as String),
      $__typename: (l$$__typename as String),
    );
  }

  final String id;

  final int progressInMilliseconds;

  final String updatedAt;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$id = id;
    _resultData['id'] = l$id;
    final l$progressInMilliseconds = progressInMilliseconds;
    _resultData['progressInMilliseconds'] = l$progressInMilliseconds;
    final l$updatedAt = updatedAt;
    _resultData['updatedAt'] = l$updatedAt;
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$id = id;
    final l$progressInMilliseconds = progressInMilliseconds;
    final l$updatedAt = updatedAt;
    final l$$__typename = $__typename;
    return Object.hashAll([
      l$id,
      l$progressInMilliseconds,
      l$updatedAt,
      l$$__typename,
    ]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Mutation$recordGamePlayed$recordGamePlayed ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$id = id;
    final lOther$id = other.id;
    if (l$id != lOther$id) {
      return false;
    }
    final l$progressInMilliseconds = progressInMilliseconds;
    final lOther$progressInMilliseconds = other.progressInMilliseconds;
    if (l$progressInMilliseconds != lOther$progressInMilliseconds) {
      return false;
    }
    final l$updatedAt = updatedAt;
    final lOther$updatedAt = other.updatedAt;
    if (l$updatedAt != lOther$updatedAt) {
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

extension UtilityExtension$Mutation$recordGamePlayed$recordGamePlayed
    on Mutation$recordGamePlayed$recordGamePlayed {
  CopyWith$Mutation$recordGamePlayed$recordGamePlayed<
    Mutation$recordGamePlayed$recordGamePlayed
  >
  get copyWith =>
      CopyWith$Mutation$recordGamePlayed$recordGamePlayed(this, (i) => i);
}

abstract class CopyWith$Mutation$recordGamePlayed$recordGamePlayed<TRes> {
  factory CopyWith$Mutation$recordGamePlayed$recordGamePlayed(
    Mutation$recordGamePlayed$recordGamePlayed instance,
    TRes Function(Mutation$recordGamePlayed$recordGamePlayed) then,
  ) = _CopyWithImpl$Mutation$recordGamePlayed$recordGamePlayed;

  factory CopyWith$Mutation$recordGamePlayed$recordGamePlayed.stub(TRes res) =
      _CopyWithStubImpl$Mutation$recordGamePlayed$recordGamePlayed;

  TRes call({
    String? id,
    int? progressInMilliseconds,
    String? updatedAt,
    String? $__typename,
  });
}

class _CopyWithImpl$Mutation$recordGamePlayed$recordGamePlayed<TRes>
    implements CopyWith$Mutation$recordGamePlayed$recordGamePlayed<TRes> {
  _CopyWithImpl$Mutation$recordGamePlayed$recordGamePlayed(
    this._instance,
    this._then,
  );

  final Mutation$recordGamePlayed$recordGamePlayed _instance;

  final TRes Function(Mutation$recordGamePlayed$recordGamePlayed) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? id = _undefined,
    Object? progressInMilliseconds = _undefined,
    Object? updatedAt = _undefined,
    Object? $__typename = _undefined,
  }) => _then(
    Mutation$recordGamePlayed$recordGamePlayed(
      id: id == _undefined || id == null ? _instance.id : (id as String),
      progressInMilliseconds:
          progressInMilliseconds == _undefined || progressInMilliseconds == null
          ? _instance.progressInMilliseconds
          : (progressInMilliseconds as int),
      updatedAt: updatedAt == _undefined || updatedAt == null
          ? _instance.updatedAt
          : (updatedAt as String),
      $__typename: $__typename == _undefined || $__typename == null
          ? _instance.$__typename
          : ($__typename as String),
    ),
  );
}

class _CopyWithStubImpl$Mutation$recordGamePlayed$recordGamePlayed<TRes>
    implements CopyWith$Mutation$recordGamePlayed$recordGamePlayed<TRes> {
  _CopyWithStubImpl$Mutation$recordGamePlayed$recordGamePlayed(this._res);

  TRes _res;

  call({
    String? id,
    int? progressInMilliseconds,
    String? updatedAt,
    String? $__typename,
  }) => _res;
}

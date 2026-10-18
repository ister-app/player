import 'package:gql/ast.dart';

class Variables$Mutation$restoreGameSave {
  factory Variables$Mutation$restoreGameSave({
    required String gameId,
    required int version,
  }) => Variables$Mutation$restoreGameSave._({
    r'gameId': gameId,
    r'version': version,
  });

  Variables$Mutation$restoreGameSave._(this._$data);

  factory Variables$Mutation$restoreGameSave.fromJson(
    Map<String, dynamic> data,
  ) {
    final result$data = <String, dynamic>{};
    final l$gameId = data['gameId'];
    result$data['gameId'] = (l$gameId as String);
    final l$version = data['version'];
    result$data['version'] = (l$version as int);
    return Variables$Mutation$restoreGameSave._(result$data);
  }

  Map<String, dynamic> _$data;

  String get gameId => (_$data['gameId'] as String);

  int get version => (_$data['version'] as int);

  Map<String, dynamic> toJson() {
    final result$data = <String, dynamic>{};
    final l$gameId = gameId;
    result$data['gameId'] = l$gameId;
    final l$version = version;
    result$data['version'] = l$version;
    return result$data;
  }

  CopyWith$Variables$Mutation$restoreGameSave<
    Variables$Mutation$restoreGameSave
  >
  get copyWith => CopyWith$Variables$Mutation$restoreGameSave(this, (i) => i);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Variables$Mutation$restoreGameSave ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$gameId = gameId;
    final lOther$gameId = other.gameId;
    if (l$gameId != lOther$gameId) {
      return false;
    }
    final l$version = version;
    final lOther$version = other.version;
    if (l$version != lOther$version) {
      return false;
    }
    return true;
  }

  @override
  int get hashCode {
    final l$gameId = gameId;
    final l$version = version;
    return Object.hashAll([l$gameId, l$version]);
  }
}

abstract class CopyWith$Variables$Mutation$restoreGameSave<TRes> {
  factory CopyWith$Variables$Mutation$restoreGameSave(
    Variables$Mutation$restoreGameSave instance,
    TRes Function(Variables$Mutation$restoreGameSave) then,
  ) = _CopyWithImpl$Variables$Mutation$restoreGameSave;

  factory CopyWith$Variables$Mutation$restoreGameSave.stub(TRes res) =
      _CopyWithStubImpl$Variables$Mutation$restoreGameSave;

  TRes call({String? gameId, int? version});
}

class _CopyWithImpl$Variables$Mutation$restoreGameSave<TRes>
    implements CopyWith$Variables$Mutation$restoreGameSave<TRes> {
  _CopyWithImpl$Variables$Mutation$restoreGameSave(this._instance, this._then);

  final Variables$Mutation$restoreGameSave _instance;

  final TRes Function(Variables$Mutation$restoreGameSave) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? gameId = _undefined,
    Object? version = _undefined,
  }) => _then(
    Variables$Mutation$restoreGameSave._({
      ..._instance._$data,
      if (gameId != _undefined && gameId != null) 'gameId': (gameId as String),
      if (version != _undefined && version != null) 'version': (version as int),
    }),
  );
}

class _CopyWithStubImpl$Variables$Mutation$restoreGameSave<TRes>
    implements CopyWith$Variables$Mutation$restoreGameSave<TRes> {
  _CopyWithStubImpl$Variables$Mutation$restoreGameSave(this._res);

  TRes _res;

  call({String? gameId, int? version}) => _res;
}

class Mutation$restoreGameSave {
  Mutation$restoreGameSave({
    required this.restoreGameSave,
    this.$__typename = 'Mutation',
  });

  factory Mutation$restoreGameSave.fromJson(Map<String, dynamic> json) {
    final l$restoreGameSave = json['restoreGameSave'];
    final l$$__typename = json['__typename'];
    return Mutation$restoreGameSave(
      restoreGameSave: Mutation$restoreGameSave$restoreGameSave.fromJson(
        (l$restoreGameSave as Map<String, dynamic>),
      ),
      $__typename: (l$$__typename as String),
    );
  }

  final Mutation$restoreGameSave$restoreGameSave restoreGameSave;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$restoreGameSave = restoreGameSave;
    _resultData['restoreGameSave'] = l$restoreGameSave.toJson();
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$restoreGameSave = restoreGameSave;
    final l$$__typename = $__typename;
    return Object.hashAll([l$restoreGameSave, l$$__typename]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Mutation$restoreGameSave ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$restoreGameSave = restoreGameSave;
    final lOther$restoreGameSave = other.restoreGameSave;
    if (l$restoreGameSave != lOther$restoreGameSave) {
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

extension UtilityExtension$Mutation$restoreGameSave
    on Mutation$restoreGameSave {
  CopyWith$Mutation$restoreGameSave<Mutation$restoreGameSave> get copyWith =>
      CopyWith$Mutation$restoreGameSave(this, (i) => i);
}

abstract class CopyWith$Mutation$restoreGameSave<TRes> {
  factory CopyWith$Mutation$restoreGameSave(
    Mutation$restoreGameSave instance,
    TRes Function(Mutation$restoreGameSave) then,
  ) = _CopyWithImpl$Mutation$restoreGameSave;

  factory CopyWith$Mutation$restoreGameSave.stub(TRes res) =
      _CopyWithStubImpl$Mutation$restoreGameSave;

  TRes call({
    Mutation$restoreGameSave$restoreGameSave? restoreGameSave,
    String? $__typename,
  });
  CopyWith$Mutation$restoreGameSave$restoreGameSave<TRes> get restoreGameSave;
}

class _CopyWithImpl$Mutation$restoreGameSave<TRes>
    implements CopyWith$Mutation$restoreGameSave<TRes> {
  _CopyWithImpl$Mutation$restoreGameSave(this._instance, this._then);

  final Mutation$restoreGameSave _instance;

  final TRes Function(Mutation$restoreGameSave) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? restoreGameSave = _undefined,
    Object? $__typename = _undefined,
  }) => _then(
    Mutation$restoreGameSave(
      restoreGameSave: restoreGameSave == _undefined || restoreGameSave == null
          ? _instance.restoreGameSave
          : (restoreGameSave as Mutation$restoreGameSave$restoreGameSave),
      $__typename: $__typename == _undefined || $__typename == null
          ? _instance.$__typename
          : ($__typename as String),
    ),
  );

  CopyWith$Mutation$restoreGameSave$restoreGameSave<TRes> get restoreGameSave {
    final local$restoreGameSave = _instance.restoreGameSave;
    return CopyWith$Mutation$restoreGameSave$restoreGameSave(
      local$restoreGameSave,
      (e) => call(restoreGameSave: e),
    );
  }
}

class _CopyWithStubImpl$Mutation$restoreGameSave<TRes>
    implements CopyWith$Mutation$restoreGameSave<TRes> {
  _CopyWithStubImpl$Mutation$restoreGameSave(this._res);

  TRes _res;

  call({
    Mutation$restoreGameSave$restoreGameSave? restoreGameSave,
    String? $__typename,
  }) => _res;

  CopyWith$Mutation$restoreGameSave$restoreGameSave<TRes> get restoreGameSave =>
      CopyWith$Mutation$restoreGameSave$restoreGameSave.stub(_res);
}

const documentNodeMutationrestoreGameSave = DocumentNode(
  definitions: [
    OperationDefinitionNode(
      type: OperationType.mutation,
      name: NameNode(value: 'restoreGameSave'),
      variableDefinitions: [
        VariableDefinitionNode(
          variable: VariableNode(name: NameNode(value: 'gameId')),
          type: NamedTypeNode(name: NameNode(value: 'ID'), isNonNull: true),
          defaultValue: DefaultValueNode(value: null),
          directives: [],
        ),
        VariableDefinitionNode(
          variable: VariableNode(name: NameNode(value: 'version')),
          type: NamedTypeNode(name: NameNode(value: 'Int'), isNonNull: true),
          defaultValue: DefaultValueNode(value: null),
          directives: [],
        ),
      ],
      directives: [],
      selectionSet: SelectionSetNode(
        selections: [
          FieldNode(
            name: NameNode(value: 'restoreGameSave'),
            alias: null,
            arguments: [
              ArgumentNode(
                name: NameNode(value: 'gameId'),
                value: VariableNode(name: NameNode(value: 'gameId')),
              ),
              ArgumentNode(
                name: NameNode(value: 'version'),
                value: VariableNode(name: NameNode(value: 'version')),
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
                  name: NameNode(value: 'version'),
                  alias: null,
                  arguments: [],
                  directives: [],
                  selectionSet: null,
                ),
                FieldNode(
                  name: NameNode(value: 'sizeBytes'),
                  alias: null,
                  arguments: [],
                  directives: [],
                  selectionSet: null,
                ),
                FieldNode(
                  name: NameNode(value: 'sha256'),
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
                  name: NameNode(value: 'note'),
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

class Mutation$restoreGameSave$restoreGameSave {
  Mutation$restoreGameSave$restoreGameSave({
    required this.id,
    required this.version,
    required this.sizeBytes,
    required this.sha256,
    this.deviceName,
    this.note,
    required this.createdAt,
    this.$__typename = 'GameSave',
  });

  factory Mutation$restoreGameSave$restoreGameSave.fromJson(
    Map<String, dynamic> json,
  ) {
    final l$id = json['id'];
    final l$version = json['version'];
    final l$sizeBytes = json['sizeBytes'];
    final l$sha256 = json['sha256'];
    final l$deviceName = json['deviceName'];
    final l$note = json['note'];
    final l$createdAt = json['createdAt'];
    final l$$__typename = json['__typename'];
    return Mutation$restoreGameSave$restoreGameSave(
      id: (l$id as String),
      version: (l$version as int),
      sizeBytes: (l$sizeBytes as num).toDouble(),
      sha256: (l$sha256 as String),
      deviceName: (l$deviceName as String?),
      note: (l$note as String?),
      createdAt: (l$createdAt as String),
      $__typename: (l$$__typename as String),
    );
  }

  final String id;

  final int version;

  final double sizeBytes;

  final String sha256;

  final String? deviceName;

  final String? note;

  final String createdAt;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$id = id;
    _resultData['id'] = l$id;
    final l$version = version;
    _resultData['version'] = l$version;
    final l$sizeBytes = sizeBytes;
    _resultData['sizeBytes'] = l$sizeBytes;
    final l$sha256 = sha256;
    _resultData['sha256'] = l$sha256;
    final l$deviceName = deviceName;
    _resultData['deviceName'] = l$deviceName;
    final l$note = note;
    _resultData['note'] = l$note;
    final l$createdAt = createdAt;
    _resultData['createdAt'] = l$createdAt;
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$id = id;
    final l$version = version;
    final l$sizeBytes = sizeBytes;
    final l$sha256 = sha256;
    final l$deviceName = deviceName;
    final l$note = note;
    final l$createdAt = createdAt;
    final l$$__typename = $__typename;
    return Object.hashAll([
      l$id,
      l$version,
      l$sizeBytes,
      l$sha256,
      l$deviceName,
      l$note,
      l$createdAt,
      l$$__typename,
    ]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Mutation$restoreGameSave$restoreGameSave ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$id = id;
    final lOther$id = other.id;
    if (l$id != lOther$id) {
      return false;
    }
    final l$version = version;
    final lOther$version = other.version;
    if (l$version != lOther$version) {
      return false;
    }
    final l$sizeBytes = sizeBytes;
    final lOther$sizeBytes = other.sizeBytes;
    if (l$sizeBytes != lOther$sizeBytes) {
      return false;
    }
    final l$sha256 = sha256;
    final lOther$sha256 = other.sha256;
    if (l$sha256 != lOther$sha256) {
      return false;
    }
    final l$deviceName = deviceName;
    final lOther$deviceName = other.deviceName;
    if (l$deviceName != lOther$deviceName) {
      return false;
    }
    final l$note = note;
    final lOther$note = other.note;
    if (l$note != lOther$note) {
      return false;
    }
    final l$createdAt = createdAt;
    final lOther$createdAt = other.createdAt;
    if (l$createdAt != lOther$createdAt) {
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

extension UtilityExtension$Mutation$restoreGameSave$restoreGameSave
    on Mutation$restoreGameSave$restoreGameSave {
  CopyWith$Mutation$restoreGameSave$restoreGameSave<
    Mutation$restoreGameSave$restoreGameSave
  >
  get copyWith =>
      CopyWith$Mutation$restoreGameSave$restoreGameSave(this, (i) => i);
}

abstract class CopyWith$Mutation$restoreGameSave$restoreGameSave<TRes> {
  factory CopyWith$Mutation$restoreGameSave$restoreGameSave(
    Mutation$restoreGameSave$restoreGameSave instance,
    TRes Function(Mutation$restoreGameSave$restoreGameSave) then,
  ) = _CopyWithImpl$Mutation$restoreGameSave$restoreGameSave;

  factory CopyWith$Mutation$restoreGameSave$restoreGameSave.stub(TRes res) =
      _CopyWithStubImpl$Mutation$restoreGameSave$restoreGameSave;

  TRes call({
    String? id,
    int? version,
    double? sizeBytes,
    String? sha256,
    String? deviceName,
    String? note,
    String? createdAt,
    String? $__typename,
  });
}

class _CopyWithImpl$Mutation$restoreGameSave$restoreGameSave<TRes>
    implements CopyWith$Mutation$restoreGameSave$restoreGameSave<TRes> {
  _CopyWithImpl$Mutation$restoreGameSave$restoreGameSave(
    this._instance,
    this._then,
  );

  final Mutation$restoreGameSave$restoreGameSave _instance;

  final TRes Function(Mutation$restoreGameSave$restoreGameSave) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? id = _undefined,
    Object? version = _undefined,
    Object? sizeBytes = _undefined,
    Object? sha256 = _undefined,
    Object? deviceName = _undefined,
    Object? note = _undefined,
    Object? createdAt = _undefined,
    Object? $__typename = _undefined,
  }) => _then(
    Mutation$restoreGameSave$restoreGameSave(
      id: id == _undefined || id == null ? _instance.id : (id as String),
      version: version == _undefined || version == null
          ? _instance.version
          : (version as int),
      sizeBytes: sizeBytes == _undefined || sizeBytes == null
          ? _instance.sizeBytes
          : (sizeBytes as double),
      sha256: sha256 == _undefined || sha256 == null
          ? _instance.sha256
          : (sha256 as String),
      deviceName: deviceName == _undefined
          ? _instance.deviceName
          : (deviceName as String?),
      note: note == _undefined ? _instance.note : (note as String?),
      createdAt: createdAt == _undefined || createdAt == null
          ? _instance.createdAt
          : (createdAt as String),
      $__typename: $__typename == _undefined || $__typename == null
          ? _instance.$__typename
          : ($__typename as String),
    ),
  );
}

class _CopyWithStubImpl$Mutation$restoreGameSave$restoreGameSave<TRes>
    implements CopyWith$Mutation$restoreGameSave$restoreGameSave<TRes> {
  _CopyWithStubImpl$Mutation$restoreGameSave$restoreGameSave(this._res);

  TRes _res;

  call({
    String? id,
    int? version,
    double? sizeBytes,
    String? sha256,
    String? deviceName,
    String? note,
    String? createdAt,
    String? $__typename,
  }) => _res;
}

class Variables$Mutation$deleteGameSave {
  factory Variables$Mutation$deleteGameSave({
    required String gameId,
    required int version,
  }) => Variables$Mutation$deleteGameSave._({
    r'gameId': gameId,
    r'version': version,
  });

  Variables$Mutation$deleteGameSave._(this._$data);

  factory Variables$Mutation$deleteGameSave.fromJson(
    Map<String, dynamic> data,
  ) {
    final result$data = <String, dynamic>{};
    final l$gameId = data['gameId'];
    result$data['gameId'] = (l$gameId as String);
    final l$version = data['version'];
    result$data['version'] = (l$version as int);
    return Variables$Mutation$deleteGameSave._(result$data);
  }

  Map<String, dynamic> _$data;

  String get gameId => (_$data['gameId'] as String);

  int get version => (_$data['version'] as int);

  Map<String, dynamic> toJson() {
    final result$data = <String, dynamic>{};
    final l$gameId = gameId;
    result$data['gameId'] = l$gameId;
    final l$version = version;
    result$data['version'] = l$version;
    return result$data;
  }

  CopyWith$Variables$Mutation$deleteGameSave<Variables$Mutation$deleteGameSave>
  get copyWith => CopyWith$Variables$Mutation$deleteGameSave(this, (i) => i);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Variables$Mutation$deleteGameSave ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$gameId = gameId;
    final lOther$gameId = other.gameId;
    if (l$gameId != lOther$gameId) {
      return false;
    }
    final l$version = version;
    final lOther$version = other.version;
    if (l$version != lOther$version) {
      return false;
    }
    return true;
  }

  @override
  int get hashCode {
    final l$gameId = gameId;
    final l$version = version;
    return Object.hashAll([l$gameId, l$version]);
  }
}

abstract class CopyWith$Variables$Mutation$deleteGameSave<TRes> {
  factory CopyWith$Variables$Mutation$deleteGameSave(
    Variables$Mutation$deleteGameSave instance,
    TRes Function(Variables$Mutation$deleteGameSave) then,
  ) = _CopyWithImpl$Variables$Mutation$deleteGameSave;

  factory CopyWith$Variables$Mutation$deleteGameSave.stub(TRes res) =
      _CopyWithStubImpl$Variables$Mutation$deleteGameSave;

  TRes call({String? gameId, int? version});
}

class _CopyWithImpl$Variables$Mutation$deleteGameSave<TRes>
    implements CopyWith$Variables$Mutation$deleteGameSave<TRes> {
  _CopyWithImpl$Variables$Mutation$deleteGameSave(this._instance, this._then);

  final Variables$Mutation$deleteGameSave _instance;

  final TRes Function(Variables$Mutation$deleteGameSave) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? gameId = _undefined,
    Object? version = _undefined,
  }) => _then(
    Variables$Mutation$deleteGameSave._({
      ..._instance._$data,
      if (gameId != _undefined && gameId != null) 'gameId': (gameId as String),
      if (version != _undefined && version != null) 'version': (version as int),
    }),
  );
}

class _CopyWithStubImpl$Variables$Mutation$deleteGameSave<TRes>
    implements CopyWith$Variables$Mutation$deleteGameSave<TRes> {
  _CopyWithStubImpl$Variables$Mutation$deleteGameSave(this._res);

  TRes _res;

  call({String? gameId, int? version}) => _res;
}

class Mutation$deleteGameSave {
  Mutation$deleteGameSave({
    required this.deleteGameSave,
    this.$__typename = 'Mutation',
  });

  factory Mutation$deleteGameSave.fromJson(Map<String, dynamic> json) {
    final l$deleteGameSave = json['deleteGameSave'];
    final l$$__typename = json['__typename'];
    return Mutation$deleteGameSave(
      deleteGameSave: (l$deleteGameSave as bool),
      $__typename: (l$$__typename as String),
    );
  }

  final bool deleteGameSave;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$deleteGameSave = deleteGameSave;
    _resultData['deleteGameSave'] = l$deleteGameSave;
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$deleteGameSave = deleteGameSave;
    final l$$__typename = $__typename;
    return Object.hashAll([l$deleteGameSave, l$$__typename]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Mutation$deleteGameSave || runtimeType != other.runtimeType) {
      return false;
    }
    final l$deleteGameSave = deleteGameSave;
    final lOther$deleteGameSave = other.deleteGameSave;
    if (l$deleteGameSave != lOther$deleteGameSave) {
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

extension UtilityExtension$Mutation$deleteGameSave on Mutation$deleteGameSave {
  CopyWith$Mutation$deleteGameSave<Mutation$deleteGameSave> get copyWith =>
      CopyWith$Mutation$deleteGameSave(this, (i) => i);
}

abstract class CopyWith$Mutation$deleteGameSave<TRes> {
  factory CopyWith$Mutation$deleteGameSave(
    Mutation$deleteGameSave instance,
    TRes Function(Mutation$deleteGameSave) then,
  ) = _CopyWithImpl$Mutation$deleteGameSave;

  factory CopyWith$Mutation$deleteGameSave.stub(TRes res) =
      _CopyWithStubImpl$Mutation$deleteGameSave;

  TRes call({bool? deleteGameSave, String? $__typename});
}

class _CopyWithImpl$Mutation$deleteGameSave<TRes>
    implements CopyWith$Mutation$deleteGameSave<TRes> {
  _CopyWithImpl$Mutation$deleteGameSave(this._instance, this._then);

  final Mutation$deleteGameSave _instance;

  final TRes Function(Mutation$deleteGameSave) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? deleteGameSave = _undefined,
    Object? $__typename = _undefined,
  }) => _then(
    Mutation$deleteGameSave(
      deleteGameSave: deleteGameSave == _undefined || deleteGameSave == null
          ? _instance.deleteGameSave
          : (deleteGameSave as bool),
      $__typename: $__typename == _undefined || $__typename == null
          ? _instance.$__typename
          : ($__typename as String),
    ),
  );
}

class _CopyWithStubImpl$Mutation$deleteGameSave<TRes>
    implements CopyWith$Mutation$deleteGameSave<TRes> {
  _CopyWithStubImpl$Mutation$deleteGameSave(this._res);

  TRes _res;

  call({bool? deleteGameSave, String? $__typename}) => _res;
}

const documentNodeMutationdeleteGameSave = DocumentNode(
  definitions: [
    OperationDefinitionNode(
      type: OperationType.mutation,
      name: NameNode(value: 'deleteGameSave'),
      variableDefinitions: [
        VariableDefinitionNode(
          variable: VariableNode(name: NameNode(value: 'gameId')),
          type: NamedTypeNode(name: NameNode(value: 'ID'), isNonNull: true),
          defaultValue: DefaultValueNode(value: null),
          directives: [],
        ),
        VariableDefinitionNode(
          variable: VariableNode(name: NameNode(value: 'version')),
          type: NamedTypeNode(name: NameNode(value: 'Int'), isNonNull: true),
          defaultValue: DefaultValueNode(value: null),
          directives: [],
        ),
      ],
      directives: [],
      selectionSet: SelectionSetNode(
        selections: [
          FieldNode(
            name: NameNode(value: 'deleteGameSave'),
            alias: null,
            arguments: [
              ArgumentNode(
                name: NameNode(value: 'gameId'),
                value: VariableNode(name: NameNode(value: 'gameId')),
              ),
              ArgumentNode(
                name: NameNode(value: 'version'),
                value: VariableNode(name: NameNode(value: 'version')),
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

class Variables$Mutation$updateGameSavePaths {
  factory Variables$Mutation$updateGameSavePaths({
    required String gameId,
    required List<String> savePaths,
  }) => Variables$Mutation$updateGameSavePaths._({
    r'gameId': gameId,
    r'savePaths': savePaths,
  });

  Variables$Mutation$updateGameSavePaths._(this._$data);

  factory Variables$Mutation$updateGameSavePaths.fromJson(
    Map<String, dynamic> data,
  ) {
    final result$data = <String, dynamic>{};
    final l$gameId = data['gameId'];
    result$data['gameId'] = (l$gameId as String);
    final l$savePaths = data['savePaths'];
    result$data['savePaths'] = (l$savePaths as List<dynamic>)
        .map((e) => (e as String))
        .toList();
    return Variables$Mutation$updateGameSavePaths._(result$data);
  }

  Map<String, dynamic> _$data;

  String get gameId => (_$data['gameId'] as String);

  List<String> get savePaths => (_$data['savePaths'] as List<String>);

  Map<String, dynamic> toJson() {
    final result$data = <String, dynamic>{};
    final l$gameId = gameId;
    result$data['gameId'] = l$gameId;
    final l$savePaths = savePaths;
    result$data['savePaths'] = l$savePaths.map((e) => e).toList();
    return result$data;
  }

  CopyWith$Variables$Mutation$updateGameSavePaths<
    Variables$Mutation$updateGameSavePaths
  >
  get copyWith =>
      CopyWith$Variables$Mutation$updateGameSavePaths(this, (i) => i);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Variables$Mutation$updateGameSavePaths ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$gameId = gameId;
    final lOther$gameId = other.gameId;
    if (l$gameId != lOther$gameId) {
      return false;
    }
    final l$savePaths = savePaths;
    final lOther$savePaths = other.savePaths;
    if (l$savePaths.length != lOther$savePaths.length) {
      return false;
    }
    for (int i = 0; i < l$savePaths.length; i++) {
      final l$savePaths$entry = l$savePaths[i];
      final lOther$savePaths$entry = lOther$savePaths[i];
      if (l$savePaths$entry != lOther$savePaths$entry) {
        return false;
      }
    }
    return true;
  }

  @override
  int get hashCode {
    final l$gameId = gameId;
    final l$savePaths = savePaths;
    return Object.hashAll([
      l$gameId,
      Object.hashAll(l$savePaths.map((v) => v)),
    ]);
  }
}

abstract class CopyWith$Variables$Mutation$updateGameSavePaths<TRes> {
  factory CopyWith$Variables$Mutation$updateGameSavePaths(
    Variables$Mutation$updateGameSavePaths instance,
    TRes Function(Variables$Mutation$updateGameSavePaths) then,
  ) = _CopyWithImpl$Variables$Mutation$updateGameSavePaths;

  factory CopyWith$Variables$Mutation$updateGameSavePaths.stub(TRes res) =
      _CopyWithStubImpl$Variables$Mutation$updateGameSavePaths;

  TRes call({String? gameId, List<String>? savePaths});
}

class _CopyWithImpl$Variables$Mutation$updateGameSavePaths<TRes>
    implements CopyWith$Variables$Mutation$updateGameSavePaths<TRes> {
  _CopyWithImpl$Variables$Mutation$updateGameSavePaths(
    this._instance,
    this._then,
  );

  final Variables$Mutation$updateGameSavePaths _instance;

  final TRes Function(Variables$Mutation$updateGameSavePaths) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({Object? gameId = _undefined, Object? savePaths = _undefined}) =>
      _then(
        Variables$Mutation$updateGameSavePaths._({
          ..._instance._$data,
          if (gameId != _undefined && gameId != null)
            'gameId': (gameId as String),
          if (savePaths != _undefined && savePaths != null)
            'savePaths': (savePaths as List<String>),
        }),
      );
}

class _CopyWithStubImpl$Variables$Mutation$updateGameSavePaths<TRes>
    implements CopyWith$Variables$Mutation$updateGameSavePaths<TRes> {
  _CopyWithStubImpl$Variables$Mutation$updateGameSavePaths(this._res);

  TRes _res;

  call({String? gameId, List<String>? savePaths}) => _res;
}

class Mutation$updateGameSavePaths {
  Mutation$updateGameSavePaths({
    required this.updateGameSavePaths,
    this.$__typename = 'Mutation',
  });

  factory Mutation$updateGameSavePaths.fromJson(Map<String, dynamic> json) {
    final l$updateGameSavePaths = json['updateGameSavePaths'];
    final l$$__typename = json['__typename'];
    return Mutation$updateGameSavePaths(
      updateGameSavePaths:
          Mutation$updateGameSavePaths$updateGameSavePaths.fromJson(
            (l$updateGameSavePaths as Map<String, dynamic>),
          ),
      $__typename: (l$$__typename as String),
    );
  }

  final Mutation$updateGameSavePaths$updateGameSavePaths updateGameSavePaths;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$updateGameSavePaths = updateGameSavePaths;
    _resultData['updateGameSavePaths'] = l$updateGameSavePaths.toJson();
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$updateGameSavePaths = updateGameSavePaths;
    final l$$__typename = $__typename;
    return Object.hashAll([l$updateGameSavePaths, l$$__typename]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Mutation$updateGameSavePaths ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$updateGameSavePaths = updateGameSavePaths;
    final lOther$updateGameSavePaths = other.updateGameSavePaths;
    if (l$updateGameSavePaths != lOther$updateGameSavePaths) {
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

extension UtilityExtension$Mutation$updateGameSavePaths
    on Mutation$updateGameSavePaths {
  CopyWith$Mutation$updateGameSavePaths<Mutation$updateGameSavePaths>
  get copyWith => CopyWith$Mutation$updateGameSavePaths(this, (i) => i);
}

abstract class CopyWith$Mutation$updateGameSavePaths<TRes> {
  factory CopyWith$Mutation$updateGameSavePaths(
    Mutation$updateGameSavePaths instance,
    TRes Function(Mutation$updateGameSavePaths) then,
  ) = _CopyWithImpl$Mutation$updateGameSavePaths;

  factory CopyWith$Mutation$updateGameSavePaths.stub(TRes res) =
      _CopyWithStubImpl$Mutation$updateGameSavePaths;

  TRes call({
    Mutation$updateGameSavePaths$updateGameSavePaths? updateGameSavePaths,
    String? $__typename,
  });
  CopyWith$Mutation$updateGameSavePaths$updateGameSavePaths<TRes>
  get updateGameSavePaths;
}

class _CopyWithImpl$Mutation$updateGameSavePaths<TRes>
    implements CopyWith$Mutation$updateGameSavePaths<TRes> {
  _CopyWithImpl$Mutation$updateGameSavePaths(this._instance, this._then);

  final Mutation$updateGameSavePaths _instance;

  final TRes Function(Mutation$updateGameSavePaths) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? updateGameSavePaths = _undefined,
    Object? $__typename = _undefined,
  }) => _then(
    Mutation$updateGameSavePaths(
      updateGameSavePaths:
          updateGameSavePaths == _undefined || updateGameSavePaths == null
          ? _instance.updateGameSavePaths
          : (updateGameSavePaths
                as Mutation$updateGameSavePaths$updateGameSavePaths),
      $__typename: $__typename == _undefined || $__typename == null
          ? _instance.$__typename
          : ($__typename as String),
    ),
  );

  CopyWith$Mutation$updateGameSavePaths$updateGameSavePaths<TRes>
  get updateGameSavePaths {
    final local$updateGameSavePaths = _instance.updateGameSavePaths;
    return CopyWith$Mutation$updateGameSavePaths$updateGameSavePaths(
      local$updateGameSavePaths,
      (e) => call(updateGameSavePaths: e),
    );
  }
}

class _CopyWithStubImpl$Mutation$updateGameSavePaths<TRes>
    implements CopyWith$Mutation$updateGameSavePaths<TRes> {
  _CopyWithStubImpl$Mutation$updateGameSavePaths(this._res);

  TRes _res;

  call({
    Mutation$updateGameSavePaths$updateGameSavePaths? updateGameSavePaths,
    String? $__typename,
  }) => _res;

  CopyWith$Mutation$updateGameSavePaths$updateGameSavePaths<TRes>
  get updateGameSavePaths =>
      CopyWith$Mutation$updateGameSavePaths$updateGameSavePaths.stub(_res);
}

const documentNodeMutationupdateGameSavePaths = DocumentNode(
  definitions: [
    OperationDefinitionNode(
      type: OperationType.mutation,
      name: NameNode(value: 'updateGameSavePaths'),
      variableDefinitions: [
        VariableDefinitionNode(
          variable: VariableNode(name: NameNode(value: 'gameId')),
          type: NamedTypeNode(name: NameNode(value: 'ID'), isNonNull: true),
          defaultValue: DefaultValueNode(value: null),
          directives: [],
        ),
        VariableDefinitionNode(
          variable: VariableNode(name: NameNode(value: 'savePaths')),
          type: ListTypeNode(
            type: NamedTypeNode(
              name: NameNode(value: 'String'),
              isNonNull: true,
            ),
            isNonNull: true,
          ),
          defaultValue: DefaultValueNode(value: null),
          directives: [],
        ),
      ],
      directives: [],
      selectionSet: SelectionSetNode(
        selections: [
          FieldNode(
            name: NameNode(value: 'updateGameSavePaths'),
            alias: null,
            arguments: [
              ArgumentNode(
                name: NameNode(value: 'gameId'),
                value: VariableNode(name: NameNode(value: 'gameId')),
              ),
              ArgumentNode(
                name: NameNode(value: 'savePaths'),
                value: VariableNode(name: NameNode(value: 'savePaths')),
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
                  name: NameNode(value: 'savePathSource'),
                  alias: null,
                  arguments: [],
                  directives: [],
                  selectionSet: null,
                ),
                FieldNode(
                  name: NameNode(value: 'savePaths'),
                  alias: null,
                  arguments: [],
                  directives: [],
                  selectionSet: SelectionSetNode(
                    selections: [
                      FieldNode(
                        name: NameNode(value: 'path'),
                        alias: null,
                        arguments: [],
                        directives: [],
                        selectionSet: null,
                      ),
                      FieldNode(
                        name: NameNode(value: 'os'),
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
                  name: NameNode(value: 'savePathOverride'),
                  alias: null,
                  arguments: [],
                  directives: [],
                  selectionSet: SelectionSetNode(
                    selections: [
                      FieldNode(
                        name: NameNode(value: 'path'),
                        alias: null,
                        arguments: [],
                        directives: [],
                        selectionSet: null,
                      ),
                      FieldNode(
                        name: NameNode(value: 'os'),
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

class Mutation$updateGameSavePaths$updateGameSavePaths {
  Mutation$updateGameSavePaths$updateGameSavePaths({
    required this.id,
    required this.savePathSource,
    required this.savePaths,
    required this.savePathOverride,
    this.$__typename = 'Game',
  });

  factory Mutation$updateGameSavePaths$updateGameSavePaths.fromJson(
    Map<String, dynamic> json,
  ) {
    final l$id = json['id'];
    final l$savePathSource = json['savePathSource'];
    final l$savePaths = json['savePaths'];
    final l$savePathOverride = json['savePathOverride'];
    final l$$__typename = json['__typename'];
    return Mutation$updateGameSavePaths$updateGameSavePaths(
      id: (l$id as String),
      savePathSource: (l$savePathSource as String),
      savePaths: (l$savePaths as List<dynamic>)
          .map(
            (e) =>
                Mutation$updateGameSavePaths$updateGameSavePaths$savePaths.fromJson(
                  (e as Map<String, dynamic>),
                ),
          )
          .toList(),
      savePathOverride: (l$savePathOverride as List<dynamic>)
          .map(
            (e) =>
                Mutation$updateGameSavePaths$updateGameSavePaths$savePathOverride.fromJson(
                  (e as Map<String, dynamic>),
                ),
          )
          .toList(),
      $__typename: (l$$__typename as String),
    );
  }

  final String id;

  final String savePathSource;

  final List<Mutation$updateGameSavePaths$updateGameSavePaths$savePaths>
  savePaths;

  final List<Mutation$updateGameSavePaths$updateGameSavePaths$savePathOverride>
  savePathOverride;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$id = id;
    _resultData['id'] = l$id;
    final l$savePathSource = savePathSource;
    _resultData['savePathSource'] = l$savePathSource;
    final l$savePaths = savePaths;
    _resultData['savePaths'] = l$savePaths.map((e) => e.toJson()).toList();
    final l$savePathOverride = savePathOverride;
    _resultData['savePathOverride'] = l$savePathOverride
        .map((e) => e.toJson())
        .toList();
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$id = id;
    final l$savePathSource = savePathSource;
    final l$savePaths = savePaths;
    final l$savePathOverride = savePathOverride;
    final l$$__typename = $__typename;
    return Object.hashAll([
      l$id,
      l$savePathSource,
      Object.hashAll(l$savePaths.map((v) => v)),
      Object.hashAll(l$savePathOverride.map((v) => v)),
      l$$__typename,
    ]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Mutation$updateGameSavePaths$updateGameSavePaths ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$id = id;
    final lOther$id = other.id;
    if (l$id != lOther$id) {
      return false;
    }
    final l$savePathSource = savePathSource;
    final lOther$savePathSource = other.savePathSource;
    if (l$savePathSource != lOther$savePathSource) {
      return false;
    }
    final l$savePaths = savePaths;
    final lOther$savePaths = other.savePaths;
    if (l$savePaths.length != lOther$savePaths.length) {
      return false;
    }
    for (int i = 0; i < l$savePaths.length; i++) {
      final l$savePaths$entry = l$savePaths[i];
      final lOther$savePaths$entry = lOther$savePaths[i];
      if (l$savePaths$entry != lOther$savePaths$entry) {
        return false;
      }
    }
    final l$savePathOverride = savePathOverride;
    final lOther$savePathOverride = other.savePathOverride;
    if (l$savePathOverride.length != lOther$savePathOverride.length) {
      return false;
    }
    for (int i = 0; i < l$savePathOverride.length; i++) {
      final l$savePathOverride$entry = l$savePathOverride[i];
      final lOther$savePathOverride$entry = lOther$savePathOverride[i];
      if (l$savePathOverride$entry != lOther$savePathOverride$entry) {
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

extension UtilityExtension$Mutation$updateGameSavePaths$updateGameSavePaths
    on Mutation$updateGameSavePaths$updateGameSavePaths {
  CopyWith$Mutation$updateGameSavePaths$updateGameSavePaths<
    Mutation$updateGameSavePaths$updateGameSavePaths
  >
  get copyWith =>
      CopyWith$Mutation$updateGameSavePaths$updateGameSavePaths(this, (i) => i);
}

abstract class CopyWith$Mutation$updateGameSavePaths$updateGameSavePaths<TRes> {
  factory CopyWith$Mutation$updateGameSavePaths$updateGameSavePaths(
    Mutation$updateGameSavePaths$updateGameSavePaths instance,
    TRes Function(Mutation$updateGameSavePaths$updateGameSavePaths) then,
  ) = _CopyWithImpl$Mutation$updateGameSavePaths$updateGameSavePaths;

  factory CopyWith$Mutation$updateGameSavePaths$updateGameSavePaths.stub(
    TRes res,
  ) = _CopyWithStubImpl$Mutation$updateGameSavePaths$updateGameSavePaths;

  TRes call({
    String? id,
    String? savePathSource,
    List<Mutation$updateGameSavePaths$updateGameSavePaths$savePaths>? savePaths,
    List<Mutation$updateGameSavePaths$updateGameSavePaths$savePathOverride>?
    savePathOverride,
    String? $__typename,
  });
  TRes savePaths(
    Iterable<Mutation$updateGameSavePaths$updateGameSavePaths$savePaths>
    Function(
      Iterable<
        CopyWith$Mutation$updateGameSavePaths$updateGameSavePaths$savePaths<
          Mutation$updateGameSavePaths$updateGameSavePaths$savePaths
        >
      >,
    )
    _fn,
  );
  TRes savePathOverride(
    Iterable<Mutation$updateGameSavePaths$updateGameSavePaths$savePathOverride>
    Function(
      Iterable<
        CopyWith$Mutation$updateGameSavePaths$updateGameSavePaths$savePathOverride<
          Mutation$updateGameSavePaths$updateGameSavePaths$savePathOverride
        >
      >,
    )
    _fn,
  );
}

class _CopyWithImpl$Mutation$updateGameSavePaths$updateGameSavePaths<TRes>
    implements CopyWith$Mutation$updateGameSavePaths$updateGameSavePaths<TRes> {
  _CopyWithImpl$Mutation$updateGameSavePaths$updateGameSavePaths(
    this._instance,
    this._then,
  );

  final Mutation$updateGameSavePaths$updateGameSavePaths _instance;

  final TRes Function(Mutation$updateGameSavePaths$updateGameSavePaths) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? id = _undefined,
    Object? savePathSource = _undefined,
    Object? savePaths = _undefined,
    Object? savePathOverride = _undefined,
    Object? $__typename = _undefined,
  }) => _then(
    Mutation$updateGameSavePaths$updateGameSavePaths(
      id: id == _undefined || id == null ? _instance.id : (id as String),
      savePathSource: savePathSource == _undefined || savePathSource == null
          ? _instance.savePathSource
          : (savePathSource as String),
      savePaths: savePaths == _undefined || savePaths == null
          ? _instance.savePaths
          : (savePaths
                as List<
                  Mutation$updateGameSavePaths$updateGameSavePaths$savePaths
                >),
      savePathOverride:
          savePathOverride == _undefined || savePathOverride == null
          ? _instance.savePathOverride
          : (savePathOverride
                as List<
                  Mutation$updateGameSavePaths$updateGameSavePaths$savePathOverride
                >),
      $__typename: $__typename == _undefined || $__typename == null
          ? _instance.$__typename
          : ($__typename as String),
    ),
  );

  TRes savePaths(
    Iterable<Mutation$updateGameSavePaths$updateGameSavePaths$savePaths>
    Function(
      Iterable<
        CopyWith$Mutation$updateGameSavePaths$updateGameSavePaths$savePaths<
          Mutation$updateGameSavePaths$updateGameSavePaths$savePaths
        >
      >,
    )
    _fn,
  ) => call(
    savePaths: _fn(
      _instance.savePaths.map(
        (e) =>
            CopyWith$Mutation$updateGameSavePaths$updateGameSavePaths$savePaths(
              e,
              (i) => i,
            ),
      ),
    ).toList(),
  );

  TRes savePathOverride(
    Iterable<Mutation$updateGameSavePaths$updateGameSavePaths$savePathOverride>
    Function(
      Iterable<
        CopyWith$Mutation$updateGameSavePaths$updateGameSavePaths$savePathOverride<
          Mutation$updateGameSavePaths$updateGameSavePaths$savePathOverride
        >
      >,
    )
    _fn,
  ) => call(
    savePathOverride: _fn(
      _instance.savePathOverride.map(
        (e) =>
            CopyWith$Mutation$updateGameSavePaths$updateGameSavePaths$savePathOverride(
              e,
              (i) => i,
            ),
      ),
    ).toList(),
  );
}

class _CopyWithStubImpl$Mutation$updateGameSavePaths$updateGameSavePaths<TRes>
    implements CopyWith$Mutation$updateGameSavePaths$updateGameSavePaths<TRes> {
  _CopyWithStubImpl$Mutation$updateGameSavePaths$updateGameSavePaths(this._res);

  TRes _res;

  call({
    String? id,
    String? savePathSource,
    List<Mutation$updateGameSavePaths$updateGameSavePaths$savePaths>? savePaths,
    List<Mutation$updateGameSavePaths$updateGameSavePaths$savePathOverride>?
    savePathOverride,
    String? $__typename,
  }) => _res;

  savePaths(_fn) => _res;

  savePathOverride(_fn) => _res;
}

class Mutation$updateGameSavePaths$updateGameSavePaths$savePaths {
  Mutation$updateGameSavePaths$updateGameSavePaths$savePaths({
    required this.path,
    this.os,
    this.$__typename = 'GameSavePath',
  });

  factory Mutation$updateGameSavePaths$updateGameSavePaths$savePaths.fromJson(
    Map<String, dynamic> json,
  ) {
    final l$path = json['path'];
    final l$os = json['os'];
    final l$$__typename = json['__typename'];
    return Mutation$updateGameSavePaths$updateGameSavePaths$savePaths(
      path: (l$path as String),
      os: (l$os as String?),
      $__typename: (l$$__typename as String),
    );
  }

  final String path;

  final String? os;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$path = path;
    _resultData['path'] = l$path;
    final l$os = os;
    _resultData['os'] = l$os;
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$path = path;
    final l$os = os;
    final l$$__typename = $__typename;
    return Object.hashAll([l$path, l$os, l$$__typename]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Mutation$updateGameSavePaths$updateGameSavePaths$savePaths ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$path = path;
    final lOther$path = other.path;
    if (l$path != lOther$path) {
      return false;
    }
    final l$os = os;
    final lOther$os = other.os;
    if (l$os != lOther$os) {
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

extension UtilityExtension$Mutation$updateGameSavePaths$updateGameSavePaths$savePaths
    on Mutation$updateGameSavePaths$updateGameSavePaths$savePaths {
  CopyWith$Mutation$updateGameSavePaths$updateGameSavePaths$savePaths<
    Mutation$updateGameSavePaths$updateGameSavePaths$savePaths
  >
  get copyWith =>
      CopyWith$Mutation$updateGameSavePaths$updateGameSavePaths$savePaths(
        this,
        (i) => i,
      );
}

abstract class CopyWith$Mutation$updateGameSavePaths$updateGameSavePaths$savePaths<
  TRes
> {
  factory CopyWith$Mutation$updateGameSavePaths$updateGameSavePaths$savePaths(
    Mutation$updateGameSavePaths$updateGameSavePaths$savePaths instance,
    TRes Function(Mutation$updateGameSavePaths$updateGameSavePaths$savePaths)
    then,
  ) = _CopyWithImpl$Mutation$updateGameSavePaths$updateGameSavePaths$savePaths;

  factory CopyWith$Mutation$updateGameSavePaths$updateGameSavePaths$savePaths.stub(
    TRes res,
  ) = _CopyWithStubImpl$Mutation$updateGameSavePaths$updateGameSavePaths$savePaths;

  TRes call({String? path, String? os, String? $__typename});
}

class _CopyWithImpl$Mutation$updateGameSavePaths$updateGameSavePaths$savePaths<
  TRes
>
    implements
        CopyWith$Mutation$updateGameSavePaths$updateGameSavePaths$savePaths<
          TRes
        > {
  _CopyWithImpl$Mutation$updateGameSavePaths$updateGameSavePaths$savePaths(
    this._instance,
    this._then,
  );

  final Mutation$updateGameSavePaths$updateGameSavePaths$savePaths _instance;

  final TRes Function(
    Mutation$updateGameSavePaths$updateGameSavePaths$savePaths,
  )
  _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? path = _undefined,
    Object? os = _undefined,
    Object? $__typename = _undefined,
  }) => _then(
    Mutation$updateGameSavePaths$updateGameSavePaths$savePaths(
      path: path == _undefined || path == null
          ? _instance.path
          : (path as String),
      os: os == _undefined ? _instance.os : (os as String?),
      $__typename: $__typename == _undefined || $__typename == null
          ? _instance.$__typename
          : ($__typename as String),
    ),
  );
}

class _CopyWithStubImpl$Mutation$updateGameSavePaths$updateGameSavePaths$savePaths<
  TRes
>
    implements
        CopyWith$Mutation$updateGameSavePaths$updateGameSavePaths$savePaths<
          TRes
        > {
  _CopyWithStubImpl$Mutation$updateGameSavePaths$updateGameSavePaths$savePaths(
    this._res,
  );

  TRes _res;

  call({String? path, String? os, String? $__typename}) => _res;
}

class Mutation$updateGameSavePaths$updateGameSavePaths$savePathOverride {
  Mutation$updateGameSavePaths$updateGameSavePaths$savePathOverride({
    required this.path,
    this.os,
    this.$__typename = 'GameSavePath',
  });

  factory Mutation$updateGameSavePaths$updateGameSavePaths$savePathOverride.fromJson(
    Map<String, dynamic> json,
  ) {
    final l$path = json['path'];
    final l$os = json['os'];
    final l$$__typename = json['__typename'];
    return Mutation$updateGameSavePaths$updateGameSavePaths$savePathOverride(
      path: (l$path as String),
      os: (l$os as String?),
      $__typename: (l$$__typename as String),
    );
  }

  final String path;

  final String? os;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$path = path;
    _resultData['path'] = l$path;
    final l$os = os;
    _resultData['os'] = l$os;
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$path = path;
    final l$os = os;
    final l$$__typename = $__typename;
    return Object.hashAll([l$path, l$os, l$$__typename]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other
            is! Mutation$updateGameSavePaths$updateGameSavePaths$savePathOverride ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$path = path;
    final lOther$path = other.path;
    if (l$path != lOther$path) {
      return false;
    }
    final l$os = os;
    final lOther$os = other.os;
    if (l$os != lOther$os) {
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

extension UtilityExtension$Mutation$updateGameSavePaths$updateGameSavePaths$savePathOverride
    on Mutation$updateGameSavePaths$updateGameSavePaths$savePathOverride {
  CopyWith$Mutation$updateGameSavePaths$updateGameSavePaths$savePathOverride<
    Mutation$updateGameSavePaths$updateGameSavePaths$savePathOverride
  >
  get copyWith =>
      CopyWith$Mutation$updateGameSavePaths$updateGameSavePaths$savePathOverride(
        this,
        (i) => i,
      );
}

abstract class CopyWith$Mutation$updateGameSavePaths$updateGameSavePaths$savePathOverride<
  TRes
> {
  factory CopyWith$Mutation$updateGameSavePaths$updateGameSavePaths$savePathOverride(
    Mutation$updateGameSavePaths$updateGameSavePaths$savePathOverride instance,
    TRes Function(
      Mutation$updateGameSavePaths$updateGameSavePaths$savePathOverride,
    )
    then,
  ) = _CopyWithImpl$Mutation$updateGameSavePaths$updateGameSavePaths$savePathOverride;

  factory CopyWith$Mutation$updateGameSavePaths$updateGameSavePaths$savePathOverride.stub(
    TRes res,
  ) = _CopyWithStubImpl$Mutation$updateGameSavePaths$updateGameSavePaths$savePathOverride;

  TRes call({String? path, String? os, String? $__typename});
}

class _CopyWithImpl$Mutation$updateGameSavePaths$updateGameSavePaths$savePathOverride<
  TRes
>
    implements
        CopyWith$Mutation$updateGameSavePaths$updateGameSavePaths$savePathOverride<
          TRes
        > {
  _CopyWithImpl$Mutation$updateGameSavePaths$updateGameSavePaths$savePathOverride(
    this._instance,
    this._then,
  );

  final Mutation$updateGameSavePaths$updateGameSavePaths$savePathOverride
  _instance;

  final TRes Function(
    Mutation$updateGameSavePaths$updateGameSavePaths$savePathOverride,
  )
  _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? path = _undefined,
    Object? os = _undefined,
    Object? $__typename = _undefined,
  }) => _then(
    Mutation$updateGameSavePaths$updateGameSavePaths$savePathOverride(
      path: path == _undefined || path == null
          ? _instance.path
          : (path as String),
      os: os == _undefined ? _instance.os : (os as String?),
      $__typename: $__typename == _undefined || $__typename == null
          ? _instance.$__typename
          : ($__typename as String),
    ),
  );
}

class _CopyWithStubImpl$Mutation$updateGameSavePaths$updateGameSavePaths$savePathOverride<
  TRes
>
    implements
        CopyWith$Mutation$updateGameSavePaths$updateGameSavePaths$savePathOverride<
          TRes
        > {
  _CopyWithStubImpl$Mutation$updateGameSavePaths$updateGameSavePaths$savePathOverride(
    this._res,
  );

  TRes _res;

  call({String? path, String? os, String? $__typename}) => _res;
}

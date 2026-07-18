import 'package:gql/ast.dart';

class Query$shareableUsers {
  Query$shareableUsers({
    required this.shareableUsers,
    this.$__typename = 'Query',
  });

  factory Query$shareableUsers.fromJson(Map<String, dynamic> json) {
    final l$shareableUsers = json['shareableUsers'];
    final l$$__typename = json['__typename'];
    return Query$shareableUsers(
      shareableUsers: (l$shareableUsers as List<dynamic>)
          .map(
            (e) => Query$shareableUsers$shareableUsers.fromJson(
              (e as Map<String, dynamic>),
            ),
          )
          .toList(),
      $__typename: (l$$__typename as String),
    );
  }

  final List<Query$shareableUsers$shareableUsers> shareableUsers;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$shareableUsers = shareableUsers;
    _resultData['shareableUsers'] = l$shareableUsers
        .map((e) => e.toJson())
        .toList();
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$shareableUsers = shareableUsers;
    final l$$__typename = $__typename;
    return Object.hashAll([
      Object.hashAll(l$shareableUsers.map((v) => v)),
      l$$__typename,
    ]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Query$shareableUsers || runtimeType != other.runtimeType) {
      return false;
    }
    final l$shareableUsers = shareableUsers;
    final lOther$shareableUsers = other.shareableUsers;
    if (l$shareableUsers.length != lOther$shareableUsers.length) {
      return false;
    }
    for (int i = 0; i < l$shareableUsers.length; i++) {
      final l$shareableUsers$entry = l$shareableUsers[i];
      final lOther$shareableUsers$entry = lOther$shareableUsers[i];
      if (l$shareableUsers$entry != lOther$shareableUsers$entry) {
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

extension UtilityExtension$Query$shareableUsers on Query$shareableUsers {
  CopyWith$Query$shareableUsers<Query$shareableUsers> get copyWith =>
      CopyWith$Query$shareableUsers(this, (i) => i);
}

abstract class CopyWith$Query$shareableUsers<TRes> {
  factory CopyWith$Query$shareableUsers(
    Query$shareableUsers instance,
    TRes Function(Query$shareableUsers) then,
  ) = _CopyWithImpl$Query$shareableUsers;

  factory CopyWith$Query$shareableUsers.stub(TRes res) =
      _CopyWithStubImpl$Query$shareableUsers;

  TRes call({
    List<Query$shareableUsers$shareableUsers>? shareableUsers,
    String? $__typename,
  });
  TRes shareableUsers(
    Iterable<Query$shareableUsers$shareableUsers> Function(
      Iterable<
        CopyWith$Query$shareableUsers$shareableUsers<
          Query$shareableUsers$shareableUsers
        >
      >,
    )
    _fn,
  );
}

class _CopyWithImpl$Query$shareableUsers<TRes>
    implements CopyWith$Query$shareableUsers<TRes> {
  _CopyWithImpl$Query$shareableUsers(this._instance, this._then);

  final Query$shareableUsers _instance;

  final TRes Function(Query$shareableUsers) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? shareableUsers = _undefined,
    Object? $__typename = _undefined,
  }) => _then(
    Query$shareableUsers(
      shareableUsers: shareableUsers == _undefined || shareableUsers == null
          ? _instance.shareableUsers
          : (shareableUsers as List<Query$shareableUsers$shareableUsers>),
      $__typename: $__typename == _undefined || $__typename == null
          ? _instance.$__typename
          : ($__typename as String),
    ),
  );

  TRes shareableUsers(
    Iterable<Query$shareableUsers$shareableUsers> Function(
      Iterable<
        CopyWith$Query$shareableUsers$shareableUsers<
          Query$shareableUsers$shareableUsers
        >
      >,
    )
    _fn,
  ) => call(
    shareableUsers: _fn(
      _instance.shareableUsers.map(
        (e) => CopyWith$Query$shareableUsers$shareableUsers(e, (i) => i),
      ),
    ).toList(),
  );
}

class _CopyWithStubImpl$Query$shareableUsers<TRes>
    implements CopyWith$Query$shareableUsers<TRes> {
  _CopyWithStubImpl$Query$shareableUsers(this._res);

  TRes _res;

  call({
    List<Query$shareableUsers$shareableUsers>? shareableUsers,
    String? $__typename,
  }) => _res;

  shareableUsers(_fn) => _res;
}

const documentNodeQueryshareableUsers = DocumentNode(
  definitions: [
    OperationDefinitionNode(
      type: OperationType.query,
      name: NameNode(value: 'shareableUsers'),
      variableDefinitions: [],
      directives: [],
      selectionSet: SelectionSetNode(
        selections: [
          FieldNode(
            name: NameNode(value: 'shareableUsers'),
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

class Query$shareableUsers$shareableUsers {
  Query$shareableUsers$shareableUsers({
    required this.id,
    this.name,
    this.$__typename = 'ShareableUser',
  });

  factory Query$shareableUsers$shareableUsers.fromJson(
    Map<String, dynamic> json,
  ) {
    final l$id = json['id'];
    final l$name = json['name'];
    final l$$__typename = json['__typename'];
    return Query$shareableUsers$shareableUsers(
      id: (l$id as String),
      name: (l$name as String?),
      $__typename: (l$$__typename as String),
    );
  }

  final String id;

  final String? name;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$id = id;
    _resultData['id'] = l$id;
    final l$name = name;
    _resultData['name'] = l$name;
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$id = id;
    final l$name = name;
    final l$$__typename = $__typename;
    return Object.hashAll([l$id, l$name, l$$__typename]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Query$shareableUsers$shareableUsers ||
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
    final l$$__typename = $__typename;
    final lOther$$__typename = other.$__typename;
    if (l$$__typename != lOther$$__typename) {
      return false;
    }
    return true;
  }
}

extension UtilityExtension$Query$shareableUsers$shareableUsers
    on Query$shareableUsers$shareableUsers {
  CopyWith$Query$shareableUsers$shareableUsers<
    Query$shareableUsers$shareableUsers
  >
  get copyWith => CopyWith$Query$shareableUsers$shareableUsers(this, (i) => i);
}

abstract class CopyWith$Query$shareableUsers$shareableUsers<TRes> {
  factory CopyWith$Query$shareableUsers$shareableUsers(
    Query$shareableUsers$shareableUsers instance,
    TRes Function(Query$shareableUsers$shareableUsers) then,
  ) = _CopyWithImpl$Query$shareableUsers$shareableUsers;

  factory CopyWith$Query$shareableUsers$shareableUsers.stub(TRes res) =
      _CopyWithStubImpl$Query$shareableUsers$shareableUsers;

  TRes call({String? id, String? name, String? $__typename});
}

class _CopyWithImpl$Query$shareableUsers$shareableUsers<TRes>
    implements CopyWith$Query$shareableUsers$shareableUsers<TRes> {
  _CopyWithImpl$Query$shareableUsers$shareableUsers(this._instance, this._then);

  final Query$shareableUsers$shareableUsers _instance;

  final TRes Function(Query$shareableUsers$shareableUsers) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? id = _undefined,
    Object? name = _undefined,
    Object? $__typename = _undefined,
  }) => _then(
    Query$shareableUsers$shareableUsers(
      id: id == _undefined || id == null ? _instance.id : (id as String),
      name: name == _undefined ? _instance.name : (name as String?),
      $__typename: $__typename == _undefined || $__typename == null
          ? _instance.$__typename
          : ($__typename as String),
    ),
  );
}

class _CopyWithStubImpl$Query$shareableUsers$shareableUsers<TRes>
    implements CopyWith$Query$shareableUsers$shareableUsers<TRes> {
  _CopyWithStubImpl$Query$shareableUsers$shareableUsers(this._res);

  TRes _res;

  call({String? id, String? name, String? $__typename}) => _res;
}

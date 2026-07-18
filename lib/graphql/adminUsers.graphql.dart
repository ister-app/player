import 'package:gql/ast.dart';
import 'schema.graphql.dart';

class Query$adminUsers {
  Query$adminUsers({required this.users, this.$__typename = 'Query'});

  factory Query$adminUsers.fromJson(Map<String, dynamic> json) {
    final l$users = json['users'];
    final l$$__typename = json['__typename'];
    return Query$adminUsers(
      users: (l$users as List<dynamic>)
          .map(
            (e) => Query$adminUsers$users.fromJson((e as Map<String, dynamic>)),
          )
          .toList(),
      $__typename: (l$$__typename as String),
    );
  }

  final List<Query$adminUsers$users> users;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$users = users;
    _resultData['users'] = l$users.map((e) => e.toJson()).toList();
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$users = users;
    final l$$__typename = $__typename;
    return Object.hashAll([
      Object.hashAll(l$users.map((v) => v)),
      l$$__typename,
    ]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Query$adminUsers || runtimeType != other.runtimeType) {
      return false;
    }
    final l$users = users;
    final lOther$users = other.users;
    if (l$users.length != lOther$users.length) {
      return false;
    }
    for (int i = 0; i < l$users.length; i++) {
      final l$users$entry = l$users[i];
      final lOther$users$entry = lOther$users[i];
      if (l$users$entry != lOther$users$entry) {
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

extension UtilityExtension$Query$adminUsers on Query$adminUsers {
  CopyWith$Query$adminUsers<Query$adminUsers> get copyWith =>
      CopyWith$Query$adminUsers(this, (i) => i);
}

abstract class CopyWith$Query$adminUsers<TRes> {
  factory CopyWith$Query$adminUsers(
    Query$adminUsers instance,
    TRes Function(Query$adminUsers) then,
  ) = _CopyWithImpl$Query$adminUsers;

  factory CopyWith$Query$adminUsers.stub(TRes res) =
      _CopyWithStubImpl$Query$adminUsers;

  TRes call({List<Query$adminUsers$users>? users, String? $__typename});
  TRes users(
    Iterable<Query$adminUsers$users> Function(
      Iterable<CopyWith$Query$adminUsers$users<Query$adminUsers$users>>,
    )
    _fn,
  );
}

class _CopyWithImpl$Query$adminUsers<TRes>
    implements CopyWith$Query$adminUsers<TRes> {
  _CopyWithImpl$Query$adminUsers(this._instance, this._then);

  final Query$adminUsers _instance;

  final TRes Function(Query$adminUsers) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({Object? users = _undefined, Object? $__typename = _undefined}) =>
      _then(
        Query$adminUsers(
          users: users == _undefined || users == null
              ? _instance.users
              : (users as List<Query$adminUsers$users>),
          $__typename: $__typename == _undefined || $__typename == null
              ? _instance.$__typename
              : ($__typename as String),
        ),
      );

  TRes users(
    Iterable<Query$adminUsers$users> Function(
      Iterable<CopyWith$Query$adminUsers$users<Query$adminUsers$users>>,
    )
    _fn,
  ) => call(
    users: _fn(
      _instance.users.map((e) => CopyWith$Query$adminUsers$users(e, (i) => i)),
    ).toList(),
  );
}

class _CopyWithStubImpl$Query$adminUsers<TRes>
    implements CopyWith$Query$adminUsers<TRes> {
  _CopyWithStubImpl$Query$adminUsers(this._res);

  TRes _res;

  call({List<Query$adminUsers$users>? users, String? $__typename}) => _res;

  users(_fn) => _res;
}

const documentNodeQueryadminUsers = DocumentNode(
  definitions: [
    OperationDefinitionNode(
      type: OperationType.query,
      name: NameNode(value: 'adminUsers'),
      variableDefinitions: [],
      directives: [],
      selectionSet: SelectionSetNode(
        selections: [
          FieldNode(
            name: NameNode(value: 'users'),
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
                  name: NameNode(value: 'email'),
                  alias: null,
                  arguments: [],
                  directives: [],
                  selectionSet: null,
                ),
                FieldNode(
                  name: NameNode(value: 'isAdmin'),
                  alias: null,
                  arguments: [],
                  directives: [],
                  selectionSet: null,
                ),
                FieldNode(
                  name: NameNode(value: 'grantedLibraries'),
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
                        name: NameNode(value: 'type'),
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

class Query$adminUsers$users {
  Query$adminUsers$users({
    required this.id,
    this.name,
    this.email,
    required this.isAdmin,
    required this.grantedLibraries,
    this.$__typename = 'User',
  });

  factory Query$adminUsers$users.fromJson(Map<String, dynamic> json) {
    final l$id = json['id'];
    final l$name = json['name'];
    final l$email = json['email'];
    final l$isAdmin = json['isAdmin'];
    final l$grantedLibraries = json['grantedLibraries'];
    final l$$__typename = json['__typename'];
    return Query$adminUsers$users(
      id: (l$id as String),
      name: (l$name as String?),
      email: (l$email as String?),
      isAdmin: (l$isAdmin as bool),
      grantedLibraries: (l$grantedLibraries as List<dynamic>)
          .map(
            (e) => Query$adminUsers$users$grantedLibraries.fromJson(
              (e as Map<String, dynamic>),
            ),
          )
          .toList(),
      $__typename: (l$$__typename as String),
    );
  }

  final String id;

  final String? name;

  final String? email;

  final bool isAdmin;

  final List<Query$adminUsers$users$grantedLibraries> grantedLibraries;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$id = id;
    _resultData['id'] = l$id;
    final l$name = name;
    _resultData['name'] = l$name;
    final l$email = email;
    _resultData['email'] = l$email;
    final l$isAdmin = isAdmin;
    _resultData['isAdmin'] = l$isAdmin;
    final l$grantedLibraries = grantedLibraries;
    _resultData['grantedLibraries'] = l$grantedLibraries
        .map((e) => e.toJson())
        .toList();
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$id = id;
    final l$name = name;
    final l$email = email;
    final l$isAdmin = isAdmin;
    final l$grantedLibraries = grantedLibraries;
    final l$$__typename = $__typename;
    return Object.hashAll([
      l$id,
      l$name,
      l$email,
      l$isAdmin,
      Object.hashAll(l$grantedLibraries.map((v) => v)),
      l$$__typename,
    ]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Query$adminUsers$users || runtimeType != other.runtimeType) {
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
    final l$email = email;
    final lOther$email = other.email;
    if (l$email != lOther$email) {
      return false;
    }
    final l$isAdmin = isAdmin;
    final lOther$isAdmin = other.isAdmin;
    if (l$isAdmin != lOther$isAdmin) {
      return false;
    }
    final l$grantedLibraries = grantedLibraries;
    final lOther$grantedLibraries = other.grantedLibraries;
    if (l$grantedLibraries.length != lOther$grantedLibraries.length) {
      return false;
    }
    for (int i = 0; i < l$grantedLibraries.length; i++) {
      final l$grantedLibraries$entry = l$grantedLibraries[i];
      final lOther$grantedLibraries$entry = lOther$grantedLibraries[i];
      if (l$grantedLibraries$entry != lOther$grantedLibraries$entry) {
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

extension UtilityExtension$Query$adminUsers$users on Query$adminUsers$users {
  CopyWith$Query$adminUsers$users<Query$adminUsers$users> get copyWith =>
      CopyWith$Query$adminUsers$users(this, (i) => i);
}

abstract class CopyWith$Query$adminUsers$users<TRes> {
  factory CopyWith$Query$adminUsers$users(
    Query$adminUsers$users instance,
    TRes Function(Query$adminUsers$users) then,
  ) = _CopyWithImpl$Query$adminUsers$users;

  factory CopyWith$Query$adminUsers$users.stub(TRes res) =
      _CopyWithStubImpl$Query$adminUsers$users;

  TRes call({
    String? id,
    String? name,
    String? email,
    bool? isAdmin,
    List<Query$adminUsers$users$grantedLibraries>? grantedLibraries,
    String? $__typename,
  });
  TRes grantedLibraries(
    Iterable<Query$adminUsers$users$grantedLibraries> Function(
      Iterable<
        CopyWith$Query$adminUsers$users$grantedLibraries<
          Query$adminUsers$users$grantedLibraries
        >
      >,
    )
    _fn,
  );
}

class _CopyWithImpl$Query$adminUsers$users<TRes>
    implements CopyWith$Query$adminUsers$users<TRes> {
  _CopyWithImpl$Query$adminUsers$users(this._instance, this._then);

  final Query$adminUsers$users _instance;

  final TRes Function(Query$adminUsers$users) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? id = _undefined,
    Object? name = _undefined,
    Object? email = _undefined,
    Object? isAdmin = _undefined,
    Object? grantedLibraries = _undefined,
    Object? $__typename = _undefined,
  }) => _then(
    Query$adminUsers$users(
      id: id == _undefined || id == null ? _instance.id : (id as String),
      name: name == _undefined ? _instance.name : (name as String?),
      email: email == _undefined ? _instance.email : (email as String?),
      isAdmin: isAdmin == _undefined || isAdmin == null
          ? _instance.isAdmin
          : (isAdmin as bool),
      grantedLibraries:
          grantedLibraries == _undefined || grantedLibraries == null
          ? _instance.grantedLibraries
          : (grantedLibraries as List<Query$adminUsers$users$grantedLibraries>),
      $__typename: $__typename == _undefined || $__typename == null
          ? _instance.$__typename
          : ($__typename as String),
    ),
  );

  TRes grantedLibraries(
    Iterable<Query$adminUsers$users$grantedLibraries> Function(
      Iterable<
        CopyWith$Query$adminUsers$users$grantedLibraries<
          Query$adminUsers$users$grantedLibraries
        >
      >,
    )
    _fn,
  ) => call(
    grantedLibraries: _fn(
      _instance.grantedLibraries.map(
        (e) => CopyWith$Query$adminUsers$users$grantedLibraries(e, (i) => i),
      ),
    ).toList(),
  );
}

class _CopyWithStubImpl$Query$adminUsers$users<TRes>
    implements CopyWith$Query$adminUsers$users<TRes> {
  _CopyWithStubImpl$Query$adminUsers$users(this._res);

  TRes _res;

  call({
    String? id,
    String? name,
    String? email,
    bool? isAdmin,
    List<Query$adminUsers$users$grantedLibraries>? grantedLibraries,
    String? $__typename,
  }) => _res;

  grantedLibraries(_fn) => _res;
}

class Query$adminUsers$users$grantedLibraries {
  Query$adminUsers$users$grantedLibraries({
    required this.id,
    required this.name,
    required this.type,
    this.$__typename = 'Library',
  });

  factory Query$adminUsers$users$grantedLibraries.fromJson(
    Map<String, dynamic> json,
  ) {
    final l$id = json['id'];
    final l$name = json['name'];
    final l$type = json['type'];
    final l$$__typename = json['__typename'];
    return Query$adminUsers$users$grantedLibraries(
      id: (l$id as String),
      name: (l$name as String),
      type: fromJson$Enum$LibraryType((l$type as String)),
      $__typename: (l$$__typename as String),
    );
  }

  final String id;

  final String name;

  final Enum$LibraryType type;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$id = id;
    _resultData['id'] = l$id;
    final l$name = name;
    _resultData['name'] = l$name;
    final l$type = type;
    _resultData['type'] = toJson$Enum$LibraryType(l$type);
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$id = id;
    final l$name = name;
    final l$type = type;
    final l$$__typename = $__typename;
    return Object.hashAll([l$id, l$name, l$type, l$$__typename]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Query$adminUsers$users$grantedLibraries ||
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
    final l$type = type;
    final lOther$type = other.type;
    if (l$type != lOther$type) {
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

extension UtilityExtension$Query$adminUsers$users$grantedLibraries
    on Query$adminUsers$users$grantedLibraries {
  CopyWith$Query$adminUsers$users$grantedLibraries<
    Query$adminUsers$users$grantedLibraries
  >
  get copyWith =>
      CopyWith$Query$adminUsers$users$grantedLibraries(this, (i) => i);
}

abstract class CopyWith$Query$adminUsers$users$grantedLibraries<TRes> {
  factory CopyWith$Query$adminUsers$users$grantedLibraries(
    Query$adminUsers$users$grantedLibraries instance,
    TRes Function(Query$adminUsers$users$grantedLibraries) then,
  ) = _CopyWithImpl$Query$adminUsers$users$grantedLibraries;

  factory CopyWith$Query$adminUsers$users$grantedLibraries.stub(TRes res) =
      _CopyWithStubImpl$Query$adminUsers$users$grantedLibraries;

  TRes call({
    String? id,
    String? name,
    Enum$LibraryType? type,
    String? $__typename,
  });
}

class _CopyWithImpl$Query$adminUsers$users$grantedLibraries<TRes>
    implements CopyWith$Query$adminUsers$users$grantedLibraries<TRes> {
  _CopyWithImpl$Query$adminUsers$users$grantedLibraries(
    this._instance,
    this._then,
  );

  final Query$adminUsers$users$grantedLibraries _instance;

  final TRes Function(Query$adminUsers$users$grantedLibraries) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? id = _undefined,
    Object? name = _undefined,
    Object? type = _undefined,
    Object? $__typename = _undefined,
  }) => _then(
    Query$adminUsers$users$grantedLibraries(
      id: id == _undefined || id == null ? _instance.id : (id as String),
      name: name == _undefined || name == null
          ? _instance.name
          : (name as String),
      type: type == _undefined || type == null
          ? _instance.type
          : (type as Enum$LibraryType),
      $__typename: $__typename == _undefined || $__typename == null
          ? _instance.$__typename
          : ($__typename as String),
    ),
  );
}

class _CopyWithStubImpl$Query$adminUsers$users$grantedLibraries<TRes>
    implements CopyWith$Query$adminUsers$users$grantedLibraries<TRes> {
  _CopyWithStubImpl$Query$adminUsers$users$grantedLibraries(this._res);

  TRes _res;

  call({
    String? id,
    String? name,
    Enum$LibraryType? type,
    String? $__typename,
  }) => _res;
}

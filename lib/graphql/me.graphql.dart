import 'package:gql/ast.dart';

class Query$me {
  Query$me({required this.me, this.$__typename = 'Query'});

  factory Query$me.fromJson(Map<String, dynamic> json) {
    final l$me = json['me'];
    final l$$__typename = json['__typename'];
    return Query$me(
      me: Query$me$me.fromJson((l$me as Map<String, dynamic>)),
      $__typename: (l$$__typename as String),
    );
  }

  final Query$me$me me;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$me = me;
    _resultData['me'] = l$me.toJson();
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$me = me;
    final l$$__typename = $__typename;
    return Object.hashAll([l$me, l$$__typename]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Query$me || runtimeType != other.runtimeType) {
      return false;
    }
    final l$me = me;
    final lOther$me = other.me;
    if (l$me != lOther$me) {
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

extension UtilityExtension$Query$me on Query$me {
  CopyWith$Query$me<Query$me> get copyWith => CopyWith$Query$me(this, (i) => i);
}

abstract class CopyWith$Query$me<TRes> {
  factory CopyWith$Query$me(Query$me instance, TRes Function(Query$me) then) =
      _CopyWithImpl$Query$me;

  factory CopyWith$Query$me.stub(TRes res) = _CopyWithStubImpl$Query$me;

  TRes call({Query$me$me? me, String? $__typename});
  CopyWith$Query$me$me<TRes> get me;
}

class _CopyWithImpl$Query$me<TRes> implements CopyWith$Query$me<TRes> {
  _CopyWithImpl$Query$me(this._instance, this._then);

  final Query$me _instance;

  final TRes Function(Query$me) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({Object? me = _undefined, Object? $__typename = _undefined}) =>
      _then(
        Query$me(
          me: me == _undefined || me == null
              ? _instance.me
              : (me as Query$me$me),
          $__typename: $__typename == _undefined || $__typename == null
              ? _instance.$__typename
              : ($__typename as String),
        ),
      );

  CopyWith$Query$me$me<TRes> get me {
    final local$me = _instance.me;
    return CopyWith$Query$me$me(local$me, (e) => call(me: e));
  }
}

class _CopyWithStubImpl$Query$me<TRes> implements CopyWith$Query$me<TRes> {
  _CopyWithStubImpl$Query$me(this._res);

  TRes _res;

  call({Query$me$me? me, String? $__typename}) => _res;

  CopyWith$Query$me$me<TRes> get me => CopyWith$Query$me$me.stub(_res);
}

const documentNodeQueryme = DocumentNode(
  definitions: [
    OperationDefinitionNode(
      type: OperationType.query,
      name: NameNode(value: 'me'),
      variableDefinitions: [],
      directives: [],
      selectionSet: SelectionSetNode(
        selections: [
          FieldNode(
            name: NameNode(value: 'me'),
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

class Query$me$me {
  Query$me$me({
    required this.id,
    this.name,
    this.email,
    required this.isAdmin,
    this.$__typename = 'Me',
  });

  factory Query$me$me.fromJson(Map<String, dynamic> json) {
    final l$id = json['id'];
    final l$name = json['name'];
    final l$email = json['email'];
    final l$isAdmin = json['isAdmin'];
    final l$$__typename = json['__typename'];
    return Query$me$me(
      id: (l$id as String),
      name: (l$name as String?),
      email: (l$email as String?),
      isAdmin: (l$isAdmin as bool),
      $__typename: (l$$__typename as String),
    );
  }

  final String id;

  final String? name;

  final String? email;

  final bool isAdmin;

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
    final l$$__typename = $__typename;
    return Object.hashAll([l$id, l$name, l$email, l$isAdmin, l$$__typename]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Query$me$me || runtimeType != other.runtimeType) {
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
    final l$$__typename = $__typename;
    final lOther$$__typename = other.$__typename;
    if (l$$__typename != lOther$$__typename) {
      return false;
    }
    return true;
  }
}

extension UtilityExtension$Query$me$me on Query$me$me {
  CopyWith$Query$me$me<Query$me$me> get copyWith =>
      CopyWith$Query$me$me(this, (i) => i);
}

abstract class CopyWith$Query$me$me<TRes> {
  factory CopyWith$Query$me$me(
    Query$me$me instance,
    TRes Function(Query$me$me) then,
  ) = _CopyWithImpl$Query$me$me;

  factory CopyWith$Query$me$me.stub(TRes res) = _CopyWithStubImpl$Query$me$me;

  TRes call({
    String? id,
    String? name,
    String? email,
    bool? isAdmin,
    String? $__typename,
  });
}

class _CopyWithImpl$Query$me$me<TRes> implements CopyWith$Query$me$me<TRes> {
  _CopyWithImpl$Query$me$me(this._instance, this._then);

  final Query$me$me _instance;

  final TRes Function(Query$me$me) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? id = _undefined,
    Object? name = _undefined,
    Object? email = _undefined,
    Object? isAdmin = _undefined,
    Object? $__typename = _undefined,
  }) => _then(
    Query$me$me(
      id: id == _undefined || id == null ? _instance.id : (id as String),
      name: name == _undefined ? _instance.name : (name as String?),
      email: email == _undefined ? _instance.email : (email as String?),
      isAdmin: isAdmin == _undefined || isAdmin == null
          ? _instance.isAdmin
          : (isAdmin as bool),
      $__typename: $__typename == _undefined || $__typename == null
          ? _instance.$__typename
          : ($__typename as String),
    ),
  );
}

class _CopyWithStubImpl$Query$me$me<TRes>
    implements CopyWith$Query$me$me<TRes> {
  _CopyWithStubImpl$Query$me$me(this._res);

  TRes _res;

  call({
    String? id,
    String? name,
    String? email,
    bool? isAdmin,
    String? $__typename,
  }) => _res;
}

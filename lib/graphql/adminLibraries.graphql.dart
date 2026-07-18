import 'package:gql/ast.dart';
import 'schema.graphql.dart';

class Query$adminLibraries {
  Query$adminLibraries({this.libraries, this.$__typename = 'Query'});

  factory Query$adminLibraries.fromJson(Map<String, dynamic> json) {
    final l$libraries = json['libraries'];
    final l$$__typename = json['__typename'];
    return Query$adminLibraries(
      libraries: (l$libraries as List<dynamic>?)
          ?.map(
            (e) => Query$adminLibraries$libraries.fromJson(
              (e as Map<String, dynamic>),
            ),
          )
          .toList(),
      $__typename: (l$$__typename as String),
    );
  }

  final List<Query$adminLibraries$libraries>? libraries;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$libraries = libraries;
    _resultData['libraries'] = l$libraries?.map((e) => e.toJson()).toList();
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$libraries = libraries;
    final l$$__typename = $__typename;
    return Object.hashAll([
      l$libraries == null ? null : Object.hashAll(l$libraries.map((v) => v)),
      l$$__typename,
    ]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Query$adminLibraries || runtimeType != other.runtimeType) {
      return false;
    }
    final l$libraries = libraries;
    final lOther$libraries = other.libraries;
    if (l$libraries != null && lOther$libraries != null) {
      if (l$libraries.length != lOther$libraries.length) {
        return false;
      }
      for (int i = 0; i < l$libraries.length; i++) {
        final l$libraries$entry = l$libraries[i];
        final lOther$libraries$entry = lOther$libraries[i];
        if (l$libraries$entry != lOther$libraries$entry) {
          return false;
        }
      }
    } else if (l$libraries != lOther$libraries) {
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

extension UtilityExtension$Query$adminLibraries on Query$adminLibraries {
  CopyWith$Query$adminLibraries<Query$adminLibraries> get copyWith =>
      CopyWith$Query$adminLibraries(this, (i) => i);
}

abstract class CopyWith$Query$adminLibraries<TRes> {
  factory CopyWith$Query$adminLibraries(
    Query$adminLibraries instance,
    TRes Function(Query$adminLibraries) then,
  ) = _CopyWithImpl$Query$adminLibraries;

  factory CopyWith$Query$adminLibraries.stub(TRes res) =
      _CopyWithStubImpl$Query$adminLibraries;

  TRes call({
    List<Query$adminLibraries$libraries>? libraries,
    String? $__typename,
  });
  TRes libraries(
    Iterable<Query$adminLibraries$libraries>? Function(
      Iterable<
        CopyWith$Query$adminLibraries$libraries<Query$adminLibraries$libraries>
      >?,
    )
    _fn,
  );
}

class _CopyWithImpl$Query$adminLibraries<TRes>
    implements CopyWith$Query$adminLibraries<TRes> {
  _CopyWithImpl$Query$adminLibraries(this._instance, this._then);

  final Query$adminLibraries _instance;

  final TRes Function(Query$adminLibraries) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? libraries = _undefined,
    Object? $__typename = _undefined,
  }) => _then(
    Query$adminLibraries(
      libraries: libraries == _undefined
          ? _instance.libraries
          : (libraries as List<Query$adminLibraries$libraries>?),
      $__typename: $__typename == _undefined || $__typename == null
          ? _instance.$__typename
          : ($__typename as String),
    ),
  );

  TRes libraries(
    Iterable<Query$adminLibraries$libraries>? Function(
      Iterable<
        CopyWith$Query$adminLibraries$libraries<Query$adminLibraries$libraries>
      >?,
    )
    _fn,
  ) => call(
    libraries: _fn(
      _instance.libraries?.map(
        (e) => CopyWith$Query$adminLibraries$libraries(e, (i) => i),
      ),
    )?.toList(),
  );
}

class _CopyWithStubImpl$Query$adminLibraries<TRes>
    implements CopyWith$Query$adminLibraries<TRes> {
  _CopyWithStubImpl$Query$adminLibraries(this._res);

  TRes _res;

  call({
    List<Query$adminLibraries$libraries>? libraries,
    String? $__typename,
  }) => _res;

  libraries(_fn) => _res;
}

const documentNodeQueryadminLibraries = DocumentNode(
  definitions: [
    OperationDefinitionNode(
      type: OperationType.query,
      name: NameNode(value: 'adminLibraries'),
      variableDefinitions: [],
      directives: [],
      selectionSet: SelectionSetNode(
        selections: [
          FieldNode(
            name: NameNode(value: 'libraries'),
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
                  name: NameNode(value: 'visibleToAll'),
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

class Query$adminLibraries$libraries {
  Query$adminLibraries$libraries({
    required this.id,
    required this.name,
    required this.type,
    required this.visibleToAll,
    this.$__typename = 'Library',
  });

  factory Query$adminLibraries$libraries.fromJson(Map<String, dynamic> json) {
    final l$id = json['id'];
    final l$name = json['name'];
    final l$type = json['type'];
    final l$visibleToAll = json['visibleToAll'];
    final l$$__typename = json['__typename'];
    return Query$adminLibraries$libraries(
      id: (l$id as String),
      name: (l$name as String),
      type: fromJson$Enum$LibraryType((l$type as String)),
      visibleToAll: (l$visibleToAll as bool),
      $__typename: (l$$__typename as String),
    );
  }

  final String id;

  final String name;

  final Enum$LibraryType type;

  final bool visibleToAll;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$id = id;
    _resultData['id'] = l$id;
    final l$name = name;
    _resultData['name'] = l$name;
    final l$type = type;
    _resultData['type'] = toJson$Enum$LibraryType(l$type);
    final l$visibleToAll = visibleToAll;
    _resultData['visibleToAll'] = l$visibleToAll;
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$id = id;
    final l$name = name;
    final l$type = type;
    final l$visibleToAll = visibleToAll;
    final l$$__typename = $__typename;
    return Object.hashAll([
      l$id,
      l$name,
      l$type,
      l$visibleToAll,
      l$$__typename,
    ]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Query$adminLibraries$libraries ||
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
    final l$visibleToAll = visibleToAll;
    final lOther$visibleToAll = other.visibleToAll;
    if (l$visibleToAll != lOther$visibleToAll) {
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

extension UtilityExtension$Query$adminLibraries$libraries
    on Query$adminLibraries$libraries {
  CopyWith$Query$adminLibraries$libraries<Query$adminLibraries$libraries>
  get copyWith => CopyWith$Query$adminLibraries$libraries(this, (i) => i);
}

abstract class CopyWith$Query$adminLibraries$libraries<TRes> {
  factory CopyWith$Query$adminLibraries$libraries(
    Query$adminLibraries$libraries instance,
    TRes Function(Query$adminLibraries$libraries) then,
  ) = _CopyWithImpl$Query$adminLibraries$libraries;

  factory CopyWith$Query$adminLibraries$libraries.stub(TRes res) =
      _CopyWithStubImpl$Query$adminLibraries$libraries;

  TRes call({
    String? id,
    String? name,
    Enum$LibraryType? type,
    bool? visibleToAll,
    String? $__typename,
  });
}

class _CopyWithImpl$Query$adminLibraries$libraries<TRes>
    implements CopyWith$Query$adminLibraries$libraries<TRes> {
  _CopyWithImpl$Query$adminLibraries$libraries(this._instance, this._then);

  final Query$adminLibraries$libraries _instance;

  final TRes Function(Query$adminLibraries$libraries) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? id = _undefined,
    Object? name = _undefined,
    Object? type = _undefined,
    Object? visibleToAll = _undefined,
    Object? $__typename = _undefined,
  }) => _then(
    Query$adminLibraries$libraries(
      id: id == _undefined || id == null ? _instance.id : (id as String),
      name: name == _undefined || name == null
          ? _instance.name
          : (name as String),
      type: type == _undefined || type == null
          ? _instance.type
          : (type as Enum$LibraryType),
      visibleToAll: visibleToAll == _undefined || visibleToAll == null
          ? _instance.visibleToAll
          : (visibleToAll as bool),
      $__typename: $__typename == _undefined || $__typename == null
          ? _instance.$__typename
          : ($__typename as String),
    ),
  );
}

class _CopyWithStubImpl$Query$adminLibraries$libraries<TRes>
    implements CopyWith$Query$adminLibraries$libraries<TRes> {
  _CopyWithStubImpl$Query$adminLibraries$libraries(this._res);

  TRes _res;

  call({
    String? id,
    String? name,
    Enum$LibraryType? type,
    bool? visibleToAll,
    String? $__typename,
  }) => _res;
}

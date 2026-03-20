import 'package:gql/ast.dart';
import 'schema.graphql.dart';

class Query$libraries {
  Query$libraries({this.libraries, this.$__typename = 'Query'});

  factory Query$libraries.fromJson(Map<String, dynamic> json) {
    final l$libraries = json['libraries'];
    final l$$__typename = json['__typename'];
    return Query$libraries(
      libraries: (l$libraries as List<dynamic>?)
          ?.map(
            (e) =>
                Query$libraries$libraries.fromJson((e as Map<String, dynamic>)),
          )
          .toList(),
      $__typename: (l$$__typename as String),
    );
  }

  final List<Query$libraries$libraries>? libraries;

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
    if (other is! Query$libraries || runtimeType != other.runtimeType) {
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

extension UtilityExtension$Query$libraries on Query$libraries {
  CopyWith$Query$libraries<Query$libraries> get copyWith =>
      CopyWith$Query$libraries(this, (i) => i);
}

abstract class CopyWith$Query$libraries<TRes> {
  factory CopyWith$Query$libraries(
    Query$libraries instance,
    TRes Function(Query$libraries) then,
  ) = _CopyWithImpl$Query$libraries;

  factory CopyWith$Query$libraries.stub(TRes res) =
      _CopyWithStubImpl$Query$libraries;

  TRes call({List<Query$libraries$libraries>? libraries, String? $__typename});
  TRes libraries(
    Iterable<Query$libraries$libraries>? Function(
      Iterable<CopyWith$Query$libraries$libraries<Query$libraries$libraries>>?,
    )
    _fn,
  );
}

class _CopyWithImpl$Query$libraries<TRes>
    implements CopyWith$Query$libraries<TRes> {
  _CopyWithImpl$Query$libraries(this._instance, this._then);

  final Query$libraries _instance;

  final TRes Function(Query$libraries) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? libraries = _undefined,
    Object? $__typename = _undefined,
  }) => _then(
    Query$libraries(
      libraries: libraries == _undefined
          ? _instance.libraries
          : (libraries as List<Query$libraries$libraries>?),
      $__typename: $__typename == _undefined || $__typename == null
          ? _instance.$__typename
          : ($__typename as String),
    ),
  );

  TRes libraries(
    Iterable<Query$libraries$libraries>? Function(
      Iterable<CopyWith$Query$libraries$libraries<Query$libraries$libraries>>?,
    )
    _fn,
  ) => call(
    libraries: _fn(
      _instance.libraries?.map(
        (e) => CopyWith$Query$libraries$libraries(e, (i) => i),
      ),
    )?.toList(),
  );
}

class _CopyWithStubImpl$Query$libraries<TRes>
    implements CopyWith$Query$libraries<TRes> {
  _CopyWithStubImpl$Query$libraries(this._res);

  TRes _res;

  call({List<Query$libraries$libraries>? libraries, String? $__typename}) =>
      _res;

  libraries(_fn) => _res;
}

const documentNodeQuerylibraries = DocumentNode(
  definitions: [
    OperationDefinitionNode(
      type: OperationType.query,
      name: NameNode(value: 'libraries'),
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

class Query$libraries$libraries {
  Query$libraries$libraries({
    required this.id,
    required this.name,
    required this.type,
    this.$__typename = 'Library',
  });

  factory Query$libraries$libraries.fromJson(Map<String, dynamic> json) {
    final l$id = json['id'];
    final l$name = json['name'];
    final l$type = json['type'];
    final l$$__typename = json['__typename'];
    return Query$libraries$libraries(
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
    if (other is! Query$libraries$libraries ||
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

extension UtilityExtension$Query$libraries$libraries
    on Query$libraries$libraries {
  CopyWith$Query$libraries$libraries<Query$libraries$libraries> get copyWith =>
      CopyWith$Query$libraries$libraries(this, (i) => i);
}

abstract class CopyWith$Query$libraries$libraries<TRes> {
  factory CopyWith$Query$libraries$libraries(
    Query$libraries$libraries instance,
    TRes Function(Query$libraries$libraries) then,
  ) = _CopyWithImpl$Query$libraries$libraries;

  factory CopyWith$Query$libraries$libraries.stub(TRes res) =
      _CopyWithStubImpl$Query$libraries$libraries;

  TRes call({
    String? id,
    String? name,
    Enum$LibraryType? type,
    String? $__typename,
  });
}

class _CopyWithImpl$Query$libraries$libraries<TRes>
    implements CopyWith$Query$libraries$libraries<TRes> {
  _CopyWithImpl$Query$libraries$libraries(this._instance, this._then);

  final Query$libraries$libraries _instance;

  final TRes Function(Query$libraries$libraries) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? id = _undefined,
    Object? name = _undefined,
    Object? type = _undefined,
    Object? $__typename = _undefined,
  }) => _then(
    Query$libraries$libraries(
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

class _CopyWithStubImpl$Query$libraries$libraries<TRes>
    implements CopyWith$Query$libraries$libraries<TRes> {
  _CopyWithStubImpl$Query$libraries$libraries(this._res);

  TRes _res;

  call({
    String? id,
    String? name,
    Enum$LibraryType? type,
    String? $__typename,
  }) => _res;
}

import 'package:gql/ast.dart';
import 'schema.graphql.dart';

class Query$attributionsQuery {
  Query$attributionsQuery({
    required this.attributions,
    this.$__typename = 'Query',
  });

  factory Query$attributionsQuery.fromJson(Map<String, dynamic> json) {
    final l$attributions = json['attributions'];
    final l$$__typename = json['__typename'];
    return Query$attributionsQuery(
      attributions: (l$attributions as List<dynamic>)
          .map(
            (e) => Query$attributionsQuery$attributions.fromJson(
              (e as Map<String, dynamic>),
            ),
          )
          .toList(),
      $__typename: (l$$__typename as String),
    );
  }

  final List<Query$attributionsQuery$attributions> attributions;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$attributions = attributions;
    _resultData['attributions'] = l$attributions
        .map((e) => e.toJson())
        .toList();
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$attributions = attributions;
    final l$$__typename = $__typename;
    return Object.hashAll([
      Object.hashAll(l$attributions.map((v) => v)),
      l$$__typename,
    ]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Query$attributionsQuery || runtimeType != other.runtimeType) {
      return false;
    }
    final l$attributions = attributions;
    final lOther$attributions = other.attributions;
    if (l$attributions.length != lOther$attributions.length) {
      return false;
    }
    for (int i = 0; i < l$attributions.length; i++) {
      final l$attributions$entry = l$attributions[i];
      final lOther$attributions$entry = lOther$attributions[i];
      if (l$attributions$entry != lOther$attributions$entry) {
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

extension UtilityExtension$Query$attributionsQuery on Query$attributionsQuery {
  CopyWith$Query$attributionsQuery<Query$attributionsQuery> get copyWith =>
      CopyWith$Query$attributionsQuery(this, (i) => i);
}

abstract class CopyWith$Query$attributionsQuery<TRes> {
  factory CopyWith$Query$attributionsQuery(
    Query$attributionsQuery instance,
    TRes Function(Query$attributionsQuery) then,
  ) = _CopyWithImpl$Query$attributionsQuery;

  factory CopyWith$Query$attributionsQuery.stub(TRes res) =
      _CopyWithStubImpl$Query$attributionsQuery;

  TRes call({
    List<Query$attributionsQuery$attributions>? attributions,
    String? $__typename,
  });
  TRes attributions(
    Iterable<Query$attributionsQuery$attributions> Function(
      Iterable<
        CopyWith$Query$attributionsQuery$attributions<
          Query$attributionsQuery$attributions
        >
      >,
    )
    _fn,
  );
}

class _CopyWithImpl$Query$attributionsQuery<TRes>
    implements CopyWith$Query$attributionsQuery<TRes> {
  _CopyWithImpl$Query$attributionsQuery(this._instance, this._then);

  final Query$attributionsQuery _instance;

  final TRes Function(Query$attributionsQuery) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? attributions = _undefined,
    Object? $__typename = _undefined,
  }) => _then(
    Query$attributionsQuery(
      attributions: attributions == _undefined || attributions == null
          ? _instance.attributions
          : (attributions as List<Query$attributionsQuery$attributions>),
      $__typename: $__typename == _undefined || $__typename == null
          ? _instance.$__typename
          : ($__typename as String),
    ),
  );

  TRes attributions(
    Iterable<Query$attributionsQuery$attributions> Function(
      Iterable<
        CopyWith$Query$attributionsQuery$attributions<
          Query$attributionsQuery$attributions
        >
      >,
    )
    _fn,
  ) => call(
    attributions: _fn(
      _instance.attributions.map(
        (e) => CopyWith$Query$attributionsQuery$attributions(e, (i) => i),
      ),
    ).toList(),
  );
}

class _CopyWithStubImpl$Query$attributionsQuery<TRes>
    implements CopyWith$Query$attributionsQuery<TRes> {
  _CopyWithStubImpl$Query$attributionsQuery(this._res);

  TRes _res;

  call({
    List<Query$attributionsQuery$attributions>? attributions,
    String? $__typename,
  }) => _res;

  attributions(_fn) => _res;
}

const documentNodeQueryattributionsQuery = DocumentNode(
  definitions: [
    OperationDefinitionNode(
      type: OperationType.query,
      name: NameNode(value: 'attributionsQuery'),
      variableDefinitions: [],
      directives: [],
      selectionSet: SelectionSetNode(
        selections: [
          FieldNode(
            name: NameNode(value: 'attributions'),
            alias: null,
            arguments: [],
            directives: [],
            selectionSet: SelectionSetNode(
              selections: [
                FieldNode(
                  name: NameNode(value: 'source'),
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
                  name: NameNode(value: 'url'),
                  alias: null,
                  arguments: [],
                  directives: [],
                  selectionSet: null,
                ),
                FieldNode(
                  name: NameNode(value: 'notice'),
                  alias: null,
                  arguments: [],
                  directives: [],
                  selectionSet: null,
                ),
                FieldNode(
                  name: NameNode(value: 'license'),
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

class Query$attributionsQuery$attributions {
  Query$attributionsQuery$attributions({
    required this.source,
    required this.name,
    this.url,
    this.notice,
    this.license,
    this.$__typename = 'Attribution',
  });

  factory Query$attributionsQuery$attributions.fromJson(
    Map<String, dynamic> json,
  ) {
    final l$source = json['source'];
    final l$name = json['name'];
    final l$url = json['url'];
    final l$notice = json['notice'];
    final l$license = json['license'];
    final l$$__typename = json['__typename'];
    return Query$attributionsQuery$attributions(
      source: fromJson$Enum$MetadataSource((l$source as String)),
      name: (l$name as String),
      url: (l$url as String?),
      notice: (l$notice as String?),
      license: (l$license as String?),
      $__typename: (l$$__typename as String),
    );
  }

  final Enum$MetadataSource source;

  final String name;

  final String? url;

  final String? notice;

  final String? license;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$source = source;
    _resultData['source'] = toJson$Enum$MetadataSource(l$source);
    final l$name = name;
    _resultData['name'] = l$name;
    final l$url = url;
    _resultData['url'] = l$url;
    final l$notice = notice;
    _resultData['notice'] = l$notice;
    final l$license = license;
    _resultData['license'] = l$license;
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$source = source;
    final l$name = name;
    final l$url = url;
    final l$notice = notice;
    final l$license = license;
    final l$$__typename = $__typename;
    return Object.hashAll([
      l$source,
      l$name,
      l$url,
      l$notice,
      l$license,
      l$$__typename,
    ]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Query$attributionsQuery$attributions ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$source = source;
    final lOther$source = other.source;
    if (l$source != lOther$source) {
      return false;
    }
    final l$name = name;
    final lOther$name = other.name;
    if (l$name != lOther$name) {
      return false;
    }
    final l$url = url;
    final lOther$url = other.url;
    if (l$url != lOther$url) {
      return false;
    }
    final l$notice = notice;
    final lOther$notice = other.notice;
    if (l$notice != lOther$notice) {
      return false;
    }
    final l$license = license;
    final lOther$license = other.license;
    if (l$license != lOther$license) {
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

extension UtilityExtension$Query$attributionsQuery$attributions
    on Query$attributionsQuery$attributions {
  CopyWith$Query$attributionsQuery$attributions<
    Query$attributionsQuery$attributions
  >
  get copyWith => CopyWith$Query$attributionsQuery$attributions(this, (i) => i);
}

abstract class CopyWith$Query$attributionsQuery$attributions<TRes> {
  factory CopyWith$Query$attributionsQuery$attributions(
    Query$attributionsQuery$attributions instance,
    TRes Function(Query$attributionsQuery$attributions) then,
  ) = _CopyWithImpl$Query$attributionsQuery$attributions;

  factory CopyWith$Query$attributionsQuery$attributions.stub(TRes res) =
      _CopyWithStubImpl$Query$attributionsQuery$attributions;

  TRes call({
    Enum$MetadataSource? source,
    String? name,
    String? url,
    String? notice,
    String? license,
    String? $__typename,
  });
}

class _CopyWithImpl$Query$attributionsQuery$attributions<TRes>
    implements CopyWith$Query$attributionsQuery$attributions<TRes> {
  _CopyWithImpl$Query$attributionsQuery$attributions(
    this._instance,
    this._then,
  );

  final Query$attributionsQuery$attributions _instance;

  final TRes Function(Query$attributionsQuery$attributions) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? source = _undefined,
    Object? name = _undefined,
    Object? url = _undefined,
    Object? notice = _undefined,
    Object? license = _undefined,
    Object? $__typename = _undefined,
  }) => _then(
    Query$attributionsQuery$attributions(
      source: source == _undefined || source == null
          ? _instance.source
          : (source as Enum$MetadataSource),
      name: name == _undefined || name == null
          ? _instance.name
          : (name as String),
      url: url == _undefined ? _instance.url : (url as String?),
      notice: notice == _undefined ? _instance.notice : (notice as String?),
      license: license == _undefined ? _instance.license : (license as String?),
      $__typename: $__typename == _undefined || $__typename == null
          ? _instance.$__typename
          : ($__typename as String),
    ),
  );
}

class _CopyWithStubImpl$Query$attributionsQuery$attributions<TRes>
    implements CopyWith$Query$attributionsQuery$attributions<TRes> {
  _CopyWithStubImpl$Query$attributionsQuery$attributions(this._res);

  TRes _res;

  call({
    Enum$MetadataSource? source,
    String? name,
    String? url,
    String? notice,
    String? license,
    String? $__typename,
  }) => _res;
}

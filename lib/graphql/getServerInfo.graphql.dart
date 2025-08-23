import 'package:gql/ast.dart';

class Query$getServerInfoQuery {
  Query$getServerInfoQuery({this.getServerInfo, this.$__typename = 'Query'});

  factory Query$getServerInfoQuery.fromJson(Map<String, dynamic> json) {
    final l$getServerInfo = json['getServerInfo'];
    final l$$__typename = json['__typename'];
    return Query$getServerInfoQuery(
      getServerInfo: l$getServerInfo == null
          ? null
          : Query$getServerInfoQuery$getServerInfo.fromJson(
              (l$getServerInfo as Map<String, dynamic>),
            ),
      $__typename: (l$$__typename as String),
    );
  }

  final Query$getServerInfoQuery$getServerInfo? getServerInfo;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$getServerInfo = getServerInfo;
    _resultData['getServerInfo'] = l$getServerInfo?.toJson();
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$getServerInfo = getServerInfo;
    final l$$__typename = $__typename;
    return Object.hashAll([l$getServerInfo, l$$__typename]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Query$getServerInfoQuery ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$getServerInfo = getServerInfo;
    final lOther$getServerInfo = other.getServerInfo;
    if (l$getServerInfo != lOther$getServerInfo) {
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

extension UtilityExtension$Query$getServerInfoQuery
    on Query$getServerInfoQuery {
  CopyWith$Query$getServerInfoQuery<Query$getServerInfoQuery> get copyWith =>
      CopyWith$Query$getServerInfoQuery(this, (i) => i);
}

abstract class CopyWith$Query$getServerInfoQuery<TRes> {
  factory CopyWith$Query$getServerInfoQuery(
    Query$getServerInfoQuery instance,
    TRes Function(Query$getServerInfoQuery) then,
  ) = _CopyWithImpl$Query$getServerInfoQuery;

  factory CopyWith$Query$getServerInfoQuery.stub(TRes res) =
      _CopyWithStubImpl$Query$getServerInfoQuery;

  TRes call({
    Query$getServerInfoQuery$getServerInfo? getServerInfo,
    String? $__typename,
  });
  CopyWith$Query$getServerInfoQuery$getServerInfo<TRes> get getServerInfo;
}

class _CopyWithImpl$Query$getServerInfoQuery<TRes>
    implements CopyWith$Query$getServerInfoQuery<TRes> {
  _CopyWithImpl$Query$getServerInfoQuery(this._instance, this._then);

  final Query$getServerInfoQuery _instance;

  final TRes Function(Query$getServerInfoQuery) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? getServerInfo = _undefined,
    Object? $__typename = _undefined,
  }) => _then(
    Query$getServerInfoQuery(
      getServerInfo: getServerInfo == _undefined
          ? _instance.getServerInfo
          : (getServerInfo as Query$getServerInfoQuery$getServerInfo?),
      $__typename: $__typename == _undefined || $__typename == null
          ? _instance.$__typename
          : ($__typename as String),
    ),
  );

  CopyWith$Query$getServerInfoQuery$getServerInfo<TRes> get getServerInfo {
    final local$getServerInfo = _instance.getServerInfo;
    return local$getServerInfo == null
        ? CopyWith$Query$getServerInfoQuery$getServerInfo.stub(_then(_instance))
        : CopyWith$Query$getServerInfoQuery$getServerInfo(
            local$getServerInfo,
            (e) => call(getServerInfo: e),
          );
  }
}

class _CopyWithStubImpl$Query$getServerInfoQuery<TRes>
    implements CopyWith$Query$getServerInfoQuery<TRes> {
  _CopyWithStubImpl$Query$getServerInfoQuery(this._res);

  TRes _res;

  call({
    Query$getServerInfoQuery$getServerInfo? getServerInfo,
    String? $__typename,
  }) => _res;

  CopyWith$Query$getServerInfoQuery$getServerInfo<TRes> get getServerInfo =>
      CopyWith$Query$getServerInfoQuery$getServerInfo.stub(_res);
}

const documentNodeQuerygetServerInfoQuery = DocumentNode(
  definitions: [
    OperationDefinitionNode(
      type: OperationType.query,
      name: NameNode(value: 'getServerInfoQuery'),
      variableDefinitions: [],
      directives: [],
      selectionSet: SelectionSetNode(
        selections: [
          FieldNode(
            name: NameNode(value: 'getServerInfo'),
            alias: null,
            arguments: [],
            directives: [],
            selectionSet: SelectionSetNode(
              selections: [
                FieldNode(
                  name: NameNode(value: 'name'),
                  alias: null,
                  arguments: [],
                  directives: [],
                  selectionSet: null,
                ),
                FieldNode(
                  name: NameNode(value: 'openIdUrl'),
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
                  name: NameNode(value: 'version'),
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

class Query$getServerInfoQuery$getServerInfo {
  Query$getServerInfoQuery$getServerInfo({
    required this.name,
    required this.openIdUrl,
    required this.url,
    required this.version,
    this.$__typename = 'ServerInfo',
  });

  factory Query$getServerInfoQuery$getServerInfo.fromJson(
    Map<String, dynamic> json,
  ) {
    final l$name = json['name'];
    final l$openIdUrl = json['openIdUrl'];
    final l$url = json['url'];
    final l$version = json['version'];
    final l$$__typename = json['__typename'];
    return Query$getServerInfoQuery$getServerInfo(
      name: (l$name as String),
      openIdUrl: (l$openIdUrl as String),
      url: (l$url as String),
      version: (l$version as String),
      $__typename: (l$$__typename as String),
    );
  }

  final String name;

  final String openIdUrl;

  final String url;

  final String version;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$name = name;
    _resultData['name'] = l$name;
    final l$openIdUrl = openIdUrl;
    _resultData['openIdUrl'] = l$openIdUrl;
    final l$url = url;
    _resultData['url'] = l$url;
    final l$version = version;
    _resultData['version'] = l$version;
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$name = name;
    final l$openIdUrl = openIdUrl;
    final l$url = url;
    final l$version = version;
    final l$$__typename = $__typename;
    return Object.hashAll([
      l$name,
      l$openIdUrl,
      l$url,
      l$version,
      l$$__typename,
    ]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Query$getServerInfoQuery$getServerInfo ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$name = name;
    final lOther$name = other.name;
    if (l$name != lOther$name) {
      return false;
    }
    final l$openIdUrl = openIdUrl;
    final lOther$openIdUrl = other.openIdUrl;
    if (l$openIdUrl != lOther$openIdUrl) {
      return false;
    }
    final l$url = url;
    final lOther$url = other.url;
    if (l$url != lOther$url) {
      return false;
    }
    final l$version = version;
    final lOther$version = other.version;
    if (l$version != lOther$version) {
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

extension UtilityExtension$Query$getServerInfoQuery$getServerInfo
    on Query$getServerInfoQuery$getServerInfo {
  CopyWith$Query$getServerInfoQuery$getServerInfo<
    Query$getServerInfoQuery$getServerInfo
  >
  get copyWith =>
      CopyWith$Query$getServerInfoQuery$getServerInfo(this, (i) => i);
}

abstract class CopyWith$Query$getServerInfoQuery$getServerInfo<TRes> {
  factory CopyWith$Query$getServerInfoQuery$getServerInfo(
    Query$getServerInfoQuery$getServerInfo instance,
    TRes Function(Query$getServerInfoQuery$getServerInfo) then,
  ) = _CopyWithImpl$Query$getServerInfoQuery$getServerInfo;

  factory CopyWith$Query$getServerInfoQuery$getServerInfo.stub(TRes res) =
      _CopyWithStubImpl$Query$getServerInfoQuery$getServerInfo;

  TRes call({
    String? name,
    String? openIdUrl,
    String? url,
    String? version,
    String? $__typename,
  });
}

class _CopyWithImpl$Query$getServerInfoQuery$getServerInfo<TRes>
    implements CopyWith$Query$getServerInfoQuery$getServerInfo<TRes> {
  _CopyWithImpl$Query$getServerInfoQuery$getServerInfo(
    this._instance,
    this._then,
  );

  final Query$getServerInfoQuery$getServerInfo _instance;

  final TRes Function(Query$getServerInfoQuery$getServerInfo) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? name = _undefined,
    Object? openIdUrl = _undefined,
    Object? url = _undefined,
    Object? version = _undefined,
    Object? $__typename = _undefined,
  }) => _then(
    Query$getServerInfoQuery$getServerInfo(
      name: name == _undefined || name == null
          ? _instance.name
          : (name as String),
      openIdUrl: openIdUrl == _undefined || openIdUrl == null
          ? _instance.openIdUrl
          : (openIdUrl as String),
      url: url == _undefined || url == null ? _instance.url : (url as String),
      version: version == _undefined || version == null
          ? _instance.version
          : (version as String),
      $__typename: $__typename == _undefined || $__typename == null
          ? _instance.$__typename
          : ($__typename as String),
    ),
  );
}

class _CopyWithStubImpl$Query$getServerInfoQuery$getServerInfo<TRes>
    implements CopyWith$Query$getServerInfoQuery$getServerInfo<TRes> {
  _CopyWithStubImpl$Query$getServerInfoQuery$getServerInfo(this._res);

  TRes _res;

  call({
    String? name,
    String? openIdUrl,
    String? url,
    String? version,
    String? $__typename,
  }) => _res;
}

import 'package:gql/ast.dart';
import 'schema.graphql.dart';

class Variables$Query$sessionFollowers {
  factory Variables$Query$sessionFollowers({required String playQueueId}) =>
      Variables$Query$sessionFollowers._({r'playQueueId': playQueueId});

  Variables$Query$sessionFollowers._(this._$data);

  factory Variables$Query$sessionFollowers.fromJson(Map<String, dynamic> data) {
    final result$data = <String, dynamic>{};
    final l$playQueueId = data['playQueueId'];
    result$data['playQueueId'] = (l$playQueueId as String);
    return Variables$Query$sessionFollowers._(result$data);
  }

  Map<String, dynamic> _$data;

  String get playQueueId => (_$data['playQueueId'] as String);

  Map<String, dynamic> toJson() {
    final result$data = <String, dynamic>{};
    final l$playQueueId = playQueueId;
    result$data['playQueueId'] = l$playQueueId;
    return result$data;
  }

  CopyWith$Variables$Query$sessionFollowers<Variables$Query$sessionFollowers>
  get copyWith => CopyWith$Variables$Query$sessionFollowers(this, (i) => i);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Variables$Query$sessionFollowers ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$playQueueId = playQueueId;
    final lOther$playQueueId = other.playQueueId;
    if (l$playQueueId != lOther$playQueueId) {
      return false;
    }
    return true;
  }

  @override
  int get hashCode {
    final l$playQueueId = playQueueId;
    return Object.hashAll([l$playQueueId]);
  }
}

abstract class CopyWith$Variables$Query$sessionFollowers<TRes> {
  factory CopyWith$Variables$Query$sessionFollowers(
    Variables$Query$sessionFollowers instance,
    TRes Function(Variables$Query$sessionFollowers) then,
  ) = _CopyWithImpl$Variables$Query$sessionFollowers;

  factory CopyWith$Variables$Query$sessionFollowers.stub(TRes res) =
      _CopyWithStubImpl$Variables$Query$sessionFollowers;

  TRes call({String? playQueueId});
}

class _CopyWithImpl$Variables$Query$sessionFollowers<TRes>
    implements CopyWith$Variables$Query$sessionFollowers<TRes> {
  _CopyWithImpl$Variables$Query$sessionFollowers(this._instance, this._then);

  final Variables$Query$sessionFollowers _instance;

  final TRes Function(Variables$Query$sessionFollowers) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({Object? playQueueId = _undefined}) => _then(
    Variables$Query$sessionFollowers._({
      ..._instance._$data,
      if (playQueueId != _undefined && playQueueId != null)
        'playQueueId': (playQueueId as String),
    }),
  );
}

class _CopyWithStubImpl$Variables$Query$sessionFollowers<TRes>
    implements CopyWith$Variables$Query$sessionFollowers<TRes> {
  _CopyWithStubImpl$Variables$Query$sessionFollowers(this._res);

  TRes _res;

  call({String? playQueueId}) => _res;
}

class Query$sessionFollowers {
  Query$sessionFollowers({
    required this.sessionFollowers,
    this.$__typename = 'Query',
  });

  factory Query$sessionFollowers.fromJson(Map<String, dynamic> json) {
    final l$sessionFollowers = json['sessionFollowers'];
    final l$$__typename = json['__typename'];
    return Query$sessionFollowers(
      sessionFollowers: (l$sessionFollowers as List<dynamic>)
          .map(
            (e) => Query$sessionFollowers$sessionFollowers.fromJson(
              (e as Map<String, dynamic>),
            ),
          )
          .toList(),
      $__typename: (l$$__typename as String),
    );
  }

  final List<Query$sessionFollowers$sessionFollowers> sessionFollowers;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$sessionFollowers = sessionFollowers;
    _resultData['sessionFollowers'] = l$sessionFollowers
        .map((e) => e.toJson())
        .toList();
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$sessionFollowers = sessionFollowers;
    final l$$__typename = $__typename;
    return Object.hashAll([
      Object.hashAll(l$sessionFollowers.map((v) => v)),
      l$$__typename,
    ]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Query$sessionFollowers || runtimeType != other.runtimeType) {
      return false;
    }
    final l$sessionFollowers = sessionFollowers;
    final lOther$sessionFollowers = other.sessionFollowers;
    if (l$sessionFollowers.length != lOther$sessionFollowers.length) {
      return false;
    }
    for (int i = 0; i < l$sessionFollowers.length; i++) {
      final l$sessionFollowers$entry = l$sessionFollowers[i];
      final lOther$sessionFollowers$entry = lOther$sessionFollowers[i];
      if (l$sessionFollowers$entry != lOther$sessionFollowers$entry) {
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

extension UtilityExtension$Query$sessionFollowers on Query$sessionFollowers {
  CopyWith$Query$sessionFollowers<Query$sessionFollowers> get copyWith =>
      CopyWith$Query$sessionFollowers(this, (i) => i);
}

abstract class CopyWith$Query$sessionFollowers<TRes> {
  factory CopyWith$Query$sessionFollowers(
    Query$sessionFollowers instance,
    TRes Function(Query$sessionFollowers) then,
  ) = _CopyWithImpl$Query$sessionFollowers;

  factory CopyWith$Query$sessionFollowers.stub(TRes res) =
      _CopyWithStubImpl$Query$sessionFollowers;

  TRes call({
    List<Query$sessionFollowers$sessionFollowers>? sessionFollowers,
    String? $__typename,
  });
  TRes sessionFollowers(
    Iterable<Query$sessionFollowers$sessionFollowers> Function(
      Iterable<
        CopyWith$Query$sessionFollowers$sessionFollowers<
          Query$sessionFollowers$sessionFollowers
        >
      >,
    )
    _fn,
  );
}

class _CopyWithImpl$Query$sessionFollowers<TRes>
    implements CopyWith$Query$sessionFollowers<TRes> {
  _CopyWithImpl$Query$sessionFollowers(this._instance, this._then);

  final Query$sessionFollowers _instance;

  final TRes Function(Query$sessionFollowers) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? sessionFollowers = _undefined,
    Object? $__typename = _undefined,
  }) => _then(
    Query$sessionFollowers(
      sessionFollowers:
          sessionFollowers == _undefined || sessionFollowers == null
          ? _instance.sessionFollowers
          : (sessionFollowers as List<Query$sessionFollowers$sessionFollowers>),
      $__typename: $__typename == _undefined || $__typename == null
          ? _instance.$__typename
          : ($__typename as String),
    ),
  );

  TRes sessionFollowers(
    Iterable<Query$sessionFollowers$sessionFollowers> Function(
      Iterable<
        CopyWith$Query$sessionFollowers$sessionFollowers<
          Query$sessionFollowers$sessionFollowers
        >
      >,
    )
    _fn,
  ) => call(
    sessionFollowers: _fn(
      _instance.sessionFollowers.map(
        (e) => CopyWith$Query$sessionFollowers$sessionFollowers(e, (i) => i),
      ),
    ).toList(),
  );
}

class _CopyWithStubImpl$Query$sessionFollowers<TRes>
    implements CopyWith$Query$sessionFollowers<TRes> {
  _CopyWithStubImpl$Query$sessionFollowers(this._res);

  TRes _res;

  call({
    List<Query$sessionFollowers$sessionFollowers>? sessionFollowers,
    String? $__typename,
  }) => _res;

  sessionFollowers(_fn) => _res;
}

const documentNodeQuerysessionFollowers = DocumentNode(
  definitions: [
    OperationDefinitionNode(
      type: OperationType.query,
      name: NameNode(value: 'sessionFollowers'),
      variableDefinitions: [
        VariableDefinitionNode(
          variable: VariableNode(name: NameNode(value: 'playQueueId')),
          type: NamedTypeNode(name: NameNode(value: 'ID'), isNonNull: true),
          defaultValue: DefaultValueNode(value: null),
          directives: [],
        ),
      ],
      directives: [],
      selectionSet: SelectionSetNode(
        selections: [
          FieldNode(
            name: NameNode(value: 'sessionFollowers'),
            alias: null,
            arguments: [
              ArgumentNode(
                name: NameNode(value: 'playQueueId'),
                value: VariableNode(name: NameNode(value: 'playQueueId')),
              ),
            ],
            directives: [],
            selectionSet: SelectionSetNode(
              selections: [
                FieldNode(
                  name: NameNode(value: 'userId'),
                  alias: null,
                  arguments: [],
                  directives: [],
                  selectionSet: null,
                ),
                FieldNode(
                  name: NameNode(value: 'userName'),
                  alias: null,
                  arguments: [],
                  directives: [],
                  selectionSet: null,
                ),
                FieldNode(
                  name: NameNode(value: 'deviceId'),
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
                  name: NameNode(value: 'platform'),
                  alias: null,
                  arguments: [],
                  directives: [],
                  selectionSet: null,
                ),
                FieldNode(
                  name: NameNode(value: 'since'),
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

class Query$sessionFollowers$sessionFollowers {
  Query$sessionFollowers$sessionFollowers({
    required this.userId,
    this.userName,
    required this.deviceId,
    this.deviceName,
    this.platform,
    required this.since,
    this.$__typename = 'SessionFollower',
  });

  factory Query$sessionFollowers$sessionFollowers.fromJson(
    Map<String, dynamic> json,
  ) {
    final l$userId = json['userId'];
    final l$userName = json['userName'];
    final l$deviceId = json['deviceId'];
    final l$deviceName = json['deviceName'];
    final l$platform = json['platform'];
    final l$since = json['since'];
    final l$$__typename = json['__typename'];
    return Query$sessionFollowers$sessionFollowers(
      userId: (l$userId as String),
      userName: (l$userName as String?),
      deviceId: (l$deviceId as String),
      deviceName: (l$deviceName as String?),
      platform: l$platform == null
          ? null
          : fromJson$Enum$DevicePlatform((l$platform as String)),
      since: (l$since as String),
      $__typename: (l$$__typename as String),
    );
  }

  final String userId;

  final String? userName;

  final String deviceId;

  final String? deviceName;

  final Enum$DevicePlatform? platform;

  final String since;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$userId = userId;
    _resultData['userId'] = l$userId;
    final l$userName = userName;
    _resultData['userName'] = l$userName;
    final l$deviceId = deviceId;
    _resultData['deviceId'] = l$deviceId;
    final l$deviceName = deviceName;
    _resultData['deviceName'] = l$deviceName;
    final l$platform = platform;
    _resultData['platform'] = l$platform == null
        ? null
        : toJson$Enum$DevicePlatform(l$platform);
    final l$since = since;
    _resultData['since'] = l$since;
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$userId = userId;
    final l$userName = userName;
    final l$deviceId = deviceId;
    final l$deviceName = deviceName;
    final l$platform = platform;
    final l$since = since;
    final l$$__typename = $__typename;
    return Object.hashAll([
      l$userId,
      l$userName,
      l$deviceId,
      l$deviceName,
      l$platform,
      l$since,
      l$$__typename,
    ]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Query$sessionFollowers$sessionFollowers ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$userId = userId;
    final lOther$userId = other.userId;
    if (l$userId != lOther$userId) {
      return false;
    }
    final l$userName = userName;
    final lOther$userName = other.userName;
    if (l$userName != lOther$userName) {
      return false;
    }
    final l$deviceId = deviceId;
    final lOther$deviceId = other.deviceId;
    if (l$deviceId != lOther$deviceId) {
      return false;
    }
    final l$deviceName = deviceName;
    final lOther$deviceName = other.deviceName;
    if (l$deviceName != lOther$deviceName) {
      return false;
    }
    final l$platform = platform;
    final lOther$platform = other.platform;
    if (l$platform != lOther$platform) {
      return false;
    }
    final l$since = since;
    final lOther$since = other.since;
    if (l$since != lOther$since) {
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

extension UtilityExtension$Query$sessionFollowers$sessionFollowers
    on Query$sessionFollowers$sessionFollowers {
  CopyWith$Query$sessionFollowers$sessionFollowers<
    Query$sessionFollowers$sessionFollowers
  >
  get copyWith =>
      CopyWith$Query$sessionFollowers$sessionFollowers(this, (i) => i);
}

abstract class CopyWith$Query$sessionFollowers$sessionFollowers<TRes> {
  factory CopyWith$Query$sessionFollowers$sessionFollowers(
    Query$sessionFollowers$sessionFollowers instance,
    TRes Function(Query$sessionFollowers$sessionFollowers) then,
  ) = _CopyWithImpl$Query$sessionFollowers$sessionFollowers;

  factory CopyWith$Query$sessionFollowers$sessionFollowers.stub(TRes res) =
      _CopyWithStubImpl$Query$sessionFollowers$sessionFollowers;

  TRes call({
    String? userId,
    String? userName,
    String? deviceId,
    String? deviceName,
    Enum$DevicePlatform? platform,
    String? since,
    String? $__typename,
  });
}

class _CopyWithImpl$Query$sessionFollowers$sessionFollowers<TRes>
    implements CopyWith$Query$sessionFollowers$sessionFollowers<TRes> {
  _CopyWithImpl$Query$sessionFollowers$sessionFollowers(
    this._instance,
    this._then,
  );

  final Query$sessionFollowers$sessionFollowers _instance;

  final TRes Function(Query$sessionFollowers$sessionFollowers) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? userId = _undefined,
    Object? userName = _undefined,
    Object? deviceId = _undefined,
    Object? deviceName = _undefined,
    Object? platform = _undefined,
    Object? since = _undefined,
    Object? $__typename = _undefined,
  }) => _then(
    Query$sessionFollowers$sessionFollowers(
      userId: userId == _undefined || userId == null
          ? _instance.userId
          : (userId as String),
      userName: userName == _undefined
          ? _instance.userName
          : (userName as String?),
      deviceId: deviceId == _undefined || deviceId == null
          ? _instance.deviceId
          : (deviceId as String),
      deviceName: deviceName == _undefined
          ? _instance.deviceName
          : (deviceName as String?),
      platform: platform == _undefined
          ? _instance.platform
          : (platform as Enum$DevicePlatform?),
      since: since == _undefined || since == null
          ? _instance.since
          : (since as String),
      $__typename: $__typename == _undefined || $__typename == null
          ? _instance.$__typename
          : ($__typename as String),
    ),
  );
}

class _CopyWithStubImpl$Query$sessionFollowers$sessionFollowers<TRes>
    implements CopyWith$Query$sessionFollowers$sessionFollowers<TRes> {
  _CopyWithStubImpl$Query$sessionFollowers$sessionFollowers(this._res);

  TRes _res;

  call({
    String? userId,
    String? userName,
    String? deviceId,
    String? deviceName,
    Enum$DevicePlatform? platform,
    String? since,
    String? $__typename,
  }) => _res;
}

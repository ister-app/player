import 'package:gql/ast.dart';

import 'schema.graphql.dart';

class Fragment$fragmentDevice {
  Fragment$fragmentDevice({
    required this.deviceId,
    required this.name,
    required this.platform,
    required this.online,
    required this.lastSeenAt,
    required this.createdAt,
    this.$__typename = 'Device',
  });

  factory Fragment$fragmentDevice.fromJson(Map<String, dynamic> json) {
    final l$deviceId = json['deviceId'];
    final l$name = json['name'];
    final l$platform = json['platform'];
    final l$online = json['online'];
    final l$lastSeenAt = json['lastSeenAt'];
    final l$createdAt = json['createdAt'];
    final l$$__typename = json['__typename'];
    return Fragment$fragmentDevice(
      deviceId: (l$deviceId as String),
      name: (l$name as String),
      platform: fromJson$Enum$DevicePlatform((l$platform as String)),
      online: (l$online as bool),
      lastSeenAt: (l$lastSeenAt as String),
      createdAt: (l$createdAt as String),
      $__typename: (l$$__typename as String),
    );
  }

  final String deviceId;

  final String name;

  final Enum$DevicePlatform platform;

  final bool online;

  final String lastSeenAt;

  final String createdAt;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$deviceId = deviceId;
    _resultData['deviceId'] = l$deviceId;
    final l$name = name;
    _resultData['name'] = l$name;
    final l$platform = platform;
    _resultData['platform'] = toJson$Enum$DevicePlatform(l$platform);
    final l$online = online;
    _resultData['online'] = l$online;
    final l$lastSeenAt = lastSeenAt;
    _resultData['lastSeenAt'] = l$lastSeenAt;
    final l$createdAt = createdAt;
    _resultData['createdAt'] = l$createdAt;
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$deviceId = deviceId;
    final l$name = name;
    final l$platform = platform;
    final l$online = online;
    final l$lastSeenAt = lastSeenAt;
    final l$createdAt = createdAt;
    final l$$__typename = $__typename;
    return Object.hashAll([
      l$deviceId,
      l$name,
      l$platform,
      l$online,
      l$lastSeenAt,
      l$createdAt,
      l$$__typename,
    ]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Fragment$fragmentDevice || runtimeType != other.runtimeType) {
      return false;
    }
    final l$deviceId = deviceId;
    final lOther$deviceId = other.deviceId;
    if (l$deviceId != lOther$deviceId) {
      return false;
    }
    final l$name = name;
    final lOther$name = other.name;
    if (l$name != lOther$name) {
      return false;
    }
    final l$platform = platform;
    final lOther$platform = other.platform;
    if (l$platform != lOther$platform) {
      return false;
    }
    final l$online = online;
    final lOther$online = other.online;
    if (l$online != lOther$online) {
      return false;
    }
    final l$lastSeenAt = lastSeenAt;
    final lOther$lastSeenAt = other.lastSeenAt;
    if (l$lastSeenAt != lOther$lastSeenAt) {
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

extension UtilityExtension$Fragment$fragmentDevice on Fragment$fragmentDevice {
  CopyWith$Fragment$fragmentDevice<Fragment$fragmentDevice> get copyWith =>
      CopyWith$Fragment$fragmentDevice(this, (i) => i);
}

abstract class CopyWith$Fragment$fragmentDevice<TRes> {
  factory CopyWith$Fragment$fragmentDevice(
    Fragment$fragmentDevice instance,
    TRes Function(Fragment$fragmentDevice) then,
  ) = _CopyWithImpl$Fragment$fragmentDevice;

  factory CopyWith$Fragment$fragmentDevice.stub(TRes res) =
      _CopyWithStubImpl$Fragment$fragmentDevice;

  TRes call({
    String? deviceId,
    String? name,
    Enum$DevicePlatform? platform,
    bool? online,
    String? lastSeenAt,
    String? createdAt,
    String? $__typename,
  });
}

class _CopyWithImpl$Fragment$fragmentDevice<TRes>
    implements CopyWith$Fragment$fragmentDevice<TRes> {
  _CopyWithImpl$Fragment$fragmentDevice(this._instance, this._then);

  final Fragment$fragmentDevice _instance;

  final TRes Function(Fragment$fragmentDevice) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? deviceId = _undefined,
    Object? name = _undefined,
    Object? platform = _undefined,
    Object? online = _undefined,
    Object? lastSeenAt = _undefined,
    Object? createdAt = _undefined,
    Object? $__typename = _undefined,
  }) => _then(
    Fragment$fragmentDevice(
      deviceId: deviceId == _undefined || deviceId == null
          ? _instance.deviceId
          : (deviceId as String),
      name: name == _undefined || name == null
          ? _instance.name
          : (name as String),
      platform: platform == _undefined || platform == null
          ? _instance.platform
          : (platform as Enum$DevicePlatform),
      online: online == _undefined || online == null
          ? _instance.online
          : (online as bool),
      lastSeenAt: lastSeenAt == _undefined || lastSeenAt == null
          ? _instance.lastSeenAt
          : (lastSeenAt as String),
      createdAt: createdAt == _undefined || createdAt == null
          ? _instance.createdAt
          : (createdAt as String),
      $__typename: $__typename == _undefined || $__typename == null
          ? _instance.$__typename
          : ($__typename as String),
    ),
  );
}

class _CopyWithStubImpl$Fragment$fragmentDevice<TRes>
    implements CopyWith$Fragment$fragmentDevice<TRes> {
  _CopyWithStubImpl$Fragment$fragmentDevice(this._res);

  TRes _res;

  call({
    String? deviceId,
    String? name,
    Enum$DevicePlatform? platform,
    bool? online,
    String? lastSeenAt,
    String? createdAt,
    String? $__typename,
  }) => _res;
}

const fragmentDefinitionfragmentDevice = FragmentDefinitionNode(
  name: NameNode(value: 'fragmentDevice'),
  typeCondition: TypeConditionNode(
    on: NamedTypeNode(name: NameNode(value: 'Device'), isNonNull: false),
  ),
  directives: [],
  selectionSet: SelectionSetNode(
    selections: [
      FieldNode(
        name: NameNode(value: 'deviceId'),
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
        name: NameNode(value: 'platform'),
        alias: null,
        arguments: [],
        directives: [],
        selectionSet: null,
      ),
      FieldNode(
        name: NameNode(value: 'online'),
        alias: null,
        arguments: [],
        directives: [],
        selectionSet: null,
      ),
      FieldNode(
        name: NameNode(value: 'lastSeenAt'),
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
);
const documentNodeFragmentfragmentDevice = DocumentNode(
  definitions: [fragmentDefinitionfragmentDevice],
);

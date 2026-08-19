import 'fragmentDevice.graphql.dart';

import 'package:gql/ast.dart';

import 'schema.graphql.dart';

class Variables$Mutation$registerDevice {
  factory Variables$Mutation$registerDevice({
    required String deviceId,
    required String name,
    required Enum$DevicePlatform platform,
  }) => Variables$Mutation$registerDevice._({
    r'deviceId': deviceId,
    r'name': name,
    r'platform': platform,
  });

  Variables$Mutation$registerDevice._(this._$data);

  factory Variables$Mutation$registerDevice.fromJson(
    Map<String, dynamic> data,
  ) {
    final result$data = <String, dynamic>{};
    final l$deviceId = data['deviceId'];
    result$data['deviceId'] = (l$deviceId as String);
    final l$name = data['name'];
    result$data['name'] = (l$name as String);
    final l$platform = data['platform'];
    result$data['platform'] = fromJson$Enum$DevicePlatform(
      (l$platform as String),
    );
    return Variables$Mutation$registerDevice._(result$data);
  }

  Map<String, dynamic> _$data;

  String get deviceId => (_$data['deviceId'] as String);

  String get name => (_$data['name'] as String);

  Enum$DevicePlatform get platform =>
      (_$data['platform'] as Enum$DevicePlatform);

  Map<String, dynamic> toJson() {
    final result$data = <String, dynamic>{};
    final l$deviceId = deviceId;
    result$data['deviceId'] = l$deviceId;
    final l$name = name;
    result$data['name'] = l$name;
    final l$platform = platform;
    result$data['platform'] = toJson$Enum$DevicePlatform(l$platform);
    return result$data;
  }

  CopyWith$Variables$Mutation$registerDevice<Variables$Mutation$registerDevice>
  get copyWith => CopyWith$Variables$Mutation$registerDevice(this, (i) => i);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Variables$Mutation$registerDevice ||
        runtimeType != other.runtimeType) {
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
    return true;
  }

  @override
  int get hashCode {
    final l$deviceId = deviceId;
    final l$name = name;
    final l$platform = platform;
    return Object.hashAll([l$deviceId, l$name, l$platform]);
  }
}

abstract class CopyWith$Variables$Mutation$registerDevice<TRes> {
  factory CopyWith$Variables$Mutation$registerDevice(
    Variables$Mutation$registerDevice instance,
    TRes Function(Variables$Mutation$registerDevice) then,
  ) = _CopyWithImpl$Variables$Mutation$registerDevice;

  factory CopyWith$Variables$Mutation$registerDevice.stub(TRes res) =
      _CopyWithStubImpl$Variables$Mutation$registerDevice;

  TRes call({String? deviceId, String? name, Enum$DevicePlatform? platform});
}

class _CopyWithImpl$Variables$Mutation$registerDevice<TRes>
    implements CopyWith$Variables$Mutation$registerDevice<TRes> {
  _CopyWithImpl$Variables$Mutation$registerDevice(this._instance, this._then);

  final Variables$Mutation$registerDevice _instance;

  final TRes Function(Variables$Mutation$registerDevice) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? deviceId = _undefined,
    Object? name = _undefined,
    Object? platform = _undefined,
  }) => _then(
    Variables$Mutation$registerDevice._({
      ..._instance._$data,
      if (deviceId != _undefined && deviceId != null)
        'deviceId': (deviceId as String),
      if (name != _undefined && name != null) 'name': (name as String),
      if (platform != _undefined && platform != null)
        'platform': (platform as Enum$DevicePlatform),
    }),
  );
}

class _CopyWithStubImpl$Variables$Mutation$registerDevice<TRes>
    implements CopyWith$Variables$Mutation$registerDevice<TRes> {
  _CopyWithStubImpl$Variables$Mutation$registerDevice(this._res);

  TRes _res;

  call({String? deviceId, String? name, Enum$DevicePlatform? platform}) => _res;
}

class Mutation$registerDevice {
  Mutation$registerDevice({
    required this.registerDevice,
    this.$__typename = 'Mutation',
  });

  factory Mutation$registerDevice.fromJson(Map<String, dynamic> json) {
    final l$registerDevice = json['registerDevice'];
    final l$$__typename = json['__typename'];
    return Mutation$registerDevice(
      registerDevice: Fragment$fragmentDevice.fromJson(
        (l$registerDevice as Map<String, dynamic>),
      ),
      $__typename: (l$$__typename as String),
    );
  }

  final Fragment$fragmentDevice registerDevice;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$registerDevice = registerDevice;
    _resultData['registerDevice'] = l$registerDevice.toJson();
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$registerDevice = registerDevice;
    final l$$__typename = $__typename;
    return Object.hashAll([l$registerDevice, l$$__typename]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Mutation$registerDevice || runtimeType != other.runtimeType) {
      return false;
    }
    final l$registerDevice = registerDevice;
    final lOther$registerDevice = other.registerDevice;
    if (l$registerDevice != lOther$registerDevice) {
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

extension UtilityExtension$Mutation$registerDevice on Mutation$registerDevice {
  CopyWith$Mutation$registerDevice<Mutation$registerDevice> get copyWith =>
      CopyWith$Mutation$registerDevice(this, (i) => i);
}

abstract class CopyWith$Mutation$registerDevice<TRes> {
  factory CopyWith$Mutation$registerDevice(
    Mutation$registerDevice instance,
    TRes Function(Mutation$registerDevice) then,
  ) = _CopyWithImpl$Mutation$registerDevice;

  factory CopyWith$Mutation$registerDevice.stub(TRes res) =
      _CopyWithStubImpl$Mutation$registerDevice;

  TRes call({Fragment$fragmentDevice? registerDevice, String? $__typename});
  CopyWith$Fragment$fragmentDevice<TRes> get registerDevice;
}

class _CopyWithImpl$Mutation$registerDevice<TRes>
    implements CopyWith$Mutation$registerDevice<TRes> {
  _CopyWithImpl$Mutation$registerDevice(this._instance, this._then);

  final Mutation$registerDevice _instance;

  final TRes Function(Mutation$registerDevice) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? registerDevice = _undefined,
    Object? $__typename = _undefined,
  }) => _then(
    Mutation$registerDevice(
      registerDevice: registerDevice == _undefined || registerDevice == null
          ? _instance.registerDevice
          : (registerDevice as Fragment$fragmentDevice),
      $__typename: $__typename == _undefined || $__typename == null
          ? _instance.$__typename
          : ($__typename as String),
    ),
  );

  CopyWith$Fragment$fragmentDevice<TRes> get registerDevice {
    final local$registerDevice = _instance.registerDevice;
    return CopyWith$Fragment$fragmentDevice(
      local$registerDevice,
      (e) => call(registerDevice: e),
    );
  }
}

class _CopyWithStubImpl$Mutation$registerDevice<TRes>
    implements CopyWith$Mutation$registerDevice<TRes> {
  _CopyWithStubImpl$Mutation$registerDevice(this._res);

  TRes _res;

  call({Fragment$fragmentDevice? registerDevice, String? $__typename}) => _res;

  CopyWith$Fragment$fragmentDevice<TRes> get registerDevice =>
      CopyWith$Fragment$fragmentDevice.stub(_res);
}

const documentNodeMutationregisterDevice = DocumentNode(
  definitions: [
    OperationDefinitionNode(
      type: OperationType.mutation,
      name: NameNode(value: 'registerDevice'),
      variableDefinitions: [
        VariableDefinitionNode(
          variable: VariableNode(name: NameNode(value: 'deviceId')),
          type: NamedTypeNode(name: NameNode(value: 'ID'), isNonNull: true),
          defaultValue: DefaultValueNode(value: null),
          directives: [],
        ),
        VariableDefinitionNode(
          variable: VariableNode(name: NameNode(value: 'name')),
          type: NamedTypeNode(name: NameNode(value: 'String'), isNonNull: true),
          defaultValue: DefaultValueNode(value: null),
          directives: [],
        ),
        VariableDefinitionNode(
          variable: VariableNode(name: NameNode(value: 'platform')),
          type: NamedTypeNode(
            name: NameNode(value: 'DevicePlatform'),
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
            name: NameNode(value: 'registerDevice'),
            alias: null,
            arguments: [
              ArgumentNode(
                name: NameNode(value: 'deviceId'),
                value: VariableNode(name: NameNode(value: 'deviceId')),
              ),
              ArgumentNode(
                name: NameNode(value: 'name'),
                value: VariableNode(name: NameNode(value: 'name')),
              ),
              ArgumentNode(
                name: NameNode(value: 'platform'),
                value: VariableNode(name: NameNode(value: 'platform')),
              ),
            ],
            directives: [],
            selectionSet: SelectionSetNode(
              selections: [
                FragmentSpreadNode(
                  name: NameNode(value: 'fragmentDevice'),
                  directives: [],
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
    fragmentDefinitionfragmentDevice,
  ],
);

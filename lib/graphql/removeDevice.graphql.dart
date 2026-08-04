import 'package:gql/ast.dart';

class Variables$Mutation$removeDevice {
  factory Variables$Mutation$removeDevice({required String deviceId}) =>
      Variables$Mutation$removeDevice._({r'deviceId': deviceId});

  Variables$Mutation$removeDevice._(this._$data);

  factory Variables$Mutation$removeDevice.fromJson(Map<String, dynamic> data) {
    final result$data = <String, dynamic>{};
    final l$deviceId = data['deviceId'];
    result$data['deviceId'] = (l$deviceId as String);
    return Variables$Mutation$removeDevice._(result$data);
  }

  Map<String, dynamic> _$data;

  String get deviceId => (_$data['deviceId'] as String);

  Map<String, dynamic> toJson() {
    final result$data = <String, dynamic>{};
    final l$deviceId = deviceId;
    result$data['deviceId'] = l$deviceId;
    return result$data;
  }

  CopyWith$Variables$Mutation$removeDevice<Variables$Mutation$removeDevice>
  get copyWith => CopyWith$Variables$Mutation$removeDevice(this, (i) => i);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Variables$Mutation$removeDevice ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$deviceId = deviceId;
    final lOther$deviceId = other.deviceId;
    if (l$deviceId != lOther$deviceId) {
      return false;
    }
    return true;
  }

  @override
  int get hashCode {
    final l$deviceId = deviceId;
    return Object.hashAll([l$deviceId]);
  }
}

abstract class CopyWith$Variables$Mutation$removeDevice<TRes> {
  factory CopyWith$Variables$Mutation$removeDevice(
    Variables$Mutation$removeDevice instance,
    TRes Function(Variables$Mutation$removeDevice) then,
  ) = _CopyWithImpl$Variables$Mutation$removeDevice;

  factory CopyWith$Variables$Mutation$removeDevice.stub(TRes res) =
      _CopyWithStubImpl$Variables$Mutation$removeDevice;

  TRes call({String? deviceId});
}

class _CopyWithImpl$Variables$Mutation$removeDevice<TRes>
    implements CopyWith$Variables$Mutation$removeDevice<TRes> {
  _CopyWithImpl$Variables$Mutation$removeDevice(this._instance, this._then);

  final Variables$Mutation$removeDevice _instance;

  final TRes Function(Variables$Mutation$removeDevice) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({Object? deviceId = _undefined}) => _then(
    Variables$Mutation$removeDevice._({
      ..._instance._$data,
      if (deviceId != _undefined && deviceId != null)
        'deviceId': (deviceId as String),
    }),
  );
}

class _CopyWithStubImpl$Variables$Mutation$removeDevice<TRes>
    implements CopyWith$Variables$Mutation$removeDevice<TRes> {
  _CopyWithStubImpl$Variables$Mutation$removeDevice(this._res);

  TRes _res;

  call({String? deviceId}) => _res;
}

class Mutation$removeDevice {
  Mutation$removeDevice({
    required this.removeDevice,
    this.$__typename = 'Mutation',
  });

  factory Mutation$removeDevice.fromJson(Map<String, dynamic> json) {
    final l$removeDevice = json['removeDevice'];
    final l$$__typename = json['__typename'];
    return Mutation$removeDevice(
      removeDevice: (l$removeDevice as bool),
      $__typename: (l$$__typename as String),
    );
  }

  final bool removeDevice;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$removeDevice = removeDevice;
    _resultData['removeDevice'] = l$removeDevice;
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$removeDevice = removeDevice;
    final l$$__typename = $__typename;
    return Object.hashAll([l$removeDevice, l$$__typename]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Mutation$removeDevice || runtimeType != other.runtimeType) {
      return false;
    }
    final l$removeDevice = removeDevice;
    final lOther$removeDevice = other.removeDevice;
    if (l$removeDevice != lOther$removeDevice) {
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

extension UtilityExtension$Mutation$removeDevice on Mutation$removeDevice {
  CopyWith$Mutation$removeDevice<Mutation$removeDevice> get copyWith =>
      CopyWith$Mutation$removeDevice(this, (i) => i);
}

abstract class CopyWith$Mutation$removeDevice<TRes> {
  factory CopyWith$Mutation$removeDevice(
    Mutation$removeDevice instance,
    TRes Function(Mutation$removeDevice) then,
  ) = _CopyWithImpl$Mutation$removeDevice;

  factory CopyWith$Mutation$removeDevice.stub(TRes res) =
      _CopyWithStubImpl$Mutation$removeDevice;

  TRes call({bool? removeDevice, String? $__typename});
}

class _CopyWithImpl$Mutation$removeDevice<TRes>
    implements CopyWith$Mutation$removeDevice<TRes> {
  _CopyWithImpl$Mutation$removeDevice(this._instance, this._then);

  final Mutation$removeDevice _instance;

  final TRes Function(Mutation$removeDevice) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? removeDevice = _undefined,
    Object? $__typename = _undefined,
  }) => _then(
    Mutation$removeDevice(
      removeDevice: removeDevice == _undefined || removeDevice == null
          ? _instance.removeDevice
          : (removeDevice as bool),
      $__typename: $__typename == _undefined || $__typename == null
          ? _instance.$__typename
          : ($__typename as String),
    ),
  );
}

class _CopyWithStubImpl$Mutation$removeDevice<TRes>
    implements CopyWith$Mutation$removeDevice<TRes> {
  _CopyWithStubImpl$Mutation$removeDevice(this._res);

  TRes _res;

  call({bool? removeDevice, String? $__typename}) => _res;
}

const documentNodeMutationremoveDevice = DocumentNode(
  definitions: [
    OperationDefinitionNode(
      type: OperationType.mutation,
      name: NameNode(value: 'removeDevice'),
      variableDefinitions: [
        VariableDefinitionNode(
          variable: VariableNode(name: NameNode(value: 'deviceId')),
          type: NamedTypeNode(name: NameNode(value: 'ID'), isNonNull: true),
          defaultValue: DefaultValueNode(value: null),
          directives: [],
        ),
      ],
      directives: [],
      selectionSet: SelectionSetNode(
        selections: [
          FieldNode(
            name: NameNode(value: 'removeDevice'),
            alias: null,
            arguments: [
              ArgumentNode(
                name: NameNode(value: 'deviceId'),
                value: VariableNode(name: NameNode(value: 'deviceId')),
              ),
            ],
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
  ],
);

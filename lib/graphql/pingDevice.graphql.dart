import 'package:gql/ast.dart';

class Variables$Mutation$pingDevice {
  factory Variables$Mutation$pingDevice({required String deviceId}) =>
      Variables$Mutation$pingDevice._({r'deviceId': deviceId});

  Variables$Mutation$pingDevice._(this._$data);

  factory Variables$Mutation$pingDevice.fromJson(Map<String, dynamic> data) {
    final result$data = <String, dynamic>{};
    final l$deviceId = data['deviceId'];
    result$data['deviceId'] = (l$deviceId as String);
    return Variables$Mutation$pingDevice._(result$data);
  }

  Map<String, dynamic> _$data;

  String get deviceId => (_$data['deviceId'] as String);

  Map<String, dynamic> toJson() {
    final result$data = <String, dynamic>{};
    final l$deviceId = deviceId;
    result$data['deviceId'] = l$deviceId;
    return result$data;
  }

  CopyWith$Variables$Mutation$pingDevice<Variables$Mutation$pingDevice>
  get copyWith => CopyWith$Variables$Mutation$pingDevice(this, (i) => i);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Variables$Mutation$pingDevice ||
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

abstract class CopyWith$Variables$Mutation$pingDevice<TRes> {
  factory CopyWith$Variables$Mutation$pingDevice(
    Variables$Mutation$pingDevice instance,
    TRes Function(Variables$Mutation$pingDevice) then,
  ) = _CopyWithImpl$Variables$Mutation$pingDevice;

  factory CopyWith$Variables$Mutation$pingDevice.stub(TRes res) =
      _CopyWithStubImpl$Variables$Mutation$pingDevice;

  TRes call({String? deviceId});
}

class _CopyWithImpl$Variables$Mutation$pingDevice<TRes>
    implements CopyWith$Variables$Mutation$pingDevice<TRes> {
  _CopyWithImpl$Variables$Mutation$pingDevice(this._instance, this._then);

  final Variables$Mutation$pingDevice _instance;

  final TRes Function(Variables$Mutation$pingDevice) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({Object? deviceId = _undefined}) => _then(
    Variables$Mutation$pingDevice._({
      ..._instance._$data,
      if (deviceId != _undefined && deviceId != null)
        'deviceId': (deviceId as String),
    }),
  );
}

class _CopyWithStubImpl$Variables$Mutation$pingDevice<TRes>
    implements CopyWith$Variables$Mutation$pingDevice<TRes> {
  _CopyWithStubImpl$Variables$Mutation$pingDevice(this._res);

  TRes _res;

  call({String? deviceId}) => _res;
}

class Mutation$pingDevice {
  Mutation$pingDevice({
    required this.pingDevice,
    this.$__typename = 'Mutation',
  });

  factory Mutation$pingDevice.fromJson(Map<String, dynamic> json) {
    final l$pingDevice = json['pingDevice'];
    final l$$__typename = json['__typename'];
    return Mutation$pingDevice(
      pingDevice: (l$pingDevice as bool),
      $__typename: (l$$__typename as String),
    );
  }

  final bool pingDevice;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$pingDevice = pingDevice;
    _resultData['pingDevice'] = l$pingDevice;
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$pingDevice = pingDevice;
    final l$$__typename = $__typename;
    return Object.hashAll([l$pingDevice, l$$__typename]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Mutation$pingDevice || runtimeType != other.runtimeType) {
      return false;
    }
    final l$pingDevice = pingDevice;
    final lOther$pingDevice = other.pingDevice;
    if (l$pingDevice != lOther$pingDevice) {
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

extension UtilityExtension$Mutation$pingDevice on Mutation$pingDevice {
  CopyWith$Mutation$pingDevice<Mutation$pingDevice> get copyWith =>
      CopyWith$Mutation$pingDevice(this, (i) => i);
}

abstract class CopyWith$Mutation$pingDevice<TRes> {
  factory CopyWith$Mutation$pingDevice(
    Mutation$pingDevice instance,
    TRes Function(Mutation$pingDevice) then,
  ) = _CopyWithImpl$Mutation$pingDevice;

  factory CopyWith$Mutation$pingDevice.stub(TRes res) =
      _CopyWithStubImpl$Mutation$pingDevice;

  TRes call({bool? pingDevice, String? $__typename});
}

class _CopyWithImpl$Mutation$pingDevice<TRes>
    implements CopyWith$Mutation$pingDevice<TRes> {
  _CopyWithImpl$Mutation$pingDevice(this._instance, this._then);

  final Mutation$pingDevice _instance;

  final TRes Function(Mutation$pingDevice) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? pingDevice = _undefined,
    Object? $__typename = _undefined,
  }) => _then(
    Mutation$pingDevice(
      pingDevice: pingDevice == _undefined || pingDevice == null
          ? _instance.pingDevice
          : (pingDevice as bool),
      $__typename: $__typename == _undefined || $__typename == null
          ? _instance.$__typename
          : ($__typename as String),
    ),
  );
}

class _CopyWithStubImpl$Mutation$pingDevice<TRes>
    implements CopyWith$Mutation$pingDevice<TRes> {
  _CopyWithStubImpl$Mutation$pingDevice(this._res);

  TRes _res;

  call({bool? pingDevice, String? $__typename}) => _res;
}

const documentNodeMutationpingDevice = DocumentNode(
  definitions: [
    OperationDefinitionNode(
      type: OperationType.mutation,
      name: NameNode(value: 'pingDevice'),
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
            name: NameNode(value: 'pingDevice'),
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

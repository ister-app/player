import 'fragmentDevice.graphql.dart';

import 'package:gql/ast.dart';

class Variables$Mutation$renameDevice {
  factory Variables$Mutation$renameDevice({
    required String deviceId,
    required String name,
  }) =>
      Variables$Mutation$renameDevice._({r'deviceId': deviceId, r'name': name});

  Variables$Mutation$renameDevice._(this._$data);

  factory Variables$Mutation$renameDevice.fromJson(Map<String, dynamic> data) {
    final result$data = <String, dynamic>{};
    final l$deviceId = data['deviceId'];
    result$data['deviceId'] = (l$deviceId as String);
    final l$name = data['name'];
    result$data['name'] = (l$name as String);
    return Variables$Mutation$renameDevice._(result$data);
  }

  Map<String, dynamic> _$data;

  String get deviceId => (_$data['deviceId'] as String);

  String get name => (_$data['name'] as String);

  Map<String, dynamic> toJson() {
    final result$data = <String, dynamic>{};
    final l$deviceId = deviceId;
    result$data['deviceId'] = l$deviceId;
    final l$name = name;
    result$data['name'] = l$name;
    return result$data;
  }

  CopyWith$Variables$Mutation$renameDevice<Variables$Mutation$renameDevice>
  get copyWith => CopyWith$Variables$Mutation$renameDevice(this, (i) => i);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Variables$Mutation$renameDevice ||
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
    return true;
  }

  @override
  int get hashCode {
    final l$deviceId = deviceId;
    final l$name = name;
    return Object.hashAll([l$deviceId, l$name]);
  }
}

abstract class CopyWith$Variables$Mutation$renameDevice<TRes> {
  factory CopyWith$Variables$Mutation$renameDevice(
    Variables$Mutation$renameDevice instance,
    TRes Function(Variables$Mutation$renameDevice) then,
  ) = _CopyWithImpl$Variables$Mutation$renameDevice;

  factory CopyWith$Variables$Mutation$renameDevice.stub(TRes res) =
      _CopyWithStubImpl$Variables$Mutation$renameDevice;

  TRes call({String? deviceId, String? name});
}

class _CopyWithImpl$Variables$Mutation$renameDevice<TRes>
    implements CopyWith$Variables$Mutation$renameDevice<TRes> {
  _CopyWithImpl$Variables$Mutation$renameDevice(this._instance, this._then);

  final Variables$Mutation$renameDevice _instance;

  final TRes Function(Variables$Mutation$renameDevice) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({Object? deviceId = _undefined, Object? name = _undefined}) =>
      _then(
        Variables$Mutation$renameDevice._({
          ..._instance._$data,
          if (deviceId != _undefined && deviceId != null)
            'deviceId': (deviceId as String),
          if (name != _undefined && name != null) 'name': (name as String),
        }),
      );
}

class _CopyWithStubImpl$Variables$Mutation$renameDevice<TRes>
    implements CopyWith$Variables$Mutation$renameDevice<TRes> {
  _CopyWithStubImpl$Variables$Mutation$renameDevice(this._res);

  TRes _res;

  call({String? deviceId, String? name}) => _res;
}

class Mutation$renameDevice {
  Mutation$renameDevice({this.renameDevice, this.$__typename = 'Mutation'});

  factory Mutation$renameDevice.fromJson(Map<String, dynamic> json) {
    final l$renameDevice = json['renameDevice'];
    final l$$__typename = json['__typename'];
    return Mutation$renameDevice(
      renameDevice: l$renameDevice == null
          ? null
          : Fragment$fragmentDevice.fromJson(
              (l$renameDevice as Map<String, dynamic>),
            ),
      $__typename: (l$$__typename as String),
    );
  }

  final Fragment$fragmentDevice? renameDevice;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$renameDevice = renameDevice;
    _resultData['renameDevice'] = l$renameDevice?.toJson();
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$renameDevice = renameDevice;
    final l$$__typename = $__typename;
    return Object.hashAll([l$renameDevice, l$$__typename]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Mutation$renameDevice || runtimeType != other.runtimeType) {
      return false;
    }
    final l$renameDevice = renameDevice;
    final lOther$renameDevice = other.renameDevice;
    if (l$renameDevice != lOther$renameDevice) {
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

extension UtilityExtension$Mutation$renameDevice on Mutation$renameDevice {
  CopyWith$Mutation$renameDevice<Mutation$renameDevice> get copyWith =>
      CopyWith$Mutation$renameDevice(this, (i) => i);
}

abstract class CopyWith$Mutation$renameDevice<TRes> {
  factory CopyWith$Mutation$renameDevice(
    Mutation$renameDevice instance,
    TRes Function(Mutation$renameDevice) then,
  ) = _CopyWithImpl$Mutation$renameDevice;

  factory CopyWith$Mutation$renameDevice.stub(TRes res) =
      _CopyWithStubImpl$Mutation$renameDevice;

  TRes call({Fragment$fragmentDevice? renameDevice, String? $__typename});
  CopyWith$Fragment$fragmentDevice<TRes> get renameDevice;
}

class _CopyWithImpl$Mutation$renameDevice<TRes>
    implements CopyWith$Mutation$renameDevice<TRes> {
  _CopyWithImpl$Mutation$renameDevice(this._instance, this._then);

  final Mutation$renameDevice _instance;

  final TRes Function(Mutation$renameDevice) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? renameDevice = _undefined,
    Object? $__typename = _undefined,
  }) => _then(
    Mutation$renameDevice(
      renameDevice: renameDevice == _undefined
          ? _instance.renameDevice
          : (renameDevice as Fragment$fragmentDevice?),
      $__typename: $__typename == _undefined || $__typename == null
          ? _instance.$__typename
          : ($__typename as String),
    ),
  );

  CopyWith$Fragment$fragmentDevice<TRes> get renameDevice {
    final local$renameDevice = _instance.renameDevice;
    return local$renameDevice == null
        ? CopyWith$Fragment$fragmentDevice.stub(_then(_instance))
        : CopyWith$Fragment$fragmentDevice(
            local$renameDevice,
            (e) => call(renameDevice: e),
          );
  }
}

class _CopyWithStubImpl$Mutation$renameDevice<TRes>
    implements CopyWith$Mutation$renameDevice<TRes> {
  _CopyWithStubImpl$Mutation$renameDevice(this._res);

  TRes _res;

  call({Fragment$fragmentDevice? renameDevice, String? $__typename}) => _res;

  CopyWith$Fragment$fragmentDevice<TRes> get renameDevice =>
      CopyWith$Fragment$fragmentDevice.stub(_res);
}

const documentNodeMutationrenameDevice = DocumentNode(
  definitions: [
    OperationDefinitionNode(
      type: OperationType.mutation,
      name: NameNode(value: 'renameDevice'),
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
      ],
      directives: [],
      selectionSet: SelectionSetNode(
        selections: [
          FieldNode(
            name: NameNode(value: 'renameDevice'),
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

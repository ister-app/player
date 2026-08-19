import 'package:gql/ast.dart';

import 'schema.graphql.dart';

class Variables$Mutation$sendDeviceCommand {
  factory Variables$Mutation$sendDeviceCommand({
    required String deviceId,
    required Enum$DeviceCommandType command,
    Enum$MediaType? mediaType,
    String? mediaId,
    String? startId,
    String? playQueueId,
    double? positionInMilliseconds,
    String? targetDeviceId,
  }) => Variables$Mutation$sendDeviceCommand._({
    r'deviceId': deviceId,
    r'command': command,
    if (mediaType != null) r'mediaType': mediaType,
    if (mediaId != null) r'mediaId': mediaId,
    if (startId != null) r'startId': startId,
    if (playQueueId != null) r'playQueueId': playQueueId,
    if (positionInMilliseconds != null)
      r'positionInMilliseconds': positionInMilliseconds,
    if (targetDeviceId != null) r'targetDeviceId': targetDeviceId,
  });

  Variables$Mutation$sendDeviceCommand._(this._$data);

  factory Variables$Mutation$sendDeviceCommand.fromJson(
    Map<String, dynamic> data,
  ) {
    final result$data = <String, dynamic>{};
    final l$deviceId = data['deviceId'];
    result$data['deviceId'] = (l$deviceId as String);
    final l$command = data['command'];
    result$data['command'] = fromJson$Enum$DeviceCommandType(
      (l$command as String),
    );
    if (data.containsKey('mediaType')) {
      final l$mediaType = data['mediaType'];
      result$data['mediaType'] = l$mediaType == null
          ? null
          : fromJson$Enum$MediaType((l$mediaType as String));
    }
    if (data.containsKey('mediaId')) {
      final l$mediaId = data['mediaId'];
      result$data['mediaId'] = (l$mediaId as String?);
    }
    if (data.containsKey('startId')) {
      final l$startId = data['startId'];
      result$data['startId'] = (l$startId as String?);
    }
    if (data.containsKey('playQueueId')) {
      final l$playQueueId = data['playQueueId'];
      result$data['playQueueId'] = (l$playQueueId as String?);
    }
    if (data.containsKey('positionInMilliseconds')) {
      final l$positionInMilliseconds = data['positionInMilliseconds'];
      result$data['positionInMilliseconds'] = (l$positionInMilliseconds as num?)
          ?.toDouble();
    }
    if (data.containsKey('targetDeviceId')) {
      final l$targetDeviceId = data['targetDeviceId'];
      result$data['targetDeviceId'] = (l$targetDeviceId as String?);
    }
    return Variables$Mutation$sendDeviceCommand._(result$data);
  }

  Map<String, dynamic> _$data;

  String get deviceId => (_$data['deviceId'] as String);

  Enum$DeviceCommandType get command =>
      (_$data['command'] as Enum$DeviceCommandType);

  Enum$MediaType? get mediaType => (_$data['mediaType'] as Enum$MediaType?);

  String? get mediaId => (_$data['mediaId'] as String?);

  String? get startId => (_$data['startId'] as String?);

  String? get playQueueId => (_$data['playQueueId'] as String?);

  double? get positionInMilliseconds =>
      (_$data['positionInMilliseconds'] as double?);

  String? get targetDeviceId => (_$data['targetDeviceId'] as String?);

  Map<String, dynamic> toJson() {
    final result$data = <String, dynamic>{};
    final l$deviceId = deviceId;
    result$data['deviceId'] = l$deviceId;
    final l$command = command;
    result$data['command'] = toJson$Enum$DeviceCommandType(l$command);
    if (_$data.containsKey('mediaType')) {
      final l$mediaType = mediaType;
      result$data['mediaType'] = l$mediaType == null
          ? null
          : toJson$Enum$MediaType(l$mediaType);
    }
    if (_$data.containsKey('mediaId')) {
      final l$mediaId = mediaId;
      result$data['mediaId'] = l$mediaId;
    }
    if (_$data.containsKey('startId')) {
      final l$startId = startId;
      result$data['startId'] = l$startId;
    }
    if (_$data.containsKey('playQueueId')) {
      final l$playQueueId = playQueueId;
      result$data['playQueueId'] = l$playQueueId;
    }
    if (_$data.containsKey('positionInMilliseconds')) {
      final l$positionInMilliseconds = positionInMilliseconds;
      result$data['positionInMilliseconds'] = l$positionInMilliseconds;
    }
    if (_$data.containsKey('targetDeviceId')) {
      final l$targetDeviceId = targetDeviceId;
      result$data['targetDeviceId'] = l$targetDeviceId;
    }
    return result$data;
  }

  CopyWith$Variables$Mutation$sendDeviceCommand<
    Variables$Mutation$sendDeviceCommand
  >
  get copyWith => CopyWith$Variables$Mutation$sendDeviceCommand(this, (i) => i);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Variables$Mutation$sendDeviceCommand ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$deviceId = deviceId;
    final lOther$deviceId = other.deviceId;
    if (l$deviceId != lOther$deviceId) {
      return false;
    }
    final l$command = command;
    final lOther$command = other.command;
    if (l$command != lOther$command) {
      return false;
    }
    final l$mediaType = mediaType;
    final lOther$mediaType = other.mediaType;
    if (_$data.containsKey('mediaType') !=
        other._$data.containsKey('mediaType')) {
      return false;
    }
    if (l$mediaType != lOther$mediaType) {
      return false;
    }
    final l$mediaId = mediaId;
    final lOther$mediaId = other.mediaId;
    if (_$data.containsKey('mediaId') != other._$data.containsKey('mediaId')) {
      return false;
    }
    if (l$mediaId != lOther$mediaId) {
      return false;
    }
    final l$startId = startId;
    final lOther$startId = other.startId;
    if (_$data.containsKey('startId') != other._$data.containsKey('startId')) {
      return false;
    }
    if (l$startId != lOther$startId) {
      return false;
    }
    final l$playQueueId = playQueueId;
    final lOther$playQueueId = other.playQueueId;
    if (_$data.containsKey('playQueueId') !=
        other._$data.containsKey('playQueueId')) {
      return false;
    }
    if (l$playQueueId != lOther$playQueueId) {
      return false;
    }
    final l$positionInMilliseconds = positionInMilliseconds;
    final lOther$positionInMilliseconds = other.positionInMilliseconds;
    if (_$data.containsKey('positionInMilliseconds') !=
        other._$data.containsKey('positionInMilliseconds')) {
      return false;
    }
    if (l$positionInMilliseconds != lOther$positionInMilliseconds) {
      return false;
    }
    final l$targetDeviceId = targetDeviceId;
    final lOther$targetDeviceId = other.targetDeviceId;
    if (_$data.containsKey('targetDeviceId') !=
        other._$data.containsKey('targetDeviceId')) {
      return false;
    }
    if (l$targetDeviceId != lOther$targetDeviceId) {
      return false;
    }
    return true;
  }

  @override
  int get hashCode {
    final l$deviceId = deviceId;
    final l$command = command;
    final l$mediaType = mediaType;
    final l$mediaId = mediaId;
    final l$startId = startId;
    final l$playQueueId = playQueueId;
    final l$positionInMilliseconds = positionInMilliseconds;
    final l$targetDeviceId = targetDeviceId;
    return Object.hashAll([
      l$deviceId,
      l$command,
      _$data.containsKey('mediaType') ? l$mediaType : const {},
      _$data.containsKey('mediaId') ? l$mediaId : const {},
      _$data.containsKey('startId') ? l$startId : const {},
      _$data.containsKey('playQueueId') ? l$playQueueId : const {},
      _$data.containsKey('positionInMilliseconds')
          ? l$positionInMilliseconds
          : const {},
      _$data.containsKey('targetDeviceId') ? l$targetDeviceId : const {},
    ]);
  }
}

abstract class CopyWith$Variables$Mutation$sendDeviceCommand<TRes> {
  factory CopyWith$Variables$Mutation$sendDeviceCommand(
    Variables$Mutation$sendDeviceCommand instance,
    TRes Function(Variables$Mutation$sendDeviceCommand) then,
  ) = _CopyWithImpl$Variables$Mutation$sendDeviceCommand;

  factory CopyWith$Variables$Mutation$sendDeviceCommand.stub(TRes res) =
      _CopyWithStubImpl$Variables$Mutation$sendDeviceCommand;

  TRes call({
    String? deviceId,
    Enum$DeviceCommandType? command,
    Enum$MediaType? mediaType,
    String? mediaId,
    String? startId,
    String? playQueueId,
    double? positionInMilliseconds,
    String? targetDeviceId,
  });
}

class _CopyWithImpl$Variables$Mutation$sendDeviceCommand<TRes>
    implements CopyWith$Variables$Mutation$sendDeviceCommand<TRes> {
  _CopyWithImpl$Variables$Mutation$sendDeviceCommand(
    this._instance,
    this._then,
  );

  final Variables$Mutation$sendDeviceCommand _instance;

  final TRes Function(Variables$Mutation$sendDeviceCommand) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? deviceId = _undefined,
    Object? command = _undefined,
    Object? mediaType = _undefined,
    Object? mediaId = _undefined,
    Object? startId = _undefined,
    Object? playQueueId = _undefined,
    Object? positionInMilliseconds = _undefined,
    Object? targetDeviceId = _undefined,
  }) => _then(
    Variables$Mutation$sendDeviceCommand._({
      ..._instance._$data,
      if (deviceId != _undefined && deviceId != null)
        'deviceId': (deviceId as String),
      if (command != _undefined && command != null)
        'command': (command as Enum$DeviceCommandType),
      if (mediaType != _undefined) 'mediaType': (mediaType as Enum$MediaType?),
      if (mediaId != _undefined) 'mediaId': (mediaId as String?),
      if (startId != _undefined) 'startId': (startId as String?),
      if (playQueueId != _undefined) 'playQueueId': (playQueueId as String?),
      if (positionInMilliseconds != _undefined)
        'positionInMilliseconds': (positionInMilliseconds as double?),
      if (targetDeviceId != _undefined)
        'targetDeviceId': (targetDeviceId as String?),
    }),
  );
}

class _CopyWithStubImpl$Variables$Mutation$sendDeviceCommand<TRes>
    implements CopyWith$Variables$Mutation$sendDeviceCommand<TRes> {
  _CopyWithStubImpl$Variables$Mutation$sendDeviceCommand(this._res);

  TRes _res;

  call({
    String? deviceId,
    Enum$DeviceCommandType? command,
    Enum$MediaType? mediaType,
    String? mediaId,
    String? startId,
    String? playQueueId,
    double? positionInMilliseconds,
    String? targetDeviceId,
  }) => _res;
}

class Mutation$sendDeviceCommand {
  Mutation$sendDeviceCommand({
    required this.sendDeviceCommand,
    this.$__typename = 'Mutation',
  });

  factory Mutation$sendDeviceCommand.fromJson(Map<String, dynamic> json) {
    final l$sendDeviceCommand = json['sendDeviceCommand'];
    final l$$__typename = json['__typename'];
    return Mutation$sendDeviceCommand(
      sendDeviceCommand: (l$sendDeviceCommand as bool),
      $__typename: (l$$__typename as String),
    );
  }

  final bool sendDeviceCommand;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$sendDeviceCommand = sendDeviceCommand;
    _resultData['sendDeviceCommand'] = l$sendDeviceCommand;
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$sendDeviceCommand = sendDeviceCommand;
    final l$$__typename = $__typename;
    return Object.hashAll([l$sendDeviceCommand, l$$__typename]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Mutation$sendDeviceCommand ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$sendDeviceCommand = sendDeviceCommand;
    final lOther$sendDeviceCommand = other.sendDeviceCommand;
    if (l$sendDeviceCommand != lOther$sendDeviceCommand) {
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

extension UtilityExtension$Mutation$sendDeviceCommand
    on Mutation$sendDeviceCommand {
  CopyWith$Mutation$sendDeviceCommand<Mutation$sendDeviceCommand>
  get copyWith => CopyWith$Mutation$sendDeviceCommand(this, (i) => i);
}

abstract class CopyWith$Mutation$sendDeviceCommand<TRes> {
  factory CopyWith$Mutation$sendDeviceCommand(
    Mutation$sendDeviceCommand instance,
    TRes Function(Mutation$sendDeviceCommand) then,
  ) = _CopyWithImpl$Mutation$sendDeviceCommand;

  factory CopyWith$Mutation$sendDeviceCommand.stub(TRes res) =
      _CopyWithStubImpl$Mutation$sendDeviceCommand;

  TRes call({bool? sendDeviceCommand, String? $__typename});
}

class _CopyWithImpl$Mutation$sendDeviceCommand<TRes>
    implements CopyWith$Mutation$sendDeviceCommand<TRes> {
  _CopyWithImpl$Mutation$sendDeviceCommand(this._instance, this._then);

  final Mutation$sendDeviceCommand _instance;

  final TRes Function(Mutation$sendDeviceCommand) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? sendDeviceCommand = _undefined,
    Object? $__typename = _undefined,
  }) => _then(
    Mutation$sendDeviceCommand(
      sendDeviceCommand:
          sendDeviceCommand == _undefined || sendDeviceCommand == null
          ? _instance.sendDeviceCommand
          : (sendDeviceCommand as bool),
      $__typename: $__typename == _undefined || $__typename == null
          ? _instance.$__typename
          : ($__typename as String),
    ),
  );
}

class _CopyWithStubImpl$Mutation$sendDeviceCommand<TRes>
    implements CopyWith$Mutation$sendDeviceCommand<TRes> {
  _CopyWithStubImpl$Mutation$sendDeviceCommand(this._res);

  TRes _res;

  call({bool? sendDeviceCommand, String? $__typename}) => _res;
}

const documentNodeMutationsendDeviceCommand = DocumentNode(
  definitions: [
    OperationDefinitionNode(
      type: OperationType.mutation,
      name: NameNode(value: 'sendDeviceCommand'),
      variableDefinitions: [
        VariableDefinitionNode(
          variable: VariableNode(name: NameNode(value: 'deviceId')),
          type: NamedTypeNode(name: NameNode(value: 'ID'), isNonNull: true),
          defaultValue: DefaultValueNode(value: null),
          directives: [],
        ),
        VariableDefinitionNode(
          variable: VariableNode(name: NameNode(value: 'command')),
          type: NamedTypeNode(
            name: NameNode(value: 'DeviceCommandType'),
            isNonNull: true,
          ),
          defaultValue: DefaultValueNode(value: null),
          directives: [],
        ),
        VariableDefinitionNode(
          variable: VariableNode(name: NameNode(value: 'mediaType')),
          type: NamedTypeNode(
            name: NameNode(value: 'MediaType'),
            isNonNull: false,
          ),
          defaultValue: DefaultValueNode(value: null),
          directives: [],
        ),
        VariableDefinitionNode(
          variable: VariableNode(name: NameNode(value: 'mediaId')),
          type: NamedTypeNode(name: NameNode(value: 'ID'), isNonNull: false),
          defaultValue: DefaultValueNode(value: null),
          directives: [],
        ),
        VariableDefinitionNode(
          variable: VariableNode(name: NameNode(value: 'startId')),
          type: NamedTypeNode(name: NameNode(value: 'ID'), isNonNull: false),
          defaultValue: DefaultValueNode(value: null),
          directives: [],
        ),
        VariableDefinitionNode(
          variable: VariableNode(name: NameNode(value: 'playQueueId')),
          type: NamedTypeNode(name: NameNode(value: 'ID'), isNonNull: false),
          defaultValue: DefaultValueNode(value: null),
          directives: [],
        ),
        VariableDefinitionNode(
          variable: VariableNode(
            name: NameNode(value: 'positionInMilliseconds'),
          ),
          type: NamedTypeNode(name: NameNode(value: 'Float'), isNonNull: false),
          defaultValue: DefaultValueNode(value: null),
          directives: [],
        ),
        VariableDefinitionNode(
          variable: VariableNode(name: NameNode(value: 'targetDeviceId')),
          type: NamedTypeNode(name: NameNode(value: 'ID'), isNonNull: false),
          defaultValue: DefaultValueNode(value: null),
          directives: [],
        ),
      ],
      directives: [],
      selectionSet: SelectionSetNode(
        selections: [
          FieldNode(
            name: NameNode(value: 'sendDeviceCommand'),
            alias: null,
            arguments: [
              ArgumentNode(
                name: NameNode(value: 'deviceId'),
                value: VariableNode(name: NameNode(value: 'deviceId')),
              ),
              ArgumentNode(
                name: NameNode(value: 'command'),
                value: VariableNode(name: NameNode(value: 'command')),
              ),
              ArgumentNode(
                name: NameNode(value: 'mediaType'),
                value: VariableNode(name: NameNode(value: 'mediaType')),
              ),
              ArgumentNode(
                name: NameNode(value: 'mediaId'),
                value: VariableNode(name: NameNode(value: 'mediaId')),
              ),
              ArgumentNode(
                name: NameNode(value: 'startId'),
                value: VariableNode(name: NameNode(value: 'startId')),
              ),
              ArgumentNode(
                name: NameNode(value: 'playQueueId'),
                value: VariableNode(name: NameNode(value: 'playQueueId')),
              ),
              ArgumentNode(
                name: NameNode(value: 'positionInMilliseconds'),
                value: VariableNode(
                  name: NameNode(value: 'positionInMilliseconds'),
                ),
              ),
              ArgumentNode(
                name: NameNode(value: 'targetDeviceId'),
                value: VariableNode(name: NameNode(value: 'targetDeviceId')),
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

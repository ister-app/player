import 'package:gql/ast.dart';
import 'schema.graphql.dart';

class Variables$Subscription$deviceCommands {
  factory Variables$Subscription$deviceCommands({required String deviceId}) =>
      Variables$Subscription$deviceCommands._({r'deviceId': deviceId});

  Variables$Subscription$deviceCommands._(this._$data);

  factory Variables$Subscription$deviceCommands.fromJson(
    Map<String, dynamic> data,
  ) {
    final result$data = <String, dynamic>{};
    final l$deviceId = data['deviceId'];
    result$data['deviceId'] = (l$deviceId as String);
    return Variables$Subscription$deviceCommands._(result$data);
  }

  Map<String, dynamic> _$data;

  String get deviceId => (_$data['deviceId'] as String);

  Map<String, dynamic> toJson() {
    final result$data = <String, dynamic>{};
    final l$deviceId = deviceId;
    result$data['deviceId'] = l$deviceId;
    return result$data;
  }

  CopyWith$Variables$Subscription$deviceCommands<
    Variables$Subscription$deviceCommands
  >
  get copyWith =>
      CopyWith$Variables$Subscription$deviceCommands(this, (i) => i);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Variables$Subscription$deviceCommands ||
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

abstract class CopyWith$Variables$Subscription$deviceCommands<TRes> {
  factory CopyWith$Variables$Subscription$deviceCommands(
    Variables$Subscription$deviceCommands instance,
    TRes Function(Variables$Subscription$deviceCommands) then,
  ) = _CopyWithImpl$Variables$Subscription$deviceCommands;

  factory CopyWith$Variables$Subscription$deviceCommands.stub(TRes res) =
      _CopyWithStubImpl$Variables$Subscription$deviceCommands;

  TRes call({String? deviceId});
}

class _CopyWithImpl$Variables$Subscription$deviceCommands<TRes>
    implements CopyWith$Variables$Subscription$deviceCommands<TRes> {
  _CopyWithImpl$Variables$Subscription$deviceCommands(
    this._instance,
    this._then,
  );

  final Variables$Subscription$deviceCommands _instance;

  final TRes Function(Variables$Subscription$deviceCommands) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({Object? deviceId = _undefined}) => _then(
    Variables$Subscription$deviceCommands._({
      ..._instance._$data,
      if (deviceId != _undefined && deviceId != null)
        'deviceId': (deviceId as String),
    }),
  );
}

class _CopyWithStubImpl$Variables$Subscription$deviceCommands<TRes>
    implements CopyWith$Variables$Subscription$deviceCommands<TRes> {
  _CopyWithStubImpl$Variables$Subscription$deviceCommands(this._res);

  TRes _res;

  call({String? deviceId}) => _res;
}

class Subscription$deviceCommands {
  Subscription$deviceCommands({required this.deviceCommands});

  factory Subscription$deviceCommands.fromJson(Map<String, dynamic> json) {
    final l$deviceCommands = json['deviceCommands'];
    return Subscription$deviceCommands(
      deviceCommands: Subscription$deviceCommands$deviceCommands.fromJson(
        (l$deviceCommands as Map<String, dynamic>),
      ),
    );
  }

  final Subscription$deviceCommands$deviceCommands deviceCommands;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$deviceCommands = deviceCommands;
    _resultData['deviceCommands'] = l$deviceCommands.toJson();
    return _resultData;
  }

  @override
  int get hashCode {
    final l$deviceCommands = deviceCommands;
    return Object.hashAll([l$deviceCommands]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Subscription$deviceCommands ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$deviceCommands = deviceCommands;
    final lOther$deviceCommands = other.deviceCommands;
    if (l$deviceCommands != lOther$deviceCommands) {
      return false;
    }
    return true;
  }
}

extension UtilityExtension$Subscription$deviceCommands
    on Subscription$deviceCommands {
  CopyWith$Subscription$deviceCommands<Subscription$deviceCommands>
  get copyWith => CopyWith$Subscription$deviceCommands(this, (i) => i);
}

abstract class CopyWith$Subscription$deviceCommands<TRes> {
  factory CopyWith$Subscription$deviceCommands(
    Subscription$deviceCommands instance,
    TRes Function(Subscription$deviceCommands) then,
  ) = _CopyWithImpl$Subscription$deviceCommands;

  factory CopyWith$Subscription$deviceCommands.stub(TRes res) =
      _CopyWithStubImpl$Subscription$deviceCommands;

  TRes call({Subscription$deviceCommands$deviceCommands? deviceCommands});
  CopyWith$Subscription$deviceCommands$deviceCommands<TRes> get deviceCommands;
}

class _CopyWithImpl$Subscription$deviceCommands<TRes>
    implements CopyWith$Subscription$deviceCommands<TRes> {
  _CopyWithImpl$Subscription$deviceCommands(this._instance, this._then);

  final Subscription$deviceCommands _instance;

  final TRes Function(Subscription$deviceCommands) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({Object? deviceCommands = _undefined}) => _then(
    Subscription$deviceCommands(
      deviceCommands: deviceCommands == _undefined || deviceCommands == null
          ? _instance.deviceCommands
          : (deviceCommands as Subscription$deviceCommands$deviceCommands),
    ),
  );

  CopyWith$Subscription$deviceCommands$deviceCommands<TRes> get deviceCommands {
    final local$deviceCommands = _instance.deviceCommands;
    return CopyWith$Subscription$deviceCommands$deviceCommands(
      local$deviceCommands,
      (e) => call(deviceCommands: e),
    );
  }
}

class _CopyWithStubImpl$Subscription$deviceCommands<TRes>
    implements CopyWith$Subscription$deviceCommands<TRes> {
  _CopyWithStubImpl$Subscription$deviceCommands(this._res);

  TRes _res;

  call({Subscription$deviceCommands$deviceCommands? deviceCommands}) => _res;

  CopyWith$Subscription$deviceCommands$deviceCommands<TRes>
  get deviceCommands =>
      CopyWith$Subscription$deviceCommands$deviceCommands.stub(_res);
}

const documentNodeSubscriptiondeviceCommands = DocumentNode(
  definitions: [
    OperationDefinitionNode(
      type: OperationType.subscription,
      name: NameNode(value: 'deviceCommands'),
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
            name: NameNode(value: 'deviceCommands'),
            alias: null,
            arguments: [
              ArgumentNode(
                name: NameNode(value: 'deviceId'),
                value: VariableNode(name: NameNode(value: 'deviceId')),
              ),
            ],
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
                  name: NameNode(value: 'command'),
                  alias: null,
                  arguments: [],
                  directives: [],
                  selectionSet: null,
                ),
                FieldNode(
                  name: NameNode(value: 'mediaType'),
                  alias: null,
                  arguments: [],
                  directives: [],
                  selectionSet: null,
                ),
                FieldNode(
                  name: NameNode(value: 'mediaId'),
                  alias: null,
                  arguments: [],
                  directives: [],
                  selectionSet: null,
                ),
                FieldNode(
                  name: NameNode(value: 'startId'),
                  alias: null,
                  arguments: [],
                  directives: [],
                  selectionSet: null,
                ),
                FieldNode(
                  name: NameNode(value: 'playQueueId'),
                  alias: null,
                  arguments: [],
                  directives: [],
                  selectionSet: null,
                ),
                FieldNode(
                  name: NameNode(value: 'positionInMilliseconds'),
                  alias: null,
                  arguments: [],
                  directives: [],
                  selectionSet: null,
                ),
                FieldNode(
                  name: NameNode(value: 'timestamp'),
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
        ],
      ),
    ),
  ],
);

class Subscription$deviceCommands$deviceCommands {
  Subscription$deviceCommands$deviceCommands({
    required this.deviceId,
    required this.command,
    this.mediaType,
    this.mediaId,
    this.startId,
    this.playQueueId,
    this.positionInMilliseconds,
    required this.timestamp,
    this.$__typename = 'DeviceCommand',
  });

  factory Subscription$deviceCommands$deviceCommands.fromJson(
    Map<String, dynamic> json,
  ) {
    final l$deviceId = json['deviceId'];
    final l$command = json['command'];
    final l$mediaType = json['mediaType'];
    final l$mediaId = json['mediaId'];
    final l$startId = json['startId'];
    final l$playQueueId = json['playQueueId'];
    final l$positionInMilliseconds = json['positionInMilliseconds'];
    final l$timestamp = json['timestamp'];
    final l$$__typename = json['__typename'];
    return Subscription$deviceCommands$deviceCommands(
      deviceId: (l$deviceId as String),
      command: fromJson$Enum$DeviceCommandType((l$command as String)),
      mediaType: l$mediaType == null
          ? null
          : fromJson$Enum$MediaType((l$mediaType as String)),
      mediaId: (l$mediaId as String?),
      startId: (l$startId as String?),
      playQueueId: (l$playQueueId as String?),
      positionInMilliseconds: (l$positionInMilliseconds as num?)?.toDouble(),
      timestamp: (l$timestamp as String),
      $__typename: (l$$__typename as String),
    );
  }

  final String deviceId;

  final Enum$DeviceCommandType command;

  final Enum$MediaType? mediaType;

  final String? mediaId;

  final String? startId;

  final String? playQueueId;

  final double? positionInMilliseconds;

  final String timestamp;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$deviceId = deviceId;
    _resultData['deviceId'] = l$deviceId;
    final l$command = command;
    _resultData['command'] = toJson$Enum$DeviceCommandType(l$command);
    final l$mediaType = mediaType;
    _resultData['mediaType'] = l$mediaType == null
        ? null
        : toJson$Enum$MediaType(l$mediaType);
    final l$mediaId = mediaId;
    _resultData['mediaId'] = l$mediaId;
    final l$startId = startId;
    _resultData['startId'] = l$startId;
    final l$playQueueId = playQueueId;
    _resultData['playQueueId'] = l$playQueueId;
    final l$positionInMilliseconds = positionInMilliseconds;
    _resultData['positionInMilliseconds'] = l$positionInMilliseconds;
    final l$timestamp = timestamp;
    _resultData['timestamp'] = l$timestamp;
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    return _resultData;
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
    final l$timestamp = timestamp;
    final l$$__typename = $__typename;
    return Object.hashAll([
      l$deviceId,
      l$command,
      l$mediaType,
      l$mediaId,
      l$startId,
      l$playQueueId,
      l$positionInMilliseconds,
      l$timestamp,
      l$$__typename,
    ]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Subscription$deviceCommands$deviceCommands ||
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
    if (l$mediaType != lOther$mediaType) {
      return false;
    }
    final l$mediaId = mediaId;
    final lOther$mediaId = other.mediaId;
    if (l$mediaId != lOther$mediaId) {
      return false;
    }
    final l$startId = startId;
    final lOther$startId = other.startId;
    if (l$startId != lOther$startId) {
      return false;
    }
    final l$playQueueId = playQueueId;
    final lOther$playQueueId = other.playQueueId;
    if (l$playQueueId != lOther$playQueueId) {
      return false;
    }
    final l$positionInMilliseconds = positionInMilliseconds;
    final lOther$positionInMilliseconds = other.positionInMilliseconds;
    if (l$positionInMilliseconds != lOther$positionInMilliseconds) {
      return false;
    }
    final l$timestamp = timestamp;
    final lOther$timestamp = other.timestamp;
    if (l$timestamp != lOther$timestamp) {
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

extension UtilityExtension$Subscription$deviceCommands$deviceCommands
    on Subscription$deviceCommands$deviceCommands {
  CopyWith$Subscription$deviceCommands$deviceCommands<
    Subscription$deviceCommands$deviceCommands
  >
  get copyWith =>
      CopyWith$Subscription$deviceCommands$deviceCommands(this, (i) => i);
}

abstract class CopyWith$Subscription$deviceCommands$deviceCommands<TRes> {
  factory CopyWith$Subscription$deviceCommands$deviceCommands(
    Subscription$deviceCommands$deviceCommands instance,
    TRes Function(Subscription$deviceCommands$deviceCommands) then,
  ) = _CopyWithImpl$Subscription$deviceCommands$deviceCommands;

  factory CopyWith$Subscription$deviceCommands$deviceCommands.stub(TRes res) =
      _CopyWithStubImpl$Subscription$deviceCommands$deviceCommands;

  TRes call({
    String? deviceId,
    Enum$DeviceCommandType? command,
    Enum$MediaType? mediaType,
    String? mediaId,
    String? startId,
    String? playQueueId,
    double? positionInMilliseconds,
    String? timestamp,
    String? $__typename,
  });
}

class _CopyWithImpl$Subscription$deviceCommands$deviceCommands<TRes>
    implements CopyWith$Subscription$deviceCommands$deviceCommands<TRes> {
  _CopyWithImpl$Subscription$deviceCommands$deviceCommands(
    this._instance,
    this._then,
  );

  final Subscription$deviceCommands$deviceCommands _instance;

  final TRes Function(Subscription$deviceCommands$deviceCommands) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? deviceId = _undefined,
    Object? command = _undefined,
    Object? mediaType = _undefined,
    Object? mediaId = _undefined,
    Object? startId = _undefined,
    Object? playQueueId = _undefined,
    Object? positionInMilliseconds = _undefined,
    Object? timestamp = _undefined,
    Object? $__typename = _undefined,
  }) => _then(
    Subscription$deviceCommands$deviceCommands(
      deviceId: deviceId == _undefined || deviceId == null
          ? _instance.deviceId
          : (deviceId as String),
      command: command == _undefined || command == null
          ? _instance.command
          : (command as Enum$DeviceCommandType),
      mediaType: mediaType == _undefined
          ? _instance.mediaType
          : (mediaType as Enum$MediaType?),
      mediaId: mediaId == _undefined ? _instance.mediaId : (mediaId as String?),
      startId: startId == _undefined ? _instance.startId : (startId as String?),
      playQueueId: playQueueId == _undefined
          ? _instance.playQueueId
          : (playQueueId as String?),
      positionInMilliseconds: positionInMilliseconds == _undefined
          ? _instance.positionInMilliseconds
          : (positionInMilliseconds as double?),
      timestamp: timestamp == _undefined || timestamp == null
          ? _instance.timestamp
          : (timestamp as String),
      $__typename: $__typename == _undefined || $__typename == null
          ? _instance.$__typename
          : ($__typename as String),
    ),
  );
}

class _CopyWithStubImpl$Subscription$deviceCommands$deviceCommands<TRes>
    implements CopyWith$Subscription$deviceCommands$deviceCommands<TRes> {
  _CopyWithStubImpl$Subscription$deviceCommands$deviceCommands(this._res);

  TRes _res;

  call({
    String? deviceId,
    Enum$DeviceCommandType? command,
    Enum$MediaType? mediaType,
    String? mediaId,
    String? startId,
    String? playQueueId,
    double? positionInMilliseconds,
    String? timestamp,
    String? $__typename,
  }) => _res;
}

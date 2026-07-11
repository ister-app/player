import 'package:gql/ast.dart';
import 'schema.graphql.dart';

class Variables$Subscription$playbackCommands {
  factory Variables$Subscription$playbackCommands({
    required String playQueueId,
  }) =>
      Variables$Subscription$playbackCommands._({r'playQueueId': playQueueId});

  Variables$Subscription$playbackCommands._(this._$data);

  factory Variables$Subscription$playbackCommands.fromJson(
    Map<String, dynamic> data,
  ) {
    final result$data = <String, dynamic>{};
    final l$playQueueId = data['playQueueId'];
    result$data['playQueueId'] = (l$playQueueId as String);
    return Variables$Subscription$playbackCommands._(result$data);
  }

  Map<String, dynamic> _$data;

  String get playQueueId => (_$data['playQueueId'] as String);

  Map<String, dynamic> toJson() {
    final result$data = <String, dynamic>{};
    final l$playQueueId = playQueueId;
    result$data['playQueueId'] = l$playQueueId;
    return result$data;
  }

  CopyWith$Variables$Subscription$playbackCommands<
    Variables$Subscription$playbackCommands
  >
  get copyWith =>
      CopyWith$Variables$Subscription$playbackCommands(this, (i) => i);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Variables$Subscription$playbackCommands ||
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

abstract class CopyWith$Variables$Subscription$playbackCommands<TRes> {
  factory CopyWith$Variables$Subscription$playbackCommands(
    Variables$Subscription$playbackCommands instance,
    TRes Function(Variables$Subscription$playbackCommands) then,
  ) = _CopyWithImpl$Variables$Subscription$playbackCommands;

  factory CopyWith$Variables$Subscription$playbackCommands.stub(TRes res) =
      _CopyWithStubImpl$Variables$Subscription$playbackCommands;

  TRes call({String? playQueueId});
}

class _CopyWithImpl$Variables$Subscription$playbackCommands<TRes>
    implements CopyWith$Variables$Subscription$playbackCommands<TRes> {
  _CopyWithImpl$Variables$Subscription$playbackCommands(
    this._instance,
    this._then,
  );

  final Variables$Subscription$playbackCommands _instance;

  final TRes Function(Variables$Subscription$playbackCommands) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({Object? playQueueId = _undefined}) => _then(
    Variables$Subscription$playbackCommands._({
      ..._instance._$data,
      if (playQueueId != _undefined && playQueueId != null)
        'playQueueId': (playQueueId as String),
    }),
  );
}

class _CopyWithStubImpl$Variables$Subscription$playbackCommands<TRes>
    implements CopyWith$Variables$Subscription$playbackCommands<TRes> {
  _CopyWithStubImpl$Variables$Subscription$playbackCommands(this._res);

  TRes _res;

  call({String? playQueueId}) => _res;
}

class Subscription$playbackCommands {
  Subscription$playbackCommands({required this.playbackCommands});

  factory Subscription$playbackCommands.fromJson(Map<String, dynamic> json) {
    final l$playbackCommands = json['playbackCommands'];
    return Subscription$playbackCommands(
      playbackCommands: Subscription$playbackCommands$playbackCommands.fromJson(
        (l$playbackCommands as Map<String, dynamic>),
      ),
    );
  }

  final Subscription$playbackCommands$playbackCommands playbackCommands;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$playbackCommands = playbackCommands;
    _resultData['playbackCommands'] = l$playbackCommands.toJson();
    return _resultData;
  }

  @override
  int get hashCode {
    final l$playbackCommands = playbackCommands;
    return Object.hashAll([l$playbackCommands]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Subscription$playbackCommands ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$playbackCommands = playbackCommands;
    final lOther$playbackCommands = other.playbackCommands;
    if (l$playbackCommands != lOther$playbackCommands) {
      return false;
    }
    return true;
  }
}

extension UtilityExtension$Subscription$playbackCommands
    on Subscription$playbackCommands {
  CopyWith$Subscription$playbackCommands<Subscription$playbackCommands>
  get copyWith => CopyWith$Subscription$playbackCommands(this, (i) => i);
}

abstract class CopyWith$Subscription$playbackCommands<TRes> {
  factory CopyWith$Subscription$playbackCommands(
    Subscription$playbackCommands instance,
    TRes Function(Subscription$playbackCommands) then,
  ) = _CopyWithImpl$Subscription$playbackCommands;

  factory CopyWith$Subscription$playbackCommands.stub(TRes res) =
      _CopyWithStubImpl$Subscription$playbackCommands;

  TRes call({Subscription$playbackCommands$playbackCommands? playbackCommands});
  CopyWith$Subscription$playbackCommands$playbackCommands<TRes>
  get playbackCommands;
}

class _CopyWithImpl$Subscription$playbackCommands<TRes>
    implements CopyWith$Subscription$playbackCommands<TRes> {
  _CopyWithImpl$Subscription$playbackCommands(this._instance, this._then);

  final Subscription$playbackCommands _instance;

  final TRes Function(Subscription$playbackCommands) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({Object? playbackCommands = _undefined}) => _then(
    Subscription$playbackCommands(
      playbackCommands:
          playbackCommands == _undefined || playbackCommands == null
          ? _instance.playbackCommands
          : (playbackCommands
                as Subscription$playbackCommands$playbackCommands),
    ),
  );

  CopyWith$Subscription$playbackCommands$playbackCommands<TRes>
  get playbackCommands {
    final local$playbackCommands = _instance.playbackCommands;
    return CopyWith$Subscription$playbackCommands$playbackCommands(
      local$playbackCommands,
      (e) => call(playbackCommands: e),
    );
  }
}

class _CopyWithStubImpl$Subscription$playbackCommands<TRes>
    implements CopyWith$Subscription$playbackCommands<TRes> {
  _CopyWithStubImpl$Subscription$playbackCommands(this._res);

  TRes _res;

  call({Subscription$playbackCommands$playbackCommands? playbackCommands}) =>
      _res;

  CopyWith$Subscription$playbackCommands$playbackCommands<TRes>
  get playbackCommands =>
      CopyWith$Subscription$playbackCommands$playbackCommands.stub(_res);
}

const documentNodeSubscriptionplaybackCommands = DocumentNode(
  definitions: [
    OperationDefinitionNode(
      type: OperationType.subscription,
      name: NameNode(value: 'playbackCommands'),
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
            name: NameNode(value: 'playbackCommands'),
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
                  name: NameNode(value: 'playQueueId'),
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
                  name: NameNode(value: 'positionInMilliseconds'),
                  alias: null,
                  arguments: [],
                  directives: [],
                  selectionSet: null,
                ),
                FieldNode(
                  name: NameNode(value: 'playQueueItemId'),
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

class Subscription$playbackCommands$playbackCommands {
  Subscription$playbackCommands$playbackCommands({
    required this.playQueueId,
    required this.command,
    this.positionInMilliseconds,
    this.playQueueItemId,
    required this.timestamp,
    this.$__typename = 'PlaybackCommand',
  });

  factory Subscription$playbackCommands$playbackCommands.fromJson(
    Map<String, dynamic> json,
  ) {
    final l$playQueueId = json['playQueueId'];
    final l$command = json['command'];
    final l$positionInMilliseconds = json['positionInMilliseconds'];
    final l$playQueueItemId = json['playQueueItemId'];
    final l$timestamp = json['timestamp'];
    final l$$__typename = json['__typename'];
    return Subscription$playbackCommands$playbackCommands(
      playQueueId: (l$playQueueId as String),
      command: fromJson$Enum$PlaybackCommandType((l$command as String)),
      positionInMilliseconds: (l$positionInMilliseconds as int?),
      playQueueItemId: (l$playQueueItemId as String?),
      timestamp: (l$timestamp as String),
      $__typename: (l$$__typename as String),
    );
  }

  final String playQueueId;

  final Enum$PlaybackCommandType command;

  final int? positionInMilliseconds;

  final String? playQueueItemId;

  final String timestamp;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$playQueueId = playQueueId;
    _resultData['playQueueId'] = l$playQueueId;
    final l$command = command;
    _resultData['command'] = toJson$Enum$PlaybackCommandType(l$command);
    final l$positionInMilliseconds = positionInMilliseconds;
    _resultData['positionInMilliseconds'] = l$positionInMilliseconds;
    final l$playQueueItemId = playQueueItemId;
    _resultData['playQueueItemId'] = l$playQueueItemId;
    final l$timestamp = timestamp;
    _resultData['timestamp'] = l$timestamp;
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$playQueueId = playQueueId;
    final l$command = command;
    final l$positionInMilliseconds = positionInMilliseconds;
    final l$playQueueItemId = playQueueItemId;
    final l$timestamp = timestamp;
    final l$$__typename = $__typename;
    return Object.hashAll([
      l$playQueueId,
      l$command,
      l$positionInMilliseconds,
      l$playQueueItemId,
      l$timestamp,
      l$$__typename,
    ]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Subscription$playbackCommands$playbackCommands ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$playQueueId = playQueueId;
    final lOther$playQueueId = other.playQueueId;
    if (l$playQueueId != lOther$playQueueId) {
      return false;
    }
    final l$command = command;
    final lOther$command = other.command;
    if (l$command != lOther$command) {
      return false;
    }
    final l$positionInMilliseconds = positionInMilliseconds;
    final lOther$positionInMilliseconds = other.positionInMilliseconds;
    if (l$positionInMilliseconds != lOther$positionInMilliseconds) {
      return false;
    }
    final l$playQueueItemId = playQueueItemId;
    final lOther$playQueueItemId = other.playQueueItemId;
    if (l$playQueueItemId != lOther$playQueueItemId) {
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

extension UtilityExtension$Subscription$playbackCommands$playbackCommands
    on Subscription$playbackCommands$playbackCommands {
  CopyWith$Subscription$playbackCommands$playbackCommands<
    Subscription$playbackCommands$playbackCommands
  >
  get copyWith =>
      CopyWith$Subscription$playbackCommands$playbackCommands(this, (i) => i);
}

abstract class CopyWith$Subscription$playbackCommands$playbackCommands<TRes> {
  factory CopyWith$Subscription$playbackCommands$playbackCommands(
    Subscription$playbackCommands$playbackCommands instance,
    TRes Function(Subscription$playbackCommands$playbackCommands) then,
  ) = _CopyWithImpl$Subscription$playbackCommands$playbackCommands;

  factory CopyWith$Subscription$playbackCommands$playbackCommands.stub(
    TRes res,
  ) = _CopyWithStubImpl$Subscription$playbackCommands$playbackCommands;

  TRes call({
    String? playQueueId,
    Enum$PlaybackCommandType? command,
    int? positionInMilliseconds,
    String? playQueueItemId,
    String? timestamp,
    String? $__typename,
  });
}

class _CopyWithImpl$Subscription$playbackCommands$playbackCommands<TRes>
    implements CopyWith$Subscription$playbackCommands$playbackCommands<TRes> {
  _CopyWithImpl$Subscription$playbackCommands$playbackCommands(
    this._instance,
    this._then,
  );

  final Subscription$playbackCommands$playbackCommands _instance;

  final TRes Function(Subscription$playbackCommands$playbackCommands) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? playQueueId = _undefined,
    Object? command = _undefined,
    Object? positionInMilliseconds = _undefined,
    Object? playQueueItemId = _undefined,
    Object? timestamp = _undefined,
    Object? $__typename = _undefined,
  }) => _then(
    Subscription$playbackCommands$playbackCommands(
      playQueueId: playQueueId == _undefined || playQueueId == null
          ? _instance.playQueueId
          : (playQueueId as String),
      command: command == _undefined || command == null
          ? _instance.command
          : (command as Enum$PlaybackCommandType),
      positionInMilliseconds: positionInMilliseconds == _undefined
          ? _instance.positionInMilliseconds
          : (positionInMilliseconds as int?),
      playQueueItemId: playQueueItemId == _undefined
          ? _instance.playQueueItemId
          : (playQueueItemId as String?),
      timestamp: timestamp == _undefined || timestamp == null
          ? _instance.timestamp
          : (timestamp as String),
      $__typename: $__typename == _undefined || $__typename == null
          ? _instance.$__typename
          : ($__typename as String),
    ),
  );
}

class _CopyWithStubImpl$Subscription$playbackCommands$playbackCommands<TRes>
    implements CopyWith$Subscription$playbackCommands$playbackCommands<TRes> {
  _CopyWithStubImpl$Subscription$playbackCommands$playbackCommands(this._res);

  TRes _res;

  call({
    String? playQueueId,
    Enum$PlaybackCommandType? command,
    int? positionInMilliseconds,
    String? playQueueItemId,
    String? timestamp,
    String? $__typename,
  }) => _res;
}

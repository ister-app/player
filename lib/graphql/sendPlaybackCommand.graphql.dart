import 'package:gql/ast.dart';
import 'schema.graphql.dart';

class Variables$Mutation$sendPlaybackCommand {
  factory Variables$Mutation$sendPlaybackCommand({
    required String playQueueId,
    required Enum$PlaybackCommandType command,
    int? positionInMilliseconds,
    String? playQueueItemId,
  }) => Variables$Mutation$sendPlaybackCommand._({
    r'playQueueId': playQueueId,
    r'command': command,
    if (positionInMilliseconds != null)
      r'positionInMilliseconds': positionInMilliseconds,
    if (playQueueItemId != null) r'playQueueItemId': playQueueItemId,
  });

  Variables$Mutation$sendPlaybackCommand._(this._$data);

  factory Variables$Mutation$sendPlaybackCommand.fromJson(
    Map<String, dynamic> data,
  ) {
    final result$data = <String, dynamic>{};
    final l$playQueueId = data['playQueueId'];
    result$data['playQueueId'] = (l$playQueueId as String);
    final l$command = data['command'];
    result$data['command'] = fromJson$Enum$PlaybackCommandType(
      (l$command as String),
    );
    if (data.containsKey('positionInMilliseconds')) {
      final l$positionInMilliseconds = data['positionInMilliseconds'];
      result$data['positionInMilliseconds'] =
          (l$positionInMilliseconds as int?);
    }
    if (data.containsKey('playQueueItemId')) {
      final l$playQueueItemId = data['playQueueItemId'];
      result$data['playQueueItemId'] = (l$playQueueItemId as String?);
    }
    return Variables$Mutation$sendPlaybackCommand._(result$data);
  }

  Map<String, dynamic> _$data;

  String get playQueueId => (_$data['playQueueId'] as String);

  Enum$PlaybackCommandType get command =>
      (_$data['command'] as Enum$PlaybackCommandType);

  int? get positionInMilliseconds => (_$data['positionInMilliseconds'] as int?);

  String? get playQueueItemId => (_$data['playQueueItemId'] as String?);

  Map<String, dynamic> toJson() {
    final result$data = <String, dynamic>{};
    final l$playQueueId = playQueueId;
    result$data['playQueueId'] = l$playQueueId;
    final l$command = command;
    result$data['command'] = toJson$Enum$PlaybackCommandType(l$command);
    if (_$data.containsKey('positionInMilliseconds')) {
      final l$positionInMilliseconds = positionInMilliseconds;
      result$data['positionInMilliseconds'] = l$positionInMilliseconds;
    }
    if (_$data.containsKey('playQueueItemId')) {
      final l$playQueueItemId = playQueueItemId;
      result$data['playQueueItemId'] = l$playQueueItemId;
    }
    return result$data;
  }

  CopyWith$Variables$Mutation$sendPlaybackCommand<
    Variables$Mutation$sendPlaybackCommand
  >
  get copyWith =>
      CopyWith$Variables$Mutation$sendPlaybackCommand(this, (i) => i);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Variables$Mutation$sendPlaybackCommand ||
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
    if (_$data.containsKey('positionInMilliseconds') !=
        other._$data.containsKey('positionInMilliseconds')) {
      return false;
    }
    if (l$positionInMilliseconds != lOther$positionInMilliseconds) {
      return false;
    }
    final l$playQueueItemId = playQueueItemId;
    final lOther$playQueueItemId = other.playQueueItemId;
    if (_$data.containsKey('playQueueItemId') !=
        other._$data.containsKey('playQueueItemId')) {
      return false;
    }
    if (l$playQueueItemId != lOther$playQueueItemId) {
      return false;
    }
    return true;
  }

  @override
  int get hashCode {
    final l$playQueueId = playQueueId;
    final l$command = command;
    final l$positionInMilliseconds = positionInMilliseconds;
    final l$playQueueItemId = playQueueItemId;
    return Object.hashAll([
      l$playQueueId,
      l$command,
      _$data.containsKey('positionInMilliseconds')
          ? l$positionInMilliseconds
          : const {},
      _$data.containsKey('playQueueItemId') ? l$playQueueItemId : const {},
    ]);
  }
}

abstract class CopyWith$Variables$Mutation$sendPlaybackCommand<TRes> {
  factory CopyWith$Variables$Mutation$sendPlaybackCommand(
    Variables$Mutation$sendPlaybackCommand instance,
    TRes Function(Variables$Mutation$sendPlaybackCommand) then,
  ) = _CopyWithImpl$Variables$Mutation$sendPlaybackCommand;

  factory CopyWith$Variables$Mutation$sendPlaybackCommand.stub(TRes res) =
      _CopyWithStubImpl$Variables$Mutation$sendPlaybackCommand;

  TRes call({
    String? playQueueId,
    Enum$PlaybackCommandType? command,
    int? positionInMilliseconds,
    String? playQueueItemId,
  });
}

class _CopyWithImpl$Variables$Mutation$sendPlaybackCommand<TRes>
    implements CopyWith$Variables$Mutation$sendPlaybackCommand<TRes> {
  _CopyWithImpl$Variables$Mutation$sendPlaybackCommand(
    this._instance,
    this._then,
  );

  final Variables$Mutation$sendPlaybackCommand _instance;

  final TRes Function(Variables$Mutation$sendPlaybackCommand) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? playQueueId = _undefined,
    Object? command = _undefined,
    Object? positionInMilliseconds = _undefined,
    Object? playQueueItemId = _undefined,
  }) => _then(
    Variables$Mutation$sendPlaybackCommand._({
      ..._instance._$data,
      if (playQueueId != _undefined && playQueueId != null)
        'playQueueId': (playQueueId as String),
      if (command != _undefined && command != null)
        'command': (command as Enum$PlaybackCommandType),
      if (positionInMilliseconds != _undefined)
        'positionInMilliseconds': (positionInMilliseconds as int?),
      if (playQueueItemId != _undefined)
        'playQueueItemId': (playQueueItemId as String?),
    }),
  );
}

class _CopyWithStubImpl$Variables$Mutation$sendPlaybackCommand<TRes>
    implements CopyWith$Variables$Mutation$sendPlaybackCommand<TRes> {
  _CopyWithStubImpl$Variables$Mutation$sendPlaybackCommand(this._res);

  TRes _res;

  call({
    String? playQueueId,
    Enum$PlaybackCommandType? command,
    int? positionInMilliseconds,
    String? playQueueItemId,
  }) => _res;
}

class Mutation$sendPlaybackCommand {
  Mutation$sendPlaybackCommand({
    required this.sendPlaybackCommand,
    this.$__typename = 'Mutation',
  });

  factory Mutation$sendPlaybackCommand.fromJson(Map<String, dynamic> json) {
    final l$sendPlaybackCommand = json['sendPlaybackCommand'];
    final l$$__typename = json['__typename'];
    return Mutation$sendPlaybackCommand(
      sendPlaybackCommand: (l$sendPlaybackCommand as bool),
      $__typename: (l$$__typename as String),
    );
  }

  final bool sendPlaybackCommand;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$sendPlaybackCommand = sendPlaybackCommand;
    _resultData['sendPlaybackCommand'] = l$sendPlaybackCommand;
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$sendPlaybackCommand = sendPlaybackCommand;
    final l$$__typename = $__typename;
    return Object.hashAll([l$sendPlaybackCommand, l$$__typename]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Mutation$sendPlaybackCommand ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$sendPlaybackCommand = sendPlaybackCommand;
    final lOther$sendPlaybackCommand = other.sendPlaybackCommand;
    if (l$sendPlaybackCommand != lOther$sendPlaybackCommand) {
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

extension UtilityExtension$Mutation$sendPlaybackCommand
    on Mutation$sendPlaybackCommand {
  CopyWith$Mutation$sendPlaybackCommand<Mutation$sendPlaybackCommand>
  get copyWith => CopyWith$Mutation$sendPlaybackCommand(this, (i) => i);
}

abstract class CopyWith$Mutation$sendPlaybackCommand<TRes> {
  factory CopyWith$Mutation$sendPlaybackCommand(
    Mutation$sendPlaybackCommand instance,
    TRes Function(Mutation$sendPlaybackCommand) then,
  ) = _CopyWithImpl$Mutation$sendPlaybackCommand;

  factory CopyWith$Mutation$sendPlaybackCommand.stub(TRes res) =
      _CopyWithStubImpl$Mutation$sendPlaybackCommand;

  TRes call({bool? sendPlaybackCommand, String? $__typename});
}

class _CopyWithImpl$Mutation$sendPlaybackCommand<TRes>
    implements CopyWith$Mutation$sendPlaybackCommand<TRes> {
  _CopyWithImpl$Mutation$sendPlaybackCommand(this._instance, this._then);

  final Mutation$sendPlaybackCommand _instance;

  final TRes Function(Mutation$sendPlaybackCommand) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? sendPlaybackCommand = _undefined,
    Object? $__typename = _undefined,
  }) => _then(
    Mutation$sendPlaybackCommand(
      sendPlaybackCommand:
          sendPlaybackCommand == _undefined || sendPlaybackCommand == null
          ? _instance.sendPlaybackCommand
          : (sendPlaybackCommand as bool),
      $__typename: $__typename == _undefined || $__typename == null
          ? _instance.$__typename
          : ($__typename as String),
    ),
  );
}

class _CopyWithStubImpl$Mutation$sendPlaybackCommand<TRes>
    implements CopyWith$Mutation$sendPlaybackCommand<TRes> {
  _CopyWithStubImpl$Mutation$sendPlaybackCommand(this._res);

  TRes _res;

  call({bool? sendPlaybackCommand, String? $__typename}) => _res;
}

const documentNodeMutationsendPlaybackCommand = DocumentNode(
  definitions: [
    OperationDefinitionNode(
      type: OperationType.mutation,
      name: NameNode(value: 'sendPlaybackCommand'),
      variableDefinitions: [
        VariableDefinitionNode(
          variable: VariableNode(name: NameNode(value: 'playQueueId')),
          type: NamedTypeNode(name: NameNode(value: 'ID'), isNonNull: true),
          defaultValue: DefaultValueNode(value: null),
          directives: [],
        ),
        VariableDefinitionNode(
          variable: VariableNode(name: NameNode(value: 'command')),
          type: NamedTypeNode(
            name: NameNode(value: 'PlaybackCommandType'),
            isNonNull: true,
          ),
          defaultValue: DefaultValueNode(value: null),
          directives: [],
        ),
        VariableDefinitionNode(
          variable: VariableNode(
            name: NameNode(value: 'positionInMilliseconds'),
          ),
          type: NamedTypeNode(name: NameNode(value: 'Int'), isNonNull: false),
          defaultValue: DefaultValueNode(value: null),
          directives: [],
        ),
        VariableDefinitionNode(
          variable: VariableNode(name: NameNode(value: 'playQueueItemId')),
          type: NamedTypeNode(name: NameNode(value: 'ID'), isNonNull: false),
          defaultValue: DefaultValueNode(value: null),
          directives: [],
        ),
      ],
      directives: [],
      selectionSet: SelectionSetNode(
        selections: [
          FieldNode(
            name: NameNode(value: 'sendPlaybackCommand'),
            alias: null,
            arguments: [
              ArgumentNode(
                name: NameNode(value: 'playQueueId'),
                value: VariableNode(name: NameNode(value: 'playQueueId')),
              ),
              ArgumentNode(
                name: NameNode(value: 'command'),
                value: VariableNode(name: NameNode(value: 'command')),
              ),
              ArgumentNode(
                name: NameNode(value: 'positionInMilliseconds'),
                value: VariableNode(
                  name: NameNode(value: 'positionInMilliseconds'),
                ),
              ),
              ArgumentNode(
                name: NameNode(value: 'playQueueItemId'),
                value: VariableNode(name: NameNode(value: 'playQueueItemId')),
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

import 'package:gql/ast.dart';

import 'schema.graphql.dart';

class Variables$Mutation$followPlayQueue {
  factory Variables$Mutation$followPlayQueue({
    required String playQueueId,
    required String deviceId,
    required bool active,
  }) => Variables$Mutation$followPlayQueue._({
    r'playQueueId': playQueueId,
    r'deviceId': deviceId,
    r'active': active,
  });

  Variables$Mutation$followPlayQueue._(this._$data);

  factory Variables$Mutation$followPlayQueue.fromJson(
    Map<String, dynamic> data,
  ) {
    final result$data = <String, dynamic>{};
    final l$playQueueId = data['playQueueId'];
    result$data['playQueueId'] = (l$playQueueId as String);
    final l$deviceId = data['deviceId'];
    result$data['deviceId'] = (l$deviceId as String);
    final l$active = data['active'];
    result$data['active'] = (l$active as bool);
    return Variables$Mutation$followPlayQueue._(result$data);
  }

  Map<String, dynamic> _$data;

  String get playQueueId => (_$data['playQueueId'] as String);

  String get deviceId => (_$data['deviceId'] as String);

  bool get active => (_$data['active'] as bool);

  Map<String, dynamic> toJson() {
    final result$data = <String, dynamic>{};
    final l$playQueueId = playQueueId;
    result$data['playQueueId'] = l$playQueueId;
    final l$deviceId = deviceId;
    result$data['deviceId'] = l$deviceId;
    final l$active = active;
    result$data['active'] = l$active;
    return result$data;
  }

  CopyWith$Variables$Mutation$followPlayQueue<
    Variables$Mutation$followPlayQueue
  >
  get copyWith => CopyWith$Variables$Mutation$followPlayQueue(this, (i) => i);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Variables$Mutation$followPlayQueue ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$playQueueId = playQueueId;
    final lOther$playQueueId = other.playQueueId;
    if (l$playQueueId != lOther$playQueueId) {
      return false;
    }
    final l$deviceId = deviceId;
    final lOther$deviceId = other.deviceId;
    if (l$deviceId != lOther$deviceId) {
      return false;
    }
    final l$active = active;
    final lOther$active = other.active;
    if (l$active != lOther$active) {
      return false;
    }
    return true;
  }

  @override
  int get hashCode {
    final l$playQueueId = playQueueId;
    final l$deviceId = deviceId;
    final l$active = active;
    return Object.hashAll([l$playQueueId, l$deviceId, l$active]);
  }
}

abstract class CopyWith$Variables$Mutation$followPlayQueue<TRes> {
  factory CopyWith$Variables$Mutation$followPlayQueue(
    Variables$Mutation$followPlayQueue instance,
    TRes Function(Variables$Mutation$followPlayQueue) then,
  ) = _CopyWithImpl$Variables$Mutation$followPlayQueue;

  factory CopyWith$Variables$Mutation$followPlayQueue.stub(TRes res) =
      _CopyWithStubImpl$Variables$Mutation$followPlayQueue;

  TRes call({String? playQueueId, String? deviceId, bool? active});
}

class _CopyWithImpl$Variables$Mutation$followPlayQueue<TRes>
    implements CopyWith$Variables$Mutation$followPlayQueue<TRes> {
  _CopyWithImpl$Variables$Mutation$followPlayQueue(this._instance, this._then);

  final Variables$Mutation$followPlayQueue _instance;

  final TRes Function(Variables$Mutation$followPlayQueue) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? playQueueId = _undefined,
    Object? deviceId = _undefined,
    Object? active = _undefined,
  }) => _then(
    Variables$Mutation$followPlayQueue._({
      ..._instance._$data,
      if (playQueueId != _undefined && playQueueId != null)
        'playQueueId': (playQueueId as String),
      if (deviceId != _undefined && deviceId != null)
        'deviceId': (deviceId as String),
      if (active != _undefined && active != null) 'active': (active as bool),
    }),
  );
}

class _CopyWithStubImpl$Variables$Mutation$followPlayQueue<TRes>
    implements CopyWith$Variables$Mutation$followPlayQueue<TRes> {
  _CopyWithStubImpl$Variables$Mutation$followPlayQueue(this._res);

  TRes _res;

  call({String? playQueueId, String? deviceId, bool? active}) => _res;
}

class Mutation$followPlayQueue {
  Mutation$followPlayQueue({
    required this.followPlayQueue,
    this.$__typename = 'Mutation',
  });

  factory Mutation$followPlayQueue.fromJson(Map<String, dynamic> json) {
    final l$followPlayQueue = json['followPlayQueue'];
    final l$$__typename = json['__typename'];
    return Mutation$followPlayQueue(
      followPlayQueue: fromJson$Enum$FollowResult(
        (l$followPlayQueue as String),
      ),
      $__typename: (l$$__typename as String),
    );
  }

  final Enum$FollowResult followPlayQueue;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$followPlayQueue = followPlayQueue;
    _resultData['followPlayQueue'] = toJson$Enum$FollowResult(
      l$followPlayQueue,
    );
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$followPlayQueue = followPlayQueue;
    final l$$__typename = $__typename;
    return Object.hashAll([l$followPlayQueue, l$$__typename]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Mutation$followPlayQueue ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$followPlayQueue = followPlayQueue;
    final lOther$followPlayQueue = other.followPlayQueue;
    if (l$followPlayQueue != lOther$followPlayQueue) {
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

extension UtilityExtension$Mutation$followPlayQueue
    on Mutation$followPlayQueue {
  CopyWith$Mutation$followPlayQueue<Mutation$followPlayQueue> get copyWith =>
      CopyWith$Mutation$followPlayQueue(this, (i) => i);
}

abstract class CopyWith$Mutation$followPlayQueue<TRes> {
  factory CopyWith$Mutation$followPlayQueue(
    Mutation$followPlayQueue instance,
    TRes Function(Mutation$followPlayQueue) then,
  ) = _CopyWithImpl$Mutation$followPlayQueue;

  factory CopyWith$Mutation$followPlayQueue.stub(TRes res) =
      _CopyWithStubImpl$Mutation$followPlayQueue;

  TRes call({Enum$FollowResult? followPlayQueue, String? $__typename});
}

class _CopyWithImpl$Mutation$followPlayQueue<TRes>
    implements CopyWith$Mutation$followPlayQueue<TRes> {
  _CopyWithImpl$Mutation$followPlayQueue(this._instance, this._then);

  final Mutation$followPlayQueue _instance;

  final TRes Function(Mutation$followPlayQueue) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? followPlayQueue = _undefined,
    Object? $__typename = _undefined,
  }) => _then(
    Mutation$followPlayQueue(
      followPlayQueue: followPlayQueue == _undefined || followPlayQueue == null
          ? _instance.followPlayQueue
          : (followPlayQueue as Enum$FollowResult),
      $__typename: $__typename == _undefined || $__typename == null
          ? _instance.$__typename
          : ($__typename as String),
    ),
  );
}

class _CopyWithStubImpl$Mutation$followPlayQueue<TRes>
    implements CopyWith$Mutation$followPlayQueue<TRes> {
  _CopyWithStubImpl$Mutation$followPlayQueue(this._res);

  TRes _res;

  call({Enum$FollowResult? followPlayQueue, String? $__typename}) => _res;
}

const documentNodeMutationfollowPlayQueue = DocumentNode(
  definitions: [
    OperationDefinitionNode(
      type: OperationType.mutation,
      name: NameNode(value: 'followPlayQueue'),
      variableDefinitions: [
        VariableDefinitionNode(
          variable: VariableNode(name: NameNode(value: 'playQueueId')),
          type: NamedTypeNode(name: NameNode(value: 'ID'), isNonNull: true),
          defaultValue: DefaultValueNode(value: null),
          directives: [],
        ),
        VariableDefinitionNode(
          variable: VariableNode(name: NameNode(value: 'deviceId')),
          type: NamedTypeNode(name: NameNode(value: 'String'), isNonNull: true),
          defaultValue: DefaultValueNode(value: null),
          directives: [],
        ),
        VariableDefinitionNode(
          variable: VariableNode(name: NameNode(value: 'active')),
          type: NamedTypeNode(
            name: NameNode(value: 'Boolean'),
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
            name: NameNode(value: 'followPlayQueue'),
            alias: null,
            arguments: [
              ArgumentNode(
                name: NameNode(value: 'playQueueId'),
                value: VariableNode(name: NameNode(value: 'playQueueId')),
              ),
              ArgumentNode(
                name: NameNode(value: 'deviceId'),
                value: VariableNode(name: NameNode(value: 'deviceId')),
              ),
              ArgumentNode(
                name: NameNode(value: 'active'),
                value: VariableNode(name: NameNode(value: 'active')),
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

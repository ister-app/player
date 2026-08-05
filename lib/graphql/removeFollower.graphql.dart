import 'package:gql/ast.dart';

class Variables$Mutation$removeFollower {
  factory Variables$Mutation$removeFollower({
    required String playQueueId,
    required String userId,
    String? deviceId,
  }) => Variables$Mutation$removeFollower._({
    r'playQueueId': playQueueId,
    r'userId': userId,
    if (deviceId != null) r'deviceId': deviceId,
  });

  Variables$Mutation$removeFollower._(this._$data);

  factory Variables$Mutation$removeFollower.fromJson(
    Map<String, dynamic> data,
  ) {
    final result$data = <String, dynamic>{};
    final l$playQueueId = data['playQueueId'];
    result$data['playQueueId'] = (l$playQueueId as String);
    final l$userId = data['userId'];
    result$data['userId'] = (l$userId as String);
    if (data.containsKey('deviceId')) {
      final l$deviceId = data['deviceId'];
      result$data['deviceId'] = (l$deviceId as String?);
    }
    return Variables$Mutation$removeFollower._(result$data);
  }

  Map<String, dynamic> _$data;

  String get playQueueId => (_$data['playQueueId'] as String);

  String get userId => (_$data['userId'] as String);

  String? get deviceId => (_$data['deviceId'] as String?);

  Map<String, dynamic> toJson() {
    final result$data = <String, dynamic>{};
    final l$playQueueId = playQueueId;
    result$data['playQueueId'] = l$playQueueId;
    final l$userId = userId;
    result$data['userId'] = l$userId;
    if (_$data.containsKey('deviceId')) {
      final l$deviceId = deviceId;
      result$data['deviceId'] = l$deviceId;
    }
    return result$data;
  }

  CopyWith$Variables$Mutation$removeFollower<Variables$Mutation$removeFollower>
  get copyWith => CopyWith$Variables$Mutation$removeFollower(this, (i) => i);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Variables$Mutation$removeFollower ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$playQueueId = playQueueId;
    final lOther$playQueueId = other.playQueueId;
    if (l$playQueueId != lOther$playQueueId) {
      return false;
    }
    final l$userId = userId;
    final lOther$userId = other.userId;
    if (l$userId != lOther$userId) {
      return false;
    }
    final l$deviceId = deviceId;
    final lOther$deviceId = other.deviceId;
    if (_$data.containsKey('deviceId') !=
        other._$data.containsKey('deviceId')) {
      return false;
    }
    if (l$deviceId != lOther$deviceId) {
      return false;
    }
    return true;
  }

  @override
  int get hashCode {
    final l$playQueueId = playQueueId;
    final l$userId = userId;
    final l$deviceId = deviceId;
    return Object.hashAll([
      l$playQueueId,
      l$userId,
      _$data.containsKey('deviceId') ? l$deviceId : const {},
    ]);
  }
}

abstract class CopyWith$Variables$Mutation$removeFollower<TRes> {
  factory CopyWith$Variables$Mutation$removeFollower(
    Variables$Mutation$removeFollower instance,
    TRes Function(Variables$Mutation$removeFollower) then,
  ) = _CopyWithImpl$Variables$Mutation$removeFollower;

  factory CopyWith$Variables$Mutation$removeFollower.stub(TRes res) =
      _CopyWithStubImpl$Variables$Mutation$removeFollower;

  TRes call({String? playQueueId, String? userId, String? deviceId});
}

class _CopyWithImpl$Variables$Mutation$removeFollower<TRes>
    implements CopyWith$Variables$Mutation$removeFollower<TRes> {
  _CopyWithImpl$Variables$Mutation$removeFollower(this._instance, this._then);

  final Variables$Mutation$removeFollower _instance;

  final TRes Function(Variables$Mutation$removeFollower) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? playQueueId = _undefined,
    Object? userId = _undefined,
    Object? deviceId = _undefined,
  }) => _then(
    Variables$Mutation$removeFollower._({
      ..._instance._$data,
      if (playQueueId != _undefined && playQueueId != null)
        'playQueueId': (playQueueId as String),
      if (userId != _undefined && userId != null) 'userId': (userId as String),
      if (deviceId != _undefined) 'deviceId': (deviceId as String?),
    }),
  );
}

class _CopyWithStubImpl$Variables$Mutation$removeFollower<TRes>
    implements CopyWith$Variables$Mutation$removeFollower<TRes> {
  _CopyWithStubImpl$Variables$Mutation$removeFollower(this._res);

  TRes _res;

  call({String? playQueueId, String? userId, String? deviceId}) => _res;
}

class Mutation$removeFollower {
  Mutation$removeFollower({
    required this.removeFollower,
    this.$__typename = 'Mutation',
  });

  factory Mutation$removeFollower.fromJson(Map<String, dynamic> json) {
    final l$removeFollower = json['removeFollower'];
    final l$$__typename = json['__typename'];
    return Mutation$removeFollower(
      removeFollower: (l$removeFollower as bool),
      $__typename: (l$$__typename as String),
    );
  }

  final bool removeFollower;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$removeFollower = removeFollower;
    _resultData['removeFollower'] = l$removeFollower;
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$removeFollower = removeFollower;
    final l$$__typename = $__typename;
    return Object.hashAll([l$removeFollower, l$$__typename]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Mutation$removeFollower || runtimeType != other.runtimeType) {
      return false;
    }
    final l$removeFollower = removeFollower;
    final lOther$removeFollower = other.removeFollower;
    if (l$removeFollower != lOther$removeFollower) {
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

extension UtilityExtension$Mutation$removeFollower on Mutation$removeFollower {
  CopyWith$Mutation$removeFollower<Mutation$removeFollower> get copyWith =>
      CopyWith$Mutation$removeFollower(this, (i) => i);
}

abstract class CopyWith$Mutation$removeFollower<TRes> {
  factory CopyWith$Mutation$removeFollower(
    Mutation$removeFollower instance,
    TRes Function(Mutation$removeFollower) then,
  ) = _CopyWithImpl$Mutation$removeFollower;

  factory CopyWith$Mutation$removeFollower.stub(TRes res) =
      _CopyWithStubImpl$Mutation$removeFollower;

  TRes call({bool? removeFollower, String? $__typename});
}

class _CopyWithImpl$Mutation$removeFollower<TRes>
    implements CopyWith$Mutation$removeFollower<TRes> {
  _CopyWithImpl$Mutation$removeFollower(this._instance, this._then);

  final Mutation$removeFollower _instance;

  final TRes Function(Mutation$removeFollower) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? removeFollower = _undefined,
    Object? $__typename = _undefined,
  }) => _then(
    Mutation$removeFollower(
      removeFollower: removeFollower == _undefined || removeFollower == null
          ? _instance.removeFollower
          : (removeFollower as bool),
      $__typename: $__typename == _undefined || $__typename == null
          ? _instance.$__typename
          : ($__typename as String),
    ),
  );
}

class _CopyWithStubImpl$Mutation$removeFollower<TRes>
    implements CopyWith$Mutation$removeFollower<TRes> {
  _CopyWithStubImpl$Mutation$removeFollower(this._res);

  TRes _res;

  call({bool? removeFollower, String? $__typename}) => _res;
}

const documentNodeMutationremoveFollower = DocumentNode(
  definitions: [
    OperationDefinitionNode(
      type: OperationType.mutation,
      name: NameNode(value: 'removeFollower'),
      variableDefinitions: [
        VariableDefinitionNode(
          variable: VariableNode(name: NameNode(value: 'playQueueId')),
          type: NamedTypeNode(name: NameNode(value: 'ID'), isNonNull: true),
          defaultValue: DefaultValueNode(value: null),
          directives: [],
        ),
        VariableDefinitionNode(
          variable: VariableNode(name: NameNode(value: 'userId')),
          type: NamedTypeNode(name: NameNode(value: 'ID'), isNonNull: true),
          defaultValue: DefaultValueNode(value: null),
          directives: [],
        ),
        VariableDefinitionNode(
          variable: VariableNode(name: NameNode(value: 'deviceId')),
          type: NamedTypeNode(
            name: NameNode(value: 'String'),
            isNonNull: false,
          ),
          defaultValue: DefaultValueNode(value: null),
          directives: [],
        ),
      ],
      directives: [],
      selectionSet: SelectionSetNode(
        selections: [
          FieldNode(
            name: NameNode(value: 'removeFollower'),
            alias: null,
            arguments: [
              ArgumentNode(
                name: NameNode(value: 'playQueueId'),
                value: VariableNode(name: NameNode(value: 'playQueueId')),
              ),
              ArgumentNode(
                name: NameNode(value: 'userId'),
                value: VariableNode(name: NameNode(value: 'userId')),
              ),
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

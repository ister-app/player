import 'package:gql/ast.dart';
import 'schema.graphql.dart';

class Variables$Mutation$setSessionSharing {
  factory Variables$Mutation$setSessionSharing({
    required String playQueueId,
    Enum$RemoteControlScope? controlScope,
    List<String>? allowedUserIds,
  }) => Variables$Mutation$setSessionSharing._({
    r'playQueueId': playQueueId,
    if (controlScope != null) r'controlScope': controlScope,
    if (allowedUserIds != null) r'allowedUserIds': allowedUserIds,
  });

  Variables$Mutation$setSessionSharing._(this._$data);

  factory Variables$Mutation$setSessionSharing.fromJson(
    Map<String, dynamic> data,
  ) {
    final result$data = <String, dynamic>{};
    final l$playQueueId = data['playQueueId'];
    result$data['playQueueId'] = (l$playQueueId as String);
    if (data.containsKey('controlScope')) {
      final l$controlScope = data['controlScope'];
      result$data['controlScope'] = l$controlScope == null
          ? null
          : fromJson$Enum$RemoteControlScope((l$controlScope as String));
    }
    if (data.containsKey('allowedUserIds')) {
      final l$allowedUserIds = data['allowedUserIds'];
      result$data['allowedUserIds'] = (l$allowedUserIds as List<dynamic>?)
          ?.map((e) => (e as String))
          .toList();
    }
    return Variables$Mutation$setSessionSharing._(result$data);
  }

  Map<String, dynamic> _$data;

  String get playQueueId => (_$data['playQueueId'] as String);

  Enum$RemoteControlScope? get controlScope =>
      (_$data['controlScope'] as Enum$RemoteControlScope?);

  List<String>? get allowedUserIds =>
      (_$data['allowedUserIds'] as List<String>?);

  Map<String, dynamic> toJson() {
    final result$data = <String, dynamic>{};
    final l$playQueueId = playQueueId;
    result$data['playQueueId'] = l$playQueueId;
    if (_$data.containsKey('controlScope')) {
      final l$controlScope = controlScope;
      result$data['controlScope'] = l$controlScope == null
          ? null
          : toJson$Enum$RemoteControlScope(l$controlScope);
    }
    if (_$data.containsKey('allowedUserIds')) {
      final l$allowedUserIds = allowedUserIds;
      result$data['allowedUserIds'] = l$allowedUserIds?.map((e) => e).toList();
    }
    return result$data;
  }

  CopyWith$Variables$Mutation$setSessionSharing<
    Variables$Mutation$setSessionSharing
  >
  get copyWith => CopyWith$Variables$Mutation$setSessionSharing(this, (i) => i);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Variables$Mutation$setSessionSharing ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$playQueueId = playQueueId;
    final lOther$playQueueId = other.playQueueId;
    if (l$playQueueId != lOther$playQueueId) {
      return false;
    }
    final l$controlScope = controlScope;
    final lOther$controlScope = other.controlScope;
    if (_$data.containsKey('controlScope') !=
        other._$data.containsKey('controlScope')) {
      return false;
    }
    if (l$controlScope != lOther$controlScope) {
      return false;
    }
    final l$allowedUserIds = allowedUserIds;
    final lOther$allowedUserIds = other.allowedUserIds;
    if (_$data.containsKey('allowedUserIds') !=
        other._$data.containsKey('allowedUserIds')) {
      return false;
    }
    if (l$allowedUserIds != null && lOther$allowedUserIds != null) {
      if (l$allowedUserIds.length != lOther$allowedUserIds.length) {
        return false;
      }
      for (int i = 0; i < l$allowedUserIds.length; i++) {
        final l$allowedUserIds$entry = l$allowedUserIds[i];
        final lOther$allowedUserIds$entry = lOther$allowedUserIds[i];
        if (l$allowedUserIds$entry != lOther$allowedUserIds$entry) {
          return false;
        }
      }
    } else if (l$allowedUserIds != lOther$allowedUserIds) {
      return false;
    }
    return true;
  }

  @override
  int get hashCode {
    final l$playQueueId = playQueueId;
    final l$controlScope = controlScope;
    final l$allowedUserIds = allowedUserIds;
    return Object.hashAll([
      l$playQueueId,
      _$data.containsKey('controlScope') ? l$controlScope : const {},
      _$data.containsKey('allowedUserIds')
          ? l$allowedUserIds == null
                ? null
                : Object.hashAll(l$allowedUserIds.map((v) => v))
          : const {},
    ]);
  }
}

abstract class CopyWith$Variables$Mutation$setSessionSharing<TRes> {
  factory CopyWith$Variables$Mutation$setSessionSharing(
    Variables$Mutation$setSessionSharing instance,
    TRes Function(Variables$Mutation$setSessionSharing) then,
  ) = _CopyWithImpl$Variables$Mutation$setSessionSharing;

  factory CopyWith$Variables$Mutation$setSessionSharing.stub(TRes res) =
      _CopyWithStubImpl$Variables$Mutation$setSessionSharing;

  TRes call({
    String? playQueueId,
    Enum$RemoteControlScope? controlScope,
    List<String>? allowedUserIds,
  });
}

class _CopyWithImpl$Variables$Mutation$setSessionSharing<TRes>
    implements CopyWith$Variables$Mutation$setSessionSharing<TRes> {
  _CopyWithImpl$Variables$Mutation$setSessionSharing(
    this._instance,
    this._then,
  );

  final Variables$Mutation$setSessionSharing _instance;

  final TRes Function(Variables$Mutation$setSessionSharing) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? playQueueId = _undefined,
    Object? controlScope = _undefined,
    Object? allowedUserIds = _undefined,
  }) => _then(
    Variables$Mutation$setSessionSharing._({
      ..._instance._$data,
      if (playQueueId != _undefined && playQueueId != null)
        'playQueueId': (playQueueId as String),
      if (controlScope != _undefined)
        'controlScope': (controlScope as Enum$RemoteControlScope?),
      if (allowedUserIds != _undefined)
        'allowedUserIds': (allowedUserIds as List<String>?),
    }),
  );
}

class _CopyWithStubImpl$Variables$Mutation$setSessionSharing<TRes>
    implements CopyWith$Variables$Mutation$setSessionSharing<TRes> {
  _CopyWithStubImpl$Variables$Mutation$setSessionSharing(this._res);

  TRes _res;

  call({
    String? playQueueId,
    Enum$RemoteControlScope? controlScope,
    List<String>? allowedUserIds,
  }) => _res;
}

class Mutation$setSessionSharing {
  Mutation$setSessionSharing({
    required this.setSessionSharing,
    this.$__typename = 'Mutation',
  });

  factory Mutation$setSessionSharing.fromJson(Map<String, dynamic> json) {
    final l$setSessionSharing = json['setSessionSharing'];
    final l$$__typename = json['__typename'];
    return Mutation$setSessionSharing(
      setSessionSharing: (l$setSessionSharing as bool),
      $__typename: (l$$__typename as String),
    );
  }

  final bool setSessionSharing;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$setSessionSharing = setSessionSharing;
    _resultData['setSessionSharing'] = l$setSessionSharing;
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$setSessionSharing = setSessionSharing;
    final l$$__typename = $__typename;
    return Object.hashAll([l$setSessionSharing, l$$__typename]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Mutation$setSessionSharing ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$setSessionSharing = setSessionSharing;
    final lOther$setSessionSharing = other.setSessionSharing;
    if (l$setSessionSharing != lOther$setSessionSharing) {
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

extension UtilityExtension$Mutation$setSessionSharing
    on Mutation$setSessionSharing {
  CopyWith$Mutation$setSessionSharing<Mutation$setSessionSharing>
  get copyWith => CopyWith$Mutation$setSessionSharing(this, (i) => i);
}

abstract class CopyWith$Mutation$setSessionSharing<TRes> {
  factory CopyWith$Mutation$setSessionSharing(
    Mutation$setSessionSharing instance,
    TRes Function(Mutation$setSessionSharing) then,
  ) = _CopyWithImpl$Mutation$setSessionSharing;

  factory CopyWith$Mutation$setSessionSharing.stub(TRes res) =
      _CopyWithStubImpl$Mutation$setSessionSharing;

  TRes call({bool? setSessionSharing, String? $__typename});
}

class _CopyWithImpl$Mutation$setSessionSharing<TRes>
    implements CopyWith$Mutation$setSessionSharing<TRes> {
  _CopyWithImpl$Mutation$setSessionSharing(this._instance, this._then);

  final Mutation$setSessionSharing _instance;

  final TRes Function(Mutation$setSessionSharing) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? setSessionSharing = _undefined,
    Object? $__typename = _undefined,
  }) => _then(
    Mutation$setSessionSharing(
      setSessionSharing:
          setSessionSharing == _undefined || setSessionSharing == null
          ? _instance.setSessionSharing
          : (setSessionSharing as bool),
      $__typename: $__typename == _undefined || $__typename == null
          ? _instance.$__typename
          : ($__typename as String),
    ),
  );
}

class _CopyWithStubImpl$Mutation$setSessionSharing<TRes>
    implements CopyWith$Mutation$setSessionSharing<TRes> {
  _CopyWithStubImpl$Mutation$setSessionSharing(this._res);

  TRes _res;

  call({bool? setSessionSharing, String? $__typename}) => _res;
}

const documentNodeMutationsetSessionSharing = DocumentNode(
  definitions: [
    OperationDefinitionNode(
      type: OperationType.mutation,
      name: NameNode(value: 'setSessionSharing'),
      variableDefinitions: [
        VariableDefinitionNode(
          variable: VariableNode(name: NameNode(value: 'playQueueId')),
          type: NamedTypeNode(name: NameNode(value: 'ID'), isNonNull: true),
          defaultValue: DefaultValueNode(value: null),
          directives: [],
        ),
        VariableDefinitionNode(
          variable: VariableNode(name: NameNode(value: 'controlScope')),
          type: NamedTypeNode(
            name: NameNode(value: 'RemoteControlScope'),
            isNonNull: false,
          ),
          defaultValue: DefaultValueNode(value: null),
          directives: [],
        ),
        VariableDefinitionNode(
          variable: VariableNode(name: NameNode(value: 'allowedUserIds')),
          type: ListTypeNode(
            type: NamedTypeNode(name: NameNode(value: 'ID'), isNonNull: true),
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
            name: NameNode(value: 'setSessionSharing'),
            alias: null,
            arguments: [
              ArgumentNode(
                name: NameNode(value: 'playQueueId'),
                value: VariableNode(name: NameNode(value: 'playQueueId')),
              ),
              ArgumentNode(
                name: NameNode(value: 'controlScope'),
                value: VariableNode(name: NameNode(value: 'controlScope')),
              ),
              ArgumentNode(
                name: NameNode(value: 'allowedUserIds'),
                value: VariableNode(name: NameNode(value: 'allowedUserIds')),
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

import 'package:gql/ast.dart';

class Variables$Mutation$updatePlayQueue {
  factory Variables$Mutation$updatePlayQueue({
    required String id,
    required String playQueueItemId,
    required int progressInMilliseconds,
  }) =>
      Variables$Mutation$updatePlayQueue._({
        r'id': id,
        r'playQueueItemId': playQueueItemId,
        r'progressInMilliseconds': progressInMilliseconds,
      });

  Variables$Mutation$updatePlayQueue._(this._$data);

  factory Variables$Mutation$updatePlayQueue.fromJson(
      Map<String, dynamic> data) {
    final result$data = <String, dynamic>{};
    final l$id = data['id'];
    result$data['id'] = (l$id as String);
    final l$playQueueItemId = data['playQueueItemId'];
    result$data['playQueueItemId'] = (l$playQueueItemId as String);
    final l$progressInMilliseconds = data['progressInMilliseconds'];
    result$data['progressInMilliseconds'] = (l$progressInMilliseconds as int);
    return Variables$Mutation$updatePlayQueue._(result$data);
  }

  Map<String, dynamic> _$data;

  String get id => (_$data['id'] as String);

  String get playQueueItemId => (_$data['playQueueItemId'] as String);

  int get progressInMilliseconds => (_$data['progressInMilliseconds'] as int);

  Map<String, dynamic> toJson() {
    final result$data = <String, dynamic>{};
    final l$id = id;
    result$data['id'] = l$id;
    final l$playQueueItemId = playQueueItemId;
    result$data['playQueueItemId'] = l$playQueueItemId;
    final l$progressInMilliseconds = progressInMilliseconds;
    result$data['progressInMilliseconds'] = l$progressInMilliseconds;
    return result$data;
  }

  CopyWith$Variables$Mutation$updatePlayQueue<
          Variables$Mutation$updatePlayQueue>
      get copyWith => CopyWith$Variables$Mutation$updatePlayQueue(
            this,
            (i) => i,
          );

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Variables$Mutation$updatePlayQueue ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$id = id;
    final lOther$id = other.id;
    if (l$id != lOther$id) {
      return false;
    }
    final l$playQueueItemId = playQueueItemId;
    final lOther$playQueueItemId = other.playQueueItemId;
    if (l$playQueueItemId != lOther$playQueueItemId) {
      return false;
    }
    final l$progressInMilliseconds = progressInMilliseconds;
    final lOther$progressInMilliseconds = other.progressInMilliseconds;
    if (l$progressInMilliseconds != lOther$progressInMilliseconds) {
      return false;
    }
    return true;
  }

  @override
  int get hashCode {
    final l$id = id;
    final l$playQueueItemId = playQueueItemId;
    final l$progressInMilliseconds = progressInMilliseconds;
    return Object.hashAll([
      l$id,
      l$playQueueItemId,
      l$progressInMilliseconds,
    ]);
  }
}

abstract class CopyWith$Variables$Mutation$updatePlayQueue<TRes> {
  factory CopyWith$Variables$Mutation$updatePlayQueue(
    Variables$Mutation$updatePlayQueue instance,
    TRes Function(Variables$Mutation$updatePlayQueue) then,
  ) = _CopyWithImpl$Variables$Mutation$updatePlayQueue;

  factory CopyWith$Variables$Mutation$updatePlayQueue.stub(TRes res) =
      _CopyWithStubImpl$Variables$Mutation$updatePlayQueue;

  TRes call({
    String? id,
    String? playQueueItemId,
    int? progressInMilliseconds,
  });
}

class _CopyWithImpl$Variables$Mutation$updatePlayQueue<TRes>
    implements CopyWith$Variables$Mutation$updatePlayQueue<TRes> {
  _CopyWithImpl$Variables$Mutation$updatePlayQueue(
    this._instance,
    this._then,
  );

  final Variables$Mutation$updatePlayQueue _instance;

  final TRes Function(Variables$Mutation$updatePlayQueue) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? id = _undefined,
    Object? playQueueItemId = _undefined,
    Object? progressInMilliseconds = _undefined,
  }) =>
      _then(Variables$Mutation$updatePlayQueue._({
        ..._instance._$data,
        if (id != _undefined && id != null) 'id': (id as String),
        if (playQueueItemId != _undefined && playQueueItemId != null)
          'playQueueItemId': (playQueueItemId as String),
        if (progressInMilliseconds != _undefined &&
            progressInMilliseconds != null)
          'progressInMilliseconds': (progressInMilliseconds as int),
      }));
}

class _CopyWithStubImpl$Variables$Mutation$updatePlayQueue<TRes>
    implements CopyWith$Variables$Mutation$updatePlayQueue<TRes> {
  _CopyWithStubImpl$Variables$Mutation$updatePlayQueue(this._res);

  TRes _res;

  call({
    String? id,
    String? playQueueItemId,
    int? progressInMilliseconds,
  }) =>
      _res;
}

class Mutation$updatePlayQueue {
  Mutation$updatePlayQueue({
    this.updatePlayQueue,
    this.$__typename = 'Mutation',
  });

  factory Mutation$updatePlayQueue.fromJson(Map<String, dynamic> json) {
    final l$updatePlayQueue = json['updatePlayQueue'];
    final l$$__typename = json['__typename'];
    return Mutation$updatePlayQueue(
      updatePlayQueue: l$updatePlayQueue == null
          ? null
          : Mutation$updatePlayQueue$updatePlayQueue.fromJson(
              (l$updatePlayQueue as Map<String, dynamic>)),
      $__typename: (l$$__typename as String),
    );
  }

  final Mutation$updatePlayQueue$updatePlayQueue? updatePlayQueue;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$updatePlayQueue = updatePlayQueue;
    _resultData['updatePlayQueue'] = l$updatePlayQueue?.toJson();
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$updatePlayQueue = updatePlayQueue;
    final l$$__typename = $__typename;
    return Object.hashAll([
      l$updatePlayQueue,
      l$$__typename,
    ]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Mutation$updatePlayQueue ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$updatePlayQueue = updatePlayQueue;
    final lOther$updatePlayQueue = other.updatePlayQueue;
    if (l$updatePlayQueue != lOther$updatePlayQueue) {
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

extension UtilityExtension$Mutation$updatePlayQueue
    on Mutation$updatePlayQueue {
  CopyWith$Mutation$updatePlayQueue<Mutation$updatePlayQueue> get copyWith =>
      CopyWith$Mutation$updatePlayQueue(
        this,
        (i) => i,
      );
}

abstract class CopyWith$Mutation$updatePlayQueue<TRes> {
  factory CopyWith$Mutation$updatePlayQueue(
    Mutation$updatePlayQueue instance,
    TRes Function(Mutation$updatePlayQueue) then,
  ) = _CopyWithImpl$Mutation$updatePlayQueue;

  factory CopyWith$Mutation$updatePlayQueue.stub(TRes res) =
      _CopyWithStubImpl$Mutation$updatePlayQueue;

  TRes call({
    Mutation$updatePlayQueue$updatePlayQueue? updatePlayQueue,
    String? $__typename,
  });
  CopyWith$Mutation$updatePlayQueue$updatePlayQueue<TRes> get updatePlayQueue;
}

class _CopyWithImpl$Mutation$updatePlayQueue<TRes>
    implements CopyWith$Mutation$updatePlayQueue<TRes> {
  _CopyWithImpl$Mutation$updatePlayQueue(
    this._instance,
    this._then,
  );

  final Mutation$updatePlayQueue _instance;

  final TRes Function(Mutation$updatePlayQueue) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? updatePlayQueue = _undefined,
    Object? $__typename = _undefined,
  }) =>
      _then(Mutation$updatePlayQueue(
        updatePlayQueue: updatePlayQueue == _undefined
            ? _instance.updatePlayQueue
            : (updatePlayQueue as Mutation$updatePlayQueue$updatePlayQueue?),
        $__typename: $__typename == _undefined || $__typename == null
            ? _instance.$__typename
            : ($__typename as String),
      ));

  CopyWith$Mutation$updatePlayQueue$updatePlayQueue<TRes> get updatePlayQueue {
    final local$updatePlayQueue = _instance.updatePlayQueue;
    return local$updatePlayQueue == null
        ? CopyWith$Mutation$updatePlayQueue$updatePlayQueue.stub(
            _then(_instance))
        : CopyWith$Mutation$updatePlayQueue$updatePlayQueue(
            local$updatePlayQueue, (e) => call(updatePlayQueue: e));
  }
}

class _CopyWithStubImpl$Mutation$updatePlayQueue<TRes>
    implements CopyWith$Mutation$updatePlayQueue<TRes> {
  _CopyWithStubImpl$Mutation$updatePlayQueue(this._res);

  TRes _res;

  call({
    Mutation$updatePlayQueue$updatePlayQueue? updatePlayQueue,
    String? $__typename,
  }) =>
      _res;

  CopyWith$Mutation$updatePlayQueue$updatePlayQueue<TRes> get updatePlayQueue =>
      CopyWith$Mutation$updatePlayQueue$updatePlayQueue.stub(_res);
}

const documentNodeMutationupdatePlayQueue = DocumentNode(definitions: [
  OperationDefinitionNode(
    type: OperationType.mutation,
    name: NameNode(value: 'updatePlayQueue'),
    variableDefinitions: [
      VariableDefinitionNode(
        variable: VariableNode(name: NameNode(value: 'id')),
        type: NamedTypeNode(
          name: NameNode(value: 'ID'),
          isNonNull: true,
        ),
        defaultValue: DefaultValueNode(value: null),
        directives: [],
      ),
      VariableDefinitionNode(
        variable: VariableNode(name: NameNode(value: 'playQueueItemId')),
        type: NamedTypeNode(
          name: NameNode(value: 'ID'),
          isNonNull: true,
        ),
        defaultValue: DefaultValueNode(value: null),
        directives: [],
      ),
      VariableDefinitionNode(
        variable: VariableNode(name: NameNode(value: 'progressInMilliseconds')),
        type: NamedTypeNode(
          name: NameNode(value: 'Int'),
          isNonNull: true,
        ),
        defaultValue: DefaultValueNode(value: null),
        directives: [],
      ),
    ],
    directives: [],
    selectionSet: SelectionSetNode(selections: [
      FieldNode(
        name: NameNode(value: 'updatePlayQueue'),
        alias: null,
        arguments: [
          ArgumentNode(
            name: NameNode(value: 'id'),
            value: VariableNode(name: NameNode(value: 'id')),
          ),
          ArgumentNode(
            name: NameNode(value: 'playQueueItemId'),
            value: VariableNode(name: NameNode(value: 'playQueueItemId')),
          ),
          ArgumentNode(
            name: NameNode(value: 'progressInMilliseconds'),
            value:
                VariableNode(name: NameNode(value: 'progressInMilliseconds')),
          ),
        ],
        directives: [],
        selectionSet: SelectionSetNode(selections: [
          FieldNode(
            name: NameNode(value: 'currentItemId'),
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
        ]),
      ),
      FieldNode(
        name: NameNode(value: '__typename'),
        alias: null,
        arguments: [],
        directives: [],
        selectionSet: null,
      ),
    ]),
  ),
]);

class Mutation$updatePlayQueue$updatePlayQueue {
  Mutation$updatePlayQueue$updatePlayQueue({
    this.currentItemId,
    this.$__typename = 'PlayQueue',
  });

  factory Mutation$updatePlayQueue$updatePlayQueue.fromJson(
      Map<String, dynamic> json) {
    final l$currentItemId = json['currentItemId'];
    final l$$__typename = json['__typename'];
    return Mutation$updatePlayQueue$updatePlayQueue(
      currentItemId: (l$currentItemId as String?),
      $__typename: (l$$__typename as String),
    );
  }

  final String? currentItemId;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$currentItemId = currentItemId;
    _resultData['currentItemId'] = l$currentItemId;
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$currentItemId = currentItemId;
    final l$$__typename = $__typename;
    return Object.hashAll([
      l$currentItemId,
      l$$__typename,
    ]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Mutation$updatePlayQueue$updatePlayQueue ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$currentItemId = currentItemId;
    final lOther$currentItemId = other.currentItemId;
    if (l$currentItemId != lOther$currentItemId) {
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

extension UtilityExtension$Mutation$updatePlayQueue$updatePlayQueue
    on Mutation$updatePlayQueue$updatePlayQueue {
  CopyWith$Mutation$updatePlayQueue$updatePlayQueue<
          Mutation$updatePlayQueue$updatePlayQueue>
      get copyWith => CopyWith$Mutation$updatePlayQueue$updatePlayQueue(
            this,
            (i) => i,
          );
}

abstract class CopyWith$Mutation$updatePlayQueue$updatePlayQueue<TRes> {
  factory CopyWith$Mutation$updatePlayQueue$updatePlayQueue(
    Mutation$updatePlayQueue$updatePlayQueue instance,
    TRes Function(Mutation$updatePlayQueue$updatePlayQueue) then,
  ) = _CopyWithImpl$Mutation$updatePlayQueue$updatePlayQueue;

  factory CopyWith$Mutation$updatePlayQueue$updatePlayQueue.stub(TRes res) =
      _CopyWithStubImpl$Mutation$updatePlayQueue$updatePlayQueue;

  TRes call({
    String? currentItemId,
    String? $__typename,
  });
}

class _CopyWithImpl$Mutation$updatePlayQueue$updatePlayQueue<TRes>
    implements CopyWith$Mutation$updatePlayQueue$updatePlayQueue<TRes> {
  _CopyWithImpl$Mutation$updatePlayQueue$updatePlayQueue(
    this._instance,
    this._then,
  );

  final Mutation$updatePlayQueue$updatePlayQueue _instance;

  final TRes Function(Mutation$updatePlayQueue$updatePlayQueue) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? currentItemId = _undefined,
    Object? $__typename = _undefined,
  }) =>
      _then(Mutation$updatePlayQueue$updatePlayQueue(
        currentItemId: currentItemId == _undefined
            ? _instance.currentItemId
            : (currentItemId as String?),
        $__typename: $__typename == _undefined || $__typename == null
            ? _instance.$__typename
            : ($__typename as String),
      ));
}

class _CopyWithStubImpl$Mutation$updatePlayQueue$updatePlayQueue<TRes>
    implements CopyWith$Mutation$updatePlayQueue$updatePlayQueue<TRes> {
  _CopyWithStubImpl$Mutation$updatePlayQueue$updatePlayQueue(this._res);

  TRes _res;

  call({
    String? currentItemId,
    String? $__typename,
  }) =>
      _res;
}

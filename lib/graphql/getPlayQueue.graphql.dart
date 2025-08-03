import 'fragmentPlayQueue.graphql.dart';
import 'package:gql/ast.dart';

class Variables$Query$getPlayQueue {
  factory Variables$Query$getPlayQueue({required String id}) =>
      Variables$Query$getPlayQueue._({
        r'id': id,
      });

  Variables$Query$getPlayQueue._(this._$data);

  factory Variables$Query$getPlayQueue.fromJson(Map<String, dynamic> data) {
    final result$data = <String, dynamic>{};
    final l$id = data['id'];
    result$data['id'] = (l$id as String);
    return Variables$Query$getPlayQueue._(result$data);
  }

  Map<String, dynamic> _$data;

  String get id => (_$data['id'] as String);

  Map<String, dynamic> toJson() {
    final result$data = <String, dynamic>{};
    final l$id = id;
    result$data['id'] = l$id;
    return result$data;
  }

  CopyWith$Variables$Query$getPlayQueue<Variables$Query$getPlayQueue>
      get copyWith => CopyWith$Variables$Query$getPlayQueue(
            this,
            (i) => i,
          );

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Variables$Query$getPlayQueue ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$id = id;
    final lOther$id = other.id;
    if (l$id != lOther$id) {
      return false;
    }
    return true;
  }

  @override
  int get hashCode {
    final l$id = id;
    return Object.hashAll([l$id]);
  }
}

abstract class CopyWith$Variables$Query$getPlayQueue<TRes> {
  factory CopyWith$Variables$Query$getPlayQueue(
    Variables$Query$getPlayQueue instance,
    TRes Function(Variables$Query$getPlayQueue) then,
  ) = _CopyWithImpl$Variables$Query$getPlayQueue;

  factory CopyWith$Variables$Query$getPlayQueue.stub(TRes res) =
      _CopyWithStubImpl$Variables$Query$getPlayQueue;

  TRes call({String? id});
}

class _CopyWithImpl$Variables$Query$getPlayQueue<TRes>
    implements CopyWith$Variables$Query$getPlayQueue<TRes> {
  _CopyWithImpl$Variables$Query$getPlayQueue(
    this._instance,
    this._then,
  );

  final Variables$Query$getPlayQueue _instance;

  final TRes Function(Variables$Query$getPlayQueue) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({Object? id = _undefined}) => _then(Variables$Query$getPlayQueue._({
        ..._instance._$data,
        if (id != _undefined && id != null) 'id': (id as String),
      }));
}

class _CopyWithStubImpl$Variables$Query$getPlayQueue<TRes>
    implements CopyWith$Variables$Query$getPlayQueue<TRes> {
  _CopyWithStubImpl$Variables$Query$getPlayQueue(this._res);

  TRes _res;

  call({String? id}) => _res;
}

class Query$getPlayQueue {
  Query$getPlayQueue({
    this.getPlayQueue,
    this.$__typename = 'Query',
  });

  factory Query$getPlayQueue.fromJson(Map<String, dynamic> json) {
    final l$getPlayQueue = json['getPlayQueue'];
    final l$$__typename = json['__typename'];
    return Query$getPlayQueue(
      getPlayQueue: l$getPlayQueue == null
          ? null
          : Fragment$fragmentPlayQueue.fromJson(
              (l$getPlayQueue as Map<String, dynamic>)),
      $__typename: (l$$__typename as String),
    );
  }

  final Fragment$fragmentPlayQueue? getPlayQueue;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$getPlayQueue = getPlayQueue;
    _resultData['getPlayQueue'] = l$getPlayQueue?.toJson();
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$getPlayQueue = getPlayQueue;
    final l$$__typename = $__typename;
    return Object.hashAll([
      l$getPlayQueue,
      l$$__typename,
    ]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Query$getPlayQueue || runtimeType != other.runtimeType) {
      return false;
    }
    final l$getPlayQueue = getPlayQueue;
    final lOther$getPlayQueue = other.getPlayQueue;
    if (l$getPlayQueue != lOther$getPlayQueue) {
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

extension UtilityExtension$Query$getPlayQueue on Query$getPlayQueue {
  CopyWith$Query$getPlayQueue<Query$getPlayQueue> get copyWith =>
      CopyWith$Query$getPlayQueue(
        this,
        (i) => i,
      );
}

abstract class CopyWith$Query$getPlayQueue<TRes> {
  factory CopyWith$Query$getPlayQueue(
    Query$getPlayQueue instance,
    TRes Function(Query$getPlayQueue) then,
  ) = _CopyWithImpl$Query$getPlayQueue;

  factory CopyWith$Query$getPlayQueue.stub(TRes res) =
      _CopyWithStubImpl$Query$getPlayQueue;

  TRes call({
    Fragment$fragmentPlayQueue? getPlayQueue,
    String? $__typename,
  });
  CopyWith$Fragment$fragmentPlayQueue<TRes> get getPlayQueue;
}

class _CopyWithImpl$Query$getPlayQueue<TRes>
    implements CopyWith$Query$getPlayQueue<TRes> {
  _CopyWithImpl$Query$getPlayQueue(
    this._instance,
    this._then,
  );

  final Query$getPlayQueue _instance;

  final TRes Function(Query$getPlayQueue) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? getPlayQueue = _undefined,
    Object? $__typename = _undefined,
  }) =>
      _then(Query$getPlayQueue(
        getPlayQueue: getPlayQueue == _undefined
            ? _instance.getPlayQueue
            : (getPlayQueue as Fragment$fragmentPlayQueue?),
        $__typename: $__typename == _undefined || $__typename == null
            ? _instance.$__typename
            : ($__typename as String),
      ));

  CopyWith$Fragment$fragmentPlayQueue<TRes> get getPlayQueue {
    final local$getPlayQueue = _instance.getPlayQueue;
    return local$getPlayQueue == null
        ? CopyWith$Fragment$fragmentPlayQueue.stub(_then(_instance))
        : CopyWith$Fragment$fragmentPlayQueue(
            local$getPlayQueue, (e) => call(getPlayQueue: e));
  }
}

class _CopyWithStubImpl$Query$getPlayQueue<TRes>
    implements CopyWith$Query$getPlayQueue<TRes> {
  _CopyWithStubImpl$Query$getPlayQueue(this._res);

  TRes _res;

  call({
    Fragment$fragmentPlayQueue? getPlayQueue,
    String? $__typename,
  }) =>
      _res;

  CopyWith$Fragment$fragmentPlayQueue<TRes> get getPlayQueue =>
      CopyWith$Fragment$fragmentPlayQueue.stub(_res);
}

const documentNodeQuerygetPlayQueue = DocumentNode(definitions: [
  OperationDefinitionNode(
    type: OperationType.query,
    name: NameNode(value: 'getPlayQueue'),
    variableDefinitions: [
      VariableDefinitionNode(
        variable: VariableNode(name: NameNode(value: 'id')),
        type: NamedTypeNode(
          name: NameNode(value: 'ID'),
          isNonNull: true,
        ),
        defaultValue: DefaultValueNode(value: null),
        directives: [],
      )
    ],
    directives: [],
    selectionSet: SelectionSetNode(selections: [
      FieldNode(
        name: NameNode(value: 'getPlayQueue'),
        alias: null,
        arguments: [
          ArgumentNode(
            name: NameNode(value: 'id'),
            value: VariableNode(name: NameNode(value: 'id')),
          )
        ],
        directives: [],
        selectionSet: SelectionSetNode(selections: [
          FragmentSpreadNode(
            name: NameNode(value: 'fragmentPlayQueue'),
            directives: [],
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
  fragmentDefinitionfragmentPlayQueue,
]);

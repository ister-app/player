import 'fragmentCredit.graphql.dart';
import 'fragmentEpisode.graphql.dart';
import 'fragmentImages.graphql.dart';
import 'fragmentMediafiles.graphql.dart';
import 'fragmentMetadata.graphql.dart';
import 'fragmentMovie.graphql.dart';
import 'fragmentPlayQueue.graphql.dart';
import 'fragmentWatchStatus.graphql.dart';
import 'package:gql/ast.dart';
import 'schema.graphql.dart';

class Variables$Mutation$createPlayQueue {
  factory Variables$Mutation$createPlayQueue({
    required Input$CreatePlayQueueInput input,
  }) => Variables$Mutation$createPlayQueue._({r'input': input});

  Variables$Mutation$createPlayQueue._(this._$data);

  factory Variables$Mutation$createPlayQueue.fromJson(
    Map<String, dynamic> data,
  ) {
    final result$data = <String, dynamic>{};
    final l$input = data['input'];
    result$data['input'] = Input$CreatePlayQueueInput.fromJson(
      (l$input as Map<String, dynamic>),
    );
    return Variables$Mutation$createPlayQueue._(result$data);
  }

  Map<String, dynamic> _$data;

  Input$CreatePlayQueueInput get input =>
      (_$data['input'] as Input$CreatePlayQueueInput);

  Map<String, dynamic> toJson() {
    final result$data = <String, dynamic>{};
    final l$input = input;
    result$data['input'] = l$input.toJson();
    return result$data;
  }

  CopyWith$Variables$Mutation$createPlayQueue<
    Variables$Mutation$createPlayQueue
  >
  get copyWith => CopyWith$Variables$Mutation$createPlayQueue(this, (i) => i);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Variables$Mutation$createPlayQueue ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$input = input;
    final lOther$input = other.input;
    if (l$input != lOther$input) {
      return false;
    }
    return true;
  }

  @override
  int get hashCode {
    final l$input = input;
    return Object.hashAll([l$input]);
  }
}

abstract class CopyWith$Variables$Mutation$createPlayQueue<TRes> {
  factory CopyWith$Variables$Mutation$createPlayQueue(
    Variables$Mutation$createPlayQueue instance,
    TRes Function(Variables$Mutation$createPlayQueue) then,
  ) = _CopyWithImpl$Variables$Mutation$createPlayQueue;

  factory CopyWith$Variables$Mutation$createPlayQueue.stub(TRes res) =
      _CopyWithStubImpl$Variables$Mutation$createPlayQueue;

  TRes call({Input$CreatePlayQueueInput? input});
}

class _CopyWithImpl$Variables$Mutation$createPlayQueue<TRes>
    implements CopyWith$Variables$Mutation$createPlayQueue<TRes> {
  _CopyWithImpl$Variables$Mutation$createPlayQueue(this._instance, this._then);

  final Variables$Mutation$createPlayQueue _instance;

  final TRes Function(Variables$Mutation$createPlayQueue) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({Object? input = _undefined}) => _then(
    Variables$Mutation$createPlayQueue._({
      ..._instance._$data,
      if (input != _undefined && input != null)
        'input': (input as Input$CreatePlayQueueInput),
    }),
  );
}

class _CopyWithStubImpl$Variables$Mutation$createPlayQueue<TRes>
    implements CopyWith$Variables$Mutation$createPlayQueue<TRes> {
  _CopyWithStubImpl$Variables$Mutation$createPlayQueue(this._res);

  TRes _res;

  call({Input$CreatePlayQueueInput? input}) => _res;
}

class Mutation$createPlayQueue {
  Mutation$createPlayQueue({
    required this.createPlayQueue,
    this.$__typename = 'Mutation',
  });

  factory Mutation$createPlayQueue.fromJson(Map<String, dynamic> json) {
    final l$createPlayQueue = json['createPlayQueue'];
    final l$$__typename = json['__typename'];
    return Mutation$createPlayQueue(
      createPlayQueue: Fragment$fragmentPlayQueue.fromJson(
        (l$createPlayQueue as Map<String, dynamic>),
      ),
      $__typename: (l$$__typename as String),
    );
  }

  final Fragment$fragmentPlayQueue createPlayQueue;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$createPlayQueue = createPlayQueue;
    _resultData['createPlayQueue'] = l$createPlayQueue.toJson();
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$createPlayQueue = createPlayQueue;
    final l$$__typename = $__typename;
    return Object.hashAll([l$createPlayQueue, l$$__typename]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Mutation$createPlayQueue ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$createPlayQueue = createPlayQueue;
    final lOther$createPlayQueue = other.createPlayQueue;
    if (l$createPlayQueue != lOther$createPlayQueue) {
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

extension UtilityExtension$Mutation$createPlayQueue
    on Mutation$createPlayQueue {
  CopyWith$Mutation$createPlayQueue<Mutation$createPlayQueue> get copyWith =>
      CopyWith$Mutation$createPlayQueue(this, (i) => i);
}

abstract class CopyWith$Mutation$createPlayQueue<TRes> {
  factory CopyWith$Mutation$createPlayQueue(
    Mutation$createPlayQueue instance,
    TRes Function(Mutation$createPlayQueue) then,
  ) = _CopyWithImpl$Mutation$createPlayQueue;

  factory CopyWith$Mutation$createPlayQueue.stub(TRes res) =
      _CopyWithStubImpl$Mutation$createPlayQueue;

  TRes call({Fragment$fragmentPlayQueue? createPlayQueue, String? $__typename});
  CopyWith$Fragment$fragmentPlayQueue<TRes> get createPlayQueue;
}

class _CopyWithImpl$Mutation$createPlayQueue<TRes>
    implements CopyWith$Mutation$createPlayQueue<TRes> {
  _CopyWithImpl$Mutation$createPlayQueue(this._instance, this._then);

  final Mutation$createPlayQueue _instance;

  final TRes Function(Mutation$createPlayQueue) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? createPlayQueue = _undefined,
    Object? $__typename = _undefined,
  }) => _then(
    Mutation$createPlayQueue(
      createPlayQueue: createPlayQueue == _undefined || createPlayQueue == null
          ? _instance.createPlayQueue
          : (createPlayQueue as Fragment$fragmentPlayQueue),
      $__typename: $__typename == _undefined || $__typename == null
          ? _instance.$__typename
          : ($__typename as String),
    ),
  );

  CopyWith$Fragment$fragmentPlayQueue<TRes> get createPlayQueue {
    final local$createPlayQueue = _instance.createPlayQueue;
    return CopyWith$Fragment$fragmentPlayQueue(
      local$createPlayQueue,
      (e) => call(createPlayQueue: e),
    );
  }
}

class _CopyWithStubImpl$Mutation$createPlayQueue<TRes>
    implements CopyWith$Mutation$createPlayQueue<TRes> {
  _CopyWithStubImpl$Mutation$createPlayQueue(this._res);

  TRes _res;

  call({Fragment$fragmentPlayQueue? createPlayQueue, String? $__typename}) =>
      _res;

  CopyWith$Fragment$fragmentPlayQueue<TRes> get createPlayQueue =>
      CopyWith$Fragment$fragmentPlayQueue.stub(_res);
}

const documentNodeMutationcreatePlayQueue = DocumentNode(
  definitions: [
    OperationDefinitionNode(
      type: OperationType.mutation,
      name: NameNode(value: 'createPlayQueue'),
      variableDefinitions: [
        VariableDefinitionNode(
          variable: VariableNode(name: NameNode(value: 'input')),
          type: NamedTypeNode(
            name: NameNode(value: 'CreatePlayQueueInput'),
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
            name: NameNode(value: 'createPlayQueue'),
            alias: null,
            arguments: [
              ArgumentNode(
                name: NameNode(value: 'input'),
                value: VariableNode(name: NameNode(value: 'input')),
              ),
            ],
            directives: [],
            selectionSet: SelectionSetNode(
              selections: [
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
    fragmentDefinitionfragmentPlayQueue,
    fragmentDefinitionfragmentEpisode,
    fragmentDefinitionfragmentMetadata,
    fragmentDefinitionfragmentImages,
    fragmentDefinitionfragmentMediaFiles,
    fragmentDefinitionfragmentCastMember,
    fragmentDefinitionfragmentMovie,
    fragmentDefinitionfragmentWatchStatus,
  ],
);

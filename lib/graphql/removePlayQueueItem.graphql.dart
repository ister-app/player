import 'fragmentCredit.graphql.dart';
import 'fragmentEpisode.graphql.dart';
import 'fragmentImages.graphql.dart';
import 'fragmentMediafiles.graphql.dart';
import 'fragmentMetadata.graphql.dart';
import 'fragmentMovie.graphql.dart';
import 'fragmentPlayQueue.graphql.dart';
import 'fragmentWatchStatus.graphql.dart';
import 'package:gql/ast.dart';

class Variables$Mutation$removePlayQueueItem {
  factory Variables$Mutation$removePlayQueueItem({
    required String playQueueId,
    required String playQueueItemId,
  }) => Variables$Mutation$removePlayQueueItem._({
    r'playQueueId': playQueueId,
    r'playQueueItemId': playQueueItemId,
  });

  Variables$Mutation$removePlayQueueItem._(this._$data);

  factory Variables$Mutation$removePlayQueueItem.fromJson(
    Map<String, dynamic> data,
  ) {
    final result$data = <String, dynamic>{};
    final l$playQueueId = data['playQueueId'];
    result$data['playQueueId'] = (l$playQueueId as String);
    final l$playQueueItemId = data['playQueueItemId'];
    result$data['playQueueItemId'] = (l$playQueueItemId as String);
    return Variables$Mutation$removePlayQueueItem._(result$data);
  }

  Map<String, dynamic> _$data;

  String get playQueueId => (_$data['playQueueId'] as String);

  String get playQueueItemId => (_$data['playQueueItemId'] as String);

  Map<String, dynamic> toJson() {
    final result$data = <String, dynamic>{};
    final l$playQueueId = playQueueId;
    result$data['playQueueId'] = l$playQueueId;
    final l$playQueueItemId = playQueueItemId;
    result$data['playQueueItemId'] = l$playQueueItemId;
    return result$data;
  }

  CopyWith$Variables$Mutation$removePlayQueueItem<
    Variables$Mutation$removePlayQueueItem
  >
  get copyWith =>
      CopyWith$Variables$Mutation$removePlayQueueItem(this, (i) => i);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Variables$Mutation$removePlayQueueItem ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$playQueueId = playQueueId;
    final lOther$playQueueId = other.playQueueId;
    if (l$playQueueId != lOther$playQueueId) {
      return false;
    }
    final l$playQueueItemId = playQueueItemId;
    final lOther$playQueueItemId = other.playQueueItemId;
    if (l$playQueueItemId != lOther$playQueueItemId) {
      return false;
    }
    return true;
  }

  @override
  int get hashCode {
    final l$playQueueId = playQueueId;
    final l$playQueueItemId = playQueueItemId;
    return Object.hashAll([l$playQueueId, l$playQueueItemId]);
  }
}

abstract class CopyWith$Variables$Mutation$removePlayQueueItem<TRes> {
  factory CopyWith$Variables$Mutation$removePlayQueueItem(
    Variables$Mutation$removePlayQueueItem instance,
    TRes Function(Variables$Mutation$removePlayQueueItem) then,
  ) = _CopyWithImpl$Variables$Mutation$removePlayQueueItem;

  factory CopyWith$Variables$Mutation$removePlayQueueItem.stub(TRes res) =
      _CopyWithStubImpl$Variables$Mutation$removePlayQueueItem;

  TRes call({String? playQueueId, String? playQueueItemId});
}

class _CopyWithImpl$Variables$Mutation$removePlayQueueItem<TRes>
    implements CopyWith$Variables$Mutation$removePlayQueueItem<TRes> {
  _CopyWithImpl$Variables$Mutation$removePlayQueueItem(
    this._instance,
    this._then,
  );

  final Variables$Mutation$removePlayQueueItem _instance;

  final TRes Function(Variables$Mutation$removePlayQueueItem) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? playQueueId = _undefined,
    Object? playQueueItemId = _undefined,
  }) => _then(
    Variables$Mutation$removePlayQueueItem._({
      ..._instance._$data,
      if (playQueueId != _undefined && playQueueId != null)
        'playQueueId': (playQueueId as String),
      if (playQueueItemId != _undefined && playQueueItemId != null)
        'playQueueItemId': (playQueueItemId as String),
    }),
  );
}

class _CopyWithStubImpl$Variables$Mutation$removePlayQueueItem<TRes>
    implements CopyWith$Variables$Mutation$removePlayQueueItem<TRes> {
  _CopyWithStubImpl$Variables$Mutation$removePlayQueueItem(this._res);

  TRes _res;

  call({String? playQueueId, String? playQueueItemId}) => _res;
}

class Mutation$removePlayQueueItem {
  Mutation$removePlayQueueItem({
    required this.removePlayQueueItem,
    this.$__typename = 'Mutation',
  });

  factory Mutation$removePlayQueueItem.fromJson(Map<String, dynamic> json) {
    final l$removePlayQueueItem = json['removePlayQueueItem'];
    final l$$__typename = json['__typename'];
    return Mutation$removePlayQueueItem(
      removePlayQueueItem: Fragment$fragmentPlayQueue.fromJson(
        (l$removePlayQueueItem as Map<String, dynamic>),
      ),
      $__typename: (l$$__typename as String),
    );
  }

  final Fragment$fragmentPlayQueue removePlayQueueItem;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$removePlayQueueItem = removePlayQueueItem;
    _resultData['removePlayQueueItem'] = l$removePlayQueueItem.toJson();
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$removePlayQueueItem = removePlayQueueItem;
    final l$$__typename = $__typename;
    return Object.hashAll([l$removePlayQueueItem, l$$__typename]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Mutation$removePlayQueueItem ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$removePlayQueueItem = removePlayQueueItem;
    final lOther$removePlayQueueItem = other.removePlayQueueItem;
    if (l$removePlayQueueItem != lOther$removePlayQueueItem) {
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

extension UtilityExtension$Mutation$removePlayQueueItem
    on Mutation$removePlayQueueItem {
  CopyWith$Mutation$removePlayQueueItem<Mutation$removePlayQueueItem>
  get copyWith => CopyWith$Mutation$removePlayQueueItem(this, (i) => i);
}

abstract class CopyWith$Mutation$removePlayQueueItem<TRes> {
  factory CopyWith$Mutation$removePlayQueueItem(
    Mutation$removePlayQueueItem instance,
    TRes Function(Mutation$removePlayQueueItem) then,
  ) = _CopyWithImpl$Mutation$removePlayQueueItem;

  factory CopyWith$Mutation$removePlayQueueItem.stub(TRes res) =
      _CopyWithStubImpl$Mutation$removePlayQueueItem;

  TRes call({
    Fragment$fragmentPlayQueue? removePlayQueueItem,
    String? $__typename,
  });
  CopyWith$Fragment$fragmentPlayQueue<TRes> get removePlayQueueItem;
}

class _CopyWithImpl$Mutation$removePlayQueueItem<TRes>
    implements CopyWith$Mutation$removePlayQueueItem<TRes> {
  _CopyWithImpl$Mutation$removePlayQueueItem(this._instance, this._then);

  final Mutation$removePlayQueueItem _instance;

  final TRes Function(Mutation$removePlayQueueItem) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? removePlayQueueItem = _undefined,
    Object? $__typename = _undefined,
  }) => _then(
    Mutation$removePlayQueueItem(
      removePlayQueueItem:
          removePlayQueueItem == _undefined || removePlayQueueItem == null
          ? _instance.removePlayQueueItem
          : (removePlayQueueItem as Fragment$fragmentPlayQueue),
      $__typename: $__typename == _undefined || $__typename == null
          ? _instance.$__typename
          : ($__typename as String),
    ),
  );

  CopyWith$Fragment$fragmentPlayQueue<TRes> get removePlayQueueItem {
    final local$removePlayQueueItem = _instance.removePlayQueueItem;
    return CopyWith$Fragment$fragmentPlayQueue(
      local$removePlayQueueItem,
      (e) => call(removePlayQueueItem: e),
    );
  }
}

class _CopyWithStubImpl$Mutation$removePlayQueueItem<TRes>
    implements CopyWith$Mutation$removePlayQueueItem<TRes> {
  _CopyWithStubImpl$Mutation$removePlayQueueItem(this._res);

  TRes _res;

  call({
    Fragment$fragmentPlayQueue? removePlayQueueItem,
    String? $__typename,
  }) => _res;

  CopyWith$Fragment$fragmentPlayQueue<TRes> get removePlayQueueItem =>
      CopyWith$Fragment$fragmentPlayQueue.stub(_res);
}

const documentNodeMutationremovePlayQueueItem = DocumentNode(
  definitions: [
    OperationDefinitionNode(
      type: OperationType.mutation,
      name: NameNode(value: 'removePlayQueueItem'),
      variableDefinitions: [
        VariableDefinitionNode(
          variable: VariableNode(name: NameNode(value: 'playQueueId')),
          type: NamedTypeNode(name: NameNode(value: 'ID'), isNonNull: true),
          defaultValue: DefaultValueNode(value: null),
          directives: [],
        ),
        VariableDefinitionNode(
          variable: VariableNode(name: NameNode(value: 'playQueueItemId')),
          type: NamedTypeNode(name: NameNode(value: 'ID'), isNonNull: true),
          defaultValue: DefaultValueNode(value: null),
          directives: [],
        ),
      ],
      directives: [],
      selectionSet: SelectionSetNode(
        selections: [
          FieldNode(
            name: NameNode(value: 'removePlayQueueItem'),
            alias: null,
            arguments: [
              ArgumentNode(
                name: NameNode(value: 'playQueueId'),
                value: VariableNode(name: NameNode(value: 'playQueueId')),
              ),
              ArgumentNode(
                name: NameNode(value: 'playQueueItemId'),
                value: VariableNode(name: NameNode(value: 'playQueueItemId')),
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

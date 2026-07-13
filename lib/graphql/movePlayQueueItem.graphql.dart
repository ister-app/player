import 'fragmentCredit.graphql.dart';
import 'fragmentEpisode.graphql.dart';
import 'fragmentImages.graphql.dart';
import 'fragmentMediafiles.graphql.dart';
import 'fragmentMetadata.graphql.dart';
import 'fragmentMovie.graphql.dart';
import 'fragmentPlayQueue.graphql.dart';
import 'fragmentWatchStatus.graphql.dart';
import 'package:gql/ast.dart';

class Variables$Mutation$movePlayQueueItem {
  factory Variables$Mutation$movePlayQueueItem({
    required String playQueueId,
    required String playQueueItemId,
    String? afterPlayQueueItemId,
  }) => Variables$Mutation$movePlayQueueItem._({
    r'playQueueId': playQueueId,
    r'playQueueItemId': playQueueItemId,
    if (afterPlayQueueItemId != null)
      r'afterPlayQueueItemId': afterPlayQueueItemId,
  });

  Variables$Mutation$movePlayQueueItem._(this._$data);

  factory Variables$Mutation$movePlayQueueItem.fromJson(
    Map<String, dynamic> data,
  ) {
    final result$data = <String, dynamic>{};
    final l$playQueueId = data['playQueueId'];
    result$data['playQueueId'] = (l$playQueueId as String);
    final l$playQueueItemId = data['playQueueItemId'];
    result$data['playQueueItemId'] = (l$playQueueItemId as String);
    if (data.containsKey('afterPlayQueueItemId')) {
      final l$afterPlayQueueItemId = data['afterPlayQueueItemId'];
      result$data['afterPlayQueueItemId'] = (l$afterPlayQueueItemId as String?);
    }
    return Variables$Mutation$movePlayQueueItem._(result$data);
  }

  Map<String, dynamic> _$data;

  String get playQueueId => (_$data['playQueueId'] as String);

  String get playQueueItemId => (_$data['playQueueItemId'] as String);

  String? get afterPlayQueueItemId =>
      (_$data['afterPlayQueueItemId'] as String?);

  Map<String, dynamic> toJson() {
    final result$data = <String, dynamic>{};
    final l$playQueueId = playQueueId;
    result$data['playQueueId'] = l$playQueueId;
    final l$playQueueItemId = playQueueItemId;
    result$data['playQueueItemId'] = l$playQueueItemId;
    if (_$data.containsKey('afterPlayQueueItemId')) {
      final l$afterPlayQueueItemId = afterPlayQueueItemId;
      result$data['afterPlayQueueItemId'] = l$afterPlayQueueItemId;
    }
    return result$data;
  }

  CopyWith$Variables$Mutation$movePlayQueueItem<
    Variables$Mutation$movePlayQueueItem
  >
  get copyWith => CopyWith$Variables$Mutation$movePlayQueueItem(this, (i) => i);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Variables$Mutation$movePlayQueueItem ||
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
    final l$afterPlayQueueItemId = afterPlayQueueItemId;
    final lOther$afterPlayQueueItemId = other.afterPlayQueueItemId;
    if (_$data.containsKey('afterPlayQueueItemId') !=
        other._$data.containsKey('afterPlayQueueItemId')) {
      return false;
    }
    if (l$afterPlayQueueItemId != lOther$afterPlayQueueItemId) {
      return false;
    }
    return true;
  }

  @override
  int get hashCode {
    final l$playQueueId = playQueueId;
    final l$playQueueItemId = playQueueItemId;
    final l$afterPlayQueueItemId = afterPlayQueueItemId;
    return Object.hashAll([
      l$playQueueId,
      l$playQueueItemId,
      _$data.containsKey('afterPlayQueueItemId')
          ? l$afterPlayQueueItemId
          : const {},
    ]);
  }
}

abstract class CopyWith$Variables$Mutation$movePlayQueueItem<TRes> {
  factory CopyWith$Variables$Mutation$movePlayQueueItem(
    Variables$Mutation$movePlayQueueItem instance,
    TRes Function(Variables$Mutation$movePlayQueueItem) then,
  ) = _CopyWithImpl$Variables$Mutation$movePlayQueueItem;

  factory CopyWith$Variables$Mutation$movePlayQueueItem.stub(TRes res) =
      _CopyWithStubImpl$Variables$Mutation$movePlayQueueItem;

  TRes call({
    String? playQueueId,
    String? playQueueItemId,
    String? afterPlayQueueItemId,
  });
}

class _CopyWithImpl$Variables$Mutation$movePlayQueueItem<TRes>
    implements CopyWith$Variables$Mutation$movePlayQueueItem<TRes> {
  _CopyWithImpl$Variables$Mutation$movePlayQueueItem(
    this._instance,
    this._then,
  );

  final Variables$Mutation$movePlayQueueItem _instance;

  final TRes Function(Variables$Mutation$movePlayQueueItem) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? playQueueId = _undefined,
    Object? playQueueItemId = _undefined,
    Object? afterPlayQueueItemId = _undefined,
  }) => _then(
    Variables$Mutation$movePlayQueueItem._({
      ..._instance._$data,
      if (playQueueId != _undefined && playQueueId != null)
        'playQueueId': (playQueueId as String),
      if (playQueueItemId != _undefined && playQueueItemId != null)
        'playQueueItemId': (playQueueItemId as String),
      if (afterPlayQueueItemId != _undefined)
        'afterPlayQueueItemId': (afterPlayQueueItemId as String?),
    }),
  );
}

class _CopyWithStubImpl$Variables$Mutation$movePlayQueueItem<TRes>
    implements CopyWith$Variables$Mutation$movePlayQueueItem<TRes> {
  _CopyWithStubImpl$Variables$Mutation$movePlayQueueItem(this._res);

  TRes _res;

  call({
    String? playQueueId,
    String? playQueueItemId,
    String? afterPlayQueueItemId,
  }) => _res;
}

class Mutation$movePlayQueueItem {
  Mutation$movePlayQueueItem({
    required this.movePlayQueueItem,
    this.$__typename = 'Mutation',
  });

  factory Mutation$movePlayQueueItem.fromJson(Map<String, dynamic> json) {
    final l$movePlayQueueItem = json['movePlayQueueItem'];
    final l$$__typename = json['__typename'];
    return Mutation$movePlayQueueItem(
      movePlayQueueItem: Fragment$fragmentPlayQueue.fromJson(
        (l$movePlayQueueItem as Map<String, dynamic>),
      ),
      $__typename: (l$$__typename as String),
    );
  }

  final Fragment$fragmentPlayQueue movePlayQueueItem;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$movePlayQueueItem = movePlayQueueItem;
    _resultData['movePlayQueueItem'] = l$movePlayQueueItem.toJson();
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$movePlayQueueItem = movePlayQueueItem;
    final l$$__typename = $__typename;
    return Object.hashAll([l$movePlayQueueItem, l$$__typename]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Mutation$movePlayQueueItem ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$movePlayQueueItem = movePlayQueueItem;
    final lOther$movePlayQueueItem = other.movePlayQueueItem;
    if (l$movePlayQueueItem != lOther$movePlayQueueItem) {
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

extension UtilityExtension$Mutation$movePlayQueueItem
    on Mutation$movePlayQueueItem {
  CopyWith$Mutation$movePlayQueueItem<Mutation$movePlayQueueItem>
  get copyWith => CopyWith$Mutation$movePlayQueueItem(this, (i) => i);
}

abstract class CopyWith$Mutation$movePlayQueueItem<TRes> {
  factory CopyWith$Mutation$movePlayQueueItem(
    Mutation$movePlayQueueItem instance,
    TRes Function(Mutation$movePlayQueueItem) then,
  ) = _CopyWithImpl$Mutation$movePlayQueueItem;

  factory CopyWith$Mutation$movePlayQueueItem.stub(TRes res) =
      _CopyWithStubImpl$Mutation$movePlayQueueItem;

  TRes call({
    Fragment$fragmentPlayQueue? movePlayQueueItem,
    String? $__typename,
  });
  CopyWith$Fragment$fragmentPlayQueue<TRes> get movePlayQueueItem;
}

class _CopyWithImpl$Mutation$movePlayQueueItem<TRes>
    implements CopyWith$Mutation$movePlayQueueItem<TRes> {
  _CopyWithImpl$Mutation$movePlayQueueItem(this._instance, this._then);

  final Mutation$movePlayQueueItem _instance;

  final TRes Function(Mutation$movePlayQueueItem) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? movePlayQueueItem = _undefined,
    Object? $__typename = _undefined,
  }) => _then(
    Mutation$movePlayQueueItem(
      movePlayQueueItem:
          movePlayQueueItem == _undefined || movePlayQueueItem == null
          ? _instance.movePlayQueueItem
          : (movePlayQueueItem as Fragment$fragmentPlayQueue),
      $__typename: $__typename == _undefined || $__typename == null
          ? _instance.$__typename
          : ($__typename as String),
    ),
  );

  CopyWith$Fragment$fragmentPlayQueue<TRes> get movePlayQueueItem {
    final local$movePlayQueueItem = _instance.movePlayQueueItem;
    return CopyWith$Fragment$fragmentPlayQueue(
      local$movePlayQueueItem,
      (e) => call(movePlayQueueItem: e),
    );
  }
}

class _CopyWithStubImpl$Mutation$movePlayQueueItem<TRes>
    implements CopyWith$Mutation$movePlayQueueItem<TRes> {
  _CopyWithStubImpl$Mutation$movePlayQueueItem(this._res);

  TRes _res;

  call({Fragment$fragmentPlayQueue? movePlayQueueItem, String? $__typename}) =>
      _res;

  CopyWith$Fragment$fragmentPlayQueue<TRes> get movePlayQueueItem =>
      CopyWith$Fragment$fragmentPlayQueue.stub(_res);
}

const documentNodeMutationmovePlayQueueItem = DocumentNode(
  definitions: [
    OperationDefinitionNode(
      type: OperationType.mutation,
      name: NameNode(value: 'movePlayQueueItem'),
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
        VariableDefinitionNode(
          variable: VariableNode(name: NameNode(value: 'afterPlayQueueItemId')),
          type: NamedTypeNode(name: NameNode(value: 'ID'), isNonNull: false),
          defaultValue: DefaultValueNode(value: null),
          directives: [],
        ),
      ],
      directives: [],
      selectionSet: SelectionSetNode(
        selections: [
          FieldNode(
            name: NameNode(value: 'movePlayQueueItem'),
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
              ArgumentNode(
                name: NameNode(value: 'afterPlayQueueItemId'),
                value: VariableNode(
                  name: NameNode(value: 'afterPlayQueueItemId'),
                ),
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

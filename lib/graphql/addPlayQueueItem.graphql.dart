import 'fragmentCredit.graphql.dart';
import 'fragmentEpisode.graphql.dart';
import 'fragmentImages.graphql.dart';
import 'fragmentMediafiles.graphql.dart';
import 'fragmentMetadata.graphql.dart';
import 'fragmentMovie.graphql.dart';
import 'fragmentPlayQueue.graphql.dart';
import 'package:gql/ast.dart';
import 'schema.graphql.dart';

class Variables$Mutation$addPlayQueueItem {
  factory Variables$Mutation$addPlayQueueItem({
    required String playQueueId,
    required Enum$MediaType mediaType,
    required String mediaId,
    String? afterPlayQueueItemId,
  }) => Variables$Mutation$addPlayQueueItem._({
    r'playQueueId': playQueueId,
    r'mediaType': mediaType,
    r'mediaId': mediaId,
    if (afterPlayQueueItemId != null)
      r'afterPlayQueueItemId': afterPlayQueueItemId,
  });

  Variables$Mutation$addPlayQueueItem._(this._$data);

  factory Variables$Mutation$addPlayQueueItem.fromJson(
    Map<String, dynamic> data,
  ) {
    final result$data = <String, dynamic>{};
    final l$playQueueId = data['playQueueId'];
    result$data['playQueueId'] = (l$playQueueId as String);
    final l$mediaType = data['mediaType'];
    result$data['mediaType'] = fromJson$Enum$MediaType((l$mediaType as String));
    final l$mediaId = data['mediaId'];
    result$data['mediaId'] = (l$mediaId as String);
    if (data.containsKey('afterPlayQueueItemId')) {
      final l$afterPlayQueueItemId = data['afterPlayQueueItemId'];
      result$data['afterPlayQueueItemId'] = (l$afterPlayQueueItemId as String?);
    }
    return Variables$Mutation$addPlayQueueItem._(result$data);
  }

  Map<String, dynamic> _$data;

  String get playQueueId => (_$data['playQueueId'] as String);

  Enum$MediaType get mediaType => (_$data['mediaType'] as Enum$MediaType);

  String get mediaId => (_$data['mediaId'] as String);

  String? get afterPlayQueueItemId =>
      (_$data['afterPlayQueueItemId'] as String?);

  Map<String, dynamic> toJson() {
    final result$data = <String, dynamic>{};
    final l$playQueueId = playQueueId;
    result$data['playQueueId'] = l$playQueueId;
    final l$mediaType = mediaType;
    result$data['mediaType'] = toJson$Enum$MediaType(l$mediaType);
    final l$mediaId = mediaId;
    result$data['mediaId'] = l$mediaId;
    if (_$data.containsKey('afterPlayQueueItemId')) {
      final l$afterPlayQueueItemId = afterPlayQueueItemId;
      result$data['afterPlayQueueItemId'] = l$afterPlayQueueItemId;
    }
    return result$data;
  }

  CopyWith$Variables$Mutation$addPlayQueueItem<
    Variables$Mutation$addPlayQueueItem
  >
  get copyWith => CopyWith$Variables$Mutation$addPlayQueueItem(this, (i) => i);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Variables$Mutation$addPlayQueueItem ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$playQueueId = playQueueId;
    final lOther$playQueueId = other.playQueueId;
    if (l$playQueueId != lOther$playQueueId) {
      return false;
    }
    final l$mediaType = mediaType;
    final lOther$mediaType = other.mediaType;
    if (l$mediaType != lOther$mediaType) {
      return false;
    }
    final l$mediaId = mediaId;
    final lOther$mediaId = other.mediaId;
    if (l$mediaId != lOther$mediaId) {
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
    final l$mediaType = mediaType;
    final l$mediaId = mediaId;
    final l$afterPlayQueueItemId = afterPlayQueueItemId;
    return Object.hashAll([
      l$playQueueId,
      l$mediaType,
      l$mediaId,
      _$data.containsKey('afterPlayQueueItemId')
          ? l$afterPlayQueueItemId
          : const {},
    ]);
  }
}

abstract class CopyWith$Variables$Mutation$addPlayQueueItem<TRes> {
  factory CopyWith$Variables$Mutation$addPlayQueueItem(
    Variables$Mutation$addPlayQueueItem instance,
    TRes Function(Variables$Mutation$addPlayQueueItem) then,
  ) = _CopyWithImpl$Variables$Mutation$addPlayQueueItem;

  factory CopyWith$Variables$Mutation$addPlayQueueItem.stub(TRes res) =
      _CopyWithStubImpl$Variables$Mutation$addPlayQueueItem;

  TRes call({
    String? playQueueId,
    Enum$MediaType? mediaType,
    String? mediaId,
    String? afterPlayQueueItemId,
  });
}

class _CopyWithImpl$Variables$Mutation$addPlayQueueItem<TRes>
    implements CopyWith$Variables$Mutation$addPlayQueueItem<TRes> {
  _CopyWithImpl$Variables$Mutation$addPlayQueueItem(this._instance, this._then);

  final Variables$Mutation$addPlayQueueItem _instance;

  final TRes Function(Variables$Mutation$addPlayQueueItem) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? playQueueId = _undefined,
    Object? mediaType = _undefined,
    Object? mediaId = _undefined,
    Object? afterPlayQueueItemId = _undefined,
  }) => _then(
    Variables$Mutation$addPlayQueueItem._({
      ..._instance._$data,
      if (playQueueId != _undefined && playQueueId != null)
        'playQueueId': (playQueueId as String),
      if (mediaType != _undefined && mediaType != null)
        'mediaType': (mediaType as Enum$MediaType),
      if (mediaId != _undefined && mediaId != null)
        'mediaId': (mediaId as String),
      if (afterPlayQueueItemId != _undefined)
        'afterPlayQueueItemId': (afterPlayQueueItemId as String?),
    }),
  );
}

class _CopyWithStubImpl$Variables$Mutation$addPlayQueueItem<TRes>
    implements CopyWith$Variables$Mutation$addPlayQueueItem<TRes> {
  _CopyWithStubImpl$Variables$Mutation$addPlayQueueItem(this._res);

  TRes _res;

  call({
    String? playQueueId,
    Enum$MediaType? mediaType,
    String? mediaId,
    String? afterPlayQueueItemId,
  }) => _res;
}

class Mutation$addPlayQueueItem {
  Mutation$addPlayQueueItem({
    required this.addPlayQueueItem,
    this.$__typename = 'Mutation',
  });

  factory Mutation$addPlayQueueItem.fromJson(Map<String, dynamic> json) {
    final l$addPlayQueueItem = json['addPlayQueueItem'];
    final l$$__typename = json['__typename'];
    return Mutation$addPlayQueueItem(
      addPlayQueueItem: Fragment$fragmentPlayQueue.fromJson(
        (l$addPlayQueueItem as Map<String, dynamic>),
      ),
      $__typename: (l$$__typename as String),
    );
  }

  final Fragment$fragmentPlayQueue addPlayQueueItem;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$addPlayQueueItem = addPlayQueueItem;
    _resultData['addPlayQueueItem'] = l$addPlayQueueItem.toJson();
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$addPlayQueueItem = addPlayQueueItem;
    final l$$__typename = $__typename;
    return Object.hashAll([l$addPlayQueueItem, l$$__typename]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Mutation$addPlayQueueItem ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$addPlayQueueItem = addPlayQueueItem;
    final lOther$addPlayQueueItem = other.addPlayQueueItem;
    if (l$addPlayQueueItem != lOther$addPlayQueueItem) {
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

extension UtilityExtension$Mutation$addPlayQueueItem
    on Mutation$addPlayQueueItem {
  CopyWith$Mutation$addPlayQueueItem<Mutation$addPlayQueueItem> get copyWith =>
      CopyWith$Mutation$addPlayQueueItem(this, (i) => i);
}

abstract class CopyWith$Mutation$addPlayQueueItem<TRes> {
  factory CopyWith$Mutation$addPlayQueueItem(
    Mutation$addPlayQueueItem instance,
    TRes Function(Mutation$addPlayQueueItem) then,
  ) = _CopyWithImpl$Mutation$addPlayQueueItem;

  factory CopyWith$Mutation$addPlayQueueItem.stub(TRes res) =
      _CopyWithStubImpl$Mutation$addPlayQueueItem;

  TRes call({
    Fragment$fragmentPlayQueue? addPlayQueueItem,
    String? $__typename,
  });
  CopyWith$Fragment$fragmentPlayQueue<TRes> get addPlayQueueItem;
}

class _CopyWithImpl$Mutation$addPlayQueueItem<TRes>
    implements CopyWith$Mutation$addPlayQueueItem<TRes> {
  _CopyWithImpl$Mutation$addPlayQueueItem(this._instance, this._then);

  final Mutation$addPlayQueueItem _instance;

  final TRes Function(Mutation$addPlayQueueItem) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? addPlayQueueItem = _undefined,
    Object? $__typename = _undefined,
  }) => _then(
    Mutation$addPlayQueueItem(
      addPlayQueueItem:
          addPlayQueueItem == _undefined || addPlayQueueItem == null
          ? _instance.addPlayQueueItem
          : (addPlayQueueItem as Fragment$fragmentPlayQueue),
      $__typename: $__typename == _undefined || $__typename == null
          ? _instance.$__typename
          : ($__typename as String),
    ),
  );

  CopyWith$Fragment$fragmentPlayQueue<TRes> get addPlayQueueItem {
    final local$addPlayQueueItem = _instance.addPlayQueueItem;
    return CopyWith$Fragment$fragmentPlayQueue(
      local$addPlayQueueItem,
      (e) => call(addPlayQueueItem: e),
    );
  }
}

class _CopyWithStubImpl$Mutation$addPlayQueueItem<TRes>
    implements CopyWith$Mutation$addPlayQueueItem<TRes> {
  _CopyWithStubImpl$Mutation$addPlayQueueItem(this._res);

  TRes _res;

  call({Fragment$fragmentPlayQueue? addPlayQueueItem, String? $__typename}) =>
      _res;

  CopyWith$Fragment$fragmentPlayQueue<TRes> get addPlayQueueItem =>
      CopyWith$Fragment$fragmentPlayQueue.stub(_res);
}

const documentNodeMutationaddPlayQueueItem = DocumentNode(
  definitions: [
    OperationDefinitionNode(
      type: OperationType.mutation,
      name: NameNode(value: 'addPlayQueueItem'),
      variableDefinitions: [
        VariableDefinitionNode(
          variable: VariableNode(name: NameNode(value: 'playQueueId')),
          type: NamedTypeNode(name: NameNode(value: 'ID'), isNonNull: true),
          defaultValue: DefaultValueNode(value: null),
          directives: [],
        ),
        VariableDefinitionNode(
          variable: VariableNode(name: NameNode(value: 'mediaType')),
          type: NamedTypeNode(
            name: NameNode(value: 'MediaType'),
            isNonNull: true,
          ),
          defaultValue: DefaultValueNode(value: null),
          directives: [],
        ),
        VariableDefinitionNode(
          variable: VariableNode(name: NameNode(value: 'mediaId')),
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
            name: NameNode(value: 'addPlayQueueItem'),
            alias: null,
            arguments: [
              ArgumentNode(
                name: NameNode(value: 'playQueueId'),
                value: VariableNode(name: NameNode(value: 'playQueueId')),
              ),
              ArgumentNode(
                name: NameNode(value: 'mediaType'),
                value: VariableNode(name: NameNode(value: 'mediaType')),
              ),
              ArgumentNode(
                name: NameNode(value: 'mediaId'),
                value: VariableNode(name: NameNode(value: 'mediaId')),
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
  ],
);

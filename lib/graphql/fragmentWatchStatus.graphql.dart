import 'package:gql/ast.dart';

class Fragment$fragmentWatchStatus {
  Fragment$fragmentWatchStatus({
    required this.id,
    required this.playQueueItemId,
    required this.progressInMilliseconds,
    required this.watched,
    this.$__typename = 'WatchStatus',
  });

  factory Fragment$fragmentWatchStatus.fromJson(Map<String, dynamic> json) {
    final l$id = json['id'];
    final l$playQueueItemId = json['playQueueItemId'];
    final l$progressInMilliseconds = json['progressInMilliseconds'];
    final l$watched = json['watched'];
    final l$$__typename = json['__typename'];
    return Fragment$fragmentWatchStatus(
      id: (l$id as String),
      playQueueItemId: (l$playQueueItemId as String),
      progressInMilliseconds: (l$progressInMilliseconds as int),
      watched: (l$watched as bool),
      $__typename: (l$$__typename as String),
    );
  }

  final String id;

  final String playQueueItemId;

  final int progressInMilliseconds;

  final bool watched;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$id = id;
    _resultData['id'] = l$id;
    final l$playQueueItemId = playQueueItemId;
    _resultData['playQueueItemId'] = l$playQueueItemId;
    final l$progressInMilliseconds = progressInMilliseconds;
    _resultData['progressInMilliseconds'] = l$progressInMilliseconds;
    final l$watched = watched;
    _resultData['watched'] = l$watched;
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$id = id;
    final l$playQueueItemId = playQueueItemId;
    final l$progressInMilliseconds = progressInMilliseconds;
    final l$watched = watched;
    final l$$__typename = $__typename;
    return Object.hashAll([
      l$id,
      l$playQueueItemId,
      l$progressInMilliseconds,
      l$watched,
      l$$__typename,
    ]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Fragment$fragmentWatchStatus ||
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
    final l$watched = watched;
    final lOther$watched = other.watched;
    if (l$watched != lOther$watched) {
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

extension UtilityExtension$Fragment$fragmentWatchStatus
    on Fragment$fragmentWatchStatus {
  CopyWith$Fragment$fragmentWatchStatus<Fragment$fragmentWatchStatus>
  get copyWith => CopyWith$Fragment$fragmentWatchStatus(this, (i) => i);
}

abstract class CopyWith$Fragment$fragmentWatchStatus<TRes> {
  factory CopyWith$Fragment$fragmentWatchStatus(
    Fragment$fragmentWatchStatus instance,
    TRes Function(Fragment$fragmentWatchStatus) then,
  ) = _CopyWithImpl$Fragment$fragmentWatchStatus;

  factory CopyWith$Fragment$fragmentWatchStatus.stub(TRes res) =
      _CopyWithStubImpl$Fragment$fragmentWatchStatus;

  TRes call({
    String? id,
    String? playQueueItemId,
    int? progressInMilliseconds,
    bool? watched,
    String? $__typename,
  });
}

class _CopyWithImpl$Fragment$fragmentWatchStatus<TRes>
    implements CopyWith$Fragment$fragmentWatchStatus<TRes> {
  _CopyWithImpl$Fragment$fragmentWatchStatus(this._instance, this._then);

  final Fragment$fragmentWatchStatus _instance;

  final TRes Function(Fragment$fragmentWatchStatus) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? id = _undefined,
    Object? playQueueItemId = _undefined,
    Object? progressInMilliseconds = _undefined,
    Object? watched = _undefined,
    Object? $__typename = _undefined,
  }) => _then(
    Fragment$fragmentWatchStatus(
      id: id == _undefined || id == null ? _instance.id : (id as String),
      playQueueItemId: playQueueItemId == _undefined || playQueueItemId == null
          ? _instance.playQueueItemId
          : (playQueueItemId as String),
      progressInMilliseconds:
          progressInMilliseconds == _undefined || progressInMilliseconds == null
          ? _instance.progressInMilliseconds
          : (progressInMilliseconds as int),
      watched: watched == _undefined || watched == null
          ? _instance.watched
          : (watched as bool),
      $__typename: $__typename == _undefined || $__typename == null
          ? _instance.$__typename
          : ($__typename as String),
    ),
  );
}

class _CopyWithStubImpl$Fragment$fragmentWatchStatus<TRes>
    implements CopyWith$Fragment$fragmentWatchStatus<TRes> {
  _CopyWithStubImpl$Fragment$fragmentWatchStatus(this._res);

  TRes _res;

  call({
    String? id,
    String? playQueueItemId,
    int? progressInMilliseconds,
    bool? watched,
    String? $__typename,
  }) => _res;
}

const fragmentDefinitionfragmentWatchStatus = FragmentDefinitionNode(
  name: NameNode(value: 'fragmentWatchStatus'),
  typeCondition: TypeConditionNode(
    on: NamedTypeNode(name: NameNode(value: 'WatchStatus'), isNonNull: false),
  ),
  directives: [],
  selectionSet: SelectionSetNode(
    selections: [
      FieldNode(
        name: NameNode(value: 'id'),
        alias: null,
        arguments: [],
        directives: [],
        selectionSet: null,
      ),
      FieldNode(
        name: NameNode(value: 'playQueueItemId'),
        alias: null,
        arguments: [],
        directives: [],
        selectionSet: null,
      ),
      FieldNode(
        name: NameNode(value: 'progressInMilliseconds'),
        alias: null,
        arguments: [],
        directives: [],
        selectionSet: null,
      ),
      FieldNode(
        name: NameNode(value: 'watched'),
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
    ],
  ),
);
const documentNodeFragmentfragmentWatchStatus = DocumentNode(
  definitions: [fragmentDefinitionfragmentWatchStatus],
);

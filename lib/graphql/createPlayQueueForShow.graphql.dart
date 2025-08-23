import 'fragmentPlayQueue.graphql.dart';
import 'package:gql/ast.dart';

class Variables$Mutation$createPlayQueueForShow {
  factory Variables$Mutation$createPlayQueueForShow({
    required String id,
    required String episodeId,
  }) => Variables$Mutation$createPlayQueueForShow._({
    r'id': id,
    r'episodeId': episodeId,
  });

  Variables$Mutation$createPlayQueueForShow._(this._$data);

  factory Variables$Mutation$createPlayQueueForShow.fromJson(
    Map<String, dynamic> data,
  ) {
    final result$data = <String, dynamic>{};
    final l$id = data['id'];
    result$data['id'] = (l$id as String);
    final l$episodeId = data['episodeId'];
    result$data['episodeId'] = (l$episodeId as String);
    return Variables$Mutation$createPlayQueueForShow._(result$data);
  }

  Map<String, dynamic> _$data;

  String get id => (_$data['id'] as String);

  String get episodeId => (_$data['episodeId'] as String);

  Map<String, dynamic> toJson() {
    final result$data = <String, dynamic>{};
    final l$id = id;
    result$data['id'] = l$id;
    final l$episodeId = episodeId;
    result$data['episodeId'] = l$episodeId;
    return result$data;
  }

  CopyWith$Variables$Mutation$createPlayQueueForShow<
    Variables$Mutation$createPlayQueueForShow
  >
  get copyWith =>
      CopyWith$Variables$Mutation$createPlayQueueForShow(this, (i) => i);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Variables$Mutation$createPlayQueueForShow ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$id = id;
    final lOther$id = other.id;
    if (l$id != lOther$id) {
      return false;
    }
    final l$episodeId = episodeId;
    final lOther$episodeId = other.episodeId;
    if (l$episodeId != lOther$episodeId) {
      return false;
    }
    return true;
  }

  @override
  int get hashCode {
    final l$id = id;
    final l$episodeId = episodeId;
    return Object.hashAll([l$id, l$episodeId]);
  }
}

abstract class CopyWith$Variables$Mutation$createPlayQueueForShow<TRes> {
  factory CopyWith$Variables$Mutation$createPlayQueueForShow(
    Variables$Mutation$createPlayQueueForShow instance,
    TRes Function(Variables$Mutation$createPlayQueueForShow) then,
  ) = _CopyWithImpl$Variables$Mutation$createPlayQueueForShow;

  factory CopyWith$Variables$Mutation$createPlayQueueForShow.stub(TRes res) =
      _CopyWithStubImpl$Variables$Mutation$createPlayQueueForShow;

  TRes call({String? id, String? episodeId});
}

class _CopyWithImpl$Variables$Mutation$createPlayQueueForShow<TRes>
    implements CopyWith$Variables$Mutation$createPlayQueueForShow<TRes> {
  _CopyWithImpl$Variables$Mutation$createPlayQueueForShow(
    this._instance,
    this._then,
  );

  final Variables$Mutation$createPlayQueueForShow _instance;

  final TRes Function(Variables$Mutation$createPlayQueueForShow) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({Object? id = _undefined, Object? episodeId = _undefined}) => _then(
    Variables$Mutation$createPlayQueueForShow._({
      ..._instance._$data,
      if (id != _undefined && id != null) 'id': (id as String),
      if (episodeId != _undefined && episodeId != null)
        'episodeId': (episodeId as String),
    }),
  );
}

class _CopyWithStubImpl$Variables$Mutation$createPlayQueueForShow<TRes>
    implements CopyWith$Variables$Mutation$createPlayQueueForShow<TRes> {
  _CopyWithStubImpl$Variables$Mutation$createPlayQueueForShow(this._res);

  TRes _res;

  call({String? id, String? episodeId}) => _res;
}

class Mutation$createPlayQueueForShow {
  Mutation$createPlayQueueForShow({
    required this.createPlayQueueForShow,
    this.$__typename = 'Mutation',
  });

  factory Mutation$createPlayQueueForShow.fromJson(Map<String, dynamic> json) {
    final l$createPlayQueueForShow = json['createPlayQueueForShow'];
    final l$$__typename = json['__typename'];
    return Mutation$createPlayQueueForShow(
      createPlayQueueForShow: Fragment$fragmentPlayQueue.fromJson(
        (l$createPlayQueueForShow as Map<String, dynamic>),
      ),
      $__typename: (l$$__typename as String),
    );
  }

  final Fragment$fragmentPlayQueue createPlayQueueForShow;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$createPlayQueueForShow = createPlayQueueForShow;
    _resultData['createPlayQueueForShow'] = l$createPlayQueueForShow.toJson();
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$createPlayQueueForShow = createPlayQueueForShow;
    final l$$__typename = $__typename;
    return Object.hashAll([l$createPlayQueueForShow, l$$__typename]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Mutation$createPlayQueueForShow ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$createPlayQueueForShow = createPlayQueueForShow;
    final lOther$createPlayQueueForShow = other.createPlayQueueForShow;
    if (l$createPlayQueueForShow != lOther$createPlayQueueForShow) {
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

extension UtilityExtension$Mutation$createPlayQueueForShow
    on Mutation$createPlayQueueForShow {
  CopyWith$Mutation$createPlayQueueForShow<Mutation$createPlayQueueForShow>
  get copyWith => CopyWith$Mutation$createPlayQueueForShow(this, (i) => i);
}

abstract class CopyWith$Mutation$createPlayQueueForShow<TRes> {
  factory CopyWith$Mutation$createPlayQueueForShow(
    Mutation$createPlayQueueForShow instance,
    TRes Function(Mutation$createPlayQueueForShow) then,
  ) = _CopyWithImpl$Mutation$createPlayQueueForShow;

  factory CopyWith$Mutation$createPlayQueueForShow.stub(TRes res) =
      _CopyWithStubImpl$Mutation$createPlayQueueForShow;

  TRes call({
    Fragment$fragmentPlayQueue? createPlayQueueForShow,
    String? $__typename,
  });
  CopyWith$Fragment$fragmentPlayQueue<TRes> get createPlayQueueForShow;
}

class _CopyWithImpl$Mutation$createPlayQueueForShow<TRes>
    implements CopyWith$Mutation$createPlayQueueForShow<TRes> {
  _CopyWithImpl$Mutation$createPlayQueueForShow(this._instance, this._then);

  final Mutation$createPlayQueueForShow _instance;

  final TRes Function(Mutation$createPlayQueueForShow) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? createPlayQueueForShow = _undefined,
    Object? $__typename = _undefined,
  }) => _then(
    Mutation$createPlayQueueForShow(
      createPlayQueueForShow:
          createPlayQueueForShow == _undefined || createPlayQueueForShow == null
          ? _instance.createPlayQueueForShow
          : (createPlayQueueForShow as Fragment$fragmentPlayQueue),
      $__typename: $__typename == _undefined || $__typename == null
          ? _instance.$__typename
          : ($__typename as String),
    ),
  );

  CopyWith$Fragment$fragmentPlayQueue<TRes> get createPlayQueueForShow {
    final local$createPlayQueueForShow = _instance.createPlayQueueForShow;
    return CopyWith$Fragment$fragmentPlayQueue(
      local$createPlayQueueForShow,
      (e) => call(createPlayQueueForShow: e),
    );
  }
}

class _CopyWithStubImpl$Mutation$createPlayQueueForShow<TRes>
    implements CopyWith$Mutation$createPlayQueueForShow<TRes> {
  _CopyWithStubImpl$Mutation$createPlayQueueForShow(this._res);

  TRes _res;

  call({
    Fragment$fragmentPlayQueue? createPlayQueueForShow,
    String? $__typename,
  }) => _res;

  CopyWith$Fragment$fragmentPlayQueue<TRes> get createPlayQueueForShow =>
      CopyWith$Fragment$fragmentPlayQueue.stub(_res);
}

const documentNodeMutationcreatePlayQueueForShow = DocumentNode(
  definitions: [
    OperationDefinitionNode(
      type: OperationType.mutation,
      name: NameNode(value: 'createPlayQueueForShow'),
      variableDefinitions: [
        VariableDefinitionNode(
          variable: VariableNode(name: NameNode(value: 'id')),
          type: NamedTypeNode(name: NameNode(value: 'ID'), isNonNull: true),
          defaultValue: DefaultValueNode(value: null),
          directives: [],
        ),
        VariableDefinitionNode(
          variable: VariableNode(name: NameNode(value: 'episodeId')),
          type: NamedTypeNode(name: NameNode(value: 'ID'), isNonNull: true),
          defaultValue: DefaultValueNode(value: null),
          directives: [],
        ),
      ],
      directives: [],
      selectionSet: SelectionSetNode(
        selections: [
          FieldNode(
            name: NameNode(value: 'createPlayQueueForShow'),
            alias: null,
            arguments: [
              ArgumentNode(
                name: NameNode(value: 'showId'),
                value: VariableNode(name: NameNode(value: 'id')),
              ),
              ArgumentNode(
                name: NameNode(value: 'episodeId'),
                value: VariableNode(name: NameNode(value: 'episodeId')),
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
  ],
);

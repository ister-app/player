import 'fragmentCredit.graphql.dart';
import 'fragmentEpisode.graphql.dart';
import 'fragmentImages.graphql.dart';
import 'fragmentMediafiles.graphql.dart';
import 'fragmentMetadata.graphql.dart';
import 'fragmentMovie.graphql.dart';
import 'fragmentPlayQueue.graphql.dart';
import 'fragmentWatchStatus.graphql.dart';
import 'package:gql/ast.dart';

class Variables$Mutation$addPlayQueueAlbum {
  factory Variables$Mutation$addPlayQueueAlbum({
    required String playQueueId,
    required String albumId,
  }) => Variables$Mutation$addPlayQueueAlbum._({
    r'playQueueId': playQueueId,
    r'albumId': albumId,
  });

  Variables$Mutation$addPlayQueueAlbum._(this._$data);

  factory Variables$Mutation$addPlayQueueAlbum.fromJson(
    Map<String, dynamic> data,
  ) {
    final result$data = <String, dynamic>{};
    final l$playQueueId = data['playQueueId'];
    result$data['playQueueId'] = (l$playQueueId as String);
    final l$albumId = data['albumId'];
    result$data['albumId'] = (l$albumId as String);
    return Variables$Mutation$addPlayQueueAlbum._(result$data);
  }

  Map<String, dynamic> _$data;

  String get playQueueId => (_$data['playQueueId'] as String);

  String get albumId => (_$data['albumId'] as String);

  Map<String, dynamic> toJson() {
    final result$data = <String, dynamic>{};
    final l$playQueueId = playQueueId;
    result$data['playQueueId'] = l$playQueueId;
    final l$albumId = albumId;
    result$data['albumId'] = l$albumId;
    return result$data;
  }

  CopyWith$Variables$Mutation$addPlayQueueAlbum<
    Variables$Mutation$addPlayQueueAlbum
  >
  get copyWith => CopyWith$Variables$Mutation$addPlayQueueAlbum(this, (i) => i);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Variables$Mutation$addPlayQueueAlbum ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$playQueueId = playQueueId;
    final lOther$playQueueId = other.playQueueId;
    if (l$playQueueId != lOther$playQueueId) {
      return false;
    }
    final l$albumId = albumId;
    final lOther$albumId = other.albumId;
    if (l$albumId != lOther$albumId) {
      return false;
    }
    return true;
  }

  @override
  int get hashCode {
    final l$playQueueId = playQueueId;
    final l$albumId = albumId;
    return Object.hashAll([l$playQueueId, l$albumId]);
  }
}

abstract class CopyWith$Variables$Mutation$addPlayQueueAlbum<TRes> {
  factory CopyWith$Variables$Mutation$addPlayQueueAlbum(
    Variables$Mutation$addPlayQueueAlbum instance,
    TRes Function(Variables$Mutation$addPlayQueueAlbum) then,
  ) = _CopyWithImpl$Variables$Mutation$addPlayQueueAlbum;

  factory CopyWith$Variables$Mutation$addPlayQueueAlbum.stub(TRes res) =
      _CopyWithStubImpl$Variables$Mutation$addPlayQueueAlbum;

  TRes call({String? playQueueId, String? albumId});
}

class _CopyWithImpl$Variables$Mutation$addPlayQueueAlbum<TRes>
    implements CopyWith$Variables$Mutation$addPlayQueueAlbum<TRes> {
  _CopyWithImpl$Variables$Mutation$addPlayQueueAlbum(
    this._instance,
    this._then,
  );

  final Variables$Mutation$addPlayQueueAlbum _instance;

  final TRes Function(Variables$Mutation$addPlayQueueAlbum) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({Object? playQueueId = _undefined, Object? albumId = _undefined}) =>
      _then(
        Variables$Mutation$addPlayQueueAlbum._({
          ..._instance._$data,
          if (playQueueId != _undefined && playQueueId != null)
            'playQueueId': (playQueueId as String),
          if (albumId != _undefined && albumId != null)
            'albumId': (albumId as String),
        }),
      );
}

class _CopyWithStubImpl$Variables$Mutation$addPlayQueueAlbum<TRes>
    implements CopyWith$Variables$Mutation$addPlayQueueAlbum<TRes> {
  _CopyWithStubImpl$Variables$Mutation$addPlayQueueAlbum(this._res);

  TRes _res;

  call({String? playQueueId, String? albumId}) => _res;
}

class Mutation$addPlayQueueAlbum {
  Mutation$addPlayQueueAlbum({
    required this.addPlayQueueAlbum,
    this.$__typename = 'Mutation',
  });

  factory Mutation$addPlayQueueAlbum.fromJson(Map<String, dynamic> json) {
    final l$addPlayQueueAlbum = json['addPlayQueueAlbum'];
    final l$$__typename = json['__typename'];
    return Mutation$addPlayQueueAlbum(
      addPlayQueueAlbum: Fragment$fragmentPlayQueue.fromJson(
        (l$addPlayQueueAlbum as Map<String, dynamic>),
      ),
      $__typename: (l$$__typename as String),
    );
  }

  final Fragment$fragmentPlayQueue addPlayQueueAlbum;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$addPlayQueueAlbum = addPlayQueueAlbum;
    _resultData['addPlayQueueAlbum'] = l$addPlayQueueAlbum.toJson();
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$addPlayQueueAlbum = addPlayQueueAlbum;
    final l$$__typename = $__typename;
    return Object.hashAll([l$addPlayQueueAlbum, l$$__typename]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Mutation$addPlayQueueAlbum ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$addPlayQueueAlbum = addPlayQueueAlbum;
    final lOther$addPlayQueueAlbum = other.addPlayQueueAlbum;
    if (l$addPlayQueueAlbum != lOther$addPlayQueueAlbum) {
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

extension UtilityExtension$Mutation$addPlayQueueAlbum
    on Mutation$addPlayQueueAlbum {
  CopyWith$Mutation$addPlayQueueAlbum<Mutation$addPlayQueueAlbum>
  get copyWith => CopyWith$Mutation$addPlayQueueAlbum(this, (i) => i);
}

abstract class CopyWith$Mutation$addPlayQueueAlbum<TRes> {
  factory CopyWith$Mutation$addPlayQueueAlbum(
    Mutation$addPlayQueueAlbum instance,
    TRes Function(Mutation$addPlayQueueAlbum) then,
  ) = _CopyWithImpl$Mutation$addPlayQueueAlbum;

  factory CopyWith$Mutation$addPlayQueueAlbum.stub(TRes res) =
      _CopyWithStubImpl$Mutation$addPlayQueueAlbum;

  TRes call({
    Fragment$fragmentPlayQueue? addPlayQueueAlbum,
    String? $__typename,
  });
  CopyWith$Fragment$fragmentPlayQueue<TRes> get addPlayQueueAlbum;
}

class _CopyWithImpl$Mutation$addPlayQueueAlbum<TRes>
    implements CopyWith$Mutation$addPlayQueueAlbum<TRes> {
  _CopyWithImpl$Mutation$addPlayQueueAlbum(this._instance, this._then);

  final Mutation$addPlayQueueAlbum _instance;

  final TRes Function(Mutation$addPlayQueueAlbum) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? addPlayQueueAlbum = _undefined,
    Object? $__typename = _undefined,
  }) => _then(
    Mutation$addPlayQueueAlbum(
      addPlayQueueAlbum:
          addPlayQueueAlbum == _undefined || addPlayQueueAlbum == null
          ? _instance.addPlayQueueAlbum
          : (addPlayQueueAlbum as Fragment$fragmentPlayQueue),
      $__typename: $__typename == _undefined || $__typename == null
          ? _instance.$__typename
          : ($__typename as String),
    ),
  );

  CopyWith$Fragment$fragmentPlayQueue<TRes> get addPlayQueueAlbum {
    final local$addPlayQueueAlbum = _instance.addPlayQueueAlbum;
    return CopyWith$Fragment$fragmentPlayQueue(
      local$addPlayQueueAlbum,
      (e) => call(addPlayQueueAlbum: e),
    );
  }
}

class _CopyWithStubImpl$Mutation$addPlayQueueAlbum<TRes>
    implements CopyWith$Mutation$addPlayQueueAlbum<TRes> {
  _CopyWithStubImpl$Mutation$addPlayQueueAlbum(this._res);

  TRes _res;

  call({Fragment$fragmentPlayQueue? addPlayQueueAlbum, String? $__typename}) =>
      _res;

  CopyWith$Fragment$fragmentPlayQueue<TRes> get addPlayQueueAlbum =>
      CopyWith$Fragment$fragmentPlayQueue.stub(_res);
}

const documentNodeMutationaddPlayQueueAlbum = DocumentNode(
  definitions: [
    OperationDefinitionNode(
      type: OperationType.mutation,
      name: NameNode(value: 'addPlayQueueAlbum'),
      variableDefinitions: [
        VariableDefinitionNode(
          variable: VariableNode(name: NameNode(value: 'playQueueId')),
          type: NamedTypeNode(name: NameNode(value: 'ID'), isNonNull: true),
          defaultValue: DefaultValueNode(value: null),
          directives: [],
        ),
        VariableDefinitionNode(
          variable: VariableNode(name: NameNode(value: 'albumId')),
          type: NamedTypeNode(name: NameNode(value: 'ID'), isNonNull: true),
          defaultValue: DefaultValueNode(value: null),
          directives: [],
        ),
      ],
      directives: [],
      selectionSet: SelectionSetNode(
        selections: [
          FieldNode(
            name: NameNode(value: 'addPlayQueueAlbum'),
            alias: null,
            arguments: [
              ArgumentNode(
                name: NameNode(value: 'playQueueId'),
                value: VariableNode(name: NameNode(value: 'playQueueId')),
              ),
              ArgumentNode(
                name: NameNode(value: 'albumId'),
                value: VariableNode(name: NameNode(value: 'albumId')),
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

import 'fragmentCredit.graphql.dart';
import 'fragmentEpisode.graphql.dart';
import 'fragmentImages.graphql.dart';
import 'fragmentMediafiles.graphql.dart';
import 'fragmentMetadata.graphql.dart';
import 'fragmentMovie.graphql.dart';
import 'fragmentPlayQueue.graphql.dart';
import 'package:gql/ast.dart';

class Variables$Mutation$createPlayQueueForAlbum {
  factory Variables$Mutation$createPlayQueueForAlbum({
    required String albumId,
    required String trackId,
  }) => Variables$Mutation$createPlayQueueForAlbum._({
    r'albumId': albumId,
    r'trackId': trackId,
  });

  Variables$Mutation$createPlayQueueForAlbum._(this._$data);

  factory Variables$Mutation$createPlayQueueForAlbum.fromJson(
    Map<String, dynamic> data,
  ) {
    final result$data = <String, dynamic>{};
    final l$albumId = data['albumId'];
    result$data['albumId'] = (l$albumId as String);
    final l$trackId = data['trackId'];
    result$data['trackId'] = (l$trackId as String);
    return Variables$Mutation$createPlayQueueForAlbum._(result$data);
  }

  Map<String, dynamic> _$data;

  String get albumId => (_$data['albumId'] as String);

  String get trackId => (_$data['trackId'] as String);

  Map<String, dynamic> toJson() {
    final result$data = <String, dynamic>{};
    final l$albumId = albumId;
    result$data['albumId'] = l$albumId;
    final l$trackId = trackId;
    result$data['trackId'] = l$trackId;
    return result$data;
  }

  CopyWith$Variables$Mutation$createPlayQueueForAlbum<
    Variables$Mutation$createPlayQueueForAlbum
  >
  get copyWith =>
      CopyWith$Variables$Mutation$createPlayQueueForAlbum(this, (i) => i);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Variables$Mutation$createPlayQueueForAlbum ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$albumId = albumId;
    final lOther$albumId = other.albumId;
    if (l$albumId != lOther$albumId) {
      return false;
    }
    final l$trackId = trackId;
    final lOther$trackId = other.trackId;
    if (l$trackId != lOther$trackId) {
      return false;
    }
    return true;
  }

  @override
  int get hashCode {
    final l$albumId = albumId;
    final l$trackId = trackId;
    return Object.hashAll([l$albumId, l$trackId]);
  }
}

abstract class CopyWith$Variables$Mutation$createPlayQueueForAlbum<TRes> {
  factory CopyWith$Variables$Mutation$createPlayQueueForAlbum(
    Variables$Mutation$createPlayQueueForAlbum instance,
    TRes Function(Variables$Mutation$createPlayQueueForAlbum) then,
  ) = _CopyWithImpl$Variables$Mutation$createPlayQueueForAlbum;

  factory CopyWith$Variables$Mutation$createPlayQueueForAlbum.stub(TRes res) =
      _CopyWithStubImpl$Variables$Mutation$createPlayQueueForAlbum;

  TRes call({String? albumId, String? trackId});
}

class _CopyWithImpl$Variables$Mutation$createPlayQueueForAlbum<TRes>
    implements CopyWith$Variables$Mutation$createPlayQueueForAlbum<TRes> {
  _CopyWithImpl$Variables$Mutation$createPlayQueueForAlbum(
    this._instance,
    this._then,
  );

  final Variables$Mutation$createPlayQueueForAlbum _instance;

  final TRes Function(Variables$Mutation$createPlayQueueForAlbum) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({Object? albumId = _undefined, Object? trackId = _undefined}) =>
      _then(
        Variables$Mutation$createPlayQueueForAlbum._({
          ..._instance._$data,
          if (albumId != _undefined && albumId != null)
            'albumId': (albumId as String),
          if (trackId != _undefined && trackId != null)
            'trackId': (trackId as String),
        }),
      );
}

class _CopyWithStubImpl$Variables$Mutation$createPlayQueueForAlbum<TRes>
    implements CopyWith$Variables$Mutation$createPlayQueueForAlbum<TRes> {
  _CopyWithStubImpl$Variables$Mutation$createPlayQueueForAlbum(this._res);

  TRes _res;

  call({String? albumId, String? trackId}) => _res;
}

class Mutation$createPlayQueueForAlbum {
  Mutation$createPlayQueueForAlbum({
    required this.createPlayQueueForAlbum,
    this.$__typename = 'Mutation',
  });

  factory Mutation$createPlayQueueForAlbum.fromJson(Map<String, dynamic> json) {
    final l$createPlayQueueForAlbum = json['createPlayQueueForAlbum'];
    final l$$__typename = json['__typename'];
    return Mutation$createPlayQueueForAlbum(
      createPlayQueueForAlbum: Fragment$fragmentPlayQueue.fromJson(
        (l$createPlayQueueForAlbum as Map<String, dynamic>),
      ),
      $__typename: (l$$__typename as String),
    );
  }

  final Fragment$fragmentPlayQueue createPlayQueueForAlbum;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$createPlayQueueForAlbum = createPlayQueueForAlbum;
    _resultData['createPlayQueueForAlbum'] = l$createPlayQueueForAlbum.toJson();
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$createPlayQueueForAlbum = createPlayQueueForAlbum;
    final l$$__typename = $__typename;
    return Object.hashAll([l$createPlayQueueForAlbum, l$$__typename]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Mutation$createPlayQueueForAlbum ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$createPlayQueueForAlbum = createPlayQueueForAlbum;
    final lOther$createPlayQueueForAlbum = other.createPlayQueueForAlbum;
    if (l$createPlayQueueForAlbum != lOther$createPlayQueueForAlbum) {
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

extension UtilityExtension$Mutation$createPlayQueueForAlbum
    on Mutation$createPlayQueueForAlbum {
  CopyWith$Mutation$createPlayQueueForAlbum<Mutation$createPlayQueueForAlbum>
  get copyWith => CopyWith$Mutation$createPlayQueueForAlbum(this, (i) => i);
}

abstract class CopyWith$Mutation$createPlayQueueForAlbum<TRes> {
  factory CopyWith$Mutation$createPlayQueueForAlbum(
    Mutation$createPlayQueueForAlbum instance,
    TRes Function(Mutation$createPlayQueueForAlbum) then,
  ) = _CopyWithImpl$Mutation$createPlayQueueForAlbum;

  factory CopyWith$Mutation$createPlayQueueForAlbum.stub(TRes res) =
      _CopyWithStubImpl$Mutation$createPlayQueueForAlbum;

  TRes call({
    Fragment$fragmentPlayQueue? createPlayQueueForAlbum,
    String? $__typename,
  });
  CopyWith$Fragment$fragmentPlayQueue<TRes> get createPlayQueueForAlbum;
}

class _CopyWithImpl$Mutation$createPlayQueueForAlbum<TRes>
    implements CopyWith$Mutation$createPlayQueueForAlbum<TRes> {
  _CopyWithImpl$Mutation$createPlayQueueForAlbum(this._instance, this._then);

  final Mutation$createPlayQueueForAlbum _instance;

  final TRes Function(Mutation$createPlayQueueForAlbum) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? createPlayQueueForAlbum = _undefined,
    Object? $__typename = _undefined,
  }) => _then(
    Mutation$createPlayQueueForAlbum(
      createPlayQueueForAlbum:
          createPlayQueueForAlbum == _undefined ||
              createPlayQueueForAlbum == null
          ? _instance.createPlayQueueForAlbum
          : (createPlayQueueForAlbum as Fragment$fragmentPlayQueue),
      $__typename: $__typename == _undefined || $__typename == null
          ? _instance.$__typename
          : ($__typename as String),
    ),
  );

  CopyWith$Fragment$fragmentPlayQueue<TRes> get createPlayQueueForAlbum {
    final local$createPlayQueueForAlbum = _instance.createPlayQueueForAlbum;
    return CopyWith$Fragment$fragmentPlayQueue(
      local$createPlayQueueForAlbum,
      (e) => call(createPlayQueueForAlbum: e),
    );
  }
}

class _CopyWithStubImpl$Mutation$createPlayQueueForAlbum<TRes>
    implements CopyWith$Mutation$createPlayQueueForAlbum<TRes> {
  _CopyWithStubImpl$Mutation$createPlayQueueForAlbum(this._res);

  TRes _res;

  call({
    Fragment$fragmentPlayQueue? createPlayQueueForAlbum,
    String? $__typename,
  }) => _res;

  CopyWith$Fragment$fragmentPlayQueue<TRes> get createPlayQueueForAlbum =>
      CopyWith$Fragment$fragmentPlayQueue.stub(_res);
}

const documentNodeMutationcreatePlayQueueForAlbum = DocumentNode(
  definitions: [
    OperationDefinitionNode(
      type: OperationType.mutation,
      name: NameNode(value: 'createPlayQueueForAlbum'),
      variableDefinitions: [
        VariableDefinitionNode(
          variable: VariableNode(name: NameNode(value: 'albumId')),
          type: NamedTypeNode(name: NameNode(value: 'ID'), isNonNull: true),
          defaultValue: DefaultValueNode(value: null),
          directives: [],
        ),
        VariableDefinitionNode(
          variable: VariableNode(name: NameNode(value: 'trackId')),
          type: NamedTypeNode(name: NameNode(value: 'ID'), isNonNull: true),
          defaultValue: DefaultValueNode(value: null),
          directives: [],
        ),
      ],
      directives: [],
      selectionSet: SelectionSetNode(
        selections: [
          FieldNode(
            name: NameNode(value: 'createPlayQueueForAlbum'),
            alias: null,
            arguments: [
              ArgumentNode(
                name: NameNode(value: 'albumId'),
                value: VariableNode(name: NameNode(value: 'albumId')),
              ),
              ArgumentNode(
                name: NameNode(value: 'trackId'),
                value: VariableNode(name: NameNode(value: 'trackId')),
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

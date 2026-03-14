import 'fragmentEpisode.graphql.dart';
import 'fragmentImages.graphql.dart';
import 'fragmentMediafiles.graphql.dart';
import 'fragmentMetadata.graphql.dart';
import 'package:gql/ast.dart';

class Variables$Query$episodeById {
  factory Variables$Query$episodeById({required String id}) =>
      Variables$Query$episodeById._({r'id': id});

  Variables$Query$episodeById._(this._$data);

  factory Variables$Query$episodeById.fromJson(Map<String, dynamic> data) {
    final result$data = <String, dynamic>{};
    final l$id = data['id'];
    result$data['id'] = (l$id as String);
    return Variables$Query$episodeById._(result$data);
  }

  Map<String, dynamic> _$data;

  String get id => (_$data['id'] as String);

  Map<String, dynamic> toJson() {
    final result$data = <String, dynamic>{};
    final l$id = id;
    result$data['id'] = l$id;
    return result$data;
  }

  CopyWith$Variables$Query$episodeById<Variables$Query$episodeById>
  get copyWith => CopyWith$Variables$Query$episodeById(this, (i) => i);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Variables$Query$episodeById ||
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

abstract class CopyWith$Variables$Query$episodeById<TRes> {
  factory CopyWith$Variables$Query$episodeById(
    Variables$Query$episodeById instance,
    TRes Function(Variables$Query$episodeById) then,
  ) = _CopyWithImpl$Variables$Query$episodeById;

  factory CopyWith$Variables$Query$episodeById.stub(TRes res) =
      _CopyWithStubImpl$Variables$Query$episodeById;

  TRes call({String? id});
}

class _CopyWithImpl$Variables$Query$episodeById<TRes>
    implements CopyWith$Variables$Query$episodeById<TRes> {
  _CopyWithImpl$Variables$Query$episodeById(this._instance, this._then);

  final Variables$Query$episodeById _instance;

  final TRes Function(Variables$Query$episodeById) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({Object? id = _undefined}) => _then(
    Variables$Query$episodeById._({
      ..._instance._$data,
      if (id != _undefined && id != null) 'id': (id as String),
    }),
  );
}

class _CopyWithStubImpl$Variables$Query$episodeById<TRes>
    implements CopyWith$Variables$Query$episodeById<TRes> {
  _CopyWithStubImpl$Variables$Query$episodeById(this._res);

  TRes _res;

  call({String? id}) => _res;
}

class Query$episodeById {
  Query$episodeById({this.episodeById, this.$__typename = 'Query'});

  factory Query$episodeById.fromJson(Map<String, dynamic> json) {
    final l$episodeById = json['episodeById'];
    final l$$__typename = json['__typename'];
    return Query$episodeById(
      episodeById: l$episodeById == null
          ? null
          : Fragment$fragmentEpisode.fromJson(
              (l$episodeById as Map<String, dynamic>),
            ),
      $__typename: (l$$__typename as String),
    );
  }

  final Fragment$fragmentEpisode? episodeById;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$episodeById = episodeById;
    _resultData['episodeById'] = l$episodeById?.toJson();
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$episodeById = episodeById;
    final l$$__typename = $__typename;
    return Object.hashAll([l$episodeById, l$$__typename]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Query$episodeById || runtimeType != other.runtimeType) {
      return false;
    }
    final l$episodeById = episodeById;
    final lOther$episodeById = other.episodeById;
    if (l$episodeById != lOther$episodeById) {
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

extension UtilityExtension$Query$episodeById on Query$episodeById {
  CopyWith$Query$episodeById<Query$episodeById> get copyWith =>
      CopyWith$Query$episodeById(this, (i) => i);
}

abstract class CopyWith$Query$episodeById<TRes> {
  factory CopyWith$Query$episodeById(
    Query$episodeById instance,
    TRes Function(Query$episodeById) then,
  ) = _CopyWithImpl$Query$episodeById;

  factory CopyWith$Query$episodeById.stub(TRes res) =
      _CopyWithStubImpl$Query$episodeById;

  TRes call({Fragment$fragmentEpisode? episodeById, String? $__typename});
  CopyWith$Fragment$fragmentEpisode<TRes> get episodeById;
}

class _CopyWithImpl$Query$episodeById<TRes>
    implements CopyWith$Query$episodeById<TRes> {
  _CopyWithImpl$Query$episodeById(this._instance, this._then);

  final Query$episodeById _instance;

  final TRes Function(Query$episodeById) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? episodeById = _undefined,
    Object? $__typename = _undefined,
  }) => _then(
    Query$episodeById(
      episodeById: episodeById == _undefined
          ? _instance.episodeById
          : (episodeById as Fragment$fragmentEpisode?),
      $__typename: $__typename == _undefined || $__typename == null
          ? _instance.$__typename
          : ($__typename as String),
    ),
  );

  CopyWith$Fragment$fragmentEpisode<TRes> get episodeById {
    final local$episodeById = _instance.episodeById;
    return local$episodeById == null
        ? CopyWith$Fragment$fragmentEpisode.stub(_then(_instance))
        : CopyWith$Fragment$fragmentEpisode(
            local$episodeById,
            (e) => call(episodeById: e),
          );
  }
}

class _CopyWithStubImpl$Query$episodeById<TRes>
    implements CopyWith$Query$episodeById<TRes> {
  _CopyWithStubImpl$Query$episodeById(this._res);

  TRes _res;

  call({Fragment$fragmentEpisode? episodeById, String? $__typename}) => _res;

  CopyWith$Fragment$fragmentEpisode<TRes> get episodeById =>
      CopyWith$Fragment$fragmentEpisode.stub(_res);
}

const documentNodeQueryepisodeById = DocumentNode(
  definitions: [
    OperationDefinitionNode(
      type: OperationType.query,
      name: NameNode(value: 'episodeById'),
      variableDefinitions: [
        VariableDefinitionNode(
          variable: VariableNode(name: NameNode(value: 'id')),
          type: NamedTypeNode(name: NameNode(value: 'ID'), isNonNull: true),
          defaultValue: DefaultValueNode(value: null),
          directives: [],
        ),
      ],
      directives: [],
      selectionSet: SelectionSetNode(
        selections: [
          FieldNode(
            name: NameNode(value: 'episodeById'),
            alias: null,
            arguments: [
              ArgumentNode(
                name: NameNode(value: 'id'),
                value: VariableNode(name: NameNode(value: 'id')),
              ),
            ],
            directives: [],
            selectionSet: SelectionSetNode(
              selections: [
                FragmentSpreadNode(
                  name: NameNode(value: 'fragmentEpisode'),
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
    fragmentDefinitionfragmentEpisode,
    fragmentDefinitionfragmentMetadata,
    fragmentDefinitionfragmentImages,
    fragmentDefinitionfragmentMediaFiles,
  ],
);

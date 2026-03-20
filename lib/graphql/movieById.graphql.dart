import 'fragmentImages.graphql.dart';
import 'fragmentMediafiles.graphql.dart';
import 'fragmentMetadata.graphql.dart';
import 'fragmentMovie.graphql.dart';
import 'package:gql/ast.dart';

class Variables$Query$movieById {
  factory Variables$Query$movieById({String? id}) =>
      Variables$Query$movieById._({if (id != null) r'id': id});

  Variables$Query$movieById._(this._$data);

  factory Variables$Query$movieById.fromJson(Map<String, dynamic> data) {
    final result$data = <String, dynamic>{};
    if (data.containsKey('id')) {
      final l$id = data['id'];
      result$data['id'] = (l$id as String?);
    }
    return Variables$Query$movieById._(result$data);
  }

  Map<String, dynamic> _$data;

  String? get id => (_$data['id'] as String?);

  Map<String, dynamic> toJson() {
    final result$data = <String, dynamic>{};
    if (_$data.containsKey('id')) {
      final l$id = id;
      result$data['id'] = l$id;
    }
    return result$data;
  }

  CopyWith$Variables$Query$movieById<Variables$Query$movieById> get copyWith =>
      CopyWith$Variables$Query$movieById(this, (i) => i);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Variables$Query$movieById ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$id = id;
    final lOther$id = other.id;
    if (_$data.containsKey('id') != other._$data.containsKey('id')) {
      return false;
    }
    if (l$id != lOther$id) {
      return false;
    }
    return true;
  }

  @override
  int get hashCode {
    final l$id = id;
    return Object.hashAll([_$data.containsKey('id') ? l$id : const {}]);
  }
}

abstract class CopyWith$Variables$Query$movieById<TRes> {
  factory CopyWith$Variables$Query$movieById(
    Variables$Query$movieById instance,
    TRes Function(Variables$Query$movieById) then,
  ) = _CopyWithImpl$Variables$Query$movieById;

  factory CopyWith$Variables$Query$movieById.stub(TRes res) =
      _CopyWithStubImpl$Variables$Query$movieById;

  TRes call({String? id});
}

class _CopyWithImpl$Variables$Query$movieById<TRes>
    implements CopyWith$Variables$Query$movieById<TRes> {
  _CopyWithImpl$Variables$Query$movieById(this._instance, this._then);

  final Variables$Query$movieById _instance;

  final TRes Function(Variables$Query$movieById) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({Object? id = _undefined}) => _then(
    Variables$Query$movieById._({
      ..._instance._$data,
      if (id != _undefined) 'id': (id as String?),
    }),
  );
}

class _CopyWithStubImpl$Variables$Query$movieById<TRes>
    implements CopyWith$Variables$Query$movieById<TRes> {
  _CopyWithStubImpl$Variables$Query$movieById(this._res);

  TRes _res;

  call({String? id}) => _res;
}

class Query$movieById {
  Query$movieById({this.movieById, this.$__typename = 'Query'});

  factory Query$movieById.fromJson(Map<String, dynamic> json) {
    final l$movieById = json['movieById'];
    final l$$__typename = json['__typename'];
    return Query$movieById(
      movieById: l$movieById == null
          ? null
          : Fragment$fragmentMovie.fromJson(
              (l$movieById as Map<String, dynamic>),
            ),
      $__typename: (l$$__typename as String),
    );
  }

  final Fragment$fragmentMovie? movieById;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$movieById = movieById;
    _resultData['movieById'] = l$movieById?.toJson();
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$movieById = movieById;
    final l$$__typename = $__typename;
    return Object.hashAll([l$movieById, l$$__typename]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Query$movieById || runtimeType != other.runtimeType) {
      return false;
    }
    final l$movieById = movieById;
    final lOther$movieById = other.movieById;
    if (l$movieById != lOther$movieById) {
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

extension UtilityExtension$Query$movieById on Query$movieById {
  CopyWith$Query$movieById<Query$movieById> get copyWith =>
      CopyWith$Query$movieById(this, (i) => i);
}

abstract class CopyWith$Query$movieById<TRes> {
  factory CopyWith$Query$movieById(
    Query$movieById instance,
    TRes Function(Query$movieById) then,
  ) = _CopyWithImpl$Query$movieById;

  factory CopyWith$Query$movieById.stub(TRes res) =
      _CopyWithStubImpl$Query$movieById;

  TRes call({Fragment$fragmentMovie? movieById, String? $__typename});
  CopyWith$Fragment$fragmentMovie<TRes> get movieById;
}

class _CopyWithImpl$Query$movieById<TRes>
    implements CopyWith$Query$movieById<TRes> {
  _CopyWithImpl$Query$movieById(this._instance, this._then);

  final Query$movieById _instance;

  final TRes Function(Query$movieById) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? movieById = _undefined,
    Object? $__typename = _undefined,
  }) => _then(
    Query$movieById(
      movieById: movieById == _undefined
          ? _instance.movieById
          : (movieById as Fragment$fragmentMovie?),
      $__typename: $__typename == _undefined || $__typename == null
          ? _instance.$__typename
          : ($__typename as String),
    ),
  );

  CopyWith$Fragment$fragmentMovie<TRes> get movieById {
    final local$movieById = _instance.movieById;
    return local$movieById == null
        ? CopyWith$Fragment$fragmentMovie.stub(_then(_instance))
        : CopyWith$Fragment$fragmentMovie(
            local$movieById,
            (e) => call(movieById: e),
          );
  }
}

class _CopyWithStubImpl$Query$movieById<TRes>
    implements CopyWith$Query$movieById<TRes> {
  _CopyWithStubImpl$Query$movieById(this._res);

  TRes _res;

  call({Fragment$fragmentMovie? movieById, String? $__typename}) => _res;

  CopyWith$Fragment$fragmentMovie<TRes> get movieById =>
      CopyWith$Fragment$fragmentMovie.stub(_res);
}

const documentNodeQuerymovieById = DocumentNode(
  definitions: [
    OperationDefinitionNode(
      type: OperationType.query,
      name: NameNode(value: 'movieById'),
      variableDefinitions: [
        VariableDefinitionNode(
          variable: VariableNode(name: NameNode(value: 'id')),
          type: NamedTypeNode(name: NameNode(value: 'ID'), isNonNull: false),
          defaultValue: DefaultValueNode(value: null),
          directives: [],
        ),
      ],
      directives: [],
      selectionSet: SelectionSetNode(
        selections: [
          FieldNode(
            name: NameNode(value: 'movieById'),
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
                  name: NameNode(value: 'fragmentMovie'),
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
    fragmentDefinitionfragmentMovie,
    fragmentDefinitionfragmentImages,
    fragmentDefinitionfragmentMetadata,
    fragmentDefinitionfragmentMediaFiles,
  ],
);

import 'fragmentImages.graphql.dart';
import 'fragmentMetadata.graphql.dart';
import 'fragmentPodcast.graphql.dart';
import 'package:gql/ast.dart';

class Variables$Query$podcastById {
  factory Variables$Query$podcastById({String? id}) =>
      Variables$Query$podcastById._({if (id != null) r'id': id});

  Variables$Query$podcastById._(this._$data);

  factory Variables$Query$podcastById.fromJson(Map<String, dynamic> data) {
    final result$data = <String, dynamic>{};
    if (data.containsKey('id')) {
      final l$id = data['id'];
      result$data['id'] = (l$id as String?);
    }
    return Variables$Query$podcastById._(result$data);
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

  CopyWith$Variables$Query$podcastById<Variables$Query$podcastById>
  get copyWith => CopyWith$Variables$Query$podcastById(this, (i) => i);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Variables$Query$podcastById ||
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

abstract class CopyWith$Variables$Query$podcastById<TRes> {
  factory CopyWith$Variables$Query$podcastById(
    Variables$Query$podcastById instance,
    TRes Function(Variables$Query$podcastById) then,
  ) = _CopyWithImpl$Variables$Query$podcastById;

  factory CopyWith$Variables$Query$podcastById.stub(TRes res) =
      _CopyWithStubImpl$Variables$Query$podcastById;

  TRes call({String? id});
}

class _CopyWithImpl$Variables$Query$podcastById<TRes>
    implements CopyWith$Variables$Query$podcastById<TRes> {
  _CopyWithImpl$Variables$Query$podcastById(this._instance, this._then);

  final Variables$Query$podcastById _instance;

  final TRes Function(Variables$Query$podcastById) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({Object? id = _undefined}) => _then(
    Variables$Query$podcastById._({
      ..._instance._$data,
      if (id != _undefined) 'id': (id as String?),
    }),
  );
}

class _CopyWithStubImpl$Variables$Query$podcastById<TRes>
    implements CopyWith$Variables$Query$podcastById<TRes> {
  _CopyWithStubImpl$Variables$Query$podcastById(this._res);

  TRes _res;

  call({String? id}) => _res;
}

class Query$podcastById {
  Query$podcastById({this.podcastById, this.$__typename = 'Query'});

  factory Query$podcastById.fromJson(Map<String, dynamic> json) {
    final l$podcastById = json['podcastById'];
    final l$$__typename = json['__typename'];
    return Query$podcastById(
      podcastById: l$podcastById == null
          ? null
          : Fragment$fragmentPodcast.fromJson(
              (l$podcastById as Map<String, dynamic>),
            ),
      $__typename: (l$$__typename as String),
    );
  }

  final Fragment$fragmentPodcast? podcastById;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$podcastById = podcastById;
    _resultData['podcastById'] = l$podcastById?.toJson();
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$podcastById = podcastById;
    final l$$__typename = $__typename;
    return Object.hashAll([l$podcastById, l$$__typename]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Query$podcastById || runtimeType != other.runtimeType) {
      return false;
    }
    final l$podcastById = podcastById;
    final lOther$podcastById = other.podcastById;
    if (l$podcastById != lOther$podcastById) {
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

extension UtilityExtension$Query$podcastById on Query$podcastById {
  CopyWith$Query$podcastById<Query$podcastById> get copyWith =>
      CopyWith$Query$podcastById(this, (i) => i);
}

abstract class CopyWith$Query$podcastById<TRes> {
  factory CopyWith$Query$podcastById(
    Query$podcastById instance,
    TRes Function(Query$podcastById) then,
  ) = _CopyWithImpl$Query$podcastById;

  factory CopyWith$Query$podcastById.stub(TRes res) =
      _CopyWithStubImpl$Query$podcastById;

  TRes call({Fragment$fragmentPodcast? podcastById, String? $__typename});
  CopyWith$Fragment$fragmentPodcast<TRes> get podcastById;
}

class _CopyWithImpl$Query$podcastById<TRes>
    implements CopyWith$Query$podcastById<TRes> {
  _CopyWithImpl$Query$podcastById(this._instance, this._then);

  final Query$podcastById _instance;

  final TRes Function(Query$podcastById) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? podcastById = _undefined,
    Object? $__typename = _undefined,
  }) => _then(
    Query$podcastById(
      podcastById: podcastById == _undefined
          ? _instance.podcastById
          : (podcastById as Fragment$fragmentPodcast?),
      $__typename: $__typename == _undefined || $__typename == null
          ? _instance.$__typename
          : ($__typename as String),
    ),
  );

  CopyWith$Fragment$fragmentPodcast<TRes> get podcastById {
    final local$podcastById = _instance.podcastById;
    return local$podcastById == null
        ? CopyWith$Fragment$fragmentPodcast.stub(_then(_instance))
        : CopyWith$Fragment$fragmentPodcast(
            local$podcastById,
            (e) => call(podcastById: e),
          );
  }
}

class _CopyWithStubImpl$Query$podcastById<TRes>
    implements CopyWith$Query$podcastById<TRes> {
  _CopyWithStubImpl$Query$podcastById(this._res);

  TRes _res;

  call({Fragment$fragmentPodcast? podcastById, String? $__typename}) => _res;

  CopyWith$Fragment$fragmentPodcast<TRes> get podcastById =>
      CopyWith$Fragment$fragmentPodcast.stub(_res);
}

const documentNodeQuerypodcastById = DocumentNode(
  definitions: [
    OperationDefinitionNode(
      type: OperationType.query,
      name: NameNode(value: 'podcastById'),
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
            name: NameNode(value: 'podcastById'),
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
                  name: NameNode(value: 'fragmentPodcast'),
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
    fragmentDefinitionfragmentPodcast,
    fragmentDefinitionfragmentImages,
    fragmentDefinitionfragmentMetadata,
  ],
);

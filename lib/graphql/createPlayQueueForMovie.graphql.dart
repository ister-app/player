import 'fragmentEpisode.graphql.dart';
import 'fragmentImages.graphql.dart';
import 'fragmentMediafiles.graphql.dart';
import 'fragmentMetadata.graphql.dart';
import 'fragmentMovie.graphql.dart';
import 'fragmentPlayQueue.graphql.dart';
import 'package:gql/ast.dart';

class Variables$Mutation$createPlayQueueForMovie {
  factory Variables$Mutation$createPlayQueueForMovie({
    required String movieId,
  }) => Variables$Mutation$createPlayQueueForMovie._({r'movieId': movieId});

  Variables$Mutation$createPlayQueueForMovie._(this._$data);

  factory Variables$Mutation$createPlayQueueForMovie.fromJson(
    Map<String, dynamic> data,
  ) {
    final result$data = <String, dynamic>{};
    final l$movieId = data['movieId'];
    result$data['movieId'] = (l$movieId as String);
    return Variables$Mutation$createPlayQueueForMovie._(result$data);
  }

  Map<String, dynamic> _$data;

  String get movieId => (_$data['movieId'] as String);

  Map<String, dynamic> toJson() {
    final result$data = <String, dynamic>{};
    final l$movieId = movieId;
    result$data['movieId'] = l$movieId;
    return result$data;
  }

  CopyWith$Variables$Mutation$createPlayQueueForMovie<
    Variables$Mutation$createPlayQueueForMovie
  >
  get copyWith =>
      CopyWith$Variables$Mutation$createPlayQueueForMovie(this, (i) => i);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Variables$Mutation$createPlayQueueForMovie ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$movieId = movieId;
    final lOther$movieId = other.movieId;
    if (l$movieId != lOther$movieId) {
      return false;
    }
    return true;
  }

  @override
  int get hashCode {
    final l$movieId = movieId;
    return Object.hashAll([l$movieId]);
  }
}

abstract class CopyWith$Variables$Mutation$createPlayQueueForMovie<TRes> {
  factory CopyWith$Variables$Mutation$createPlayQueueForMovie(
    Variables$Mutation$createPlayQueueForMovie instance,
    TRes Function(Variables$Mutation$createPlayQueueForMovie) then,
  ) = _CopyWithImpl$Variables$Mutation$createPlayQueueForMovie;

  factory CopyWith$Variables$Mutation$createPlayQueueForMovie.stub(TRes res) =
      _CopyWithStubImpl$Variables$Mutation$createPlayQueueForMovie;

  TRes call({String? movieId});
}

class _CopyWithImpl$Variables$Mutation$createPlayQueueForMovie<TRes>
    implements CopyWith$Variables$Mutation$createPlayQueueForMovie<TRes> {
  _CopyWithImpl$Variables$Mutation$createPlayQueueForMovie(
    this._instance,
    this._then,
  );

  final Variables$Mutation$createPlayQueueForMovie _instance;

  final TRes Function(Variables$Mutation$createPlayQueueForMovie) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({Object? movieId = _undefined}) => _then(
    Variables$Mutation$createPlayQueueForMovie._({
      ..._instance._$data,
      if (movieId != _undefined && movieId != null)
        'movieId': (movieId as String),
    }),
  );
}

class _CopyWithStubImpl$Variables$Mutation$createPlayQueueForMovie<TRes>
    implements CopyWith$Variables$Mutation$createPlayQueueForMovie<TRes> {
  _CopyWithStubImpl$Variables$Mutation$createPlayQueueForMovie(this._res);

  TRes _res;

  call({String? movieId}) => _res;
}

class Mutation$createPlayQueueForMovie {
  Mutation$createPlayQueueForMovie({
    required this.createPlayQueueForMovie,
    this.$__typename = 'Mutation',
  });

  factory Mutation$createPlayQueueForMovie.fromJson(Map<String, dynamic> json) {
    final l$createPlayQueueForMovie = json['createPlayQueueForMovie'];
    final l$$__typename = json['__typename'];
    return Mutation$createPlayQueueForMovie(
      createPlayQueueForMovie: Fragment$fragmentPlayQueue.fromJson(
        (l$createPlayQueueForMovie as Map<String, dynamic>),
      ),
      $__typename: (l$$__typename as String),
    );
  }

  final Fragment$fragmentPlayQueue createPlayQueueForMovie;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$createPlayQueueForMovie = createPlayQueueForMovie;
    _resultData['createPlayQueueForMovie'] = l$createPlayQueueForMovie.toJson();
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$createPlayQueueForMovie = createPlayQueueForMovie;
    final l$$__typename = $__typename;
    return Object.hashAll([l$createPlayQueueForMovie, l$$__typename]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Mutation$createPlayQueueForMovie ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$createPlayQueueForMovie = createPlayQueueForMovie;
    final lOther$createPlayQueueForMovie = other.createPlayQueueForMovie;
    if (l$createPlayQueueForMovie != lOther$createPlayQueueForMovie) {
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

extension UtilityExtension$Mutation$createPlayQueueForMovie
    on Mutation$createPlayQueueForMovie {
  CopyWith$Mutation$createPlayQueueForMovie<Mutation$createPlayQueueForMovie>
  get copyWith => CopyWith$Mutation$createPlayQueueForMovie(this, (i) => i);
}

abstract class CopyWith$Mutation$createPlayQueueForMovie<TRes> {
  factory CopyWith$Mutation$createPlayQueueForMovie(
    Mutation$createPlayQueueForMovie instance,
    TRes Function(Mutation$createPlayQueueForMovie) then,
  ) = _CopyWithImpl$Mutation$createPlayQueueForMovie;

  factory CopyWith$Mutation$createPlayQueueForMovie.stub(TRes res) =
      _CopyWithStubImpl$Mutation$createPlayQueueForMovie;

  TRes call({
    Fragment$fragmentPlayQueue? createPlayQueueForMovie,
    String? $__typename,
  });
  CopyWith$Fragment$fragmentPlayQueue<TRes> get createPlayQueueForMovie;
}

class _CopyWithImpl$Mutation$createPlayQueueForMovie<TRes>
    implements CopyWith$Mutation$createPlayQueueForMovie<TRes> {
  _CopyWithImpl$Mutation$createPlayQueueForMovie(this._instance, this._then);

  final Mutation$createPlayQueueForMovie _instance;

  final TRes Function(Mutation$createPlayQueueForMovie) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? createPlayQueueForMovie = _undefined,
    Object? $__typename = _undefined,
  }) => _then(
    Mutation$createPlayQueueForMovie(
      createPlayQueueForMovie:
          createPlayQueueForMovie == _undefined ||
              createPlayQueueForMovie == null
          ? _instance.createPlayQueueForMovie
          : (createPlayQueueForMovie as Fragment$fragmentPlayQueue),
      $__typename: $__typename == _undefined || $__typename == null
          ? _instance.$__typename
          : ($__typename as String),
    ),
  );

  CopyWith$Fragment$fragmentPlayQueue<TRes> get createPlayQueueForMovie {
    final local$createPlayQueueForMovie = _instance.createPlayQueueForMovie;
    return CopyWith$Fragment$fragmentPlayQueue(
      local$createPlayQueueForMovie,
      (e) => call(createPlayQueueForMovie: e),
    );
  }
}

class _CopyWithStubImpl$Mutation$createPlayQueueForMovie<TRes>
    implements CopyWith$Mutation$createPlayQueueForMovie<TRes> {
  _CopyWithStubImpl$Mutation$createPlayQueueForMovie(this._res);

  TRes _res;

  call({
    Fragment$fragmentPlayQueue? createPlayQueueForMovie,
    String? $__typename,
  }) => _res;

  CopyWith$Fragment$fragmentPlayQueue<TRes> get createPlayQueueForMovie =>
      CopyWith$Fragment$fragmentPlayQueue.stub(_res);
}

const documentNodeMutationcreatePlayQueueForMovie = DocumentNode(
  definitions: [
    OperationDefinitionNode(
      type: OperationType.mutation,
      name: NameNode(value: 'createPlayQueueForMovie'),
      variableDefinitions: [
        VariableDefinitionNode(
          variable: VariableNode(name: NameNode(value: 'movieId')),
          type: NamedTypeNode(name: NameNode(value: 'ID'), isNonNull: true),
          defaultValue: DefaultValueNode(value: null),
          directives: [],
        ),
      ],
      directives: [],
      selectionSet: SelectionSetNode(
        selections: [
          FieldNode(
            name: NameNode(value: 'createPlayQueueForMovie'),
            alias: null,
            arguments: [
              ArgumentNode(
                name: NameNode(value: 'movieId'),
                value: VariableNode(name: NameNode(value: 'movieId')),
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
    fragmentDefinitionfragmentMovie,
  ],
);

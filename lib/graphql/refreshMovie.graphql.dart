import 'package:gql/ast.dart';

class Variables$Mutation$refreshMovie {
  factory Variables$Mutation$refreshMovie({required String movieId}) =>
      Variables$Mutation$refreshMovie._({r'movieId': movieId});

  Variables$Mutation$refreshMovie._(this._$data);

  factory Variables$Mutation$refreshMovie.fromJson(Map<String, dynamic> data) {
    final result$data = <String, dynamic>{};
    final l$movieId = data['movieId'];
    result$data['movieId'] = (l$movieId as String);
    return Variables$Mutation$refreshMovie._(result$data);
  }

  Map<String, dynamic> _$data;

  String get movieId => (_$data['movieId'] as String);

  Map<String, dynamic> toJson() {
    final result$data = <String, dynamic>{};
    final l$movieId = movieId;
    result$data['movieId'] = l$movieId;
    return result$data;
  }

  CopyWith$Variables$Mutation$refreshMovie<Variables$Mutation$refreshMovie>
  get copyWith => CopyWith$Variables$Mutation$refreshMovie(this, (i) => i);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Variables$Mutation$refreshMovie ||
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

abstract class CopyWith$Variables$Mutation$refreshMovie<TRes> {
  factory CopyWith$Variables$Mutation$refreshMovie(
    Variables$Mutation$refreshMovie instance,
    TRes Function(Variables$Mutation$refreshMovie) then,
  ) = _CopyWithImpl$Variables$Mutation$refreshMovie;

  factory CopyWith$Variables$Mutation$refreshMovie.stub(TRes res) =
      _CopyWithStubImpl$Variables$Mutation$refreshMovie;

  TRes call({String? movieId});
}

class _CopyWithImpl$Variables$Mutation$refreshMovie<TRes>
    implements CopyWith$Variables$Mutation$refreshMovie<TRes> {
  _CopyWithImpl$Variables$Mutation$refreshMovie(this._instance, this._then);

  final Variables$Mutation$refreshMovie _instance;

  final TRes Function(Variables$Mutation$refreshMovie) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({Object? movieId = _undefined}) => _then(
    Variables$Mutation$refreshMovie._({
      ..._instance._$data,
      if (movieId != _undefined && movieId != null)
        'movieId': (movieId as String),
    }),
  );
}

class _CopyWithStubImpl$Variables$Mutation$refreshMovie<TRes>
    implements CopyWith$Variables$Mutation$refreshMovie<TRes> {
  _CopyWithStubImpl$Variables$Mutation$refreshMovie(this._res);

  TRes _res;

  call({String? movieId}) => _res;
}

class Mutation$refreshMovie {
  Mutation$refreshMovie({
    required this.refreshMovie,
    this.$__typename = 'Mutation',
  });

  factory Mutation$refreshMovie.fromJson(Map<String, dynamic> json) {
    final l$refreshMovie = json['refreshMovie'];
    final l$$__typename = json['__typename'];
    return Mutation$refreshMovie(
      refreshMovie: (l$refreshMovie as bool),
      $__typename: (l$$__typename as String),
    );
  }

  final bool refreshMovie;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$refreshMovie = refreshMovie;
    _resultData['refreshMovie'] = l$refreshMovie;
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$refreshMovie = refreshMovie;
    final l$$__typename = $__typename;
    return Object.hashAll([l$refreshMovie, l$$__typename]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Mutation$refreshMovie || runtimeType != other.runtimeType) {
      return false;
    }
    final l$refreshMovie = refreshMovie;
    final lOther$refreshMovie = other.refreshMovie;
    if (l$refreshMovie != lOther$refreshMovie) {
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

extension UtilityExtension$Mutation$refreshMovie on Mutation$refreshMovie {
  CopyWith$Mutation$refreshMovie<Mutation$refreshMovie> get copyWith =>
      CopyWith$Mutation$refreshMovie(this, (i) => i);
}

abstract class CopyWith$Mutation$refreshMovie<TRes> {
  factory CopyWith$Mutation$refreshMovie(
    Mutation$refreshMovie instance,
    TRes Function(Mutation$refreshMovie) then,
  ) = _CopyWithImpl$Mutation$refreshMovie;

  factory CopyWith$Mutation$refreshMovie.stub(TRes res) =
      _CopyWithStubImpl$Mutation$refreshMovie;

  TRes call({bool? refreshMovie, String? $__typename});
}

class _CopyWithImpl$Mutation$refreshMovie<TRes>
    implements CopyWith$Mutation$refreshMovie<TRes> {
  _CopyWithImpl$Mutation$refreshMovie(this._instance, this._then);

  final Mutation$refreshMovie _instance;

  final TRes Function(Mutation$refreshMovie) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? refreshMovie = _undefined,
    Object? $__typename = _undefined,
  }) => _then(
    Mutation$refreshMovie(
      refreshMovie: refreshMovie == _undefined || refreshMovie == null
          ? _instance.refreshMovie
          : (refreshMovie as bool),
      $__typename: $__typename == _undefined || $__typename == null
          ? _instance.$__typename
          : ($__typename as String),
    ),
  );
}

class _CopyWithStubImpl$Mutation$refreshMovie<TRes>
    implements CopyWith$Mutation$refreshMovie<TRes> {
  _CopyWithStubImpl$Mutation$refreshMovie(this._res);

  TRes _res;

  call({bool? refreshMovie, String? $__typename}) => _res;
}

const documentNodeMutationrefreshMovie = DocumentNode(
  definitions: [
    OperationDefinitionNode(
      type: OperationType.mutation,
      name: NameNode(value: 'refreshMovie'),
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
            name: NameNode(value: 'refreshMovie'),
            alias: null,
            arguments: [
              ArgumentNode(
                name: NameNode(value: 'movieId'),
                value: VariableNode(name: NameNode(value: 'movieId')),
              ),
            ],
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
    ),
  ],
);

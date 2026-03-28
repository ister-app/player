import 'package:gql/ast.dart';

class Variables$Mutation$analyzeDataForMovieMutation {
  factory Variables$Mutation$analyzeDataForMovieMutation({
    required String movieId,
  }) => Variables$Mutation$analyzeDataForMovieMutation._({r'movieId': movieId});

  Variables$Mutation$analyzeDataForMovieMutation._(this._$data);

  factory Variables$Mutation$analyzeDataForMovieMutation.fromJson(
    Map<String, dynamic> data,
  ) {
    final result$data = <String, dynamic>{};
    final l$movieId = data['movieId'];
    result$data['movieId'] = (l$movieId as String);
    return Variables$Mutation$analyzeDataForMovieMutation._(result$data);
  }

  Map<String, dynamic> _$data;

  String get movieId => (_$data['movieId'] as String);

  Map<String, dynamic> toJson() {
    final result$data = <String, dynamic>{};
    final l$movieId = movieId;
    result$data['movieId'] = l$movieId;
    return result$data;
  }

  CopyWith$Variables$Mutation$analyzeDataForMovieMutation<
    Variables$Mutation$analyzeDataForMovieMutation
  >
  get copyWith =>
      CopyWith$Variables$Mutation$analyzeDataForMovieMutation(this, (i) => i);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Variables$Mutation$analyzeDataForMovieMutation ||
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

abstract class CopyWith$Variables$Mutation$analyzeDataForMovieMutation<TRes> {
  factory CopyWith$Variables$Mutation$analyzeDataForMovieMutation(
    Variables$Mutation$analyzeDataForMovieMutation instance,
    TRes Function(Variables$Mutation$analyzeDataForMovieMutation) then,
  ) = _CopyWithImpl$Variables$Mutation$analyzeDataForMovieMutation;

  factory CopyWith$Variables$Mutation$analyzeDataForMovieMutation.stub(
    TRes res,
  ) = _CopyWithStubImpl$Variables$Mutation$analyzeDataForMovieMutation;

  TRes call({String? movieId});
}

class _CopyWithImpl$Variables$Mutation$analyzeDataForMovieMutation<TRes>
    implements CopyWith$Variables$Mutation$analyzeDataForMovieMutation<TRes> {
  _CopyWithImpl$Variables$Mutation$analyzeDataForMovieMutation(
    this._instance,
    this._then,
  );

  final Variables$Mutation$analyzeDataForMovieMutation _instance;

  final TRes Function(Variables$Mutation$analyzeDataForMovieMutation) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({Object? movieId = _undefined}) => _then(
    Variables$Mutation$analyzeDataForMovieMutation._({
      ..._instance._$data,
      if (movieId != _undefined && movieId != null)
        'movieId': (movieId as String),
    }),
  );
}

class _CopyWithStubImpl$Variables$Mutation$analyzeDataForMovieMutation<TRes>
    implements CopyWith$Variables$Mutation$analyzeDataForMovieMutation<TRes> {
  _CopyWithStubImpl$Variables$Mutation$analyzeDataForMovieMutation(this._res);

  TRes _res;

  call({String? movieId}) => _res;
}

class Mutation$analyzeDataForMovieMutation {
  Mutation$analyzeDataForMovieMutation({
    required this.analyzeDataForMovie,
    this.$__typename = 'Mutation',
  });

  factory Mutation$analyzeDataForMovieMutation.fromJson(
    Map<String, dynamic> json,
  ) {
    final l$analyzeDataForMovie = json['analyzeDataForMovie'];
    final l$$__typename = json['__typename'];
    return Mutation$analyzeDataForMovieMutation(
      analyzeDataForMovie: (l$analyzeDataForMovie as bool),
      $__typename: (l$$__typename as String),
    );
  }

  final bool analyzeDataForMovie;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$analyzeDataForMovie = analyzeDataForMovie;
    _resultData['analyzeDataForMovie'] = l$analyzeDataForMovie;
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$analyzeDataForMovie = analyzeDataForMovie;
    final l$$__typename = $__typename;
    return Object.hashAll([l$analyzeDataForMovie, l$$__typename]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Mutation$analyzeDataForMovieMutation ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$analyzeDataForMovie = analyzeDataForMovie;
    final lOther$analyzeDataForMovie = other.analyzeDataForMovie;
    if (l$analyzeDataForMovie != lOther$analyzeDataForMovie) {
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

extension UtilityExtension$Mutation$analyzeDataForMovieMutation
    on Mutation$analyzeDataForMovieMutation {
  CopyWith$Mutation$analyzeDataForMovieMutation<
    Mutation$analyzeDataForMovieMutation
  >
  get copyWith => CopyWith$Mutation$analyzeDataForMovieMutation(this, (i) => i);
}

abstract class CopyWith$Mutation$analyzeDataForMovieMutation<TRes> {
  factory CopyWith$Mutation$analyzeDataForMovieMutation(
    Mutation$analyzeDataForMovieMutation instance,
    TRes Function(Mutation$analyzeDataForMovieMutation) then,
  ) = _CopyWithImpl$Mutation$analyzeDataForMovieMutation;

  factory CopyWith$Mutation$analyzeDataForMovieMutation.stub(TRes res) =
      _CopyWithStubImpl$Mutation$analyzeDataForMovieMutation;

  TRes call({bool? analyzeDataForMovie, String? $__typename});
}

class _CopyWithImpl$Mutation$analyzeDataForMovieMutation<TRes>
    implements CopyWith$Mutation$analyzeDataForMovieMutation<TRes> {
  _CopyWithImpl$Mutation$analyzeDataForMovieMutation(
    this._instance,
    this._then,
  );

  final Mutation$analyzeDataForMovieMutation _instance;

  final TRes Function(Mutation$analyzeDataForMovieMutation) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? analyzeDataForMovie = _undefined,
    Object? $__typename = _undefined,
  }) => _then(
    Mutation$analyzeDataForMovieMutation(
      analyzeDataForMovie:
          analyzeDataForMovie == _undefined || analyzeDataForMovie == null
          ? _instance.analyzeDataForMovie
          : (analyzeDataForMovie as bool),
      $__typename: $__typename == _undefined || $__typename == null
          ? _instance.$__typename
          : ($__typename as String),
    ),
  );
}

class _CopyWithStubImpl$Mutation$analyzeDataForMovieMutation<TRes>
    implements CopyWith$Mutation$analyzeDataForMovieMutation<TRes> {
  _CopyWithStubImpl$Mutation$analyzeDataForMovieMutation(this._res);

  TRes _res;

  call({bool? analyzeDataForMovie, String? $__typename}) => _res;
}

const documentNodeMutationanalyzeDataForMovieMutation = DocumentNode(
  definitions: [
    OperationDefinitionNode(
      type: OperationType.mutation,
      name: NameNode(value: 'analyzeDataForMovieMutation'),
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
            name: NameNode(value: 'analyzeDataForMovie'),
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

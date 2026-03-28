import 'package:gql/ast.dart';

class Variables$Mutation$analyzeDataForEpisodeMutation {
  factory Variables$Mutation$analyzeDataForEpisodeMutation({
    required String episodeId,
  }) => Variables$Mutation$analyzeDataForEpisodeMutation._({
    r'episodeId': episodeId,
  });

  Variables$Mutation$analyzeDataForEpisodeMutation._(this._$data);

  factory Variables$Mutation$analyzeDataForEpisodeMutation.fromJson(
    Map<String, dynamic> data,
  ) {
    final result$data = <String, dynamic>{};
    final l$episodeId = data['episodeId'];
    result$data['episodeId'] = (l$episodeId as String);
    return Variables$Mutation$analyzeDataForEpisodeMutation._(result$data);
  }

  Map<String, dynamic> _$data;

  String get episodeId => (_$data['episodeId'] as String);

  Map<String, dynamic> toJson() {
    final result$data = <String, dynamic>{};
    final l$episodeId = episodeId;
    result$data['episodeId'] = l$episodeId;
    return result$data;
  }

  CopyWith$Variables$Mutation$analyzeDataForEpisodeMutation<
    Variables$Mutation$analyzeDataForEpisodeMutation
  >
  get copyWith =>
      CopyWith$Variables$Mutation$analyzeDataForEpisodeMutation(this, (i) => i);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Variables$Mutation$analyzeDataForEpisodeMutation ||
        runtimeType != other.runtimeType) {
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
    final l$episodeId = episodeId;
    return Object.hashAll([l$episodeId]);
  }
}

abstract class CopyWith$Variables$Mutation$analyzeDataForEpisodeMutation<TRes> {
  factory CopyWith$Variables$Mutation$analyzeDataForEpisodeMutation(
    Variables$Mutation$analyzeDataForEpisodeMutation instance,
    TRes Function(Variables$Mutation$analyzeDataForEpisodeMutation) then,
  ) = _CopyWithImpl$Variables$Mutation$analyzeDataForEpisodeMutation;

  factory CopyWith$Variables$Mutation$analyzeDataForEpisodeMutation.stub(
    TRes res,
  ) = _CopyWithStubImpl$Variables$Mutation$analyzeDataForEpisodeMutation;

  TRes call({String? episodeId});
}

class _CopyWithImpl$Variables$Mutation$analyzeDataForEpisodeMutation<TRes>
    implements CopyWith$Variables$Mutation$analyzeDataForEpisodeMutation<TRes> {
  _CopyWithImpl$Variables$Mutation$analyzeDataForEpisodeMutation(
    this._instance,
    this._then,
  );

  final Variables$Mutation$analyzeDataForEpisodeMutation _instance;

  final TRes Function(Variables$Mutation$analyzeDataForEpisodeMutation) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({Object? episodeId = _undefined}) => _then(
    Variables$Mutation$analyzeDataForEpisodeMutation._({
      ..._instance._$data,
      if (episodeId != _undefined && episodeId != null)
        'episodeId': (episodeId as String),
    }),
  );
}

class _CopyWithStubImpl$Variables$Mutation$analyzeDataForEpisodeMutation<TRes>
    implements CopyWith$Variables$Mutation$analyzeDataForEpisodeMutation<TRes> {
  _CopyWithStubImpl$Variables$Mutation$analyzeDataForEpisodeMutation(this._res);

  TRes _res;

  call({String? episodeId}) => _res;
}

class Mutation$analyzeDataForEpisodeMutation {
  Mutation$analyzeDataForEpisodeMutation({
    required this.analyzeDataForEpisode,
    this.$__typename = 'Mutation',
  });

  factory Mutation$analyzeDataForEpisodeMutation.fromJson(
    Map<String, dynamic> json,
  ) {
    final l$analyzeDataForEpisode = json['analyzeDataForEpisode'];
    final l$$__typename = json['__typename'];
    return Mutation$analyzeDataForEpisodeMutation(
      analyzeDataForEpisode: (l$analyzeDataForEpisode as bool),
      $__typename: (l$$__typename as String),
    );
  }

  final bool analyzeDataForEpisode;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$analyzeDataForEpisode = analyzeDataForEpisode;
    _resultData['analyzeDataForEpisode'] = l$analyzeDataForEpisode;
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$analyzeDataForEpisode = analyzeDataForEpisode;
    final l$$__typename = $__typename;
    return Object.hashAll([l$analyzeDataForEpisode, l$$__typename]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Mutation$analyzeDataForEpisodeMutation ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$analyzeDataForEpisode = analyzeDataForEpisode;
    final lOther$analyzeDataForEpisode = other.analyzeDataForEpisode;
    if (l$analyzeDataForEpisode != lOther$analyzeDataForEpisode) {
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

extension UtilityExtension$Mutation$analyzeDataForEpisodeMutation
    on Mutation$analyzeDataForEpisodeMutation {
  CopyWith$Mutation$analyzeDataForEpisodeMutation<
    Mutation$analyzeDataForEpisodeMutation
  >
  get copyWith =>
      CopyWith$Mutation$analyzeDataForEpisodeMutation(this, (i) => i);
}

abstract class CopyWith$Mutation$analyzeDataForEpisodeMutation<TRes> {
  factory CopyWith$Mutation$analyzeDataForEpisodeMutation(
    Mutation$analyzeDataForEpisodeMutation instance,
    TRes Function(Mutation$analyzeDataForEpisodeMutation) then,
  ) = _CopyWithImpl$Mutation$analyzeDataForEpisodeMutation;

  factory CopyWith$Mutation$analyzeDataForEpisodeMutation.stub(TRes res) =
      _CopyWithStubImpl$Mutation$analyzeDataForEpisodeMutation;

  TRes call({bool? analyzeDataForEpisode, String? $__typename});
}

class _CopyWithImpl$Mutation$analyzeDataForEpisodeMutation<TRes>
    implements CopyWith$Mutation$analyzeDataForEpisodeMutation<TRes> {
  _CopyWithImpl$Mutation$analyzeDataForEpisodeMutation(
    this._instance,
    this._then,
  );

  final Mutation$analyzeDataForEpisodeMutation _instance;

  final TRes Function(Mutation$analyzeDataForEpisodeMutation) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? analyzeDataForEpisode = _undefined,
    Object? $__typename = _undefined,
  }) => _then(
    Mutation$analyzeDataForEpisodeMutation(
      analyzeDataForEpisode:
          analyzeDataForEpisode == _undefined || analyzeDataForEpisode == null
          ? _instance.analyzeDataForEpisode
          : (analyzeDataForEpisode as bool),
      $__typename: $__typename == _undefined || $__typename == null
          ? _instance.$__typename
          : ($__typename as String),
    ),
  );
}

class _CopyWithStubImpl$Mutation$analyzeDataForEpisodeMutation<TRes>
    implements CopyWith$Mutation$analyzeDataForEpisodeMutation<TRes> {
  _CopyWithStubImpl$Mutation$analyzeDataForEpisodeMutation(this._res);

  TRes _res;

  call({bool? analyzeDataForEpisode, String? $__typename}) => _res;
}

const documentNodeMutationanalyzeDataForEpisodeMutation = DocumentNode(
  definitions: [
    OperationDefinitionNode(
      type: OperationType.mutation,
      name: NameNode(value: 'analyzeDataForEpisodeMutation'),
      variableDefinitions: [
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
            name: NameNode(value: 'analyzeDataForEpisode'),
            alias: null,
            arguments: [
              ArgumentNode(
                name: NameNode(value: 'episodeId'),
                value: VariableNode(name: NameNode(value: 'episodeId')),
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

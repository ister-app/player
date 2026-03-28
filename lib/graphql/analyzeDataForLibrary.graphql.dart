import 'package:gql/ast.dart';

class Variables$Mutation$analyzeDataForLibraryMutation {
  factory Variables$Mutation$analyzeDataForLibraryMutation({
    required String libraryId,
  }) => Variables$Mutation$analyzeDataForLibraryMutation._({
    r'libraryId': libraryId,
  });

  Variables$Mutation$analyzeDataForLibraryMutation._(this._$data);

  factory Variables$Mutation$analyzeDataForLibraryMutation.fromJson(
    Map<String, dynamic> data,
  ) {
    final result$data = <String, dynamic>{};
    final l$libraryId = data['libraryId'];
    result$data['libraryId'] = (l$libraryId as String);
    return Variables$Mutation$analyzeDataForLibraryMutation._(result$data);
  }

  Map<String, dynamic> _$data;

  String get libraryId => (_$data['libraryId'] as String);

  Map<String, dynamic> toJson() {
    final result$data = <String, dynamic>{};
    final l$libraryId = libraryId;
    result$data['libraryId'] = l$libraryId;
    return result$data;
  }

  CopyWith$Variables$Mutation$analyzeDataForLibraryMutation<
    Variables$Mutation$analyzeDataForLibraryMutation
  >
  get copyWith =>
      CopyWith$Variables$Mutation$analyzeDataForLibraryMutation(this, (i) => i);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Variables$Mutation$analyzeDataForLibraryMutation ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$libraryId = libraryId;
    final lOther$libraryId = other.libraryId;
    if (l$libraryId != lOther$libraryId) {
      return false;
    }
    return true;
  }

  @override
  int get hashCode {
    final l$libraryId = libraryId;
    return Object.hashAll([l$libraryId]);
  }
}

abstract class CopyWith$Variables$Mutation$analyzeDataForLibraryMutation<TRes> {
  factory CopyWith$Variables$Mutation$analyzeDataForLibraryMutation(
    Variables$Mutation$analyzeDataForLibraryMutation instance,
    TRes Function(Variables$Mutation$analyzeDataForLibraryMutation) then,
  ) = _CopyWithImpl$Variables$Mutation$analyzeDataForLibraryMutation;

  factory CopyWith$Variables$Mutation$analyzeDataForLibraryMutation.stub(
    TRes res,
  ) = _CopyWithStubImpl$Variables$Mutation$analyzeDataForLibraryMutation;

  TRes call({String? libraryId});
}

class _CopyWithImpl$Variables$Mutation$analyzeDataForLibraryMutation<TRes>
    implements CopyWith$Variables$Mutation$analyzeDataForLibraryMutation<TRes> {
  _CopyWithImpl$Variables$Mutation$analyzeDataForLibraryMutation(
    this._instance,
    this._then,
  );

  final Variables$Mutation$analyzeDataForLibraryMutation _instance;

  final TRes Function(Variables$Mutation$analyzeDataForLibraryMutation) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({Object? libraryId = _undefined}) => _then(
    Variables$Mutation$analyzeDataForLibraryMutation._({
      ..._instance._$data,
      if (libraryId != _undefined && libraryId != null)
        'libraryId': (libraryId as String),
    }),
  );
}

class _CopyWithStubImpl$Variables$Mutation$analyzeDataForLibraryMutation<TRes>
    implements CopyWith$Variables$Mutation$analyzeDataForLibraryMutation<TRes> {
  _CopyWithStubImpl$Variables$Mutation$analyzeDataForLibraryMutation(this._res);

  TRes _res;

  call({String? libraryId}) => _res;
}

class Mutation$analyzeDataForLibraryMutation {
  Mutation$analyzeDataForLibraryMutation({
    required this.analyzeDataForLibrary,
    this.$__typename = 'Mutation',
  });

  factory Mutation$analyzeDataForLibraryMutation.fromJson(
    Map<String, dynamic> json,
  ) {
    final l$analyzeDataForLibrary = json['analyzeDataForLibrary'];
    final l$$__typename = json['__typename'];
    return Mutation$analyzeDataForLibraryMutation(
      analyzeDataForLibrary: (l$analyzeDataForLibrary as bool),
      $__typename: (l$$__typename as String),
    );
  }

  final bool analyzeDataForLibrary;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$analyzeDataForLibrary = analyzeDataForLibrary;
    _resultData['analyzeDataForLibrary'] = l$analyzeDataForLibrary;
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$analyzeDataForLibrary = analyzeDataForLibrary;
    final l$$__typename = $__typename;
    return Object.hashAll([l$analyzeDataForLibrary, l$$__typename]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Mutation$analyzeDataForLibraryMutation ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$analyzeDataForLibrary = analyzeDataForLibrary;
    final lOther$analyzeDataForLibrary = other.analyzeDataForLibrary;
    if (l$analyzeDataForLibrary != lOther$analyzeDataForLibrary) {
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

extension UtilityExtension$Mutation$analyzeDataForLibraryMutation
    on Mutation$analyzeDataForLibraryMutation {
  CopyWith$Mutation$analyzeDataForLibraryMutation<
    Mutation$analyzeDataForLibraryMutation
  >
  get copyWith =>
      CopyWith$Mutation$analyzeDataForLibraryMutation(this, (i) => i);
}

abstract class CopyWith$Mutation$analyzeDataForLibraryMutation<TRes> {
  factory CopyWith$Mutation$analyzeDataForLibraryMutation(
    Mutation$analyzeDataForLibraryMutation instance,
    TRes Function(Mutation$analyzeDataForLibraryMutation) then,
  ) = _CopyWithImpl$Mutation$analyzeDataForLibraryMutation;

  factory CopyWith$Mutation$analyzeDataForLibraryMutation.stub(TRes res) =
      _CopyWithStubImpl$Mutation$analyzeDataForLibraryMutation;

  TRes call({bool? analyzeDataForLibrary, String? $__typename});
}

class _CopyWithImpl$Mutation$analyzeDataForLibraryMutation<TRes>
    implements CopyWith$Mutation$analyzeDataForLibraryMutation<TRes> {
  _CopyWithImpl$Mutation$analyzeDataForLibraryMutation(
    this._instance,
    this._then,
  );

  final Mutation$analyzeDataForLibraryMutation _instance;

  final TRes Function(Mutation$analyzeDataForLibraryMutation) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? analyzeDataForLibrary = _undefined,
    Object? $__typename = _undefined,
  }) => _then(
    Mutation$analyzeDataForLibraryMutation(
      analyzeDataForLibrary:
          analyzeDataForLibrary == _undefined || analyzeDataForLibrary == null
          ? _instance.analyzeDataForLibrary
          : (analyzeDataForLibrary as bool),
      $__typename: $__typename == _undefined || $__typename == null
          ? _instance.$__typename
          : ($__typename as String),
    ),
  );
}

class _CopyWithStubImpl$Mutation$analyzeDataForLibraryMutation<TRes>
    implements CopyWith$Mutation$analyzeDataForLibraryMutation<TRes> {
  _CopyWithStubImpl$Mutation$analyzeDataForLibraryMutation(this._res);

  TRes _res;

  call({bool? analyzeDataForLibrary, String? $__typename}) => _res;
}

const documentNodeMutationanalyzeDataForLibraryMutation = DocumentNode(
  definitions: [
    OperationDefinitionNode(
      type: OperationType.mutation,
      name: NameNode(value: 'analyzeDataForLibraryMutation'),
      variableDefinitions: [
        VariableDefinitionNode(
          variable: VariableNode(name: NameNode(value: 'libraryId')),
          type: NamedTypeNode(name: NameNode(value: 'ID'), isNonNull: true),
          defaultValue: DefaultValueNode(value: null),
          directives: [],
        ),
      ],
      directives: [],
      selectionSet: SelectionSetNode(
        selections: [
          FieldNode(
            name: NameNode(value: 'analyzeDataForLibrary'),
            alias: null,
            arguments: [
              ArgumentNode(
                name: NameNode(value: 'libraryId'),
                value: VariableNode(name: NameNode(value: 'libraryId')),
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

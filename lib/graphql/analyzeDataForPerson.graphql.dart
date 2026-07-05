import 'package:gql/ast.dart';

class Variables$Mutation$analyzeDataForPersonMutation {
  factory Variables$Mutation$analyzeDataForPersonMutation({
    required String personId,
  }) => Variables$Mutation$analyzeDataForPersonMutation._({
    r'personId': personId,
  });

  Variables$Mutation$analyzeDataForPersonMutation._(this._$data);

  factory Variables$Mutation$analyzeDataForPersonMutation.fromJson(
    Map<String, dynamic> data,
  ) {
    final result$data = <String, dynamic>{};
    final l$personId = data['personId'];
    result$data['personId'] = (l$personId as String);
    return Variables$Mutation$analyzeDataForPersonMutation._(result$data);
  }

  Map<String, dynamic> _$data;

  String get personId => (_$data['personId'] as String);

  Map<String, dynamic> toJson() {
    final result$data = <String, dynamic>{};
    final l$personId = personId;
    result$data['personId'] = l$personId;
    return result$data;
  }

  CopyWith$Variables$Mutation$analyzeDataForPersonMutation<
    Variables$Mutation$analyzeDataForPersonMutation
  >
  get copyWith =>
      CopyWith$Variables$Mutation$analyzeDataForPersonMutation(this, (i) => i);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Variables$Mutation$analyzeDataForPersonMutation ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$personId = personId;
    final lOther$personId = other.personId;
    if (l$personId != lOther$personId) {
      return false;
    }
    return true;
  }

  @override
  int get hashCode {
    final l$personId = personId;
    return Object.hashAll([l$personId]);
  }
}

abstract class CopyWith$Variables$Mutation$analyzeDataForPersonMutation<TRes> {
  factory CopyWith$Variables$Mutation$analyzeDataForPersonMutation(
    Variables$Mutation$analyzeDataForPersonMutation instance,
    TRes Function(Variables$Mutation$analyzeDataForPersonMutation) then,
  ) = _CopyWithImpl$Variables$Mutation$analyzeDataForPersonMutation;

  factory CopyWith$Variables$Mutation$analyzeDataForPersonMutation.stub(
    TRes res,
  ) = _CopyWithStubImpl$Variables$Mutation$analyzeDataForPersonMutation;

  TRes call({String? personId});
}

class _CopyWithImpl$Variables$Mutation$analyzeDataForPersonMutation<TRes>
    implements CopyWith$Variables$Mutation$analyzeDataForPersonMutation<TRes> {
  _CopyWithImpl$Variables$Mutation$analyzeDataForPersonMutation(
    this._instance,
    this._then,
  );

  final Variables$Mutation$analyzeDataForPersonMutation _instance;

  final TRes Function(Variables$Mutation$analyzeDataForPersonMutation) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({Object? personId = _undefined}) => _then(
    Variables$Mutation$analyzeDataForPersonMutation._({
      ..._instance._$data,
      if (personId != _undefined && personId != null)
        'personId': (personId as String),
    }),
  );
}

class _CopyWithStubImpl$Variables$Mutation$analyzeDataForPersonMutation<TRes>
    implements CopyWith$Variables$Mutation$analyzeDataForPersonMutation<TRes> {
  _CopyWithStubImpl$Variables$Mutation$analyzeDataForPersonMutation(this._res);

  TRes _res;

  call({String? personId}) => _res;
}

class Mutation$analyzeDataForPersonMutation {
  Mutation$analyzeDataForPersonMutation({
    required this.analyzeDataForPerson,
    this.$__typename = 'Mutation',
  });

  factory Mutation$analyzeDataForPersonMutation.fromJson(
    Map<String, dynamic> json,
  ) {
    final l$analyzeDataForPerson = json['analyzeDataForPerson'];
    final l$$__typename = json['__typename'];
    return Mutation$analyzeDataForPersonMutation(
      analyzeDataForPerson: (l$analyzeDataForPerson as bool),
      $__typename: (l$$__typename as String),
    );
  }

  final bool analyzeDataForPerson;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$analyzeDataForPerson = analyzeDataForPerson;
    _resultData['analyzeDataForPerson'] = l$analyzeDataForPerson;
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$analyzeDataForPerson = analyzeDataForPerson;
    final l$$__typename = $__typename;
    return Object.hashAll([l$analyzeDataForPerson, l$$__typename]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Mutation$analyzeDataForPersonMutation ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$analyzeDataForPerson = analyzeDataForPerson;
    final lOther$analyzeDataForPerson = other.analyzeDataForPerson;
    if (l$analyzeDataForPerson != lOther$analyzeDataForPerson) {
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

extension UtilityExtension$Mutation$analyzeDataForPersonMutation
    on Mutation$analyzeDataForPersonMutation {
  CopyWith$Mutation$analyzeDataForPersonMutation<
    Mutation$analyzeDataForPersonMutation
  >
  get copyWith =>
      CopyWith$Mutation$analyzeDataForPersonMutation(this, (i) => i);
}

abstract class CopyWith$Mutation$analyzeDataForPersonMutation<TRes> {
  factory CopyWith$Mutation$analyzeDataForPersonMutation(
    Mutation$analyzeDataForPersonMutation instance,
    TRes Function(Mutation$analyzeDataForPersonMutation) then,
  ) = _CopyWithImpl$Mutation$analyzeDataForPersonMutation;

  factory CopyWith$Mutation$analyzeDataForPersonMutation.stub(TRes res) =
      _CopyWithStubImpl$Mutation$analyzeDataForPersonMutation;

  TRes call({bool? analyzeDataForPerson, String? $__typename});
}

class _CopyWithImpl$Mutation$analyzeDataForPersonMutation<TRes>
    implements CopyWith$Mutation$analyzeDataForPersonMutation<TRes> {
  _CopyWithImpl$Mutation$analyzeDataForPersonMutation(
    this._instance,
    this._then,
  );

  final Mutation$analyzeDataForPersonMutation _instance;

  final TRes Function(Mutation$analyzeDataForPersonMutation) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? analyzeDataForPerson = _undefined,
    Object? $__typename = _undefined,
  }) => _then(
    Mutation$analyzeDataForPersonMutation(
      analyzeDataForPerson:
          analyzeDataForPerson == _undefined || analyzeDataForPerson == null
          ? _instance.analyzeDataForPerson
          : (analyzeDataForPerson as bool),
      $__typename: $__typename == _undefined || $__typename == null
          ? _instance.$__typename
          : ($__typename as String),
    ),
  );
}

class _CopyWithStubImpl$Mutation$analyzeDataForPersonMutation<TRes>
    implements CopyWith$Mutation$analyzeDataForPersonMutation<TRes> {
  _CopyWithStubImpl$Mutation$analyzeDataForPersonMutation(this._res);

  TRes _res;

  call({bool? analyzeDataForPerson, String? $__typename}) => _res;
}

const documentNodeMutationanalyzeDataForPersonMutation = DocumentNode(
  definitions: [
    OperationDefinitionNode(
      type: OperationType.mutation,
      name: NameNode(value: 'analyzeDataForPersonMutation'),
      variableDefinitions: [
        VariableDefinitionNode(
          variable: VariableNode(name: NameNode(value: 'personId')),
          type: NamedTypeNode(name: NameNode(value: 'ID'), isNonNull: true),
          defaultValue: DefaultValueNode(value: null),
          directives: [],
        ),
      ],
      directives: [],
      selectionSet: SelectionSetNode(
        selections: [
          FieldNode(
            name: NameNode(value: 'analyzeDataForPerson'),
            alias: null,
            arguments: [
              ArgumentNode(
                name: NameNode(value: 'personId'),
                value: VariableNode(name: NameNode(value: 'personId')),
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

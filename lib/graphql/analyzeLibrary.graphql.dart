import 'package:gql/ast.dart';

class Mutation$analyzeLibrary {
  Mutation$analyzeLibrary({
    required this.analyzeLibrary,
    this.$__typename = 'Mutation',
  });

  factory Mutation$analyzeLibrary.fromJson(Map<String, dynamic> json) {
    final l$analyzeLibrary = json['analyzeLibrary'];
    final l$$__typename = json['__typename'];
    return Mutation$analyzeLibrary(
      analyzeLibrary: (l$analyzeLibrary as bool),
      $__typename: (l$$__typename as String),
    );
  }

  final bool analyzeLibrary;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$analyzeLibrary = analyzeLibrary;
    _resultData['analyzeLibrary'] = l$analyzeLibrary;
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$analyzeLibrary = analyzeLibrary;
    final l$$__typename = $__typename;
    return Object.hashAll([l$analyzeLibrary, l$$__typename]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Mutation$analyzeLibrary || runtimeType != other.runtimeType) {
      return false;
    }
    final l$analyzeLibrary = analyzeLibrary;
    final lOther$analyzeLibrary = other.analyzeLibrary;
    if (l$analyzeLibrary != lOther$analyzeLibrary) {
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

extension UtilityExtension$Mutation$analyzeLibrary on Mutation$analyzeLibrary {
  CopyWith$Mutation$analyzeLibrary<Mutation$analyzeLibrary> get copyWith =>
      CopyWith$Mutation$analyzeLibrary(this, (i) => i);
}

abstract class CopyWith$Mutation$analyzeLibrary<TRes> {
  factory CopyWith$Mutation$analyzeLibrary(
    Mutation$analyzeLibrary instance,
    TRes Function(Mutation$analyzeLibrary) then,
  ) = _CopyWithImpl$Mutation$analyzeLibrary;

  factory CopyWith$Mutation$analyzeLibrary.stub(TRes res) =
      _CopyWithStubImpl$Mutation$analyzeLibrary;

  TRes call({bool? analyzeLibrary, String? $__typename});
}

class _CopyWithImpl$Mutation$analyzeLibrary<TRes>
    implements CopyWith$Mutation$analyzeLibrary<TRes> {
  _CopyWithImpl$Mutation$analyzeLibrary(this._instance, this._then);

  final Mutation$analyzeLibrary _instance;

  final TRes Function(Mutation$analyzeLibrary) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? analyzeLibrary = _undefined,
    Object? $__typename = _undefined,
  }) => _then(
    Mutation$analyzeLibrary(
      analyzeLibrary: analyzeLibrary == _undefined || analyzeLibrary == null
          ? _instance.analyzeLibrary
          : (analyzeLibrary as bool),
      $__typename: $__typename == _undefined || $__typename == null
          ? _instance.$__typename
          : ($__typename as String),
    ),
  );
}

class _CopyWithStubImpl$Mutation$analyzeLibrary<TRes>
    implements CopyWith$Mutation$analyzeLibrary<TRes> {
  _CopyWithStubImpl$Mutation$analyzeLibrary(this._res);

  TRes _res;

  call({bool? analyzeLibrary, String? $__typename}) => _res;
}

const documentNodeMutationanalyzeLibrary = DocumentNode(
  definitions: [
    OperationDefinitionNode(
      type: OperationType.mutation,
      name: NameNode(value: 'analyzeLibrary'),
      variableDefinitions: [],
      directives: [],
      selectionSet: SelectionSetNode(
        selections: [
          FieldNode(
            name: NameNode(value: 'analyzeLibrary'),
            alias: null,
            arguments: [],
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

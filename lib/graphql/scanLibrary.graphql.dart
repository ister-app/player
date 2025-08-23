import 'package:gql/ast.dart';

class Mutation$scanLibrary {
  Mutation$scanLibrary({this.scanLibrary, this.$__typename = 'Mutation'});

  factory Mutation$scanLibrary.fromJson(Map<String, dynamic> json) {
    final l$scanLibrary = json['scanLibrary'];
    final l$$__typename = json['__typename'];
    return Mutation$scanLibrary(
      scanLibrary: (l$scanLibrary as bool?),
      $__typename: (l$$__typename as String),
    );
  }

  final bool? scanLibrary;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$scanLibrary = scanLibrary;
    _resultData['scanLibrary'] = l$scanLibrary;
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$scanLibrary = scanLibrary;
    final l$$__typename = $__typename;
    return Object.hashAll([l$scanLibrary, l$$__typename]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Mutation$scanLibrary || runtimeType != other.runtimeType) {
      return false;
    }
    final l$scanLibrary = scanLibrary;
    final lOther$scanLibrary = other.scanLibrary;
    if (l$scanLibrary != lOther$scanLibrary) {
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

extension UtilityExtension$Mutation$scanLibrary on Mutation$scanLibrary {
  CopyWith$Mutation$scanLibrary<Mutation$scanLibrary> get copyWith =>
      CopyWith$Mutation$scanLibrary(this, (i) => i);
}

abstract class CopyWith$Mutation$scanLibrary<TRes> {
  factory CopyWith$Mutation$scanLibrary(
    Mutation$scanLibrary instance,
    TRes Function(Mutation$scanLibrary) then,
  ) = _CopyWithImpl$Mutation$scanLibrary;

  factory CopyWith$Mutation$scanLibrary.stub(TRes res) =
      _CopyWithStubImpl$Mutation$scanLibrary;

  TRes call({bool? scanLibrary, String? $__typename});
}

class _CopyWithImpl$Mutation$scanLibrary<TRes>
    implements CopyWith$Mutation$scanLibrary<TRes> {
  _CopyWithImpl$Mutation$scanLibrary(this._instance, this._then);

  final Mutation$scanLibrary _instance;

  final TRes Function(Mutation$scanLibrary) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? scanLibrary = _undefined,
    Object? $__typename = _undefined,
  }) => _then(
    Mutation$scanLibrary(
      scanLibrary: scanLibrary == _undefined
          ? _instance.scanLibrary
          : (scanLibrary as bool?),
      $__typename: $__typename == _undefined || $__typename == null
          ? _instance.$__typename
          : ($__typename as String),
    ),
  );
}

class _CopyWithStubImpl$Mutation$scanLibrary<TRes>
    implements CopyWith$Mutation$scanLibrary<TRes> {
  _CopyWithStubImpl$Mutation$scanLibrary(this._res);

  TRes _res;

  call({bool? scanLibrary, String? $__typename}) => _res;
}

const documentNodeMutationscanLibrary = DocumentNode(
  definitions: [
    OperationDefinitionNode(
      type: OperationType.mutation,
      name: NameNode(value: 'scanLibrary'),
      variableDefinitions: [],
      directives: [],
      selectionSet: SelectionSetNode(
        selections: [
          FieldNode(
            name: NameNode(value: 'scanLibrary'),
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

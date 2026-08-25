import 'package:gql/ast.dart';

class Mutation$rebuildSearchIndex {
  Mutation$rebuildSearchIndex({
    required this.rebuildSearchIndex,
    this.$__typename = 'Mutation',
  });

  factory Mutation$rebuildSearchIndex.fromJson(Map<String, dynamic> json) {
    final l$rebuildSearchIndex = json['rebuildSearchIndex'];
    final l$$__typename = json['__typename'];
    return Mutation$rebuildSearchIndex(
      rebuildSearchIndex: (l$rebuildSearchIndex as bool),
      $__typename: (l$$__typename as String),
    );
  }

  final bool rebuildSearchIndex;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$rebuildSearchIndex = rebuildSearchIndex;
    _resultData['rebuildSearchIndex'] = l$rebuildSearchIndex;
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$rebuildSearchIndex = rebuildSearchIndex;
    final l$$__typename = $__typename;
    return Object.hashAll([l$rebuildSearchIndex, l$$__typename]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Mutation$rebuildSearchIndex ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$rebuildSearchIndex = rebuildSearchIndex;
    final lOther$rebuildSearchIndex = other.rebuildSearchIndex;
    if (l$rebuildSearchIndex != lOther$rebuildSearchIndex) {
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

extension UtilityExtension$Mutation$rebuildSearchIndex
    on Mutation$rebuildSearchIndex {
  CopyWith$Mutation$rebuildSearchIndex<Mutation$rebuildSearchIndex>
  get copyWith => CopyWith$Mutation$rebuildSearchIndex(this, (i) => i);
}

abstract class CopyWith$Mutation$rebuildSearchIndex<TRes> {
  factory CopyWith$Mutation$rebuildSearchIndex(
    Mutation$rebuildSearchIndex instance,
    TRes Function(Mutation$rebuildSearchIndex) then,
  ) = _CopyWithImpl$Mutation$rebuildSearchIndex;

  factory CopyWith$Mutation$rebuildSearchIndex.stub(TRes res) =
      _CopyWithStubImpl$Mutation$rebuildSearchIndex;

  TRes call({bool? rebuildSearchIndex, String? $__typename});
}

class _CopyWithImpl$Mutation$rebuildSearchIndex<TRes>
    implements CopyWith$Mutation$rebuildSearchIndex<TRes> {
  _CopyWithImpl$Mutation$rebuildSearchIndex(this._instance, this._then);

  final Mutation$rebuildSearchIndex _instance;

  final TRes Function(Mutation$rebuildSearchIndex) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? rebuildSearchIndex = _undefined,
    Object? $__typename = _undefined,
  }) => _then(
    Mutation$rebuildSearchIndex(
      rebuildSearchIndex:
          rebuildSearchIndex == _undefined || rebuildSearchIndex == null
          ? _instance.rebuildSearchIndex
          : (rebuildSearchIndex as bool),
      $__typename: $__typename == _undefined || $__typename == null
          ? _instance.$__typename
          : ($__typename as String),
    ),
  );
}

class _CopyWithStubImpl$Mutation$rebuildSearchIndex<TRes>
    implements CopyWith$Mutation$rebuildSearchIndex<TRes> {
  _CopyWithStubImpl$Mutation$rebuildSearchIndex(this._res);

  TRes _res;

  call({bool? rebuildSearchIndex, String? $__typename}) => _res;
}

const documentNodeMutationrebuildSearchIndex = DocumentNode(
  definitions: [
    OperationDefinitionNode(
      type: OperationType.mutation,
      name: NameNode(value: 'rebuildSearchIndex'),
      variableDefinitions: [],
      directives: [],
      selectionSet: SelectionSetNode(
        selections: [
          FieldNode(
            name: NameNode(value: 'rebuildSearchIndex'),
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

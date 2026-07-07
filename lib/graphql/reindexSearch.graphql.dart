import 'package:gql/ast.dart';

class Mutation$reindexSearch {
  Mutation$reindexSearch({
    required this.reindexSearch,
    this.$__typename = 'Mutation',
  });

  factory Mutation$reindexSearch.fromJson(Map<String, dynamic> json) {
    final l$reindexSearch = json['reindexSearch'];
    final l$$__typename = json['__typename'];
    return Mutation$reindexSearch(
      reindexSearch: (l$reindexSearch as bool),
      $__typename: (l$$__typename as String),
    );
  }

  final bool reindexSearch;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$reindexSearch = reindexSearch;
    _resultData['reindexSearch'] = l$reindexSearch;
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$reindexSearch = reindexSearch;
    final l$$__typename = $__typename;
    return Object.hashAll([l$reindexSearch, l$$__typename]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Mutation$reindexSearch || runtimeType != other.runtimeType) {
      return false;
    }
    final l$reindexSearch = reindexSearch;
    final lOther$reindexSearch = other.reindexSearch;
    if (l$reindexSearch != lOther$reindexSearch) {
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

extension UtilityExtension$Mutation$reindexSearch on Mutation$reindexSearch {
  CopyWith$Mutation$reindexSearch<Mutation$reindexSearch> get copyWith =>
      CopyWith$Mutation$reindexSearch(this, (i) => i);
}

abstract class CopyWith$Mutation$reindexSearch<TRes> {
  factory CopyWith$Mutation$reindexSearch(
    Mutation$reindexSearch instance,
    TRes Function(Mutation$reindexSearch) then,
  ) = _CopyWithImpl$Mutation$reindexSearch;

  factory CopyWith$Mutation$reindexSearch.stub(TRes res) =
      _CopyWithStubImpl$Mutation$reindexSearch;

  TRes call({bool? reindexSearch, String? $__typename});
}

class _CopyWithImpl$Mutation$reindexSearch<TRes>
    implements CopyWith$Mutation$reindexSearch<TRes> {
  _CopyWithImpl$Mutation$reindexSearch(this._instance, this._then);

  final Mutation$reindexSearch _instance;

  final TRes Function(Mutation$reindexSearch) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? reindexSearch = _undefined,
    Object? $__typename = _undefined,
  }) => _then(
    Mutation$reindexSearch(
      reindexSearch: reindexSearch == _undefined || reindexSearch == null
          ? _instance.reindexSearch
          : (reindexSearch as bool),
      $__typename: $__typename == _undefined || $__typename == null
          ? _instance.$__typename
          : ($__typename as String),
    ),
  );
}

class _CopyWithStubImpl$Mutation$reindexSearch<TRes>
    implements CopyWith$Mutation$reindexSearch<TRes> {
  _CopyWithStubImpl$Mutation$reindexSearch(this._res);

  TRes _res;

  call({bool? reindexSearch, String? $__typename}) => _res;
}

const documentNodeMutationreindexSearch = DocumentNode(
  definitions: [
    OperationDefinitionNode(
      type: OperationType.mutation,
      name: NameNode(value: 'reindexSearch'),
      variableDefinitions: [],
      directives: [],
      selectionSet: SelectionSetNode(
        selections: [
          FieldNode(
            name: NameNode(value: 'reindexSearch'),
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

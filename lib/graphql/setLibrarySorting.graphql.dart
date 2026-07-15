import 'package:gql/ast.dart';
import 'schema.graphql.dart';

class Variables$Mutation$setLibrarySorting {
  factory Variables$Mutation$setLibrarySorting({
    required String libraryId,
    required Enum$SortingEnum sorting,
    required Enum$SortingOrder sortingOrder,
  }) => Variables$Mutation$setLibrarySorting._({
    r'libraryId': libraryId,
    r'sorting': sorting,
    r'sortingOrder': sortingOrder,
  });

  Variables$Mutation$setLibrarySorting._(this._$data);

  factory Variables$Mutation$setLibrarySorting.fromJson(
    Map<String, dynamic> data,
  ) {
    final result$data = <String, dynamic>{};
    final l$libraryId = data['libraryId'];
    result$data['libraryId'] = (l$libraryId as String);
    final l$sorting = data['sorting'];
    result$data['sorting'] = fromJson$Enum$SortingEnum((l$sorting as String));
    final l$sortingOrder = data['sortingOrder'];
    result$data['sortingOrder'] = fromJson$Enum$SortingOrder(
      (l$sortingOrder as String),
    );
    return Variables$Mutation$setLibrarySorting._(result$data);
  }

  Map<String, dynamic> _$data;

  String get libraryId => (_$data['libraryId'] as String);

  Enum$SortingEnum get sorting => (_$data['sorting'] as Enum$SortingEnum);

  Enum$SortingOrder get sortingOrder =>
      (_$data['sortingOrder'] as Enum$SortingOrder);

  Map<String, dynamic> toJson() {
    final result$data = <String, dynamic>{};
    final l$libraryId = libraryId;
    result$data['libraryId'] = l$libraryId;
    final l$sorting = sorting;
    result$data['sorting'] = toJson$Enum$SortingEnum(l$sorting);
    final l$sortingOrder = sortingOrder;
    result$data['sortingOrder'] = toJson$Enum$SortingOrder(l$sortingOrder);
    return result$data;
  }

  CopyWith$Variables$Mutation$setLibrarySorting<
    Variables$Mutation$setLibrarySorting
  >
  get copyWith => CopyWith$Variables$Mutation$setLibrarySorting(this, (i) => i);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Variables$Mutation$setLibrarySorting ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$libraryId = libraryId;
    final lOther$libraryId = other.libraryId;
    if (l$libraryId != lOther$libraryId) {
      return false;
    }
    final l$sorting = sorting;
    final lOther$sorting = other.sorting;
    if (l$sorting != lOther$sorting) {
      return false;
    }
    final l$sortingOrder = sortingOrder;
    final lOther$sortingOrder = other.sortingOrder;
    if (l$sortingOrder != lOther$sortingOrder) {
      return false;
    }
    return true;
  }

  @override
  int get hashCode {
    final l$libraryId = libraryId;
    final l$sorting = sorting;
    final l$sortingOrder = sortingOrder;
    return Object.hashAll([l$libraryId, l$sorting, l$sortingOrder]);
  }
}

abstract class CopyWith$Variables$Mutation$setLibrarySorting<TRes> {
  factory CopyWith$Variables$Mutation$setLibrarySorting(
    Variables$Mutation$setLibrarySorting instance,
    TRes Function(Variables$Mutation$setLibrarySorting) then,
  ) = _CopyWithImpl$Variables$Mutation$setLibrarySorting;

  factory CopyWith$Variables$Mutation$setLibrarySorting.stub(TRes res) =
      _CopyWithStubImpl$Variables$Mutation$setLibrarySorting;

  TRes call({
    String? libraryId,
    Enum$SortingEnum? sorting,
    Enum$SortingOrder? sortingOrder,
  });
}

class _CopyWithImpl$Variables$Mutation$setLibrarySorting<TRes>
    implements CopyWith$Variables$Mutation$setLibrarySorting<TRes> {
  _CopyWithImpl$Variables$Mutation$setLibrarySorting(
    this._instance,
    this._then,
  );

  final Variables$Mutation$setLibrarySorting _instance;

  final TRes Function(Variables$Mutation$setLibrarySorting) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? libraryId = _undefined,
    Object? sorting = _undefined,
    Object? sortingOrder = _undefined,
  }) => _then(
    Variables$Mutation$setLibrarySorting._({
      ..._instance._$data,
      if (libraryId != _undefined && libraryId != null)
        'libraryId': (libraryId as String),
      if (sorting != _undefined && sorting != null)
        'sorting': (sorting as Enum$SortingEnum),
      if (sortingOrder != _undefined && sortingOrder != null)
        'sortingOrder': (sortingOrder as Enum$SortingOrder),
    }),
  );
}

class _CopyWithStubImpl$Variables$Mutation$setLibrarySorting<TRes>
    implements CopyWith$Variables$Mutation$setLibrarySorting<TRes> {
  _CopyWithStubImpl$Variables$Mutation$setLibrarySorting(this._res);

  TRes _res;

  call({
    String? libraryId,
    Enum$SortingEnum? sorting,
    Enum$SortingOrder? sortingOrder,
  }) => _res;
}

class Mutation$setLibrarySorting {
  Mutation$setLibrarySorting({
    required this.setLibrarySorting,
    this.$__typename = 'Mutation',
  });

  factory Mutation$setLibrarySorting.fromJson(Map<String, dynamic> json) {
    final l$setLibrarySorting = json['setLibrarySorting'];
    final l$$__typename = json['__typename'];
    return Mutation$setLibrarySorting(
      setLibrarySorting: (l$setLibrarySorting as bool),
      $__typename: (l$$__typename as String),
    );
  }

  final bool setLibrarySorting;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$setLibrarySorting = setLibrarySorting;
    _resultData['setLibrarySorting'] = l$setLibrarySorting;
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$setLibrarySorting = setLibrarySorting;
    final l$$__typename = $__typename;
    return Object.hashAll([l$setLibrarySorting, l$$__typename]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Mutation$setLibrarySorting ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$setLibrarySorting = setLibrarySorting;
    final lOther$setLibrarySorting = other.setLibrarySorting;
    if (l$setLibrarySorting != lOther$setLibrarySorting) {
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

extension UtilityExtension$Mutation$setLibrarySorting
    on Mutation$setLibrarySorting {
  CopyWith$Mutation$setLibrarySorting<Mutation$setLibrarySorting>
  get copyWith => CopyWith$Mutation$setLibrarySorting(this, (i) => i);
}

abstract class CopyWith$Mutation$setLibrarySorting<TRes> {
  factory CopyWith$Mutation$setLibrarySorting(
    Mutation$setLibrarySorting instance,
    TRes Function(Mutation$setLibrarySorting) then,
  ) = _CopyWithImpl$Mutation$setLibrarySorting;

  factory CopyWith$Mutation$setLibrarySorting.stub(TRes res) =
      _CopyWithStubImpl$Mutation$setLibrarySorting;

  TRes call({bool? setLibrarySorting, String? $__typename});
}

class _CopyWithImpl$Mutation$setLibrarySorting<TRes>
    implements CopyWith$Mutation$setLibrarySorting<TRes> {
  _CopyWithImpl$Mutation$setLibrarySorting(this._instance, this._then);

  final Mutation$setLibrarySorting _instance;

  final TRes Function(Mutation$setLibrarySorting) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? setLibrarySorting = _undefined,
    Object? $__typename = _undefined,
  }) => _then(
    Mutation$setLibrarySorting(
      setLibrarySorting:
          setLibrarySorting == _undefined || setLibrarySorting == null
          ? _instance.setLibrarySorting
          : (setLibrarySorting as bool),
      $__typename: $__typename == _undefined || $__typename == null
          ? _instance.$__typename
          : ($__typename as String),
    ),
  );
}

class _CopyWithStubImpl$Mutation$setLibrarySorting<TRes>
    implements CopyWith$Mutation$setLibrarySorting<TRes> {
  _CopyWithStubImpl$Mutation$setLibrarySorting(this._res);

  TRes _res;

  call({bool? setLibrarySorting, String? $__typename}) => _res;
}

const documentNodeMutationsetLibrarySorting = DocumentNode(
  definitions: [
    OperationDefinitionNode(
      type: OperationType.mutation,
      name: NameNode(value: 'setLibrarySorting'),
      variableDefinitions: [
        VariableDefinitionNode(
          variable: VariableNode(name: NameNode(value: 'libraryId')),
          type: NamedTypeNode(name: NameNode(value: 'ID'), isNonNull: true),
          defaultValue: DefaultValueNode(value: null),
          directives: [],
        ),
        VariableDefinitionNode(
          variable: VariableNode(name: NameNode(value: 'sorting')),
          type: NamedTypeNode(
            name: NameNode(value: 'SortingEnum'),
            isNonNull: true,
          ),
          defaultValue: DefaultValueNode(value: null),
          directives: [],
        ),
        VariableDefinitionNode(
          variable: VariableNode(name: NameNode(value: 'sortingOrder')),
          type: NamedTypeNode(
            name: NameNode(value: 'SortingOrder'),
            isNonNull: true,
          ),
          defaultValue: DefaultValueNode(value: null),
          directives: [],
        ),
      ],
      directives: [],
      selectionSet: SelectionSetNode(
        selections: [
          FieldNode(
            name: NameNode(value: 'setLibrarySorting'),
            alias: null,
            arguments: [
              ArgumentNode(
                name: NameNode(value: 'libraryId'),
                value: VariableNode(name: NameNode(value: 'libraryId')),
              ),
              ArgumentNode(
                name: NameNode(value: 'sorting'),
                value: VariableNode(name: NameNode(value: 'sorting')),
              ),
              ArgumentNode(
                name: NameNode(value: 'sortingOrder'),
                value: VariableNode(name: NameNode(value: 'sortingOrder')),
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

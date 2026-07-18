import 'package:gql/ast.dart';

class Variables$Mutation$setLibraryVisibleToAll {
  factory Variables$Mutation$setLibraryVisibleToAll({
    required String libraryId,
    required bool visibleToAll,
  }) => Variables$Mutation$setLibraryVisibleToAll._({
    r'libraryId': libraryId,
    r'visibleToAll': visibleToAll,
  });

  Variables$Mutation$setLibraryVisibleToAll._(this._$data);

  factory Variables$Mutation$setLibraryVisibleToAll.fromJson(
    Map<String, dynamic> data,
  ) {
    final result$data = <String, dynamic>{};
    final l$libraryId = data['libraryId'];
    result$data['libraryId'] = (l$libraryId as String);
    final l$visibleToAll = data['visibleToAll'];
    result$data['visibleToAll'] = (l$visibleToAll as bool);
    return Variables$Mutation$setLibraryVisibleToAll._(result$data);
  }

  Map<String, dynamic> _$data;

  String get libraryId => (_$data['libraryId'] as String);

  bool get visibleToAll => (_$data['visibleToAll'] as bool);

  Map<String, dynamic> toJson() {
    final result$data = <String, dynamic>{};
    final l$libraryId = libraryId;
    result$data['libraryId'] = l$libraryId;
    final l$visibleToAll = visibleToAll;
    result$data['visibleToAll'] = l$visibleToAll;
    return result$data;
  }

  CopyWith$Variables$Mutation$setLibraryVisibleToAll<
    Variables$Mutation$setLibraryVisibleToAll
  >
  get copyWith =>
      CopyWith$Variables$Mutation$setLibraryVisibleToAll(this, (i) => i);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Variables$Mutation$setLibraryVisibleToAll ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$libraryId = libraryId;
    final lOther$libraryId = other.libraryId;
    if (l$libraryId != lOther$libraryId) {
      return false;
    }
    final l$visibleToAll = visibleToAll;
    final lOther$visibleToAll = other.visibleToAll;
    if (l$visibleToAll != lOther$visibleToAll) {
      return false;
    }
    return true;
  }

  @override
  int get hashCode {
    final l$libraryId = libraryId;
    final l$visibleToAll = visibleToAll;
    return Object.hashAll([l$libraryId, l$visibleToAll]);
  }
}

abstract class CopyWith$Variables$Mutation$setLibraryVisibleToAll<TRes> {
  factory CopyWith$Variables$Mutation$setLibraryVisibleToAll(
    Variables$Mutation$setLibraryVisibleToAll instance,
    TRes Function(Variables$Mutation$setLibraryVisibleToAll) then,
  ) = _CopyWithImpl$Variables$Mutation$setLibraryVisibleToAll;

  factory CopyWith$Variables$Mutation$setLibraryVisibleToAll.stub(TRes res) =
      _CopyWithStubImpl$Variables$Mutation$setLibraryVisibleToAll;

  TRes call({String? libraryId, bool? visibleToAll});
}

class _CopyWithImpl$Variables$Mutation$setLibraryVisibleToAll<TRes>
    implements CopyWith$Variables$Mutation$setLibraryVisibleToAll<TRes> {
  _CopyWithImpl$Variables$Mutation$setLibraryVisibleToAll(
    this._instance,
    this._then,
  );

  final Variables$Mutation$setLibraryVisibleToAll _instance;

  final TRes Function(Variables$Mutation$setLibraryVisibleToAll) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? libraryId = _undefined,
    Object? visibleToAll = _undefined,
  }) => _then(
    Variables$Mutation$setLibraryVisibleToAll._({
      ..._instance._$data,
      if (libraryId != _undefined && libraryId != null)
        'libraryId': (libraryId as String),
      if (visibleToAll != _undefined && visibleToAll != null)
        'visibleToAll': (visibleToAll as bool),
    }),
  );
}

class _CopyWithStubImpl$Variables$Mutation$setLibraryVisibleToAll<TRes>
    implements CopyWith$Variables$Mutation$setLibraryVisibleToAll<TRes> {
  _CopyWithStubImpl$Variables$Mutation$setLibraryVisibleToAll(this._res);

  TRes _res;

  call({String? libraryId, bool? visibleToAll}) => _res;
}

class Mutation$setLibraryVisibleToAll {
  Mutation$setLibraryVisibleToAll({
    required this.setLibraryVisibleToAll,
    this.$__typename = 'Mutation',
  });

  factory Mutation$setLibraryVisibleToAll.fromJson(Map<String, dynamic> json) {
    final l$setLibraryVisibleToAll = json['setLibraryVisibleToAll'];
    final l$$__typename = json['__typename'];
    return Mutation$setLibraryVisibleToAll(
      setLibraryVisibleToAll: (l$setLibraryVisibleToAll as bool),
      $__typename: (l$$__typename as String),
    );
  }

  final bool setLibraryVisibleToAll;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$setLibraryVisibleToAll = setLibraryVisibleToAll;
    _resultData['setLibraryVisibleToAll'] = l$setLibraryVisibleToAll;
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$setLibraryVisibleToAll = setLibraryVisibleToAll;
    final l$$__typename = $__typename;
    return Object.hashAll([l$setLibraryVisibleToAll, l$$__typename]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Mutation$setLibraryVisibleToAll ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$setLibraryVisibleToAll = setLibraryVisibleToAll;
    final lOther$setLibraryVisibleToAll = other.setLibraryVisibleToAll;
    if (l$setLibraryVisibleToAll != lOther$setLibraryVisibleToAll) {
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

extension UtilityExtension$Mutation$setLibraryVisibleToAll
    on Mutation$setLibraryVisibleToAll {
  CopyWith$Mutation$setLibraryVisibleToAll<Mutation$setLibraryVisibleToAll>
  get copyWith => CopyWith$Mutation$setLibraryVisibleToAll(this, (i) => i);
}

abstract class CopyWith$Mutation$setLibraryVisibleToAll<TRes> {
  factory CopyWith$Mutation$setLibraryVisibleToAll(
    Mutation$setLibraryVisibleToAll instance,
    TRes Function(Mutation$setLibraryVisibleToAll) then,
  ) = _CopyWithImpl$Mutation$setLibraryVisibleToAll;

  factory CopyWith$Mutation$setLibraryVisibleToAll.stub(TRes res) =
      _CopyWithStubImpl$Mutation$setLibraryVisibleToAll;

  TRes call({bool? setLibraryVisibleToAll, String? $__typename});
}

class _CopyWithImpl$Mutation$setLibraryVisibleToAll<TRes>
    implements CopyWith$Mutation$setLibraryVisibleToAll<TRes> {
  _CopyWithImpl$Mutation$setLibraryVisibleToAll(this._instance, this._then);

  final Mutation$setLibraryVisibleToAll _instance;

  final TRes Function(Mutation$setLibraryVisibleToAll) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? setLibraryVisibleToAll = _undefined,
    Object? $__typename = _undefined,
  }) => _then(
    Mutation$setLibraryVisibleToAll(
      setLibraryVisibleToAll:
          setLibraryVisibleToAll == _undefined || setLibraryVisibleToAll == null
          ? _instance.setLibraryVisibleToAll
          : (setLibraryVisibleToAll as bool),
      $__typename: $__typename == _undefined || $__typename == null
          ? _instance.$__typename
          : ($__typename as String),
    ),
  );
}

class _CopyWithStubImpl$Mutation$setLibraryVisibleToAll<TRes>
    implements CopyWith$Mutation$setLibraryVisibleToAll<TRes> {
  _CopyWithStubImpl$Mutation$setLibraryVisibleToAll(this._res);

  TRes _res;

  call({bool? setLibraryVisibleToAll, String? $__typename}) => _res;
}

const documentNodeMutationsetLibraryVisibleToAll = DocumentNode(
  definitions: [
    OperationDefinitionNode(
      type: OperationType.mutation,
      name: NameNode(value: 'setLibraryVisibleToAll'),
      variableDefinitions: [
        VariableDefinitionNode(
          variable: VariableNode(name: NameNode(value: 'libraryId')),
          type: NamedTypeNode(name: NameNode(value: 'ID'), isNonNull: true),
          defaultValue: DefaultValueNode(value: null),
          directives: [],
        ),
        VariableDefinitionNode(
          variable: VariableNode(name: NameNode(value: 'visibleToAll')),
          type: NamedTypeNode(
            name: NameNode(value: 'Boolean'),
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
            name: NameNode(value: 'setLibraryVisibleToAll'),
            alias: null,
            arguments: [
              ArgumentNode(
                name: NameNode(value: 'libraryId'),
                value: VariableNode(name: NameNode(value: 'libraryId')),
              ),
              ArgumentNode(
                name: NameNode(value: 'visibleToAll'),
                value: VariableNode(name: NameNode(value: 'visibleToAll')),
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

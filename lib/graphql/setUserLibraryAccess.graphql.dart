import 'package:gql/ast.dart';

class Variables$Mutation$setUserLibraryAccess {
  factory Variables$Mutation$setUserLibraryAccess({
    required String userId,
    required String libraryId,
    required bool granted,
  }) => Variables$Mutation$setUserLibraryAccess._({
    r'userId': userId,
    r'libraryId': libraryId,
    r'granted': granted,
  });

  Variables$Mutation$setUserLibraryAccess._(this._$data);

  factory Variables$Mutation$setUserLibraryAccess.fromJson(
    Map<String, dynamic> data,
  ) {
    final result$data = <String, dynamic>{};
    final l$userId = data['userId'];
    result$data['userId'] = (l$userId as String);
    final l$libraryId = data['libraryId'];
    result$data['libraryId'] = (l$libraryId as String);
    final l$granted = data['granted'];
    result$data['granted'] = (l$granted as bool);
    return Variables$Mutation$setUserLibraryAccess._(result$data);
  }

  Map<String, dynamic> _$data;

  String get userId => (_$data['userId'] as String);

  String get libraryId => (_$data['libraryId'] as String);

  bool get granted => (_$data['granted'] as bool);

  Map<String, dynamic> toJson() {
    final result$data = <String, dynamic>{};
    final l$userId = userId;
    result$data['userId'] = l$userId;
    final l$libraryId = libraryId;
    result$data['libraryId'] = l$libraryId;
    final l$granted = granted;
    result$data['granted'] = l$granted;
    return result$data;
  }

  CopyWith$Variables$Mutation$setUserLibraryAccess<
    Variables$Mutation$setUserLibraryAccess
  >
  get copyWith =>
      CopyWith$Variables$Mutation$setUserLibraryAccess(this, (i) => i);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Variables$Mutation$setUserLibraryAccess ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$userId = userId;
    final lOther$userId = other.userId;
    if (l$userId != lOther$userId) {
      return false;
    }
    final l$libraryId = libraryId;
    final lOther$libraryId = other.libraryId;
    if (l$libraryId != lOther$libraryId) {
      return false;
    }
    final l$granted = granted;
    final lOther$granted = other.granted;
    if (l$granted != lOther$granted) {
      return false;
    }
    return true;
  }

  @override
  int get hashCode {
    final l$userId = userId;
    final l$libraryId = libraryId;
    final l$granted = granted;
    return Object.hashAll([l$userId, l$libraryId, l$granted]);
  }
}

abstract class CopyWith$Variables$Mutation$setUserLibraryAccess<TRes> {
  factory CopyWith$Variables$Mutation$setUserLibraryAccess(
    Variables$Mutation$setUserLibraryAccess instance,
    TRes Function(Variables$Mutation$setUserLibraryAccess) then,
  ) = _CopyWithImpl$Variables$Mutation$setUserLibraryAccess;

  factory CopyWith$Variables$Mutation$setUserLibraryAccess.stub(TRes res) =
      _CopyWithStubImpl$Variables$Mutation$setUserLibraryAccess;

  TRes call({String? userId, String? libraryId, bool? granted});
}

class _CopyWithImpl$Variables$Mutation$setUserLibraryAccess<TRes>
    implements CopyWith$Variables$Mutation$setUserLibraryAccess<TRes> {
  _CopyWithImpl$Variables$Mutation$setUserLibraryAccess(
    this._instance,
    this._then,
  );

  final Variables$Mutation$setUserLibraryAccess _instance;

  final TRes Function(Variables$Mutation$setUserLibraryAccess) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? userId = _undefined,
    Object? libraryId = _undefined,
    Object? granted = _undefined,
  }) => _then(
    Variables$Mutation$setUserLibraryAccess._({
      ..._instance._$data,
      if (userId != _undefined && userId != null) 'userId': (userId as String),
      if (libraryId != _undefined && libraryId != null)
        'libraryId': (libraryId as String),
      if (granted != _undefined && granted != null)
        'granted': (granted as bool),
    }),
  );
}

class _CopyWithStubImpl$Variables$Mutation$setUserLibraryAccess<TRes>
    implements CopyWith$Variables$Mutation$setUserLibraryAccess<TRes> {
  _CopyWithStubImpl$Variables$Mutation$setUserLibraryAccess(this._res);

  TRes _res;

  call({String? userId, String? libraryId, bool? granted}) => _res;
}

class Mutation$setUserLibraryAccess {
  Mutation$setUserLibraryAccess({
    required this.setUserLibraryAccess,
    this.$__typename = 'Mutation',
  });

  factory Mutation$setUserLibraryAccess.fromJson(Map<String, dynamic> json) {
    final l$setUserLibraryAccess = json['setUserLibraryAccess'];
    final l$$__typename = json['__typename'];
    return Mutation$setUserLibraryAccess(
      setUserLibraryAccess: (l$setUserLibraryAccess as bool),
      $__typename: (l$$__typename as String),
    );
  }

  final bool setUserLibraryAccess;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$setUserLibraryAccess = setUserLibraryAccess;
    _resultData['setUserLibraryAccess'] = l$setUserLibraryAccess;
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$setUserLibraryAccess = setUserLibraryAccess;
    final l$$__typename = $__typename;
    return Object.hashAll([l$setUserLibraryAccess, l$$__typename]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Mutation$setUserLibraryAccess ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$setUserLibraryAccess = setUserLibraryAccess;
    final lOther$setUserLibraryAccess = other.setUserLibraryAccess;
    if (l$setUserLibraryAccess != lOther$setUserLibraryAccess) {
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

extension UtilityExtension$Mutation$setUserLibraryAccess
    on Mutation$setUserLibraryAccess {
  CopyWith$Mutation$setUserLibraryAccess<Mutation$setUserLibraryAccess>
  get copyWith => CopyWith$Mutation$setUserLibraryAccess(this, (i) => i);
}

abstract class CopyWith$Mutation$setUserLibraryAccess<TRes> {
  factory CopyWith$Mutation$setUserLibraryAccess(
    Mutation$setUserLibraryAccess instance,
    TRes Function(Mutation$setUserLibraryAccess) then,
  ) = _CopyWithImpl$Mutation$setUserLibraryAccess;

  factory CopyWith$Mutation$setUserLibraryAccess.stub(TRes res) =
      _CopyWithStubImpl$Mutation$setUserLibraryAccess;

  TRes call({bool? setUserLibraryAccess, String? $__typename});
}

class _CopyWithImpl$Mutation$setUserLibraryAccess<TRes>
    implements CopyWith$Mutation$setUserLibraryAccess<TRes> {
  _CopyWithImpl$Mutation$setUserLibraryAccess(this._instance, this._then);

  final Mutation$setUserLibraryAccess _instance;

  final TRes Function(Mutation$setUserLibraryAccess) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? setUserLibraryAccess = _undefined,
    Object? $__typename = _undefined,
  }) => _then(
    Mutation$setUserLibraryAccess(
      setUserLibraryAccess:
          setUserLibraryAccess == _undefined || setUserLibraryAccess == null
          ? _instance.setUserLibraryAccess
          : (setUserLibraryAccess as bool),
      $__typename: $__typename == _undefined || $__typename == null
          ? _instance.$__typename
          : ($__typename as String),
    ),
  );
}

class _CopyWithStubImpl$Mutation$setUserLibraryAccess<TRes>
    implements CopyWith$Mutation$setUserLibraryAccess<TRes> {
  _CopyWithStubImpl$Mutation$setUserLibraryAccess(this._res);

  TRes _res;

  call({bool? setUserLibraryAccess, String? $__typename}) => _res;
}

const documentNodeMutationsetUserLibraryAccess = DocumentNode(
  definitions: [
    OperationDefinitionNode(
      type: OperationType.mutation,
      name: NameNode(value: 'setUserLibraryAccess'),
      variableDefinitions: [
        VariableDefinitionNode(
          variable: VariableNode(name: NameNode(value: 'userId')),
          type: NamedTypeNode(name: NameNode(value: 'ID'), isNonNull: true),
          defaultValue: DefaultValueNode(value: null),
          directives: [],
        ),
        VariableDefinitionNode(
          variable: VariableNode(name: NameNode(value: 'libraryId')),
          type: NamedTypeNode(name: NameNode(value: 'ID'), isNonNull: true),
          defaultValue: DefaultValueNode(value: null),
          directives: [],
        ),
        VariableDefinitionNode(
          variable: VariableNode(name: NameNode(value: 'granted')),
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
            name: NameNode(value: 'setUserLibraryAccess'),
            alias: null,
            arguments: [
              ArgumentNode(
                name: NameNode(value: 'userId'),
                value: VariableNode(name: NameNode(value: 'userId')),
              ),
              ArgumentNode(
                name: NameNode(value: 'libraryId'),
                value: VariableNode(name: NameNode(value: 'libraryId')),
              ),
              ArgumentNode(
                name: NameNode(value: 'granted'),
                value: VariableNode(name: NameNode(value: 'granted')),
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

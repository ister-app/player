import 'package:gql/ast.dart';

class Variables$Mutation$refreshPerson {
  factory Variables$Mutation$refreshPerson({required String personId}) =>
      Variables$Mutation$refreshPerson._({r'personId': personId});

  Variables$Mutation$refreshPerson._(this._$data);

  factory Variables$Mutation$refreshPerson.fromJson(Map<String, dynamic> data) {
    final result$data = <String, dynamic>{};
    final l$personId = data['personId'];
    result$data['personId'] = (l$personId as String);
    return Variables$Mutation$refreshPerson._(result$data);
  }

  Map<String, dynamic> _$data;

  String get personId => (_$data['personId'] as String);

  Map<String, dynamic> toJson() {
    final result$data = <String, dynamic>{};
    final l$personId = personId;
    result$data['personId'] = l$personId;
    return result$data;
  }

  CopyWith$Variables$Mutation$refreshPerson<Variables$Mutation$refreshPerson>
  get copyWith => CopyWith$Variables$Mutation$refreshPerson(this, (i) => i);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Variables$Mutation$refreshPerson ||
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

abstract class CopyWith$Variables$Mutation$refreshPerson<TRes> {
  factory CopyWith$Variables$Mutation$refreshPerson(
    Variables$Mutation$refreshPerson instance,
    TRes Function(Variables$Mutation$refreshPerson) then,
  ) = _CopyWithImpl$Variables$Mutation$refreshPerson;

  factory CopyWith$Variables$Mutation$refreshPerson.stub(TRes res) =
      _CopyWithStubImpl$Variables$Mutation$refreshPerson;

  TRes call({String? personId});
}

class _CopyWithImpl$Variables$Mutation$refreshPerson<TRes>
    implements CopyWith$Variables$Mutation$refreshPerson<TRes> {
  _CopyWithImpl$Variables$Mutation$refreshPerson(this._instance, this._then);

  final Variables$Mutation$refreshPerson _instance;

  final TRes Function(Variables$Mutation$refreshPerson) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({Object? personId = _undefined}) => _then(
    Variables$Mutation$refreshPerson._({
      ..._instance._$data,
      if (personId != _undefined && personId != null)
        'personId': (personId as String),
    }),
  );
}

class _CopyWithStubImpl$Variables$Mutation$refreshPerson<TRes>
    implements CopyWith$Variables$Mutation$refreshPerson<TRes> {
  _CopyWithStubImpl$Variables$Mutation$refreshPerson(this._res);

  TRes _res;

  call({String? personId}) => _res;
}

class Mutation$refreshPerson {
  Mutation$refreshPerson({
    required this.refreshPerson,
    this.$__typename = 'Mutation',
  });

  factory Mutation$refreshPerson.fromJson(Map<String, dynamic> json) {
    final l$refreshPerson = json['refreshPerson'];
    final l$$__typename = json['__typename'];
    return Mutation$refreshPerson(
      refreshPerson: (l$refreshPerson as bool),
      $__typename: (l$$__typename as String),
    );
  }

  final bool refreshPerson;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$refreshPerson = refreshPerson;
    _resultData['refreshPerson'] = l$refreshPerson;
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$refreshPerson = refreshPerson;
    final l$$__typename = $__typename;
    return Object.hashAll([l$refreshPerson, l$$__typename]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Mutation$refreshPerson || runtimeType != other.runtimeType) {
      return false;
    }
    final l$refreshPerson = refreshPerson;
    final lOther$refreshPerson = other.refreshPerson;
    if (l$refreshPerson != lOther$refreshPerson) {
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

extension UtilityExtension$Mutation$refreshPerson on Mutation$refreshPerson {
  CopyWith$Mutation$refreshPerson<Mutation$refreshPerson> get copyWith =>
      CopyWith$Mutation$refreshPerson(this, (i) => i);
}

abstract class CopyWith$Mutation$refreshPerson<TRes> {
  factory CopyWith$Mutation$refreshPerson(
    Mutation$refreshPerson instance,
    TRes Function(Mutation$refreshPerson) then,
  ) = _CopyWithImpl$Mutation$refreshPerson;

  factory CopyWith$Mutation$refreshPerson.stub(TRes res) =
      _CopyWithStubImpl$Mutation$refreshPerson;

  TRes call({bool? refreshPerson, String? $__typename});
}

class _CopyWithImpl$Mutation$refreshPerson<TRes>
    implements CopyWith$Mutation$refreshPerson<TRes> {
  _CopyWithImpl$Mutation$refreshPerson(this._instance, this._then);

  final Mutation$refreshPerson _instance;

  final TRes Function(Mutation$refreshPerson) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? refreshPerson = _undefined,
    Object? $__typename = _undefined,
  }) => _then(
    Mutation$refreshPerson(
      refreshPerson: refreshPerson == _undefined || refreshPerson == null
          ? _instance.refreshPerson
          : (refreshPerson as bool),
      $__typename: $__typename == _undefined || $__typename == null
          ? _instance.$__typename
          : ($__typename as String),
    ),
  );
}

class _CopyWithStubImpl$Mutation$refreshPerson<TRes>
    implements CopyWith$Mutation$refreshPerson<TRes> {
  _CopyWithStubImpl$Mutation$refreshPerson(this._res);

  TRes _res;

  call({bool? refreshPerson, String? $__typename}) => _res;
}

const documentNodeMutationrefreshPerson = DocumentNode(
  definitions: [
    OperationDefinitionNode(
      type: OperationType.mutation,
      name: NameNode(value: 'refreshPerson'),
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
            name: NameNode(value: 'refreshPerson'),
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

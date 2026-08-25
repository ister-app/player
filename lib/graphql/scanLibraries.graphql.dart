import 'package:gql/ast.dart';

class Variables$Mutation$scanLibraries {
  factory Variables$Mutation$scanLibraries({String? libraryId}) =>
      Variables$Mutation$scanLibraries._({
        if (libraryId != null) r'libraryId': libraryId,
      });

  Variables$Mutation$scanLibraries._(this._$data);

  factory Variables$Mutation$scanLibraries.fromJson(Map<String, dynamic> data) {
    final result$data = <String, dynamic>{};
    if (data.containsKey('libraryId')) {
      final l$libraryId = data['libraryId'];
      result$data['libraryId'] = (l$libraryId as String?);
    }
    return Variables$Mutation$scanLibraries._(result$data);
  }

  Map<String, dynamic> _$data;

  String? get libraryId => (_$data['libraryId'] as String?);

  Map<String, dynamic> toJson() {
    final result$data = <String, dynamic>{};
    if (_$data.containsKey('libraryId')) {
      final l$libraryId = libraryId;
      result$data['libraryId'] = l$libraryId;
    }
    return result$data;
  }

  CopyWith$Variables$Mutation$scanLibraries<Variables$Mutation$scanLibraries>
  get copyWith => CopyWith$Variables$Mutation$scanLibraries(this, (i) => i);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Variables$Mutation$scanLibraries ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$libraryId = libraryId;
    final lOther$libraryId = other.libraryId;
    if (_$data.containsKey('libraryId') !=
        other._$data.containsKey('libraryId')) {
      return false;
    }
    if (l$libraryId != lOther$libraryId) {
      return false;
    }
    return true;
  }

  @override
  int get hashCode {
    final l$libraryId = libraryId;
    return Object.hashAll([
      _$data.containsKey('libraryId') ? l$libraryId : const {},
    ]);
  }
}

abstract class CopyWith$Variables$Mutation$scanLibraries<TRes> {
  factory CopyWith$Variables$Mutation$scanLibraries(
    Variables$Mutation$scanLibraries instance,
    TRes Function(Variables$Mutation$scanLibraries) then,
  ) = _CopyWithImpl$Variables$Mutation$scanLibraries;

  factory CopyWith$Variables$Mutation$scanLibraries.stub(TRes res) =
      _CopyWithStubImpl$Variables$Mutation$scanLibraries;

  TRes call({String? libraryId});
}

class _CopyWithImpl$Variables$Mutation$scanLibraries<TRes>
    implements CopyWith$Variables$Mutation$scanLibraries<TRes> {
  _CopyWithImpl$Variables$Mutation$scanLibraries(this._instance, this._then);

  final Variables$Mutation$scanLibraries _instance;

  final TRes Function(Variables$Mutation$scanLibraries) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({Object? libraryId = _undefined}) => _then(
    Variables$Mutation$scanLibraries._({
      ..._instance._$data,
      if (libraryId != _undefined) 'libraryId': (libraryId as String?),
    }),
  );
}

class _CopyWithStubImpl$Variables$Mutation$scanLibraries<TRes>
    implements CopyWith$Variables$Mutation$scanLibraries<TRes> {
  _CopyWithStubImpl$Variables$Mutation$scanLibraries(this._res);

  TRes _res;

  call({String? libraryId}) => _res;
}

class Mutation$scanLibraries {
  Mutation$scanLibraries({
    required this.scanLibraries,
    this.$__typename = 'Mutation',
  });

  factory Mutation$scanLibraries.fromJson(Map<String, dynamic> json) {
    final l$scanLibraries = json['scanLibraries'];
    final l$$__typename = json['__typename'];
    return Mutation$scanLibraries(
      scanLibraries: (l$scanLibraries as bool),
      $__typename: (l$$__typename as String),
    );
  }

  final bool scanLibraries;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$scanLibraries = scanLibraries;
    _resultData['scanLibraries'] = l$scanLibraries;
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$scanLibraries = scanLibraries;
    final l$$__typename = $__typename;
    return Object.hashAll([l$scanLibraries, l$$__typename]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Mutation$scanLibraries || runtimeType != other.runtimeType) {
      return false;
    }
    final l$scanLibraries = scanLibraries;
    final lOther$scanLibraries = other.scanLibraries;
    if (l$scanLibraries != lOther$scanLibraries) {
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

extension UtilityExtension$Mutation$scanLibraries on Mutation$scanLibraries {
  CopyWith$Mutation$scanLibraries<Mutation$scanLibraries> get copyWith =>
      CopyWith$Mutation$scanLibraries(this, (i) => i);
}

abstract class CopyWith$Mutation$scanLibraries<TRes> {
  factory CopyWith$Mutation$scanLibraries(
    Mutation$scanLibraries instance,
    TRes Function(Mutation$scanLibraries) then,
  ) = _CopyWithImpl$Mutation$scanLibraries;

  factory CopyWith$Mutation$scanLibraries.stub(TRes res) =
      _CopyWithStubImpl$Mutation$scanLibraries;

  TRes call({bool? scanLibraries, String? $__typename});
}

class _CopyWithImpl$Mutation$scanLibraries<TRes>
    implements CopyWith$Mutation$scanLibraries<TRes> {
  _CopyWithImpl$Mutation$scanLibraries(this._instance, this._then);

  final Mutation$scanLibraries _instance;

  final TRes Function(Mutation$scanLibraries) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? scanLibraries = _undefined,
    Object? $__typename = _undefined,
  }) => _then(
    Mutation$scanLibraries(
      scanLibraries: scanLibraries == _undefined || scanLibraries == null
          ? _instance.scanLibraries
          : (scanLibraries as bool),
      $__typename: $__typename == _undefined || $__typename == null
          ? _instance.$__typename
          : ($__typename as String),
    ),
  );
}

class _CopyWithStubImpl$Mutation$scanLibraries<TRes>
    implements CopyWith$Mutation$scanLibraries<TRes> {
  _CopyWithStubImpl$Mutation$scanLibraries(this._res);

  TRes _res;

  call({bool? scanLibraries, String? $__typename}) => _res;
}

const documentNodeMutationscanLibraries = DocumentNode(
  definitions: [
    OperationDefinitionNode(
      type: OperationType.mutation,
      name: NameNode(value: 'scanLibraries'),
      variableDefinitions: [
        VariableDefinitionNode(
          variable: VariableNode(name: NameNode(value: 'libraryId')),
          type: NamedTypeNode(name: NameNode(value: 'ID'), isNonNull: false),
          defaultValue: DefaultValueNode(value: null),
          directives: [],
        ),
      ],
      directives: [],
      selectionSet: SelectionSetNode(
        selections: [
          FieldNode(
            name: NameNode(value: 'scanLibraries'),
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

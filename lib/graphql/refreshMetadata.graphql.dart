import 'package:gql/ast.dart';

import 'schema.graphql.dart';

class Variables$Mutation$refreshMetadata {
  factory Variables$Mutation$refreshMetadata({
    required Enum$MetadataRefreshMode mode,
    String? libraryId,
  }) => Variables$Mutation$refreshMetadata._({
    r'mode': mode,
    if (libraryId != null) r'libraryId': libraryId,
  });

  Variables$Mutation$refreshMetadata._(this._$data);

  factory Variables$Mutation$refreshMetadata.fromJson(
    Map<String, dynamic> data,
  ) {
    final result$data = <String, dynamic>{};
    final l$mode = data['mode'];
    result$data['mode'] = fromJson$Enum$MetadataRefreshMode((l$mode as String));
    if (data.containsKey('libraryId')) {
      final l$libraryId = data['libraryId'];
      result$data['libraryId'] = (l$libraryId as String?);
    }
    return Variables$Mutation$refreshMetadata._(result$data);
  }

  Map<String, dynamic> _$data;

  Enum$MetadataRefreshMode get mode =>
      (_$data['mode'] as Enum$MetadataRefreshMode);

  String? get libraryId => (_$data['libraryId'] as String?);

  Map<String, dynamic> toJson() {
    final result$data = <String, dynamic>{};
    final l$mode = mode;
    result$data['mode'] = toJson$Enum$MetadataRefreshMode(l$mode);
    if (_$data.containsKey('libraryId')) {
      final l$libraryId = libraryId;
      result$data['libraryId'] = l$libraryId;
    }
    return result$data;
  }

  CopyWith$Variables$Mutation$refreshMetadata<
    Variables$Mutation$refreshMetadata
  >
  get copyWith => CopyWith$Variables$Mutation$refreshMetadata(this, (i) => i);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Variables$Mutation$refreshMetadata ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$mode = mode;
    final lOther$mode = other.mode;
    if (l$mode != lOther$mode) {
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
    final l$mode = mode;
    final l$libraryId = libraryId;
    return Object.hashAll([
      l$mode,
      _$data.containsKey('libraryId') ? l$libraryId : const {},
    ]);
  }
}

abstract class CopyWith$Variables$Mutation$refreshMetadata<TRes> {
  factory CopyWith$Variables$Mutation$refreshMetadata(
    Variables$Mutation$refreshMetadata instance,
    TRes Function(Variables$Mutation$refreshMetadata) then,
  ) = _CopyWithImpl$Variables$Mutation$refreshMetadata;

  factory CopyWith$Variables$Mutation$refreshMetadata.stub(TRes res) =
      _CopyWithStubImpl$Variables$Mutation$refreshMetadata;

  TRes call({Enum$MetadataRefreshMode? mode, String? libraryId});
}

class _CopyWithImpl$Variables$Mutation$refreshMetadata<TRes>
    implements CopyWith$Variables$Mutation$refreshMetadata<TRes> {
  _CopyWithImpl$Variables$Mutation$refreshMetadata(this._instance, this._then);

  final Variables$Mutation$refreshMetadata _instance;

  final TRes Function(Variables$Mutation$refreshMetadata) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({Object? mode = _undefined, Object? libraryId = _undefined}) =>
      _then(
        Variables$Mutation$refreshMetadata._({
          ..._instance._$data,
          if (mode != _undefined && mode != null)
            'mode': (mode as Enum$MetadataRefreshMode),
          if (libraryId != _undefined) 'libraryId': (libraryId as String?),
        }),
      );
}

class _CopyWithStubImpl$Variables$Mutation$refreshMetadata<TRes>
    implements CopyWith$Variables$Mutation$refreshMetadata<TRes> {
  _CopyWithStubImpl$Variables$Mutation$refreshMetadata(this._res);

  TRes _res;

  call({Enum$MetadataRefreshMode? mode, String? libraryId}) => _res;
}

class Mutation$refreshMetadata {
  Mutation$refreshMetadata({
    required this.refreshMetadata,
    this.$__typename = 'Mutation',
  });

  factory Mutation$refreshMetadata.fromJson(Map<String, dynamic> json) {
    final l$refreshMetadata = json['refreshMetadata'];
    final l$$__typename = json['__typename'];
    return Mutation$refreshMetadata(
      refreshMetadata: (l$refreshMetadata as bool),
      $__typename: (l$$__typename as String),
    );
  }

  final bool refreshMetadata;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$refreshMetadata = refreshMetadata;
    _resultData['refreshMetadata'] = l$refreshMetadata;
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$refreshMetadata = refreshMetadata;
    final l$$__typename = $__typename;
    return Object.hashAll([l$refreshMetadata, l$$__typename]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Mutation$refreshMetadata ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$refreshMetadata = refreshMetadata;
    final lOther$refreshMetadata = other.refreshMetadata;
    if (l$refreshMetadata != lOther$refreshMetadata) {
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

extension UtilityExtension$Mutation$refreshMetadata
    on Mutation$refreshMetadata {
  CopyWith$Mutation$refreshMetadata<Mutation$refreshMetadata> get copyWith =>
      CopyWith$Mutation$refreshMetadata(this, (i) => i);
}

abstract class CopyWith$Mutation$refreshMetadata<TRes> {
  factory CopyWith$Mutation$refreshMetadata(
    Mutation$refreshMetadata instance,
    TRes Function(Mutation$refreshMetadata) then,
  ) = _CopyWithImpl$Mutation$refreshMetadata;

  factory CopyWith$Mutation$refreshMetadata.stub(TRes res) =
      _CopyWithStubImpl$Mutation$refreshMetadata;

  TRes call({bool? refreshMetadata, String? $__typename});
}

class _CopyWithImpl$Mutation$refreshMetadata<TRes>
    implements CopyWith$Mutation$refreshMetadata<TRes> {
  _CopyWithImpl$Mutation$refreshMetadata(this._instance, this._then);

  final Mutation$refreshMetadata _instance;

  final TRes Function(Mutation$refreshMetadata) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? refreshMetadata = _undefined,
    Object? $__typename = _undefined,
  }) => _then(
    Mutation$refreshMetadata(
      refreshMetadata: refreshMetadata == _undefined || refreshMetadata == null
          ? _instance.refreshMetadata
          : (refreshMetadata as bool),
      $__typename: $__typename == _undefined || $__typename == null
          ? _instance.$__typename
          : ($__typename as String),
    ),
  );
}

class _CopyWithStubImpl$Mutation$refreshMetadata<TRes>
    implements CopyWith$Mutation$refreshMetadata<TRes> {
  _CopyWithStubImpl$Mutation$refreshMetadata(this._res);

  TRes _res;

  call({bool? refreshMetadata, String? $__typename}) => _res;
}

const documentNodeMutationrefreshMetadata = DocumentNode(
  definitions: [
    OperationDefinitionNode(
      type: OperationType.mutation,
      name: NameNode(value: 'refreshMetadata'),
      variableDefinitions: [
        VariableDefinitionNode(
          variable: VariableNode(name: NameNode(value: 'mode')),
          type: NamedTypeNode(
            name: NameNode(value: 'MetadataRefreshMode'),
            isNonNull: true,
          ),
          defaultValue: DefaultValueNode(value: null),
          directives: [],
        ),
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
            name: NameNode(value: 'refreshMetadata'),
            alias: null,
            arguments: [
              ArgumentNode(
                name: NameNode(value: 'mode'),
                value: VariableNode(name: NameNode(value: 'mode')),
              ),
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

import 'package:gql/ast.dart';

class Variables$Mutation$analyzeDataForAlbumMutation {
  factory Variables$Mutation$analyzeDataForAlbumMutation({
    required String albumId,
  }) => Variables$Mutation$analyzeDataForAlbumMutation._({r'albumId': albumId});

  Variables$Mutation$analyzeDataForAlbumMutation._(this._$data);

  factory Variables$Mutation$analyzeDataForAlbumMutation.fromJson(
    Map<String, dynamic> data,
  ) {
    final result$data = <String, dynamic>{};
    final l$albumId = data['albumId'];
    result$data['albumId'] = (l$albumId as String);
    return Variables$Mutation$analyzeDataForAlbumMutation._(result$data);
  }

  Map<String, dynamic> _$data;

  String get albumId => (_$data['albumId'] as String);

  Map<String, dynamic> toJson() {
    final result$data = <String, dynamic>{};
    final l$albumId = albumId;
    result$data['albumId'] = l$albumId;
    return result$data;
  }

  CopyWith$Variables$Mutation$analyzeDataForAlbumMutation<
    Variables$Mutation$analyzeDataForAlbumMutation
  >
  get copyWith =>
      CopyWith$Variables$Mutation$analyzeDataForAlbumMutation(this, (i) => i);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Variables$Mutation$analyzeDataForAlbumMutation ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$albumId = albumId;
    final lOther$albumId = other.albumId;
    if (l$albumId != lOther$albumId) {
      return false;
    }
    return true;
  }

  @override
  int get hashCode {
    final l$albumId = albumId;
    return Object.hashAll([l$albumId]);
  }
}

abstract class CopyWith$Variables$Mutation$analyzeDataForAlbumMutation<TRes> {
  factory CopyWith$Variables$Mutation$analyzeDataForAlbumMutation(
    Variables$Mutation$analyzeDataForAlbumMutation instance,
    TRes Function(Variables$Mutation$analyzeDataForAlbumMutation) then,
  ) = _CopyWithImpl$Variables$Mutation$analyzeDataForAlbumMutation;

  factory CopyWith$Variables$Mutation$analyzeDataForAlbumMutation.stub(
    TRes res,
  ) = _CopyWithStubImpl$Variables$Mutation$analyzeDataForAlbumMutation;

  TRes call({String? albumId});
}

class _CopyWithImpl$Variables$Mutation$analyzeDataForAlbumMutation<TRes>
    implements CopyWith$Variables$Mutation$analyzeDataForAlbumMutation<TRes> {
  _CopyWithImpl$Variables$Mutation$analyzeDataForAlbumMutation(
    this._instance,
    this._then,
  );

  final Variables$Mutation$analyzeDataForAlbumMutation _instance;

  final TRes Function(Variables$Mutation$analyzeDataForAlbumMutation) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({Object? albumId = _undefined}) => _then(
    Variables$Mutation$analyzeDataForAlbumMutation._({
      ..._instance._$data,
      if (albumId != _undefined && albumId != null)
        'albumId': (albumId as String),
    }),
  );
}

class _CopyWithStubImpl$Variables$Mutation$analyzeDataForAlbumMutation<TRes>
    implements CopyWith$Variables$Mutation$analyzeDataForAlbumMutation<TRes> {
  _CopyWithStubImpl$Variables$Mutation$analyzeDataForAlbumMutation(this._res);

  TRes _res;

  call({String? albumId}) => _res;
}

class Mutation$analyzeDataForAlbumMutation {
  Mutation$analyzeDataForAlbumMutation({
    required this.analyzeDataForAlbum,
    this.$__typename = 'Mutation',
  });

  factory Mutation$analyzeDataForAlbumMutation.fromJson(
    Map<String, dynamic> json,
  ) {
    final l$analyzeDataForAlbum = json['analyzeDataForAlbum'];
    final l$$__typename = json['__typename'];
    return Mutation$analyzeDataForAlbumMutation(
      analyzeDataForAlbum: (l$analyzeDataForAlbum as bool),
      $__typename: (l$$__typename as String),
    );
  }

  final bool analyzeDataForAlbum;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$analyzeDataForAlbum = analyzeDataForAlbum;
    _resultData['analyzeDataForAlbum'] = l$analyzeDataForAlbum;
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$analyzeDataForAlbum = analyzeDataForAlbum;
    final l$$__typename = $__typename;
    return Object.hashAll([l$analyzeDataForAlbum, l$$__typename]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Mutation$analyzeDataForAlbumMutation ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$analyzeDataForAlbum = analyzeDataForAlbum;
    final lOther$analyzeDataForAlbum = other.analyzeDataForAlbum;
    if (l$analyzeDataForAlbum != lOther$analyzeDataForAlbum) {
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

extension UtilityExtension$Mutation$analyzeDataForAlbumMutation
    on Mutation$analyzeDataForAlbumMutation {
  CopyWith$Mutation$analyzeDataForAlbumMutation<
    Mutation$analyzeDataForAlbumMutation
  >
  get copyWith => CopyWith$Mutation$analyzeDataForAlbumMutation(this, (i) => i);
}

abstract class CopyWith$Mutation$analyzeDataForAlbumMutation<TRes> {
  factory CopyWith$Mutation$analyzeDataForAlbumMutation(
    Mutation$analyzeDataForAlbumMutation instance,
    TRes Function(Mutation$analyzeDataForAlbumMutation) then,
  ) = _CopyWithImpl$Mutation$analyzeDataForAlbumMutation;

  factory CopyWith$Mutation$analyzeDataForAlbumMutation.stub(TRes res) =
      _CopyWithStubImpl$Mutation$analyzeDataForAlbumMutation;

  TRes call({bool? analyzeDataForAlbum, String? $__typename});
}

class _CopyWithImpl$Mutation$analyzeDataForAlbumMutation<TRes>
    implements CopyWith$Mutation$analyzeDataForAlbumMutation<TRes> {
  _CopyWithImpl$Mutation$analyzeDataForAlbumMutation(
    this._instance,
    this._then,
  );

  final Mutation$analyzeDataForAlbumMutation _instance;

  final TRes Function(Mutation$analyzeDataForAlbumMutation) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? analyzeDataForAlbum = _undefined,
    Object? $__typename = _undefined,
  }) => _then(
    Mutation$analyzeDataForAlbumMutation(
      analyzeDataForAlbum:
          analyzeDataForAlbum == _undefined || analyzeDataForAlbum == null
          ? _instance.analyzeDataForAlbum
          : (analyzeDataForAlbum as bool),
      $__typename: $__typename == _undefined || $__typename == null
          ? _instance.$__typename
          : ($__typename as String),
    ),
  );
}

class _CopyWithStubImpl$Mutation$analyzeDataForAlbumMutation<TRes>
    implements CopyWith$Mutation$analyzeDataForAlbumMutation<TRes> {
  _CopyWithStubImpl$Mutation$analyzeDataForAlbumMutation(this._res);

  TRes _res;

  call({bool? analyzeDataForAlbum, String? $__typename}) => _res;
}

const documentNodeMutationanalyzeDataForAlbumMutation = DocumentNode(
  definitions: [
    OperationDefinitionNode(
      type: OperationType.mutation,
      name: NameNode(value: 'analyzeDataForAlbumMutation'),
      variableDefinitions: [
        VariableDefinitionNode(
          variable: VariableNode(name: NameNode(value: 'albumId')),
          type: NamedTypeNode(name: NameNode(value: 'ID'), isNonNull: true),
          defaultValue: DefaultValueNode(value: null),
          directives: [],
        ),
      ],
      directives: [],
      selectionSet: SelectionSetNode(
        selections: [
          FieldNode(
            name: NameNode(value: 'analyzeDataForAlbum'),
            alias: null,
            arguments: [
              ArgumentNode(
                name: NameNode(value: 'albumId'),
                value: VariableNode(name: NameNode(value: 'albumId')),
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

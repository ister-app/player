import 'package:gql/ast.dart';

class Variables$Mutation$refreshAlbum {
  factory Variables$Mutation$refreshAlbum({required String albumId}) =>
      Variables$Mutation$refreshAlbum._({r'albumId': albumId});

  Variables$Mutation$refreshAlbum._(this._$data);

  factory Variables$Mutation$refreshAlbum.fromJson(Map<String, dynamic> data) {
    final result$data = <String, dynamic>{};
    final l$albumId = data['albumId'];
    result$data['albumId'] = (l$albumId as String);
    return Variables$Mutation$refreshAlbum._(result$data);
  }

  Map<String, dynamic> _$data;

  String get albumId => (_$data['albumId'] as String);

  Map<String, dynamic> toJson() {
    final result$data = <String, dynamic>{};
    final l$albumId = albumId;
    result$data['albumId'] = l$albumId;
    return result$data;
  }

  CopyWith$Variables$Mutation$refreshAlbum<Variables$Mutation$refreshAlbum>
  get copyWith => CopyWith$Variables$Mutation$refreshAlbum(this, (i) => i);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Variables$Mutation$refreshAlbum ||
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

abstract class CopyWith$Variables$Mutation$refreshAlbum<TRes> {
  factory CopyWith$Variables$Mutation$refreshAlbum(
    Variables$Mutation$refreshAlbum instance,
    TRes Function(Variables$Mutation$refreshAlbum) then,
  ) = _CopyWithImpl$Variables$Mutation$refreshAlbum;

  factory CopyWith$Variables$Mutation$refreshAlbum.stub(TRes res) =
      _CopyWithStubImpl$Variables$Mutation$refreshAlbum;

  TRes call({String? albumId});
}

class _CopyWithImpl$Variables$Mutation$refreshAlbum<TRes>
    implements CopyWith$Variables$Mutation$refreshAlbum<TRes> {
  _CopyWithImpl$Variables$Mutation$refreshAlbum(this._instance, this._then);

  final Variables$Mutation$refreshAlbum _instance;

  final TRes Function(Variables$Mutation$refreshAlbum) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({Object? albumId = _undefined}) => _then(
    Variables$Mutation$refreshAlbum._({
      ..._instance._$data,
      if (albumId != _undefined && albumId != null)
        'albumId': (albumId as String),
    }),
  );
}

class _CopyWithStubImpl$Variables$Mutation$refreshAlbum<TRes>
    implements CopyWith$Variables$Mutation$refreshAlbum<TRes> {
  _CopyWithStubImpl$Variables$Mutation$refreshAlbum(this._res);

  TRes _res;

  call({String? albumId}) => _res;
}

class Mutation$refreshAlbum {
  Mutation$refreshAlbum({
    required this.refreshAlbum,
    this.$__typename = 'Mutation',
  });

  factory Mutation$refreshAlbum.fromJson(Map<String, dynamic> json) {
    final l$refreshAlbum = json['refreshAlbum'];
    final l$$__typename = json['__typename'];
    return Mutation$refreshAlbum(
      refreshAlbum: (l$refreshAlbum as bool),
      $__typename: (l$$__typename as String),
    );
  }

  final bool refreshAlbum;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$refreshAlbum = refreshAlbum;
    _resultData['refreshAlbum'] = l$refreshAlbum;
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$refreshAlbum = refreshAlbum;
    final l$$__typename = $__typename;
    return Object.hashAll([l$refreshAlbum, l$$__typename]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Mutation$refreshAlbum || runtimeType != other.runtimeType) {
      return false;
    }
    final l$refreshAlbum = refreshAlbum;
    final lOther$refreshAlbum = other.refreshAlbum;
    if (l$refreshAlbum != lOther$refreshAlbum) {
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

extension UtilityExtension$Mutation$refreshAlbum on Mutation$refreshAlbum {
  CopyWith$Mutation$refreshAlbum<Mutation$refreshAlbum> get copyWith =>
      CopyWith$Mutation$refreshAlbum(this, (i) => i);
}

abstract class CopyWith$Mutation$refreshAlbum<TRes> {
  factory CopyWith$Mutation$refreshAlbum(
    Mutation$refreshAlbum instance,
    TRes Function(Mutation$refreshAlbum) then,
  ) = _CopyWithImpl$Mutation$refreshAlbum;

  factory CopyWith$Mutation$refreshAlbum.stub(TRes res) =
      _CopyWithStubImpl$Mutation$refreshAlbum;

  TRes call({bool? refreshAlbum, String? $__typename});
}

class _CopyWithImpl$Mutation$refreshAlbum<TRes>
    implements CopyWith$Mutation$refreshAlbum<TRes> {
  _CopyWithImpl$Mutation$refreshAlbum(this._instance, this._then);

  final Mutation$refreshAlbum _instance;

  final TRes Function(Mutation$refreshAlbum) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? refreshAlbum = _undefined,
    Object? $__typename = _undefined,
  }) => _then(
    Mutation$refreshAlbum(
      refreshAlbum: refreshAlbum == _undefined || refreshAlbum == null
          ? _instance.refreshAlbum
          : (refreshAlbum as bool),
      $__typename: $__typename == _undefined || $__typename == null
          ? _instance.$__typename
          : ($__typename as String),
    ),
  );
}

class _CopyWithStubImpl$Mutation$refreshAlbum<TRes>
    implements CopyWith$Mutation$refreshAlbum<TRes> {
  _CopyWithStubImpl$Mutation$refreshAlbum(this._res);

  TRes _res;

  call({bool? refreshAlbum, String? $__typename}) => _res;
}

const documentNodeMutationrefreshAlbum = DocumentNode(
  definitions: [
    OperationDefinitionNode(
      type: OperationType.mutation,
      name: NameNode(value: 'refreshAlbum'),
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
            name: NameNode(value: 'refreshAlbum'),
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

import 'fragmentAlbum.graphql.dart';
import 'fragmentImages.graphql.dart';
import 'fragmentMetadata.graphql.dart';
import 'package:gql/ast.dart';

class Variables$Query$trackById {
  factory Variables$Query$trackById({String? id}) =>
      Variables$Query$trackById._({if (id != null) r'id': id});

  Variables$Query$trackById._(this._$data);

  factory Variables$Query$trackById.fromJson(Map<String, dynamic> data) {
    final result$data = <String, dynamic>{};
    if (data.containsKey('id')) {
      final l$id = data['id'];
      result$data['id'] = (l$id as String?);
    }
    return Variables$Query$trackById._(result$data);
  }

  Map<String, dynamic> _$data;

  String? get id => (_$data['id'] as String?);

  Map<String, dynamic> toJson() {
    final result$data = <String, dynamic>{};
    if (_$data.containsKey('id')) {
      final l$id = id;
      result$data['id'] = l$id;
    }
    return result$data;
  }

  CopyWith$Variables$Query$trackById<Variables$Query$trackById> get copyWith =>
      CopyWith$Variables$Query$trackById(this, (i) => i);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Variables$Query$trackById ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$id = id;
    final lOther$id = other.id;
    if (_$data.containsKey('id') != other._$data.containsKey('id')) {
      return false;
    }
    if (l$id != lOther$id) {
      return false;
    }
    return true;
  }

  @override
  int get hashCode {
    final l$id = id;
    return Object.hashAll([_$data.containsKey('id') ? l$id : const {}]);
  }
}

abstract class CopyWith$Variables$Query$trackById<TRes> {
  factory CopyWith$Variables$Query$trackById(
    Variables$Query$trackById instance,
    TRes Function(Variables$Query$trackById) then,
  ) = _CopyWithImpl$Variables$Query$trackById;

  factory CopyWith$Variables$Query$trackById.stub(TRes res) =
      _CopyWithStubImpl$Variables$Query$trackById;

  TRes call({String? id});
}

class _CopyWithImpl$Variables$Query$trackById<TRes>
    implements CopyWith$Variables$Query$trackById<TRes> {
  _CopyWithImpl$Variables$Query$trackById(this._instance, this._then);

  final Variables$Query$trackById _instance;

  final TRes Function(Variables$Query$trackById) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({Object? id = _undefined}) => _then(
    Variables$Query$trackById._({
      ..._instance._$data,
      if (id != _undefined) 'id': (id as String?),
    }),
  );
}

class _CopyWithStubImpl$Variables$Query$trackById<TRes>
    implements CopyWith$Variables$Query$trackById<TRes> {
  _CopyWithStubImpl$Variables$Query$trackById(this._res);

  TRes _res;

  call({String? id}) => _res;
}

class Query$trackById {
  Query$trackById({this.trackById, this.$__typename = 'Query'});

  factory Query$trackById.fromJson(Map<String, dynamic> json) {
    final l$trackById = json['trackById'];
    final l$$__typename = json['__typename'];
    return Query$trackById(
      trackById: l$trackById == null
          ? null
          : Query$trackById$trackById.fromJson(
              (l$trackById as Map<String, dynamic>),
            ),
      $__typename: (l$$__typename as String),
    );
  }

  final Query$trackById$trackById? trackById;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$trackById = trackById;
    _resultData['trackById'] = l$trackById?.toJson();
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$trackById = trackById;
    final l$$__typename = $__typename;
    return Object.hashAll([l$trackById, l$$__typename]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Query$trackById || runtimeType != other.runtimeType) {
      return false;
    }
    final l$trackById = trackById;
    final lOther$trackById = other.trackById;
    if (l$trackById != lOther$trackById) {
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

extension UtilityExtension$Query$trackById on Query$trackById {
  CopyWith$Query$trackById<Query$trackById> get copyWith =>
      CopyWith$Query$trackById(this, (i) => i);
}

abstract class CopyWith$Query$trackById<TRes> {
  factory CopyWith$Query$trackById(
    Query$trackById instance,
    TRes Function(Query$trackById) then,
  ) = _CopyWithImpl$Query$trackById;

  factory CopyWith$Query$trackById.stub(TRes res) =
      _CopyWithStubImpl$Query$trackById;

  TRes call({Query$trackById$trackById? trackById, String? $__typename});
  CopyWith$Query$trackById$trackById<TRes> get trackById;
}

class _CopyWithImpl$Query$trackById<TRes>
    implements CopyWith$Query$trackById<TRes> {
  _CopyWithImpl$Query$trackById(this._instance, this._then);

  final Query$trackById _instance;

  final TRes Function(Query$trackById) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? trackById = _undefined,
    Object? $__typename = _undefined,
  }) => _then(
    Query$trackById(
      trackById: trackById == _undefined
          ? _instance.trackById
          : (trackById as Query$trackById$trackById?),
      $__typename: $__typename == _undefined || $__typename == null
          ? _instance.$__typename
          : ($__typename as String),
    ),
  );

  CopyWith$Query$trackById$trackById<TRes> get trackById {
    final local$trackById = _instance.trackById;
    return local$trackById == null
        ? CopyWith$Query$trackById$trackById.stub(_then(_instance))
        : CopyWith$Query$trackById$trackById(
            local$trackById,
            (e) => call(trackById: e),
          );
  }
}

class _CopyWithStubImpl$Query$trackById<TRes>
    implements CopyWith$Query$trackById<TRes> {
  _CopyWithStubImpl$Query$trackById(this._res);

  TRes _res;

  call({Query$trackById$trackById? trackById, String? $__typename}) => _res;

  CopyWith$Query$trackById$trackById<TRes> get trackById =>
      CopyWith$Query$trackById$trackById.stub(_res);
}

const documentNodeQuerytrackById = DocumentNode(
  definitions: [
    OperationDefinitionNode(
      type: OperationType.query,
      name: NameNode(value: 'trackById'),
      variableDefinitions: [
        VariableDefinitionNode(
          variable: VariableNode(name: NameNode(value: 'id')),
          type: NamedTypeNode(name: NameNode(value: 'ID'), isNonNull: false),
          defaultValue: DefaultValueNode(value: null),
          directives: [],
        ),
      ],
      directives: [],
      selectionSet: SelectionSetNode(
        selections: [
          FieldNode(
            name: NameNode(value: 'trackById'),
            alias: null,
            arguments: [
              ArgumentNode(
                name: NameNode(value: 'id'),
                value: VariableNode(name: NameNode(value: 'id')),
              ),
            ],
            directives: [],
            selectionSet: SelectionSetNode(
              selections: [
                FieldNode(
                  name: NameNode(value: 'id'),
                  alias: null,
                  arguments: [],
                  directives: [],
                  selectionSet: null,
                ),
                FieldNode(
                  name: NameNode(value: 'album'),
                  alias: null,
                  arguments: [],
                  directives: [],
                  selectionSet: SelectionSetNode(
                    selections: [
                      FragmentSpreadNode(
                        name: NameNode(value: 'fragmentAlbum'),
                        directives: [],
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
    fragmentDefinitionfragmentAlbum,
    fragmentDefinitionfragmentImages,
    fragmentDefinitionfragmentMetadata,
  ],
);

class Query$trackById$trackById {
  Query$trackById$trackById({
    required this.id,
    required this.album,
    this.$__typename = 'Track',
  });

  factory Query$trackById$trackById.fromJson(Map<String, dynamic> json) {
    final l$id = json['id'];
    final l$album = json['album'];
    final l$$__typename = json['__typename'];
    return Query$trackById$trackById(
      id: (l$id as String),
      album: Fragment$fragmentAlbum.fromJson((l$album as Map<String, dynamic>)),
      $__typename: (l$$__typename as String),
    );
  }

  final String id;

  final Fragment$fragmentAlbum album;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$id = id;
    _resultData['id'] = l$id;
    final l$album = album;
    _resultData['album'] = l$album.toJson();
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$id = id;
    final l$album = album;
    final l$$__typename = $__typename;
    return Object.hashAll([l$id, l$album, l$$__typename]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Query$trackById$trackById ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$id = id;
    final lOther$id = other.id;
    if (l$id != lOther$id) {
      return false;
    }
    final l$album = album;
    final lOther$album = other.album;
    if (l$album != lOther$album) {
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

extension UtilityExtension$Query$trackById$trackById
    on Query$trackById$trackById {
  CopyWith$Query$trackById$trackById<Query$trackById$trackById> get copyWith =>
      CopyWith$Query$trackById$trackById(this, (i) => i);
}

abstract class CopyWith$Query$trackById$trackById<TRes> {
  factory CopyWith$Query$trackById$trackById(
    Query$trackById$trackById instance,
    TRes Function(Query$trackById$trackById) then,
  ) = _CopyWithImpl$Query$trackById$trackById;

  factory CopyWith$Query$trackById$trackById.stub(TRes res) =
      _CopyWithStubImpl$Query$trackById$trackById;

  TRes call({String? id, Fragment$fragmentAlbum? album, String? $__typename});
  CopyWith$Fragment$fragmentAlbum<TRes> get album;
}

class _CopyWithImpl$Query$trackById$trackById<TRes>
    implements CopyWith$Query$trackById$trackById<TRes> {
  _CopyWithImpl$Query$trackById$trackById(this._instance, this._then);

  final Query$trackById$trackById _instance;

  final TRes Function(Query$trackById$trackById) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? id = _undefined,
    Object? album = _undefined,
    Object? $__typename = _undefined,
  }) => _then(
    Query$trackById$trackById(
      id: id == _undefined || id == null ? _instance.id : (id as String),
      album: album == _undefined || album == null
          ? _instance.album
          : (album as Fragment$fragmentAlbum),
      $__typename: $__typename == _undefined || $__typename == null
          ? _instance.$__typename
          : ($__typename as String),
    ),
  );

  CopyWith$Fragment$fragmentAlbum<TRes> get album {
    final local$album = _instance.album;
    return CopyWith$Fragment$fragmentAlbum(local$album, (e) => call(album: e));
  }
}

class _CopyWithStubImpl$Query$trackById$trackById<TRes>
    implements CopyWith$Query$trackById$trackById<TRes> {
  _CopyWithStubImpl$Query$trackById$trackById(this._res);

  TRes _res;

  call({String? id, Fragment$fragmentAlbum? album, String? $__typename}) =>
      _res;

  CopyWith$Fragment$fragmentAlbum<TRes> get album =>
      CopyWith$Fragment$fragmentAlbum.stub(_res);
}

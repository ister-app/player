import 'fragmentAlbum.graphql.dart';
import 'fragmentImages.graphql.dart';
import 'fragmentMetadata.graphql.dart';

import 'package:gql/ast.dart';

class Variables$Query$appearsOnAlbums {
  factory Variables$Query$appearsOnAlbums({String? id}) =>
      Variables$Query$appearsOnAlbums._({if (id != null) r'id': id});

  Variables$Query$appearsOnAlbums._(this._$data);

  factory Variables$Query$appearsOnAlbums.fromJson(Map<String, dynamic> data) {
    final result$data = <String, dynamic>{};
    if (data.containsKey('id')) {
      final l$id = data['id'];
      result$data['id'] = (l$id as String?);
    }
    return Variables$Query$appearsOnAlbums._(result$data);
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

  CopyWith$Variables$Query$appearsOnAlbums<Variables$Query$appearsOnAlbums>
  get copyWith => CopyWith$Variables$Query$appearsOnAlbums(this, (i) => i);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Variables$Query$appearsOnAlbums ||
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

abstract class CopyWith$Variables$Query$appearsOnAlbums<TRes> {
  factory CopyWith$Variables$Query$appearsOnAlbums(
    Variables$Query$appearsOnAlbums instance,
    TRes Function(Variables$Query$appearsOnAlbums) then,
  ) = _CopyWithImpl$Variables$Query$appearsOnAlbums;

  factory CopyWith$Variables$Query$appearsOnAlbums.stub(TRes res) =
      _CopyWithStubImpl$Variables$Query$appearsOnAlbums;

  TRes call({String? id});
}

class _CopyWithImpl$Variables$Query$appearsOnAlbums<TRes>
    implements CopyWith$Variables$Query$appearsOnAlbums<TRes> {
  _CopyWithImpl$Variables$Query$appearsOnAlbums(this._instance, this._then);

  final Variables$Query$appearsOnAlbums _instance;

  final TRes Function(Variables$Query$appearsOnAlbums) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({Object? id = _undefined}) => _then(
    Variables$Query$appearsOnAlbums._({
      ..._instance._$data,
      if (id != _undefined) 'id': (id as String?),
    }),
  );
}

class _CopyWithStubImpl$Variables$Query$appearsOnAlbums<TRes>
    implements CopyWith$Variables$Query$appearsOnAlbums<TRes> {
  _CopyWithStubImpl$Variables$Query$appearsOnAlbums(this._res);

  TRes _res;

  call({String? id}) => _res;
}

class Query$appearsOnAlbums {
  Query$appearsOnAlbums({this.albums, this.$__typename = 'Query'});

  factory Query$appearsOnAlbums.fromJson(Map<String, dynamic> json) {
    final l$albums = json['albums'];
    final l$$__typename = json['__typename'];
    return Query$appearsOnAlbums(
      albums: l$albums == null
          ? null
          : Query$appearsOnAlbums$albums.fromJson(
              (l$albums as Map<String, dynamic>),
            ),
      $__typename: (l$$__typename as String),
    );
  }

  final Query$appearsOnAlbums$albums? albums;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$albums = albums;
    _resultData['albums'] = l$albums?.toJson();
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$albums = albums;
    final l$$__typename = $__typename;
    return Object.hashAll([l$albums, l$$__typename]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Query$appearsOnAlbums || runtimeType != other.runtimeType) {
      return false;
    }
    final l$albums = albums;
    final lOther$albums = other.albums;
    if (l$albums != lOther$albums) {
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

extension UtilityExtension$Query$appearsOnAlbums on Query$appearsOnAlbums {
  CopyWith$Query$appearsOnAlbums<Query$appearsOnAlbums> get copyWith =>
      CopyWith$Query$appearsOnAlbums(this, (i) => i);
}

abstract class CopyWith$Query$appearsOnAlbums<TRes> {
  factory CopyWith$Query$appearsOnAlbums(
    Query$appearsOnAlbums instance,
    TRes Function(Query$appearsOnAlbums) then,
  ) = _CopyWithImpl$Query$appearsOnAlbums;

  factory CopyWith$Query$appearsOnAlbums.stub(TRes res) =
      _CopyWithStubImpl$Query$appearsOnAlbums;

  TRes call({Query$appearsOnAlbums$albums? albums, String? $__typename});
  CopyWith$Query$appearsOnAlbums$albums<TRes> get albums;
}

class _CopyWithImpl$Query$appearsOnAlbums<TRes>
    implements CopyWith$Query$appearsOnAlbums<TRes> {
  _CopyWithImpl$Query$appearsOnAlbums(this._instance, this._then);

  final Query$appearsOnAlbums _instance;

  final TRes Function(Query$appearsOnAlbums) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({Object? albums = _undefined, Object? $__typename = _undefined}) =>
      _then(
        Query$appearsOnAlbums(
          albums: albums == _undefined
              ? _instance.albums
              : (albums as Query$appearsOnAlbums$albums?),
          $__typename: $__typename == _undefined || $__typename == null
              ? _instance.$__typename
              : ($__typename as String),
        ),
      );

  CopyWith$Query$appearsOnAlbums$albums<TRes> get albums {
    final local$albums = _instance.albums;
    return local$albums == null
        ? CopyWith$Query$appearsOnAlbums$albums.stub(_then(_instance))
        : CopyWith$Query$appearsOnAlbums$albums(
            local$albums,
            (e) => call(albums: e),
          );
  }
}

class _CopyWithStubImpl$Query$appearsOnAlbums<TRes>
    implements CopyWith$Query$appearsOnAlbums<TRes> {
  _CopyWithStubImpl$Query$appearsOnAlbums(this._res);

  TRes _res;

  call({Query$appearsOnAlbums$albums? albums, String? $__typename}) => _res;

  CopyWith$Query$appearsOnAlbums$albums<TRes> get albums =>
      CopyWith$Query$appearsOnAlbums$albums.stub(_res);
}

const documentNodeQueryappearsOnAlbums = DocumentNode(
  definitions: [
    OperationDefinitionNode(
      type: OperationType.query,
      name: NameNode(value: 'appearsOnAlbums'),
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
            name: NameNode(value: 'albums'),
            alias: null,
            arguments: [
              ArgumentNode(
                name: NameNode(value: 'appearsOnArtistId'),
                value: VariableNode(name: NameNode(value: 'id')),
              ),
              ArgumentNode(
                name: NameNode(value: 'sorting'),
                value: EnumValueNode(name: NameNode(value: 'DATE_CREATED')),
              ),
              ArgumentNode(
                name: NameNode(value: 'sortingOrder'),
                value: EnumValueNode(name: NameNode(value: 'DESCENDING')),
              ),
              ArgumentNode(
                name: NameNode(value: 'page'),
                value: IntValueNode(value: '0'),
              ),
              ArgumentNode(
                name: NameNode(value: 'size'),
                value: IntValueNode(value: '200'),
              ),
            ],
            directives: [],
            selectionSet: SelectionSetNode(
              selections: [
                FieldNode(
                  name: NameNode(value: 'content'),
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
                  name: NameNode(value: 'totalPages'),
                  alias: null,
                  arguments: [],
                  directives: [],
                  selectionSet: null,
                ),
                FieldNode(
                  name: NameNode(value: 'totalElements'),
                  alias: null,
                  arguments: [],
                  directives: [],
                  selectionSet: null,
                ),
                FieldNode(
                  name: NameNode(value: 'number'),
                  alias: null,
                  arguments: [],
                  directives: [],
                  selectionSet: null,
                ),
                FieldNode(
                  name: NameNode(value: 'size'),
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

class Query$appearsOnAlbums$albums {
  Query$appearsOnAlbums$albums({
    required this.content,
    required this.totalPages,
    required this.totalElements,
    required this.number,
    required this.size,
    this.$__typename = 'AlbumPage',
  });

  factory Query$appearsOnAlbums$albums.fromJson(Map<String, dynamic> json) {
    final l$content = json['content'];
    final l$totalPages = json['totalPages'];
    final l$totalElements = json['totalElements'];
    final l$number = json['number'];
    final l$size = json['size'];
    final l$$__typename = json['__typename'];
    return Query$appearsOnAlbums$albums(
      content: (l$content as List<dynamic>)
          .map(
            (e) => Fragment$fragmentAlbum.fromJson((e as Map<String, dynamic>)),
          )
          .toList(),
      totalPages: (l$totalPages as int),
      totalElements: (l$totalElements as int),
      number: (l$number as int),
      size: (l$size as int),
      $__typename: (l$$__typename as String),
    );
  }

  final List<Fragment$fragmentAlbum> content;

  final int totalPages;

  final int totalElements;

  final int number;

  final int size;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$content = content;
    _resultData['content'] = l$content.map((e) => e.toJson()).toList();
    final l$totalPages = totalPages;
    _resultData['totalPages'] = l$totalPages;
    final l$totalElements = totalElements;
    _resultData['totalElements'] = l$totalElements;
    final l$number = number;
    _resultData['number'] = l$number;
    final l$size = size;
    _resultData['size'] = l$size;
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$content = content;
    final l$totalPages = totalPages;
    final l$totalElements = totalElements;
    final l$number = number;
    final l$size = size;
    final l$$__typename = $__typename;
    return Object.hashAll([
      Object.hashAll(l$content.map((v) => v)),
      l$totalPages,
      l$totalElements,
      l$number,
      l$size,
      l$$__typename,
    ]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Query$appearsOnAlbums$albums ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$content = content;
    final lOther$content = other.content;
    if (l$content.length != lOther$content.length) {
      return false;
    }
    for (int i = 0; i < l$content.length; i++) {
      final l$content$entry = l$content[i];
      final lOther$content$entry = lOther$content[i];
      if (l$content$entry != lOther$content$entry) {
        return false;
      }
    }
    final l$totalPages = totalPages;
    final lOther$totalPages = other.totalPages;
    if (l$totalPages != lOther$totalPages) {
      return false;
    }
    final l$totalElements = totalElements;
    final lOther$totalElements = other.totalElements;
    if (l$totalElements != lOther$totalElements) {
      return false;
    }
    final l$number = number;
    final lOther$number = other.number;
    if (l$number != lOther$number) {
      return false;
    }
    final l$size = size;
    final lOther$size = other.size;
    if (l$size != lOther$size) {
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

extension UtilityExtension$Query$appearsOnAlbums$albums
    on Query$appearsOnAlbums$albums {
  CopyWith$Query$appearsOnAlbums$albums<Query$appearsOnAlbums$albums>
  get copyWith => CopyWith$Query$appearsOnAlbums$albums(this, (i) => i);
}

abstract class CopyWith$Query$appearsOnAlbums$albums<TRes> {
  factory CopyWith$Query$appearsOnAlbums$albums(
    Query$appearsOnAlbums$albums instance,
    TRes Function(Query$appearsOnAlbums$albums) then,
  ) = _CopyWithImpl$Query$appearsOnAlbums$albums;

  factory CopyWith$Query$appearsOnAlbums$albums.stub(TRes res) =
      _CopyWithStubImpl$Query$appearsOnAlbums$albums;

  TRes call({
    List<Fragment$fragmentAlbum>? content,
    int? totalPages,
    int? totalElements,
    int? number,
    int? size,
    String? $__typename,
  });
  TRes content(
    Iterable<Fragment$fragmentAlbum> Function(
      Iterable<CopyWith$Fragment$fragmentAlbum<Fragment$fragmentAlbum>>,
    )
    _fn,
  );
}

class _CopyWithImpl$Query$appearsOnAlbums$albums<TRes>
    implements CopyWith$Query$appearsOnAlbums$albums<TRes> {
  _CopyWithImpl$Query$appearsOnAlbums$albums(this._instance, this._then);

  final Query$appearsOnAlbums$albums _instance;

  final TRes Function(Query$appearsOnAlbums$albums) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? content = _undefined,
    Object? totalPages = _undefined,
    Object? totalElements = _undefined,
    Object? number = _undefined,
    Object? size = _undefined,
    Object? $__typename = _undefined,
  }) => _then(
    Query$appearsOnAlbums$albums(
      content: content == _undefined || content == null
          ? _instance.content
          : (content as List<Fragment$fragmentAlbum>),
      totalPages: totalPages == _undefined || totalPages == null
          ? _instance.totalPages
          : (totalPages as int),
      totalElements: totalElements == _undefined || totalElements == null
          ? _instance.totalElements
          : (totalElements as int),
      number: number == _undefined || number == null
          ? _instance.number
          : (number as int),
      size: size == _undefined || size == null ? _instance.size : (size as int),
      $__typename: $__typename == _undefined || $__typename == null
          ? _instance.$__typename
          : ($__typename as String),
    ),
  );

  TRes content(
    Iterable<Fragment$fragmentAlbum> Function(
      Iterable<CopyWith$Fragment$fragmentAlbum<Fragment$fragmentAlbum>>,
    )
    _fn,
  ) => call(
    content: _fn(
      _instance.content.map(
        (e) => CopyWith$Fragment$fragmentAlbum(e, (i) => i),
      ),
    ).toList(),
  );
}

class _CopyWithStubImpl$Query$appearsOnAlbums$albums<TRes>
    implements CopyWith$Query$appearsOnAlbums$albums<TRes> {
  _CopyWithStubImpl$Query$appearsOnAlbums$albums(this._res);

  TRes _res;

  call({
    List<Fragment$fragmentAlbum>? content,
    int? totalPages,
    int? totalElements,
    int? number,
    int? size,
    String? $__typename,
  }) => _res;

  content(_fn) => _res;
}

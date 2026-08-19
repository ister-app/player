import 'fragmentImages.graphql.dart';
import 'fragmentMetadata.graphql.dart';

import 'package:gql/ast.dart';

import 'schema.graphql.dart';

class Variables$Query$rankedMovies {
  factory Variables$Query$rankedMovies({
    required String libraryId,
    required Enum$RankKind kind,
    int? page,
    int? size,
  }) => Variables$Query$rankedMovies._({
    r'libraryId': libraryId,
    r'kind': kind,
    if (page != null) r'page': page,
    if (size != null) r'size': size,
  });

  Variables$Query$rankedMovies._(this._$data);

  factory Variables$Query$rankedMovies.fromJson(Map<String, dynamic> data) {
    final result$data = <String, dynamic>{};
    final l$libraryId = data['libraryId'];
    result$data['libraryId'] = (l$libraryId as String);
    final l$kind = data['kind'];
    result$data['kind'] = fromJson$Enum$RankKind((l$kind as String));
    if (data.containsKey('page')) {
      final l$page = data['page'];
      result$data['page'] = (l$page as int?);
    }
    if (data.containsKey('size')) {
      final l$size = data['size'];
      result$data['size'] = (l$size as int?);
    }
    return Variables$Query$rankedMovies._(result$data);
  }

  Map<String, dynamic> _$data;

  String get libraryId => (_$data['libraryId'] as String);

  Enum$RankKind get kind => (_$data['kind'] as Enum$RankKind);

  int? get page => (_$data['page'] as int?);

  int? get size => (_$data['size'] as int?);

  Map<String, dynamic> toJson() {
    final result$data = <String, dynamic>{};
    final l$libraryId = libraryId;
    result$data['libraryId'] = l$libraryId;
    final l$kind = kind;
    result$data['kind'] = toJson$Enum$RankKind(l$kind);
    if (_$data.containsKey('page')) {
      final l$page = page;
      result$data['page'] = l$page;
    }
    if (_$data.containsKey('size')) {
      final l$size = size;
      result$data['size'] = l$size;
    }
    return result$data;
  }

  CopyWith$Variables$Query$rankedMovies<Variables$Query$rankedMovies>
  get copyWith => CopyWith$Variables$Query$rankedMovies(this, (i) => i);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Variables$Query$rankedMovies ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$libraryId = libraryId;
    final lOther$libraryId = other.libraryId;
    if (l$libraryId != lOther$libraryId) {
      return false;
    }
    final l$kind = kind;
    final lOther$kind = other.kind;
    if (l$kind != lOther$kind) {
      return false;
    }
    final l$page = page;
    final lOther$page = other.page;
    if (_$data.containsKey('page') != other._$data.containsKey('page')) {
      return false;
    }
    if (l$page != lOther$page) {
      return false;
    }
    final l$size = size;
    final lOther$size = other.size;
    if (_$data.containsKey('size') != other._$data.containsKey('size')) {
      return false;
    }
    if (l$size != lOther$size) {
      return false;
    }
    return true;
  }

  @override
  int get hashCode {
    final l$libraryId = libraryId;
    final l$kind = kind;
    final l$page = page;
    final l$size = size;
    return Object.hashAll([
      l$libraryId,
      l$kind,
      _$data.containsKey('page') ? l$page : const {},
      _$data.containsKey('size') ? l$size : const {},
    ]);
  }
}

abstract class CopyWith$Variables$Query$rankedMovies<TRes> {
  factory CopyWith$Variables$Query$rankedMovies(
    Variables$Query$rankedMovies instance,
    TRes Function(Variables$Query$rankedMovies) then,
  ) = _CopyWithImpl$Variables$Query$rankedMovies;

  factory CopyWith$Variables$Query$rankedMovies.stub(TRes res) =
      _CopyWithStubImpl$Variables$Query$rankedMovies;

  TRes call({String? libraryId, Enum$RankKind? kind, int? page, int? size});
}

class _CopyWithImpl$Variables$Query$rankedMovies<TRes>
    implements CopyWith$Variables$Query$rankedMovies<TRes> {
  _CopyWithImpl$Variables$Query$rankedMovies(this._instance, this._then);

  final Variables$Query$rankedMovies _instance;

  final TRes Function(Variables$Query$rankedMovies) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? libraryId = _undefined,
    Object? kind = _undefined,
    Object? page = _undefined,
    Object? size = _undefined,
  }) => _then(
    Variables$Query$rankedMovies._({
      ..._instance._$data,
      if (libraryId != _undefined && libraryId != null)
        'libraryId': (libraryId as String),
      if (kind != _undefined && kind != null) 'kind': (kind as Enum$RankKind),
      if (page != _undefined) 'page': (page as int?),
      if (size != _undefined) 'size': (size as int?),
    }),
  );
}

class _CopyWithStubImpl$Variables$Query$rankedMovies<TRes>
    implements CopyWith$Variables$Query$rankedMovies<TRes> {
  _CopyWithStubImpl$Variables$Query$rankedMovies(this._res);

  TRes _res;

  call({String? libraryId, Enum$RankKind? kind, int? page, int? size}) => _res;
}

class Query$rankedMovies {
  Query$rankedMovies({this.libraryById, this.$__typename = 'Query'});

  factory Query$rankedMovies.fromJson(Map<String, dynamic> json) {
    final l$libraryById = json['libraryById'];
    final l$$__typename = json['__typename'];
    return Query$rankedMovies(
      libraryById: l$libraryById == null
          ? null
          : Query$rankedMovies$libraryById.fromJson(
              (l$libraryById as Map<String, dynamic>),
            ),
      $__typename: (l$$__typename as String),
    );
  }

  final Query$rankedMovies$libraryById? libraryById;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$libraryById = libraryById;
    _resultData['libraryById'] = l$libraryById?.toJson();
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$libraryById = libraryById;
    final l$$__typename = $__typename;
    return Object.hashAll([l$libraryById, l$$__typename]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Query$rankedMovies || runtimeType != other.runtimeType) {
      return false;
    }
    final l$libraryById = libraryById;
    final lOther$libraryById = other.libraryById;
    if (l$libraryById != lOther$libraryById) {
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

extension UtilityExtension$Query$rankedMovies on Query$rankedMovies {
  CopyWith$Query$rankedMovies<Query$rankedMovies> get copyWith =>
      CopyWith$Query$rankedMovies(this, (i) => i);
}

abstract class CopyWith$Query$rankedMovies<TRes> {
  factory CopyWith$Query$rankedMovies(
    Query$rankedMovies instance,
    TRes Function(Query$rankedMovies) then,
  ) = _CopyWithImpl$Query$rankedMovies;

  factory CopyWith$Query$rankedMovies.stub(TRes res) =
      _CopyWithStubImpl$Query$rankedMovies;

  TRes call({Query$rankedMovies$libraryById? libraryById, String? $__typename});
  CopyWith$Query$rankedMovies$libraryById<TRes> get libraryById;
}

class _CopyWithImpl$Query$rankedMovies<TRes>
    implements CopyWith$Query$rankedMovies<TRes> {
  _CopyWithImpl$Query$rankedMovies(this._instance, this._then);

  final Query$rankedMovies _instance;

  final TRes Function(Query$rankedMovies) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? libraryById = _undefined,
    Object? $__typename = _undefined,
  }) => _then(
    Query$rankedMovies(
      libraryById: libraryById == _undefined
          ? _instance.libraryById
          : (libraryById as Query$rankedMovies$libraryById?),
      $__typename: $__typename == _undefined || $__typename == null
          ? _instance.$__typename
          : ($__typename as String),
    ),
  );

  CopyWith$Query$rankedMovies$libraryById<TRes> get libraryById {
    final local$libraryById = _instance.libraryById;
    return local$libraryById == null
        ? CopyWith$Query$rankedMovies$libraryById.stub(_then(_instance))
        : CopyWith$Query$rankedMovies$libraryById(
            local$libraryById,
            (e) => call(libraryById: e),
          );
  }
}

class _CopyWithStubImpl$Query$rankedMovies<TRes>
    implements CopyWith$Query$rankedMovies<TRes> {
  _CopyWithStubImpl$Query$rankedMovies(this._res);

  TRes _res;

  call({Query$rankedMovies$libraryById? libraryById, String? $__typename}) =>
      _res;

  CopyWith$Query$rankedMovies$libraryById<TRes> get libraryById =>
      CopyWith$Query$rankedMovies$libraryById.stub(_res);
}

const documentNodeQueryrankedMovies = DocumentNode(
  definitions: [
    OperationDefinitionNode(
      type: OperationType.query,
      name: NameNode(value: 'rankedMovies'),
      variableDefinitions: [
        VariableDefinitionNode(
          variable: VariableNode(name: NameNode(value: 'libraryId')),
          type: NamedTypeNode(name: NameNode(value: 'ID'), isNonNull: true),
          defaultValue: DefaultValueNode(value: null),
          directives: [],
        ),
        VariableDefinitionNode(
          variable: VariableNode(name: NameNode(value: 'kind')),
          type: NamedTypeNode(
            name: NameNode(value: 'RankKind'),
            isNonNull: true,
          ),
          defaultValue: DefaultValueNode(value: null),
          directives: [],
        ),
        VariableDefinitionNode(
          variable: VariableNode(name: NameNode(value: 'page')),
          type: NamedTypeNode(name: NameNode(value: 'Int'), isNonNull: false),
          defaultValue: DefaultValueNode(value: null),
          directives: [],
        ),
        VariableDefinitionNode(
          variable: VariableNode(name: NameNode(value: 'size')),
          type: NamedTypeNode(name: NameNode(value: 'Int'), isNonNull: false),
          defaultValue: DefaultValueNode(value: null),
          directives: [],
        ),
      ],
      directives: [],
      selectionSet: SelectionSetNode(
        selections: [
          FieldNode(
            name: NameNode(value: 'libraryById'),
            alias: null,
            arguments: [
              ArgumentNode(
                name: NameNode(value: 'id'),
                value: VariableNode(name: NameNode(value: 'libraryId')),
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
                  name: NameNode(value: 'rankedMovies'),
                  alias: null,
                  arguments: [
                    ArgumentNode(
                      name: NameNode(value: 'kind'),
                      value: VariableNode(name: NameNode(value: 'kind')),
                    ),
                    ArgumentNode(
                      name: NameNode(value: 'page'),
                      value: VariableNode(name: NameNode(value: 'page')),
                    ),
                    ArgumentNode(
                      name: NameNode(value: 'size'),
                      value: VariableNode(name: NameNode(value: 'size')),
                    ),
                  ],
                  directives: [],
                  selectionSet: SelectionSetNode(
                    selections: [
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
                        name: NameNode(value: 'totalElements'),
                        alias: null,
                        arguments: [],
                        directives: [],
                        selectionSet: null,
                      ),
                      FieldNode(
                        name: NameNode(value: 'totalPages'),
                        alias: null,
                        arguments: [],
                        directives: [],
                        selectionSet: null,
                      ),
                      FieldNode(
                        name: NameNode(value: 'content'),
                        alias: null,
                        arguments: [],
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
                              name: NameNode(value: 'name'),
                              alias: null,
                              arguments: [],
                              directives: [],
                              selectionSet: null,
                            ),
                            FieldNode(
                              name: NameNode(value: 'releaseYear'),
                              alias: null,
                              arguments: [],
                              directives: [],
                              selectionSet: null,
                            ),
                            FieldNode(
                              name: NameNode(value: 'images'),
                              alias: null,
                              arguments: [],
                              directives: [],
                              selectionSet: SelectionSetNode(
                                selections: [
                                  FragmentSpreadNode(
                                    name: NameNode(value: 'fragmentImages'),
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
                              name: NameNode(value: 'metadata'),
                              alias: null,
                              arguments: [],
                              directives: [],
                              selectionSet: SelectionSetNode(
                                selections: [
                                  FragmentSpreadNode(
                                    name: NameNode(value: 'fragmentMetadata'),
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
    fragmentDefinitionfragmentImages,
    fragmentDefinitionfragmentMetadata,
  ],
);

class Query$rankedMovies$libraryById {
  Query$rankedMovies$libraryById({
    required this.id,
    required this.rankedMovies,
    this.$__typename = 'Library',
  });

  factory Query$rankedMovies$libraryById.fromJson(Map<String, dynamic> json) {
    final l$id = json['id'];
    final l$rankedMovies = json['rankedMovies'];
    final l$$__typename = json['__typename'];
    return Query$rankedMovies$libraryById(
      id: (l$id as String),
      rankedMovies: Query$rankedMovies$libraryById$rankedMovies.fromJson(
        (l$rankedMovies as Map<String, dynamic>),
      ),
      $__typename: (l$$__typename as String),
    );
  }

  final String id;

  final Query$rankedMovies$libraryById$rankedMovies rankedMovies;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$id = id;
    _resultData['id'] = l$id;
    final l$rankedMovies = rankedMovies;
    _resultData['rankedMovies'] = l$rankedMovies.toJson();
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$id = id;
    final l$rankedMovies = rankedMovies;
    final l$$__typename = $__typename;
    return Object.hashAll([l$id, l$rankedMovies, l$$__typename]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Query$rankedMovies$libraryById ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$id = id;
    final lOther$id = other.id;
    if (l$id != lOther$id) {
      return false;
    }
    final l$rankedMovies = rankedMovies;
    final lOther$rankedMovies = other.rankedMovies;
    if (l$rankedMovies != lOther$rankedMovies) {
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

extension UtilityExtension$Query$rankedMovies$libraryById
    on Query$rankedMovies$libraryById {
  CopyWith$Query$rankedMovies$libraryById<Query$rankedMovies$libraryById>
  get copyWith => CopyWith$Query$rankedMovies$libraryById(this, (i) => i);
}

abstract class CopyWith$Query$rankedMovies$libraryById<TRes> {
  factory CopyWith$Query$rankedMovies$libraryById(
    Query$rankedMovies$libraryById instance,
    TRes Function(Query$rankedMovies$libraryById) then,
  ) = _CopyWithImpl$Query$rankedMovies$libraryById;

  factory CopyWith$Query$rankedMovies$libraryById.stub(TRes res) =
      _CopyWithStubImpl$Query$rankedMovies$libraryById;

  TRes call({
    String? id,
    Query$rankedMovies$libraryById$rankedMovies? rankedMovies,
    String? $__typename,
  });
  CopyWith$Query$rankedMovies$libraryById$rankedMovies<TRes> get rankedMovies;
}

class _CopyWithImpl$Query$rankedMovies$libraryById<TRes>
    implements CopyWith$Query$rankedMovies$libraryById<TRes> {
  _CopyWithImpl$Query$rankedMovies$libraryById(this._instance, this._then);

  final Query$rankedMovies$libraryById _instance;

  final TRes Function(Query$rankedMovies$libraryById) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? id = _undefined,
    Object? rankedMovies = _undefined,
    Object? $__typename = _undefined,
  }) => _then(
    Query$rankedMovies$libraryById(
      id: id == _undefined || id == null ? _instance.id : (id as String),
      rankedMovies: rankedMovies == _undefined || rankedMovies == null
          ? _instance.rankedMovies
          : (rankedMovies as Query$rankedMovies$libraryById$rankedMovies),
      $__typename: $__typename == _undefined || $__typename == null
          ? _instance.$__typename
          : ($__typename as String),
    ),
  );

  CopyWith$Query$rankedMovies$libraryById$rankedMovies<TRes> get rankedMovies {
    final local$rankedMovies = _instance.rankedMovies;
    return CopyWith$Query$rankedMovies$libraryById$rankedMovies(
      local$rankedMovies,
      (e) => call(rankedMovies: e),
    );
  }
}

class _CopyWithStubImpl$Query$rankedMovies$libraryById<TRes>
    implements CopyWith$Query$rankedMovies$libraryById<TRes> {
  _CopyWithStubImpl$Query$rankedMovies$libraryById(this._res);

  TRes _res;

  call({
    String? id,
    Query$rankedMovies$libraryById$rankedMovies? rankedMovies,
    String? $__typename,
  }) => _res;

  CopyWith$Query$rankedMovies$libraryById$rankedMovies<TRes> get rankedMovies =>
      CopyWith$Query$rankedMovies$libraryById$rankedMovies.stub(_res);
}

class Query$rankedMovies$libraryById$rankedMovies {
  Query$rankedMovies$libraryById$rankedMovies({
    required this.number,
    required this.size,
    required this.totalElements,
    required this.totalPages,
    required this.content,
    this.$__typename = 'MoviePage',
  });

  factory Query$rankedMovies$libraryById$rankedMovies.fromJson(
    Map<String, dynamic> json,
  ) {
    final l$number = json['number'];
    final l$size = json['size'];
    final l$totalElements = json['totalElements'];
    final l$totalPages = json['totalPages'];
    final l$content = json['content'];
    final l$$__typename = json['__typename'];
    return Query$rankedMovies$libraryById$rankedMovies(
      number: (l$number as int),
      size: (l$size as int),
      totalElements: (l$totalElements as int),
      totalPages: (l$totalPages as int),
      content: (l$content as List<dynamic>)
          .map(
            (e) => Query$rankedMovies$libraryById$rankedMovies$content.fromJson(
              (e as Map<String, dynamic>),
            ),
          )
          .toList(),
      $__typename: (l$$__typename as String),
    );
  }

  final int number;

  final int size;

  final int totalElements;

  final int totalPages;

  final List<Query$rankedMovies$libraryById$rankedMovies$content> content;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$number = number;
    _resultData['number'] = l$number;
    final l$size = size;
    _resultData['size'] = l$size;
    final l$totalElements = totalElements;
    _resultData['totalElements'] = l$totalElements;
    final l$totalPages = totalPages;
    _resultData['totalPages'] = l$totalPages;
    final l$content = content;
    _resultData['content'] = l$content.map((e) => e.toJson()).toList();
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$number = number;
    final l$size = size;
    final l$totalElements = totalElements;
    final l$totalPages = totalPages;
    final l$content = content;
    final l$$__typename = $__typename;
    return Object.hashAll([
      l$number,
      l$size,
      l$totalElements,
      l$totalPages,
      Object.hashAll(l$content.map((v) => v)),
      l$$__typename,
    ]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Query$rankedMovies$libraryById$rankedMovies ||
        runtimeType != other.runtimeType) {
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
    final l$totalElements = totalElements;
    final lOther$totalElements = other.totalElements;
    if (l$totalElements != lOther$totalElements) {
      return false;
    }
    final l$totalPages = totalPages;
    final lOther$totalPages = other.totalPages;
    if (l$totalPages != lOther$totalPages) {
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
    final l$$__typename = $__typename;
    final lOther$$__typename = other.$__typename;
    if (l$$__typename != lOther$$__typename) {
      return false;
    }
    return true;
  }
}

extension UtilityExtension$Query$rankedMovies$libraryById$rankedMovies
    on Query$rankedMovies$libraryById$rankedMovies {
  CopyWith$Query$rankedMovies$libraryById$rankedMovies<
    Query$rankedMovies$libraryById$rankedMovies
  >
  get copyWith =>
      CopyWith$Query$rankedMovies$libraryById$rankedMovies(this, (i) => i);
}

abstract class CopyWith$Query$rankedMovies$libraryById$rankedMovies<TRes> {
  factory CopyWith$Query$rankedMovies$libraryById$rankedMovies(
    Query$rankedMovies$libraryById$rankedMovies instance,
    TRes Function(Query$rankedMovies$libraryById$rankedMovies) then,
  ) = _CopyWithImpl$Query$rankedMovies$libraryById$rankedMovies;

  factory CopyWith$Query$rankedMovies$libraryById$rankedMovies.stub(TRes res) =
      _CopyWithStubImpl$Query$rankedMovies$libraryById$rankedMovies;

  TRes call({
    int? number,
    int? size,
    int? totalElements,
    int? totalPages,
    List<Query$rankedMovies$libraryById$rankedMovies$content>? content,
    String? $__typename,
  });
  TRes content(
    Iterable<Query$rankedMovies$libraryById$rankedMovies$content> Function(
      Iterable<
        CopyWith$Query$rankedMovies$libraryById$rankedMovies$content<
          Query$rankedMovies$libraryById$rankedMovies$content
        >
      >,
    )
    _fn,
  );
}

class _CopyWithImpl$Query$rankedMovies$libraryById$rankedMovies<TRes>
    implements CopyWith$Query$rankedMovies$libraryById$rankedMovies<TRes> {
  _CopyWithImpl$Query$rankedMovies$libraryById$rankedMovies(
    this._instance,
    this._then,
  );

  final Query$rankedMovies$libraryById$rankedMovies _instance;

  final TRes Function(Query$rankedMovies$libraryById$rankedMovies) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? number = _undefined,
    Object? size = _undefined,
    Object? totalElements = _undefined,
    Object? totalPages = _undefined,
    Object? content = _undefined,
    Object? $__typename = _undefined,
  }) => _then(
    Query$rankedMovies$libraryById$rankedMovies(
      number: number == _undefined || number == null
          ? _instance.number
          : (number as int),
      size: size == _undefined || size == null ? _instance.size : (size as int),
      totalElements: totalElements == _undefined || totalElements == null
          ? _instance.totalElements
          : (totalElements as int),
      totalPages: totalPages == _undefined || totalPages == null
          ? _instance.totalPages
          : (totalPages as int),
      content: content == _undefined || content == null
          ? _instance.content
          : (content
                as List<Query$rankedMovies$libraryById$rankedMovies$content>),
      $__typename: $__typename == _undefined || $__typename == null
          ? _instance.$__typename
          : ($__typename as String),
    ),
  );

  TRes content(
    Iterable<Query$rankedMovies$libraryById$rankedMovies$content> Function(
      Iterable<
        CopyWith$Query$rankedMovies$libraryById$rankedMovies$content<
          Query$rankedMovies$libraryById$rankedMovies$content
        >
      >,
    )
    _fn,
  ) => call(
    content: _fn(
      _instance.content.map(
        (e) => CopyWith$Query$rankedMovies$libraryById$rankedMovies$content(
          e,
          (i) => i,
        ),
      ),
    ).toList(),
  );
}

class _CopyWithStubImpl$Query$rankedMovies$libraryById$rankedMovies<TRes>
    implements CopyWith$Query$rankedMovies$libraryById$rankedMovies<TRes> {
  _CopyWithStubImpl$Query$rankedMovies$libraryById$rankedMovies(this._res);

  TRes _res;

  call({
    int? number,
    int? size,
    int? totalElements,
    int? totalPages,
    List<Query$rankedMovies$libraryById$rankedMovies$content>? content,
    String? $__typename,
  }) => _res;

  content(_fn) => _res;
}

class Query$rankedMovies$libraryById$rankedMovies$content {
  Query$rankedMovies$libraryById$rankedMovies$content({
    required this.id,
    required this.name,
    required this.releaseYear,
    this.images,
    this.metadata,
    this.$__typename = 'Movie',
  });

  factory Query$rankedMovies$libraryById$rankedMovies$content.fromJson(
    Map<String, dynamic> json,
  ) {
    final l$id = json['id'];
    final l$name = json['name'];
    final l$releaseYear = json['releaseYear'];
    final l$images = json['images'];
    final l$metadata = json['metadata'];
    final l$$__typename = json['__typename'];
    return Query$rankedMovies$libraryById$rankedMovies$content(
      id: (l$id as String),
      name: (l$name as String),
      releaseYear: (l$releaseYear as int),
      images: (l$images as List<dynamic>?)
          ?.map(
            (e) =>
                Fragment$fragmentImages.fromJson((e as Map<String, dynamic>)),
          )
          .toList(),
      metadata: (l$metadata as List<dynamic>?)
          ?.map(
            (e) =>
                Fragment$fragmentMetadata.fromJson((e as Map<String, dynamic>)),
          )
          .toList(),
      $__typename: (l$$__typename as String),
    );
  }

  final String id;

  final String name;

  final int releaseYear;

  final List<Fragment$fragmentImages>? images;

  final List<Fragment$fragmentMetadata>? metadata;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$id = id;
    _resultData['id'] = l$id;
    final l$name = name;
    _resultData['name'] = l$name;
    final l$releaseYear = releaseYear;
    _resultData['releaseYear'] = l$releaseYear;
    final l$images = images;
    _resultData['images'] = l$images?.map((e) => e.toJson()).toList();
    final l$metadata = metadata;
    _resultData['metadata'] = l$metadata?.map((e) => e.toJson()).toList();
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$id = id;
    final l$name = name;
    final l$releaseYear = releaseYear;
    final l$images = images;
    final l$metadata = metadata;
    final l$$__typename = $__typename;
    return Object.hashAll([
      l$id,
      l$name,
      l$releaseYear,
      l$images == null ? null : Object.hashAll(l$images.map((v) => v)),
      l$metadata == null ? null : Object.hashAll(l$metadata.map((v) => v)),
      l$$__typename,
    ]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Query$rankedMovies$libraryById$rankedMovies$content ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$id = id;
    final lOther$id = other.id;
    if (l$id != lOther$id) {
      return false;
    }
    final l$name = name;
    final lOther$name = other.name;
    if (l$name != lOther$name) {
      return false;
    }
    final l$releaseYear = releaseYear;
    final lOther$releaseYear = other.releaseYear;
    if (l$releaseYear != lOther$releaseYear) {
      return false;
    }
    final l$images = images;
    final lOther$images = other.images;
    if (l$images != null && lOther$images != null) {
      if (l$images.length != lOther$images.length) {
        return false;
      }
      for (int i = 0; i < l$images.length; i++) {
        final l$images$entry = l$images[i];
        final lOther$images$entry = lOther$images[i];
        if (l$images$entry != lOther$images$entry) {
          return false;
        }
      }
    } else if (l$images != lOther$images) {
      return false;
    }
    final l$metadata = metadata;
    final lOther$metadata = other.metadata;
    if (l$metadata != null && lOther$metadata != null) {
      if (l$metadata.length != lOther$metadata.length) {
        return false;
      }
      for (int i = 0; i < l$metadata.length; i++) {
        final l$metadata$entry = l$metadata[i];
        final lOther$metadata$entry = lOther$metadata[i];
        if (l$metadata$entry != lOther$metadata$entry) {
          return false;
        }
      }
    } else if (l$metadata != lOther$metadata) {
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

extension UtilityExtension$Query$rankedMovies$libraryById$rankedMovies$content
    on Query$rankedMovies$libraryById$rankedMovies$content {
  CopyWith$Query$rankedMovies$libraryById$rankedMovies$content<
    Query$rankedMovies$libraryById$rankedMovies$content
  >
  get copyWith => CopyWith$Query$rankedMovies$libraryById$rankedMovies$content(
    this,
    (i) => i,
  );
}

abstract class CopyWith$Query$rankedMovies$libraryById$rankedMovies$content<
  TRes
> {
  factory CopyWith$Query$rankedMovies$libraryById$rankedMovies$content(
    Query$rankedMovies$libraryById$rankedMovies$content instance,
    TRes Function(Query$rankedMovies$libraryById$rankedMovies$content) then,
  ) = _CopyWithImpl$Query$rankedMovies$libraryById$rankedMovies$content;

  factory CopyWith$Query$rankedMovies$libraryById$rankedMovies$content.stub(
    TRes res,
  ) = _CopyWithStubImpl$Query$rankedMovies$libraryById$rankedMovies$content;

  TRes call({
    String? id,
    String? name,
    int? releaseYear,
    List<Fragment$fragmentImages>? images,
    List<Fragment$fragmentMetadata>? metadata,
    String? $__typename,
  });
  TRes images(
    Iterable<Fragment$fragmentImages>? Function(
      Iterable<CopyWith$Fragment$fragmentImages<Fragment$fragmentImages>>?,
    )
    _fn,
  );
  TRes metadata(
    Iterable<Fragment$fragmentMetadata>? Function(
      Iterable<CopyWith$Fragment$fragmentMetadata<Fragment$fragmentMetadata>>?,
    )
    _fn,
  );
}

class _CopyWithImpl$Query$rankedMovies$libraryById$rankedMovies$content<TRes>
    implements
        CopyWith$Query$rankedMovies$libraryById$rankedMovies$content<TRes> {
  _CopyWithImpl$Query$rankedMovies$libraryById$rankedMovies$content(
    this._instance,
    this._then,
  );

  final Query$rankedMovies$libraryById$rankedMovies$content _instance;

  final TRes Function(Query$rankedMovies$libraryById$rankedMovies$content)
  _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? id = _undefined,
    Object? name = _undefined,
    Object? releaseYear = _undefined,
    Object? images = _undefined,
    Object? metadata = _undefined,
    Object? $__typename = _undefined,
  }) => _then(
    Query$rankedMovies$libraryById$rankedMovies$content(
      id: id == _undefined || id == null ? _instance.id : (id as String),
      name: name == _undefined || name == null
          ? _instance.name
          : (name as String),
      releaseYear: releaseYear == _undefined || releaseYear == null
          ? _instance.releaseYear
          : (releaseYear as int),
      images: images == _undefined
          ? _instance.images
          : (images as List<Fragment$fragmentImages>?),
      metadata: metadata == _undefined
          ? _instance.metadata
          : (metadata as List<Fragment$fragmentMetadata>?),
      $__typename: $__typename == _undefined || $__typename == null
          ? _instance.$__typename
          : ($__typename as String),
    ),
  );

  TRes images(
    Iterable<Fragment$fragmentImages>? Function(
      Iterable<CopyWith$Fragment$fragmentImages<Fragment$fragmentImages>>?,
    )
    _fn,
  ) => call(
    images: _fn(
      _instance.images?.map(
        (e) => CopyWith$Fragment$fragmentImages(e, (i) => i),
      ),
    )?.toList(),
  );

  TRes metadata(
    Iterable<Fragment$fragmentMetadata>? Function(
      Iterable<CopyWith$Fragment$fragmentMetadata<Fragment$fragmentMetadata>>?,
    )
    _fn,
  ) => call(
    metadata: _fn(
      _instance.metadata?.map(
        (e) => CopyWith$Fragment$fragmentMetadata(e, (i) => i),
      ),
    )?.toList(),
  );
}

class _CopyWithStubImpl$Query$rankedMovies$libraryById$rankedMovies$content<
  TRes
>
    implements
        CopyWith$Query$rankedMovies$libraryById$rankedMovies$content<TRes> {
  _CopyWithStubImpl$Query$rankedMovies$libraryById$rankedMovies$content(
    this._res,
  );

  TRes _res;

  call({
    String? id,
    String? name,
    int? releaseYear,
    List<Fragment$fragmentImages>? images,
    List<Fragment$fragmentMetadata>? metadata,
    String? $__typename,
  }) => _res;

  images(_fn) => _res;

  metadata(_fn) => _res;
}

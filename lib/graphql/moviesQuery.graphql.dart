import 'fragmentImages.graphql.dart';
import 'fragmentMetadata.graphql.dart';
import 'package:gql/ast.dart';
import 'schema.graphql.dart';

class Variables$Query$movies {
  factory Variables$Query$movies({
    int? page,
    int? size,
    Enum$SortingEnum? sorting,
    Enum$SortingOrder? sortingOrder,
    String? libraryId,
  }) => Variables$Query$movies._({
    if (page != null) r'page': page,
    if (size != null) r'size': size,
    if (sorting != null) r'sorting': sorting,
    if (sortingOrder != null) r'sortingOrder': sortingOrder,
    if (libraryId != null) r'libraryId': libraryId,
  });

  Variables$Query$movies._(this._$data);

  factory Variables$Query$movies.fromJson(Map<String, dynamic> data) {
    final result$data = <String, dynamic>{};
    if (data.containsKey('page')) {
      final l$page = data['page'];
      result$data['page'] = (l$page as int?);
    }
    if (data.containsKey('size')) {
      final l$size = data['size'];
      result$data['size'] = (l$size as int?);
    }
    if (data.containsKey('sorting')) {
      final l$sorting = data['sorting'];
      result$data['sorting'] = l$sorting == null
          ? null
          : fromJson$Enum$SortingEnum((l$sorting as String));
    }
    if (data.containsKey('sortingOrder')) {
      final l$sortingOrder = data['sortingOrder'];
      result$data['sortingOrder'] = l$sortingOrder == null
          ? null
          : fromJson$Enum$SortingOrder((l$sortingOrder as String));
    }
    if (data.containsKey('libraryId')) {
      final l$libraryId = data['libraryId'];
      result$data['libraryId'] = (l$libraryId as String?);
    }
    return Variables$Query$movies._(result$data);
  }

  Map<String, dynamic> _$data;

  int? get page => (_$data['page'] as int?);

  int? get size => (_$data['size'] as int?);

  Enum$SortingEnum? get sorting => (_$data['sorting'] as Enum$SortingEnum?);

  Enum$SortingOrder? get sortingOrder =>
      (_$data['sortingOrder'] as Enum$SortingOrder?);

  String? get libraryId => (_$data['libraryId'] as String?);

  Map<String, dynamic> toJson() {
    final result$data = <String, dynamic>{};
    if (_$data.containsKey('page')) {
      final l$page = page;
      result$data['page'] = l$page;
    }
    if (_$data.containsKey('size')) {
      final l$size = size;
      result$data['size'] = l$size;
    }
    if (_$data.containsKey('sorting')) {
      final l$sorting = sorting;
      result$data['sorting'] = l$sorting == null
          ? null
          : toJson$Enum$SortingEnum(l$sorting);
    }
    if (_$data.containsKey('sortingOrder')) {
      final l$sortingOrder = sortingOrder;
      result$data['sortingOrder'] = l$sortingOrder == null
          ? null
          : toJson$Enum$SortingOrder(l$sortingOrder);
    }
    if (_$data.containsKey('libraryId')) {
      final l$libraryId = libraryId;
      result$data['libraryId'] = l$libraryId;
    }
    return result$data;
  }

  CopyWith$Variables$Query$movies<Variables$Query$movies> get copyWith =>
      CopyWith$Variables$Query$movies(this, (i) => i);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Variables$Query$movies || runtimeType != other.runtimeType) {
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
    final l$sorting = sorting;
    final lOther$sorting = other.sorting;
    if (_$data.containsKey('sorting') != other._$data.containsKey('sorting')) {
      return false;
    }
    if (l$sorting != lOther$sorting) {
      return false;
    }
    final l$sortingOrder = sortingOrder;
    final lOther$sortingOrder = other.sortingOrder;
    if (_$data.containsKey('sortingOrder') !=
        other._$data.containsKey('sortingOrder')) {
      return false;
    }
    if (l$sortingOrder != lOther$sortingOrder) {
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
    final l$page = page;
    final l$size = size;
    final l$sorting = sorting;
    final l$sortingOrder = sortingOrder;
    final l$libraryId = libraryId;
    return Object.hashAll([
      _$data.containsKey('page') ? l$page : const {},
      _$data.containsKey('size') ? l$size : const {},
      _$data.containsKey('sorting') ? l$sorting : const {},
      _$data.containsKey('sortingOrder') ? l$sortingOrder : const {},
      _$data.containsKey('libraryId') ? l$libraryId : const {},
    ]);
  }
}

abstract class CopyWith$Variables$Query$movies<TRes> {
  factory CopyWith$Variables$Query$movies(
    Variables$Query$movies instance,
    TRes Function(Variables$Query$movies) then,
  ) = _CopyWithImpl$Variables$Query$movies;

  factory CopyWith$Variables$Query$movies.stub(TRes res) =
      _CopyWithStubImpl$Variables$Query$movies;

  TRes call({
    int? page,
    int? size,
    Enum$SortingEnum? sorting,
    Enum$SortingOrder? sortingOrder,
    String? libraryId,
  });
}

class _CopyWithImpl$Variables$Query$movies<TRes>
    implements CopyWith$Variables$Query$movies<TRes> {
  _CopyWithImpl$Variables$Query$movies(this._instance, this._then);

  final Variables$Query$movies _instance;

  final TRes Function(Variables$Query$movies) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? page = _undefined,
    Object? size = _undefined,
    Object? sorting = _undefined,
    Object? sortingOrder = _undefined,
    Object? libraryId = _undefined,
  }) => _then(
    Variables$Query$movies._({
      ..._instance._$data,
      if (page != _undefined) 'page': (page as int?),
      if (size != _undefined) 'size': (size as int?),
      if (sorting != _undefined) 'sorting': (sorting as Enum$SortingEnum?),
      if (sortingOrder != _undefined)
        'sortingOrder': (sortingOrder as Enum$SortingOrder?),
      if (libraryId != _undefined) 'libraryId': (libraryId as String?),
    }),
  );
}

class _CopyWithStubImpl$Variables$Query$movies<TRes>
    implements CopyWith$Variables$Query$movies<TRes> {
  _CopyWithStubImpl$Variables$Query$movies(this._res);

  TRes _res;

  call({
    int? page,
    int? size,
    Enum$SortingEnum? sorting,
    Enum$SortingOrder? sortingOrder,
    String? libraryId,
  }) => _res;
}

class Query$movies {
  Query$movies({this.movies, this.$__typename = 'Query'});

  factory Query$movies.fromJson(Map<String, dynamic> json) {
    final l$movies = json['movies'];
    final l$$__typename = json['__typename'];
    return Query$movies(
      movies: l$movies == null
          ? null
          : Query$movies$movies.fromJson((l$movies as Map<String, dynamic>)),
      $__typename: (l$$__typename as String),
    );
  }

  final Query$movies$movies? movies;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$movies = movies;
    _resultData['movies'] = l$movies?.toJson();
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$movies = movies;
    final l$$__typename = $__typename;
    return Object.hashAll([l$movies, l$$__typename]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Query$movies || runtimeType != other.runtimeType) {
      return false;
    }
    final l$movies = movies;
    final lOther$movies = other.movies;
    if (l$movies != lOther$movies) {
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

extension UtilityExtension$Query$movies on Query$movies {
  CopyWith$Query$movies<Query$movies> get copyWith =>
      CopyWith$Query$movies(this, (i) => i);
}

abstract class CopyWith$Query$movies<TRes> {
  factory CopyWith$Query$movies(
    Query$movies instance,
    TRes Function(Query$movies) then,
  ) = _CopyWithImpl$Query$movies;

  factory CopyWith$Query$movies.stub(TRes res) = _CopyWithStubImpl$Query$movies;

  TRes call({Query$movies$movies? movies, String? $__typename});
  CopyWith$Query$movies$movies<TRes> get movies;
}

class _CopyWithImpl$Query$movies<TRes> implements CopyWith$Query$movies<TRes> {
  _CopyWithImpl$Query$movies(this._instance, this._then);

  final Query$movies _instance;

  final TRes Function(Query$movies) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({Object? movies = _undefined, Object? $__typename = _undefined}) =>
      _then(
        Query$movies(
          movies: movies == _undefined
              ? _instance.movies
              : (movies as Query$movies$movies?),
          $__typename: $__typename == _undefined || $__typename == null
              ? _instance.$__typename
              : ($__typename as String),
        ),
      );

  CopyWith$Query$movies$movies<TRes> get movies {
    final local$movies = _instance.movies;
    return local$movies == null
        ? CopyWith$Query$movies$movies.stub(_then(_instance))
        : CopyWith$Query$movies$movies(local$movies, (e) => call(movies: e));
  }
}

class _CopyWithStubImpl$Query$movies<TRes>
    implements CopyWith$Query$movies<TRes> {
  _CopyWithStubImpl$Query$movies(this._res);

  TRes _res;

  call({Query$movies$movies? movies, String? $__typename}) => _res;

  CopyWith$Query$movies$movies<TRes> get movies =>
      CopyWith$Query$movies$movies.stub(_res);
}

const documentNodeQuerymovies = DocumentNode(
  definitions: [
    OperationDefinitionNode(
      type: OperationType.query,
      name: NameNode(value: 'movies'),
      variableDefinitions: [
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
        VariableDefinitionNode(
          variable: VariableNode(name: NameNode(value: 'sorting')),
          type: NamedTypeNode(
            name: NameNode(value: 'SortingEnum'),
            isNonNull: false,
          ),
          defaultValue: DefaultValueNode(value: null),
          directives: [],
        ),
        VariableDefinitionNode(
          variable: VariableNode(name: NameNode(value: 'sortingOrder')),
          type: NamedTypeNode(
            name: NameNode(value: 'SortingOrder'),
            isNonNull: false,
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
            name: NameNode(value: 'movies'),
            alias: null,
            arguments: [
              ArgumentNode(
                name: NameNode(value: 'page'),
                value: VariableNode(name: NameNode(value: 'page')),
              ),
              ArgumentNode(
                name: NameNode(value: 'size'),
                value: VariableNode(name: NameNode(value: 'size')),
              ),
              ArgumentNode(
                name: NameNode(value: 'sorting'),
                value: VariableNode(name: NameNode(value: 'sorting')),
              ),
              ArgumentNode(
                name: NameNode(value: 'sortingOrder'),
                value: VariableNode(name: NameNode(value: 'sortingOrder')),
              ),
              ArgumentNode(
                name: NameNode(value: 'libraryId'),
                value: VariableNode(name: NameNode(value: 'libraryId')),
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
    fragmentDefinitionfragmentImages,
    fragmentDefinitionfragmentMetadata,
  ],
);

class Query$movies$movies {
  Query$movies$movies({
    required this.number,
    required this.size,
    required this.totalElements,
    required this.totalPages,
    required this.content,
    this.$__typename = 'MoviePage',
  });

  factory Query$movies$movies.fromJson(Map<String, dynamic> json) {
    final l$number = json['number'];
    final l$size = json['size'];
    final l$totalElements = json['totalElements'];
    final l$totalPages = json['totalPages'];
    final l$content = json['content'];
    final l$$__typename = json['__typename'];
    return Query$movies$movies(
      number: (l$number as int),
      size: (l$size as int),
      totalElements: (l$totalElements as int),
      totalPages: (l$totalPages as int),
      content: (l$content as List<dynamic>)
          .map(
            (e) => Query$movies$movies$content.fromJson(
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

  final List<Query$movies$movies$content> content;

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
    if (other is! Query$movies$movies || runtimeType != other.runtimeType) {
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

extension UtilityExtension$Query$movies$movies on Query$movies$movies {
  CopyWith$Query$movies$movies<Query$movies$movies> get copyWith =>
      CopyWith$Query$movies$movies(this, (i) => i);
}

abstract class CopyWith$Query$movies$movies<TRes> {
  factory CopyWith$Query$movies$movies(
    Query$movies$movies instance,
    TRes Function(Query$movies$movies) then,
  ) = _CopyWithImpl$Query$movies$movies;

  factory CopyWith$Query$movies$movies.stub(TRes res) =
      _CopyWithStubImpl$Query$movies$movies;

  TRes call({
    int? number,
    int? size,
    int? totalElements,
    int? totalPages,
    List<Query$movies$movies$content>? content,
    String? $__typename,
  });
  TRes content(
    Iterable<Query$movies$movies$content> Function(
      Iterable<
        CopyWith$Query$movies$movies$content<Query$movies$movies$content>
      >,
    )
    _fn,
  );
}

class _CopyWithImpl$Query$movies$movies<TRes>
    implements CopyWith$Query$movies$movies<TRes> {
  _CopyWithImpl$Query$movies$movies(this._instance, this._then);

  final Query$movies$movies _instance;

  final TRes Function(Query$movies$movies) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? number = _undefined,
    Object? size = _undefined,
    Object? totalElements = _undefined,
    Object? totalPages = _undefined,
    Object? content = _undefined,
    Object? $__typename = _undefined,
  }) => _then(
    Query$movies$movies(
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
          : (content as List<Query$movies$movies$content>),
      $__typename: $__typename == _undefined || $__typename == null
          ? _instance.$__typename
          : ($__typename as String),
    ),
  );

  TRes content(
    Iterable<Query$movies$movies$content> Function(
      Iterable<
        CopyWith$Query$movies$movies$content<Query$movies$movies$content>
      >,
    )
    _fn,
  ) => call(
    content: _fn(
      _instance.content.map(
        (e) => CopyWith$Query$movies$movies$content(e, (i) => i),
      ),
    ).toList(),
  );
}

class _CopyWithStubImpl$Query$movies$movies<TRes>
    implements CopyWith$Query$movies$movies<TRes> {
  _CopyWithStubImpl$Query$movies$movies(this._res);

  TRes _res;

  call({
    int? number,
    int? size,
    int? totalElements,
    int? totalPages,
    List<Query$movies$movies$content>? content,
    String? $__typename,
  }) => _res;

  content(_fn) => _res;
}

class Query$movies$movies$content {
  Query$movies$movies$content({
    required this.id,
    required this.name,
    required this.releaseYear,
    this.images,
    this.metadata,
    this.$__typename = 'Movie',
  });

  factory Query$movies$movies$content.fromJson(Map<String, dynamic> json) {
    final l$id = json['id'];
    final l$name = json['name'];
    final l$releaseYear = json['releaseYear'];
    final l$images = json['images'];
    final l$metadata = json['metadata'];
    final l$$__typename = json['__typename'];
    return Query$movies$movies$content(
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
    if (other is! Query$movies$movies$content ||
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

extension UtilityExtension$Query$movies$movies$content
    on Query$movies$movies$content {
  CopyWith$Query$movies$movies$content<Query$movies$movies$content>
  get copyWith => CopyWith$Query$movies$movies$content(this, (i) => i);
}

abstract class CopyWith$Query$movies$movies$content<TRes> {
  factory CopyWith$Query$movies$movies$content(
    Query$movies$movies$content instance,
    TRes Function(Query$movies$movies$content) then,
  ) = _CopyWithImpl$Query$movies$movies$content;

  factory CopyWith$Query$movies$movies$content.stub(TRes res) =
      _CopyWithStubImpl$Query$movies$movies$content;

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

class _CopyWithImpl$Query$movies$movies$content<TRes>
    implements CopyWith$Query$movies$movies$content<TRes> {
  _CopyWithImpl$Query$movies$movies$content(this._instance, this._then);

  final Query$movies$movies$content _instance;

  final TRes Function(Query$movies$movies$content) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? id = _undefined,
    Object? name = _undefined,
    Object? releaseYear = _undefined,
    Object? images = _undefined,
    Object? metadata = _undefined,
    Object? $__typename = _undefined,
  }) => _then(
    Query$movies$movies$content(
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

class _CopyWithStubImpl$Query$movies$movies$content<TRes>
    implements CopyWith$Query$movies$movies$content<TRes> {
  _CopyWithStubImpl$Query$movies$movies$content(this._res);

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

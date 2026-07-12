import 'fragmentBook.graphql.dart';
import 'fragmentImages.graphql.dart';
import 'fragmentMetadata.graphql.dart';
import 'package:gql/ast.dart';
import 'schema.graphql.dart';

class Variables$Query$books {
  factory Variables$Query$books({
    int? page,
    int? size,
    Enum$SortingEnum? sorting,
    Enum$SortingOrder? sortingOrder,
    String? authorId,
    String? libraryId,
  }) => Variables$Query$books._({
    if (page != null) r'page': page,
    if (size != null) r'size': size,
    if (sorting != null) r'sorting': sorting,
    if (sortingOrder != null) r'sortingOrder': sortingOrder,
    if (authorId != null) r'authorId': authorId,
    if (libraryId != null) r'libraryId': libraryId,
  });

  Variables$Query$books._(this._$data);

  factory Variables$Query$books.fromJson(Map<String, dynamic> data) {
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
    if (data.containsKey('authorId')) {
      final l$authorId = data['authorId'];
      result$data['authorId'] = (l$authorId as String?);
    }
    if (data.containsKey('libraryId')) {
      final l$libraryId = data['libraryId'];
      result$data['libraryId'] = (l$libraryId as String?);
    }
    return Variables$Query$books._(result$data);
  }

  Map<String, dynamic> _$data;

  int? get page => (_$data['page'] as int?);

  int? get size => (_$data['size'] as int?);

  Enum$SortingEnum? get sorting => (_$data['sorting'] as Enum$SortingEnum?);

  Enum$SortingOrder? get sortingOrder =>
      (_$data['sortingOrder'] as Enum$SortingOrder?);

  String? get authorId => (_$data['authorId'] as String?);

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
    if (_$data.containsKey('authorId')) {
      final l$authorId = authorId;
      result$data['authorId'] = l$authorId;
    }
    if (_$data.containsKey('libraryId')) {
      final l$libraryId = libraryId;
      result$data['libraryId'] = l$libraryId;
    }
    return result$data;
  }

  CopyWith$Variables$Query$books<Variables$Query$books> get copyWith =>
      CopyWith$Variables$Query$books(this, (i) => i);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Variables$Query$books || runtimeType != other.runtimeType) {
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
    final l$authorId = authorId;
    final lOther$authorId = other.authorId;
    if (_$data.containsKey('authorId') !=
        other._$data.containsKey('authorId')) {
      return false;
    }
    if (l$authorId != lOther$authorId) {
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
    final l$authorId = authorId;
    final l$libraryId = libraryId;
    return Object.hashAll([
      _$data.containsKey('page') ? l$page : const {},
      _$data.containsKey('size') ? l$size : const {},
      _$data.containsKey('sorting') ? l$sorting : const {},
      _$data.containsKey('sortingOrder') ? l$sortingOrder : const {},
      _$data.containsKey('authorId') ? l$authorId : const {},
      _$data.containsKey('libraryId') ? l$libraryId : const {},
    ]);
  }
}

abstract class CopyWith$Variables$Query$books<TRes> {
  factory CopyWith$Variables$Query$books(
    Variables$Query$books instance,
    TRes Function(Variables$Query$books) then,
  ) = _CopyWithImpl$Variables$Query$books;

  factory CopyWith$Variables$Query$books.stub(TRes res) =
      _CopyWithStubImpl$Variables$Query$books;

  TRes call({
    int? page,
    int? size,
    Enum$SortingEnum? sorting,
    Enum$SortingOrder? sortingOrder,
    String? authorId,
    String? libraryId,
  });
}

class _CopyWithImpl$Variables$Query$books<TRes>
    implements CopyWith$Variables$Query$books<TRes> {
  _CopyWithImpl$Variables$Query$books(this._instance, this._then);

  final Variables$Query$books _instance;

  final TRes Function(Variables$Query$books) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? page = _undefined,
    Object? size = _undefined,
    Object? sorting = _undefined,
    Object? sortingOrder = _undefined,
    Object? authorId = _undefined,
    Object? libraryId = _undefined,
  }) => _then(
    Variables$Query$books._({
      ..._instance._$data,
      if (page != _undefined) 'page': (page as int?),
      if (size != _undefined) 'size': (size as int?),
      if (sorting != _undefined) 'sorting': (sorting as Enum$SortingEnum?),
      if (sortingOrder != _undefined)
        'sortingOrder': (sortingOrder as Enum$SortingOrder?),
      if (authorId != _undefined) 'authorId': (authorId as String?),
      if (libraryId != _undefined) 'libraryId': (libraryId as String?),
    }),
  );
}

class _CopyWithStubImpl$Variables$Query$books<TRes>
    implements CopyWith$Variables$Query$books<TRes> {
  _CopyWithStubImpl$Variables$Query$books(this._res);

  TRes _res;

  call({
    int? page,
    int? size,
    Enum$SortingEnum? sorting,
    Enum$SortingOrder? sortingOrder,
    String? authorId,
    String? libraryId,
  }) => _res;
}

class Query$books {
  Query$books({this.books, this.$__typename = 'Query'});

  factory Query$books.fromJson(Map<String, dynamic> json) {
    final l$books = json['books'];
    final l$$__typename = json['__typename'];
    return Query$books(
      books: l$books == null
          ? null
          : Query$books$books.fromJson((l$books as Map<String, dynamic>)),
      $__typename: (l$$__typename as String),
    );
  }

  final Query$books$books? books;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$books = books;
    _resultData['books'] = l$books?.toJson();
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$books = books;
    final l$$__typename = $__typename;
    return Object.hashAll([l$books, l$$__typename]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Query$books || runtimeType != other.runtimeType) {
      return false;
    }
    final l$books = books;
    final lOther$books = other.books;
    if (l$books != lOther$books) {
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

extension UtilityExtension$Query$books on Query$books {
  CopyWith$Query$books<Query$books> get copyWith =>
      CopyWith$Query$books(this, (i) => i);
}

abstract class CopyWith$Query$books<TRes> {
  factory CopyWith$Query$books(
    Query$books instance,
    TRes Function(Query$books) then,
  ) = _CopyWithImpl$Query$books;

  factory CopyWith$Query$books.stub(TRes res) = _CopyWithStubImpl$Query$books;

  TRes call({Query$books$books? books, String? $__typename});
  CopyWith$Query$books$books<TRes> get books;
}

class _CopyWithImpl$Query$books<TRes> implements CopyWith$Query$books<TRes> {
  _CopyWithImpl$Query$books(this._instance, this._then);

  final Query$books _instance;

  final TRes Function(Query$books) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({Object? books = _undefined, Object? $__typename = _undefined}) =>
      _then(
        Query$books(
          books: books == _undefined
              ? _instance.books
              : (books as Query$books$books?),
          $__typename: $__typename == _undefined || $__typename == null
              ? _instance.$__typename
              : ($__typename as String),
        ),
      );

  CopyWith$Query$books$books<TRes> get books {
    final local$books = _instance.books;
    return local$books == null
        ? CopyWith$Query$books$books.stub(_then(_instance))
        : CopyWith$Query$books$books(local$books, (e) => call(books: e));
  }
}

class _CopyWithStubImpl$Query$books<TRes>
    implements CopyWith$Query$books<TRes> {
  _CopyWithStubImpl$Query$books(this._res);

  TRes _res;

  call({Query$books$books? books, String? $__typename}) => _res;

  CopyWith$Query$books$books<TRes> get books =>
      CopyWith$Query$books$books.stub(_res);
}

const documentNodeQuerybooks = DocumentNode(
  definitions: [
    OperationDefinitionNode(
      type: OperationType.query,
      name: NameNode(value: 'books'),
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
          variable: VariableNode(name: NameNode(value: 'authorId')),
          type: NamedTypeNode(name: NameNode(value: 'ID'), isNonNull: false),
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
            name: NameNode(value: 'books'),
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
                name: NameNode(value: 'authorId'),
                value: VariableNode(name: NameNode(value: 'authorId')),
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
                  name: NameNode(value: 'content'),
                  alias: null,
                  arguments: [],
                  directives: [],
                  selectionSet: SelectionSetNode(
                    selections: [
                      FragmentSpreadNode(
                        name: NameNode(value: 'fragmentBook'),
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
    fragmentDefinitionfragmentBook,
    fragmentDefinitionfragmentImages,
    fragmentDefinitionfragmentMetadata,
  ],
);

class Query$books$books {
  Query$books$books({
    required this.content,
    required this.totalPages,
    required this.totalElements,
    required this.number,
    required this.size,
    this.$__typename = 'BookPage',
  });

  factory Query$books$books.fromJson(Map<String, dynamic> json) {
    final l$content = json['content'];
    final l$totalPages = json['totalPages'];
    final l$totalElements = json['totalElements'];
    final l$number = json['number'];
    final l$size = json['size'];
    final l$$__typename = json['__typename'];
    return Query$books$books(
      content: (l$content as List<dynamic>)
          .map(
            (e) => Fragment$fragmentBook.fromJson((e as Map<String, dynamic>)),
          )
          .toList(),
      totalPages: (l$totalPages as int),
      totalElements: (l$totalElements as int),
      number: (l$number as int),
      size: (l$size as int),
      $__typename: (l$$__typename as String),
    );
  }

  final List<Fragment$fragmentBook> content;

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
    if (other is! Query$books$books || runtimeType != other.runtimeType) {
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

extension UtilityExtension$Query$books$books on Query$books$books {
  CopyWith$Query$books$books<Query$books$books> get copyWith =>
      CopyWith$Query$books$books(this, (i) => i);
}

abstract class CopyWith$Query$books$books<TRes> {
  factory CopyWith$Query$books$books(
    Query$books$books instance,
    TRes Function(Query$books$books) then,
  ) = _CopyWithImpl$Query$books$books;

  factory CopyWith$Query$books$books.stub(TRes res) =
      _CopyWithStubImpl$Query$books$books;

  TRes call({
    List<Fragment$fragmentBook>? content,
    int? totalPages,
    int? totalElements,
    int? number,
    int? size,
    String? $__typename,
  });
  TRes content(
    Iterable<Fragment$fragmentBook> Function(
      Iterable<CopyWith$Fragment$fragmentBook<Fragment$fragmentBook>>,
    )
    _fn,
  );
}

class _CopyWithImpl$Query$books$books<TRes>
    implements CopyWith$Query$books$books<TRes> {
  _CopyWithImpl$Query$books$books(this._instance, this._then);

  final Query$books$books _instance;

  final TRes Function(Query$books$books) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? content = _undefined,
    Object? totalPages = _undefined,
    Object? totalElements = _undefined,
    Object? number = _undefined,
    Object? size = _undefined,
    Object? $__typename = _undefined,
  }) => _then(
    Query$books$books(
      content: content == _undefined || content == null
          ? _instance.content
          : (content as List<Fragment$fragmentBook>),
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
    Iterable<Fragment$fragmentBook> Function(
      Iterable<CopyWith$Fragment$fragmentBook<Fragment$fragmentBook>>,
    )
    _fn,
  ) => call(
    content: _fn(
      _instance.content.map((e) => CopyWith$Fragment$fragmentBook(e, (i) => i)),
    ).toList(),
  );
}

class _CopyWithStubImpl$Query$books$books<TRes>
    implements CopyWith$Query$books$books<TRes> {
  _CopyWithStubImpl$Query$books$books(this._res);

  TRes _res;

  call({
    List<Fragment$fragmentBook>? content,
    int? totalPages,
    int? totalElements,
    int? number,
    int? size,
    String? $__typename,
  }) => _res;

  content(_fn) => _res;
}

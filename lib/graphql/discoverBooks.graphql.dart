import 'fragmentBook.graphql.dart';
import 'fragmentImages.graphql.dart';
import 'fragmentMetadata.graphql.dart';

import 'package:gql/ast.dart';

class Variables$Query$discoverBooks {
  factory Variables$Query$discoverBooks({
    required String libraryId,
    int? limit,
  }) => Variables$Query$discoverBooks._({
    r'libraryId': libraryId,
    if (limit != null) r'limit': limit,
  });

  Variables$Query$discoverBooks._(this._$data);

  factory Variables$Query$discoverBooks.fromJson(Map<String, dynamic> data) {
    final result$data = <String, dynamic>{};
    final l$libraryId = data['libraryId'];
    result$data['libraryId'] = (l$libraryId as String);
    if (data.containsKey('limit')) {
      final l$limit = data['limit'];
      result$data['limit'] = (l$limit as int?);
    }
    return Variables$Query$discoverBooks._(result$data);
  }

  Map<String, dynamic> _$data;

  String get libraryId => (_$data['libraryId'] as String);

  int? get limit => (_$data['limit'] as int?);

  Map<String, dynamic> toJson() {
    final result$data = <String, dynamic>{};
    final l$libraryId = libraryId;
    result$data['libraryId'] = l$libraryId;
    if (_$data.containsKey('limit')) {
      final l$limit = limit;
      result$data['limit'] = l$limit;
    }
    return result$data;
  }

  CopyWith$Variables$Query$discoverBooks<Variables$Query$discoverBooks>
  get copyWith => CopyWith$Variables$Query$discoverBooks(this, (i) => i);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Variables$Query$discoverBooks ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$libraryId = libraryId;
    final lOther$libraryId = other.libraryId;
    if (l$libraryId != lOther$libraryId) {
      return false;
    }
    final l$limit = limit;
    final lOther$limit = other.limit;
    if (_$data.containsKey('limit') != other._$data.containsKey('limit')) {
      return false;
    }
    if (l$limit != lOther$limit) {
      return false;
    }
    return true;
  }

  @override
  int get hashCode {
    final l$libraryId = libraryId;
    final l$limit = limit;
    return Object.hashAll([
      l$libraryId,
      _$data.containsKey('limit') ? l$limit : const {},
    ]);
  }
}

abstract class CopyWith$Variables$Query$discoverBooks<TRes> {
  factory CopyWith$Variables$Query$discoverBooks(
    Variables$Query$discoverBooks instance,
    TRes Function(Variables$Query$discoverBooks) then,
  ) = _CopyWithImpl$Variables$Query$discoverBooks;

  factory CopyWith$Variables$Query$discoverBooks.stub(TRes res) =
      _CopyWithStubImpl$Variables$Query$discoverBooks;

  TRes call({String? libraryId, int? limit});
}

class _CopyWithImpl$Variables$Query$discoverBooks<TRes>
    implements CopyWith$Variables$Query$discoverBooks<TRes> {
  _CopyWithImpl$Variables$Query$discoverBooks(this._instance, this._then);

  final Variables$Query$discoverBooks _instance;

  final TRes Function(Variables$Query$discoverBooks) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({Object? libraryId = _undefined, Object? limit = _undefined}) =>
      _then(
        Variables$Query$discoverBooks._({
          ..._instance._$data,
          if (libraryId != _undefined && libraryId != null)
            'libraryId': (libraryId as String),
          if (limit != _undefined) 'limit': (limit as int?),
        }),
      );
}

class _CopyWithStubImpl$Variables$Query$discoverBooks<TRes>
    implements CopyWith$Variables$Query$discoverBooks<TRes> {
  _CopyWithStubImpl$Variables$Query$discoverBooks(this._res);

  TRes _res;

  call({String? libraryId, int? limit}) => _res;
}

class Query$discoverBooks {
  Query$discoverBooks({this.libraryById, this.$__typename = 'Query'});

  factory Query$discoverBooks.fromJson(Map<String, dynamic> json) {
    final l$libraryById = json['libraryById'];
    final l$$__typename = json['__typename'];
    return Query$discoverBooks(
      libraryById: l$libraryById == null
          ? null
          : Query$discoverBooks$libraryById.fromJson(
              (l$libraryById as Map<String, dynamic>),
            ),
      $__typename: (l$$__typename as String),
    );
  }

  final Query$discoverBooks$libraryById? libraryById;

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
    if (other is! Query$discoverBooks || runtimeType != other.runtimeType) {
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

extension UtilityExtension$Query$discoverBooks on Query$discoverBooks {
  CopyWith$Query$discoverBooks<Query$discoverBooks> get copyWith =>
      CopyWith$Query$discoverBooks(this, (i) => i);
}

abstract class CopyWith$Query$discoverBooks<TRes> {
  factory CopyWith$Query$discoverBooks(
    Query$discoverBooks instance,
    TRes Function(Query$discoverBooks) then,
  ) = _CopyWithImpl$Query$discoverBooks;

  factory CopyWith$Query$discoverBooks.stub(TRes res) =
      _CopyWithStubImpl$Query$discoverBooks;

  TRes call({
    Query$discoverBooks$libraryById? libraryById,
    String? $__typename,
  });
  CopyWith$Query$discoverBooks$libraryById<TRes> get libraryById;
}

class _CopyWithImpl$Query$discoverBooks<TRes>
    implements CopyWith$Query$discoverBooks<TRes> {
  _CopyWithImpl$Query$discoverBooks(this._instance, this._then);

  final Query$discoverBooks _instance;

  final TRes Function(Query$discoverBooks) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? libraryById = _undefined,
    Object? $__typename = _undefined,
  }) => _then(
    Query$discoverBooks(
      libraryById: libraryById == _undefined
          ? _instance.libraryById
          : (libraryById as Query$discoverBooks$libraryById?),
      $__typename: $__typename == _undefined || $__typename == null
          ? _instance.$__typename
          : ($__typename as String),
    ),
  );

  CopyWith$Query$discoverBooks$libraryById<TRes> get libraryById {
    final local$libraryById = _instance.libraryById;
    return local$libraryById == null
        ? CopyWith$Query$discoverBooks$libraryById.stub(_then(_instance))
        : CopyWith$Query$discoverBooks$libraryById(
            local$libraryById,
            (e) => call(libraryById: e),
          );
  }
}

class _CopyWithStubImpl$Query$discoverBooks<TRes>
    implements CopyWith$Query$discoverBooks<TRes> {
  _CopyWithStubImpl$Query$discoverBooks(this._res);

  TRes _res;

  call({Query$discoverBooks$libraryById? libraryById, String? $__typename}) =>
      _res;

  CopyWith$Query$discoverBooks$libraryById<TRes> get libraryById =>
      CopyWith$Query$discoverBooks$libraryById.stub(_res);
}

const documentNodeQuerydiscoverBooks = DocumentNode(
  definitions: [
    OperationDefinitionNode(
      type: OperationType.query,
      name: NameNode(value: 'discoverBooks'),
      variableDefinitions: [
        VariableDefinitionNode(
          variable: VariableNode(name: NameNode(value: 'libraryId')),
          type: NamedTypeNode(name: NameNode(value: 'ID'), isNonNull: true),
          defaultValue: DefaultValueNode(value: null),
          directives: [],
        ),
        VariableDefinitionNode(
          variable: VariableNode(name: NameNode(value: 'limit')),
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
                  name: NameNode(value: 'recentlyReadBooks'),
                  alias: null,
                  arguments: [
                    ArgumentNode(
                      name: NameNode(value: 'limit'),
                      value: VariableNode(name: NameNode(value: 'limit')),
                    ),
                  ],
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
                  name: NameNode(value: 'highestRatedBooks'),
                  alias: null,
                  arguments: [
                    ArgumentNode(
                      name: NameNode(value: 'limit'),
                      value: VariableNode(name: NameNode(value: 'limit')),
                    ),
                  ],
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

class Query$discoverBooks$libraryById {
  Query$discoverBooks$libraryById({
    required this.id,
    required this.recentlyReadBooks,
    required this.highestRatedBooks,
    this.$__typename = 'Library',
  });

  factory Query$discoverBooks$libraryById.fromJson(Map<String, dynamic> json) {
    final l$id = json['id'];
    final l$recentlyReadBooks = json['recentlyReadBooks'];
    final l$highestRatedBooks = json['highestRatedBooks'];
    final l$$__typename = json['__typename'];
    return Query$discoverBooks$libraryById(
      id: (l$id as String),
      recentlyReadBooks: (l$recentlyReadBooks as List<dynamic>)
          .map(
            (e) => Fragment$fragmentBook.fromJson((e as Map<String, dynamic>)),
          )
          .toList(),
      highestRatedBooks: (l$highestRatedBooks as List<dynamic>)
          .map(
            (e) => Fragment$fragmentBook.fromJson((e as Map<String, dynamic>)),
          )
          .toList(),
      $__typename: (l$$__typename as String),
    );
  }

  final String id;

  final List<Fragment$fragmentBook> recentlyReadBooks;

  final List<Fragment$fragmentBook> highestRatedBooks;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$id = id;
    _resultData['id'] = l$id;
    final l$recentlyReadBooks = recentlyReadBooks;
    _resultData['recentlyReadBooks'] = l$recentlyReadBooks
        .map((e) => e.toJson())
        .toList();
    final l$highestRatedBooks = highestRatedBooks;
    _resultData['highestRatedBooks'] = l$highestRatedBooks
        .map((e) => e.toJson())
        .toList();
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$id = id;
    final l$recentlyReadBooks = recentlyReadBooks;
    final l$highestRatedBooks = highestRatedBooks;
    final l$$__typename = $__typename;
    return Object.hashAll([
      l$id,
      Object.hashAll(l$recentlyReadBooks.map((v) => v)),
      Object.hashAll(l$highestRatedBooks.map((v) => v)),
      l$$__typename,
    ]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Query$discoverBooks$libraryById ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$id = id;
    final lOther$id = other.id;
    if (l$id != lOther$id) {
      return false;
    }
    final l$recentlyReadBooks = recentlyReadBooks;
    final lOther$recentlyReadBooks = other.recentlyReadBooks;
    if (l$recentlyReadBooks.length != lOther$recentlyReadBooks.length) {
      return false;
    }
    for (int i = 0; i < l$recentlyReadBooks.length; i++) {
      final l$recentlyReadBooks$entry = l$recentlyReadBooks[i];
      final lOther$recentlyReadBooks$entry = lOther$recentlyReadBooks[i];
      if (l$recentlyReadBooks$entry != lOther$recentlyReadBooks$entry) {
        return false;
      }
    }
    final l$highestRatedBooks = highestRatedBooks;
    final lOther$highestRatedBooks = other.highestRatedBooks;
    if (l$highestRatedBooks.length != lOther$highestRatedBooks.length) {
      return false;
    }
    for (int i = 0; i < l$highestRatedBooks.length; i++) {
      final l$highestRatedBooks$entry = l$highestRatedBooks[i];
      final lOther$highestRatedBooks$entry = lOther$highestRatedBooks[i];
      if (l$highestRatedBooks$entry != lOther$highestRatedBooks$entry) {
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

extension UtilityExtension$Query$discoverBooks$libraryById
    on Query$discoverBooks$libraryById {
  CopyWith$Query$discoverBooks$libraryById<Query$discoverBooks$libraryById>
  get copyWith => CopyWith$Query$discoverBooks$libraryById(this, (i) => i);
}

abstract class CopyWith$Query$discoverBooks$libraryById<TRes> {
  factory CopyWith$Query$discoverBooks$libraryById(
    Query$discoverBooks$libraryById instance,
    TRes Function(Query$discoverBooks$libraryById) then,
  ) = _CopyWithImpl$Query$discoverBooks$libraryById;

  factory CopyWith$Query$discoverBooks$libraryById.stub(TRes res) =
      _CopyWithStubImpl$Query$discoverBooks$libraryById;

  TRes call({
    String? id,
    List<Fragment$fragmentBook>? recentlyReadBooks,
    List<Fragment$fragmentBook>? highestRatedBooks,
    String? $__typename,
  });
  TRes recentlyReadBooks(
    Iterable<Fragment$fragmentBook> Function(
      Iterable<CopyWith$Fragment$fragmentBook<Fragment$fragmentBook>>,
    )
    _fn,
  );
  TRes highestRatedBooks(
    Iterable<Fragment$fragmentBook> Function(
      Iterable<CopyWith$Fragment$fragmentBook<Fragment$fragmentBook>>,
    )
    _fn,
  );
}

class _CopyWithImpl$Query$discoverBooks$libraryById<TRes>
    implements CopyWith$Query$discoverBooks$libraryById<TRes> {
  _CopyWithImpl$Query$discoverBooks$libraryById(this._instance, this._then);

  final Query$discoverBooks$libraryById _instance;

  final TRes Function(Query$discoverBooks$libraryById) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? id = _undefined,
    Object? recentlyReadBooks = _undefined,
    Object? highestRatedBooks = _undefined,
    Object? $__typename = _undefined,
  }) => _then(
    Query$discoverBooks$libraryById(
      id: id == _undefined || id == null ? _instance.id : (id as String),
      recentlyReadBooks:
          recentlyReadBooks == _undefined || recentlyReadBooks == null
          ? _instance.recentlyReadBooks
          : (recentlyReadBooks as List<Fragment$fragmentBook>),
      highestRatedBooks:
          highestRatedBooks == _undefined || highestRatedBooks == null
          ? _instance.highestRatedBooks
          : (highestRatedBooks as List<Fragment$fragmentBook>),
      $__typename: $__typename == _undefined || $__typename == null
          ? _instance.$__typename
          : ($__typename as String),
    ),
  );

  TRes recentlyReadBooks(
    Iterable<Fragment$fragmentBook> Function(
      Iterable<CopyWith$Fragment$fragmentBook<Fragment$fragmentBook>>,
    )
    _fn,
  ) => call(
    recentlyReadBooks: _fn(
      _instance.recentlyReadBooks.map(
        (e) => CopyWith$Fragment$fragmentBook(e, (i) => i),
      ),
    ).toList(),
  );

  TRes highestRatedBooks(
    Iterable<Fragment$fragmentBook> Function(
      Iterable<CopyWith$Fragment$fragmentBook<Fragment$fragmentBook>>,
    )
    _fn,
  ) => call(
    highestRatedBooks: _fn(
      _instance.highestRatedBooks.map(
        (e) => CopyWith$Fragment$fragmentBook(e, (i) => i),
      ),
    ).toList(),
  );
}

class _CopyWithStubImpl$Query$discoverBooks$libraryById<TRes>
    implements CopyWith$Query$discoverBooks$libraryById<TRes> {
  _CopyWithStubImpl$Query$discoverBooks$libraryById(this._res);

  TRes _res;

  call({
    String? id,
    List<Fragment$fragmentBook>? recentlyReadBooks,
    List<Fragment$fragmentBook>? highestRatedBooks,
    String? $__typename,
  }) => _res;

  recentlyReadBooks(_fn) => _res;

  highestRatedBooks(_fn) => _res;
}

import 'package:gql/ast.dart';
import 'schema.graphql.dart';

class Variables$Query$seriesReadingDirection {
  factory Variables$Query$seriesReadingDirection({String? id}) =>
      Variables$Query$seriesReadingDirection._({if (id != null) r'id': id});

  Variables$Query$seriesReadingDirection._(this._$data);

  factory Variables$Query$seriesReadingDirection.fromJson(
    Map<String, dynamic> data,
  ) {
    final result$data = <String, dynamic>{};
    if (data.containsKey('id')) {
      final l$id = data['id'];
      result$data['id'] = (l$id as String?);
    }
    return Variables$Query$seriesReadingDirection._(result$data);
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

  CopyWith$Variables$Query$seriesReadingDirection<
    Variables$Query$seriesReadingDirection
  >
  get copyWith =>
      CopyWith$Variables$Query$seriesReadingDirection(this, (i) => i);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Variables$Query$seriesReadingDirection ||
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

abstract class CopyWith$Variables$Query$seriesReadingDirection<TRes> {
  factory CopyWith$Variables$Query$seriesReadingDirection(
    Variables$Query$seriesReadingDirection instance,
    TRes Function(Variables$Query$seriesReadingDirection) then,
  ) = _CopyWithImpl$Variables$Query$seriesReadingDirection;

  factory CopyWith$Variables$Query$seriesReadingDirection.stub(TRes res) =
      _CopyWithStubImpl$Variables$Query$seriesReadingDirection;

  TRes call({String? id});
}

class _CopyWithImpl$Variables$Query$seriesReadingDirection<TRes>
    implements CopyWith$Variables$Query$seriesReadingDirection<TRes> {
  _CopyWithImpl$Variables$Query$seriesReadingDirection(
    this._instance,
    this._then,
  );

  final Variables$Query$seriesReadingDirection _instance;

  final TRes Function(Variables$Query$seriesReadingDirection) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({Object? id = _undefined}) => _then(
    Variables$Query$seriesReadingDirection._({
      ..._instance._$data,
      if (id != _undefined) 'id': (id as String?),
    }),
  );
}

class _CopyWithStubImpl$Variables$Query$seriesReadingDirection<TRes>
    implements CopyWith$Variables$Query$seriesReadingDirection<TRes> {
  _CopyWithStubImpl$Variables$Query$seriesReadingDirection(this._res);

  TRes _res;

  call({String? id}) => _res;
}

class Query$seriesReadingDirection {
  Query$seriesReadingDirection({this.seriesById, this.$__typename = 'Query'});

  factory Query$seriesReadingDirection.fromJson(Map<String, dynamic> json) {
    final l$seriesById = json['seriesById'];
    final l$$__typename = json['__typename'];
    return Query$seriesReadingDirection(
      seriesById: l$seriesById == null
          ? null
          : Query$seriesReadingDirection$seriesById.fromJson(
              (l$seriesById as Map<String, dynamic>),
            ),
      $__typename: (l$$__typename as String),
    );
  }

  final Query$seriesReadingDirection$seriesById? seriesById;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$seriesById = seriesById;
    _resultData['seriesById'] = l$seriesById?.toJson();
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$seriesById = seriesById;
    final l$$__typename = $__typename;
    return Object.hashAll([l$seriesById, l$$__typename]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Query$seriesReadingDirection ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$seriesById = seriesById;
    final lOther$seriesById = other.seriesById;
    if (l$seriesById != lOther$seriesById) {
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

extension UtilityExtension$Query$seriesReadingDirection
    on Query$seriesReadingDirection {
  CopyWith$Query$seriesReadingDirection<Query$seriesReadingDirection>
  get copyWith => CopyWith$Query$seriesReadingDirection(this, (i) => i);
}

abstract class CopyWith$Query$seriesReadingDirection<TRes> {
  factory CopyWith$Query$seriesReadingDirection(
    Query$seriesReadingDirection instance,
    TRes Function(Query$seriesReadingDirection) then,
  ) = _CopyWithImpl$Query$seriesReadingDirection;

  factory CopyWith$Query$seriesReadingDirection.stub(TRes res) =
      _CopyWithStubImpl$Query$seriesReadingDirection;

  TRes call({
    Query$seriesReadingDirection$seriesById? seriesById,
    String? $__typename,
  });
  CopyWith$Query$seriesReadingDirection$seriesById<TRes> get seriesById;
}

class _CopyWithImpl$Query$seriesReadingDirection<TRes>
    implements CopyWith$Query$seriesReadingDirection<TRes> {
  _CopyWithImpl$Query$seriesReadingDirection(this._instance, this._then);

  final Query$seriesReadingDirection _instance;

  final TRes Function(Query$seriesReadingDirection) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? seriesById = _undefined,
    Object? $__typename = _undefined,
  }) => _then(
    Query$seriesReadingDirection(
      seriesById: seriesById == _undefined
          ? _instance.seriesById
          : (seriesById as Query$seriesReadingDirection$seriesById?),
      $__typename: $__typename == _undefined || $__typename == null
          ? _instance.$__typename
          : ($__typename as String),
    ),
  );

  CopyWith$Query$seriesReadingDirection$seriesById<TRes> get seriesById {
    final local$seriesById = _instance.seriesById;
    return local$seriesById == null
        ? CopyWith$Query$seriesReadingDirection$seriesById.stub(
            _then(_instance),
          )
        : CopyWith$Query$seriesReadingDirection$seriesById(
            local$seriesById,
            (e) => call(seriesById: e),
          );
  }
}

class _CopyWithStubImpl$Query$seriesReadingDirection<TRes>
    implements CopyWith$Query$seriesReadingDirection<TRes> {
  _CopyWithStubImpl$Query$seriesReadingDirection(this._res);

  TRes _res;

  call({
    Query$seriesReadingDirection$seriesById? seriesById,
    String? $__typename,
  }) => _res;

  CopyWith$Query$seriesReadingDirection$seriesById<TRes> get seriesById =>
      CopyWith$Query$seriesReadingDirection$seriesById.stub(_res);
}

const documentNodeQueryseriesReadingDirection = DocumentNode(
  definitions: [
    OperationDefinitionNode(
      type: OperationType.query,
      name: NameNode(value: 'seriesReadingDirection'),
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
            name: NameNode(value: 'seriesById'),
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
                  name: NameNode(value: 'readingDirection'),
                  alias: null,
                  arguments: [],
                  directives: [],
                  selectionSet: null,
                ),
                FieldNode(
                  name: NameNode(value: 'books'),
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
                        name: NameNode(value: 'title'),
                        alias: null,
                        arguments: [],
                        directives: [],
                        selectionSet: null,
                      ),
                      FieldNode(
                        name: NameNode(value: 'seriesIndex'),
                        alias: null,
                        arguments: [],
                        directives: [],
                        selectionSet: null,
                      ),
                      FieldNode(
                        name: NameNode(value: 'epubFiles'),
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
                              name: NameNode(value: 'format'),
                              alias: null,
                              arguments: [],
                              directives: [],
                              selectionSet: null,
                            ),
                            FieldNode(
                              name: NameNode(value: 'directory'),
                              alias: null,
                              arguments: [],
                              directives: [],
                              selectionSet: SelectionSetNode(
                                selections: [
                                  FieldNode(
                                    name: NameNode(value: 'node'),
                                    alias: null,
                                    arguments: [],
                                    directives: [],
                                    selectionSet: SelectionSetNode(
                                      selections: [
                                        FieldNode(
                                          name: NameNode(value: 'url'),
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
  ],
);

class Query$seriesReadingDirection$seriesById {
  Query$seriesReadingDirection$seriesById({
    required this.id,
    required this.readingDirection,
    required this.books,
    this.$__typename = 'Series',
  });

  factory Query$seriesReadingDirection$seriesById.fromJson(
    Map<String, dynamic> json,
  ) {
    final l$id = json['id'];
    final l$readingDirection = json['readingDirection'];
    final l$books = json['books'];
    final l$$__typename = json['__typename'];
    return Query$seriesReadingDirection$seriesById(
      id: (l$id as String),
      readingDirection: fromJson$Enum$ReadingDirection(
        (l$readingDirection as String),
      ),
      books: (l$books as List<dynamic>)
          .map(
            (e) => Query$seriesReadingDirection$seriesById$books.fromJson(
              (e as Map<String, dynamic>),
            ),
          )
          .toList(),
      $__typename: (l$$__typename as String),
    );
  }

  final String id;

  final Enum$ReadingDirection readingDirection;

  final List<Query$seriesReadingDirection$seriesById$books> books;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$id = id;
    _resultData['id'] = l$id;
    final l$readingDirection = readingDirection;
    _resultData['readingDirection'] = toJson$Enum$ReadingDirection(
      l$readingDirection,
    );
    final l$books = books;
    _resultData['books'] = l$books.map((e) => e.toJson()).toList();
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$id = id;
    final l$readingDirection = readingDirection;
    final l$books = books;
    final l$$__typename = $__typename;
    return Object.hashAll([
      l$id,
      l$readingDirection,
      Object.hashAll(l$books.map((v) => v)),
      l$$__typename,
    ]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Query$seriesReadingDirection$seriesById ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$id = id;
    final lOther$id = other.id;
    if (l$id != lOther$id) {
      return false;
    }
    final l$readingDirection = readingDirection;
    final lOther$readingDirection = other.readingDirection;
    if (l$readingDirection != lOther$readingDirection) {
      return false;
    }
    final l$books = books;
    final lOther$books = other.books;
    if (l$books.length != lOther$books.length) {
      return false;
    }
    for (int i = 0; i < l$books.length; i++) {
      final l$books$entry = l$books[i];
      final lOther$books$entry = lOther$books[i];
      if (l$books$entry != lOther$books$entry) {
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

extension UtilityExtension$Query$seriesReadingDirection$seriesById
    on Query$seriesReadingDirection$seriesById {
  CopyWith$Query$seriesReadingDirection$seriesById<
    Query$seriesReadingDirection$seriesById
  >
  get copyWith =>
      CopyWith$Query$seriesReadingDirection$seriesById(this, (i) => i);
}

abstract class CopyWith$Query$seriesReadingDirection$seriesById<TRes> {
  factory CopyWith$Query$seriesReadingDirection$seriesById(
    Query$seriesReadingDirection$seriesById instance,
    TRes Function(Query$seriesReadingDirection$seriesById) then,
  ) = _CopyWithImpl$Query$seriesReadingDirection$seriesById;

  factory CopyWith$Query$seriesReadingDirection$seriesById.stub(TRes res) =
      _CopyWithStubImpl$Query$seriesReadingDirection$seriesById;

  TRes call({
    String? id,
    Enum$ReadingDirection? readingDirection,
    List<Query$seriesReadingDirection$seriesById$books>? books,
    String? $__typename,
  });
  TRes books(
    Iterable<Query$seriesReadingDirection$seriesById$books> Function(
      Iterable<
        CopyWith$Query$seriesReadingDirection$seriesById$books<
          Query$seriesReadingDirection$seriesById$books
        >
      >,
    )
    _fn,
  );
}

class _CopyWithImpl$Query$seriesReadingDirection$seriesById<TRes>
    implements CopyWith$Query$seriesReadingDirection$seriesById<TRes> {
  _CopyWithImpl$Query$seriesReadingDirection$seriesById(
    this._instance,
    this._then,
  );

  final Query$seriesReadingDirection$seriesById _instance;

  final TRes Function(Query$seriesReadingDirection$seriesById) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? id = _undefined,
    Object? readingDirection = _undefined,
    Object? books = _undefined,
    Object? $__typename = _undefined,
  }) => _then(
    Query$seriesReadingDirection$seriesById(
      id: id == _undefined || id == null ? _instance.id : (id as String),
      readingDirection:
          readingDirection == _undefined || readingDirection == null
          ? _instance.readingDirection
          : (readingDirection as Enum$ReadingDirection),
      books: books == _undefined || books == null
          ? _instance.books
          : (books as List<Query$seriesReadingDirection$seriesById$books>),
      $__typename: $__typename == _undefined || $__typename == null
          ? _instance.$__typename
          : ($__typename as String),
    ),
  );

  TRes books(
    Iterable<Query$seriesReadingDirection$seriesById$books> Function(
      Iterable<
        CopyWith$Query$seriesReadingDirection$seriesById$books<
          Query$seriesReadingDirection$seriesById$books
        >
      >,
    )
    _fn,
  ) => call(
    books: _fn(
      _instance.books.map(
        (e) =>
            CopyWith$Query$seriesReadingDirection$seriesById$books(e, (i) => i),
      ),
    ).toList(),
  );
}

class _CopyWithStubImpl$Query$seriesReadingDirection$seriesById<TRes>
    implements CopyWith$Query$seriesReadingDirection$seriesById<TRes> {
  _CopyWithStubImpl$Query$seriesReadingDirection$seriesById(this._res);

  TRes _res;

  call({
    String? id,
    Enum$ReadingDirection? readingDirection,
    List<Query$seriesReadingDirection$seriesById$books>? books,
    String? $__typename,
  }) => _res;

  books(_fn) => _res;
}

class Query$seriesReadingDirection$seriesById$books {
  Query$seriesReadingDirection$seriesById$books({
    required this.id,
    required this.title,
    this.seriesIndex,
    this.epubFiles,
    this.$__typename = 'Book',
  });

  factory Query$seriesReadingDirection$seriesById$books.fromJson(
    Map<String, dynamic> json,
  ) {
    final l$id = json['id'];
    final l$title = json['title'];
    final l$seriesIndex = json['seriesIndex'];
    final l$epubFiles = json['epubFiles'];
    final l$$__typename = json['__typename'];
    return Query$seriesReadingDirection$seriesById$books(
      id: (l$id as String),
      title: (l$title as String),
      seriesIndex: (l$seriesIndex as num?)?.toDouble(),
      epubFiles: (l$epubFiles as List<dynamic>?)
          ?.map(
            (e) =>
                Query$seriesReadingDirection$seriesById$books$epubFiles.fromJson(
                  (e as Map<String, dynamic>),
                ),
          )
          .toList(),
      $__typename: (l$$__typename as String),
    );
  }

  final String id;

  final String title;

  final double? seriesIndex;

  final List<Query$seriesReadingDirection$seriesById$books$epubFiles>?
  epubFiles;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$id = id;
    _resultData['id'] = l$id;
    final l$title = title;
    _resultData['title'] = l$title;
    final l$seriesIndex = seriesIndex;
    _resultData['seriesIndex'] = l$seriesIndex;
    final l$epubFiles = epubFiles;
    _resultData['epubFiles'] = l$epubFiles?.map((e) => e.toJson()).toList();
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$id = id;
    final l$title = title;
    final l$seriesIndex = seriesIndex;
    final l$epubFiles = epubFiles;
    final l$$__typename = $__typename;
    return Object.hashAll([
      l$id,
      l$title,
      l$seriesIndex,
      l$epubFiles == null ? null : Object.hashAll(l$epubFiles.map((v) => v)),
      l$$__typename,
    ]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Query$seriesReadingDirection$seriesById$books ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$id = id;
    final lOther$id = other.id;
    if (l$id != lOther$id) {
      return false;
    }
    final l$title = title;
    final lOther$title = other.title;
    if (l$title != lOther$title) {
      return false;
    }
    final l$seriesIndex = seriesIndex;
    final lOther$seriesIndex = other.seriesIndex;
    if (l$seriesIndex != lOther$seriesIndex) {
      return false;
    }
    final l$epubFiles = epubFiles;
    final lOther$epubFiles = other.epubFiles;
    if (l$epubFiles != null && lOther$epubFiles != null) {
      if (l$epubFiles.length != lOther$epubFiles.length) {
        return false;
      }
      for (int i = 0; i < l$epubFiles.length; i++) {
        final l$epubFiles$entry = l$epubFiles[i];
        final lOther$epubFiles$entry = lOther$epubFiles[i];
        if (l$epubFiles$entry != lOther$epubFiles$entry) {
          return false;
        }
      }
    } else if (l$epubFiles != lOther$epubFiles) {
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

extension UtilityExtension$Query$seriesReadingDirection$seriesById$books
    on Query$seriesReadingDirection$seriesById$books {
  CopyWith$Query$seriesReadingDirection$seriesById$books<
    Query$seriesReadingDirection$seriesById$books
  >
  get copyWith =>
      CopyWith$Query$seriesReadingDirection$seriesById$books(this, (i) => i);
}

abstract class CopyWith$Query$seriesReadingDirection$seriesById$books<TRes> {
  factory CopyWith$Query$seriesReadingDirection$seriesById$books(
    Query$seriesReadingDirection$seriesById$books instance,
    TRes Function(Query$seriesReadingDirection$seriesById$books) then,
  ) = _CopyWithImpl$Query$seriesReadingDirection$seriesById$books;

  factory CopyWith$Query$seriesReadingDirection$seriesById$books.stub(
    TRes res,
  ) = _CopyWithStubImpl$Query$seriesReadingDirection$seriesById$books;

  TRes call({
    String? id,
    String? title,
    double? seriesIndex,
    List<Query$seriesReadingDirection$seriesById$books$epubFiles>? epubFiles,
    String? $__typename,
  });
  TRes epubFiles(
    Iterable<Query$seriesReadingDirection$seriesById$books$epubFiles>? Function(
      Iterable<
        CopyWith$Query$seriesReadingDirection$seriesById$books$epubFiles<
          Query$seriesReadingDirection$seriesById$books$epubFiles
        >
      >?,
    )
    _fn,
  );
}

class _CopyWithImpl$Query$seriesReadingDirection$seriesById$books<TRes>
    implements CopyWith$Query$seriesReadingDirection$seriesById$books<TRes> {
  _CopyWithImpl$Query$seriesReadingDirection$seriesById$books(
    this._instance,
    this._then,
  );

  final Query$seriesReadingDirection$seriesById$books _instance;

  final TRes Function(Query$seriesReadingDirection$seriesById$books) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? id = _undefined,
    Object? title = _undefined,
    Object? seriesIndex = _undefined,
    Object? epubFiles = _undefined,
    Object? $__typename = _undefined,
  }) => _then(
    Query$seriesReadingDirection$seriesById$books(
      id: id == _undefined || id == null ? _instance.id : (id as String),
      title: title == _undefined || title == null
          ? _instance.title
          : (title as String),
      seriesIndex: seriesIndex == _undefined
          ? _instance.seriesIndex
          : (seriesIndex as double?),
      epubFiles: epubFiles == _undefined
          ? _instance.epubFiles
          : (epubFiles
                as List<
                  Query$seriesReadingDirection$seriesById$books$epubFiles
                >?),
      $__typename: $__typename == _undefined || $__typename == null
          ? _instance.$__typename
          : ($__typename as String),
    ),
  );

  TRes epubFiles(
    Iterable<Query$seriesReadingDirection$seriesById$books$epubFiles>? Function(
      Iterable<
        CopyWith$Query$seriesReadingDirection$seriesById$books$epubFiles<
          Query$seriesReadingDirection$seriesById$books$epubFiles
        >
      >?,
    )
    _fn,
  ) => call(
    epubFiles: _fn(
      _instance.epubFiles?.map(
        (e) => CopyWith$Query$seriesReadingDirection$seriesById$books$epubFiles(
          e,
          (i) => i,
        ),
      ),
    )?.toList(),
  );
}

class _CopyWithStubImpl$Query$seriesReadingDirection$seriesById$books<TRes>
    implements CopyWith$Query$seriesReadingDirection$seriesById$books<TRes> {
  _CopyWithStubImpl$Query$seriesReadingDirection$seriesById$books(this._res);

  TRes _res;

  call({
    String? id,
    String? title,
    double? seriesIndex,
    List<Query$seriesReadingDirection$seriesById$books$epubFiles>? epubFiles,
    String? $__typename,
  }) => _res;

  epubFiles(_fn) => _res;
}

class Query$seriesReadingDirection$seriesById$books$epubFiles {
  Query$seriesReadingDirection$seriesById$books$epubFiles({
    required this.id,
    this.format,
    required this.directory,
    this.$__typename = 'MediaFile',
  });

  factory Query$seriesReadingDirection$seriesById$books$epubFiles.fromJson(
    Map<String, dynamic> json,
  ) {
    final l$id = json['id'];
    final l$format = json['format'];
    final l$directory = json['directory'];
    final l$$__typename = json['__typename'];
    return Query$seriesReadingDirection$seriesById$books$epubFiles(
      id: (l$id as String),
      format: (l$format as String?),
      directory:
          Query$seriesReadingDirection$seriesById$books$epubFiles$directory.fromJson(
            (l$directory as Map<String, dynamic>),
          ),
      $__typename: (l$$__typename as String),
    );
  }

  final String id;

  final String? format;

  final Query$seriesReadingDirection$seriesById$books$epubFiles$directory
  directory;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$id = id;
    _resultData['id'] = l$id;
    final l$format = format;
    _resultData['format'] = l$format;
    final l$directory = directory;
    _resultData['directory'] = l$directory.toJson();
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$id = id;
    final l$format = format;
    final l$directory = directory;
    final l$$__typename = $__typename;
    return Object.hashAll([l$id, l$format, l$directory, l$$__typename]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Query$seriesReadingDirection$seriesById$books$epubFiles ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$id = id;
    final lOther$id = other.id;
    if (l$id != lOther$id) {
      return false;
    }
    final l$format = format;
    final lOther$format = other.format;
    if (l$format != lOther$format) {
      return false;
    }
    final l$directory = directory;
    final lOther$directory = other.directory;
    if (l$directory != lOther$directory) {
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

extension UtilityExtension$Query$seriesReadingDirection$seriesById$books$epubFiles
    on Query$seriesReadingDirection$seriesById$books$epubFiles {
  CopyWith$Query$seriesReadingDirection$seriesById$books$epubFiles<
    Query$seriesReadingDirection$seriesById$books$epubFiles
  >
  get copyWith =>
      CopyWith$Query$seriesReadingDirection$seriesById$books$epubFiles(
        this,
        (i) => i,
      );
}

abstract class CopyWith$Query$seriesReadingDirection$seriesById$books$epubFiles<
  TRes
> {
  factory CopyWith$Query$seriesReadingDirection$seriesById$books$epubFiles(
    Query$seriesReadingDirection$seriesById$books$epubFiles instance,
    TRes Function(Query$seriesReadingDirection$seriesById$books$epubFiles) then,
  ) = _CopyWithImpl$Query$seriesReadingDirection$seriesById$books$epubFiles;

  factory CopyWith$Query$seriesReadingDirection$seriesById$books$epubFiles.stub(
    TRes res,
  ) = _CopyWithStubImpl$Query$seriesReadingDirection$seriesById$books$epubFiles;

  TRes call({
    String? id,
    String? format,
    Query$seriesReadingDirection$seriesById$books$epubFiles$directory?
    directory,
    String? $__typename,
  });
  CopyWith$Query$seriesReadingDirection$seriesById$books$epubFiles$directory<
    TRes
  >
  get directory;
}

class _CopyWithImpl$Query$seriesReadingDirection$seriesById$books$epubFiles<
  TRes
>
    implements
        CopyWith$Query$seriesReadingDirection$seriesById$books$epubFiles<TRes> {
  _CopyWithImpl$Query$seriesReadingDirection$seriesById$books$epubFiles(
    this._instance,
    this._then,
  );

  final Query$seriesReadingDirection$seriesById$books$epubFiles _instance;

  final TRes Function(Query$seriesReadingDirection$seriesById$books$epubFiles)
  _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? id = _undefined,
    Object? format = _undefined,
    Object? directory = _undefined,
    Object? $__typename = _undefined,
  }) => _then(
    Query$seriesReadingDirection$seriesById$books$epubFiles(
      id: id == _undefined || id == null ? _instance.id : (id as String),
      format: format == _undefined ? _instance.format : (format as String?),
      directory: directory == _undefined || directory == null
          ? _instance.directory
          : (directory
                as Query$seriesReadingDirection$seriesById$books$epubFiles$directory),
      $__typename: $__typename == _undefined || $__typename == null
          ? _instance.$__typename
          : ($__typename as String),
    ),
  );

  CopyWith$Query$seriesReadingDirection$seriesById$books$epubFiles$directory<
    TRes
  >
  get directory {
    final local$directory = _instance.directory;
    return CopyWith$Query$seriesReadingDirection$seriesById$books$epubFiles$directory(
      local$directory,
      (e) => call(directory: e),
    );
  }
}

class _CopyWithStubImpl$Query$seriesReadingDirection$seriesById$books$epubFiles<
  TRes
>
    implements
        CopyWith$Query$seriesReadingDirection$seriesById$books$epubFiles<TRes> {
  _CopyWithStubImpl$Query$seriesReadingDirection$seriesById$books$epubFiles(
    this._res,
  );

  TRes _res;

  call({
    String? id,
    String? format,
    Query$seriesReadingDirection$seriesById$books$epubFiles$directory?
    directory,
    String? $__typename,
  }) => _res;

  CopyWith$Query$seriesReadingDirection$seriesById$books$epubFiles$directory<
    TRes
  >
  get directory =>
      CopyWith$Query$seriesReadingDirection$seriesById$books$epubFiles$directory.stub(
        _res,
      );
}

class Query$seriesReadingDirection$seriesById$books$epubFiles$directory {
  Query$seriesReadingDirection$seriesById$books$epubFiles$directory({
    required this.node,
    this.$__typename = 'Directory',
  });

  factory Query$seriesReadingDirection$seriesById$books$epubFiles$directory.fromJson(
    Map<String, dynamic> json,
  ) {
    final l$node = json['node'];
    final l$$__typename = json['__typename'];
    return Query$seriesReadingDirection$seriesById$books$epubFiles$directory(
      node:
          Query$seriesReadingDirection$seriesById$books$epubFiles$directory$node.fromJson(
            (l$node as Map<String, dynamic>),
          ),
      $__typename: (l$$__typename as String),
    );
  }

  final Query$seriesReadingDirection$seriesById$books$epubFiles$directory$node
  node;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$node = node;
    _resultData['node'] = l$node.toJson();
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$node = node;
    final l$$__typename = $__typename;
    return Object.hashAll([l$node, l$$__typename]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other
            is! Query$seriesReadingDirection$seriesById$books$epubFiles$directory ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$node = node;
    final lOther$node = other.node;
    if (l$node != lOther$node) {
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

extension UtilityExtension$Query$seriesReadingDirection$seriesById$books$epubFiles$directory
    on Query$seriesReadingDirection$seriesById$books$epubFiles$directory {
  CopyWith$Query$seriesReadingDirection$seriesById$books$epubFiles$directory<
    Query$seriesReadingDirection$seriesById$books$epubFiles$directory
  >
  get copyWith =>
      CopyWith$Query$seriesReadingDirection$seriesById$books$epubFiles$directory(
        this,
        (i) => i,
      );
}

abstract class CopyWith$Query$seriesReadingDirection$seriesById$books$epubFiles$directory<
  TRes
> {
  factory CopyWith$Query$seriesReadingDirection$seriesById$books$epubFiles$directory(
    Query$seriesReadingDirection$seriesById$books$epubFiles$directory instance,
    TRes Function(
      Query$seriesReadingDirection$seriesById$books$epubFiles$directory,
    )
    then,
  ) = _CopyWithImpl$Query$seriesReadingDirection$seriesById$books$epubFiles$directory;

  factory CopyWith$Query$seriesReadingDirection$seriesById$books$epubFiles$directory.stub(
    TRes res,
  ) = _CopyWithStubImpl$Query$seriesReadingDirection$seriesById$books$epubFiles$directory;

  TRes call({
    Query$seriesReadingDirection$seriesById$books$epubFiles$directory$node?
    node,
    String? $__typename,
  });
  CopyWith$Query$seriesReadingDirection$seriesById$books$epubFiles$directory$node<
    TRes
  >
  get node;
}

class _CopyWithImpl$Query$seriesReadingDirection$seriesById$books$epubFiles$directory<
  TRes
>
    implements
        CopyWith$Query$seriesReadingDirection$seriesById$books$epubFiles$directory<
          TRes
        > {
  _CopyWithImpl$Query$seriesReadingDirection$seriesById$books$epubFiles$directory(
    this._instance,
    this._then,
  );

  final Query$seriesReadingDirection$seriesById$books$epubFiles$directory
  _instance;

  final TRes Function(
    Query$seriesReadingDirection$seriesById$books$epubFiles$directory,
  )
  _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? node = _undefined,
    Object? $__typename = _undefined,
  }) => _then(
    Query$seriesReadingDirection$seriesById$books$epubFiles$directory(
      node: node == _undefined || node == null
          ? _instance.node
          : (node
                as Query$seriesReadingDirection$seriesById$books$epubFiles$directory$node),
      $__typename: $__typename == _undefined || $__typename == null
          ? _instance.$__typename
          : ($__typename as String),
    ),
  );

  CopyWith$Query$seriesReadingDirection$seriesById$books$epubFiles$directory$node<
    TRes
  >
  get node {
    final local$node = _instance.node;
    return CopyWith$Query$seriesReadingDirection$seriesById$books$epubFiles$directory$node(
      local$node,
      (e) => call(node: e),
    );
  }
}

class _CopyWithStubImpl$Query$seriesReadingDirection$seriesById$books$epubFiles$directory<
  TRes
>
    implements
        CopyWith$Query$seriesReadingDirection$seriesById$books$epubFiles$directory<
          TRes
        > {
  _CopyWithStubImpl$Query$seriesReadingDirection$seriesById$books$epubFiles$directory(
    this._res,
  );

  TRes _res;

  call({
    Query$seriesReadingDirection$seriesById$books$epubFiles$directory$node?
    node,
    String? $__typename,
  }) => _res;

  CopyWith$Query$seriesReadingDirection$seriesById$books$epubFiles$directory$node<
    TRes
  >
  get node =>
      CopyWith$Query$seriesReadingDirection$seriesById$books$epubFiles$directory$node.stub(
        _res,
      );
}

class Query$seriesReadingDirection$seriesById$books$epubFiles$directory$node {
  Query$seriesReadingDirection$seriesById$books$epubFiles$directory$node({
    required this.url,
    this.$__typename = 'Node',
  });

  factory Query$seriesReadingDirection$seriesById$books$epubFiles$directory$node.fromJson(
    Map<String, dynamic> json,
  ) {
    final l$url = json['url'];
    final l$$__typename = json['__typename'];
    return Query$seriesReadingDirection$seriesById$books$epubFiles$directory$node(
      url: (l$url as String),
      $__typename: (l$$__typename as String),
    );
  }

  final String url;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$url = url;
    _resultData['url'] = l$url;
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$url = url;
    final l$$__typename = $__typename;
    return Object.hashAll([l$url, l$$__typename]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other
            is! Query$seriesReadingDirection$seriesById$books$epubFiles$directory$node ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$url = url;
    final lOther$url = other.url;
    if (l$url != lOther$url) {
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

extension UtilityExtension$Query$seriesReadingDirection$seriesById$books$epubFiles$directory$node
    on Query$seriesReadingDirection$seriesById$books$epubFiles$directory$node {
  CopyWith$Query$seriesReadingDirection$seriesById$books$epubFiles$directory$node<
    Query$seriesReadingDirection$seriesById$books$epubFiles$directory$node
  >
  get copyWith =>
      CopyWith$Query$seriesReadingDirection$seriesById$books$epubFiles$directory$node(
        this,
        (i) => i,
      );
}

abstract class CopyWith$Query$seriesReadingDirection$seriesById$books$epubFiles$directory$node<
  TRes
> {
  factory CopyWith$Query$seriesReadingDirection$seriesById$books$epubFiles$directory$node(
    Query$seriesReadingDirection$seriesById$books$epubFiles$directory$node
    instance,
    TRes Function(
      Query$seriesReadingDirection$seriesById$books$epubFiles$directory$node,
    )
    then,
  ) = _CopyWithImpl$Query$seriesReadingDirection$seriesById$books$epubFiles$directory$node;

  factory CopyWith$Query$seriesReadingDirection$seriesById$books$epubFiles$directory$node.stub(
    TRes res,
  ) = _CopyWithStubImpl$Query$seriesReadingDirection$seriesById$books$epubFiles$directory$node;

  TRes call({String? url, String? $__typename});
}

class _CopyWithImpl$Query$seriesReadingDirection$seriesById$books$epubFiles$directory$node<
  TRes
>
    implements
        CopyWith$Query$seriesReadingDirection$seriesById$books$epubFiles$directory$node<
          TRes
        > {
  _CopyWithImpl$Query$seriesReadingDirection$seriesById$books$epubFiles$directory$node(
    this._instance,
    this._then,
  );

  final Query$seriesReadingDirection$seriesById$books$epubFiles$directory$node
  _instance;

  final TRes Function(
    Query$seriesReadingDirection$seriesById$books$epubFiles$directory$node,
  )
  _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({Object? url = _undefined, Object? $__typename = _undefined}) =>
      _then(
        Query$seriesReadingDirection$seriesById$books$epubFiles$directory$node(
          url: url == _undefined || url == null
              ? _instance.url
              : (url as String),
          $__typename: $__typename == _undefined || $__typename == null
              ? _instance.$__typename
              : ($__typename as String),
        ),
      );
}

class _CopyWithStubImpl$Query$seriesReadingDirection$seriesById$books$epubFiles$directory$node<
  TRes
>
    implements
        CopyWith$Query$seriesReadingDirection$seriesById$books$epubFiles$directory$node<
          TRes
        > {
  _CopyWithStubImpl$Query$seriesReadingDirection$seriesById$books$epubFiles$directory$node(
    this._res,
  );

  TRes _res;

  call({String? url, String? $__typename}) => _res;
}

import 'fragmentBook.graphql.dart';
import 'fragmentImages.graphql.dart';
import 'fragmentMetadata.graphql.dart';
import 'fragmentSeries.graphql.dart';
import 'package:gql/ast.dart';
import 'schema.graphql.dart';

class Variables$Query$seriesById {
  factory Variables$Query$seriesById({String? id}) =>
      Variables$Query$seriesById._({if (id != null) r'id': id});

  Variables$Query$seriesById._(this._$data);

  factory Variables$Query$seriesById.fromJson(Map<String, dynamic> data) {
    final result$data = <String, dynamic>{};
    if (data.containsKey('id')) {
      final l$id = data['id'];
      result$data['id'] = (l$id as String?);
    }
    return Variables$Query$seriesById._(result$data);
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

  CopyWith$Variables$Query$seriesById<Variables$Query$seriesById>
  get copyWith => CopyWith$Variables$Query$seriesById(this, (i) => i);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Variables$Query$seriesById ||
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

abstract class CopyWith$Variables$Query$seriesById<TRes> {
  factory CopyWith$Variables$Query$seriesById(
    Variables$Query$seriesById instance,
    TRes Function(Variables$Query$seriesById) then,
  ) = _CopyWithImpl$Variables$Query$seriesById;

  factory CopyWith$Variables$Query$seriesById.stub(TRes res) =
      _CopyWithStubImpl$Variables$Query$seriesById;

  TRes call({String? id});
}

class _CopyWithImpl$Variables$Query$seriesById<TRes>
    implements CopyWith$Variables$Query$seriesById<TRes> {
  _CopyWithImpl$Variables$Query$seriesById(this._instance, this._then);

  final Variables$Query$seriesById _instance;

  final TRes Function(Variables$Query$seriesById) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({Object? id = _undefined}) => _then(
    Variables$Query$seriesById._({
      ..._instance._$data,
      if (id != _undefined) 'id': (id as String?),
    }),
  );
}

class _CopyWithStubImpl$Variables$Query$seriesById<TRes>
    implements CopyWith$Variables$Query$seriesById<TRes> {
  _CopyWithStubImpl$Variables$Query$seriesById(this._res);

  TRes _res;

  call({String? id}) => _res;
}

class Query$seriesById {
  Query$seriesById({this.seriesById, this.$__typename = 'Query'});

  factory Query$seriesById.fromJson(Map<String, dynamic> json) {
    final l$seriesById = json['seriesById'];
    final l$$__typename = json['__typename'];
    return Query$seriesById(
      seriesById: l$seriesById == null
          ? null
          : Query$seriesById$seriesById.fromJson(
              (l$seriesById as Map<String, dynamic>),
            ),
      $__typename: (l$$__typename as String),
    );
  }

  final Query$seriesById$seriesById? seriesById;

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
    if (other is! Query$seriesById || runtimeType != other.runtimeType) {
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

extension UtilityExtension$Query$seriesById on Query$seriesById {
  CopyWith$Query$seriesById<Query$seriesById> get copyWith =>
      CopyWith$Query$seriesById(this, (i) => i);
}

abstract class CopyWith$Query$seriesById<TRes> {
  factory CopyWith$Query$seriesById(
    Query$seriesById instance,
    TRes Function(Query$seriesById) then,
  ) = _CopyWithImpl$Query$seriesById;

  factory CopyWith$Query$seriesById.stub(TRes res) =
      _CopyWithStubImpl$Query$seriesById;

  TRes call({Query$seriesById$seriesById? seriesById, String? $__typename});
  CopyWith$Query$seriesById$seriesById<TRes> get seriesById;
}

class _CopyWithImpl$Query$seriesById<TRes>
    implements CopyWith$Query$seriesById<TRes> {
  _CopyWithImpl$Query$seriesById(this._instance, this._then);

  final Query$seriesById _instance;

  final TRes Function(Query$seriesById) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? seriesById = _undefined,
    Object? $__typename = _undefined,
  }) => _then(
    Query$seriesById(
      seriesById: seriesById == _undefined
          ? _instance.seriesById
          : (seriesById as Query$seriesById$seriesById?),
      $__typename: $__typename == _undefined || $__typename == null
          ? _instance.$__typename
          : ($__typename as String),
    ),
  );

  CopyWith$Query$seriesById$seriesById<TRes> get seriesById {
    final local$seriesById = _instance.seriesById;
    return local$seriesById == null
        ? CopyWith$Query$seriesById$seriesById.stub(_then(_instance))
        : CopyWith$Query$seriesById$seriesById(
            local$seriesById,
            (e) => call(seriesById: e),
          );
  }
}

class _CopyWithStubImpl$Query$seriesById<TRes>
    implements CopyWith$Query$seriesById<TRes> {
  _CopyWithStubImpl$Query$seriesById(this._res);

  TRes _res;

  call({Query$seriesById$seriesById? seriesById, String? $__typename}) => _res;

  CopyWith$Query$seriesById$seriesById<TRes> get seriesById =>
      CopyWith$Query$seriesById$seriesById.stub(_res);
}

const documentNodeQueryseriesById = DocumentNode(
  definitions: [
    OperationDefinitionNode(
      type: OperationType.query,
      name: NameNode(value: 'seriesById'),
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
                FragmentSpreadNode(
                  name: NameNode(value: 'fragmentSeries'),
                  directives: [],
                ),
                FieldNode(
                  name: NameNode(value: 'books'),
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
                              name: NameNode(value: 'path'),
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
                              name: NameNode(value: 'pageCount'),
                              alias: null,
                              arguments: [],
                              directives: [],
                              selectionSet: null,
                            ),
                            FieldNode(
                              name: NameNode(value: 'mediaOverlays'),
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
                        name: NameNode(value: 'watchStatus'),
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
                              name: NameNode(value: 'watched'),
                              alias: null,
                              arguments: [],
                              directives: [],
                              selectionSet: null,
                            ),
                            FieldNode(
                              name: NameNode(value: 'readingLocation'),
                              alias: null,
                              arguments: [],
                              directives: [],
                              selectionSet: null,
                            ),
                            FieldNode(
                              name: NameNode(value: 'readingProgress'),
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
    fragmentDefinitionfragmentSeries,
    fragmentDefinitionfragmentImages,
    fragmentDefinitionfragmentMetadata,
    fragmentDefinitionfragmentBook,
  ],
);

class Query$seriesById$seriesById implements Fragment$fragmentSeries {
  Query$seriesById$seriesById({
    required this.id,
    required this.name,
    required this.startYear,
    required this.readingDirection,
    this.userReadingDirection,
    this.cover,
    this.images,
    this.metadata,
    this.$__typename = 'Series',
    required this.books,
  });

  factory Query$seriesById$seriesById.fromJson(Map<String, dynamic> json) {
    final l$id = json['id'];
    final l$name = json['name'];
    final l$startYear = json['startYear'];
    final l$readingDirection = json['readingDirection'];
    final l$userReadingDirection = json['userReadingDirection'];
    final l$cover = json['cover'];
    final l$images = json['images'];
    final l$metadata = json['metadata'];
    final l$$__typename = json['__typename'];
    final l$books = json['books'];
    return Query$seriesById$seriesById(
      id: (l$id as String),
      name: (l$name as String),
      startYear: (l$startYear as int),
      readingDirection: fromJson$Enum$ReadingDirection(
        (l$readingDirection as String),
      ),
      userReadingDirection: l$userReadingDirection == null
          ? null
          : fromJson$Enum$ReadingDirection((l$userReadingDirection as String)),
      cover: l$cover == null
          ? null
          : Fragment$fragmentImages.fromJson((l$cover as Map<String, dynamic>)),
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
      books: (l$books as List<dynamic>)
          .map(
            (e) => Query$seriesById$seriesById$books.fromJson(
              (e as Map<String, dynamic>),
            ),
          )
          .toList(),
    );
  }

  final String id;

  final String name;

  final int startYear;

  final Enum$ReadingDirection readingDirection;

  final Enum$ReadingDirection? userReadingDirection;

  final Fragment$fragmentImages? cover;

  final List<Fragment$fragmentImages>? images;

  final List<Fragment$fragmentMetadata>? metadata;

  final String $__typename;

  final List<Query$seriesById$seriesById$books> books;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$id = id;
    _resultData['id'] = l$id;
    final l$name = name;
    _resultData['name'] = l$name;
    final l$startYear = startYear;
    _resultData['startYear'] = l$startYear;
    final l$readingDirection = readingDirection;
    _resultData['readingDirection'] = toJson$Enum$ReadingDirection(
      l$readingDirection,
    );
    final l$userReadingDirection = userReadingDirection;
    _resultData['userReadingDirection'] = l$userReadingDirection == null
        ? null
        : toJson$Enum$ReadingDirection(l$userReadingDirection);
    final l$cover = cover;
    _resultData['cover'] = l$cover?.toJson();
    final l$images = images;
    _resultData['images'] = l$images?.map((e) => e.toJson()).toList();
    final l$metadata = metadata;
    _resultData['metadata'] = l$metadata?.map((e) => e.toJson()).toList();
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    final l$books = books;
    _resultData['books'] = l$books.map((e) => e.toJson()).toList();
    return _resultData;
  }

  @override
  int get hashCode {
    final l$id = id;
    final l$name = name;
    final l$startYear = startYear;
    final l$readingDirection = readingDirection;
    final l$userReadingDirection = userReadingDirection;
    final l$cover = cover;
    final l$images = images;
    final l$metadata = metadata;
    final l$$__typename = $__typename;
    final l$books = books;
    return Object.hashAll([
      l$id,
      l$name,
      l$startYear,
      l$readingDirection,
      l$userReadingDirection,
      l$cover,
      l$images == null ? null : Object.hashAll(l$images.map((v) => v)),
      l$metadata == null ? null : Object.hashAll(l$metadata.map((v) => v)),
      l$$__typename,
      Object.hashAll(l$books.map((v) => v)),
    ]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Query$seriesById$seriesById ||
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
    final l$startYear = startYear;
    final lOther$startYear = other.startYear;
    if (l$startYear != lOther$startYear) {
      return false;
    }
    final l$readingDirection = readingDirection;
    final lOther$readingDirection = other.readingDirection;
    if (l$readingDirection != lOther$readingDirection) {
      return false;
    }
    final l$userReadingDirection = userReadingDirection;
    final lOther$userReadingDirection = other.userReadingDirection;
    if (l$userReadingDirection != lOther$userReadingDirection) {
      return false;
    }
    final l$cover = cover;
    final lOther$cover = other.cover;
    if (l$cover != lOther$cover) {
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
    return true;
  }
}

extension UtilityExtension$Query$seriesById$seriesById
    on Query$seriesById$seriesById {
  CopyWith$Query$seriesById$seriesById<Query$seriesById$seriesById>
  get copyWith => CopyWith$Query$seriesById$seriesById(this, (i) => i);
}

abstract class CopyWith$Query$seriesById$seriesById<TRes> {
  factory CopyWith$Query$seriesById$seriesById(
    Query$seriesById$seriesById instance,
    TRes Function(Query$seriesById$seriesById) then,
  ) = _CopyWithImpl$Query$seriesById$seriesById;

  factory CopyWith$Query$seriesById$seriesById.stub(TRes res) =
      _CopyWithStubImpl$Query$seriesById$seriesById;

  TRes call({
    String? id,
    String? name,
    int? startYear,
    Enum$ReadingDirection? readingDirection,
    Enum$ReadingDirection? userReadingDirection,
    Fragment$fragmentImages? cover,
    List<Fragment$fragmentImages>? images,
    List<Fragment$fragmentMetadata>? metadata,
    String? $__typename,
    List<Query$seriesById$seriesById$books>? books,
  });
  CopyWith$Fragment$fragmentImages<TRes> get cover;
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
  TRes books(
    Iterable<Query$seriesById$seriesById$books> Function(
      Iterable<
        CopyWith$Query$seriesById$seriesById$books<
          Query$seriesById$seriesById$books
        >
      >,
    )
    _fn,
  );
}

class _CopyWithImpl$Query$seriesById$seriesById<TRes>
    implements CopyWith$Query$seriesById$seriesById<TRes> {
  _CopyWithImpl$Query$seriesById$seriesById(this._instance, this._then);

  final Query$seriesById$seriesById _instance;

  final TRes Function(Query$seriesById$seriesById) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? id = _undefined,
    Object? name = _undefined,
    Object? startYear = _undefined,
    Object? readingDirection = _undefined,
    Object? userReadingDirection = _undefined,
    Object? cover = _undefined,
    Object? images = _undefined,
    Object? metadata = _undefined,
    Object? $__typename = _undefined,
    Object? books = _undefined,
  }) => _then(
    Query$seriesById$seriesById(
      id: id == _undefined || id == null ? _instance.id : (id as String),
      name: name == _undefined || name == null
          ? _instance.name
          : (name as String),
      startYear: startYear == _undefined || startYear == null
          ? _instance.startYear
          : (startYear as int),
      readingDirection:
          readingDirection == _undefined || readingDirection == null
          ? _instance.readingDirection
          : (readingDirection as Enum$ReadingDirection),
      userReadingDirection: userReadingDirection == _undefined
          ? _instance.userReadingDirection
          : (userReadingDirection as Enum$ReadingDirection?),
      cover: cover == _undefined
          ? _instance.cover
          : (cover as Fragment$fragmentImages?),
      images: images == _undefined
          ? _instance.images
          : (images as List<Fragment$fragmentImages>?),
      metadata: metadata == _undefined
          ? _instance.metadata
          : (metadata as List<Fragment$fragmentMetadata>?),
      $__typename: $__typename == _undefined || $__typename == null
          ? _instance.$__typename
          : ($__typename as String),
      books: books == _undefined || books == null
          ? _instance.books
          : (books as List<Query$seriesById$seriesById$books>),
    ),
  );

  CopyWith$Fragment$fragmentImages<TRes> get cover {
    final local$cover = _instance.cover;
    return local$cover == null
        ? CopyWith$Fragment$fragmentImages.stub(_then(_instance))
        : CopyWith$Fragment$fragmentImages(local$cover, (e) => call(cover: e));
  }

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

  TRes books(
    Iterable<Query$seriesById$seriesById$books> Function(
      Iterable<
        CopyWith$Query$seriesById$seriesById$books<
          Query$seriesById$seriesById$books
        >
      >,
    )
    _fn,
  ) => call(
    books: _fn(
      _instance.books.map(
        (e) => CopyWith$Query$seriesById$seriesById$books(e, (i) => i),
      ),
    ).toList(),
  );
}

class _CopyWithStubImpl$Query$seriesById$seriesById<TRes>
    implements CopyWith$Query$seriesById$seriesById<TRes> {
  _CopyWithStubImpl$Query$seriesById$seriesById(this._res);

  TRes _res;

  call({
    String? id,
    String? name,
    int? startYear,
    Enum$ReadingDirection? readingDirection,
    Enum$ReadingDirection? userReadingDirection,
    Fragment$fragmentImages? cover,
    List<Fragment$fragmentImages>? images,
    List<Fragment$fragmentMetadata>? metadata,
    String? $__typename,
    List<Query$seriesById$seriesById$books>? books,
  }) => _res;

  CopyWith$Fragment$fragmentImages<TRes> get cover =>
      CopyWith$Fragment$fragmentImages.stub(_res);

  images(_fn) => _res;

  metadata(_fn) => _res;

  books(_fn) => _res;
}

class Query$seriesById$seriesById$books implements Fragment$fragmentBook {
  Query$seriesById$seriesById$books({
    required this.id,
    required this.name,
    required this.title,
    required this.releaseYear,
    this.seriesIndex,
    this.author,
    this.series,
    this.images,
    this.metadata,
    this.rating,
    this.$__typename = 'Book',
    this.epubFiles,
    this.watchStatus,
  });

  factory Query$seriesById$seriesById$books.fromJson(
    Map<String, dynamic> json,
  ) {
    final l$id = json['id'];
    final l$name = json['name'];
    final l$title = json['title'];
    final l$releaseYear = json['releaseYear'];
    final l$seriesIndex = json['seriesIndex'];
    final l$author = json['author'];
    final l$series = json['series'];
    final l$images = json['images'];
    final l$metadata = json['metadata'];
    final l$rating = json['rating'];
    final l$$__typename = json['__typename'];
    final l$epubFiles = json['epubFiles'];
    final l$watchStatus = json['watchStatus'];
    return Query$seriesById$seriesById$books(
      id: (l$id as String),
      name: (l$name as String),
      title: (l$title as String),
      releaseYear: (l$releaseYear as int),
      seriesIndex: (l$seriesIndex as num?)?.toDouble(),
      author: l$author == null
          ? null
          : Query$seriesById$seriesById$books$author.fromJson(
              (l$author as Map<String, dynamic>),
            ),
      series: l$series == null
          ? null
          : Query$seriesById$seriesById$books$series.fromJson(
              (l$series as Map<String, dynamic>),
            ),
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
      rating: (l$rating as int?),
      $__typename: (l$$__typename as String),
      epubFiles: (l$epubFiles as List<dynamic>?)
          ?.map(
            (e) => Query$seriesById$seriesById$books$epubFiles.fromJson(
              (e as Map<String, dynamic>),
            ),
          )
          .toList(),
      watchStatus: (l$watchStatus as List<dynamic>?)
          ?.map(
            (e) => Query$seriesById$seriesById$books$watchStatus.fromJson(
              (e as Map<String, dynamic>),
            ),
          )
          .toList(),
    );
  }

  final String id;

  final String name;

  final String title;

  final int releaseYear;

  final double? seriesIndex;

  final Query$seriesById$seriesById$books$author? author;

  final Query$seriesById$seriesById$books$series? series;

  final List<Fragment$fragmentImages>? images;

  final List<Fragment$fragmentMetadata>? metadata;

  final int? rating;

  final String $__typename;

  final List<Query$seriesById$seriesById$books$epubFiles>? epubFiles;

  final List<Query$seriesById$seriesById$books$watchStatus>? watchStatus;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$id = id;
    _resultData['id'] = l$id;
    final l$name = name;
    _resultData['name'] = l$name;
    final l$title = title;
    _resultData['title'] = l$title;
    final l$releaseYear = releaseYear;
    _resultData['releaseYear'] = l$releaseYear;
    final l$seriesIndex = seriesIndex;
    _resultData['seriesIndex'] = l$seriesIndex;
    final l$author = author;
    _resultData['author'] = l$author?.toJson();
    final l$series = series;
    _resultData['series'] = l$series?.toJson();
    final l$images = images;
    _resultData['images'] = l$images?.map((e) => e.toJson()).toList();
    final l$metadata = metadata;
    _resultData['metadata'] = l$metadata?.map((e) => e.toJson()).toList();
    final l$rating = rating;
    _resultData['rating'] = l$rating;
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    final l$epubFiles = epubFiles;
    _resultData['epubFiles'] = l$epubFiles?.map((e) => e.toJson()).toList();
    final l$watchStatus = watchStatus;
    _resultData['watchStatus'] = l$watchStatus?.map((e) => e.toJson()).toList();
    return _resultData;
  }

  @override
  int get hashCode {
    final l$id = id;
    final l$name = name;
    final l$title = title;
    final l$releaseYear = releaseYear;
    final l$seriesIndex = seriesIndex;
    final l$author = author;
    final l$series = series;
    final l$images = images;
    final l$metadata = metadata;
    final l$rating = rating;
    final l$$__typename = $__typename;
    final l$epubFiles = epubFiles;
    final l$watchStatus = watchStatus;
    return Object.hashAll([
      l$id,
      l$name,
      l$title,
      l$releaseYear,
      l$seriesIndex,
      l$author,
      l$series,
      l$images == null ? null : Object.hashAll(l$images.map((v) => v)),
      l$metadata == null ? null : Object.hashAll(l$metadata.map((v) => v)),
      l$rating,
      l$$__typename,
      l$epubFiles == null ? null : Object.hashAll(l$epubFiles.map((v) => v)),
      l$watchStatus == null
          ? null
          : Object.hashAll(l$watchStatus.map((v) => v)),
    ]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Query$seriesById$seriesById$books ||
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
    final l$title = title;
    final lOther$title = other.title;
    if (l$title != lOther$title) {
      return false;
    }
    final l$releaseYear = releaseYear;
    final lOther$releaseYear = other.releaseYear;
    if (l$releaseYear != lOther$releaseYear) {
      return false;
    }
    final l$seriesIndex = seriesIndex;
    final lOther$seriesIndex = other.seriesIndex;
    if (l$seriesIndex != lOther$seriesIndex) {
      return false;
    }
    final l$author = author;
    final lOther$author = other.author;
    if (l$author != lOther$author) {
      return false;
    }
    final l$series = series;
    final lOther$series = other.series;
    if (l$series != lOther$series) {
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
    final l$rating = rating;
    final lOther$rating = other.rating;
    if (l$rating != lOther$rating) {
      return false;
    }
    final l$$__typename = $__typename;
    final lOther$$__typename = other.$__typename;
    if (l$$__typename != lOther$$__typename) {
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
    final l$watchStatus = watchStatus;
    final lOther$watchStatus = other.watchStatus;
    if (l$watchStatus != null && lOther$watchStatus != null) {
      if (l$watchStatus.length != lOther$watchStatus.length) {
        return false;
      }
      for (int i = 0; i < l$watchStatus.length; i++) {
        final l$watchStatus$entry = l$watchStatus[i];
        final lOther$watchStatus$entry = lOther$watchStatus[i];
        if (l$watchStatus$entry != lOther$watchStatus$entry) {
          return false;
        }
      }
    } else if (l$watchStatus != lOther$watchStatus) {
      return false;
    }
    return true;
  }
}

extension UtilityExtension$Query$seriesById$seriesById$books
    on Query$seriesById$seriesById$books {
  CopyWith$Query$seriesById$seriesById$books<Query$seriesById$seriesById$books>
  get copyWith => CopyWith$Query$seriesById$seriesById$books(this, (i) => i);
}

abstract class CopyWith$Query$seriesById$seriesById$books<TRes> {
  factory CopyWith$Query$seriesById$seriesById$books(
    Query$seriesById$seriesById$books instance,
    TRes Function(Query$seriesById$seriesById$books) then,
  ) = _CopyWithImpl$Query$seriesById$seriesById$books;

  factory CopyWith$Query$seriesById$seriesById$books.stub(TRes res) =
      _CopyWithStubImpl$Query$seriesById$seriesById$books;

  TRes call({
    String? id,
    String? name,
    String? title,
    int? releaseYear,
    double? seriesIndex,
    Query$seriesById$seriesById$books$author? author,
    Query$seriesById$seriesById$books$series? series,
    List<Fragment$fragmentImages>? images,
    List<Fragment$fragmentMetadata>? metadata,
    int? rating,
    String? $__typename,
    List<Query$seriesById$seriesById$books$epubFiles>? epubFiles,
    List<Query$seriesById$seriesById$books$watchStatus>? watchStatus,
  });
  CopyWith$Query$seriesById$seriesById$books$author<TRes> get author;
  CopyWith$Query$seriesById$seriesById$books$series<TRes> get series;
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
  TRes epubFiles(
    Iterable<Query$seriesById$seriesById$books$epubFiles>? Function(
      Iterable<
        CopyWith$Query$seriesById$seriesById$books$epubFiles<
          Query$seriesById$seriesById$books$epubFiles
        >
      >?,
    )
    _fn,
  );
  TRes watchStatus(
    Iterable<Query$seriesById$seriesById$books$watchStatus>? Function(
      Iterable<
        CopyWith$Query$seriesById$seriesById$books$watchStatus<
          Query$seriesById$seriesById$books$watchStatus
        >
      >?,
    )
    _fn,
  );
}

class _CopyWithImpl$Query$seriesById$seriesById$books<TRes>
    implements CopyWith$Query$seriesById$seriesById$books<TRes> {
  _CopyWithImpl$Query$seriesById$seriesById$books(this._instance, this._then);

  final Query$seriesById$seriesById$books _instance;

  final TRes Function(Query$seriesById$seriesById$books) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? id = _undefined,
    Object? name = _undefined,
    Object? title = _undefined,
    Object? releaseYear = _undefined,
    Object? seriesIndex = _undefined,
    Object? author = _undefined,
    Object? series = _undefined,
    Object? images = _undefined,
    Object? metadata = _undefined,
    Object? rating = _undefined,
    Object? $__typename = _undefined,
    Object? epubFiles = _undefined,
    Object? watchStatus = _undefined,
  }) => _then(
    Query$seriesById$seriesById$books(
      id: id == _undefined || id == null ? _instance.id : (id as String),
      name: name == _undefined || name == null
          ? _instance.name
          : (name as String),
      title: title == _undefined || title == null
          ? _instance.title
          : (title as String),
      releaseYear: releaseYear == _undefined || releaseYear == null
          ? _instance.releaseYear
          : (releaseYear as int),
      seriesIndex: seriesIndex == _undefined
          ? _instance.seriesIndex
          : (seriesIndex as double?),
      author: author == _undefined
          ? _instance.author
          : (author as Query$seriesById$seriesById$books$author?),
      series: series == _undefined
          ? _instance.series
          : (series as Query$seriesById$seriesById$books$series?),
      images: images == _undefined
          ? _instance.images
          : (images as List<Fragment$fragmentImages>?),
      metadata: metadata == _undefined
          ? _instance.metadata
          : (metadata as List<Fragment$fragmentMetadata>?),
      rating: rating == _undefined ? _instance.rating : (rating as int?),
      $__typename: $__typename == _undefined || $__typename == null
          ? _instance.$__typename
          : ($__typename as String),
      epubFiles: epubFiles == _undefined
          ? _instance.epubFiles
          : (epubFiles as List<Query$seriesById$seriesById$books$epubFiles>?),
      watchStatus: watchStatus == _undefined
          ? _instance.watchStatus
          : (watchStatus
                as List<Query$seriesById$seriesById$books$watchStatus>?),
    ),
  );

  CopyWith$Query$seriesById$seriesById$books$author<TRes> get author {
    final local$author = _instance.author;
    return local$author == null
        ? CopyWith$Query$seriesById$seriesById$books$author.stub(
            _then(_instance),
          )
        : CopyWith$Query$seriesById$seriesById$books$author(
            local$author,
            (e) => call(author: e),
          );
  }

  CopyWith$Query$seriesById$seriesById$books$series<TRes> get series {
    final local$series = _instance.series;
    return local$series == null
        ? CopyWith$Query$seriesById$seriesById$books$series.stub(
            _then(_instance),
          )
        : CopyWith$Query$seriesById$seriesById$books$series(
            local$series,
            (e) => call(series: e),
          );
  }

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

  TRes epubFiles(
    Iterable<Query$seriesById$seriesById$books$epubFiles>? Function(
      Iterable<
        CopyWith$Query$seriesById$seriesById$books$epubFiles<
          Query$seriesById$seriesById$books$epubFiles
        >
      >?,
    )
    _fn,
  ) => call(
    epubFiles: _fn(
      _instance.epubFiles?.map(
        (e) =>
            CopyWith$Query$seriesById$seriesById$books$epubFiles(e, (i) => i),
      ),
    )?.toList(),
  );

  TRes watchStatus(
    Iterable<Query$seriesById$seriesById$books$watchStatus>? Function(
      Iterable<
        CopyWith$Query$seriesById$seriesById$books$watchStatus<
          Query$seriesById$seriesById$books$watchStatus
        >
      >?,
    )
    _fn,
  ) => call(
    watchStatus: _fn(
      _instance.watchStatus?.map(
        (e) =>
            CopyWith$Query$seriesById$seriesById$books$watchStatus(e, (i) => i),
      ),
    )?.toList(),
  );
}

class _CopyWithStubImpl$Query$seriesById$seriesById$books<TRes>
    implements CopyWith$Query$seriesById$seriesById$books<TRes> {
  _CopyWithStubImpl$Query$seriesById$seriesById$books(this._res);

  TRes _res;

  call({
    String? id,
    String? name,
    String? title,
    int? releaseYear,
    double? seriesIndex,
    Query$seriesById$seriesById$books$author? author,
    Query$seriesById$seriesById$books$series? series,
    List<Fragment$fragmentImages>? images,
    List<Fragment$fragmentMetadata>? metadata,
    int? rating,
    String? $__typename,
    List<Query$seriesById$seriesById$books$epubFiles>? epubFiles,
    List<Query$seriesById$seriesById$books$watchStatus>? watchStatus,
  }) => _res;

  CopyWith$Query$seriesById$seriesById$books$author<TRes> get author =>
      CopyWith$Query$seriesById$seriesById$books$author.stub(_res);

  CopyWith$Query$seriesById$seriesById$books$series<TRes> get series =>
      CopyWith$Query$seriesById$seriesById$books$series.stub(_res);

  images(_fn) => _res;

  metadata(_fn) => _res;

  epubFiles(_fn) => _res;

  watchStatus(_fn) => _res;
}

class Query$seriesById$seriesById$books$author
    implements Fragment$fragmentBook$author {
  Query$seriesById$seriesById$books$author({
    required this.id,
    required this.name,
    this.$__typename = 'Person',
  });

  factory Query$seriesById$seriesById$books$author.fromJson(
    Map<String, dynamic> json,
  ) {
    final l$id = json['id'];
    final l$name = json['name'];
    final l$$__typename = json['__typename'];
    return Query$seriesById$seriesById$books$author(
      id: (l$id as String),
      name: (l$name as String),
      $__typename: (l$$__typename as String),
    );
  }

  final String id;

  final String name;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$id = id;
    _resultData['id'] = l$id;
    final l$name = name;
    _resultData['name'] = l$name;
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$id = id;
    final l$name = name;
    final l$$__typename = $__typename;
    return Object.hashAll([l$id, l$name, l$$__typename]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Query$seriesById$seriesById$books$author ||
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
    final l$$__typename = $__typename;
    final lOther$$__typename = other.$__typename;
    if (l$$__typename != lOther$$__typename) {
      return false;
    }
    return true;
  }
}

extension UtilityExtension$Query$seriesById$seriesById$books$author
    on Query$seriesById$seriesById$books$author {
  CopyWith$Query$seriesById$seriesById$books$author<
    Query$seriesById$seriesById$books$author
  >
  get copyWith =>
      CopyWith$Query$seriesById$seriesById$books$author(this, (i) => i);
}

abstract class CopyWith$Query$seriesById$seriesById$books$author<TRes> {
  factory CopyWith$Query$seriesById$seriesById$books$author(
    Query$seriesById$seriesById$books$author instance,
    TRes Function(Query$seriesById$seriesById$books$author) then,
  ) = _CopyWithImpl$Query$seriesById$seriesById$books$author;

  factory CopyWith$Query$seriesById$seriesById$books$author.stub(TRes res) =
      _CopyWithStubImpl$Query$seriesById$seriesById$books$author;

  TRes call({String? id, String? name, String? $__typename});
}

class _CopyWithImpl$Query$seriesById$seriesById$books$author<TRes>
    implements CopyWith$Query$seriesById$seriesById$books$author<TRes> {
  _CopyWithImpl$Query$seriesById$seriesById$books$author(
    this._instance,
    this._then,
  );

  final Query$seriesById$seriesById$books$author _instance;

  final TRes Function(Query$seriesById$seriesById$books$author) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? id = _undefined,
    Object? name = _undefined,
    Object? $__typename = _undefined,
  }) => _then(
    Query$seriesById$seriesById$books$author(
      id: id == _undefined || id == null ? _instance.id : (id as String),
      name: name == _undefined || name == null
          ? _instance.name
          : (name as String),
      $__typename: $__typename == _undefined || $__typename == null
          ? _instance.$__typename
          : ($__typename as String),
    ),
  );
}

class _CopyWithStubImpl$Query$seriesById$seriesById$books$author<TRes>
    implements CopyWith$Query$seriesById$seriesById$books$author<TRes> {
  _CopyWithStubImpl$Query$seriesById$seriesById$books$author(this._res);

  TRes _res;

  call({String? id, String? name, String? $__typename}) => _res;
}

class Query$seriesById$seriesById$books$series
    implements Fragment$fragmentBook$series {
  Query$seriesById$seriesById$books$series({
    required this.id,
    required this.name,
    this.$__typename = 'Series',
  });

  factory Query$seriesById$seriesById$books$series.fromJson(
    Map<String, dynamic> json,
  ) {
    final l$id = json['id'];
    final l$name = json['name'];
    final l$$__typename = json['__typename'];
    return Query$seriesById$seriesById$books$series(
      id: (l$id as String),
      name: (l$name as String),
      $__typename: (l$$__typename as String),
    );
  }

  final String id;

  final String name;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$id = id;
    _resultData['id'] = l$id;
    final l$name = name;
    _resultData['name'] = l$name;
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$id = id;
    final l$name = name;
    final l$$__typename = $__typename;
    return Object.hashAll([l$id, l$name, l$$__typename]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Query$seriesById$seriesById$books$series ||
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
    final l$$__typename = $__typename;
    final lOther$$__typename = other.$__typename;
    if (l$$__typename != lOther$$__typename) {
      return false;
    }
    return true;
  }
}

extension UtilityExtension$Query$seriesById$seriesById$books$series
    on Query$seriesById$seriesById$books$series {
  CopyWith$Query$seriesById$seriesById$books$series<
    Query$seriesById$seriesById$books$series
  >
  get copyWith =>
      CopyWith$Query$seriesById$seriesById$books$series(this, (i) => i);
}

abstract class CopyWith$Query$seriesById$seriesById$books$series<TRes> {
  factory CopyWith$Query$seriesById$seriesById$books$series(
    Query$seriesById$seriesById$books$series instance,
    TRes Function(Query$seriesById$seriesById$books$series) then,
  ) = _CopyWithImpl$Query$seriesById$seriesById$books$series;

  factory CopyWith$Query$seriesById$seriesById$books$series.stub(TRes res) =
      _CopyWithStubImpl$Query$seriesById$seriesById$books$series;

  TRes call({String? id, String? name, String? $__typename});
}

class _CopyWithImpl$Query$seriesById$seriesById$books$series<TRes>
    implements CopyWith$Query$seriesById$seriesById$books$series<TRes> {
  _CopyWithImpl$Query$seriesById$seriesById$books$series(
    this._instance,
    this._then,
  );

  final Query$seriesById$seriesById$books$series _instance;

  final TRes Function(Query$seriesById$seriesById$books$series) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? id = _undefined,
    Object? name = _undefined,
    Object? $__typename = _undefined,
  }) => _then(
    Query$seriesById$seriesById$books$series(
      id: id == _undefined || id == null ? _instance.id : (id as String),
      name: name == _undefined || name == null
          ? _instance.name
          : (name as String),
      $__typename: $__typename == _undefined || $__typename == null
          ? _instance.$__typename
          : ($__typename as String),
    ),
  );
}

class _CopyWithStubImpl$Query$seriesById$seriesById$books$series<TRes>
    implements CopyWith$Query$seriesById$seriesById$books$series<TRes> {
  _CopyWithStubImpl$Query$seriesById$seriesById$books$series(this._res);

  TRes _res;

  call({String? id, String? name, String? $__typename}) => _res;
}

class Query$seriesById$seriesById$books$epubFiles {
  Query$seriesById$seriesById$books$epubFiles({
    required this.id,
    required this.path,
    this.format,
    this.pageCount,
    this.mediaOverlays,
    required this.directory,
    this.$__typename = 'MediaFile',
  });

  factory Query$seriesById$seriesById$books$epubFiles.fromJson(
    Map<String, dynamic> json,
  ) {
    final l$id = json['id'];
    final l$path = json['path'];
    final l$format = json['format'];
    final l$pageCount = json['pageCount'];
    final l$mediaOverlays = json['mediaOverlays'];
    final l$directory = json['directory'];
    final l$$__typename = json['__typename'];
    return Query$seriesById$seriesById$books$epubFiles(
      id: (l$id as String),
      path: (l$path as String),
      format: (l$format as String?),
      pageCount: (l$pageCount as int?),
      mediaOverlays: (l$mediaOverlays as bool?),
      directory: Query$seriesById$seriesById$books$epubFiles$directory.fromJson(
        (l$directory as Map<String, dynamic>),
      ),
      $__typename: (l$$__typename as String),
    );
  }

  final String id;

  final String path;

  final String? format;

  final int? pageCount;

  final bool? mediaOverlays;

  final Query$seriesById$seriesById$books$epubFiles$directory directory;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$id = id;
    _resultData['id'] = l$id;
    final l$path = path;
    _resultData['path'] = l$path;
    final l$format = format;
    _resultData['format'] = l$format;
    final l$pageCount = pageCount;
    _resultData['pageCount'] = l$pageCount;
    final l$mediaOverlays = mediaOverlays;
    _resultData['mediaOverlays'] = l$mediaOverlays;
    final l$directory = directory;
    _resultData['directory'] = l$directory.toJson();
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$id = id;
    final l$path = path;
    final l$format = format;
    final l$pageCount = pageCount;
    final l$mediaOverlays = mediaOverlays;
    final l$directory = directory;
    final l$$__typename = $__typename;
    return Object.hashAll([
      l$id,
      l$path,
      l$format,
      l$pageCount,
      l$mediaOverlays,
      l$directory,
      l$$__typename,
    ]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Query$seriesById$seriesById$books$epubFiles ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$id = id;
    final lOther$id = other.id;
    if (l$id != lOther$id) {
      return false;
    }
    final l$path = path;
    final lOther$path = other.path;
    if (l$path != lOther$path) {
      return false;
    }
    final l$format = format;
    final lOther$format = other.format;
    if (l$format != lOther$format) {
      return false;
    }
    final l$pageCount = pageCount;
    final lOther$pageCount = other.pageCount;
    if (l$pageCount != lOther$pageCount) {
      return false;
    }
    final l$mediaOverlays = mediaOverlays;
    final lOther$mediaOverlays = other.mediaOverlays;
    if (l$mediaOverlays != lOther$mediaOverlays) {
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

extension UtilityExtension$Query$seriesById$seriesById$books$epubFiles
    on Query$seriesById$seriesById$books$epubFiles {
  CopyWith$Query$seriesById$seriesById$books$epubFiles<
    Query$seriesById$seriesById$books$epubFiles
  >
  get copyWith =>
      CopyWith$Query$seriesById$seriesById$books$epubFiles(this, (i) => i);
}

abstract class CopyWith$Query$seriesById$seriesById$books$epubFiles<TRes> {
  factory CopyWith$Query$seriesById$seriesById$books$epubFiles(
    Query$seriesById$seriesById$books$epubFiles instance,
    TRes Function(Query$seriesById$seriesById$books$epubFiles) then,
  ) = _CopyWithImpl$Query$seriesById$seriesById$books$epubFiles;

  factory CopyWith$Query$seriesById$seriesById$books$epubFiles.stub(TRes res) =
      _CopyWithStubImpl$Query$seriesById$seriesById$books$epubFiles;

  TRes call({
    String? id,
    String? path,
    String? format,
    int? pageCount,
    bool? mediaOverlays,
    Query$seriesById$seriesById$books$epubFiles$directory? directory,
    String? $__typename,
  });
  CopyWith$Query$seriesById$seriesById$books$epubFiles$directory<TRes>
  get directory;
}

class _CopyWithImpl$Query$seriesById$seriesById$books$epubFiles<TRes>
    implements CopyWith$Query$seriesById$seriesById$books$epubFiles<TRes> {
  _CopyWithImpl$Query$seriesById$seriesById$books$epubFiles(
    this._instance,
    this._then,
  );

  final Query$seriesById$seriesById$books$epubFiles _instance;

  final TRes Function(Query$seriesById$seriesById$books$epubFiles) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? id = _undefined,
    Object? path = _undefined,
    Object? format = _undefined,
    Object? pageCount = _undefined,
    Object? mediaOverlays = _undefined,
    Object? directory = _undefined,
    Object? $__typename = _undefined,
  }) => _then(
    Query$seriesById$seriesById$books$epubFiles(
      id: id == _undefined || id == null ? _instance.id : (id as String),
      path: path == _undefined || path == null
          ? _instance.path
          : (path as String),
      format: format == _undefined ? _instance.format : (format as String?),
      pageCount: pageCount == _undefined
          ? _instance.pageCount
          : (pageCount as int?),
      mediaOverlays: mediaOverlays == _undefined
          ? _instance.mediaOverlays
          : (mediaOverlays as bool?),
      directory: directory == _undefined || directory == null
          ? _instance.directory
          : (directory
                as Query$seriesById$seriesById$books$epubFiles$directory),
      $__typename: $__typename == _undefined || $__typename == null
          ? _instance.$__typename
          : ($__typename as String),
    ),
  );

  CopyWith$Query$seriesById$seriesById$books$epubFiles$directory<TRes>
  get directory {
    final local$directory = _instance.directory;
    return CopyWith$Query$seriesById$seriesById$books$epubFiles$directory(
      local$directory,
      (e) => call(directory: e),
    );
  }
}

class _CopyWithStubImpl$Query$seriesById$seriesById$books$epubFiles<TRes>
    implements CopyWith$Query$seriesById$seriesById$books$epubFiles<TRes> {
  _CopyWithStubImpl$Query$seriesById$seriesById$books$epubFiles(this._res);

  TRes _res;

  call({
    String? id,
    String? path,
    String? format,
    int? pageCount,
    bool? mediaOverlays,
    Query$seriesById$seriesById$books$epubFiles$directory? directory,
    String? $__typename,
  }) => _res;

  CopyWith$Query$seriesById$seriesById$books$epubFiles$directory<TRes>
  get directory =>
      CopyWith$Query$seriesById$seriesById$books$epubFiles$directory.stub(_res);
}

class Query$seriesById$seriesById$books$epubFiles$directory {
  Query$seriesById$seriesById$books$epubFiles$directory({
    required this.node,
    this.$__typename = 'Directory',
  });

  factory Query$seriesById$seriesById$books$epubFiles$directory.fromJson(
    Map<String, dynamic> json,
  ) {
    final l$node = json['node'];
    final l$$__typename = json['__typename'];
    return Query$seriesById$seriesById$books$epubFiles$directory(
      node: Query$seriesById$seriesById$books$epubFiles$directory$node.fromJson(
        (l$node as Map<String, dynamic>),
      ),
      $__typename: (l$$__typename as String),
    );
  }

  final Query$seriesById$seriesById$books$epubFiles$directory$node node;

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
    if (other is! Query$seriesById$seriesById$books$epubFiles$directory ||
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

extension UtilityExtension$Query$seriesById$seriesById$books$epubFiles$directory
    on Query$seriesById$seriesById$books$epubFiles$directory {
  CopyWith$Query$seriesById$seriesById$books$epubFiles$directory<
    Query$seriesById$seriesById$books$epubFiles$directory
  >
  get copyWith =>
      CopyWith$Query$seriesById$seriesById$books$epubFiles$directory(
        this,
        (i) => i,
      );
}

abstract class CopyWith$Query$seriesById$seriesById$books$epubFiles$directory<
  TRes
> {
  factory CopyWith$Query$seriesById$seriesById$books$epubFiles$directory(
    Query$seriesById$seriesById$books$epubFiles$directory instance,
    TRes Function(Query$seriesById$seriesById$books$epubFiles$directory) then,
  ) = _CopyWithImpl$Query$seriesById$seriesById$books$epubFiles$directory;

  factory CopyWith$Query$seriesById$seriesById$books$epubFiles$directory.stub(
    TRes res,
  ) = _CopyWithStubImpl$Query$seriesById$seriesById$books$epubFiles$directory;

  TRes call({
    Query$seriesById$seriesById$books$epubFiles$directory$node? node,
    String? $__typename,
  });
  CopyWith$Query$seriesById$seriesById$books$epubFiles$directory$node<TRes>
  get node;
}

class _CopyWithImpl$Query$seriesById$seriesById$books$epubFiles$directory<TRes>
    implements
        CopyWith$Query$seriesById$seriesById$books$epubFiles$directory<TRes> {
  _CopyWithImpl$Query$seriesById$seriesById$books$epubFiles$directory(
    this._instance,
    this._then,
  );

  final Query$seriesById$seriesById$books$epubFiles$directory _instance;

  final TRes Function(Query$seriesById$seriesById$books$epubFiles$directory)
  _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? node = _undefined,
    Object? $__typename = _undefined,
  }) => _then(
    Query$seriesById$seriesById$books$epubFiles$directory(
      node: node == _undefined || node == null
          ? _instance.node
          : (node
                as Query$seriesById$seriesById$books$epubFiles$directory$node),
      $__typename: $__typename == _undefined || $__typename == null
          ? _instance.$__typename
          : ($__typename as String),
    ),
  );

  CopyWith$Query$seriesById$seriesById$books$epubFiles$directory$node<TRes>
  get node {
    final local$node = _instance.node;
    return CopyWith$Query$seriesById$seriesById$books$epubFiles$directory$node(
      local$node,
      (e) => call(node: e),
    );
  }
}

class _CopyWithStubImpl$Query$seriesById$seriesById$books$epubFiles$directory<
  TRes
>
    implements
        CopyWith$Query$seriesById$seriesById$books$epubFiles$directory<TRes> {
  _CopyWithStubImpl$Query$seriesById$seriesById$books$epubFiles$directory(
    this._res,
  );

  TRes _res;

  call({
    Query$seriesById$seriesById$books$epubFiles$directory$node? node,
    String? $__typename,
  }) => _res;

  CopyWith$Query$seriesById$seriesById$books$epubFiles$directory$node<TRes>
  get node =>
      CopyWith$Query$seriesById$seriesById$books$epubFiles$directory$node.stub(
        _res,
      );
}

class Query$seriesById$seriesById$books$epubFiles$directory$node {
  Query$seriesById$seriesById$books$epubFiles$directory$node({
    required this.url,
    this.$__typename = 'Node',
  });

  factory Query$seriesById$seriesById$books$epubFiles$directory$node.fromJson(
    Map<String, dynamic> json,
  ) {
    final l$url = json['url'];
    final l$$__typename = json['__typename'];
    return Query$seriesById$seriesById$books$epubFiles$directory$node(
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
    if (other is! Query$seriesById$seriesById$books$epubFiles$directory$node ||
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

extension UtilityExtension$Query$seriesById$seriesById$books$epubFiles$directory$node
    on Query$seriesById$seriesById$books$epubFiles$directory$node {
  CopyWith$Query$seriesById$seriesById$books$epubFiles$directory$node<
    Query$seriesById$seriesById$books$epubFiles$directory$node
  >
  get copyWith =>
      CopyWith$Query$seriesById$seriesById$books$epubFiles$directory$node(
        this,
        (i) => i,
      );
}

abstract class CopyWith$Query$seriesById$seriesById$books$epubFiles$directory$node<
  TRes
> {
  factory CopyWith$Query$seriesById$seriesById$books$epubFiles$directory$node(
    Query$seriesById$seriesById$books$epubFiles$directory$node instance,
    TRes Function(Query$seriesById$seriesById$books$epubFiles$directory$node)
    then,
  ) = _CopyWithImpl$Query$seriesById$seriesById$books$epubFiles$directory$node;

  factory CopyWith$Query$seriesById$seriesById$books$epubFiles$directory$node.stub(
    TRes res,
  ) = _CopyWithStubImpl$Query$seriesById$seriesById$books$epubFiles$directory$node;

  TRes call({String? url, String? $__typename});
}

class _CopyWithImpl$Query$seriesById$seriesById$books$epubFiles$directory$node<
  TRes
>
    implements
        CopyWith$Query$seriesById$seriesById$books$epubFiles$directory$node<
          TRes
        > {
  _CopyWithImpl$Query$seriesById$seriesById$books$epubFiles$directory$node(
    this._instance,
    this._then,
  );

  final Query$seriesById$seriesById$books$epubFiles$directory$node _instance;

  final TRes Function(
    Query$seriesById$seriesById$books$epubFiles$directory$node,
  )
  _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({Object? url = _undefined, Object? $__typename = _undefined}) =>
      _then(
        Query$seriesById$seriesById$books$epubFiles$directory$node(
          url: url == _undefined || url == null
              ? _instance.url
              : (url as String),
          $__typename: $__typename == _undefined || $__typename == null
              ? _instance.$__typename
              : ($__typename as String),
        ),
      );
}

class _CopyWithStubImpl$Query$seriesById$seriesById$books$epubFiles$directory$node<
  TRes
>
    implements
        CopyWith$Query$seriesById$seriesById$books$epubFiles$directory$node<
          TRes
        > {
  _CopyWithStubImpl$Query$seriesById$seriesById$books$epubFiles$directory$node(
    this._res,
  );

  TRes _res;

  call({String? url, String? $__typename}) => _res;
}

class Query$seriesById$seriesById$books$watchStatus {
  Query$seriesById$seriesById$books$watchStatus({
    required this.id,
    required this.watched,
    this.readingLocation,
    this.readingProgress,
    this.$__typename = 'WatchStatus',
  });

  factory Query$seriesById$seriesById$books$watchStatus.fromJson(
    Map<String, dynamic> json,
  ) {
    final l$id = json['id'];
    final l$watched = json['watched'];
    final l$readingLocation = json['readingLocation'];
    final l$readingProgress = json['readingProgress'];
    final l$$__typename = json['__typename'];
    return Query$seriesById$seriesById$books$watchStatus(
      id: (l$id as String),
      watched: (l$watched as bool),
      readingLocation: (l$readingLocation as String?),
      readingProgress: (l$readingProgress as num?)?.toDouble(),
      $__typename: (l$$__typename as String),
    );
  }

  final String id;

  final bool watched;

  final String? readingLocation;

  final double? readingProgress;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$id = id;
    _resultData['id'] = l$id;
    final l$watched = watched;
    _resultData['watched'] = l$watched;
    final l$readingLocation = readingLocation;
    _resultData['readingLocation'] = l$readingLocation;
    final l$readingProgress = readingProgress;
    _resultData['readingProgress'] = l$readingProgress;
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$id = id;
    final l$watched = watched;
    final l$readingLocation = readingLocation;
    final l$readingProgress = readingProgress;
    final l$$__typename = $__typename;
    return Object.hashAll([
      l$id,
      l$watched,
      l$readingLocation,
      l$readingProgress,
      l$$__typename,
    ]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Query$seriesById$seriesById$books$watchStatus ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$id = id;
    final lOther$id = other.id;
    if (l$id != lOther$id) {
      return false;
    }
    final l$watched = watched;
    final lOther$watched = other.watched;
    if (l$watched != lOther$watched) {
      return false;
    }
    final l$readingLocation = readingLocation;
    final lOther$readingLocation = other.readingLocation;
    if (l$readingLocation != lOther$readingLocation) {
      return false;
    }
    final l$readingProgress = readingProgress;
    final lOther$readingProgress = other.readingProgress;
    if (l$readingProgress != lOther$readingProgress) {
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

extension UtilityExtension$Query$seriesById$seriesById$books$watchStatus
    on Query$seriesById$seriesById$books$watchStatus {
  CopyWith$Query$seriesById$seriesById$books$watchStatus<
    Query$seriesById$seriesById$books$watchStatus
  >
  get copyWith =>
      CopyWith$Query$seriesById$seriesById$books$watchStatus(this, (i) => i);
}

abstract class CopyWith$Query$seriesById$seriesById$books$watchStatus<TRes> {
  factory CopyWith$Query$seriesById$seriesById$books$watchStatus(
    Query$seriesById$seriesById$books$watchStatus instance,
    TRes Function(Query$seriesById$seriesById$books$watchStatus) then,
  ) = _CopyWithImpl$Query$seriesById$seriesById$books$watchStatus;

  factory CopyWith$Query$seriesById$seriesById$books$watchStatus.stub(
    TRes res,
  ) = _CopyWithStubImpl$Query$seriesById$seriesById$books$watchStatus;

  TRes call({
    String? id,
    bool? watched,
    String? readingLocation,
    double? readingProgress,
    String? $__typename,
  });
}

class _CopyWithImpl$Query$seriesById$seriesById$books$watchStatus<TRes>
    implements CopyWith$Query$seriesById$seriesById$books$watchStatus<TRes> {
  _CopyWithImpl$Query$seriesById$seriesById$books$watchStatus(
    this._instance,
    this._then,
  );

  final Query$seriesById$seriesById$books$watchStatus _instance;

  final TRes Function(Query$seriesById$seriesById$books$watchStatus) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? id = _undefined,
    Object? watched = _undefined,
    Object? readingLocation = _undefined,
    Object? readingProgress = _undefined,
    Object? $__typename = _undefined,
  }) => _then(
    Query$seriesById$seriesById$books$watchStatus(
      id: id == _undefined || id == null ? _instance.id : (id as String),
      watched: watched == _undefined || watched == null
          ? _instance.watched
          : (watched as bool),
      readingLocation: readingLocation == _undefined
          ? _instance.readingLocation
          : (readingLocation as String?),
      readingProgress: readingProgress == _undefined
          ? _instance.readingProgress
          : (readingProgress as double?),
      $__typename: $__typename == _undefined || $__typename == null
          ? _instance.$__typename
          : ($__typename as String),
    ),
  );
}

class _CopyWithStubImpl$Query$seriesById$seriesById$books$watchStatus<TRes>
    implements CopyWith$Query$seriesById$seriesById$books$watchStatus<TRes> {
  _CopyWithStubImpl$Query$seriesById$seriesById$books$watchStatus(this._res);

  TRes _res;

  call({
    String? id,
    bool? watched,
    String? readingLocation,
    double? readingProgress,
    String? $__typename,
  }) => _res;
}

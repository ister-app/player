import 'fragmentBook.graphql.dart';
import 'fragmentChapter.graphql.dart';
import 'fragmentImages.graphql.dart';
import 'fragmentMetadata.graphql.dart';
import 'package:gql/ast.dart';

class Variables$Query$bookById {
  factory Variables$Query$bookById({String? id}) =>
      Variables$Query$bookById._({if (id != null) r'id': id});

  Variables$Query$bookById._(this._$data);

  factory Variables$Query$bookById.fromJson(Map<String, dynamic> data) {
    final result$data = <String, dynamic>{};
    if (data.containsKey('id')) {
      final l$id = data['id'];
      result$data['id'] = (l$id as String?);
    }
    return Variables$Query$bookById._(result$data);
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

  CopyWith$Variables$Query$bookById<Variables$Query$bookById> get copyWith =>
      CopyWith$Variables$Query$bookById(this, (i) => i);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Variables$Query$bookById ||
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

abstract class CopyWith$Variables$Query$bookById<TRes> {
  factory CopyWith$Variables$Query$bookById(
    Variables$Query$bookById instance,
    TRes Function(Variables$Query$bookById) then,
  ) = _CopyWithImpl$Variables$Query$bookById;

  factory CopyWith$Variables$Query$bookById.stub(TRes res) =
      _CopyWithStubImpl$Variables$Query$bookById;

  TRes call({String? id});
}

class _CopyWithImpl$Variables$Query$bookById<TRes>
    implements CopyWith$Variables$Query$bookById<TRes> {
  _CopyWithImpl$Variables$Query$bookById(this._instance, this._then);

  final Variables$Query$bookById _instance;

  final TRes Function(Variables$Query$bookById) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({Object? id = _undefined}) => _then(
    Variables$Query$bookById._({
      ..._instance._$data,
      if (id != _undefined) 'id': (id as String?),
    }),
  );
}

class _CopyWithStubImpl$Variables$Query$bookById<TRes>
    implements CopyWith$Variables$Query$bookById<TRes> {
  _CopyWithStubImpl$Variables$Query$bookById(this._res);

  TRes _res;

  call({String? id}) => _res;
}

class Query$bookById {
  Query$bookById({this.bookById, this.$__typename = 'Query'});

  factory Query$bookById.fromJson(Map<String, dynamic> json) {
    final l$bookById = json['bookById'];
    final l$$__typename = json['__typename'];
    return Query$bookById(
      bookById: l$bookById == null
          ? null
          : Query$bookById$bookById.fromJson(
              (l$bookById as Map<String, dynamic>),
            ),
      $__typename: (l$$__typename as String),
    );
  }

  final Query$bookById$bookById? bookById;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$bookById = bookById;
    _resultData['bookById'] = l$bookById?.toJson();
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$bookById = bookById;
    final l$$__typename = $__typename;
    return Object.hashAll([l$bookById, l$$__typename]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Query$bookById || runtimeType != other.runtimeType) {
      return false;
    }
    final l$bookById = bookById;
    final lOther$bookById = other.bookById;
    if (l$bookById != lOther$bookById) {
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

extension UtilityExtension$Query$bookById on Query$bookById {
  CopyWith$Query$bookById<Query$bookById> get copyWith =>
      CopyWith$Query$bookById(this, (i) => i);
}

abstract class CopyWith$Query$bookById<TRes> {
  factory CopyWith$Query$bookById(
    Query$bookById instance,
    TRes Function(Query$bookById) then,
  ) = _CopyWithImpl$Query$bookById;

  factory CopyWith$Query$bookById.stub(TRes res) =
      _CopyWithStubImpl$Query$bookById;

  TRes call({Query$bookById$bookById? bookById, String? $__typename});
  CopyWith$Query$bookById$bookById<TRes> get bookById;
}

class _CopyWithImpl$Query$bookById<TRes>
    implements CopyWith$Query$bookById<TRes> {
  _CopyWithImpl$Query$bookById(this._instance, this._then);

  final Query$bookById _instance;

  final TRes Function(Query$bookById) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? bookById = _undefined,
    Object? $__typename = _undefined,
  }) => _then(
    Query$bookById(
      bookById: bookById == _undefined
          ? _instance.bookById
          : (bookById as Query$bookById$bookById?),
      $__typename: $__typename == _undefined || $__typename == null
          ? _instance.$__typename
          : ($__typename as String),
    ),
  );

  CopyWith$Query$bookById$bookById<TRes> get bookById {
    final local$bookById = _instance.bookById;
    return local$bookById == null
        ? CopyWith$Query$bookById$bookById.stub(_then(_instance))
        : CopyWith$Query$bookById$bookById(
            local$bookById,
            (e) => call(bookById: e),
          );
  }
}

class _CopyWithStubImpl$Query$bookById<TRes>
    implements CopyWith$Query$bookById<TRes> {
  _CopyWithStubImpl$Query$bookById(this._res);

  TRes _res;

  call({Query$bookById$bookById? bookById, String? $__typename}) => _res;

  CopyWith$Query$bookById$bookById<TRes> get bookById =>
      CopyWith$Query$bookById$bookById.stub(_res);
}

const documentNodeQuerybookById = DocumentNode(
  definitions: [
    OperationDefinitionNode(
      type: OperationType.query,
      name: NameNode(value: 'bookById'),
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
            name: NameNode(value: 'bookById'),
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
                  name: NameNode(value: 'fragmentBook'),
                  directives: [],
                ),
                FieldNode(
                  name: NameNode(value: 'chapters'),
                  alias: null,
                  arguments: [],
                  directives: [],
                  selectionSet: SelectionSetNode(
                    selections: [
                      FragmentSpreadNode(
                        name: NameNode(value: 'fragmentChapter'),
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
                  name: NameNode(value: 'resumeChapter'),
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
    fragmentDefinitionfragmentBook,
    fragmentDefinitionfragmentImages,
    fragmentDefinitionfragmentMetadata,
    fragmentDefinitionfragmentChapter,
  ],
);

class Query$bookById$bookById implements Fragment$fragmentBook {
  Query$bookById$bookById({
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
    this.chapters,
    this.resumeChapter,
    this.epubFiles,
    this.watchStatus,
  });

  factory Query$bookById$bookById.fromJson(Map<String, dynamic> json) {
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
    final l$chapters = json['chapters'];
    final l$resumeChapter = json['resumeChapter'];
    final l$epubFiles = json['epubFiles'];
    final l$watchStatus = json['watchStatus'];
    return Query$bookById$bookById(
      id: (l$id as String),
      name: (l$name as String),
      title: (l$title as String),
      releaseYear: (l$releaseYear as int),
      seriesIndex: (l$seriesIndex as num?)?.toDouble(),
      author: l$author == null
          ? null
          : Query$bookById$bookById$author.fromJson(
              (l$author as Map<String, dynamic>),
            ),
      series: l$series == null
          ? null
          : Query$bookById$bookById$series.fromJson(
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
      chapters: (l$chapters as List<dynamic>?)
          ?.map(
            (e) =>
                Fragment$fragmentChapter.fromJson((e as Map<String, dynamic>)),
          )
          .toList(),
      resumeChapter: l$resumeChapter == null
          ? null
          : Query$bookById$bookById$resumeChapter.fromJson(
              (l$resumeChapter as Map<String, dynamic>),
            ),
      epubFiles: (l$epubFiles as List<dynamic>?)
          ?.map(
            (e) => Query$bookById$bookById$epubFiles.fromJson(
              (e as Map<String, dynamic>),
            ),
          )
          .toList(),
      watchStatus: (l$watchStatus as List<dynamic>?)
          ?.map(
            (e) => Query$bookById$bookById$watchStatus.fromJson(
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

  final Query$bookById$bookById$author? author;

  final Query$bookById$bookById$series? series;

  final List<Fragment$fragmentImages>? images;

  final List<Fragment$fragmentMetadata>? metadata;

  final int? rating;

  final String $__typename;

  final List<Fragment$fragmentChapter>? chapters;

  final Query$bookById$bookById$resumeChapter? resumeChapter;

  final List<Query$bookById$bookById$epubFiles>? epubFiles;

  final List<Query$bookById$bookById$watchStatus>? watchStatus;

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
    final l$chapters = chapters;
    _resultData['chapters'] = l$chapters?.map((e) => e.toJson()).toList();
    final l$resumeChapter = resumeChapter;
    _resultData['resumeChapter'] = l$resumeChapter?.toJson();
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
    final l$chapters = chapters;
    final l$resumeChapter = resumeChapter;
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
      l$chapters == null ? null : Object.hashAll(l$chapters.map((v) => v)),
      l$resumeChapter,
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
    if (other is! Query$bookById$bookById || runtimeType != other.runtimeType) {
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
    final l$chapters = chapters;
    final lOther$chapters = other.chapters;
    if (l$chapters != null && lOther$chapters != null) {
      if (l$chapters.length != lOther$chapters.length) {
        return false;
      }
      for (int i = 0; i < l$chapters.length; i++) {
        final l$chapters$entry = l$chapters[i];
        final lOther$chapters$entry = lOther$chapters[i];
        if (l$chapters$entry != lOther$chapters$entry) {
          return false;
        }
      }
    } else if (l$chapters != lOther$chapters) {
      return false;
    }
    final l$resumeChapter = resumeChapter;
    final lOther$resumeChapter = other.resumeChapter;
    if (l$resumeChapter != lOther$resumeChapter) {
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

extension UtilityExtension$Query$bookById$bookById on Query$bookById$bookById {
  CopyWith$Query$bookById$bookById<Query$bookById$bookById> get copyWith =>
      CopyWith$Query$bookById$bookById(this, (i) => i);
}

abstract class CopyWith$Query$bookById$bookById<TRes> {
  factory CopyWith$Query$bookById$bookById(
    Query$bookById$bookById instance,
    TRes Function(Query$bookById$bookById) then,
  ) = _CopyWithImpl$Query$bookById$bookById;

  factory CopyWith$Query$bookById$bookById.stub(TRes res) =
      _CopyWithStubImpl$Query$bookById$bookById;

  TRes call({
    String? id,
    String? name,
    String? title,
    int? releaseYear,
    double? seriesIndex,
    Query$bookById$bookById$author? author,
    Query$bookById$bookById$series? series,
    List<Fragment$fragmentImages>? images,
    List<Fragment$fragmentMetadata>? metadata,
    int? rating,
    String? $__typename,
    List<Fragment$fragmentChapter>? chapters,
    Query$bookById$bookById$resumeChapter? resumeChapter,
    List<Query$bookById$bookById$epubFiles>? epubFiles,
    List<Query$bookById$bookById$watchStatus>? watchStatus,
  });
  CopyWith$Query$bookById$bookById$author<TRes> get author;
  CopyWith$Query$bookById$bookById$series<TRes> get series;
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
  TRes chapters(
    Iterable<Fragment$fragmentChapter>? Function(
      Iterable<CopyWith$Fragment$fragmentChapter<Fragment$fragmentChapter>>?,
    )
    _fn,
  );
  CopyWith$Query$bookById$bookById$resumeChapter<TRes> get resumeChapter;
  TRes epubFiles(
    Iterable<Query$bookById$bookById$epubFiles>? Function(
      Iterable<
        CopyWith$Query$bookById$bookById$epubFiles<
          Query$bookById$bookById$epubFiles
        >
      >?,
    )
    _fn,
  );
  TRes watchStatus(
    Iterable<Query$bookById$bookById$watchStatus>? Function(
      Iterable<
        CopyWith$Query$bookById$bookById$watchStatus<
          Query$bookById$bookById$watchStatus
        >
      >?,
    )
    _fn,
  );
}

class _CopyWithImpl$Query$bookById$bookById<TRes>
    implements CopyWith$Query$bookById$bookById<TRes> {
  _CopyWithImpl$Query$bookById$bookById(this._instance, this._then);

  final Query$bookById$bookById _instance;

  final TRes Function(Query$bookById$bookById) _then;

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
    Object? chapters = _undefined,
    Object? resumeChapter = _undefined,
    Object? epubFiles = _undefined,
    Object? watchStatus = _undefined,
  }) => _then(
    Query$bookById$bookById(
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
          : (author as Query$bookById$bookById$author?),
      series: series == _undefined
          ? _instance.series
          : (series as Query$bookById$bookById$series?),
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
      chapters: chapters == _undefined
          ? _instance.chapters
          : (chapters as List<Fragment$fragmentChapter>?),
      resumeChapter: resumeChapter == _undefined
          ? _instance.resumeChapter
          : (resumeChapter as Query$bookById$bookById$resumeChapter?),
      epubFiles: epubFiles == _undefined
          ? _instance.epubFiles
          : (epubFiles as List<Query$bookById$bookById$epubFiles>?),
      watchStatus: watchStatus == _undefined
          ? _instance.watchStatus
          : (watchStatus as List<Query$bookById$bookById$watchStatus>?),
    ),
  );

  CopyWith$Query$bookById$bookById$author<TRes> get author {
    final local$author = _instance.author;
    return local$author == null
        ? CopyWith$Query$bookById$bookById$author.stub(_then(_instance))
        : CopyWith$Query$bookById$bookById$author(
            local$author,
            (e) => call(author: e),
          );
  }

  CopyWith$Query$bookById$bookById$series<TRes> get series {
    final local$series = _instance.series;
    return local$series == null
        ? CopyWith$Query$bookById$bookById$series.stub(_then(_instance))
        : CopyWith$Query$bookById$bookById$series(
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

  TRes chapters(
    Iterable<Fragment$fragmentChapter>? Function(
      Iterable<CopyWith$Fragment$fragmentChapter<Fragment$fragmentChapter>>?,
    )
    _fn,
  ) => call(
    chapters: _fn(
      _instance.chapters?.map(
        (e) => CopyWith$Fragment$fragmentChapter(e, (i) => i),
      ),
    )?.toList(),
  );

  CopyWith$Query$bookById$bookById$resumeChapter<TRes> get resumeChapter {
    final local$resumeChapter = _instance.resumeChapter;
    return local$resumeChapter == null
        ? CopyWith$Query$bookById$bookById$resumeChapter.stub(_then(_instance))
        : CopyWith$Query$bookById$bookById$resumeChapter(
            local$resumeChapter,
            (e) => call(resumeChapter: e),
          );
  }

  TRes epubFiles(
    Iterable<Query$bookById$bookById$epubFiles>? Function(
      Iterable<
        CopyWith$Query$bookById$bookById$epubFiles<
          Query$bookById$bookById$epubFiles
        >
      >?,
    )
    _fn,
  ) => call(
    epubFiles: _fn(
      _instance.epubFiles?.map(
        (e) => CopyWith$Query$bookById$bookById$epubFiles(e, (i) => i),
      ),
    )?.toList(),
  );

  TRes watchStatus(
    Iterable<Query$bookById$bookById$watchStatus>? Function(
      Iterable<
        CopyWith$Query$bookById$bookById$watchStatus<
          Query$bookById$bookById$watchStatus
        >
      >?,
    )
    _fn,
  ) => call(
    watchStatus: _fn(
      _instance.watchStatus?.map(
        (e) => CopyWith$Query$bookById$bookById$watchStatus(e, (i) => i),
      ),
    )?.toList(),
  );
}

class _CopyWithStubImpl$Query$bookById$bookById<TRes>
    implements CopyWith$Query$bookById$bookById<TRes> {
  _CopyWithStubImpl$Query$bookById$bookById(this._res);

  TRes _res;

  call({
    String? id,
    String? name,
    String? title,
    int? releaseYear,
    double? seriesIndex,
    Query$bookById$bookById$author? author,
    Query$bookById$bookById$series? series,
    List<Fragment$fragmentImages>? images,
    List<Fragment$fragmentMetadata>? metadata,
    int? rating,
    String? $__typename,
    List<Fragment$fragmentChapter>? chapters,
    Query$bookById$bookById$resumeChapter? resumeChapter,
    List<Query$bookById$bookById$epubFiles>? epubFiles,
    List<Query$bookById$bookById$watchStatus>? watchStatus,
  }) => _res;

  CopyWith$Query$bookById$bookById$author<TRes> get author =>
      CopyWith$Query$bookById$bookById$author.stub(_res);

  CopyWith$Query$bookById$bookById$series<TRes> get series =>
      CopyWith$Query$bookById$bookById$series.stub(_res);

  images(_fn) => _res;

  metadata(_fn) => _res;

  chapters(_fn) => _res;

  CopyWith$Query$bookById$bookById$resumeChapter<TRes> get resumeChapter =>
      CopyWith$Query$bookById$bookById$resumeChapter.stub(_res);

  epubFiles(_fn) => _res;

  watchStatus(_fn) => _res;
}

class Query$bookById$bookById$author implements Fragment$fragmentBook$author {
  Query$bookById$bookById$author({
    required this.id,
    required this.name,
    this.$__typename = 'Person',
  });

  factory Query$bookById$bookById$author.fromJson(Map<String, dynamic> json) {
    final l$id = json['id'];
    final l$name = json['name'];
    final l$$__typename = json['__typename'];
    return Query$bookById$bookById$author(
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
    if (other is! Query$bookById$bookById$author ||
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

extension UtilityExtension$Query$bookById$bookById$author
    on Query$bookById$bookById$author {
  CopyWith$Query$bookById$bookById$author<Query$bookById$bookById$author>
  get copyWith => CopyWith$Query$bookById$bookById$author(this, (i) => i);
}

abstract class CopyWith$Query$bookById$bookById$author<TRes> {
  factory CopyWith$Query$bookById$bookById$author(
    Query$bookById$bookById$author instance,
    TRes Function(Query$bookById$bookById$author) then,
  ) = _CopyWithImpl$Query$bookById$bookById$author;

  factory CopyWith$Query$bookById$bookById$author.stub(TRes res) =
      _CopyWithStubImpl$Query$bookById$bookById$author;

  TRes call({String? id, String? name, String? $__typename});
}

class _CopyWithImpl$Query$bookById$bookById$author<TRes>
    implements CopyWith$Query$bookById$bookById$author<TRes> {
  _CopyWithImpl$Query$bookById$bookById$author(this._instance, this._then);

  final Query$bookById$bookById$author _instance;

  final TRes Function(Query$bookById$bookById$author) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? id = _undefined,
    Object? name = _undefined,
    Object? $__typename = _undefined,
  }) => _then(
    Query$bookById$bookById$author(
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

class _CopyWithStubImpl$Query$bookById$bookById$author<TRes>
    implements CopyWith$Query$bookById$bookById$author<TRes> {
  _CopyWithStubImpl$Query$bookById$bookById$author(this._res);

  TRes _res;

  call({String? id, String? name, String? $__typename}) => _res;
}

class Query$bookById$bookById$series implements Fragment$fragmentBook$series {
  Query$bookById$bookById$series({
    required this.id,
    required this.name,
    this.$__typename = 'Series',
  });

  factory Query$bookById$bookById$series.fromJson(Map<String, dynamic> json) {
    final l$id = json['id'];
    final l$name = json['name'];
    final l$$__typename = json['__typename'];
    return Query$bookById$bookById$series(
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
    if (other is! Query$bookById$bookById$series ||
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

extension UtilityExtension$Query$bookById$bookById$series
    on Query$bookById$bookById$series {
  CopyWith$Query$bookById$bookById$series<Query$bookById$bookById$series>
  get copyWith => CopyWith$Query$bookById$bookById$series(this, (i) => i);
}

abstract class CopyWith$Query$bookById$bookById$series<TRes> {
  factory CopyWith$Query$bookById$bookById$series(
    Query$bookById$bookById$series instance,
    TRes Function(Query$bookById$bookById$series) then,
  ) = _CopyWithImpl$Query$bookById$bookById$series;

  factory CopyWith$Query$bookById$bookById$series.stub(TRes res) =
      _CopyWithStubImpl$Query$bookById$bookById$series;

  TRes call({String? id, String? name, String? $__typename});
}

class _CopyWithImpl$Query$bookById$bookById$series<TRes>
    implements CopyWith$Query$bookById$bookById$series<TRes> {
  _CopyWithImpl$Query$bookById$bookById$series(this._instance, this._then);

  final Query$bookById$bookById$series _instance;

  final TRes Function(Query$bookById$bookById$series) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? id = _undefined,
    Object? name = _undefined,
    Object? $__typename = _undefined,
  }) => _then(
    Query$bookById$bookById$series(
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

class _CopyWithStubImpl$Query$bookById$bookById$series<TRes>
    implements CopyWith$Query$bookById$bookById$series<TRes> {
  _CopyWithStubImpl$Query$bookById$bookById$series(this._res);

  TRes _res;

  call({String? id, String? name, String? $__typename}) => _res;
}

class Query$bookById$bookById$resumeChapter {
  Query$bookById$bookById$resumeChapter({
    required this.id,
    this.$__typename = 'Chapter',
  });

  factory Query$bookById$bookById$resumeChapter.fromJson(
    Map<String, dynamic> json,
  ) {
    final l$id = json['id'];
    final l$$__typename = json['__typename'];
    return Query$bookById$bookById$resumeChapter(
      id: (l$id as String),
      $__typename: (l$$__typename as String),
    );
  }

  final String id;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$id = id;
    _resultData['id'] = l$id;
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$id = id;
    final l$$__typename = $__typename;
    return Object.hashAll([l$id, l$$__typename]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Query$bookById$bookById$resumeChapter ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$id = id;
    final lOther$id = other.id;
    if (l$id != lOther$id) {
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

extension UtilityExtension$Query$bookById$bookById$resumeChapter
    on Query$bookById$bookById$resumeChapter {
  CopyWith$Query$bookById$bookById$resumeChapter<
    Query$bookById$bookById$resumeChapter
  >
  get copyWith =>
      CopyWith$Query$bookById$bookById$resumeChapter(this, (i) => i);
}

abstract class CopyWith$Query$bookById$bookById$resumeChapter<TRes> {
  factory CopyWith$Query$bookById$bookById$resumeChapter(
    Query$bookById$bookById$resumeChapter instance,
    TRes Function(Query$bookById$bookById$resumeChapter) then,
  ) = _CopyWithImpl$Query$bookById$bookById$resumeChapter;

  factory CopyWith$Query$bookById$bookById$resumeChapter.stub(TRes res) =
      _CopyWithStubImpl$Query$bookById$bookById$resumeChapter;

  TRes call({String? id, String? $__typename});
}

class _CopyWithImpl$Query$bookById$bookById$resumeChapter<TRes>
    implements CopyWith$Query$bookById$bookById$resumeChapter<TRes> {
  _CopyWithImpl$Query$bookById$bookById$resumeChapter(
    this._instance,
    this._then,
  );

  final Query$bookById$bookById$resumeChapter _instance;

  final TRes Function(Query$bookById$bookById$resumeChapter) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({Object? id = _undefined, Object? $__typename = _undefined}) =>
      _then(
        Query$bookById$bookById$resumeChapter(
          id: id == _undefined || id == null ? _instance.id : (id as String),
          $__typename: $__typename == _undefined || $__typename == null
              ? _instance.$__typename
              : ($__typename as String),
        ),
      );
}

class _CopyWithStubImpl$Query$bookById$bookById$resumeChapter<TRes>
    implements CopyWith$Query$bookById$bookById$resumeChapter<TRes> {
  _CopyWithStubImpl$Query$bookById$bookById$resumeChapter(this._res);

  TRes _res;

  call({String? id, String? $__typename}) => _res;
}

class Query$bookById$bookById$epubFiles {
  Query$bookById$bookById$epubFiles({
    required this.id,
    required this.path,
    this.format,
    this.pageCount,
    this.mediaOverlays,
    required this.directory,
    this.$__typename = 'MediaFile',
  });

  factory Query$bookById$bookById$epubFiles.fromJson(
    Map<String, dynamic> json,
  ) {
    final l$id = json['id'];
    final l$path = json['path'];
    final l$format = json['format'];
    final l$pageCount = json['pageCount'];
    final l$mediaOverlays = json['mediaOverlays'];
    final l$directory = json['directory'];
    final l$$__typename = json['__typename'];
    return Query$bookById$bookById$epubFiles(
      id: (l$id as String),
      path: (l$path as String),
      format: (l$format as String?),
      pageCount: (l$pageCount as int?),
      mediaOverlays: (l$mediaOverlays as bool?),
      directory: Query$bookById$bookById$epubFiles$directory.fromJson(
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

  final Query$bookById$bookById$epubFiles$directory directory;

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
    if (other is! Query$bookById$bookById$epubFiles ||
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

extension UtilityExtension$Query$bookById$bookById$epubFiles
    on Query$bookById$bookById$epubFiles {
  CopyWith$Query$bookById$bookById$epubFiles<Query$bookById$bookById$epubFiles>
  get copyWith => CopyWith$Query$bookById$bookById$epubFiles(this, (i) => i);
}

abstract class CopyWith$Query$bookById$bookById$epubFiles<TRes> {
  factory CopyWith$Query$bookById$bookById$epubFiles(
    Query$bookById$bookById$epubFiles instance,
    TRes Function(Query$bookById$bookById$epubFiles) then,
  ) = _CopyWithImpl$Query$bookById$bookById$epubFiles;

  factory CopyWith$Query$bookById$bookById$epubFiles.stub(TRes res) =
      _CopyWithStubImpl$Query$bookById$bookById$epubFiles;

  TRes call({
    String? id,
    String? path,
    String? format,
    int? pageCount,
    bool? mediaOverlays,
    Query$bookById$bookById$epubFiles$directory? directory,
    String? $__typename,
  });
  CopyWith$Query$bookById$bookById$epubFiles$directory<TRes> get directory;
}

class _CopyWithImpl$Query$bookById$bookById$epubFiles<TRes>
    implements CopyWith$Query$bookById$bookById$epubFiles<TRes> {
  _CopyWithImpl$Query$bookById$bookById$epubFiles(this._instance, this._then);

  final Query$bookById$bookById$epubFiles _instance;

  final TRes Function(Query$bookById$bookById$epubFiles) _then;

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
    Query$bookById$bookById$epubFiles(
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
          : (directory as Query$bookById$bookById$epubFiles$directory),
      $__typename: $__typename == _undefined || $__typename == null
          ? _instance.$__typename
          : ($__typename as String),
    ),
  );

  CopyWith$Query$bookById$bookById$epubFiles$directory<TRes> get directory {
    final local$directory = _instance.directory;
    return CopyWith$Query$bookById$bookById$epubFiles$directory(
      local$directory,
      (e) => call(directory: e),
    );
  }
}

class _CopyWithStubImpl$Query$bookById$bookById$epubFiles<TRes>
    implements CopyWith$Query$bookById$bookById$epubFiles<TRes> {
  _CopyWithStubImpl$Query$bookById$bookById$epubFiles(this._res);

  TRes _res;

  call({
    String? id,
    String? path,
    String? format,
    int? pageCount,
    bool? mediaOverlays,
    Query$bookById$bookById$epubFiles$directory? directory,
    String? $__typename,
  }) => _res;

  CopyWith$Query$bookById$bookById$epubFiles$directory<TRes> get directory =>
      CopyWith$Query$bookById$bookById$epubFiles$directory.stub(_res);
}

class Query$bookById$bookById$epubFiles$directory {
  Query$bookById$bookById$epubFiles$directory({
    required this.node,
    this.$__typename = 'Directory',
  });

  factory Query$bookById$bookById$epubFiles$directory.fromJson(
    Map<String, dynamic> json,
  ) {
    final l$node = json['node'];
    final l$$__typename = json['__typename'];
    return Query$bookById$bookById$epubFiles$directory(
      node: Query$bookById$bookById$epubFiles$directory$node.fromJson(
        (l$node as Map<String, dynamic>),
      ),
      $__typename: (l$$__typename as String),
    );
  }

  final Query$bookById$bookById$epubFiles$directory$node node;

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
    if (other is! Query$bookById$bookById$epubFiles$directory ||
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

extension UtilityExtension$Query$bookById$bookById$epubFiles$directory
    on Query$bookById$bookById$epubFiles$directory {
  CopyWith$Query$bookById$bookById$epubFiles$directory<
    Query$bookById$bookById$epubFiles$directory
  >
  get copyWith =>
      CopyWith$Query$bookById$bookById$epubFiles$directory(this, (i) => i);
}

abstract class CopyWith$Query$bookById$bookById$epubFiles$directory<TRes> {
  factory CopyWith$Query$bookById$bookById$epubFiles$directory(
    Query$bookById$bookById$epubFiles$directory instance,
    TRes Function(Query$bookById$bookById$epubFiles$directory) then,
  ) = _CopyWithImpl$Query$bookById$bookById$epubFiles$directory;

  factory CopyWith$Query$bookById$bookById$epubFiles$directory.stub(TRes res) =
      _CopyWithStubImpl$Query$bookById$bookById$epubFiles$directory;

  TRes call({
    Query$bookById$bookById$epubFiles$directory$node? node,
    String? $__typename,
  });
  CopyWith$Query$bookById$bookById$epubFiles$directory$node<TRes> get node;
}

class _CopyWithImpl$Query$bookById$bookById$epubFiles$directory<TRes>
    implements CopyWith$Query$bookById$bookById$epubFiles$directory<TRes> {
  _CopyWithImpl$Query$bookById$bookById$epubFiles$directory(
    this._instance,
    this._then,
  );

  final Query$bookById$bookById$epubFiles$directory _instance;

  final TRes Function(Query$bookById$bookById$epubFiles$directory) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({Object? node = _undefined, Object? $__typename = _undefined}) =>
      _then(
        Query$bookById$bookById$epubFiles$directory(
          node: node == _undefined || node == null
              ? _instance.node
              : (node as Query$bookById$bookById$epubFiles$directory$node),
          $__typename: $__typename == _undefined || $__typename == null
              ? _instance.$__typename
              : ($__typename as String),
        ),
      );

  CopyWith$Query$bookById$bookById$epubFiles$directory$node<TRes> get node {
    final local$node = _instance.node;
    return CopyWith$Query$bookById$bookById$epubFiles$directory$node(
      local$node,
      (e) => call(node: e),
    );
  }
}

class _CopyWithStubImpl$Query$bookById$bookById$epubFiles$directory<TRes>
    implements CopyWith$Query$bookById$bookById$epubFiles$directory<TRes> {
  _CopyWithStubImpl$Query$bookById$bookById$epubFiles$directory(this._res);

  TRes _res;

  call({
    Query$bookById$bookById$epubFiles$directory$node? node,
    String? $__typename,
  }) => _res;

  CopyWith$Query$bookById$bookById$epubFiles$directory$node<TRes> get node =>
      CopyWith$Query$bookById$bookById$epubFiles$directory$node.stub(_res);
}

class Query$bookById$bookById$epubFiles$directory$node {
  Query$bookById$bookById$epubFiles$directory$node({
    required this.url,
    this.$__typename = 'Node',
  });

  factory Query$bookById$bookById$epubFiles$directory$node.fromJson(
    Map<String, dynamic> json,
  ) {
    final l$url = json['url'];
    final l$$__typename = json['__typename'];
    return Query$bookById$bookById$epubFiles$directory$node(
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
    if (other is! Query$bookById$bookById$epubFiles$directory$node ||
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

extension UtilityExtension$Query$bookById$bookById$epubFiles$directory$node
    on Query$bookById$bookById$epubFiles$directory$node {
  CopyWith$Query$bookById$bookById$epubFiles$directory$node<
    Query$bookById$bookById$epubFiles$directory$node
  >
  get copyWith =>
      CopyWith$Query$bookById$bookById$epubFiles$directory$node(this, (i) => i);
}

abstract class CopyWith$Query$bookById$bookById$epubFiles$directory$node<TRes> {
  factory CopyWith$Query$bookById$bookById$epubFiles$directory$node(
    Query$bookById$bookById$epubFiles$directory$node instance,
    TRes Function(Query$bookById$bookById$epubFiles$directory$node) then,
  ) = _CopyWithImpl$Query$bookById$bookById$epubFiles$directory$node;

  factory CopyWith$Query$bookById$bookById$epubFiles$directory$node.stub(
    TRes res,
  ) = _CopyWithStubImpl$Query$bookById$bookById$epubFiles$directory$node;

  TRes call({String? url, String? $__typename});
}

class _CopyWithImpl$Query$bookById$bookById$epubFiles$directory$node<TRes>
    implements CopyWith$Query$bookById$bookById$epubFiles$directory$node<TRes> {
  _CopyWithImpl$Query$bookById$bookById$epubFiles$directory$node(
    this._instance,
    this._then,
  );

  final Query$bookById$bookById$epubFiles$directory$node _instance;

  final TRes Function(Query$bookById$bookById$epubFiles$directory$node) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({Object? url = _undefined, Object? $__typename = _undefined}) =>
      _then(
        Query$bookById$bookById$epubFiles$directory$node(
          url: url == _undefined || url == null
              ? _instance.url
              : (url as String),
          $__typename: $__typename == _undefined || $__typename == null
              ? _instance.$__typename
              : ($__typename as String),
        ),
      );
}

class _CopyWithStubImpl$Query$bookById$bookById$epubFiles$directory$node<TRes>
    implements CopyWith$Query$bookById$bookById$epubFiles$directory$node<TRes> {
  _CopyWithStubImpl$Query$bookById$bookById$epubFiles$directory$node(this._res);

  TRes _res;

  call({String? url, String? $__typename}) => _res;
}

class Query$bookById$bookById$watchStatus {
  Query$bookById$bookById$watchStatus({
    required this.id,
    required this.watched,
    this.readingLocation,
    this.readingProgress,
    this.$__typename = 'WatchStatus',
  });

  factory Query$bookById$bookById$watchStatus.fromJson(
    Map<String, dynamic> json,
  ) {
    final l$id = json['id'];
    final l$watched = json['watched'];
    final l$readingLocation = json['readingLocation'];
    final l$readingProgress = json['readingProgress'];
    final l$$__typename = json['__typename'];
    return Query$bookById$bookById$watchStatus(
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
    if (other is! Query$bookById$bookById$watchStatus ||
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

extension UtilityExtension$Query$bookById$bookById$watchStatus
    on Query$bookById$bookById$watchStatus {
  CopyWith$Query$bookById$bookById$watchStatus<
    Query$bookById$bookById$watchStatus
  >
  get copyWith => CopyWith$Query$bookById$bookById$watchStatus(this, (i) => i);
}

abstract class CopyWith$Query$bookById$bookById$watchStatus<TRes> {
  factory CopyWith$Query$bookById$bookById$watchStatus(
    Query$bookById$bookById$watchStatus instance,
    TRes Function(Query$bookById$bookById$watchStatus) then,
  ) = _CopyWithImpl$Query$bookById$bookById$watchStatus;

  factory CopyWith$Query$bookById$bookById$watchStatus.stub(TRes res) =
      _CopyWithStubImpl$Query$bookById$bookById$watchStatus;

  TRes call({
    String? id,
    bool? watched,
    String? readingLocation,
    double? readingProgress,
    String? $__typename,
  });
}

class _CopyWithImpl$Query$bookById$bookById$watchStatus<TRes>
    implements CopyWith$Query$bookById$bookById$watchStatus<TRes> {
  _CopyWithImpl$Query$bookById$bookById$watchStatus(this._instance, this._then);

  final Query$bookById$bookById$watchStatus _instance;

  final TRes Function(Query$bookById$bookById$watchStatus) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? id = _undefined,
    Object? watched = _undefined,
    Object? readingLocation = _undefined,
    Object? readingProgress = _undefined,
    Object? $__typename = _undefined,
  }) => _then(
    Query$bookById$bookById$watchStatus(
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

class _CopyWithStubImpl$Query$bookById$bookById$watchStatus<TRes>
    implements CopyWith$Query$bookById$bookById$watchStatus<TRes> {
  _CopyWithStubImpl$Query$bookById$bookById$watchStatus(this._res);

  TRes _res;

  call({
    String? id,
    bool? watched,
    String? readingLocation,
    double? readingProgress,
    String? $__typename,
  }) => _res;
}

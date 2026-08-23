import 'fragmentImages.graphql.dart';
import 'fragmentMediafiles.graphql.dart';
import 'fragmentMetadata.graphql.dart';
import 'fragmentWatchStatus.graphql.dart';

import 'package:gql/ast.dart';

class Variables$Query$bookForDownload {
  factory Variables$Query$bookForDownload({String? id}) =>
      Variables$Query$bookForDownload._({if (id != null) r'id': id});

  Variables$Query$bookForDownload._(this._$data);

  factory Variables$Query$bookForDownload.fromJson(Map<String, dynamic> data) {
    final result$data = <String, dynamic>{};
    if (data.containsKey('id')) {
      final l$id = data['id'];
      result$data['id'] = (l$id as String?);
    }
    return Variables$Query$bookForDownload._(result$data);
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

  CopyWith$Variables$Query$bookForDownload<Variables$Query$bookForDownload>
  get copyWith => CopyWith$Variables$Query$bookForDownload(this, (i) => i);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Variables$Query$bookForDownload ||
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

abstract class CopyWith$Variables$Query$bookForDownload<TRes> {
  factory CopyWith$Variables$Query$bookForDownload(
    Variables$Query$bookForDownload instance,
    TRes Function(Variables$Query$bookForDownload) then,
  ) = _CopyWithImpl$Variables$Query$bookForDownload;

  factory CopyWith$Variables$Query$bookForDownload.stub(TRes res) =
      _CopyWithStubImpl$Variables$Query$bookForDownload;

  TRes call({String? id});
}

class _CopyWithImpl$Variables$Query$bookForDownload<TRes>
    implements CopyWith$Variables$Query$bookForDownload<TRes> {
  _CopyWithImpl$Variables$Query$bookForDownload(this._instance, this._then);

  final Variables$Query$bookForDownload _instance;

  final TRes Function(Variables$Query$bookForDownload) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({Object? id = _undefined}) => _then(
    Variables$Query$bookForDownload._({
      ..._instance._$data,
      if (id != _undefined) 'id': (id as String?),
    }),
  );
}

class _CopyWithStubImpl$Variables$Query$bookForDownload<TRes>
    implements CopyWith$Variables$Query$bookForDownload<TRes> {
  _CopyWithStubImpl$Variables$Query$bookForDownload(this._res);

  TRes _res;

  call({String? id}) => _res;
}

class Query$bookForDownload {
  Query$bookForDownload({this.bookById, this.$__typename = 'Query'});

  factory Query$bookForDownload.fromJson(Map<String, dynamic> json) {
    final l$bookById = json['bookById'];
    final l$$__typename = json['__typename'];
    return Query$bookForDownload(
      bookById: l$bookById == null
          ? null
          : Query$bookForDownload$bookById.fromJson(
              (l$bookById as Map<String, dynamic>),
            ),
      $__typename: (l$$__typename as String),
    );
  }

  final Query$bookForDownload$bookById? bookById;

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
    if (other is! Query$bookForDownload || runtimeType != other.runtimeType) {
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

extension UtilityExtension$Query$bookForDownload on Query$bookForDownload {
  CopyWith$Query$bookForDownload<Query$bookForDownload> get copyWith =>
      CopyWith$Query$bookForDownload(this, (i) => i);
}

abstract class CopyWith$Query$bookForDownload<TRes> {
  factory CopyWith$Query$bookForDownload(
    Query$bookForDownload instance,
    TRes Function(Query$bookForDownload) then,
  ) = _CopyWithImpl$Query$bookForDownload;

  factory CopyWith$Query$bookForDownload.stub(TRes res) =
      _CopyWithStubImpl$Query$bookForDownload;

  TRes call({Query$bookForDownload$bookById? bookById, String? $__typename});
  CopyWith$Query$bookForDownload$bookById<TRes> get bookById;
}

class _CopyWithImpl$Query$bookForDownload<TRes>
    implements CopyWith$Query$bookForDownload<TRes> {
  _CopyWithImpl$Query$bookForDownload(this._instance, this._then);

  final Query$bookForDownload _instance;

  final TRes Function(Query$bookForDownload) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? bookById = _undefined,
    Object? $__typename = _undefined,
  }) => _then(
    Query$bookForDownload(
      bookById: bookById == _undefined
          ? _instance.bookById
          : (bookById as Query$bookForDownload$bookById?),
      $__typename: $__typename == _undefined || $__typename == null
          ? _instance.$__typename
          : ($__typename as String),
    ),
  );

  CopyWith$Query$bookForDownload$bookById<TRes> get bookById {
    final local$bookById = _instance.bookById;
    return local$bookById == null
        ? CopyWith$Query$bookForDownload$bookById.stub(_then(_instance))
        : CopyWith$Query$bookForDownload$bookById(
            local$bookById,
            (e) => call(bookById: e),
          );
  }
}

class _CopyWithStubImpl$Query$bookForDownload<TRes>
    implements CopyWith$Query$bookForDownload<TRes> {
  _CopyWithStubImpl$Query$bookForDownload(this._res);

  TRes _res;

  call({Query$bookForDownload$bookById? bookById, String? $__typename}) => _res;

  CopyWith$Query$bookForDownload$bookById<TRes> get bookById =>
      CopyWith$Query$bookForDownload$bookById.stub(_res);
}

const documentNodeQuerybookForDownload = DocumentNode(
  definitions: [
    OperationDefinitionNode(
      type: OperationType.query,
      name: NameNode(value: 'bookForDownload'),
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
                  name: NameNode(value: 'chapters'),
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
                        name: NameNode(value: 'number'),
                        alias: null,
                        arguments: [],
                        directives: [],
                        selectionSet: null,
                      ),
                      FieldNode(
                        name: NameNode(value: 'author'),
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
                        name: NameNode(value: 'book'),
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
                        name: NameNode(value: 'mediaFile'),
                        alias: null,
                        arguments: [],
                        directives: [],
                        selectionSet: SelectionSetNode(
                          selections: [
                            FragmentSpreadNode(
                              name: NameNode(value: 'fragmentMediaFiles'),
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
                        name: NameNode(value: 'watchStatus'),
                        alias: null,
                        arguments: [],
                        directives: [],
                        selectionSet: SelectionSetNode(
                          selections: [
                            FragmentSpreadNode(
                              name: NameNode(value: 'fragmentWatchStatus'),
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
    fragmentDefinitionfragmentMetadata,
    fragmentDefinitionfragmentImages,
    fragmentDefinitionfragmentMediaFiles,
    fragmentDefinitionfragmentWatchStatus,
  ],
);

class Query$bookForDownload$bookById {
  Query$bookForDownload$bookById({
    required this.id,
    required this.title,
    this.chapters,
    this.$__typename = 'Book',
  });

  factory Query$bookForDownload$bookById.fromJson(Map<String, dynamic> json) {
    final l$id = json['id'];
    final l$title = json['title'];
    final l$chapters = json['chapters'];
    final l$$__typename = json['__typename'];
    return Query$bookForDownload$bookById(
      id: (l$id as String),
      title: (l$title as String),
      chapters: (l$chapters as List<dynamic>?)
          ?.map(
            (e) => Query$bookForDownload$bookById$chapters.fromJson(
              (e as Map<String, dynamic>),
            ),
          )
          .toList(),
      $__typename: (l$$__typename as String),
    );
  }

  final String id;

  final String title;

  final List<Query$bookForDownload$bookById$chapters>? chapters;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$id = id;
    _resultData['id'] = l$id;
    final l$title = title;
    _resultData['title'] = l$title;
    final l$chapters = chapters;
    _resultData['chapters'] = l$chapters?.map((e) => e.toJson()).toList();
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$id = id;
    final l$title = title;
    final l$chapters = chapters;
    final l$$__typename = $__typename;
    return Object.hashAll([
      l$id,
      l$title,
      l$chapters == null ? null : Object.hashAll(l$chapters.map((v) => v)),
      l$$__typename,
    ]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Query$bookForDownload$bookById ||
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
    final l$$__typename = $__typename;
    final lOther$$__typename = other.$__typename;
    if (l$$__typename != lOther$$__typename) {
      return false;
    }
    return true;
  }
}

extension UtilityExtension$Query$bookForDownload$bookById
    on Query$bookForDownload$bookById {
  CopyWith$Query$bookForDownload$bookById<Query$bookForDownload$bookById>
  get copyWith => CopyWith$Query$bookForDownload$bookById(this, (i) => i);
}

abstract class CopyWith$Query$bookForDownload$bookById<TRes> {
  factory CopyWith$Query$bookForDownload$bookById(
    Query$bookForDownload$bookById instance,
    TRes Function(Query$bookForDownload$bookById) then,
  ) = _CopyWithImpl$Query$bookForDownload$bookById;

  factory CopyWith$Query$bookForDownload$bookById.stub(TRes res) =
      _CopyWithStubImpl$Query$bookForDownload$bookById;

  TRes call({
    String? id,
    String? title,
    List<Query$bookForDownload$bookById$chapters>? chapters,
    String? $__typename,
  });
  TRes chapters(
    Iterable<Query$bookForDownload$bookById$chapters>? Function(
      Iterable<
        CopyWith$Query$bookForDownload$bookById$chapters<
          Query$bookForDownload$bookById$chapters
        >
      >?,
    )
    _fn,
  );
}

class _CopyWithImpl$Query$bookForDownload$bookById<TRes>
    implements CopyWith$Query$bookForDownload$bookById<TRes> {
  _CopyWithImpl$Query$bookForDownload$bookById(this._instance, this._then);

  final Query$bookForDownload$bookById _instance;

  final TRes Function(Query$bookForDownload$bookById) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? id = _undefined,
    Object? title = _undefined,
    Object? chapters = _undefined,
    Object? $__typename = _undefined,
  }) => _then(
    Query$bookForDownload$bookById(
      id: id == _undefined || id == null ? _instance.id : (id as String),
      title: title == _undefined || title == null
          ? _instance.title
          : (title as String),
      chapters: chapters == _undefined
          ? _instance.chapters
          : (chapters as List<Query$bookForDownload$bookById$chapters>?),
      $__typename: $__typename == _undefined || $__typename == null
          ? _instance.$__typename
          : ($__typename as String),
    ),
  );

  TRes chapters(
    Iterable<Query$bookForDownload$bookById$chapters>? Function(
      Iterable<
        CopyWith$Query$bookForDownload$bookById$chapters<
          Query$bookForDownload$bookById$chapters
        >
      >?,
    )
    _fn,
  ) => call(
    chapters: _fn(
      _instance.chapters?.map(
        (e) => CopyWith$Query$bookForDownload$bookById$chapters(e, (i) => i),
      ),
    )?.toList(),
  );
}

class _CopyWithStubImpl$Query$bookForDownload$bookById<TRes>
    implements CopyWith$Query$bookForDownload$bookById<TRes> {
  _CopyWithStubImpl$Query$bookForDownload$bookById(this._res);

  TRes _res;

  call({
    String? id,
    String? title,
    List<Query$bookForDownload$bookById$chapters>? chapters,
    String? $__typename,
  }) => _res;

  chapters(_fn) => _res;
}

class Query$bookForDownload$bookById$chapters {
  Query$bookForDownload$bookById$chapters({
    required this.id,
    required this.number,
    required this.author,
    required this.book,
    this.metadata,
    this.mediaFile,
    this.watchStatus,
    this.$__typename = 'Chapter',
  });

  factory Query$bookForDownload$bookById$chapters.fromJson(
    Map<String, dynamic> json,
  ) {
    final l$id = json['id'];
    final l$number = json['number'];
    final l$author = json['author'];
    final l$book = json['book'];
    final l$metadata = json['metadata'];
    final l$mediaFile = json['mediaFile'];
    final l$watchStatus = json['watchStatus'];
    final l$$__typename = json['__typename'];
    return Query$bookForDownload$bookById$chapters(
      id: (l$id as String),
      number: (l$number as int),
      author: Query$bookForDownload$bookById$chapters$author.fromJson(
        (l$author as Map<String, dynamic>),
      ),
      book: Query$bookForDownload$bookById$chapters$book.fromJson(
        (l$book as Map<String, dynamic>),
      ),
      metadata: (l$metadata as List<dynamic>?)
          ?.map(
            (e) =>
                Fragment$fragmentMetadata.fromJson((e as Map<String, dynamic>)),
          )
          .toList(),
      mediaFile: (l$mediaFile as List<dynamic>?)
          ?.map(
            (e) => Fragment$fragmentMediaFiles.fromJson(
              (e as Map<String, dynamic>),
            ),
          )
          .toList(),
      watchStatus: (l$watchStatus as List<dynamic>?)
          ?.map(
            (e) => Fragment$fragmentWatchStatus.fromJson(
              (e as Map<String, dynamic>),
            ),
          )
          .toList(),
      $__typename: (l$$__typename as String),
    );
  }

  final String id;

  final int number;

  final Query$bookForDownload$bookById$chapters$author author;

  final Query$bookForDownload$bookById$chapters$book book;

  final List<Fragment$fragmentMetadata>? metadata;

  final List<Fragment$fragmentMediaFiles>? mediaFile;

  final List<Fragment$fragmentWatchStatus>? watchStatus;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$id = id;
    _resultData['id'] = l$id;
    final l$number = number;
    _resultData['number'] = l$number;
    final l$author = author;
    _resultData['author'] = l$author.toJson();
    final l$book = book;
    _resultData['book'] = l$book.toJson();
    final l$metadata = metadata;
    _resultData['metadata'] = l$metadata?.map((e) => e.toJson()).toList();
    final l$mediaFile = mediaFile;
    _resultData['mediaFile'] = l$mediaFile?.map((e) => e.toJson()).toList();
    final l$watchStatus = watchStatus;
    _resultData['watchStatus'] = l$watchStatus?.map((e) => e.toJson()).toList();
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$id = id;
    final l$number = number;
    final l$author = author;
    final l$book = book;
    final l$metadata = metadata;
    final l$mediaFile = mediaFile;
    final l$watchStatus = watchStatus;
    final l$$__typename = $__typename;
    return Object.hashAll([
      l$id,
      l$number,
      l$author,
      l$book,
      l$metadata == null ? null : Object.hashAll(l$metadata.map((v) => v)),
      l$mediaFile == null ? null : Object.hashAll(l$mediaFile.map((v) => v)),
      l$watchStatus == null
          ? null
          : Object.hashAll(l$watchStatus.map((v) => v)),
      l$$__typename,
    ]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Query$bookForDownload$bookById$chapters ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$id = id;
    final lOther$id = other.id;
    if (l$id != lOther$id) {
      return false;
    }
    final l$number = number;
    final lOther$number = other.number;
    if (l$number != lOther$number) {
      return false;
    }
    final l$author = author;
    final lOther$author = other.author;
    if (l$author != lOther$author) {
      return false;
    }
    final l$book = book;
    final lOther$book = other.book;
    if (l$book != lOther$book) {
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
    final l$mediaFile = mediaFile;
    final lOther$mediaFile = other.mediaFile;
    if (l$mediaFile != null && lOther$mediaFile != null) {
      if (l$mediaFile.length != lOther$mediaFile.length) {
        return false;
      }
      for (int i = 0; i < l$mediaFile.length; i++) {
        final l$mediaFile$entry = l$mediaFile[i];
        final lOther$mediaFile$entry = lOther$mediaFile[i];
        if (l$mediaFile$entry != lOther$mediaFile$entry) {
          return false;
        }
      }
    } else if (l$mediaFile != lOther$mediaFile) {
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
    final l$$__typename = $__typename;
    final lOther$$__typename = other.$__typename;
    if (l$$__typename != lOther$$__typename) {
      return false;
    }
    return true;
  }
}

extension UtilityExtension$Query$bookForDownload$bookById$chapters
    on Query$bookForDownload$bookById$chapters {
  CopyWith$Query$bookForDownload$bookById$chapters<
    Query$bookForDownload$bookById$chapters
  >
  get copyWith =>
      CopyWith$Query$bookForDownload$bookById$chapters(this, (i) => i);
}

abstract class CopyWith$Query$bookForDownload$bookById$chapters<TRes> {
  factory CopyWith$Query$bookForDownload$bookById$chapters(
    Query$bookForDownload$bookById$chapters instance,
    TRes Function(Query$bookForDownload$bookById$chapters) then,
  ) = _CopyWithImpl$Query$bookForDownload$bookById$chapters;

  factory CopyWith$Query$bookForDownload$bookById$chapters.stub(TRes res) =
      _CopyWithStubImpl$Query$bookForDownload$bookById$chapters;

  TRes call({
    String? id,
    int? number,
    Query$bookForDownload$bookById$chapters$author? author,
    Query$bookForDownload$bookById$chapters$book? book,
    List<Fragment$fragmentMetadata>? metadata,
    List<Fragment$fragmentMediaFiles>? mediaFile,
    List<Fragment$fragmentWatchStatus>? watchStatus,
    String? $__typename,
  });
  CopyWith$Query$bookForDownload$bookById$chapters$author<TRes> get author;
  CopyWith$Query$bookForDownload$bookById$chapters$book<TRes> get book;
  TRes metadata(
    Iterable<Fragment$fragmentMetadata>? Function(
      Iterable<CopyWith$Fragment$fragmentMetadata<Fragment$fragmentMetadata>>?,
    )
    _fn,
  );
  TRes mediaFile(
    Iterable<Fragment$fragmentMediaFiles>? Function(
      Iterable<
        CopyWith$Fragment$fragmentMediaFiles<Fragment$fragmentMediaFiles>
      >?,
    )
    _fn,
  );
  TRes watchStatus(
    Iterable<Fragment$fragmentWatchStatus>? Function(
      Iterable<
        CopyWith$Fragment$fragmentWatchStatus<Fragment$fragmentWatchStatus>
      >?,
    )
    _fn,
  );
}

class _CopyWithImpl$Query$bookForDownload$bookById$chapters<TRes>
    implements CopyWith$Query$bookForDownload$bookById$chapters<TRes> {
  _CopyWithImpl$Query$bookForDownload$bookById$chapters(
    this._instance,
    this._then,
  );

  final Query$bookForDownload$bookById$chapters _instance;

  final TRes Function(Query$bookForDownload$bookById$chapters) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? id = _undefined,
    Object? number = _undefined,
    Object? author = _undefined,
    Object? book = _undefined,
    Object? metadata = _undefined,
    Object? mediaFile = _undefined,
    Object? watchStatus = _undefined,
    Object? $__typename = _undefined,
  }) => _then(
    Query$bookForDownload$bookById$chapters(
      id: id == _undefined || id == null ? _instance.id : (id as String),
      number: number == _undefined || number == null
          ? _instance.number
          : (number as int),
      author: author == _undefined || author == null
          ? _instance.author
          : (author as Query$bookForDownload$bookById$chapters$author),
      book: book == _undefined || book == null
          ? _instance.book
          : (book as Query$bookForDownload$bookById$chapters$book),
      metadata: metadata == _undefined
          ? _instance.metadata
          : (metadata as List<Fragment$fragmentMetadata>?),
      mediaFile: mediaFile == _undefined
          ? _instance.mediaFile
          : (mediaFile as List<Fragment$fragmentMediaFiles>?),
      watchStatus: watchStatus == _undefined
          ? _instance.watchStatus
          : (watchStatus as List<Fragment$fragmentWatchStatus>?),
      $__typename: $__typename == _undefined || $__typename == null
          ? _instance.$__typename
          : ($__typename as String),
    ),
  );

  CopyWith$Query$bookForDownload$bookById$chapters$author<TRes> get author {
    final local$author = _instance.author;
    return CopyWith$Query$bookForDownload$bookById$chapters$author(
      local$author,
      (e) => call(author: e),
    );
  }

  CopyWith$Query$bookForDownload$bookById$chapters$book<TRes> get book {
    final local$book = _instance.book;
    return CopyWith$Query$bookForDownload$bookById$chapters$book(
      local$book,
      (e) => call(book: e),
    );
  }

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

  TRes mediaFile(
    Iterable<Fragment$fragmentMediaFiles>? Function(
      Iterable<
        CopyWith$Fragment$fragmentMediaFiles<Fragment$fragmentMediaFiles>
      >?,
    )
    _fn,
  ) => call(
    mediaFile: _fn(
      _instance.mediaFile?.map(
        (e) => CopyWith$Fragment$fragmentMediaFiles(e, (i) => i),
      ),
    )?.toList(),
  );

  TRes watchStatus(
    Iterable<Fragment$fragmentWatchStatus>? Function(
      Iterable<
        CopyWith$Fragment$fragmentWatchStatus<Fragment$fragmentWatchStatus>
      >?,
    )
    _fn,
  ) => call(
    watchStatus: _fn(
      _instance.watchStatus?.map(
        (e) => CopyWith$Fragment$fragmentWatchStatus(e, (i) => i),
      ),
    )?.toList(),
  );
}

class _CopyWithStubImpl$Query$bookForDownload$bookById$chapters<TRes>
    implements CopyWith$Query$bookForDownload$bookById$chapters<TRes> {
  _CopyWithStubImpl$Query$bookForDownload$bookById$chapters(this._res);

  TRes _res;

  call({
    String? id,
    int? number,
    Query$bookForDownload$bookById$chapters$author? author,
    Query$bookForDownload$bookById$chapters$book? book,
    List<Fragment$fragmentMetadata>? metadata,
    List<Fragment$fragmentMediaFiles>? mediaFile,
    List<Fragment$fragmentWatchStatus>? watchStatus,
    String? $__typename,
  }) => _res;

  CopyWith$Query$bookForDownload$bookById$chapters$author<TRes> get author =>
      CopyWith$Query$bookForDownload$bookById$chapters$author.stub(_res);

  CopyWith$Query$bookForDownload$bookById$chapters$book<TRes> get book =>
      CopyWith$Query$bookForDownload$bookById$chapters$book.stub(_res);

  metadata(_fn) => _res;

  mediaFile(_fn) => _res;

  watchStatus(_fn) => _res;
}

class Query$bookForDownload$bookById$chapters$author {
  Query$bookForDownload$bookById$chapters$author({
    required this.id,
    required this.name,
    this.$__typename = 'Person',
  });

  factory Query$bookForDownload$bookById$chapters$author.fromJson(
    Map<String, dynamic> json,
  ) {
    final l$id = json['id'];
    final l$name = json['name'];
    final l$$__typename = json['__typename'];
    return Query$bookForDownload$bookById$chapters$author(
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
    if (other is! Query$bookForDownload$bookById$chapters$author ||
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

extension UtilityExtension$Query$bookForDownload$bookById$chapters$author
    on Query$bookForDownload$bookById$chapters$author {
  CopyWith$Query$bookForDownload$bookById$chapters$author<
    Query$bookForDownload$bookById$chapters$author
  >
  get copyWith =>
      CopyWith$Query$bookForDownload$bookById$chapters$author(this, (i) => i);
}

abstract class CopyWith$Query$bookForDownload$bookById$chapters$author<TRes> {
  factory CopyWith$Query$bookForDownload$bookById$chapters$author(
    Query$bookForDownload$bookById$chapters$author instance,
    TRes Function(Query$bookForDownload$bookById$chapters$author) then,
  ) = _CopyWithImpl$Query$bookForDownload$bookById$chapters$author;

  factory CopyWith$Query$bookForDownload$bookById$chapters$author.stub(
    TRes res,
  ) = _CopyWithStubImpl$Query$bookForDownload$bookById$chapters$author;

  TRes call({String? id, String? name, String? $__typename});
}

class _CopyWithImpl$Query$bookForDownload$bookById$chapters$author<TRes>
    implements CopyWith$Query$bookForDownload$bookById$chapters$author<TRes> {
  _CopyWithImpl$Query$bookForDownload$bookById$chapters$author(
    this._instance,
    this._then,
  );

  final Query$bookForDownload$bookById$chapters$author _instance;

  final TRes Function(Query$bookForDownload$bookById$chapters$author) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? id = _undefined,
    Object? name = _undefined,
    Object? $__typename = _undefined,
  }) => _then(
    Query$bookForDownload$bookById$chapters$author(
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

class _CopyWithStubImpl$Query$bookForDownload$bookById$chapters$author<TRes>
    implements CopyWith$Query$bookForDownload$bookById$chapters$author<TRes> {
  _CopyWithStubImpl$Query$bookForDownload$bookById$chapters$author(this._res);

  TRes _res;

  call({String? id, String? name, String? $__typename}) => _res;
}

class Query$bookForDownload$bookById$chapters$book {
  Query$bookForDownload$bookById$chapters$book({
    required this.id,
    required this.title,
    this.metadata,
    this.images,
    this.$__typename = 'Book',
  });

  factory Query$bookForDownload$bookById$chapters$book.fromJson(
    Map<String, dynamic> json,
  ) {
    final l$id = json['id'];
    final l$title = json['title'];
    final l$metadata = json['metadata'];
    final l$images = json['images'];
    final l$$__typename = json['__typename'];
    return Query$bookForDownload$bookById$chapters$book(
      id: (l$id as String),
      title: (l$title as String),
      metadata: (l$metadata as List<dynamic>?)
          ?.map(
            (e) =>
                Fragment$fragmentMetadata.fromJson((e as Map<String, dynamic>)),
          )
          .toList(),
      images: (l$images as List<dynamic>?)
          ?.map(
            (e) =>
                Fragment$fragmentImages.fromJson((e as Map<String, dynamic>)),
          )
          .toList(),
      $__typename: (l$$__typename as String),
    );
  }

  final String id;

  final String title;

  final List<Fragment$fragmentMetadata>? metadata;

  final List<Fragment$fragmentImages>? images;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$id = id;
    _resultData['id'] = l$id;
    final l$title = title;
    _resultData['title'] = l$title;
    final l$metadata = metadata;
    _resultData['metadata'] = l$metadata?.map((e) => e.toJson()).toList();
    final l$images = images;
    _resultData['images'] = l$images?.map((e) => e.toJson()).toList();
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$id = id;
    final l$title = title;
    final l$metadata = metadata;
    final l$images = images;
    final l$$__typename = $__typename;
    return Object.hashAll([
      l$id,
      l$title,
      l$metadata == null ? null : Object.hashAll(l$metadata.map((v) => v)),
      l$images == null ? null : Object.hashAll(l$images.map((v) => v)),
      l$$__typename,
    ]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Query$bookForDownload$bookById$chapters$book ||
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
    final l$$__typename = $__typename;
    final lOther$$__typename = other.$__typename;
    if (l$$__typename != lOther$$__typename) {
      return false;
    }
    return true;
  }
}

extension UtilityExtension$Query$bookForDownload$bookById$chapters$book
    on Query$bookForDownload$bookById$chapters$book {
  CopyWith$Query$bookForDownload$bookById$chapters$book<
    Query$bookForDownload$bookById$chapters$book
  >
  get copyWith =>
      CopyWith$Query$bookForDownload$bookById$chapters$book(this, (i) => i);
}

abstract class CopyWith$Query$bookForDownload$bookById$chapters$book<TRes> {
  factory CopyWith$Query$bookForDownload$bookById$chapters$book(
    Query$bookForDownload$bookById$chapters$book instance,
    TRes Function(Query$bookForDownload$bookById$chapters$book) then,
  ) = _CopyWithImpl$Query$bookForDownload$bookById$chapters$book;

  factory CopyWith$Query$bookForDownload$bookById$chapters$book.stub(TRes res) =
      _CopyWithStubImpl$Query$bookForDownload$bookById$chapters$book;

  TRes call({
    String? id,
    String? title,
    List<Fragment$fragmentMetadata>? metadata,
    List<Fragment$fragmentImages>? images,
    String? $__typename,
  });
  TRes metadata(
    Iterable<Fragment$fragmentMetadata>? Function(
      Iterable<CopyWith$Fragment$fragmentMetadata<Fragment$fragmentMetadata>>?,
    )
    _fn,
  );
  TRes images(
    Iterable<Fragment$fragmentImages>? Function(
      Iterable<CopyWith$Fragment$fragmentImages<Fragment$fragmentImages>>?,
    )
    _fn,
  );
}

class _CopyWithImpl$Query$bookForDownload$bookById$chapters$book<TRes>
    implements CopyWith$Query$bookForDownload$bookById$chapters$book<TRes> {
  _CopyWithImpl$Query$bookForDownload$bookById$chapters$book(
    this._instance,
    this._then,
  );

  final Query$bookForDownload$bookById$chapters$book _instance;

  final TRes Function(Query$bookForDownload$bookById$chapters$book) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? id = _undefined,
    Object? title = _undefined,
    Object? metadata = _undefined,
    Object? images = _undefined,
    Object? $__typename = _undefined,
  }) => _then(
    Query$bookForDownload$bookById$chapters$book(
      id: id == _undefined || id == null ? _instance.id : (id as String),
      title: title == _undefined || title == null
          ? _instance.title
          : (title as String),
      metadata: metadata == _undefined
          ? _instance.metadata
          : (metadata as List<Fragment$fragmentMetadata>?),
      images: images == _undefined
          ? _instance.images
          : (images as List<Fragment$fragmentImages>?),
      $__typename: $__typename == _undefined || $__typename == null
          ? _instance.$__typename
          : ($__typename as String),
    ),
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
}

class _CopyWithStubImpl$Query$bookForDownload$bookById$chapters$book<TRes>
    implements CopyWith$Query$bookForDownload$bookById$chapters$book<TRes> {
  _CopyWithStubImpl$Query$bookForDownload$bookById$chapters$book(this._res);

  TRes _res;

  call({
    String? id,
    String? title,
    List<Fragment$fragmentMetadata>? metadata,
    List<Fragment$fragmentImages>? images,
    String? $__typename,
  }) => _res;

  metadata(_fn) => _res;

  images(_fn) => _res;
}

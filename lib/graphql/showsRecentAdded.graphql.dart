import 'fragmentImages.graphql.dart';
import 'fragmentMetadata.graphql.dart';
import 'package:gql/ast.dart';

class Variables$Query$showsRecentAdded {
  factory Variables$Query$showsRecentAdded({int? page, int? size}) =>
      Variables$Query$showsRecentAdded._({
        if (page != null) r'page': page,
        if (size != null) r'size': size,
      });

  Variables$Query$showsRecentAdded._(this._$data);

  factory Variables$Query$showsRecentAdded.fromJson(Map<String, dynamic> data) {
    final result$data = <String, dynamic>{};
    if (data.containsKey('page')) {
      final l$page = data['page'];
      result$data['page'] = (l$page as int?);
    }
    if (data.containsKey('size')) {
      final l$size = data['size'];
      result$data['size'] = (l$size as int?);
    }
    return Variables$Query$showsRecentAdded._(result$data);
  }

  Map<String, dynamic> _$data;

  int? get page => (_$data['page'] as int?);

  int? get size => (_$data['size'] as int?);

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
    return result$data;
  }

  CopyWith$Variables$Query$showsRecentAdded<Variables$Query$showsRecentAdded>
  get copyWith => CopyWith$Variables$Query$showsRecentAdded(this, (i) => i);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Variables$Query$showsRecentAdded ||
        runtimeType != other.runtimeType) {
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
    final l$page = page;
    final l$size = size;
    return Object.hashAll([
      _$data.containsKey('page') ? l$page : const {},
      _$data.containsKey('size') ? l$size : const {},
    ]);
  }
}

abstract class CopyWith$Variables$Query$showsRecentAdded<TRes> {
  factory CopyWith$Variables$Query$showsRecentAdded(
    Variables$Query$showsRecentAdded instance,
    TRes Function(Variables$Query$showsRecentAdded) then,
  ) = _CopyWithImpl$Variables$Query$showsRecentAdded;

  factory CopyWith$Variables$Query$showsRecentAdded.stub(TRes res) =
      _CopyWithStubImpl$Variables$Query$showsRecentAdded;

  TRes call({int? page, int? size});
}

class _CopyWithImpl$Variables$Query$showsRecentAdded<TRes>
    implements CopyWith$Variables$Query$showsRecentAdded<TRes> {
  _CopyWithImpl$Variables$Query$showsRecentAdded(this._instance, this._then);

  final Variables$Query$showsRecentAdded _instance;

  final TRes Function(Variables$Query$showsRecentAdded) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({Object? page = _undefined, Object? size = _undefined}) => _then(
    Variables$Query$showsRecentAdded._({
      ..._instance._$data,
      if (page != _undefined) 'page': (page as int?),
      if (size != _undefined) 'size': (size as int?),
    }),
  );
}

class _CopyWithStubImpl$Variables$Query$showsRecentAdded<TRes>
    implements CopyWith$Variables$Query$showsRecentAdded<TRes> {
  _CopyWithStubImpl$Variables$Query$showsRecentAdded(this._res);

  TRes _res;

  call({int? page, int? size}) => _res;
}

class Query$showsRecentAdded {
  Query$showsRecentAdded({this.showsRecentAdded, this.$__typename = 'Query'});

  factory Query$showsRecentAdded.fromJson(Map<String, dynamic> json) {
    final l$showsRecentAdded = json['showsRecentAdded'];
    final l$$__typename = json['__typename'];
    return Query$showsRecentAdded(
      showsRecentAdded: l$showsRecentAdded == null
          ? null
          : Query$showsRecentAdded$showsRecentAdded.fromJson(
              (l$showsRecentAdded as Map<String, dynamic>),
            ),
      $__typename: (l$$__typename as String),
    );
  }

  final Query$showsRecentAdded$showsRecentAdded? showsRecentAdded;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$showsRecentAdded = showsRecentAdded;
    _resultData['showsRecentAdded'] = l$showsRecentAdded?.toJson();
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$showsRecentAdded = showsRecentAdded;
    final l$$__typename = $__typename;
    return Object.hashAll([l$showsRecentAdded, l$$__typename]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Query$showsRecentAdded || runtimeType != other.runtimeType) {
      return false;
    }
    final l$showsRecentAdded = showsRecentAdded;
    final lOther$showsRecentAdded = other.showsRecentAdded;
    if (l$showsRecentAdded != lOther$showsRecentAdded) {
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

extension UtilityExtension$Query$showsRecentAdded on Query$showsRecentAdded {
  CopyWith$Query$showsRecentAdded<Query$showsRecentAdded> get copyWith =>
      CopyWith$Query$showsRecentAdded(this, (i) => i);
}

abstract class CopyWith$Query$showsRecentAdded<TRes> {
  factory CopyWith$Query$showsRecentAdded(
    Query$showsRecentAdded instance,
    TRes Function(Query$showsRecentAdded) then,
  ) = _CopyWithImpl$Query$showsRecentAdded;

  factory CopyWith$Query$showsRecentAdded.stub(TRes res) =
      _CopyWithStubImpl$Query$showsRecentAdded;

  TRes call({
    Query$showsRecentAdded$showsRecentAdded? showsRecentAdded,
    String? $__typename,
  });
  CopyWith$Query$showsRecentAdded$showsRecentAdded<TRes> get showsRecentAdded;
}

class _CopyWithImpl$Query$showsRecentAdded<TRes>
    implements CopyWith$Query$showsRecentAdded<TRes> {
  _CopyWithImpl$Query$showsRecentAdded(this._instance, this._then);

  final Query$showsRecentAdded _instance;

  final TRes Function(Query$showsRecentAdded) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? showsRecentAdded = _undefined,
    Object? $__typename = _undefined,
  }) => _then(
    Query$showsRecentAdded(
      showsRecentAdded: showsRecentAdded == _undefined
          ? _instance.showsRecentAdded
          : (showsRecentAdded as Query$showsRecentAdded$showsRecentAdded?),
      $__typename: $__typename == _undefined || $__typename == null
          ? _instance.$__typename
          : ($__typename as String),
    ),
  );

  CopyWith$Query$showsRecentAdded$showsRecentAdded<TRes> get showsRecentAdded {
    final local$showsRecentAdded = _instance.showsRecentAdded;
    return local$showsRecentAdded == null
        ? CopyWith$Query$showsRecentAdded$showsRecentAdded.stub(
            _then(_instance),
          )
        : CopyWith$Query$showsRecentAdded$showsRecentAdded(
            local$showsRecentAdded,
            (e) => call(showsRecentAdded: e),
          );
  }
}

class _CopyWithStubImpl$Query$showsRecentAdded<TRes>
    implements CopyWith$Query$showsRecentAdded<TRes> {
  _CopyWithStubImpl$Query$showsRecentAdded(this._res);

  TRes _res;

  call({
    Query$showsRecentAdded$showsRecentAdded? showsRecentAdded,
    String? $__typename,
  }) => _res;

  CopyWith$Query$showsRecentAdded$showsRecentAdded<TRes> get showsRecentAdded =>
      CopyWith$Query$showsRecentAdded$showsRecentAdded.stub(_res);
}

const documentNodeQueryshowsRecentAdded = DocumentNode(
  definitions: [
    OperationDefinitionNode(
      type: OperationType.query,
      name: NameNode(value: 'showsRecentAdded'),
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
      ],
      directives: [],
      selectionSet: SelectionSetNode(
        selections: [
          FieldNode(
            name: NameNode(value: 'showsRecentAdded'),
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
                        name: NameNode(value: 'releaseYear'),
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
                        name: NameNode(value: 'episodes'),
                        alias: null,
                        arguments: [],
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

class Query$showsRecentAdded$showsRecentAdded {
  Query$showsRecentAdded$showsRecentAdded({
    required this.number,
    required this.size,
    required this.totalElements,
    required this.totalPages,
    required this.content,
    this.$__typename = 'ShowPage',
  });

  factory Query$showsRecentAdded$showsRecentAdded.fromJson(
    Map<String, dynamic> json,
  ) {
    final l$number = json['number'];
    final l$size = json['size'];
    final l$totalElements = json['totalElements'];
    final l$totalPages = json['totalPages'];
    final l$content = json['content'];
    final l$$__typename = json['__typename'];
    return Query$showsRecentAdded$showsRecentAdded(
      number: (l$number as int),
      size: (l$size as int),
      totalElements: (l$totalElements as int),
      totalPages: (l$totalPages as int),
      content: (l$content as List<dynamic>)
          .map(
            (e) => Query$showsRecentAdded$showsRecentAdded$content.fromJson(
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

  final List<Query$showsRecentAdded$showsRecentAdded$content> content;

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
    if (other is! Query$showsRecentAdded$showsRecentAdded ||
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

extension UtilityExtension$Query$showsRecentAdded$showsRecentAdded
    on Query$showsRecentAdded$showsRecentAdded {
  CopyWith$Query$showsRecentAdded$showsRecentAdded<
    Query$showsRecentAdded$showsRecentAdded
  >
  get copyWith =>
      CopyWith$Query$showsRecentAdded$showsRecentAdded(this, (i) => i);
}

abstract class CopyWith$Query$showsRecentAdded$showsRecentAdded<TRes> {
  factory CopyWith$Query$showsRecentAdded$showsRecentAdded(
    Query$showsRecentAdded$showsRecentAdded instance,
    TRes Function(Query$showsRecentAdded$showsRecentAdded) then,
  ) = _CopyWithImpl$Query$showsRecentAdded$showsRecentAdded;

  factory CopyWith$Query$showsRecentAdded$showsRecentAdded.stub(TRes res) =
      _CopyWithStubImpl$Query$showsRecentAdded$showsRecentAdded;

  TRes call({
    int? number,
    int? size,
    int? totalElements,
    int? totalPages,
    List<Query$showsRecentAdded$showsRecentAdded$content>? content,
    String? $__typename,
  });
  TRes content(
    Iterable<Query$showsRecentAdded$showsRecentAdded$content> Function(
      Iterable<
        CopyWith$Query$showsRecentAdded$showsRecentAdded$content<
          Query$showsRecentAdded$showsRecentAdded$content
        >
      >,
    )
    _fn,
  );
}

class _CopyWithImpl$Query$showsRecentAdded$showsRecentAdded<TRes>
    implements CopyWith$Query$showsRecentAdded$showsRecentAdded<TRes> {
  _CopyWithImpl$Query$showsRecentAdded$showsRecentAdded(
    this._instance,
    this._then,
  );

  final Query$showsRecentAdded$showsRecentAdded _instance;

  final TRes Function(Query$showsRecentAdded$showsRecentAdded) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? number = _undefined,
    Object? size = _undefined,
    Object? totalElements = _undefined,
    Object? totalPages = _undefined,
    Object? content = _undefined,
    Object? $__typename = _undefined,
  }) => _then(
    Query$showsRecentAdded$showsRecentAdded(
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
          : (content as List<Query$showsRecentAdded$showsRecentAdded$content>),
      $__typename: $__typename == _undefined || $__typename == null
          ? _instance.$__typename
          : ($__typename as String),
    ),
  );

  TRes content(
    Iterable<Query$showsRecentAdded$showsRecentAdded$content> Function(
      Iterable<
        CopyWith$Query$showsRecentAdded$showsRecentAdded$content<
          Query$showsRecentAdded$showsRecentAdded$content
        >
      >,
    )
    _fn,
  ) => call(
    content: _fn(
      _instance.content.map(
        (e) => CopyWith$Query$showsRecentAdded$showsRecentAdded$content(
          e,
          (i) => i,
        ),
      ),
    ).toList(),
  );
}

class _CopyWithStubImpl$Query$showsRecentAdded$showsRecentAdded<TRes>
    implements CopyWith$Query$showsRecentAdded$showsRecentAdded<TRes> {
  _CopyWithStubImpl$Query$showsRecentAdded$showsRecentAdded(this._res);

  TRes _res;

  call({
    int? number,
    int? size,
    int? totalElements,
    int? totalPages,
    List<Query$showsRecentAdded$showsRecentAdded$content>? content,
    String? $__typename,
  }) => _res;

  content(_fn) => _res;
}

class Query$showsRecentAdded$showsRecentAdded$content {
  Query$showsRecentAdded$showsRecentAdded$content({
    required this.id,
    required this.releaseYear,
    required this.name,
    this.images,
    this.episodes,
    this.metadata,
    this.$__typename = 'Show',
  });

  factory Query$showsRecentAdded$showsRecentAdded$content.fromJson(
    Map<String, dynamic> json,
  ) {
    final l$id = json['id'];
    final l$releaseYear = json['releaseYear'];
    final l$name = json['name'];
    final l$images = json['images'];
    final l$episodes = json['episodes'];
    final l$metadata = json['metadata'];
    final l$$__typename = json['__typename'];
    return Query$showsRecentAdded$showsRecentAdded$content(
      id: (l$id as String),
      releaseYear: (l$releaseYear as int),
      name: (l$name as String),
      images: (l$images as List<dynamic>?)
          ?.map(
            (e) =>
                Fragment$fragmentImages.fromJson((e as Map<String, dynamic>)),
          )
          .toList(),
      episodes: (l$episodes as List<dynamic>?)
          ?.map(
            (e) =>
                Query$showsRecentAdded$showsRecentAdded$content$episodes.fromJson(
                  (e as Map<String, dynamic>),
                ),
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

  final int releaseYear;

  final String name;

  final List<Fragment$fragmentImages>? images;

  final List<Query$showsRecentAdded$showsRecentAdded$content$episodes>?
  episodes;

  final List<Fragment$fragmentMetadata>? metadata;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$id = id;
    _resultData['id'] = l$id;
    final l$releaseYear = releaseYear;
    _resultData['releaseYear'] = l$releaseYear;
    final l$name = name;
    _resultData['name'] = l$name;
    final l$images = images;
    _resultData['images'] = l$images?.map((e) => e.toJson()).toList();
    final l$episodes = episodes;
    _resultData['episodes'] = l$episodes?.map((e) => e.toJson()).toList();
    final l$metadata = metadata;
    _resultData['metadata'] = l$metadata?.map((e) => e.toJson()).toList();
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$id = id;
    final l$releaseYear = releaseYear;
    final l$name = name;
    final l$images = images;
    final l$episodes = episodes;
    final l$metadata = metadata;
    final l$$__typename = $__typename;
    return Object.hashAll([
      l$id,
      l$releaseYear,
      l$name,
      l$images == null ? null : Object.hashAll(l$images.map((v) => v)),
      l$episodes == null ? null : Object.hashAll(l$episodes.map((v) => v)),
      l$metadata == null ? null : Object.hashAll(l$metadata.map((v) => v)),
      l$$__typename,
    ]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Query$showsRecentAdded$showsRecentAdded$content ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$id = id;
    final lOther$id = other.id;
    if (l$id != lOther$id) {
      return false;
    }
    final l$releaseYear = releaseYear;
    final lOther$releaseYear = other.releaseYear;
    if (l$releaseYear != lOther$releaseYear) {
      return false;
    }
    final l$name = name;
    final lOther$name = other.name;
    if (l$name != lOther$name) {
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
    final l$episodes = episodes;
    final lOther$episodes = other.episodes;
    if (l$episodes != null && lOther$episodes != null) {
      if (l$episodes.length != lOther$episodes.length) {
        return false;
      }
      for (int i = 0; i < l$episodes.length; i++) {
        final l$episodes$entry = l$episodes[i];
        final lOther$episodes$entry = lOther$episodes[i];
        if (l$episodes$entry != lOther$episodes$entry) {
          return false;
        }
      }
    } else if (l$episodes != lOther$episodes) {
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

extension UtilityExtension$Query$showsRecentAdded$showsRecentAdded$content
    on Query$showsRecentAdded$showsRecentAdded$content {
  CopyWith$Query$showsRecentAdded$showsRecentAdded$content<
    Query$showsRecentAdded$showsRecentAdded$content
  >
  get copyWith =>
      CopyWith$Query$showsRecentAdded$showsRecentAdded$content(this, (i) => i);
}

abstract class CopyWith$Query$showsRecentAdded$showsRecentAdded$content<TRes> {
  factory CopyWith$Query$showsRecentAdded$showsRecentAdded$content(
    Query$showsRecentAdded$showsRecentAdded$content instance,
    TRes Function(Query$showsRecentAdded$showsRecentAdded$content) then,
  ) = _CopyWithImpl$Query$showsRecentAdded$showsRecentAdded$content;

  factory CopyWith$Query$showsRecentAdded$showsRecentAdded$content.stub(
    TRes res,
  ) = _CopyWithStubImpl$Query$showsRecentAdded$showsRecentAdded$content;

  TRes call({
    String? id,
    int? releaseYear,
    String? name,
    List<Fragment$fragmentImages>? images,
    List<Query$showsRecentAdded$showsRecentAdded$content$episodes>? episodes,
    List<Fragment$fragmentMetadata>? metadata,
    String? $__typename,
  });
  TRes images(
    Iterable<Fragment$fragmentImages>? Function(
      Iterable<CopyWith$Fragment$fragmentImages<Fragment$fragmentImages>>?,
    )
    _fn,
  );
  TRes episodes(
    Iterable<Query$showsRecentAdded$showsRecentAdded$content$episodes>?
    Function(
      Iterable<
        CopyWith$Query$showsRecentAdded$showsRecentAdded$content$episodes<
          Query$showsRecentAdded$showsRecentAdded$content$episodes
        >
      >?,
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

class _CopyWithImpl$Query$showsRecentAdded$showsRecentAdded$content<TRes>
    implements CopyWith$Query$showsRecentAdded$showsRecentAdded$content<TRes> {
  _CopyWithImpl$Query$showsRecentAdded$showsRecentAdded$content(
    this._instance,
    this._then,
  );

  final Query$showsRecentAdded$showsRecentAdded$content _instance;

  final TRes Function(Query$showsRecentAdded$showsRecentAdded$content) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? id = _undefined,
    Object? releaseYear = _undefined,
    Object? name = _undefined,
    Object? images = _undefined,
    Object? episodes = _undefined,
    Object? metadata = _undefined,
    Object? $__typename = _undefined,
  }) => _then(
    Query$showsRecentAdded$showsRecentAdded$content(
      id: id == _undefined || id == null ? _instance.id : (id as String),
      releaseYear: releaseYear == _undefined || releaseYear == null
          ? _instance.releaseYear
          : (releaseYear as int),
      name: name == _undefined || name == null
          ? _instance.name
          : (name as String),
      images: images == _undefined
          ? _instance.images
          : (images as List<Fragment$fragmentImages>?),
      episodes: episodes == _undefined
          ? _instance.episodes
          : (episodes
                as List<
                  Query$showsRecentAdded$showsRecentAdded$content$episodes
                >?),
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

  TRes episodes(
    Iterable<Query$showsRecentAdded$showsRecentAdded$content$episodes>?
    Function(
      Iterable<
        CopyWith$Query$showsRecentAdded$showsRecentAdded$content$episodes<
          Query$showsRecentAdded$showsRecentAdded$content$episodes
        >
      >?,
    )
    _fn,
  ) => call(
    episodes: _fn(
      _instance.episodes?.map(
        (e) =>
            CopyWith$Query$showsRecentAdded$showsRecentAdded$content$episodes(
              e,
              (i) => i,
            ),
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

class _CopyWithStubImpl$Query$showsRecentAdded$showsRecentAdded$content<TRes>
    implements CopyWith$Query$showsRecentAdded$showsRecentAdded$content<TRes> {
  _CopyWithStubImpl$Query$showsRecentAdded$showsRecentAdded$content(this._res);

  TRes _res;

  call({
    String? id,
    int? releaseYear,
    String? name,
    List<Fragment$fragmentImages>? images,
    List<Query$showsRecentAdded$showsRecentAdded$content$episodes>? episodes,
    List<Fragment$fragmentMetadata>? metadata,
    String? $__typename,
  }) => _res;

  images(_fn) => _res;

  episodes(_fn) => _res;

  metadata(_fn) => _res;
}

class Query$showsRecentAdded$showsRecentAdded$content$episodes {
  Query$showsRecentAdded$showsRecentAdded$content$episodes({
    this.number,
    this.$__typename = 'Episode',
  });

  factory Query$showsRecentAdded$showsRecentAdded$content$episodes.fromJson(
    Map<String, dynamic> json,
  ) {
    final l$number = json['number'];
    final l$$__typename = json['__typename'];
    return Query$showsRecentAdded$showsRecentAdded$content$episodes(
      number: (l$number as int?),
      $__typename: (l$$__typename as String),
    );
  }

  final int? number;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$number = number;
    _resultData['number'] = l$number;
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$number = number;
    final l$$__typename = $__typename;
    return Object.hashAll([l$number, l$$__typename]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Query$showsRecentAdded$showsRecentAdded$content$episodes ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$number = number;
    final lOther$number = other.number;
    if (l$number != lOther$number) {
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

extension UtilityExtension$Query$showsRecentAdded$showsRecentAdded$content$episodes
    on Query$showsRecentAdded$showsRecentAdded$content$episodes {
  CopyWith$Query$showsRecentAdded$showsRecentAdded$content$episodes<
    Query$showsRecentAdded$showsRecentAdded$content$episodes
  >
  get copyWith =>
      CopyWith$Query$showsRecentAdded$showsRecentAdded$content$episodes(
        this,
        (i) => i,
      );
}

abstract class CopyWith$Query$showsRecentAdded$showsRecentAdded$content$episodes<
  TRes
> {
  factory CopyWith$Query$showsRecentAdded$showsRecentAdded$content$episodes(
    Query$showsRecentAdded$showsRecentAdded$content$episodes instance,
    TRes Function(Query$showsRecentAdded$showsRecentAdded$content$episodes)
    then,
  ) = _CopyWithImpl$Query$showsRecentAdded$showsRecentAdded$content$episodes;

  factory CopyWith$Query$showsRecentAdded$showsRecentAdded$content$episodes.stub(
    TRes res,
  ) = _CopyWithStubImpl$Query$showsRecentAdded$showsRecentAdded$content$episodes;

  TRes call({int? number, String? $__typename});
}

class _CopyWithImpl$Query$showsRecentAdded$showsRecentAdded$content$episodes<
  TRes
>
    implements
        CopyWith$Query$showsRecentAdded$showsRecentAdded$content$episodes<
          TRes
        > {
  _CopyWithImpl$Query$showsRecentAdded$showsRecentAdded$content$episodes(
    this._instance,
    this._then,
  );

  final Query$showsRecentAdded$showsRecentAdded$content$episodes _instance;

  final TRes Function(Query$showsRecentAdded$showsRecentAdded$content$episodes)
  _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({Object? number = _undefined, Object? $__typename = _undefined}) =>
      _then(
        Query$showsRecentAdded$showsRecentAdded$content$episodes(
          number: number == _undefined ? _instance.number : (number as int?),
          $__typename: $__typename == _undefined || $__typename == null
              ? _instance.$__typename
              : ($__typename as String),
        ),
      );
}

class _CopyWithStubImpl$Query$showsRecentAdded$showsRecentAdded$content$episodes<
  TRes
>
    implements
        CopyWith$Query$showsRecentAdded$showsRecentAdded$content$episodes<
          TRes
        > {
  _CopyWithStubImpl$Query$showsRecentAdded$showsRecentAdded$content$episodes(
    this._res,
  );

  TRes _res;

  call({int? number, String? $__typename}) => _res;
}

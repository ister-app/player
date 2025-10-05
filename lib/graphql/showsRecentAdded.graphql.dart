import 'fragmentImages.graphql.dart';
import 'fragmentMetadata.graphql.dart';
import 'package:gql/ast.dart';
import 'schema.graphql.dart';

class Variables$Query$shows {
  factory Variables$Query$shows({
    int? page,
    int? size,
    Enum$SortingEnum? sorting,
    Enum$SortingOrder? sortingOrder,
  }) => Variables$Query$shows._({
    if (page != null) r'page': page,
    if (size != null) r'size': size,
    if (sorting != null) r'sorting': sorting,
    if (sortingOrder != null) r'sortingOrder': sortingOrder,
  });

  Variables$Query$shows._(this._$data);

  factory Variables$Query$shows.fromJson(Map<String, dynamic> data) {
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
    return Variables$Query$shows._(result$data);
  }

  Map<String, dynamic> _$data;

  int? get page => (_$data['page'] as int?);

  int? get size => (_$data['size'] as int?);

  Enum$SortingEnum? get sorting => (_$data['sorting'] as Enum$SortingEnum?);

  Enum$SortingOrder? get sortingOrder =>
      (_$data['sortingOrder'] as Enum$SortingOrder?);

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
    return result$data;
  }

  CopyWith$Variables$Query$shows<Variables$Query$shows> get copyWith =>
      CopyWith$Variables$Query$shows(this, (i) => i);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Variables$Query$shows || runtimeType != other.runtimeType) {
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
    return true;
  }

  @override
  int get hashCode {
    final l$page = page;
    final l$size = size;
    final l$sorting = sorting;
    final l$sortingOrder = sortingOrder;
    return Object.hashAll([
      _$data.containsKey('page') ? l$page : const {},
      _$data.containsKey('size') ? l$size : const {},
      _$data.containsKey('sorting') ? l$sorting : const {},
      _$data.containsKey('sortingOrder') ? l$sortingOrder : const {},
    ]);
  }
}

abstract class CopyWith$Variables$Query$shows<TRes> {
  factory CopyWith$Variables$Query$shows(
    Variables$Query$shows instance,
    TRes Function(Variables$Query$shows) then,
  ) = _CopyWithImpl$Variables$Query$shows;

  factory CopyWith$Variables$Query$shows.stub(TRes res) =
      _CopyWithStubImpl$Variables$Query$shows;

  TRes call({
    int? page,
    int? size,
    Enum$SortingEnum? sorting,
    Enum$SortingOrder? sortingOrder,
  });
}

class _CopyWithImpl$Variables$Query$shows<TRes>
    implements CopyWith$Variables$Query$shows<TRes> {
  _CopyWithImpl$Variables$Query$shows(this._instance, this._then);

  final Variables$Query$shows _instance;

  final TRes Function(Variables$Query$shows) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? page = _undefined,
    Object? size = _undefined,
    Object? sorting = _undefined,
    Object? sortingOrder = _undefined,
  }) => _then(
    Variables$Query$shows._({
      ..._instance._$data,
      if (page != _undefined) 'page': (page as int?),
      if (size != _undefined) 'size': (size as int?),
      if (sorting != _undefined) 'sorting': (sorting as Enum$SortingEnum?),
      if (sortingOrder != _undefined)
        'sortingOrder': (sortingOrder as Enum$SortingOrder?),
    }),
  );
}

class _CopyWithStubImpl$Variables$Query$shows<TRes>
    implements CopyWith$Variables$Query$shows<TRes> {
  _CopyWithStubImpl$Variables$Query$shows(this._res);

  TRes _res;

  call({
    int? page,
    int? size,
    Enum$SortingEnum? sorting,
    Enum$SortingOrder? sortingOrder,
  }) => _res;
}

class Query$shows {
  Query$shows({this.shows, this.$__typename = 'Query'});

  factory Query$shows.fromJson(Map<String, dynamic> json) {
    final l$shows = json['shows'];
    final l$$__typename = json['__typename'];
    return Query$shows(
      shows: l$shows == null
          ? null
          : Query$shows$shows.fromJson((l$shows as Map<String, dynamic>)),
      $__typename: (l$$__typename as String),
    );
  }

  final Query$shows$shows? shows;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$shows = shows;
    _resultData['shows'] = l$shows?.toJson();
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$shows = shows;
    final l$$__typename = $__typename;
    return Object.hashAll([l$shows, l$$__typename]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Query$shows || runtimeType != other.runtimeType) {
      return false;
    }
    final l$shows = shows;
    final lOther$shows = other.shows;
    if (l$shows != lOther$shows) {
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

extension UtilityExtension$Query$shows on Query$shows {
  CopyWith$Query$shows<Query$shows> get copyWith =>
      CopyWith$Query$shows(this, (i) => i);
}

abstract class CopyWith$Query$shows<TRes> {
  factory CopyWith$Query$shows(
    Query$shows instance,
    TRes Function(Query$shows) then,
  ) = _CopyWithImpl$Query$shows;

  factory CopyWith$Query$shows.stub(TRes res) = _CopyWithStubImpl$Query$shows;

  TRes call({Query$shows$shows? shows, String? $__typename});
  CopyWith$Query$shows$shows<TRes> get shows;
}

class _CopyWithImpl$Query$shows<TRes> implements CopyWith$Query$shows<TRes> {
  _CopyWithImpl$Query$shows(this._instance, this._then);

  final Query$shows _instance;

  final TRes Function(Query$shows) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({Object? shows = _undefined, Object? $__typename = _undefined}) =>
      _then(
        Query$shows(
          shows: shows == _undefined
              ? _instance.shows
              : (shows as Query$shows$shows?),
          $__typename: $__typename == _undefined || $__typename == null
              ? _instance.$__typename
              : ($__typename as String),
        ),
      );

  CopyWith$Query$shows$shows<TRes> get shows {
    final local$shows = _instance.shows;
    return local$shows == null
        ? CopyWith$Query$shows$shows.stub(_then(_instance))
        : CopyWith$Query$shows$shows(local$shows, (e) => call(shows: e));
  }
}

class _CopyWithStubImpl$Query$shows<TRes>
    implements CopyWith$Query$shows<TRes> {
  _CopyWithStubImpl$Query$shows(this._res);

  TRes _res;

  call({Query$shows$shows? shows, String? $__typename}) => _res;

  CopyWith$Query$shows$shows<TRes> get shows =>
      CopyWith$Query$shows$shows.stub(_res);
}

const documentNodeQueryshows = DocumentNode(
  definitions: [
    OperationDefinitionNode(
      type: OperationType.query,
      name: NameNode(value: 'shows'),
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
      ],
      directives: [],
      selectionSet: SelectionSetNode(
        selections: [
          FieldNode(
            name: NameNode(value: 'shows'),
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

class Query$shows$shows {
  Query$shows$shows({
    required this.number,
    required this.size,
    required this.totalElements,
    required this.totalPages,
    required this.content,
    this.$__typename = 'ShowPage',
  });

  factory Query$shows$shows.fromJson(Map<String, dynamic> json) {
    final l$number = json['number'];
    final l$size = json['size'];
    final l$totalElements = json['totalElements'];
    final l$totalPages = json['totalPages'];
    final l$content = json['content'];
    final l$$__typename = json['__typename'];
    return Query$shows$shows(
      number: (l$number as int),
      size: (l$size as int),
      totalElements: (l$totalElements as int),
      totalPages: (l$totalPages as int),
      content: (l$content as List<dynamic>)
          .map(
            (e) =>
                Query$shows$shows$content.fromJson((e as Map<String, dynamic>)),
          )
          .toList(),
      $__typename: (l$$__typename as String),
    );
  }

  final int number;

  final int size;

  final int totalElements;

  final int totalPages;

  final List<Query$shows$shows$content> content;

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
    if (other is! Query$shows$shows || runtimeType != other.runtimeType) {
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

extension UtilityExtension$Query$shows$shows on Query$shows$shows {
  CopyWith$Query$shows$shows<Query$shows$shows> get copyWith =>
      CopyWith$Query$shows$shows(this, (i) => i);
}

abstract class CopyWith$Query$shows$shows<TRes> {
  factory CopyWith$Query$shows$shows(
    Query$shows$shows instance,
    TRes Function(Query$shows$shows) then,
  ) = _CopyWithImpl$Query$shows$shows;

  factory CopyWith$Query$shows$shows.stub(TRes res) =
      _CopyWithStubImpl$Query$shows$shows;

  TRes call({
    int? number,
    int? size,
    int? totalElements,
    int? totalPages,
    List<Query$shows$shows$content>? content,
    String? $__typename,
  });
  TRes content(
    Iterable<Query$shows$shows$content> Function(
      Iterable<CopyWith$Query$shows$shows$content<Query$shows$shows$content>>,
    )
    _fn,
  );
}

class _CopyWithImpl$Query$shows$shows<TRes>
    implements CopyWith$Query$shows$shows<TRes> {
  _CopyWithImpl$Query$shows$shows(this._instance, this._then);

  final Query$shows$shows _instance;

  final TRes Function(Query$shows$shows) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? number = _undefined,
    Object? size = _undefined,
    Object? totalElements = _undefined,
    Object? totalPages = _undefined,
    Object? content = _undefined,
    Object? $__typename = _undefined,
  }) => _then(
    Query$shows$shows(
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
          : (content as List<Query$shows$shows$content>),
      $__typename: $__typename == _undefined || $__typename == null
          ? _instance.$__typename
          : ($__typename as String),
    ),
  );

  TRes content(
    Iterable<Query$shows$shows$content> Function(
      Iterable<CopyWith$Query$shows$shows$content<Query$shows$shows$content>>,
    )
    _fn,
  ) => call(
    content: _fn(
      _instance.content.map(
        (e) => CopyWith$Query$shows$shows$content(e, (i) => i),
      ),
    ).toList(),
  );
}

class _CopyWithStubImpl$Query$shows$shows<TRes>
    implements CopyWith$Query$shows$shows<TRes> {
  _CopyWithStubImpl$Query$shows$shows(this._res);

  TRes _res;

  call({
    int? number,
    int? size,
    int? totalElements,
    int? totalPages,
    List<Query$shows$shows$content>? content,
    String? $__typename,
  }) => _res;

  content(_fn) => _res;
}

class Query$shows$shows$content {
  Query$shows$shows$content({
    required this.id,
    required this.releaseYear,
    required this.name,
    this.images,
    this.episodes,
    this.metadata,
    this.$__typename = 'Show',
  });

  factory Query$shows$shows$content.fromJson(Map<String, dynamic> json) {
    final l$id = json['id'];
    final l$releaseYear = json['releaseYear'];
    final l$name = json['name'];
    final l$images = json['images'];
    final l$episodes = json['episodes'];
    final l$metadata = json['metadata'];
    final l$$__typename = json['__typename'];
    return Query$shows$shows$content(
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
            (e) => Query$shows$shows$content$episodes.fromJson(
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

  final List<Query$shows$shows$content$episodes>? episodes;

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
    if (other is! Query$shows$shows$content ||
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

extension UtilityExtension$Query$shows$shows$content
    on Query$shows$shows$content {
  CopyWith$Query$shows$shows$content<Query$shows$shows$content> get copyWith =>
      CopyWith$Query$shows$shows$content(this, (i) => i);
}

abstract class CopyWith$Query$shows$shows$content<TRes> {
  factory CopyWith$Query$shows$shows$content(
    Query$shows$shows$content instance,
    TRes Function(Query$shows$shows$content) then,
  ) = _CopyWithImpl$Query$shows$shows$content;

  factory CopyWith$Query$shows$shows$content.stub(TRes res) =
      _CopyWithStubImpl$Query$shows$shows$content;

  TRes call({
    String? id,
    int? releaseYear,
    String? name,
    List<Fragment$fragmentImages>? images,
    List<Query$shows$shows$content$episodes>? episodes,
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
    Iterable<Query$shows$shows$content$episodes>? Function(
      Iterable<
        CopyWith$Query$shows$shows$content$episodes<
          Query$shows$shows$content$episodes
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

class _CopyWithImpl$Query$shows$shows$content<TRes>
    implements CopyWith$Query$shows$shows$content<TRes> {
  _CopyWithImpl$Query$shows$shows$content(this._instance, this._then);

  final Query$shows$shows$content _instance;

  final TRes Function(Query$shows$shows$content) _then;

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
    Query$shows$shows$content(
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
          : (episodes as List<Query$shows$shows$content$episodes>?),
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
    Iterable<Query$shows$shows$content$episodes>? Function(
      Iterable<
        CopyWith$Query$shows$shows$content$episodes<
          Query$shows$shows$content$episodes
        >
      >?,
    )
    _fn,
  ) => call(
    episodes: _fn(
      _instance.episodes?.map(
        (e) => CopyWith$Query$shows$shows$content$episodes(e, (i) => i),
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

class _CopyWithStubImpl$Query$shows$shows$content<TRes>
    implements CopyWith$Query$shows$shows$content<TRes> {
  _CopyWithStubImpl$Query$shows$shows$content(this._res);

  TRes _res;

  call({
    String? id,
    int? releaseYear,
    String? name,
    List<Fragment$fragmentImages>? images,
    List<Query$shows$shows$content$episodes>? episodes,
    List<Fragment$fragmentMetadata>? metadata,
    String? $__typename,
  }) => _res;

  images(_fn) => _res;

  episodes(_fn) => _res;

  metadata(_fn) => _res;
}

class Query$shows$shows$content$episodes {
  Query$shows$shows$content$episodes({
    this.number,
    this.$__typename = 'Episode',
  });

  factory Query$shows$shows$content$episodes.fromJson(
    Map<String, dynamic> json,
  ) {
    final l$number = json['number'];
    final l$$__typename = json['__typename'];
    return Query$shows$shows$content$episodes(
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
    if (other is! Query$shows$shows$content$episodes ||
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

extension UtilityExtension$Query$shows$shows$content$episodes
    on Query$shows$shows$content$episodes {
  CopyWith$Query$shows$shows$content$episodes<
    Query$shows$shows$content$episodes
  >
  get copyWith => CopyWith$Query$shows$shows$content$episodes(this, (i) => i);
}

abstract class CopyWith$Query$shows$shows$content$episodes<TRes> {
  factory CopyWith$Query$shows$shows$content$episodes(
    Query$shows$shows$content$episodes instance,
    TRes Function(Query$shows$shows$content$episodes) then,
  ) = _CopyWithImpl$Query$shows$shows$content$episodes;

  factory CopyWith$Query$shows$shows$content$episodes.stub(TRes res) =
      _CopyWithStubImpl$Query$shows$shows$content$episodes;

  TRes call({int? number, String? $__typename});
}

class _CopyWithImpl$Query$shows$shows$content$episodes<TRes>
    implements CopyWith$Query$shows$shows$content$episodes<TRes> {
  _CopyWithImpl$Query$shows$shows$content$episodes(this._instance, this._then);

  final Query$shows$shows$content$episodes _instance;

  final TRes Function(Query$shows$shows$content$episodes) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({Object? number = _undefined, Object? $__typename = _undefined}) =>
      _then(
        Query$shows$shows$content$episodes(
          number: number == _undefined ? _instance.number : (number as int?),
          $__typename: $__typename == _undefined || $__typename == null
              ? _instance.$__typename
              : ($__typename as String),
        ),
      );
}

class _CopyWithStubImpl$Query$shows$shows$content$episodes<TRes>
    implements CopyWith$Query$shows$shows$content$episodes<TRes> {
  _CopyWithStubImpl$Query$shows$shows$content$episodes(this._res);

  TRes _res;

  call({int? number, String? $__typename}) => _res;
}

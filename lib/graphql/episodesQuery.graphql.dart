import 'fragmentImages.graphql.dart';
import 'fragmentMetadata.graphql.dart';
import 'fragmentWatchStatus.graphql.dart';
import 'package:gql/ast.dart';
import 'schema.graphql.dart';

class Variables$Query$episodes {
  factory Variables$Query$episodes({
    int? page,
    int? size,
    Enum$SortingEnum? sorting,
    Enum$SortingOrder? sortingOrder,
    String? libraryId,
    Input$MediaFilterInput? filter,
  }) => Variables$Query$episodes._({
    if (page != null) r'page': page,
    if (size != null) r'size': size,
    if (sorting != null) r'sorting': sorting,
    if (sortingOrder != null) r'sortingOrder': sortingOrder,
    if (libraryId != null) r'libraryId': libraryId,
    if (filter != null) r'filter': filter,
  });

  Variables$Query$episodes._(this._$data);

  factory Variables$Query$episodes.fromJson(Map<String, dynamic> data) {
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
    if (data.containsKey('filter')) {
      final l$filter = data['filter'];
      result$data['filter'] = l$filter == null
          ? null
          : Input$MediaFilterInput.fromJson((l$filter as Map<String, dynamic>));
    }
    return Variables$Query$episodes._(result$data);
  }

  Map<String, dynamic> _$data;

  int? get page => (_$data['page'] as int?);

  int? get size => (_$data['size'] as int?);

  Enum$SortingEnum? get sorting => (_$data['sorting'] as Enum$SortingEnum?);

  Enum$SortingOrder? get sortingOrder =>
      (_$data['sortingOrder'] as Enum$SortingOrder?);

  String? get libraryId => (_$data['libraryId'] as String?);

  Input$MediaFilterInput? get filter =>
      (_$data['filter'] as Input$MediaFilterInput?);

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
    if (_$data.containsKey('filter')) {
      final l$filter = filter;
      result$data['filter'] = l$filter?.toJson();
    }
    return result$data;
  }

  CopyWith$Variables$Query$episodes<Variables$Query$episodes> get copyWith =>
      CopyWith$Variables$Query$episodes(this, (i) => i);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Variables$Query$episodes ||
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
    final l$filter = filter;
    final lOther$filter = other.filter;
    if (_$data.containsKey('filter') != other._$data.containsKey('filter')) {
      return false;
    }
    if (l$filter != lOther$filter) {
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
    final l$filter = filter;
    return Object.hashAll([
      _$data.containsKey('page') ? l$page : const {},
      _$data.containsKey('size') ? l$size : const {},
      _$data.containsKey('sorting') ? l$sorting : const {},
      _$data.containsKey('sortingOrder') ? l$sortingOrder : const {},
      _$data.containsKey('libraryId') ? l$libraryId : const {},
      _$data.containsKey('filter') ? l$filter : const {},
    ]);
  }
}

abstract class CopyWith$Variables$Query$episodes<TRes> {
  factory CopyWith$Variables$Query$episodes(
    Variables$Query$episodes instance,
    TRes Function(Variables$Query$episodes) then,
  ) = _CopyWithImpl$Variables$Query$episodes;

  factory CopyWith$Variables$Query$episodes.stub(TRes res) =
      _CopyWithStubImpl$Variables$Query$episodes;

  TRes call({
    int? page,
    int? size,
    Enum$SortingEnum? sorting,
    Enum$SortingOrder? sortingOrder,
    String? libraryId,
    Input$MediaFilterInput? filter,
  });
}

class _CopyWithImpl$Variables$Query$episodes<TRes>
    implements CopyWith$Variables$Query$episodes<TRes> {
  _CopyWithImpl$Variables$Query$episodes(this._instance, this._then);

  final Variables$Query$episodes _instance;

  final TRes Function(Variables$Query$episodes) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? page = _undefined,
    Object? size = _undefined,
    Object? sorting = _undefined,
    Object? sortingOrder = _undefined,
    Object? libraryId = _undefined,
    Object? filter = _undefined,
  }) => _then(
    Variables$Query$episodes._({
      ..._instance._$data,
      if (page != _undefined) 'page': (page as int?),
      if (size != _undefined) 'size': (size as int?),
      if (sorting != _undefined) 'sorting': (sorting as Enum$SortingEnum?),
      if (sortingOrder != _undefined)
        'sortingOrder': (sortingOrder as Enum$SortingOrder?),
      if (libraryId != _undefined) 'libraryId': (libraryId as String?),
      if (filter != _undefined) 'filter': (filter as Input$MediaFilterInput?),
    }),
  );
}

class _CopyWithStubImpl$Variables$Query$episodes<TRes>
    implements CopyWith$Variables$Query$episodes<TRes> {
  _CopyWithStubImpl$Variables$Query$episodes(this._res);

  TRes _res;

  call({
    int? page,
    int? size,
    Enum$SortingEnum? sorting,
    Enum$SortingOrder? sortingOrder,
    String? libraryId,
    Input$MediaFilterInput? filter,
  }) => _res;
}

class Query$episodes {
  Query$episodes({this.episodes, this.$__typename = 'Query'});

  factory Query$episodes.fromJson(Map<String, dynamic> json) {
    final l$episodes = json['episodes'];
    final l$$__typename = json['__typename'];
    return Query$episodes(
      episodes: l$episodes == null
          ? null
          : Query$episodes$episodes.fromJson(
              (l$episodes as Map<String, dynamic>),
            ),
      $__typename: (l$$__typename as String),
    );
  }

  final Query$episodes$episodes? episodes;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$episodes = episodes;
    _resultData['episodes'] = l$episodes?.toJson();
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$episodes = episodes;
    final l$$__typename = $__typename;
    return Object.hashAll([l$episodes, l$$__typename]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Query$episodes || runtimeType != other.runtimeType) {
      return false;
    }
    final l$episodes = episodes;
    final lOther$episodes = other.episodes;
    if (l$episodes != lOther$episodes) {
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

extension UtilityExtension$Query$episodes on Query$episodes {
  CopyWith$Query$episodes<Query$episodes> get copyWith =>
      CopyWith$Query$episodes(this, (i) => i);
}

abstract class CopyWith$Query$episodes<TRes> {
  factory CopyWith$Query$episodes(
    Query$episodes instance,
    TRes Function(Query$episodes) then,
  ) = _CopyWithImpl$Query$episodes;

  factory CopyWith$Query$episodes.stub(TRes res) =
      _CopyWithStubImpl$Query$episodes;

  TRes call({Query$episodes$episodes? episodes, String? $__typename});
  CopyWith$Query$episodes$episodes<TRes> get episodes;
}

class _CopyWithImpl$Query$episodes<TRes>
    implements CopyWith$Query$episodes<TRes> {
  _CopyWithImpl$Query$episodes(this._instance, this._then);

  final Query$episodes _instance;

  final TRes Function(Query$episodes) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? episodes = _undefined,
    Object? $__typename = _undefined,
  }) => _then(
    Query$episodes(
      episodes: episodes == _undefined
          ? _instance.episodes
          : (episodes as Query$episodes$episodes?),
      $__typename: $__typename == _undefined || $__typename == null
          ? _instance.$__typename
          : ($__typename as String),
    ),
  );

  CopyWith$Query$episodes$episodes<TRes> get episodes {
    final local$episodes = _instance.episodes;
    return local$episodes == null
        ? CopyWith$Query$episodes$episodes.stub(_then(_instance))
        : CopyWith$Query$episodes$episodes(
            local$episodes,
            (e) => call(episodes: e),
          );
  }
}

class _CopyWithStubImpl$Query$episodes<TRes>
    implements CopyWith$Query$episodes<TRes> {
  _CopyWithStubImpl$Query$episodes(this._res);

  TRes _res;

  call({Query$episodes$episodes? episodes, String? $__typename}) => _res;

  CopyWith$Query$episodes$episodes<TRes> get episodes =>
      CopyWith$Query$episodes$episodes.stub(_res);
}

const documentNodeQueryepisodes = DocumentNode(
  definitions: [
    OperationDefinitionNode(
      type: OperationType.query,
      name: NameNode(value: 'episodes'),
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
        VariableDefinitionNode(
          variable: VariableNode(name: NameNode(value: 'filter')),
          type: NamedTypeNode(
            name: NameNode(value: 'MediaFilterInput'),
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
            name: NameNode(value: 'episodes'),
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
              ArgumentNode(
                name: NameNode(value: 'filter'),
                value: VariableNode(name: NameNode(value: 'filter')),
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
                        name: NameNode(value: 'show'),
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
                        name: NameNode(value: 'season'),
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
                        name: NameNode(value: 'mediaFile'),
                        alias: null,
                        arguments: [],
                        directives: [],
                        selectionSet: SelectionSetNode(
                          selections: [
                            FieldNode(
                              name: NameNode(value: 'durationInMilliseconds'),
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
    fragmentDefinitionfragmentImages,
    fragmentDefinitionfragmentMetadata,
    fragmentDefinitionfragmentWatchStatus,
  ],
);

class Query$episodes$episodes {
  Query$episodes$episodes({
    required this.content,
    required this.totalPages,
    required this.totalElements,
    required this.number,
    required this.size,
    this.$__typename = 'EpisodePage',
  });

  factory Query$episodes$episodes.fromJson(Map<String, dynamic> json) {
    final l$content = json['content'];
    final l$totalPages = json['totalPages'];
    final l$totalElements = json['totalElements'];
    final l$number = json['number'];
    final l$size = json['size'];
    final l$$__typename = json['__typename'];
    return Query$episodes$episodes(
      content: (l$content as List<dynamic>)
          .map(
            (e) => Query$episodes$episodes$content.fromJson(
              (e as Map<String, dynamic>),
            ),
          )
          .toList(),
      totalPages: (l$totalPages as int),
      totalElements: (l$totalElements as int),
      number: (l$number as int),
      size: (l$size as int),
      $__typename: (l$$__typename as String),
    );
  }

  final List<Query$episodes$episodes$content> content;

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
    if (other is! Query$episodes$episodes || runtimeType != other.runtimeType) {
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

extension UtilityExtension$Query$episodes$episodes on Query$episodes$episodes {
  CopyWith$Query$episodes$episodes<Query$episodes$episodes> get copyWith =>
      CopyWith$Query$episodes$episodes(this, (i) => i);
}

abstract class CopyWith$Query$episodes$episodes<TRes> {
  factory CopyWith$Query$episodes$episodes(
    Query$episodes$episodes instance,
    TRes Function(Query$episodes$episodes) then,
  ) = _CopyWithImpl$Query$episodes$episodes;

  factory CopyWith$Query$episodes$episodes.stub(TRes res) =
      _CopyWithStubImpl$Query$episodes$episodes;

  TRes call({
    List<Query$episodes$episodes$content>? content,
    int? totalPages,
    int? totalElements,
    int? number,
    int? size,
    String? $__typename,
  });
  TRes content(
    Iterable<Query$episodes$episodes$content> Function(
      Iterable<
        CopyWith$Query$episodes$episodes$content<
          Query$episodes$episodes$content
        >
      >,
    )
    _fn,
  );
}

class _CopyWithImpl$Query$episodes$episodes<TRes>
    implements CopyWith$Query$episodes$episodes<TRes> {
  _CopyWithImpl$Query$episodes$episodes(this._instance, this._then);

  final Query$episodes$episodes _instance;

  final TRes Function(Query$episodes$episodes) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? content = _undefined,
    Object? totalPages = _undefined,
    Object? totalElements = _undefined,
    Object? number = _undefined,
    Object? size = _undefined,
    Object? $__typename = _undefined,
  }) => _then(
    Query$episodes$episodes(
      content: content == _undefined || content == null
          ? _instance.content
          : (content as List<Query$episodes$episodes$content>),
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
    Iterable<Query$episodes$episodes$content> Function(
      Iterable<
        CopyWith$Query$episodes$episodes$content<
          Query$episodes$episodes$content
        >
      >,
    )
    _fn,
  ) => call(
    content: _fn(
      _instance.content.map(
        (e) => CopyWith$Query$episodes$episodes$content(e, (i) => i),
      ),
    ).toList(),
  );
}

class _CopyWithStubImpl$Query$episodes$episodes<TRes>
    implements CopyWith$Query$episodes$episodes<TRes> {
  _CopyWithStubImpl$Query$episodes$episodes(this._res);

  TRes _res;

  call({
    List<Query$episodes$episodes$content>? content,
    int? totalPages,
    int? totalElements,
    int? number,
    int? size,
    String? $__typename,
  }) => _res;

  content(_fn) => _res;
}

class Query$episodes$episodes$content {
  Query$episodes$episodes$content({
    required this.id,
    required this.number,
    this.$show,
    this.season,
    this.metadata,
    this.images,
    this.watchStatus,
    this.mediaFile,
    this.$__typename = 'Episode',
  });

  factory Query$episodes$episodes$content.fromJson(Map<String, dynamic> json) {
    final l$id = json['id'];
    final l$number = json['number'];
    final l$$show = json['show'];
    final l$season = json['season'];
    final l$metadata = json['metadata'];
    final l$images = json['images'];
    final l$watchStatus = json['watchStatus'];
    final l$mediaFile = json['mediaFile'];
    final l$$__typename = json['__typename'];
    return Query$episodes$episodes$content(
      id: (l$id as String),
      number: (l$number as int),
      $show: l$$show == null
          ? null
          : Query$episodes$episodes$content$show.fromJson(
              (l$$show as Map<String, dynamic>),
            ),
      season: l$season == null
          ? null
          : Query$episodes$episodes$content$season.fromJson(
              (l$season as Map<String, dynamic>),
            ),
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
      watchStatus: (l$watchStatus as List<dynamic>?)
          ?.map(
            (e) => Fragment$fragmentWatchStatus.fromJson(
              (e as Map<String, dynamic>),
            ),
          )
          .toList(),
      mediaFile: (l$mediaFile as List<dynamic>?)
          ?.map(
            (e) => Query$episodes$episodes$content$mediaFile.fromJson(
              (e as Map<String, dynamic>),
            ),
          )
          .toList(),
      $__typename: (l$$__typename as String),
    );
  }

  final String id;

  final int number;

  final Query$episodes$episodes$content$show? $show;

  final Query$episodes$episodes$content$season? season;

  final List<Fragment$fragmentMetadata>? metadata;

  final List<Fragment$fragmentImages>? images;

  final List<Fragment$fragmentWatchStatus>? watchStatus;

  final List<Query$episodes$episodes$content$mediaFile>? mediaFile;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$id = id;
    _resultData['id'] = l$id;
    final l$number = number;
    _resultData['number'] = l$number;
    final l$$show = $show;
    _resultData['show'] = l$$show?.toJson();
    final l$season = season;
    _resultData['season'] = l$season?.toJson();
    final l$metadata = metadata;
    _resultData['metadata'] = l$metadata?.map((e) => e.toJson()).toList();
    final l$images = images;
    _resultData['images'] = l$images?.map((e) => e.toJson()).toList();
    final l$watchStatus = watchStatus;
    _resultData['watchStatus'] = l$watchStatus?.map((e) => e.toJson()).toList();
    final l$mediaFile = mediaFile;
    _resultData['mediaFile'] = l$mediaFile?.map((e) => e.toJson()).toList();
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$id = id;
    final l$number = number;
    final l$$show = $show;
    final l$season = season;
    final l$metadata = metadata;
    final l$images = images;
    final l$watchStatus = watchStatus;
    final l$mediaFile = mediaFile;
    final l$$__typename = $__typename;
    return Object.hashAll([
      l$id,
      l$number,
      l$$show,
      l$season,
      l$metadata == null ? null : Object.hashAll(l$metadata.map((v) => v)),
      l$images == null ? null : Object.hashAll(l$images.map((v) => v)),
      l$watchStatus == null
          ? null
          : Object.hashAll(l$watchStatus.map((v) => v)),
      l$mediaFile == null ? null : Object.hashAll(l$mediaFile.map((v) => v)),
      l$$__typename,
    ]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Query$episodes$episodes$content ||
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
    final l$$show = $show;
    final lOther$$show = other.$show;
    if (l$$show != lOther$$show) {
      return false;
    }
    final l$season = season;
    final lOther$season = other.season;
    if (l$season != lOther$season) {
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
    final l$$__typename = $__typename;
    final lOther$$__typename = other.$__typename;
    if (l$$__typename != lOther$$__typename) {
      return false;
    }
    return true;
  }
}

extension UtilityExtension$Query$episodes$episodes$content
    on Query$episodes$episodes$content {
  CopyWith$Query$episodes$episodes$content<Query$episodes$episodes$content>
  get copyWith => CopyWith$Query$episodes$episodes$content(this, (i) => i);
}

abstract class CopyWith$Query$episodes$episodes$content<TRes> {
  factory CopyWith$Query$episodes$episodes$content(
    Query$episodes$episodes$content instance,
    TRes Function(Query$episodes$episodes$content) then,
  ) = _CopyWithImpl$Query$episodes$episodes$content;

  factory CopyWith$Query$episodes$episodes$content.stub(TRes res) =
      _CopyWithStubImpl$Query$episodes$episodes$content;

  TRes call({
    String? id,
    int? number,
    Query$episodes$episodes$content$show? $show,
    Query$episodes$episodes$content$season? season,
    List<Fragment$fragmentMetadata>? metadata,
    List<Fragment$fragmentImages>? images,
    List<Fragment$fragmentWatchStatus>? watchStatus,
    List<Query$episodes$episodes$content$mediaFile>? mediaFile,
    String? $__typename,
  });
  CopyWith$Query$episodes$episodes$content$show<TRes> get $show;
  CopyWith$Query$episodes$episodes$content$season<TRes> get season;
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
  TRes watchStatus(
    Iterable<Fragment$fragmentWatchStatus>? Function(
      Iterable<
        CopyWith$Fragment$fragmentWatchStatus<Fragment$fragmentWatchStatus>
      >?,
    )
    _fn,
  );
  TRes mediaFile(
    Iterable<Query$episodes$episodes$content$mediaFile>? Function(
      Iterable<
        CopyWith$Query$episodes$episodes$content$mediaFile<
          Query$episodes$episodes$content$mediaFile
        >
      >?,
    )
    _fn,
  );
}

class _CopyWithImpl$Query$episodes$episodes$content<TRes>
    implements CopyWith$Query$episodes$episodes$content<TRes> {
  _CopyWithImpl$Query$episodes$episodes$content(this._instance, this._then);

  final Query$episodes$episodes$content _instance;

  final TRes Function(Query$episodes$episodes$content) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? id = _undefined,
    Object? number = _undefined,
    Object? $show = _undefined,
    Object? season = _undefined,
    Object? metadata = _undefined,
    Object? images = _undefined,
    Object? watchStatus = _undefined,
    Object? mediaFile = _undefined,
    Object? $__typename = _undefined,
  }) => _then(
    Query$episodes$episodes$content(
      id: id == _undefined || id == null ? _instance.id : (id as String),
      number: number == _undefined || number == null
          ? _instance.number
          : (number as int),
      $show: $show == _undefined
          ? _instance.$show
          : ($show as Query$episodes$episodes$content$show?),
      season: season == _undefined
          ? _instance.season
          : (season as Query$episodes$episodes$content$season?),
      metadata: metadata == _undefined
          ? _instance.metadata
          : (metadata as List<Fragment$fragmentMetadata>?),
      images: images == _undefined
          ? _instance.images
          : (images as List<Fragment$fragmentImages>?),
      watchStatus: watchStatus == _undefined
          ? _instance.watchStatus
          : (watchStatus as List<Fragment$fragmentWatchStatus>?),
      mediaFile: mediaFile == _undefined
          ? _instance.mediaFile
          : (mediaFile as List<Query$episodes$episodes$content$mediaFile>?),
      $__typename: $__typename == _undefined || $__typename == null
          ? _instance.$__typename
          : ($__typename as String),
    ),
  );

  CopyWith$Query$episodes$episodes$content$show<TRes> get $show {
    final local$$show = _instance.$show;
    return local$$show == null
        ? CopyWith$Query$episodes$episodes$content$show.stub(_then(_instance))
        : CopyWith$Query$episodes$episodes$content$show(
            local$$show,
            (e) => call($show: e),
          );
  }

  CopyWith$Query$episodes$episodes$content$season<TRes> get season {
    final local$season = _instance.season;
    return local$season == null
        ? CopyWith$Query$episodes$episodes$content$season.stub(_then(_instance))
        : CopyWith$Query$episodes$episodes$content$season(
            local$season,
            (e) => call(season: e),
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

  TRes mediaFile(
    Iterable<Query$episodes$episodes$content$mediaFile>? Function(
      Iterable<
        CopyWith$Query$episodes$episodes$content$mediaFile<
          Query$episodes$episodes$content$mediaFile
        >
      >?,
    )
    _fn,
  ) => call(
    mediaFile: _fn(
      _instance.mediaFile?.map(
        (e) => CopyWith$Query$episodes$episodes$content$mediaFile(e, (i) => i),
      ),
    )?.toList(),
  );
}

class _CopyWithStubImpl$Query$episodes$episodes$content<TRes>
    implements CopyWith$Query$episodes$episodes$content<TRes> {
  _CopyWithStubImpl$Query$episodes$episodes$content(this._res);

  TRes _res;

  call({
    String? id,
    int? number,
    Query$episodes$episodes$content$show? $show,
    Query$episodes$episodes$content$season? season,
    List<Fragment$fragmentMetadata>? metadata,
    List<Fragment$fragmentImages>? images,
    List<Fragment$fragmentWatchStatus>? watchStatus,
    List<Query$episodes$episodes$content$mediaFile>? mediaFile,
    String? $__typename,
  }) => _res;

  CopyWith$Query$episodes$episodes$content$show<TRes> get $show =>
      CopyWith$Query$episodes$episodes$content$show.stub(_res);

  CopyWith$Query$episodes$episodes$content$season<TRes> get season =>
      CopyWith$Query$episodes$episodes$content$season.stub(_res);

  metadata(_fn) => _res;

  images(_fn) => _res;

  watchStatus(_fn) => _res;

  mediaFile(_fn) => _res;
}

class Query$episodes$episodes$content$show {
  Query$episodes$episodes$content$show({
    required this.id,
    required this.name,
    this.images,
    this.$__typename = 'Show',
  });

  factory Query$episodes$episodes$content$show.fromJson(
    Map<String, dynamic> json,
  ) {
    final l$id = json['id'];
    final l$name = json['name'];
    final l$images = json['images'];
    final l$$__typename = json['__typename'];
    return Query$episodes$episodes$content$show(
      id: (l$id as String),
      name: (l$name as String),
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

  final String name;

  final List<Fragment$fragmentImages>? images;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$id = id;
    _resultData['id'] = l$id;
    final l$name = name;
    _resultData['name'] = l$name;
    final l$images = images;
    _resultData['images'] = l$images?.map((e) => e.toJson()).toList();
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$id = id;
    final l$name = name;
    final l$images = images;
    final l$$__typename = $__typename;
    return Object.hashAll([
      l$id,
      l$name,
      l$images == null ? null : Object.hashAll(l$images.map((v) => v)),
      l$$__typename,
    ]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Query$episodes$episodes$content$show ||
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

extension UtilityExtension$Query$episodes$episodes$content$show
    on Query$episodes$episodes$content$show {
  CopyWith$Query$episodes$episodes$content$show<
    Query$episodes$episodes$content$show
  >
  get copyWith => CopyWith$Query$episodes$episodes$content$show(this, (i) => i);
}

abstract class CopyWith$Query$episodes$episodes$content$show<TRes> {
  factory CopyWith$Query$episodes$episodes$content$show(
    Query$episodes$episodes$content$show instance,
    TRes Function(Query$episodes$episodes$content$show) then,
  ) = _CopyWithImpl$Query$episodes$episodes$content$show;

  factory CopyWith$Query$episodes$episodes$content$show.stub(TRes res) =
      _CopyWithStubImpl$Query$episodes$episodes$content$show;

  TRes call({
    String? id,
    String? name,
    List<Fragment$fragmentImages>? images,
    String? $__typename,
  });
  TRes images(
    Iterable<Fragment$fragmentImages>? Function(
      Iterable<CopyWith$Fragment$fragmentImages<Fragment$fragmentImages>>?,
    )
    _fn,
  );
}

class _CopyWithImpl$Query$episodes$episodes$content$show<TRes>
    implements CopyWith$Query$episodes$episodes$content$show<TRes> {
  _CopyWithImpl$Query$episodes$episodes$content$show(
    this._instance,
    this._then,
  );

  final Query$episodes$episodes$content$show _instance;

  final TRes Function(Query$episodes$episodes$content$show) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? id = _undefined,
    Object? name = _undefined,
    Object? images = _undefined,
    Object? $__typename = _undefined,
  }) => _then(
    Query$episodes$episodes$content$show(
      id: id == _undefined || id == null ? _instance.id : (id as String),
      name: name == _undefined || name == null
          ? _instance.name
          : (name as String),
      images: images == _undefined
          ? _instance.images
          : (images as List<Fragment$fragmentImages>?),
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
}

class _CopyWithStubImpl$Query$episodes$episodes$content$show<TRes>
    implements CopyWith$Query$episodes$episodes$content$show<TRes> {
  _CopyWithStubImpl$Query$episodes$episodes$content$show(this._res);

  TRes _res;

  call({
    String? id,
    String? name,
    List<Fragment$fragmentImages>? images,
    String? $__typename,
  }) => _res;

  images(_fn) => _res;
}

class Query$episodes$episodes$content$season {
  Query$episodes$episodes$content$season({
    required this.id,
    required this.number,
    this.$__typename = 'Season',
  });

  factory Query$episodes$episodes$content$season.fromJson(
    Map<String, dynamic> json,
  ) {
    final l$id = json['id'];
    final l$number = json['number'];
    final l$$__typename = json['__typename'];
    return Query$episodes$episodes$content$season(
      id: (l$id as String),
      number: (l$number as int),
      $__typename: (l$$__typename as String),
    );
  }

  final String id;

  final int number;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$id = id;
    _resultData['id'] = l$id;
    final l$number = number;
    _resultData['number'] = l$number;
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$id = id;
    final l$number = number;
    final l$$__typename = $__typename;
    return Object.hashAll([l$id, l$number, l$$__typename]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Query$episodes$episodes$content$season ||
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
    final l$$__typename = $__typename;
    final lOther$$__typename = other.$__typename;
    if (l$$__typename != lOther$$__typename) {
      return false;
    }
    return true;
  }
}

extension UtilityExtension$Query$episodes$episodes$content$season
    on Query$episodes$episodes$content$season {
  CopyWith$Query$episodes$episodes$content$season<
    Query$episodes$episodes$content$season
  >
  get copyWith =>
      CopyWith$Query$episodes$episodes$content$season(this, (i) => i);
}

abstract class CopyWith$Query$episodes$episodes$content$season<TRes> {
  factory CopyWith$Query$episodes$episodes$content$season(
    Query$episodes$episodes$content$season instance,
    TRes Function(Query$episodes$episodes$content$season) then,
  ) = _CopyWithImpl$Query$episodes$episodes$content$season;

  factory CopyWith$Query$episodes$episodes$content$season.stub(TRes res) =
      _CopyWithStubImpl$Query$episodes$episodes$content$season;

  TRes call({String? id, int? number, String? $__typename});
}

class _CopyWithImpl$Query$episodes$episodes$content$season<TRes>
    implements CopyWith$Query$episodes$episodes$content$season<TRes> {
  _CopyWithImpl$Query$episodes$episodes$content$season(
    this._instance,
    this._then,
  );

  final Query$episodes$episodes$content$season _instance;

  final TRes Function(Query$episodes$episodes$content$season) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? id = _undefined,
    Object? number = _undefined,
    Object? $__typename = _undefined,
  }) => _then(
    Query$episodes$episodes$content$season(
      id: id == _undefined || id == null ? _instance.id : (id as String),
      number: number == _undefined || number == null
          ? _instance.number
          : (number as int),
      $__typename: $__typename == _undefined || $__typename == null
          ? _instance.$__typename
          : ($__typename as String),
    ),
  );
}

class _CopyWithStubImpl$Query$episodes$episodes$content$season<TRes>
    implements CopyWith$Query$episodes$episodes$content$season<TRes> {
  _CopyWithStubImpl$Query$episodes$episodes$content$season(this._res);

  TRes _res;

  call({String? id, int? number, String? $__typename}) => _res;
}

class Query$episodes$episodes$content$mediaFile {
  Query$episodes$episodes$content$mediaFile({
    this.durationInMilliseconds,
    this.$__typename = 'MediaFile',
  });

  factory Query$episodes$episodes$content$mediaFile.fromJson(
    Map<String, dynamic> json,
  ) {
    final l$durationInMilliseconds = json['durationInMilliseconds'];
    final l$$__typename = json['__typename'];
    return Query$episodes$episodes$content$mediaFile(
      durationInMilliseconds: (l$durationInMilliseconds as int?),
      $__typename: (l$$__typename as String),
    );
  }

  final int? durationInMilliseconds;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$durationInMilliseconds = durationInMilliseconds;
    _resultData['durationInMilliseconds'] = l$durationInMilliseconds;
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$durationInMilliseconds = durationInMilliseconds;
    final l$$__typename = $__typename;
    return Object.hashAll([l$durationInMilliseconds, l$$__typename]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Query$episodes$episodes$content$mediaFile ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$durationInMilliseconds = durationInMilliseconds;
    final lOther$durationInMilliseconds = other.durationInMilliseconds;
    if (l$durationInMilliseconds != lOther$durationInMilliseconds) {
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

extension UtilityExtension$Query$episodes$episodes$content$mediaFile
    on Query$episodes$episodes$content$mediaFile {
  CopyWith$Query$episodes$episodes$content$mediaFile<
    Query$episodes$episodes$content$mediaFile
  >
  get copyWith =>
      CopyWith$Query$episodes$episodes$content$mediaFile(this, (i) => i);
}

abstract class CopyWith$Query$episodes$episodes$content$mediaFile<TRes> {
  factory CopyWith$Query$episodes$episodes$content$mediaFile(
    Query$episodes$episodes$content$mediaFile instance,
    TRes Function(Query$episodes$episodes$content$mediaFile) then,
  ) = _CopyWithImpl$Query$episodes$episodes$content$mediaFile;

  factory CopyWith$Query$episodes$episodes$content$mediaFile.stub(TRes res) =
      _CopyWithStubImpl$Query$episodes$episodes$content$mediaFile;

  TRes call({int? durationInMilliseconds, String? $__typename});
}

class _CopyWithImpl$Query$episodes$episodes$content$mediaFile<TRes>
    implements CopyWith$Query$episodes$episodes$content$mediaFile<TRes> {
  _CopyWithImpl$Query$episodes$episodes$content$mediaFile(
    this._instance,
    this._then,
  );

  final Query$episodes$episodes$content$mediaFile _instance;

  final TRes Function(Query$episodes$episodes$content$mediaFile) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? durationInMilliseconds = _undefined,
    Object? $__typename = _undefined,
  }) => _then(
    Query$episodes$episodes$content$mediaFile(
      durationInMilliseconds: durationInMilliseconds == _undefined
          ? _instance.durationInMilliseconds
          : (durationInMilliseconds as int?),
      $__typename: $__typename == _undefined || $__typename == null
          ? _instance.$__typename
          : ($__typename as String),
    ),
  );
}

class _CopyWithStubImpl$Query$episodes$episodes$content$mediaFile<TRes>
    implements CopyWith$Query$episodes$episodes$content$mediaFile<TRes> {
  _CopyWithStubImpl$Query$episodes$episodes$content$mediaFile(this._res);

  TRes _res;

  call({int? durationInMilliseconds, String? $__typename}) => _res;
}

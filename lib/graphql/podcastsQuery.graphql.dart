import 'fragmentImages.graphql.dart';
import 'fragmentMetadata.graphql.dart';
import 'fragmentPodcast.graphql.dart';
import 'package:gql/ast.dart';
import 'schema.graphql.dart';

class Variables$Query$podcasts {
  factory Variables$Query$podcasts({
    int? page,
    int? size,
    Enum$SortingEnum? sorting,
    Enum$SortingOrder? sortingOrder,
    String? libraryId,
  }) => Variables$Query$podcasts._({
    if (page != null) r'page': page,
    if (size != null) r'size': size,
    if (sorting != null) r'sorting': sorting,
    if (sortingOrder != null) r'sortingOrder': sortingOrder,
    if (libraryId != null) r'libraryId': libraryId,
  });

  Variables$Query$podcasts._(this._$data);

  factory Variables$Query$podcasts.fromJson(Map<String, dynamic> data) {
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
    return Variables$Query$podcasts._(result$data);
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

  CopyWith$Variables$Query$podcasts<Variables$Query$podcasts> get copyWith =>
      CopyWith$Variables$Query$podcasts(this, (i) => i);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Variables$Query$podcasts ||
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

abstract class CopyWith$Variables$Query$podcasts<TRes> {
  factory CopyWith$Variables$Query$podcasts(
    Variables$Query$podcasts instance,
    TRes Function(Variables$Query$podcasts) then,
  ) = _CopyWithImpl$Variables$Query$podcasts;

  factory CopyWith$Variables$Query$podcasts.stub(TRes res) =
      _CopyWithStubImpl$Variables$Query$podcasts;

  TRes call({
    int? page,
    int? size,
    Enum$SortingEnum? sorting,
    Enum$SortingOrder? sortingOrder,
    String? libraryId,
  });
}

class _CopyWithImpl$Variables$Query$podcasts<TRes>
    implements CopyWith$Variables$Query$podcasts<TRes> {
  _CopyWithImpl$Variables$Query$podcasts(this._instance, this._then);

  final Variables$Query$podcasts _instance;

  final TRes Function(Variables$Query$podcasts) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? page = _undefined,
    Object? size = _undefined,
    Object? sorting = _undefined,
    Object? sortingOrder = _undefined,
    Object? libraryId = _undefined,
  }) => _then(
    Variables$Query$podcasts._({
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

class _CopyWithStubImpl$Variables$Query$podcasts<TRes>
    implements CopyWith$Variables$Query$podcasts<TRes> {
  _CopyWithStubImpl$Variables$Query$podcasts(this._res);

  TRes _res;

  call({
    int? page,
    int? size,
    Enum$SortingEnum? sorting,
    Enum$SortingOrder? sortingOrder,
    String? libraryId,
  }) => _res;
}

class Query$podcasts {
  Query$podcasts({this.podcasts, this.$__typename = 'Query'});

  factory Query$podcasts.fromJson(Map<String, dynamic> json) {
    final l$podcasts = json['podcasts'];
    final l$$__typename = json['__typename'];
    return Query$podcasts(
      podcasts: l$podcasts == null
          ? null
          : Query$podcasts$podcasts.fromJson(
              (l$podcasts as Map<String, dynamic>),
            ),
      $__typename: (l$$__typename as String),
    );
  }

  final Query$podcasts$podcasts? podcasts;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$podcasts = podcasts;
    _resultData['podcasts'] = l$podcasts?.toJson();
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$podcasts = podcasts;
    final l$$__typename = $__typename;
    return Object.hashAll([l$podcasts, l$$__typename]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Query$podcasts || runtimeType != other.runtimeType) {
      return false;
    }
    final l$podcasts = podcasts;
    final lOther$podcasts = other.podcasts;
    if (l$podcasts != lOther$podcasts) {
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

extension UtilityExtension$Query$podcasts on Query$podcasts {
  CopyWith$Query$podcasts<Query$podcasts> get copyWith =>
      CopyWith$Query$podcasts(this, (i) => i);
}

abstract class CopyWith$Query$podcasts<TRes> {
  factory CopyWith$Query$podcasts(
    Query$podcasts instance,
    TRes Function(Query$podcasts) then,
  ) = _CopyWithImpl$Query$podcasts;

  factory CopyWith$Query$podcasts.stub(TRes res) =
      _CopyWithStubImpl$Query$podcasts;

  TRes call({Query$podcasts$podcasts? podcasts, String? $__typename});
  CopyWith$Query$podcasts$podcasts<TRes> get podcasts;
}

class _CopyWithImpl$Query$podcasts<TRes>
    implements CopyWith$Query$podcasts<TRes> {
  _CopyWithImpl$Query$podcasts(this._instance, this._then);

  final Query$podcasts _instance;

  final TRes Function(Query$podcasts) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? podcasts = _undefined,
    Object? $__typename = _undefined,
  }) => _then(
    Query$podcasts(
      podcasts: podcasts == _undefined
          ? _instance.podcasts
          : (podcasts as Query$podcasts$podcasts?),
      $__typename: $__typename == _undefined || $__typename == null
          ? _instance.$__typename
          : ($__typename as String),
    ),
  );

  CopyWith$Query$podcasts$podcasts<TRes> get podcasts {
    final local$podcasts = _instance.podcasts;
    return local$podcasts == null
        ? CopyWith$Query$podcasts$podcasts.stub(_then(_instance))
        : CopyWith$Query$podcasts$podcasts(
            local$podcasts,
            (e) => call(podcasts: e),
          );
  }
}

class _CopyWithStubImpl$Query$podcasts<TRes>
    implements CopyWith$Query$podcasts<TRes> {
  _CopyWithStubImpl$Query$podcasts(this._res);

  TRes _res;

  call({Query$podcasts$podcasts? podcasts, String? $__typename}) => _res;

  CopyWith$Query$podcasts$podcasts<TRes> get podcasts =>
      CopyWith$Query$podcasts$podcasts.stub(_res);
}

const documentNodeQuerypodcasts = DocumentNode(
  definitions: [
    OperationDefinitionNode(
      type: OperationType.query,
      name: NameNode(value: 'podcasts'),
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
            name: NameNode(value: 'podcasts'),
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
                  name: NameNode(value: 'content'),
                  alias: null,
                  arguments: [],
                  directives: [],
                  selectionSet: SelectionSetNode(
                    selections: [
                      FragmentSpreadNode(
                        name: NameNode(value: 'fragmentPodcast'),
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
    fragmentDefinitionfragmentPodcast,
    fragmentDefinitionfragmentImages,
    fragmentDefinitionfragmentMetadata,
  ],
);

class Query$podcasts$podcasts {
  Query$podcasts$podcasts({
    required this.content,
    required this.totalPages,
    required this.totalElements,
    required this.number,
    required this.size,
    this.$__typename = 'PodcastPage',
  });

  factory Query$podcasts$podcasts.fromJson(Map<String, dynamic> json) {
    final l$content = json['content'];
    final l$totalPages = json['totalPages'];
    final l$totalElements = json['totalElements'];
    final l$number = json['number'];
    final l$size = json['size'];
    final l$$__typename = json['__typename'];
    return Query$podcasts$podcasts(
      content: (l$content as List<dynamic>)
          .map(
            (e) =>
                Fragment$fragmentPodcast.fromJson((e as Map<String, dynamic>)),
          )
          .toList(),
      totalPages: (l$totalPages as int),
      totalElements: (l$totalElements as int),
      number: (l$number as int),
      size: (l$size as int),
      $__typename: (l$$__typename as String),
    );
  }

  final List<Fragment$fragmentPodcast> content;

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
    if (other is! Query$podcasts$podcasts || runtimeType != other.runtimeType) {
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

extension UtilityExtension$Query$podcasts$podcasts on Query$podcasts$podcasts {
  CopyWith$Query$podcasts$podcasts<Query$podcasts$podcasts> get copyWith =>
      CopyWith$Query$podcasts$podcasts(this, (i) => i);
}

abstract class CopyWith$Query$podcasts$podcasts<TRes> {
  factory CopyWith$Query$podcasts$podcasts(
    Query$podcasts$podcasts instance,
    TRes Function(Query$podcasts$podcasts) then,
  ) = _CopyWithImpl$Query$podcasts$podcasts;

  factory CopyWith$Query$podcasts$podcasts.stub(TRes res) =
      _CopyWithStubImpl$Query$podcasts$podcasts;

  TRes call({
    List<Fragment$fragmentPodcast>? content,
    int? totalPages,
    int? totalElements,
    int? number,
    int? size,
    String? $__typename,
  });
  TRes content(
    Iterable<Fragment$fragmentPodcast> Function(
      Iterable<CopyWith$Fragment$fragmentPodcast<Fragment$fragmentPodcast>>,
    )
    _fn,
  );
}

class _CopyWithImpl$Query$podcasts$podcasts<TRes>
    implements CopyWith$Query$podcasts$podcasts<TRes> {
  _CopyWithImpl$Query$podcasts$podcasts(this._instance, this._then);

  final Query$podcasts$podcasts _instance;

  final TRes Function(Query$podcasts$podcasts) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? content = _undefined,
    Object? totalPages = _undefined,
    Object? totalElements = _undefined,
    Object? number = _undefined,
    Object? size = _undefined,
    Object? $__typename = _undefined,
  }) => _then(
    Query$podcasts$podcasts(
      content: content == _undefined || content == null
          ? _instance.content
          : (content as List<Fragment$fragmentPodcast>),
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
    Iterable<Fragment$fragmentPodcast> Function(
      Iterable<CopyWith$Fragment$fragmentPodcast<Fragment$fragmentPodcast>>,
    )
    _fn,
  ) => call(
    content: _fn(
      _instance.content.map(
        (e) => CopyWith$Fragment$fragmentPodcast(e, (i) => i),
      ),
    ).toList(),
  );
}

class _CopyWithStubImpl$Query$podcasts$podcasts<TRes>
    implements CopyWith$Query$podcasts$podcasts<TRes> {
  _CopyWithStubImpl$Query$podcasts$podcasts(this._res);

  TRes _res;

  call({
    List<Fragment$fragmentPodcast>? content,
    int? totalPages,
    int? totalElements,
    int? number,
    int? size,
    String? $__typename,
  }) => _res;

  content(_fn) => _res;
}

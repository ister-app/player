import 'fragmentImages.graphql.dart';

import 'package:gql/ast.dart';

import 'schema.graphql.dart';

class Fragment$fragmentPlaylist {
  Fragment$fragmentPlaylist({
    required this.id,
    required this.name,
    required this.type,
    required this.libraryId,
    required this.libraryType,
    this.itemCount,
    required this.coverImages,
    this.filterKind,
    this.sorting,
    this.sortingOrder,
    this.filter,
    this.$__typename = 'Playlist',
  });

  factory Fragment$fragmentPlaylist.fromJson(Map<String, dynamic> json) {
    final l$id = json['id'];
    final l$name = json['name'];
    final l$type = json['type'];
    final l$libraryId = json['libraryId'];
    final l$libraryType = json['libraryType'];
    final l$itemCount = json['itemCount'];
    final l$coverImages = json['coverImages'];
    final l$filterKind = json['filterKind'];
    final l$sorting = json['sorting'];
    final l$sortingOrder = json['sortingOrder'];
    final l$filter = json['filter'];
    final l$$__typename = json['__typename'];
    return Fragment$fragmentPlaylist(
      id: (l$id as String),
      name: (l$name as String),
      type: fromJson$Enum$PlaylistType((l$type as String)),
      libraryId: (l$libraryId as String),
      libraryType: fromJson$Enum$LibraryType((l$libraryType as String)),
      itemCount: (l$itemCount as int?),
      coverImages: (l$coverImages as List<dynamic>)
          .map(
            (e) =>
                Fragment$fragmentImages.fromJson((e as Map<String, dynamic>)),
          )
          .toList(),
      filterKind: l$filterKind == null
          ? null
          : fromJson$Enum$FilterKind((l$filterKind as String)),
      sorting: l$sorting == null
          ? null
          : fromJson$Enum$SortingEnum((l$sorting as String)),
      sortingOrder: l$sortingOrder == null
          ? null
          : fromJson$Enum$SortingOrder((l$sortingOrder as String)),
      filter: l$filter == null
          ? null
          : Fragment$fragmentPlaylist$filter.fromJson(
              (l$filter as Map<String, dynamic>),
            ),
      $__typename: (l$$__typename as String),
    );
  }

  final String id;

  final String name;

  final Enum$PlaylistType type;

  final String libraryId;

  final Enum$LibraryType libraryType;

  final int? itemCount;

  final List<Fragment$fragmentImages> coverImages;

  final Enum$FilterKind? filterKind;

  final Enum$SortingEnum? sorting;

  final Enum$SortingOrder? sortingOrder;

  final Fragment$fragmentPlaylist$filter? filter;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$id = id;
    _resultData['id'] = l$id;
    final l$name = name;
    _resultData['name'] = l$name;
    final l$type = type;
    _resultData['type'] = toJson$Enum$PlaylistType(l$type);
    final l$libraryId = libraryId;
    _resultData['libraryId'] = l$libraryId;
    final l$libraryType = libraryType;
    _resultData['libraryType'] = toJson$Enum$LibraryType(l$libraryType);
    final l$itemCount = itemCount;
    _resultData['itemCount'] = l$itemCount;
    final l$coverImages = coverImages;
    _resultData['coverImages'] = l$coverImages.map((e) => e.toJson()).toList();
    final l$filterKind = filterKind;
    _resultData['filterKind'] = l$filterKind == null
        ? null
        : toJson$Enum$FilterKind(l$filterKind);
    final l$sorting = sorting;
    _resultData['sorting'] = l$sorting == null
        ? null
        : toJson$Enum$SortingEnum(l$sorting);
    final l$sortingOrder = sortingOrder;
    _resultData['sortingOrder'] = l$sortingOrder == null
        ? null
        : toJson$Enum$SortingOrder(l$sortingOrder);
    final l$filter = filter;
    _resultData['filter'] = l$filter?.toJson();
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$id = id;
    final l$name = name;
    final l$type = type;
    final l$libraryId = libraryId;
    final l$libraryType = libraryType;
    final l$itemCount = itemCount;
    final l$coverImages = coverImages;
    final l$filterKind = filterKind;
    final l$sorting = sorting;
    final l$sortingOrder = sortingOrder;
    final l$filter = filter;
    final l$$__typename = $__typename;
    return Object.hashAll([
      l$id,
      l$name,
      l$type,
      l$libraryId,
      l$libraryType,
      l$itemCount,
      Object.hashAll(l$coverImages.map((v) => v)),
      l$filterKind,
      l$sorting,
      l$sortingOrder,
      l$filter,
      l$$__typename,
    ]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Fragment$fragmentPlaylist ||
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
    final l$type = type;
    final lOther$type = other.type;
    if (l$type != lOther$type) {
      return false;
    }
    final l$libraryId = libraryId;
    final lOther$libraryId = other.libraryId;
    if (l$libraryId != lOther$libraryId) {
      return false;
    }
    final l$libraryType = libraryType;
    final lOther$libraryType = other.libraryType;
    if (l$libraryType != lOther$libraryType) {
      return false;
    }
    final l$itemCount = itemCount;
    final lOther$itemCount = other.itemCount;
    if (l$itemCount != lOther$itemCount) {
      return false;
    }
    final l$coverImages = coverImages;
    final lOther$coverImages = other.coverImages;
    if (l$coverImages.length != lOther$coverImages.length) {
      return false;
    }
    for (int i = 0; i < l$coverImages.length; i++) {
      final l$coverImages$entry = l$coverImages[i];
      final lOther$coverImages$entry = lOther$coverImages[i];
      if (l$coverImages$entry != lOther$coverImages$entry) {
        return false;
      }
    }
    final l$filterKind = filterKind;
    final lOther$filterKind = other.filterKind;
    if (l$filterKind != lOther$filterKind) {
      return false;
    }
    final l$sorting = sorting;
    final lOther$sorting = other.sorting;
    if (l$sorting != lOther$sorting) {
      return false;
    }
    final l$sortingOrder = sortingOrder;
    final lOther$sortingOrder = other.sortingOrder;
    if (l$sortingOrder != lOther$sortingOrder) {
      return false;
    }
    final l$filter = filter;
    final lOther$filter = other.filter;
    if (l$filter != lOther$filter) {
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

extension UtilityExtension$Fragment$fragmentPlaylist
    on Fragment$fragmentPlaylist {
  CopyWith$Fragment$fragmentPlaylist<Fragment$fragmentPlaylist> get copyWith =>
      CopyWith$Fragment$fragmentPlaylist(this, (i) => i);
}

abstract class CopyWith$Fragment$fragmentPlaylist<TRes> {
  factory CopyWith$Fragment$fragmentPlaylist(
    Fragment$fragmentPlaylist instance,
    TRes Function(Fragment$fragmentPlaylist) then,
  ) = _CopyWithImpl$Fragment$fragmentPlaylist;

  factory CopyWith$Fragment$fragmentPlaylist.stub(TRes res) =
      _CopyWithStubImpl$Fragment$fragmentPlaylist;

  TRes call({
    String? id,
    String? name,
    Enum$PlaylistType? type,
    String? libraryId,
    Enum$LibraryType? libraryType,
    int? itemCount,
    List<Fragment$fragmentImages>? coverImages,
    Enum$FilterKind? filterKind,
    Enum$SortingEnum? sorting,
    Enum$SortingOrder? sortingOrder,
    Fragment$fragmentPlaylist$filter? filter,
    String? $__typename,
  });
  TRes coverImages(
    Iterable<Fragment$fragmentImages> Function(
      Iterable<CopyWith$Fragment$fragmentImages<Fragment$fragmentImages>>,
    )
    _fn,
  );
  CopyWith$Fragment$fragmentPlaylist$filter<TRes> get filter;
}

class _CopyWithImpl$Fragment$fragmentPlaylist<TRes>
    implements CopyWith$Fragment$fragmentPlaylist<TRes> {
  _CopyWithImpl$Fragment$fragmentPlaylist(this._instance, this._then);

  final Fragment$fragmentPlaylist _instance;

  final TRes Function(Fragment$fragmentPlaylist) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? id = _undefined,
    Object? name = _undefined,
    Object? type = _undefined,
    Object? libraryId = _undefined,
    Object? libraryType = _undefined,
    Object? itemCount = _undefined,
    Object? coverImages = _undefined,
    Object? filterKind = _undefined,
    Object? sorting = _undefined,
    Object? sortingOrder = _undefined,
    Object? filter = _undefined,
    Object? $__typename = _undefined,
  }) => _then(
    Fragment$fragmentPlaylist(
      id: id == _undefined || id == null ? _instance.id : (id as String),
      name: name == _undefined || name == null
          ? _instance.name
          : (name as String),
      type: type == _undefined || type == null
          ? _instance.type
          : (type as Enum$PlaylistType),
      libraryId: libraryId == _undefined || libraryId == null
          ? _instance.libraryId
          : (libraryId as String),
      libraryType: libraryType == _undefined || libraryType == null
          ? _instance.libraryType
          : (libraryType as Enum$LibraryType),
      itemCount: itemCount == _undefined
          ? _instance.itemCount
          : (itemCount as int?),
      coverImages: coverImages == _undefined || coverImages == null
          ? _instance.coverImages
          : (coverImages as List<Fragment$fragmentImages>),
      filterKind: filterKind == _undefined
          ? _instance.filterKind
          : (filterKind as Enum$FilterKind?),
      sorting: sorting == _undefined
          ? _instance.sorting
          : (sorting as Enum$SortingEnum?),
      sortingOrder: sortingOrder == _undefined
          ? _instance.sortingOrder
          : (sortingOrder as Enum$SortingOrder?),
      filter: filter == _undefined
          ? _instance.filter
          : (filter as Fragment$fragmentPlaylist$filter?),
      $__typename: $__typename == _undefined || $__typename == null
          ? _instance.$__typename
          : ($__typename as String),
    ),
  );

  TRes coverImages(
    Iterable<Fragment$fragmentImages> Function(
      Iterable<CopyWith$Fragment$fragmentImages<Fragment$fragmentImages>>,
    )
    _fn,
  ) => call(
    coverImages: _fn(
      _instance.coverImages.map(
        (e) => CopyWith$Fragment$fragmentImages(e, (i) => i),
      ),
    ).toList(),
  );

  CopyWith$Fragment$fragmentPlaylist$filter<TRes> get filter {
    final local$filter = _instance.filter;
    return local$filter == null
        ? CopyWith$Fragment$fragmentPlaylist$filter.stub(_then(_instance))
        : CopyWith$Fragment$fragmentPlaylist$filter(
            local$filter,
            (e) => call(filter: e),
          );
  }
}

class _CopyWithStubImpl$Fragment$fragmentPlaylist<TRes>
    implements CopyWith$Fragment$fragmentPlaylist<TRes> {
  _CopyWithStubImpl$Fragment$fragmentPlaylist(this._res);

  TRes _res;

  call({
    String? id,
    String? name,
    Enum$PlaylistType? type,
    String? libraryId,
    Enum$LibraryType? libraryType,
    int? itemCount,
    List<Fragment$fragmentImages>? coverImages,
    Enum$FilterKind? filterKind,
    Enum$SortingEnum? sorting,
    Enum$SortingOrder? sortingOrder,
    Fragment$fragmentPlaylist$filter? filter,
    String? $__typename,
  }) => _res;

  coverImages(_fn) => _res;

  CopyWith$Fragment$fragmentPlaylist$filter<TRes> get filter =>
      CopyWith$Fragment$fragmentPlaylist$filter.stub(_res);
}

const fragmentDefinitionfragmentPlaylist = FragmentDefinitionNode(
  name: NameNode(value: 'fragmentPlaylist'),
  typeCondition: TypeConditionNode(
    on: NamedTypeNode(name: NameNode(value: 'Playlist'), isNonNull: false),
  ),
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
        name: NameNode(value: 'type'),
        alias: null,
        arguments: [],
        directives: [],
        selectionSet: null,
      ),
      FieldNode(
        name: NameNode(value: 'libraryId'),
        alias: null,
        arguments: [],
        directives: [],
        selectionSet: null,
      ),
      FieldNode(
        name: NameNode(value: 'libraryType'),
        alias: null,
        arguments: [],
        directives: [],
        selectionSet: null,
      ),
      FieldNode(
        name: NameNode(value: 'itemCount'),
        alias: null,
        arguments: [],
        directives: [],
        selectionSet: null,
      ),
      FieldNode(
        name: NameNode(value: 'coverImages'),
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
        name: NameNode(value: 'filterKind'),
        alias: null,
        arguments: [],
        directives: [],
        selectionSet: null,
      ),
      FieldNode(
        name: NameNode(value: 'sorting'),
        alias: null,
        arguments: [],
        directives: [],
        selectionSet: null,
      ),
      FieldNode(
        name: NameNode(value: 'sortingOrder'),
        alias: null,
        arguments: [],
        directives: [],
        selectionSet: null,
      ),
      FieldNode(
        name: NameNode(value: 'filter'),
        alias: null,
        arguments: [],
        directives: [],
        selectionSet: SelectionSetNode(
          selections: [
            FieldNode(
              name: NameNode(value: 'match'),
              alias: null,
              arguments: [],
              directives: [],
              selectionSet: null,
            ),
            FieldNode(
              name: NameNode(value: 'limit'),
              alias: null,
              arguments: [],
              directives: [],
              selectionSet: null,
            ),
            FieldNode(
              name: NameNode(value: 'conditions'),
              alias: null,
              arguments: [],
              directives: [],
              selectionSet: SelectionSetNode(
                selections: [
                  FieldNode(
                    name: NameNode(value: 'field'),
                    alias: null,
                    arguments: [],
                    directives: [],
                    selectionSet: null,
                  ),
                  FieldNode(
                    name: NameNode(value: 'operator'),
                    alias: null,
                    arguments: [],
                    directives: [],
                    selectionSet: null,
                  ),
                  FieldNode(
                    name: NameNode(value: 'value'),
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
              name: NameNode(value: 'groups'),
              alias: null,
              arguments: [],
              directives: [],
              selectionSet: SelectionSetNode(
                selections: [
                  FieldNode(
                    name: NameNode(value: 'match'),
                    alias: null,
                    arguments: [],
                    directives: [],
                    selectionSet: null,
                  ),
                  FieldNode(
                    name: NameNode(value: 'conditions'),
                    alias: null,
                    arguments: [],
                    directives: [],
                    selectionSet: SelectionSetNode(
                      selections: [
                        FieldNode(
                          name: NameNode(value: 'field'),
                          alias: null,
                          arguments: [],
                          directives: [],
                          selectionSet: null,
                        ),
                        FieldNode(
                          name: NameNode(value: 'operator'),
                          alias: null,
                          arguments: [],
                          directives: [],
                          selectionSet: null,
                        ),
                        FieldNode(
                          name: NameNode(value: 'value'),
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
                    name: NameNode(value: 'groups'),
                    alias: null,
                    arguments: [],
                    directives: [],
                    selectionSet: SelectionSetNode(
                      selections: [
                        FieldNode(
                          name: NameNode(value: 'match'),
                          alias: null,
                          arguments: [],
                          directives: [],
                          selectionSet: null,
                        ),
                        FieldNode(
                          name: NameNode(value: 'conditions'),
                          alias: null,
                          arguments: [],
                          directives: [],
                          selectionSet: SelectionSetNode(
                            selections: [
                              FieldNode(
                                name: NameNode(value: 'field'),
                                alias: null,
                                arguments: [],
                                directives: [],
                                selectionSet: null,
                              ),
                              FieldNode(
                                name: NameNode(value: 'operator'),
                                alias: null,
                                arguments: [],
                                directives: [],
                                selectionSet: null,
                              ),
                              FieldNode(
                                name: NameNode(value: 'value'),
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
);
const documentNodeFragmentfragmentPlaylist = DocumentNode(
  definitions: [
    fragmentDefinitionfragmentPlaylist,
    fragmentDefinitionfragmentImages,
  ],
);

class Fragment$fragmentPlaylist$filter {
  Fragment$fragmentPlaylist$filter({
    required this.match,
    this.limit,
    required this.conditions,
    required this.groups,
    this.$__typename = 'FilterGroup',
  });

  factory Fragment$fragmentPlaylist$filter.fromJson(Map<String, dynamic> json) {
    final l$match = json['match'];
    final l$limit = json['limit'];
    final l$conditions = json['conditions'];
    final l$groups = json['groups'];
    final l$$__typename = json['__typename'];
    return Fragment$fragmentPlaylist$filter(
      match: fromJson$Enum$FilterMatch((l$match as String)),
      limit: (l$limit as int?),
      conditions: (l$conditions as List<dynamic>)
          .map(
            (e) => Fragment$fragmentPlaylist$filter$conditions.fromJson(
              (e as Map<String, dynamic>),
            ),
          )
          .toList(),
      groups: (l$groups as List<dynamic>)
          .map(
            (e) => Fragment$fragmentPlaylist$filter$groups.fromJson(
              (e as Map<String, dynamic>),
            ),
          )
          .toList(),
      $__typename: (l$$__typename as String),
    );
  }

  final Enum$FilterMatch match;

  final int? limit;

  final List<Fragment$fragmentPlaylist$filter$conditions> conditions;

  final List<Fragment$fragmentPlaylist$filter$groups> groups;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$match = match;
    _resultData['match'] = toJson$Enum$FilterMatch(l$match);
    final l$limit = limit;
    _resultData['limit'] = l$limit;
    final l$conditions = conditions;
    _resultData['conditions'] = l$conditions.map((e) => e.toJson()).toList();
    final l$groups = groups;
    _resultData['groups'] = l$groups.map((e) => e.toJson()).toList();
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$match = match;
    final l$limit = limit;
    final l$conditions = conditions;
    final l$groups = groups;
    final l$$__typename = $__typename;
    return Object.hashAll([
      l$match,
      l$limit,
      Object.hashAll(l$conditions.map((v) => v)),
      Object.hashAll(l$groups.map((v) => v)),
      l$$__typename,
    ]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Fragment$fragmentPlaylist$filter ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$match = match;
    final lOther$match = other.match;
    if (l$match != lOther$match) {
      return false;
    }
    final l$limit = limit;
    final lOther$limit = other.limit;
    if (l$limit != lOther$limit) {
      return false;
    }
    final l$conditions = conditions;
    final lOther$conditions = other.conditions;
    if (l$conditions.length != lOther$conditions.length) {
      return false;
    }
    for (int i = 0; i < l$conditions.length; i++) {
      final l$conditions$entry = l$conditions[i];
      final lOther$conditions$entry = lOther$conditions[i];
      if (l$conditions$entry != lOther$conditions$entry) {
        return false;
      }
    }
    final l$groups = groups;
    final lOther$groups = other.groups;
    if (l$groups.length != lOther$groups.length) {
      return false;
    }
    for (int i = 0; i < l$groups.length; i++) {
      final l$groups$entry = l$groups[i];
      final lOther$groups$entry = lOther$groups[i];
      if (l$groups$entry != lOther$groups$entry) {
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

extension UtilityExtension$Fragment$fragmentPlaylist$filter
    on Fragment$fragmentPlaylist$filter {
  CopyWith$Fragment$fragmentPlaylist$filter<Fragment$fragmentPlaylist$filter>
  get copyWith => CopyWith$Fragment$fragmentPlaylist$filter(this, (i) => i);
}

abstract class CopyWith$Fragment$fragmentPlaylist$filter<TRes> {
  factory CopyWith$Fragment$fragmentPlaylist$filter(
    Fragment$fragmentPlaylist$filter instance,
    TRes Function(Fragment$fragmentPlaylist$filter) then,
  ) = _CopyWithImpl$Fragment$fragmentPlaylist$filter;

  factory CopyWith$Fragment$fragmentPlaylist$filter.stub(TRes res) =
      _CopyWithStubImpl$Fragment$fragmentPlaylist$filter;

  TRes call({
    Enum$FilterMatch? match,
    int? limit,
    List<Fragment$fragmentPlaylist$filter$conditions>? conditions,
    List<Fragment$fragmentPlaylist$filter$groups>? groups,
    String? $__typename,
  });
  TRes conditions(
    Iterable<Fragment$fragmentPlaylist$filter$conditions> Function(
      Iterable<
        CopyWith$Fragment$fragmentPlaylist$filter$conditions<
          Fragment$fragmentPlaylist$filter$conditions
        >
      >,
    )
    _fn,
  );
  TRes groups(
    Iterable<Fragment$fragmentPlaylist$filter$groups> Function(
      Iterable<
        CopyWith$Fragment$fragmentPlaylist$filter$groups<
          Fragment$fragmentPlaylist$filter$groups
        >
      >,
    )
    _fn,
  );
}

class _CopyWithImpl$Fragment$fragmentPlaylist$filter<TRes>
    implements CopyWith$Fragment$fragmentPlaylist$filter<TRes> {
  _CopyWithImpl$Fragment$fragmentPlaylist$filter(this._instance, this._then);

  final Fragment$fragmentPlaylist$filter _instance;

  final TRes Function(Fragment$fragmentPlaylist$filter) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? match = _undefined,
    Object? limit = _undefined,
    Object? conditions = _undefined,
    Object? groups = _undefined,
    Object? $__typename = _undefined,
  }) => _then(
    Fragment$fragmentPlaylist$filter(
      match: match == _undefined || match == null
          ? _instance.match
          : (match as Enum$FilterMatch),
      limit: limit == _undefined ? _instance.limit : (limit as int?),
      conditions: conditions == _undefined || conditions == null
          ? _instance.conditions
          : (conditions as List<Fragment$fragmentPlaylist$filter$conditions>),
      groups: groups == _undefined || groups == null
          ? _instance.groups
          : (groups as List<Fragment$fragmentPlaylist$filter$groups>),
      $__typename: $__typename == _undefined || $__typename == null
          ? _instance.$__typename
          : ($__typename as String),
    ),
  );

  TRes conditions(
    Iterable<Fragment$fragmentPlaylist$filter$conditions> Function(
      Iterable<
        CopyWith$Fragment$fragmentPlaylist$filter$conditions<
          Fragment$fragmentPlaylist$filter$conditions
        >
      >,
    )
    _fn,
  ) => call(
    conditions: _fn(
      _instance.conditions.map(
        (e) =>
            CopyWith$Fragment$fragmentPlaylist$filter$conditions(e, (i) => i),
      ),
    ).toList(),
  );

  TRes groups(
    Iterable<Fragment$fragmentPlaylist$filter$groups> Function(
      Iterable<
        CopyWith$Fragment$fragmentPlaylist$filter$groups<
          Fragment$fragmentPlaylist$filter$groups
        >
      >,
    )
    _fn,
  ) => call(
    groups: _fn(
      _instance.groups.map(
        (e) => CopyWith$Fragment$fragmentPlaylist$filter$groups(e, (i) => i),
      ),
    ).toList(),
  );
}

class _CopyWithStubImpl$Fragment$fragmentPlaylist$filter<TRes>
    implements CopyWith$Fragment$fragmentPlaylist$filter<TRes> {
  _CopyWithStubImpl$Fragment$fragmentPlaylist$filter(this._res);

  TRes _res;

  call({
    Enum$FilterMatch? match,
    int? limit,
    List<Fragment$fragmentPlaylist$filter$conditions>? conditions,
    List<Fragment$fragmentPlaylist$filter$groups>? groups,
    String? $__typename,
  }) => _res;

  conditions(_fn) => _res;

  groups(_fn) => _res;
}

class Fragment$fragmentPlaylist$filter$conditions {
  Fragment$fragmentPlaylist$filter$conditions({
    required this.field,
    required this.$operator,
    this.value,
    this.$__typename = 'FilterConditionValue',
  });

  factory Fragment$fragmentPlaylist$filter$conditions.fromJson(
    Map<String, dynamic> json,
  ) {
    final l$field = json['field'];
    final l$$operator = json['operator'];
    final l$value = json['value'];
    final l$$__typename = json['__typename'];
    return Fragment$fragmentPlaylist$filter$conditions(
      field: fromJson$Enum$FilterField((l$field as String)),
      $operator: fromJson$Enum$FilterOperator((l$$operator as String)),
      value: (l$value as String?),
      $__typename: (l$$__typename as String),
    );
  }

  final Enum$FilterField field;

  final Enum$FilterOperator $operator;

  final String? value;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$field = field;
    _resultData['field'] = toJson$Enum$FilterField(l$field);
    final l$$operator = $operator;
    _resultData['operator'] = toJson$Enum$FilterOperator(l$$operator);
    final l$value = value;
    _resultData['value'] = l$value;
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$field = field;
    final l$$operator = $operator;
    final l$value = value;
    final l$$__typename = $__typename;
    return Object.hashAll([l$field, l$$operator, l$value, l$$__typename]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Fragment$fragmentPlaylist$filter$conditions ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$field = field;
    final lOther$field = other.field;
    if (l$field != lOther$field) {
      return false;
    }
    final l$$operator = $operator;
    final lOther$$operator = other.$operator;
    if (l$$operator != lOther$$operator) {
      return false;
    }
    final l$value = value;
    final lOther$value = other.value;
    if (l$value != lOther$value) {
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

extension UtilityExtension$Fragment$fragmentPlaylist$filter$conditions
    on Fragment$fragmentPlaylist$filter$conditions {
  CopyWith$Fragment$fragmentPlaylist$filter$conditions<
    Fragment$fragmentPlaylist$filter$conditions
  >
  get copyWith =>
      CopyWith$Fragment$fragmentPlaylist$filter$conditions(this, (i) => i);
}

abstract class CopyWith$Fragment$fragmentPlaylist$filter$conditions<TRes> {
  factory CopyWith$Fragment$fragmentPlaylist$filter$conditions(
    Fragment$fragmentPlaylist$filter$conditions instance,
    TRes Function(Fragment$fragmentPlaylist$filter$conditions) then,
  ) = _CopyWithImpl$Fragment$fragmentPlaylist$filter$conditions;

  factory CopyWith$Fragment$fragmentPlaylist$filter$conditions.stub(TRes res) =
      _CopyWithStubImpl$Fragment$fragmentPlaylist$filter$conditions;

  TRes call({
    Enum$FilterField? field,
    Enum$FilterOperator? $operator,
    String? value,
    String? $__typename,
  });
}

class _CopyWithImpl$Fragment$fragmentPlaylist$filter$conditions<TRes>
    implements CopyWith$Fragment$fragmentPlaylist$filter$conditions<TRes> {
  _CopyWithImpl$Fragment$fragmentPlaylist$filter$conditions(
    this._instance,
    this._then,
  );

  final Fragment$fragmentPlaylist$filter$conditions _instance;

  final TRes Function(Fragment$fragmentPlaylist$filter$conditions) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? field = _undefined,
    Object? $operator = _undefined,
    Object? value = _undefined,
    Object? $__typename = _undefined,
  }) => _then(
    Fragment$fragmentPlaylist$filter$conditions(
      field: field == _undefined || field == null
          ? _instance.field
          : (field as Enum$FilterField),
      $operator: $operator == _undefined || $operator == null
          ? _instance.$operator
          : ($operator as Enum$FilterOperator),
      value: value == _undefined ? _instance.value : (value as String?),
      $__typename: $__typename == _undefined || $__typename == null
          ? _instance.$__typename
          : ($__typename as String),
    ),
  );
}

class _CopyWithStubImpl$Fragment$fragmentPlaylist$filter$conditions<TRes>
    implements CopyWith$Fragment$fragmentPlaylist$filter$conditions<TRes> {
  _CopyWithStubImpl$Fragment$fragmentPlaylist$filter$conditions(this._res);

  TRes _res;

  call({
    Enum$FilterField? field,
    Enum$FilterOperator? $operator,
    String? value,
    String? $__typename,
  }) => _res;
}

class Fragment$fragmentPlaylist$filter$groups {
  Fragment$fragmentPlaylist$filter$groups({
    required this.match,
    required this.conditions,
    required this.groups,
    this.$__typename = 'FilterGroup',
  });

  factory Fragment$fragmentPlaylist$filter$groups.fromJson(
    Map<String, dynamic> json,
  ) {
    final l$match = json['match'];
    final l$conditions = json['conditions'];
    final l$groups = json['groups'];
    final l$$__typename = json['__typename'];
    return Fragment$fragmentPlaylist$filter$groups(
      match: fromJson$Enum$FilterMatch((l$match as String)),
      conditions: (l$conditions as List<dynamic>)
          .map(
            (e) => Fragment$fragmentPlaylist$filter$groups$conditions.fromJson(
              (e as Map<String, dynamic>),
            ),
          )
          .toList(),
      groups: (l$groups as List<dynamic>)
          .map(
            (e) => Fragment$fragmentPlaylist$filter$groups$groups.fromJson(
              (e as Map<String, dynamic>),
            ),
          )
          .toList(),
      $__typename: (l$$__typename as String),
    );
  }

  final Enum$FilterMatch match;

  final List<Fragment$fragmentPlaylist$filter$groups$conditions> conditions;

  final List<Fragment$fragmentPlaylist$filter$groups$groups> groups;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$match = match;
    _resultData['match'] = toJson$Enum$FilterMatch(l$match);
    final l$conditions = conditions;
    _resultData['conditions'] = l$conditions.map((e) => e.toJson()).toList();
    final l$groups = groups;
    _resultData['groups'] = l$groups.map((e) => e.toJson()).toList();
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$match = match;
    final l$conditions = conditions;
    final l$groups = groups;
    final l$$__typename = $__typename;
    return Object.hashAll([
      l$match,
      Object.hashAll(l$conditions.map((v) => v)),
      Object.hashAll(l$groups.map((v) => v)),
      l$$__typename,
    ]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Fragment$fragmentPlaylist$filter$groups ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$match = match;
    final lOther$match = other.match;
    if (l$match != lOther$match) {
      return false;
    }
    final l$conditions = conditions;
    final lOther$conditions = other.conditions;
    if (l$conditions.length != lOther$conditions.length) {
      return false;
    }
    for (int i = 0; i < l$conditions.length; i++) {
      final l$conditions$entry = l$conditions[i];
      final lOther$conditions$entry = lOther$conditions[i];
      if (l$conditions$entry != lOther$conditions$entry) {
        return false;
      }
    }
    final l$groups = groups;
    final lOther$groups = other.groups;
    if (l$groups.length != lOther$groups.length) {
      return false;
    }
    for (int i = 0; i < l$groups.length; i++) {
      final l$groups$entry = l$groups[i];
      final lOther$groups$entry = lOther$groups[i];
      if (l$groups$entry != lOther$groups$entry) {
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

extension UtilityExtension$Fragment$fragmentPlaylist$filter$groups
    on Fragment$fragmentPlaylist$filter$groups {
  CopyWith$Fragment$fragmentPlaylist$filter$groups<
    Fragment$fragmentPlaylist$filter$groups
  >
  get copyWith =>
      CopyWith$Fragment$fragmentPlaylist$filter$groups(this, (i) => i);
}

abstract class CopyWith$Fragment$fragmentPlaylist$filter$groups<TRes> {
  factory CopyWith$Fragment$fragmentPlaylist$filter$groups(
    Fragment$fragmentPlaylist$filter$groups instance,
    TRes Function(Fragment$fragmentPlaylist$filter$groups) then,
  ) = _CopyWithImpl$Fragment$fragmentPlaylist$filter$groups;

  factory CopyWith$Fragment$fragmentPlaylist$filter$groups.stub(TRes res) =
      _CopyWithStubImpl$Fragment$fragmentPlaylist$filter$groups;

  TRes call({
    Enum$FilterMatch? match,
    List<Fragment$fragmentPlaylist$filter$groups$conditions>? conditions,
    List<Fragment$fragmentPlaylist$filter$groups$groups>? groups,
    String? $__typename,
  });
  TRes conditions(
    Iterable<Fragment$fragmentPlaylist$filter$groups$conditions> Function(
      Iterable<
        CopyWith$Fragment$fragmentPlaylist$filter$groups$conditions<
          Fragment$fragmentPlaylist$filter$groups$conditions
        >
      >,
    )
    _fn,
  );
  TRes groups(
    Iterable<Fragment$fragmentPlaylist$filter$groups$groups> Function(
      Iterable<
        CopyWith$Fragment$fragmentPlaylist$filter$groups$groups<
          Fragment$fragmentPlaylist$filter$groups$groups
        >
      >,
    )
    _fn,
  );
}

class _CopyWithImpl$Fragment$fragmentPlaylist$filter$groups<TRes>
    implements CopyWith$Fragment$fragmentPlaylist$filter$groups<TRes> {
  _CopyWithImpl$Fragment$fragmentPlaylist$filter$groups(
    this._instance,
    this._then,
  );

  final Fragment$fragmentPlaylist$filter$groups _instance;

  final TRes Function(Fragment$fragmentPlaylist$filter$groups) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? match = _undefined,
    Object? conditions = _undefined,
    Object? groups = _undefined,
    Object? $__typename = _undefined,
  }) => _then(
    Fragment$fragmentPlaylist$filter$groups(
      match: match == _undefined || match == null
          ? _instance.match
          : (match as Enum$FilterMatch),
      conditions: conditions == _undefined || conditions == null
          ? _instance.conditions
          : (conditions
                as List<Fragment$fragmentPlaylist$filter$groups$conditions>),
      groups: groups == _undefined || groups == null
          ? _instance.groups
          : (groups as List<Fragment$fragmentPlaylist$filter$groups$groups>),
      $__typename: $__typename == _undefined || $__typename == null
          ? _instance.$__typename
          : ($__typename as String),
    ),
  );

  TRes conditions(
    Iterable<Fragment$fragmentPlaylist$filter$groups$conditions> Function(
      Iterable<
        CopyWith$Fragment$fragmentPlaylist$filter$groups$conditions<
          Fragment$fragmentPlaylist$filter$groups$conditions
        >
      >,
    )
    _fn,
  ) => call(
    conditions: _fn(
      _instance.conditions.map(
        (e) => CopyWith$Fragment$fragmentPlaylist$filter$groups$conditions(
          e,
          (i) => i,
        ),
      ),
    ).toList(),
  );

  TRes groups(
    Iterable<Fragment$fragmentPlaylist$filter$groups$groups> Function(
      Iterable<
        CopyWith$Fragment$fragmentPlaylist$filter$groups$groups<
          Fragment$fragmentPlaylist$filter$groups$groups
        >
      >,
    )
    _fn,
  ) => call(
    groups: _fn(
      _instance.groups.map(
        (e) => CopyWith$Fragment$fragmentPlaylist$filter$groups$groups(
          e,
          (i) => i,
        ),
      ),
    ).toList(),
  );
}

class _CopyWithStubImpl$Fragment$fragmentPlaylist$filter$groups<TRes>
    implements CopyWith$Fragment$fragmentPlaylist$filter$groups<TRes> {
  _CopyWithStubImpl$Fragment$fragmentPlaylist$filter$groups(this._res);

  TRes _res;

  call({
    Enum$FilterMatch? match,
    List<Fragment$fragmentPlaylist$filter$groups$conditions>? conditions,
    List<Fragment$fragmentPlaylist$filter$groups$groups>? groups,
    String? $__typename,
  }) => _res;

  conditions(_fn) => _res;

  groups(_fn) => _res;
}

class Fragment$fragmentPlaylist$filter$groups$conditions {
  Fragment$fragmentPlaylist$filter$groups$conditions({
    required this.field,
    required this.$operator,
    this.value,
    this.$__typename = 'FilterConditionValue',
  });

  factory Fragment$fragmentPlaylist$filter$groups$conditions.fromJson(
    Map<String, dynamic> json,
  ) {
    final l$field = json['field'];
    final l$$operator = json['operator'];
    final l$value = json['value'];
    final l$$__typename = json['__typename'];
    return Fragment$fragmentPlaylist$filter$groups$conditions(
      field: fromJson$Enum$FilterField((l$field as String)),
      $operator: fromJson$Enum$FilterOperator((l$$operator as String)),
      value: (l$value as String?),
      $__typename: (l$$__typename as String),
    );
  }

  final Enum$FilterField field;

  final Enum$FilterOperator $operator;

  final String? value;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$field = field;
    _resultData['field'] = toJson$Enum$FilterField(l$field);
    final l$$operator = $operator;
    _resultData['operator'] = toJson$Enum$FilterOperator(l$$operator);
    final l$value = value;
    _resultData['value'] = l$value;
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$field = field;
    final l$$operator = $operator;
    final l$value = value;
    final l$$__typename = $__typename;
    return Object.hashAll([l$field, l$$operator, l$value, l$$__typename]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Fragment$fragmentPlaylist$filter$groups$conditions ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$field = field;
    final lOther$field = other.field;
    if (l$field != lOther$field) {
      return false;
    }
    final l$$operator = $operator;
    final lOther$$operator = other.$operator;
    if (l$$operator != lOther$$operator) {
      return false;
    }
    final l$value = value;
    final lOther$value = other.value;
    if (l$value != lOther$value) {
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

extension UtilityExtension$Fragment$fragmentPlaylist$filter$groups$conditions
    on Fragment$fragmentPlaylist$filter$groups$conditions {
  CopyWith$Fragment$fragmentPlaylist$filter$groups$conditions<
    Fragment$fragmentPlaylist$filter$groups$conditions
  >
  get copyWith => CopyWith$Fragment$fragmentPlaylist$filter$groups$conditions(
    this,
    (i) => i,
  );
}

abstract class CopyWith$Fragment$fragmentPlaylist$filter$groups$conditions<
  TRes
> {
  factory CopyWith$Fragment$fragmentPlaylist$filter$groups$conditions(
    Fragment$fragmentPlaylist$filter$groups$conditions instance,
    TRes Function(Fragment$fragmentPlaylist$filter$groups$conditions) then,
  ) = _CopyWithImpl$Fragment$fragmentPlaylist$filter$groups$conditions;

  factory CopyWith$Fragment$fragmentPlaylist$filter$groups$conditions.stub(
    TRes res,
  ) = _CopyWithStubImpl$Fragment$fragmentPlaylist$filter$groups$conditions;

  TRes call({
    Enum$FilterField? field,
    Enum$FilterOperator? $operator,
    String? value,
    String? $__typename,
  });
}

class _CopyWithImpl$Fragment$fragmentPlaylist$filter$groups$conditions<TRes>
    implements
        CopyWith$Fragment$fragmentPlaylist$filter$groups$conditions<TRes> {
  _CopyWithImpl$Fragment$fragmentPlaylist$filter$groups$conditions(
    this._instance,
    this._then,
  );

  final Fragment$fragmentPlaylist$filter$groups$conditions _instance;

  final TRes Function(Fragment$fragmentPlaylist$filter$groups$conditions) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? field = _undefined,
    Object? $operator = _undefined,
    Object? value = _undefined,
    Object? $__typename = _undefined,
  }) => _then(
    Fragment$fragmentPlaylist$filter$groups$conditions(
      field: field == _undefined || field == null
          ? _instance.field
          : (field as Enum$FilterField),
      $operator: $operator == _undefined || $operator == null
          ? _instance.$operator
          : ($operator as Enum$FilterOperator),
      value: value == _undefined ? _instance.value : (value as String?),
      $__typename: $__typename == _undefined || $__typename == null
          ? _instance.$__typename
          : ($__typename as String),
    ),
  );
}

class _CopyWithStubImpl$Fragment$fragmentPlaylist$filter$groups$conditions<TRes>
    implements
        CopyWith$Fragment$fragmentPlaylist$filter$groups$conditions<TRes> {
  _CopyWithStubImpl$Fragment$fragmentPlaylist$filter$groups$conditions(
    this._res,
  );

  TRes _res;

  call({
    Enum$FilterField? field,
    Enum$FilterOperator? $operator,
    String? value,
    String? $__typename,
  }) => _res;
}

class Fragment$fragmentPlaylist$filter$groups$groups {
  Fragment$fragmentPlaylist$filter$groups$groups({
    required this.match,
    required this.conditions,
    this.$__typename = 'FilterGroup',
  });

  factory Fragment$fragmentPlaylist$filter$groups$groups.fromJson(
    Map<String, dynamic> json,
  ) {
    final l$match = json['match'];
    final l$conditions = json['conditions'];
    final l$$__typename = json['__typename'];
    return Fragment$fragmentPlaylist$filter$groups$groups(
      match: fromJson$Enum$FilterMatch((l$match as String)),
      conditions: (l$conditions as List<dynamic>)
          .map(
            (e) =>
                Fragment$fragmentPlaylist$filter$groups$groups$conditions.fromJson(
                  (e as Map<String, dynamic>),
                ),
          )
          .toList(),
      $__typename: (l$$__typename as String),
    );
  }

  final Enum$FilterMatch match;

  final List<Fragment$fragmentPlaylist$filter$groups$groups$conditions>
  conditions;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$match = match;
    _resultData['match'] = toJson$Enum$FilterMatch(l$match);
    final l$conditions = conditions;
    _resultData['conditions'] = l$conditions.map((e) => e.toJson()).toList();
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$match = match;
    final l$conditions = conditions;
    final l$$__typename = $__typename;
    return Object.hashAll([
      l$match,
      Object.hashAll(l$conditions.map((v) => v)),
      l$$__typename,
    ]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Fragment$fragmentPlaylist$filter$groups$groups ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$match = match;
    final lOther$match = other.match;
    if (l$match != lOther$match) {
      return false;
    }
    final l$conditions = conditions;
    final lOther$conditions = other.conditions;
    if (l$conditions.length != lOther$conditions.length) {
      return false;
    }
    for (int i = 0; i < l$conditions.length; i++) {
      final l$conditions$entry = l$conditions[i];
      final lOther$conditions$entry = lOther$conditions[i];
      if (l$conditions$entry != lOther$conditions$entry) {
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

extension UtilityExtension$Fragment$fragmentPlaylist$filter$groups$groups
    on Fragment$fragmentPlaylist$filter$groups$groups {
  CopyWith$Fragment$fragmentPlaylist$filter$groups$groups<
    Fragment$fragmentPlaylist$filter$groups$groups
  >
  get copyWith =>
      CopyWith$Fragment$fragmentPlaylist$filter$groups$groups(this, (i) => i);
}

abstract class CopyWith$Fragment$fragmentPlaylist$filter$groups$groups<TRes> {
  factory CopyWith$Fragment$fragmentPlaylist$filter$groups$groups(
    Fragment$fragmentPlaylist$filter$groups$groups instance,
    TRes Function(Fragment$fragmentPlaylist$filter$groups$groups) then,
  ) = _CopyWithImpl$Fragment$fragmentPlaylist$filter$groups$groups;

  factory CopyWith$Fragment$fragmentPlaylist$filter$groups$groups.stub(
    TRes res,
  ) = _CopyWithStubImpl$Fragment$fragmentPlaylist$filter$groups$groups;

  TRes call({
    Enum$FilterMatch? match,
    List<Fragment$fragmentPlaylist$filter$groups$groups$conditions>? conditions,
    String? $__typename,
  });
  TRes conditions(
    Iterable<Fragment$fragmentPlaylist$filter$groups$groups$conditions>
    Function(
      Iterable<
        CopyWith$Fragment$fragmentPlaylist$filter$groups$groups$conditions<
          Fragment$fragmentPlaylist$filter$groups$groups$conditions
        >
      >,
    )
    _fn,
  );
}

class _CopyWithImpl$Fragment$fragmentPlaylist$filter$groups$groups<TRes>
    implements CopyWith$Fragment$fragmentPlaylist$filter$groups$groups<TRes> {
  _CopyWithImpl$Fragment$fragmentPlaylist$filter$groups$groups(
    this._instance,
    this._then,
  );

  final Fragment$fragmentPlaylist$filter$groups$groups _instance;

  final TRes Function(Fragment$fragmentPlaylist$filter$groups$groups) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? match = _undefined,
    Object? conditions = _undefined,
    Object? $__typename = _undefined,
  }) => _then(
    Fragment$fragmentPlaylist$filter$groups$groups(
      match: match == _undefined || match == null
          ? _instance.match
          : (match as Enum$FilterMatch),
      conditions: conditions == _undefined || conditions == null
          ? _instance.conditions
          : (conditions
                as List<
                  Fragment$fragmentPlaylist$filter$groups$groups$conditions
                >),
      $__typename: $__typename == _undefined || $__typename == null
          ? _instance.$__typename
          : ($__typename as String),
    ),
  );

  TRes conditions(
    Iterable<Fragment$fragmentPlaylist$filter$groups$groups$conditions>
    Function(
      Iterable<
        CopyWith$Fragment$fragmentPlaylist$filter$groups$groups$conditions<
          Fragment$fragmentPlaylist$filter$groups$groups$conditions
        >
      >,
    )
    _fn,
  ) => call(
    conditions: _fn(
      _instance.conditions.map(
        (e) =>
            CopyWith$Fragment$fragmentPlaylist$filter$groups$groups$conditions(
              e,
              (i) => i,
            ),
      ),
    ).toList(),
  );
}

class _CopyWithStubImpl$Fragment$fragmentPlaylist$filter$groups$groups<TRes>
    implements CopyWith$Fragment$fragmentPlaylist$filter$groups$groups<TRes> {
  _CopyWithStubImpl$Fragment$fragmentPlaylist$filter$groups$groups(this._res);

  TRes _res;

  call({
    Enum$FilterMatch? match,
    List<Fragment$fragmentPlaylist$filter$groups$groups$conditions>? conditions,
    String? $__typename,
  }) => _res;

  conditions(_fn) => _res;
}

class Fragment$fragmentPlaylist$filter$groups$groups$conditions {
  Fragment$fragmentPlaylist$filter$groups$groups$conditions({
    required this.field,
    required this.$operator,
    this.value,
    this.$__typename = 'FilterConditionValue',
  });

  factory Fragment$fragmentPlaylist$filter$groups$groups$conditions.fromJson(
    Map<String, dynamic> json,
  ) {
    final l$field = json['field'];
    final l$$operator = json['operator'];
    final l$value = json['value'];
    final l$$__typename = json['__typename'];
    return Fragment$fragmentPlaylist$filter$groups$groups$conditions(
      field: fromJson$Enum$FilterField((l$field as String)),
      $operator: fromJson$Enum$FilterOperator((l$$operator as String)),
      value: (l$value as String?),
      $__typename: (l$$__typename as String),
    );
  }

  final Enum$FilterField field;

  final Enum$FilterOperator $operator;

  final String? value;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$field = field;
    _resultData['field'] = toJson$Enum$FilterField(l$field);
    final l$$operator = $operator;
    _resultData['operator'] = toJson$Enum$FilterOperator(l$$operator);
    final l$value = value;
    _resultData['value'] = l$value;
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$field = field;
    final l$$operator = $operator;
    final l$value = value;
    final l$$__typename = $__typename;
    return Object.hashAll([l$field, l$$operator, l$value, l$$__typename]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Fragment$fragmentPlaylist$filter$groups$groups$conditions ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$field = field;
    final lOther$field = other.field;
    if (l$field != lOther$field) {
      return false;
    }
    final l$$operator = $operator;
    final lOther$$operator = other.$operator;
    if (l$$operator != lOther$$operator) {
      return false;
    }
    final l$value = value;
    final lOther$value = other.value;
    if (l$value != lOther$value) {
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

extension UtilityExtension$Fragment$fragmentPlaylist$filter$groups$groups$conditions
    on Fragment$fragmentPlaylist$filter$groups$groups$conditions {
  CopyWith$Fragment$fragmentPlaylist$filter$groups$groups$conditions<
    Fragment$fragmentPlaylist$filter$groups$groups$conditions
  >
  get copyWith =>
      CopyWith$Fragment$fragmentPlaylist$filter$groups$groups$conditions(
        this,
        (i) => i,
      );
}

abstract class CopyWith$Fragment$fragmentPlaylist$filter$groups$groups$conditions<
  TRes
> {
  factory CopyWith$Fragment$fragmentPlaylist$filter$groups$groups$conditions(
    Fragment$fragmentPlaylist$filter$groups$groups$conditions instance,
    TRes Function(Fragment$fragmentPlaylist$filter$groups$groups$conditions)
    then,
  ) = _CopyWithImpl$Fragment$fragmentPlaylist$filter$groups$groups$conditions;

  factory CopyWith$Fragment$fragmentPlaylist$filter$groups$groups$conditions.stub(
    TRes res,
  ) = _CopyWithStubImpl$Fragment$fragmentPlaylist$filter$groups$groups$conditions;

  TRes call({
    Enum$FilterField? field,
    Enum$FilterOperator? $operator,
    String? value,
    String? $__typename,
  });
}

class _CopyWithImpl$Fragment$fragmentPlaylist$filter$groups$groups$conditions<
  TRes
>
    implements
        CopyWith$Fragment$fragmentPlaylist$filter$groups$groups$conditions<
          TRes
        > {
  _CopyWithImpl$Fragment$fragmentPlaylist$filter$groups$groups$conditions(
    this._instance,
    this._then,
  );

  final Fragment$fragmentPlaylist$filter$groups$groups$conditions _instance;

  final TRes Function(Fragment$fragmentPlaylist$filter$groups$groups$conditions)
  _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? field = _undefined,
    Object? $operator = _undefined,
    Object? value = _undefined,
    Object? $__typename = _undefined,
  }) => _then(
    Fragment$fragmentPlaylist$filter$groups$groups$conditions(
      field: field == _undefined || field == null
          ? _instance.field
          : (field as Enum$FilterField),
      $operator: $operator == _undefined || $operator == null
          ? _instance.$operator
          : ($operator as Enum$FilterOperator),
      value: value == _undefined ? _instance.value : (value as String?),
      $__typename: $__typename == _undefined || $__typename == null
          ? _instance.$__typename
          : ($__typename as String),
    ),
  );
}

class _CopyWithStubImpl$Fragment$fragmentPlaylist$filter$groups$groups$conditions<
  TRes
>
    implements
        CopyWith$Fragment$fragmentPlaylist$filter$groups$groups$conditions<
          TRes
        > {
  _CopyWithStubImpl$Fragment$fragmentPlaylist$filter$groups$groups$conditions(
    this._res,
  );

  TRes _res;

  call({
    Enum$FilterField? field,
    Enum$FilterOperator? $operator,
    String? value,
    String? $__typename,
  }) => _res;
}

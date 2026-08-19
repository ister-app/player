import 'package:gql/ast.dart';

import 'schema.graphql.dart';

class Fragment$fragmentSavedView {
  Fragment$fragmentSavedView({
    required this.id,
    required this.name,
    required this.kind,
    this.libraryId,
    this.sorting,
    this.sortingOrder,
    required this.filter,
    this.$__typename = 'SavedView',
  });

  factory Fragment$fragmentSavedView.fromJson(Map<String, dynamic> json) {
    final l$id = json['id'];
    final l$name = json['name'];
    final l$kind = json['kind'];
    final l$libraryId = json['libraryId'];
    final l$sorting = json['sorting'];
    final l$sortingOrder = json['sortingOrder'];
    final l$filter = json['filter'];
    final l$$__typename = json['__typename'];
    return Fragment$fragmentSavedView(
      id: (l$id as String),
      name: (l$name as String),
      kind: fromJson$Enum$FilterKind((l$kind as String)),
      libraryId: (l$libraryId as String?),
      sorting: l$sorting == null
          ? null
          : fromJson$Enum$SortingEnum((l$sorting as String)),
      sortingOrder: l$sortingOrder == null
          ? null
          : fromJson$Enum$SortingOrder((l$sortingOrder as String)),
      filter: Fragment$fragmentSavedView$filter.fromJson(
        (l$filter as Map<String, dynamic>),
      ),
      $__typename: (l$$__typename as String),
    );
  }

  final String id;

  final String name;

  final Enum$FilterKind kind;

  final String? libraryId;

  final Enum$SortingEnum? sorting;

  final Enum$SortingOrder? sortingOrder;

  final Fragment$fragmentSavedView$filter filter;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$id = id;
    _resultData['id'] = l$id;
    final l$name = name;
    _resultData['name'] = l$name;
    final l$kind = kind;
    _resultData['kind'] = toJson$Enum$FilterKind(l$kind);
    final l$libraryId = libraryId;
    _resultData['libraryId'] = l$libraryId;
    final l$sorting = sorting;
    _resultData['sorting'] = l$sorting == null
        ? null
        : toJson$Enum$SortingEnum(l$sorting);
    final l$sortingOrder = sortingOrder;
    _resultData['sortingOrder'] = l$sortingOrder == null
        ? null
        : toJson$Enum$SortingOrder(l$sortingOrder);
    final l$filter = filter;
    _resultData['filter'] = l$filter.toJson();
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$id = id;
    final l$name = name;
    final l$kind = kind;
    final l$libraryId = libraryId;
    final l$sorting = sorting;
    final l$sortingOrder = sortingOrder;
    final l$filter = filter;
    final l$$__typename = $__typename;
    return Object.hashAll([
      l$id,
      l$name,
      l$kind,
      l$libraryId,
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
    if (other is! Fragment$fragmentSavedView ||
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
    final l$kind = kind;
    final lOther$kind = other.kind;
    if (l$kind != lOther$kind) {
      return false;
    }
    final l$libraryId = libraryId;
    final lOther$libraryId = other.libraryId;
    if (l$libraryId != lOther$libraryId) {
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

extension UtilityExtension$Fragment$fragmentSavedView
    on Fragment$fragmentSavedView {
  CopyWith$Fragment$fragmentSavedView<Fragment$fragmentSavedView>
  get copyWith => CopyWith$Fragment$fragmentSavedView(this, (i) => i);
}

abstract class CopyWith$Fragment$fragmentSavedView<TRes> {
  factory CopyWith$Fragment$fragmentSavedView(
    Fragment$fragmentSavedView instance,
    TRes Function(Fragment$fragmentSavedView) then,
  ) = _CopyWithImpl$Fragment$fragmentSavedView;

  factory CopyWith$Fragment$fragmentSavedView.stub(TRes res) =
      _CopyWithStubImpl$Fragment$fragmentSavedView;

  TRes call({
    String? id,
    String? name,
    Enum$FilterKind? kind,
    String? libraryId,
    Enum$SortingEnum? sorting,
    Enum$SortingOrder? sortingOrder,
    Fragment$fragmentSavedView$filter? filter,
    String? $__typename,
  });
  CopyWith$Fragment$fragmentSavedView$filter<TRes> get filter;
}

class _CopyWithImpl$Fragment$fragmentSavedView<TRes>
    implements CopyWith$Fragment$fragmentSavedView<TRes> {
  _CopyWithImpl$Fragment$fragmentSavedView(this._instance, this._then);

  final Fragment$fragmentSavedView _instance;

  final TRes Function(Fragment$fragmentSavedView) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? id = _undefined,
    Object? name = _undefined,
    Object? kind = _undefined,
    Object? libraryId = _undefined,
    Object? sorting = _undefined,
    Object? sortingOrder = _undefined,
    Object? filter = _undefined,
    Object? $__typename = _undefined,
  }) => _then(
    Fragment$fragmentSavedView(
      id: id == _undefined || id == null ? _instance.id : (id as String),
      name: name == _undefined || name == null
          ? _instance.name
          : (name as String),
      kind: kind == _undefined || kind == null
          ? _instance.kind
          : (kind as Enum$FilterKind),
      libraryId: libraryId == _undefined
          ? _instance.libraryId
          : (libraryId as String?),
      sorting: sorting == _undefined
          ? _instance.sorting
          : (sorting as Enum$SortingEnum?),
      sortingOrder: sortingOrder == _undefined
          ? _instance.sortingOrder
          : (sortingOrder as Enum$SortingOrder?),
      filter: filter == _undefined || filter == null
          ? _instance.filter
          : (filter as Fragment$fragmentSavedView$filter),
      $__typename: $__typename == _undefined || $__typename == null
          ? _instance.$__typename
          : ($__typename as String),
    ),
  );

  CopyWith$Fragment$fragmentSavedView$filter<TRes> get filter {
    final local$filter = _instance.filter;
    return CopyWith$Fragment$fragmentSavedView$filter(
      local$filter,
      (e) => call(filter: e),
    );
  }
}

class _CopyWithStubImpl$Fragment$fragmentSavedView<TRes>
    implements CopyWith$Fragment$fragmentSavedView<TRes> {
  _CopyWithStubImpl$Fragment$fragmentSavedView(this._res);

  TRes _res;

  call({
    String? id,
    String? name,
    Enum$FilterKind? kind,
    String? libraryId,
    Enum$SortingEnum? sorting,
    Enum$SortingOrder? sortingOrder,
    Fragment$fragmentSavedView$filter? filter,
    String? $__typename,
  }) => _res;

  CopyWith$Fragment$fragmentSavedView$filter<TRes> get filter =>
      CopyWith$Fragment$fragmentSavedView$filter.stub(_res);
}

const fragmentDefinitionfragmentSavedView = FragmentDefinitionNode(
  name: NameNode(value: 'fragmentSavedView'),
  typeCondition: TypeConditionNode(
    on: NamedTypeNode(name: NameNode(value: 'SavedView'), isNonNull: false),
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
        name: NameNode(value: 'kind'),
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
const documentNodeFragmentfragmentSavedView = DocumentNode(
  definitions: [fragmentDefinitionfragmentSavedView],
);

class Fragment$fragmentSavedView$filter {
  Fragment$fragmentSavedView$filter({
    required this.match,
    this.limit,
    required this.conditions,
    required this.groups,
    this.$__typename = 'FilterGroup',
  });

  factory Fragment$fragmentSavedView$filter.fromJson(
    Map<String, dynamic> json,
  ) {
    final l$match = json['match'];
    final l$limit = json['limit'];
    final l$conditions = json['conditions'];
    final l$groups = json['groups'];
    final l$$__typename = json['__typename'];
    return Fragment$fragmentSavedView$filter(
      match: fromJson$Enum$FilterMatch((l$match as String)),
      limit: (l$limit as int?),
      conditions: (l$conditions as List<dynamic>)
          .map(
            (e) => Fragment$fragmentSavedView$filter$conditions.fromJson(
              (e as Map<String, dynamic>),
            ),
          )
          .toList(),
      groups: (l$groups as List<dynamic>)
          .map(
            (e) => Fragment$fragmentSavedView$filter$groups.fromJson(
              (e as Map<String, dynamic>),
            ),
          )
          .toList(),
      $__typename: (l$$__typename as String),
    );
  }

  final Enum$FilterMatch match;

  final int? limit;

  final List<Fragment$fragmentSavedView$filter$conditions> conditions;

  final List<Fragment$fragmentSavedView$filter$groups> groups;

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
    if (other is! Fragment$fragmentSavedView$filter ||
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

extension UtilityExtension$Fragment$fragmentSavedView$filter
    on Fragment$fragmentSavedView$filter {
  CopyWith$Fragment$fragmentSavedView$filter<Fragment$fragmentSavedView$filter>
  get copyWith => CopyWith$Fragment$fragmentSavedView$filter(this, (i) => i);
}

abstract class CopyWith$Fragment$fragmentSavedView$filter<TRes> {
  factory CopyWith$Fragment$fragmentSavedView$filter(
    Fragment$fragmentSavedView$filter instance,
    TRes Function(Fragment$fragmentSavedView$filter) then,
  ) = _CopyWithImpl$Fragment$fragmentSavedView$filter;

  factory CopyWith$Fragment$fragmentSavedView$filter.stub(TRes res) =
      _CopyWithStubImpl$Fragment$fragmentSavedView$filter;

  TRes call({
    Enum$FilterMatch? match,
    int? limit,
    List<Fragment$fragmentSavedView$filter$conditions>? conditions,
    List<Fragment$fragmentSavedView$filter$groups>? groups,
    String? $__typename,
  });
  TRes conditions(
    Iterable<Fragment$fragmentSavedView$filter$conditions> Function(
      Iterable<
        CopyWith$Fragment$fragmentSavedView$filter$conditions<
          Fragment$fragmentSavedView$filter$conditions
        >
      >,
    )
    _fn,
  );
  TRes groups(
    Iterable<Fragment$fragmentSavedView$filter$groups> Function(
      Iterable<
        CopyWith$Fragment$fragmentSavedView$filter$groups<
          Fragment$fragmentSavedView$filter$groups
        >
      >,
    )
    _fn,
  );
}

class _CopyWithImpl$Fragment$fragmentSavedView$filter<TRes>
    implements CopyWith$Fragment$fragmentSavedView$filter<TRes> {
  _CopyWithImpl$Fragment$fragmentSavedView$filter(this._instance, this._then);

  final Fragment$fragmentSavedView$filter _instance;

  final TRes Function(Fragment$fragmentSavedView$filter) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? match = _undefined,
    Object? limit = _undefined,
    Object? conditions = _undefined,
    Object? groups = _undefined,
    Object? $__typename = _undefined,
  }) => _then(
    Fragment$fragmentSavedView$filter(
      match: match == _undefined || match == null
          ? _instance.match
          : (match as Enum$FilterMatch),
      limit: limit == _undefined ? _instance.limit : (limit as int?),
      conditions: conditions == _undefined || conditions == null
          ? _instance.conditions
          : (conditions as List<Fragment$fragmentSavedView$filter$conditions>),
      groups: groups == _undefined || groups == null
          ? _instance.groups
          : (groups as List<Fragment$fragmentSavedView$filter$groups>),
      $__typename: $__typename == _undefined || $__typename == null
          ? _instance.$__typename
          : ($__typename as String),
    ),
  );

  TRes conditions(
    Iterable<Fragment$fragmentSavedView$filter$conditions> Function(
      Iterable<
        CopyWith$Fragment$fragmentSavedView$filter$conditions<
          Fragment$fragmentSavedView$filter$conditions
        >
      >,
    )
    _fn,
  ) => call(
    conditions: _fn(
      _instance.conditions.map(
        (e) =>
            CopyWith$Fragment$fragmentSavedView$filter$conditions(e, (i) => i),
      ),
    ).toList(),
  );

  TRes groups(
    Iterable<Fragment$fragmentSavedView$filter$groups> Function(
      Iterable<
        CopyWith$Fragment$fragmentSavedView$filter$groups<
          Fragment$fragmentSavedView$filter$groups
        >
      >,
    )
    _fn,
  ) => call(
    groups: _fn(
      _instance.groups.map(
        (e) => CopyWith$Fragment$fragmentSavedView$filter$groups(e, (i) => i),
      ),
    ).toList(),
  );
}

class _CopyWithStubImpl$Fragment$fragmentSavedView$filter<TRes>
    implements CopyWith$Fragment$fragmentSavedView$filter<TRes> {
  _CopyWithStubImpl$Fragment$fragmentSavedView$filter(this._res);

  TRes _res;

  call({
    Enum$FilterMatch? match,
    int? limit,
    List<Fragment$fragmentSavedView$filter$conditions>? conditions,
    List<Fragment$fragmentSavedView$filter$groups>? groups,
    String? $__typename,
  }) => _res;

  conditions(_fn) => _res;

  groups(_fn) => _res;
}

class Fragment$fragmentSavedView$filter$conditions {
  Fragment$fragmentSavedView$filter$conditions({
    required this.field,
    required this.$operator,
    this.value,
    this.$__typename = 'FilterConditionValue',
  });

  factory Fragment$fragmentSavedView$filter$conditions.fromJson(
    Map<String, dynamic> json,
  ) {
    final l$field = json['field'];
    final l$$operator = json['operator'];
    final l$value = json['value'];
    final l$$__typename = json['__typename'];
    return Fragment$fragmentSavedView$filter$conditions(
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
    if (other is! Fragment$fragmentSavedView$filter$conditions ||
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

extension UtilityExtension$Fragment$fragmentSavedView$filter$conditions
    on Fragment$fragmentSavedView$filter$conditions {
  CopyWith$Fragment$fragmentSavedView$filter$conditions<
    Fragment$fragmentSavedView$filter$conditions
  >
  get copyWith =>
      CopyWith$Fragment$fragmentSavedView$filter$conditions(this, (i) => i);
}

abstract class CopyWith$Fragment$fragmentSavedView$filter$conditions<TRes> {
  factory CopyWith$Fragment$fragmentSavedView$filter$conditions(
    Fragment$fragmentSavedView$filter$conditions instance,
    TRes Function(Fragment$fragmentSavedView$filter$conditions) then,
  ) = _CopyWithImpl$Fragment$fragmentSavedView$filter$conditions;

  factory CopyWith$Fragment$fragmentSavedView$filter$conditions.stub(TRes res) =
      _CopyWithStubImpl$Fragment$fragmentSavedView$filter$conditions;

  TRes call({
    Enum$FilterField? field,
    Enum$FilterOperator? $operator,
    String? value,
    String? $__typename,
  });
}

class _CopyWithImpl$Fragment$fragmentSavedView$filter$conditions<TRes>
    implements CopyWith$Fragment$fragmentSavedView$filter$conditions<TRes> {
  _CopyWithImpl$Fragment$fragmentSavedView$filter$conditions(
    this._instance,
    this._then,
  );

  final Fragment$fragmentSavedView$filter$conditions _instance;

  final TRes Function(Fragment$fragmentSavedView$filter$conditions) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? field = _undefined,
    Object? $operator = _undefined,
    Object? value = _undefined,
    Object? $__typename = _undefined,
  }) => _then(
    Fragment$fragmentSavedView$filter$conditions(
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

class _CopyWithStubImpl$Fragment$fragmentSavedView$filter$conditions<TRes>
    implements CopyWith$Fragment$fragmentSavedView$filter$conditions<TRes> {
  _CopyWithStubImpl$Fragment$fragmentSavedView$filter$conditions(this._res);

  TRes _res;

  call({
    Enum$FilterField? field,
    Enum$FilterOperator? $operator,
    String? value,
    String? $__typename,
  }) => _res;
}

class Fragment$fragmentSavedView$filter$groups {
  Fragment$fragmentSavedView$filter$groups({
    required this.match,
    required this.conditions,
    required this.groups,
    this.$__typename = 'FilterGroup',
  });

  factory Fragment$fragmentSavedView$filter$groups.fromJson(
    Map<String, dynamic> json,
  ) {
    final l$match = json['match'];
    final l$conditions = json['conditions'];
    final l$groups = json['groups'];
    final l$$__typename = json['__typename'];
    return Fragment$fragmentSavedView$filter$groups(
      match: fromJson$Enum$FilterMatch((l$match as String)),
      conditions: (l$conditions as List<dynamic>)
          .map(
            (e) => Fragment$fragmentSavedView$filter$groups$conditions.fromJson(
              (e as Map<String, dynamic>),
            ),
          )
          .toList(),
      groups: (l$groups as List<dynamic>)
          .map(
            (e) => Fragment$fragmentSavedView$filter$groups$groups.fromJson(
              (e as Map<String, dynamic>),
            ),
          )
          .toList(),
      $__typename: (l$$__typename as String),
    );
  }

  final Enum$FilterMatch match;

  final List<Fragment$fragmentSavedView$filter$groups$conditions> conditions;

  final List<Fragment$fragmentSavedView$filter$groups$groups> groups;

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
    if (other is! Fragment$fragmentSavedView$filter$groups ||
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

extension UtilityExtension$Fragment$fragmentSavedView$filter$groups
    on Fragment$fragmentSavedView$filter$groups {
  CopyWith$Fragment$fragmentSavedView$filter$groups<
    Fragment$fragmentSavedView$filter$groups
  >
  get copyWith =>
      CopyWith$Fragment$fragmentSavedView$filter$groups(this, (i) => i);
}

abstract class CopyWith$Fragment$fragmentSavedView$filter$groups<TRes> {
  factory CopyWith$Fragment$fragmentSavedView$filter$groups(
    Fragment$fragmentSavedView$filter$groups instance,
    TRes Function(Fragment$fragmentSavedView$filter$groups) then,
  ) = _CopyWithImpl$Fragment$fragmentSavedView$filter$groups;

  factory CopyWith$Fragment$fragmentSavedView$filter$groups.stub(TRes res) =
      _CopyWithStubImpl$Fragment$fragmentSavedView$filter$groups;

  TRes call({
    Enum$FilterMatch? match,
    List<Fragment$fragmentSavedView$filter$groups$conditions>? conditions,
    List<Fragment$fragmentSavedView$filter$groups$groups>? groups,
    String? $__typename,
  });
  TRes conditions(
    Iterable<Fragment$fragmentSavedView$filter$groups$conditions> Function(
      Iterable<
        CopyWith$Fragment$fragmentSavedView$filter$groups$conditions<
          Fragment$fragmentSavedView$filter$groups$conditions
        >
      >,
    )
    _fn,
  );
  TRes groups(
    Iterable<Fragment$fragmentSavedView$filter$groups$groups> Function(
      Iterable<
        CopyWith$Fragment$fragmentSavedView$filter$groups$groups<
          Fragment$fragmentSavedView$filter$groups$groups
        >
      >,
    )
    _fn,
  );
}

class _CopyWithImpl$Fragment$fragmentSavedView$filter$groups<TRes>
    implements CopyWith$Fragment$fragmentSavedView$filter$groups<TRes> {
  _CopyWithImpl$Fragment$fragmentSavedView$filter$groups(
    this._instance,
    this._then,
  );

  final Fragment$fragmentSavedView$filter$groups _instance;

  final TRes Function(Fragment$fragmentSavedView$filter$groups) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? match = _undefined,
    Object? conditions = _undefined,
    Object? groups = _undefined,
    Object? $__typename = _undefined,
  }) => _then(
    Fragment$fragmentSavedView$filter$groups(
      match: match == _undefined || match == null
          ? _instance.match
          : (match as Enum$FilterMatch),
      conditions: conditions == _undefined || conditions == null
          ? _instance.conditions
          : (conditions
                as List<Fragment$fragmentSavedView$filter$groups$conditions>),
      groups: groups == _undefined || groups == null
          ? _instance.groups
          : (groups as List<Fragment$fragmentSavedView$filter$groups$groups>),
      $__typename: $__typename == _undefined || $__typename == null
          ? _instance.$__typename
          : ($__typename as String),
    ),
  );

  TRes conditions(
    Iterable<Fragment$fragmentSavedView$filter$groups$conditions> Function(
      Iterable<
        CopyWith$Fragment$fragmentSavedView$filter$groups$conditions<
          Fragment$fragmentSavedView$filter$groups$conditions
        >
      >,
    )
    _fn,
  ) => call(
    conditions: _fn(
      _instance.conditions.map(
        (e) => CopyWith$Fragment$fragmentSavedView$filter$groups$conditions(
          e,
          (i) => i,
        ),
      ),
    ).toList(),
  );

  TRes groups(
    Iterable<Fragment$fragmentSavedView$filter$groups$groups> Function(
      Iterable<
        CopyWith$Fragment$fragmentSavedView$filter$groups$groups<
          Fragment$fragmentSavedView$filter$groups$groups
        >
      >,
    )
    _fn,
  ) => call(
    groups: _fn(
      _instance.groups.map(
        (e) => CopyWith$Fragment$fragmentSavedView$filter$groups$groups(
          e,
          (i) => i,
        ),
      ),
    ).toList(),
  );
}

class _CopyWithStubImpl$Fragment$fragmentSavedView$filter$groups<TRes>
    implements CopyWith$Fragment$fragmentSavedView$filter$groups<TRes> {
  _CopyWithStubImpl$Fragment$fragmentSavedView$filter$groups(this._res);

  TRes _res;

  call({
    Enum$FilterMatch? match,
    List<Fragment$fragmentSavedView$filter$groups$conditions>? conditions,
    List<Fragment$fragmentSavedView$filter$groups$groups>? groups,
    String? $__typename,
  }) => _res;

  conditions(_fn) => _res;

  groups(_fn) => _res;
}

class Fragment$fragmentSavedView$filter$groups$conditions {
  Fragment$fragmentSavedView$filter$groups$conditions({
    required this.field,
    required this.$operator,
    this.value,
    this.$__typename = 'FilterConditionValue',
  });

  factory Fragment$fragmentSavedView$filter$groups$conditions.fromJson(
    Map<String, dynamic> json,
  ) {
    final l$field = json['field'];
    final l$$operator = json['operator'];
    final l$value = json['value'];
    final l$$__typename = json['__typename'];
    return Fragment$fragmentSavedView$filter$groups$conditions(
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
    if (other is! Fragment$fragmentSavedView$filter$groups$conditions ||
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

extension UtilityExtension$Fragment$fragmentSavedView$filter$groups$conditions
    on Fragment$fragmentSavedView$filter$groups$conditions {
  CopyWith$Fragment$fragmentSavedView$filter$groups$conditions<
    Fragment$fragmentSavedView$filter$groups$conditions
  >
  get copyWith => CopyWith$Fragment$fragmentSavedView$filter$groups$conditions(
    this,
    (i) => i,
  );
}

abstract class CopyWith$Fragment$fragmentSavedView$filter$groups$conditions<
  TRes
> {
  factory CopyWith$Fragment$fragmentSavedView$filter$groups$conditions(
    Fragment$fragmentSavedView$filter$groups$conditions instance,
    TRes Function(Fragment$fragmentSavedView$filter$groups$conditions) then,
  ) = _CopyWithImpl$Fragment$fragmentSavedView$filter$groups$conditions;

  factory CopyWith$Fragment$fragmentSavedView$filter$groups$conditions.stub(
    TRes res,
  ) = _CopyWithStubImpl$Fragment$fragmentSavedView$filter$groups$conditions;

  TRes call({
    Enum$FilterField? field,
    Enum$FilterOperator? $operator,
    String? value,
    String? $__typename,
  });
}

class _CopyWithImpl$Fragment$fragmentSavedView$filter$groups$conditions<TRes>
    implements
        CopyWith$Fragment$fragmentSavedView$filter$groups$conditions<TRes> {
  _CopyWithImpl$Fragment$fragmentSavedView$filter$groups$conditions(
    this._instance,
    this._then,
  );

  final Fragment$fragmentSavedView$filter$groups$conditions _instance;

  final TRes Function(Fragment$fragmentSavedView$filter$groups$conditions)
  _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? field = _undefined,
    Object? $operator = _undefined,
    Object? value = _undefined,
    Object? $__typename = _undefined,
  }) => _then(
    Fragment$fragmentSavedView$filter$groups$conditions(
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

class _CopyWithStubImpl$Fragment$fragmentSavedView$filter$groups$conditions<
  TRes
>
    implements
        CopyWith$Fragment$fragmentSavedView$filter$groups$conditions<TRes> {
  _CopyWithStubImpl$Fragment$fragmentSavedView$filter$groups$conditions(
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

class Fragment$fragmentSavedView$filter$groups$groups {
  Fragment$fragmentSavedView$filter$groups$groups({
    required this.match,
    required this.conditions,
    this.$__typename = 'FilterGroup',
  });

  factory Fragment$fragmentSavedView$filter$groups$groups.fromJson(
    Map<String, dynamic> json,
  ) {
    final l$match = json['match'];
    final l$conditions = json['conditions'];
    final l$$__typename = json['__typename'];
    return Fragment$fragmentSavedView$filter$groups$groups(
      match: fromJson$Enum$FilterMatch((l$match as String)),
      conditions: (l$conditions as List<dynamic>)
          .map(
            (e) =>
                Fragment$fragmentSavedView$filter$groups$groups$conditions.fromJson(
                  (e as Map<String, dynamic>),
                ),
          )
          .toList(),
      $__typename: (l$$__typename as String),
    );
  }

  final Enum$FilterMatch match;

  final List<Fragment$fragmentSavedView$filter$groups$groups$conditions>
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
    if (other is! Fragment$fragmentSavedView$filter$groups$groups ||
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

extension UtilityExtension$Fragment$fragmentSavedView$filter$groups$groups
    on Fragment$fragmentSavedView$filter$groups$groups {
  CopyWith$Fragment$fragmentSavedView$filter$groups$groups<
    Fragment$fragmentSavedView$filter$groups$groups
  >
  get copyWith =>
      CopyWith$Fragment$fragmentSavedView$filter$groups$groups(this, (i) => i);
}

abstract class CopyWith$Fragment$fragmentSavedView$filter$groups$groups<TRes> {
  factory CopyWith$Fragment$fragmentSavedView$filter$groups$groups(
    Fragment$fragmentSavedView$filter$groups$groups instance,
    TRes Function(Fragment$fragmentSavedView$filter$groups$groups) then,
  ) = _CopyWithImpl$Fragment$fragmentSavedView$filter$groups$groups;

  factory CopyWith$Fragment$fragmentSavedView$filter$groups$groups.stub(
    TRes res,
  ) = _CopyWithStubImpl$Fragment$fragmentSavedView$filter$groups$groups;

  TRes call({
    Enum$FilterMatch? match,
    List<Fragment$fragmentSavedView$filter$groups$groups$conditions>?
    conditions,
    String? $__typename,
  });
  TRes conditions(
    Iterable<Fragment$fragmentSavedView$filter$groups$groups$conditions>
    Function(
      Iterable<
        CopyWith$Fragment$fragmentSavedView$filter$groups$groups$conditions<
          Fragment$fragmentSavedView$filter$groups$groups$conditions
        >
      >,
    )
    _fn,
  );
}

class _CopyWithImpl$Fragment$fragmentSavedView$filter$groups$groups<TRes>
    implements CopyWith$Fragment$fragmentSavedView$filter$groups$groups<TRes> {
  _CopyWithImpl$Fragment$fragmentSavedView$filter$groups$groups(
    this._instance,
    this._then,
  );

  final Fragment$fragmentSavedView$filter$groups$groups _instance;

  final TRes Function(Fragment$fragmentSavedView$filter$groups$groups) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? match = _undefined,
    Object? conditions = _undefined,
    Object? $__typename = _undefined,
  }) => _then(
    Fragment$fragmentSavedView$filter$groups$groups(
      match: match == _undefined || match == null
          ? _instance.match
          : (match as Enum$FilterMatch),
      conditions: conditions == _undefined || conditions == null
          ? _instance.conditions
          : (conditions
                as List<
                  Fragment$fragmentSavedView$filter$groups$groups$conditions
                >),
      $__typename: $__typename == _undefined || $__typename == null
          ? _instance.$__typename
          : ($__typename as String),
    ),
  );

  TRes conditions(
    Iterable<Fragment$fragmentSavedView$filter$groups$groups$conditions>
    Function(
      Iterable<
        CopyWith$Fragment$fragmentSavedView$filter$groups$groups$conditions<
          Fragment$fragmentSavedView$filter$groups$groups$conditions
        >
      >,
    )
    _fn,
  ) => call(
    conditions: _fn(
      _instance.conditions.map(
        (e) =>
            CopyWith$Fragment$fragmentSavedView$filter$groups$groups$conditions(
              e,
              (i) => i,
            ),
      ),
    ).toList(),
  );
}

class _CopyWithStubImpl$Fragment$fragmentSavedView$filter$groups$groups<TRes>
    implements CopyWith$Fragment$fragmentSavedView$filter$groups$groups<TRes> {
  _CopyWithStubImpl$Fragment$fragmentSavedView$filter$groups$groups(this._res);

  TRes _res;

  call({
    Enum$FilterMatch? match,
    List<Fragment$fragmentSavedView$filter$groups$groups$conditions>?
    conditions,
    String? $__typename,
  }) => _res;

  conditions(_fn) => _res;
}

class Fragment$fragmentSavedView$filter$groups$groups$conditions {
  Fragment$fragmentSavedView$filter$groups$groups$conditions({
    required this.field,
    required this.$operator,
    this.value,
    this.$__typename = 'FilterConditionValue',
  });

  factory Fragment$fragmentSavedView$filter$groups$groups$conditions.fromJson(
    Map<String, dynamic> json,
  ) {
    final l$field = json['field'];
    final l$$operator = json['operator'];
    final l$value = json['value'];
    final l$$__typename = json['__typename'];
    return Fragment$fragmentSavedView$filter$groups$groups$conditions(
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
    if (other is! Fragment$fragmentSavedView$filter$groups$groups$conditions ||
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

extension UtilityExtension$Fragment$fragmentSavedView$filter$groups$groups$conditions
    on Fragment$fragmentSavedView$filter$groups$groups$conditions {
  CopyWith$Fragment$fragmentSavedView$filter$groups$groups$conditions<
    Fragment$fragmentSavedView$filter$groups$groups$conditions
  >
  get copyWith =>
      CopyWith$Fragment$fragmentSavedView$filter$groups$groups$conditions(
        this,
        (i) => i,
      );
}

abstract class CopyWith$Fragment$fragmentSavedView$filter$groups$groups$conditions<
  TRes
> {
  factory CopyWith$Fragment$fragmentSavedView$filter$groups$groups$conditions(
    Fragment$fragmentSavedView$filter$groups$groups$conditions instance,
    TRes Function(Fragment$fragmentSavedView$filter$groups$groups$conditions)
    then,
  ) = _CopyWithImpl$Fragment$fragmentSavedView$filter$groups$groups$conditions;

  factory CopyWith$Fragment$fragmentSavedView$filter$groups$groups$conditions.stub(
    TRes res,
  ) = _CopyWithStubImpl$Fragment$fragmentSavedView$filter$groups$groups$conditions;

  TRes call({
    Enum$FilterField? field,
    Enum$FilterOperator? $operator,
    String? value,
    String? $__typename,
  });
}

class _CopyWithImpl$Fragment$fragmentSavedView$filter$groups$groups$conditions<
  TRes
>
    implements
        CopyWith$Fragment$fragmentSavedView$filter$groups$groups$conditions<
          TRes
        > {
  _CopyWithImpl$Fragment$fragmentSavedView$filter$groups$groups$conditions(
    this._instance,
    this._then,
  );

  final Fragment$fragmentSavedView$filter$groups$groups$conditions _instance;

  final TRes Function(
    Fragment$fragmentSavedView$filter$groups$groups$conditions,
  )
  _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? field = _undefined,
    Object? $operator = _undefined,
    Object? value = _undefined,
    Object? $__typename = _undefined,
  }) => _then(
    Fragment$fragmentSavedView$filter$groups$groups$conditions(
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

class _CopyWithStubImpl$Fragment$fragmentSavedView$filter$groups$groups$conditions<
  TRes
>
    implements
        CopyWith$Fragment$fragmentSavedView$filter$groups$groups$conditions<
          TRes
        > {
  _CopyWithStubImpl$Fragment$fragmentSavedView$filter$groups$groups$conditions(
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

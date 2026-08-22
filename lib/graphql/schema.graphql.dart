class Input$FilterConditionInput {
  factory Input$FilterConditionInput({
    required Enum$FilterField field,
    required Enum$FilterOperator $operator,
    String? value,
  }) => Input$FilterConditionInput._({
    r'field': field,
    r'operator': $operator,
    if (value != null) r'value': value,
  });

  Input$FilterConditionInput._(this._$data);

  factory Input$FilterConditionInput.fromJson(Map<String, dynamic> data) {
    final result$data = <String, dynamic>{};
    final l$field = data['field'];
    result$data['field'] = fromJson$Enum$FilterField((l$field as String));
    final l$$operator = data['operator'];
    result$data['operator'] = fromJson$Enum$FilterOperator(
      (l$$operator as String),
    );
    if (data.containsKey('value')) {
      final l$value = data['value'];
      result$data['value'] = (l$value as String?);
    }
    return Input$FilterConditionInput._(result$data);
  }

  Map<String, dynamic> _$data;

  Enum$FilterField get field => (_$data['field'] as Enum$FilterField);

  Enum$FilterOperator get $operator =>
      (_$data['operator'] as Enum$FilterOperator);

  String? get value => (_$data['value'] as String?);

  Map<String, dynamic> toJson() {
    final result$data = <String, dynamic>{};
    final l$field = field;
    result$data['field'] = toJson$Enum$FilterField(l$field);
    final l$$operator = $operator;
    result$data['operator'] = toJson$Enum$FilterOperator(l$$operator);
    if (_$data.containsKey('value')) {
      final l$value = value;
      result$data['value'] = l$value;
    }
    return result$data;
  }

  CopyWith$Input$FilterConditionInput<Input$FilterConditionInput>
  get copyWith => CopyWith$Input$FilterConditionInput(this, (i) => i);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Input$FilterConditionInput ||
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
    if (_$data.containsKey('value') != other._$data.containsKey('value')) {
      return false;
    }
    if (l$value != lOther$value) {
      return false;
    }
    return true;
  }

  @override
  int get hashCode {
    final l$field = field;
    final l$$operator = $operator;
    final l$value = value;
    return Object.hashAll([
      l$field,
      l$$operator,
      _$data.containsKey('value') ? l$value : const {},
    ]);
  }
}

abstract class CopyWith$Input$FilterConditionInput<TRes> {
  factory CopyWith$Input$FilterConditionInput(
    Input$FilterConditionInput instance,
    TRes Function(Input$FilterConditionInput) then,
  ) = _CopyWithImpl$Input$FilterConditionInput;

  factory CopyWith$Input$FilterConditionInput.stub(TRes res) =
      _CopyWithStubImpl$Input$FilterConditionInput;

  TRes call({
    Enum$FilterField? field,
    Enum$FilterOperator? $operator,
    String? value,
  });
}

class _CopyWithImpl$Input$FilterConditionInput<TRes>
    implements CopyWith$Input$FilterConditionInput<TRes> {
  _CopyWithImpl$Input$FilterConditionInput(this._instance, this._then);

  final Input$FilterConditionInput _instance;

  final TRes Function(Input$FilterConditionInput) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? field = _undefined,
    Object? $operator = _undefined,
    Object? value = _undefined,
  }) => _then(
    Input$FilterConditionInput._({
      ..._instance._$data,
      if (field != _undefined && field != null)
        'field': (field as Enum$FilterField),
      if ($operator != _undefined && $operator != null)
        'operator': ($operator as Enum$FilterOperator),
      if (value != _undefined) 'value': (value as String?),
    }),
  );
}

class _CopyWithStubImpl$Input$FilterConditionInput<TRes>
    implements CopyWith$Input$FilterConditionInput<TRes> {
  _CopyWithStubImpl$Input$FilterConditionInput(this._res);

  TRes _res;

  call({
    Enum$FilterField? field,
    Enum$FilterOperator? $operator,
    String? value,
  }) => _res;
}

class Input$MediaFilterInput {
  factory Input$MediaFilterInput({
    required Enum$FilterMatch match,
    List<Input$FilterConditionInput>? conditions,
    List<Input$MediaFilterInput>? groups,
    int? limit,
  }) => Input$MediaFilterInput._({
    r'match': match,
    if (conditions != null) r'conditions': conditions,
    if (groups != null) r'groups': groups,
    if (limit != null) r'limit': limit,
  });

  Input$MediaFilterInput._(this._$data);

  factory Input$MediaFilterInput.fromJson(Map<String, dynamic> data) {
    final result$data = <String, dynamic>{};
    final l$match = data['match'];
    result$data['match'] = fromJson$Enum$FilterMatch((l$match as String));
    if (data.containsKey('conditions')) {
      final l$conditions = data['conditions'];
      result$data['conditions'] = (l$conditions as List<dynamic>?)
          ?.map(
            (e) => Input$FilterConditionInput.fromJson(
              (e as Map<String, dynamic>),
            ),
          )
          .toList();
    }
    if (data.containsKey('groups')) {
      final l$groups = data['groups'];
      result$data['groups'] = (l$groups as List<dynamic>?)
          ?.map(
            (e) => Input$MediaFilterInput.fromJson((e as Map<String, dynamic>)),
          )
          .toList();
    }
    if (data.containsKey('limit')) {
      final l$limit = data['limit'];
      result$data['limit'] = (l$limit as int?);
    }
    return Input$MediaFilterInput._(result$data);
  }

  Map<String, dynamic> _$data;

  Enum$FilterMatch get match => (_$data['match'] as Enum$FilterMatch);

  List<Input$FilterConditionInput>? get conditions =>
      (_$data['conditions'] as List<Input$FilterConditionInput>?);

  List<Input$MediaFilterInput>? get groups =>
      (_$data['groups'] as List<Input$MediaFilterInput>?);

  int? get limit => (_$data['limit'] as int?);

  Map<String, dynamic> toJson() {
    final result$data = <String, dynamic>{};
    final l$match = match;
    result$data['match'] = toJson$Enum$FilterMatch(l$match);
    if (_$data.containsKey('conditions')) {
      final l$conditions = conditions;
      result$data['conditions'] = l$conditions?.map((e) => e.toJson()).toList();
    }
    if (_$data.containsKey('groups')) {
      final l$groups = groups;
      result$data['groups'] = l$groups?.map((e) => e.toJson()).toList();
    }
    if (_$data.containsKey('limit')) {
      final l$limit = limit;
      result$data['limit'] = l$limit;
    }
    return result$data;
  }

  CopyWith$Input$MediaFilterInput<Input$MediaFilterInput> get copyWith =>
      CopyWith$Input$MediaFilterInput(this, (i) => i);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Input$MediaFilterInput || runtimeType != other.runtimeType) {
      return false;
    }
    final l$match = match;
    final lOther$match = other.match;
    if (l$match != lOther$match) {
      return false;
    }
    final l$conditions = conditions;
    final lOther$conditions = other.conditions;
    if (_$data.containsKey('conditions') !=
        other._$data.containsKey('conditions')) {
      return false;
    }
    if (l$conditions != null && lOther$conditions != null) {
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
    } else if (l$conditions != lOther$conditions) {
      return false;
    }
    final l$groups = groups;
    final lOther$groups = other.groups;
    if (_$data.containsKey('groups') != other._$data.containsKey('groups')) {
      return false;
    }
    if (l$groups != null && lOther$groups != null) {
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
    } else if (l$groups != lOther$groups) {
      return false;
    }
    final l$limit = limit;
    final lOther$limit = other.limit;
    if (_$data.containsKey('limit') != other._$data.containsKey('limit')) {
      return false;
    }
    if (l$limit != lOther$limit) {
      return false;
    }
    return true;
  }

  @override
  int get hashCode {
    final l$match = match;
    final l$conditions = conditions;
    final l$groups = groups;
    final l$limit = limit;
    return Object.hashAll([
      l$match,
      _$data.containsKey('conditions')
          ? l$conditions == null
                ? null
                : Object.hashAll(l$conditions.map((v) => v))
          : const {},
      _$data.containsKey('groups')
          ? l$groups == null
                ? null
                : Object.hashAll(l$groups.map((v) => v))
          : const {},
      _$data.containsKey('limit') ? l$limit : const {},
    ]);
  }
}

abstract class CopyWith$Input$MediaFilterInput<TRes> {
  factory CopyWith$Input$MediaFilterInput(
    Input$MediaFilterInput instance,
    TRes Function(Input$MediaFilterInput) then,
  ) = _CopyWithImpl$Input$MediaFilterInput;

  factory CopyWith$Input$MediaFilterInput.stub(TRes res) =
      _CopyWithStubImpl$Input$MediaFilterInput;

  TRes call({
    Enum$FilterMatch? match,
    List<Input$FilterConditionInput>? conditions,
    List<Input$MediaFilterInput>? groups,
    int? limit,
  });
  TRes conditions(
    Iterable<Input$FilterConditionInput>? Function(
      Iterable<
        CopyWith$Input$FilterConditionInput<Input$FilterConditionInput>
      >?,
    )
    _fn,
  );
  TRes groups(
    Iterable<Input$MediaFilterInput>? Function(
      Iterable<CopyWith$Input$MediaFilterInput<Input$MediaFilterInput>>?,
    )
    _fn,
  );
}

class _CopyWithImpl$Input$MediaFilterInput<TRes>
    implements CopyWith$Input$MediaFilterInput<TRes> {
  _CopyWithImpl$Input$MediaFilterInput(this._instance, this._then);

  final Input$MediaFilterInput _instance;

  final TRes Function(Input$MediaFilterInput) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? match = _undefined,
    Object? conditions = _undefined,
    Object? groups = _undefined,
    Object? limit = _undefined,
  }) => _then(
    Input$MediaFilterInput._({
      ..._instance._$data,
      if (match != _undefined && match != null)
        'match': (match as Enum$FilterMatch),
      if (conditions != _undefined)
        'conditions': (conditions as List<Input$FilterConditionInput>?),
      if (groups != _undefined)
        'groups': (groups as List<Input$MediaFilterInput>?),
      if (limit != _undefined) 'limit': (limit as int?),
    }),
  );

  TRes conditions(
    Iterable<Input$FilterConditionInput>? Function(
      Iterable<
        CopyWith$Input$FilterConditionInput<Input$FilterConditionInput>
      >?,
    )
    _fn,
  ) => call(
    conditions: _fn(
      _instance.conditions?.map(
        (e) => CopyWith$Input$FilterConditionInput(e, (i) => i),
      ),
    )?.toList(),
  );

  TRes groups(
    Iterable<Input$MediaFilterInput>? Function(
      Iterable<CopyWith$Input$MediaFilterInput<Input$MediaFilterInput>>?,
    )
    _fn,
  ) => call(
    groups: _fn(
      _instance.groups?.map(
        (e) => CopyWith$Input$MediaFilterInput(e, (i) => i),
      ),
    )?.toList(),
  );
}

class _CopyWithStubImpl$Input$MediaFilterInput<TRes>
    implements CopyWith$Input$MediaFilterInput<TRes> {
  _CopyWithStubImpl$Input$MediaFilterInput(this._res);

  TRes _res;

  call({
    Enum$FilterMatch? match,
    List<Input$FilterConditionInput>? conditions,
    List<Input$MediaFilterInput>? groups,
    int? limit,
  }) => _res;

  conditions(_fn) => _res;

  groups(_fn) => _res;
}

class Input$SavedViewInput {
  factory Input$SavedViewInput({
    required String name,
    required Enum$FilterKind kind,
    String? libraryId,
    required Input$MediaFilterInput filter,
    Enum$SortingEnum? sorting,
    Enum$SortingOrder? sortingOrder,
  }) => Input$SavedViewInput._({
    r'name': name,
    r'kind': kind,
    if (libraryId != null) r'libraryId': libraryId,
    r'filter': filter,
    if (sorting != null) r'sorting': sorting,
    if (sortingOrder != null) r'sortingOrder': sortingOrder,
  });

  Input$SavedViewInput._(this._$data);

  factory Input$SavedViewInput.fromJson(Map<String, dynamic> data) {
    final result$data = <String, dynamic>{};
    final l$name = data['name'];
    result$data['name'] = (l$name as String);
    final l$kind = data['kind'];
    result$data['kind'] = fromJson$Enum$FilterKind((l$kind as String));
    if (data.containsKey('libraryId')) {
      final l$libraryId = data['libraryId'];
      result$data['libraryId'] = (l$libraryId as String?);
    }
    final l$filter = data['filter'];
    result$data['filter'] = Input$MediaFilterInput.fromJson(
      (l$filter as Map<String, dynamic>),
    );
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
    return Input$SavedViewInput._(result$data);
  }

  Map<String, dynamic> _$data;

  String get name => (_$data['name'] as String);

  Enum$FilterKind get kind => (_$data['kind'] as Enum$FilterKind);

  String? get libraryId => (_$data['libraryId'] as String?);

  Input$MediaFilterInput get filter =>
      (_$data['filter'] as Input$MediaFilterInput);

  Enum$SortingEnum? get sorting => (_$data['sorting'] as Enum$SortingEnum?);

  Enum$SortingOrder? get sortingOrder =>
      (_$data['sortingOrder'] as Enum$SortingOrder?);

  Map<String, dynamic> toJson() {
    final result$data = <String, dynamic>{};
    final l$name = name;
    result$data['name'] = l$name;
    final l$kind = kind;
    result$data['kind'] = toJson$Enum$FilterKind(l$kind);
    if (_$data.containsKey('libraryId')) {
      final l$libraryId = libraryId;
      result$data['libraryId'] = l$libraryId;
    }
    final l$filter = filter;
    result$data['filter'] = l$filter.toJson();
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

  CopyWith$Input$SavedViewInput<Input$SavedViewInput> get copyWith =>
      CopyWith$Input$SavedViewInput(this, (i) => i);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Input$SavedViewInput || runtimeType != other.runtimeType) {
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
    if (_$data.containsKey('libraryId') !=
        other._$data.containsKey('libraryId')) {
      return false;
    }
    if (l$libraryId != lOther$libraryId) {
      return false;
    }
    final l$filter = filter;
    final lOther$filter = other.filter;
    if (l$filter != lOther$filter) {
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
    final l$name = name;
    final l$kind = kind;
    final l$libraryId = libraryId;
    final l$filter = filter;
    final l$sorting = sorting;
    final l$sortingOrder = sortingOrder;
    return Object.hashAll([
      l$name,
      l$kind,
      _$data.containsKey('libraryId') ? l$libraryId : const {},
      l$filter,
      _$data.containsKey('sorting') ? l$sorting : const {},
      _$data.containsKey('sortingOrder') ? l$sortingOrder : const {},
    ]);
  }
}

abstract class CopyWith$Input$SavedViewInput<TRes> {
  factory CopyWith$Input$SavedViewInput(
    Input$SavedViewInput instance,
    TRes Function(Input$SavedViewInput) then,
  ) = _CopyWithImpl$Input$SavedViewInput;

  factory CopyWith$Input$SavedViewInput.stub(TRes res) =
      _CopyWithStubImpl$Input$SavedViewInput;

  TRes call({
    String? name,
    Enum$FilterKind? kind,
    String? libraryId,
    Input$MediaFilterInput? filter,
    Enum$SortingEnum? sorting,
    Enum$SortingOrder? sortingOrder,
  });
  CopyWith$Input$MediaFilterInput<TRes> get filter;
}

class _CopyWithImpl$Input$SavedViewInput<TRes>
    implements CopyWith$Input$SavedViewInput<TRes> {
  _CopyWithImpl$Input$SavedViewInput(this._instance, this._then);

  final Input$SavedViewInput _instance;

  final TRes Function(Input$SavedViewInput) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? name = _undefined,
    Object? kind = _undefined,
    Object? libraryId = _undefined,
    Object? filter = _undefined,
    Object? sorting = _undefined,
    Object? sortingOrder = _undefined,
  }) => _then(
    Input$SavedViewInput._({
      ..._instance._$data,
      if (name != _undefined && name != null) 'name': (name as String),
      if (kind != _undefined && kind != null) 'kind': (kind as Enum$FilterKind),
      if (libraryId != _undefined) 'libraryId': (libraryId as String?),
      if (filter != _undefined && filter != null)
        'filter': (filter as Input$MediaFilterInput),
      if (sorting != _undefined) 'sorting': (sorting as Enum$SortingEnum?),
      if (sortingOrder != _undefined)
        'sortingOrder': (sortingOrder as Enum$SortingOrder?),
    }),
  );

  CopyWith$Input$MediaFilterInput<TRes> get filter {
    final local$filter = _instance.filter;
    return CopyWith$Input$MediaFilterInput(
      local$filter,
      (e) => call(filter: e),
    );
  }
}

class _CopyWithStubImpl$Input$SavedViewInput<TRes>
    implements CopyWith$Input$SavedViewInput<TRes> {
  _CopyWithStubImpl$Input$SavedViewInput(this._res);

  TRes _res;

  call({
    String? name,
    Enum$FilterKind? kind,
    String? libraryId,
    Input$MediaFilterInput? filter,
    Enum$SortingEnum? sorting,
    Enum$SortingOrder? sortingOrder,
  }) => _res;

  CopyWith$Input$MediaFilterInput<TRes> get filter =>
      CopyWith$Input$MediaFilterInput.stub(_res);
}

class Input$PlaylistInput {
  factory Input$PlaylistInput({
    required String name,
    required String libraryId,
    required Enum$PlaylistType type,
    Input$MediaFilterInput? filter,
    Enum$FilterKind? filterKind,
    Enum$SortingEnum? sorting,
    Enum$SortingOrder? sortingOrder,
  }) => Input$PlaylistInput._({
    r'name': name,
    r'libraryId': libraryId,
    r'type': type,
    if (filter != null) r'filter': filter,
    if (filterKind != null) r'filterKind': filterKind,
    if (sorting != null) r'sorting': sorting,
    if (sortingOrder != null) r'sortingOrder': sortingOrder,
  });

  Input$PlaylistInput._(this._$data);

  factory Input$PlaylistInput.fromJson(Map<String, dynamic> data) {
    final result$data = <String, dynamic>{};
    final l$name = data['name'];
    result$data['name'] = (l$name as String);
    final l$libraryId = data['libraryId'];
    result$data['libraryId'] = (l$libraryId as String);
    final l$type = data['type'];
    result$data['type'] = fromJson$Enum$PlaylistType((l$type as String));
    if (data.containsKey('filter')) {
      final l$filter = data['filter'];
      result$data['filter'] = l$filter == null
          ? null
          : Input$MediaFilterInput.fromJson((l$filter as Map<String, dynamic>));
    }
    if (data.containsKey('filterKind')) {
      final l$filterKind = data['filterKind'];
      result$data['filterKind'] = l$filterKind == null
          ? null
          : fromJson$Enum$FilterKind((l$filterKind as String));
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
    return Input$PlaylistInput._(result$data);
  }

  Map<String, dynamic> _$data;

  String get name => (_$data['name'] as String);

  String get libraryId => (_$data['libraryId'] as String);

  Enum$PlaylistType get type => (_$data['type'] as Enum$PlaylistType);

  Input$MediaFilterInput? get filter =>
      (_$data['filter'] as Input$MediaFilterInput?);

  Enum$FilterKind? get filterKind => (_$data['filterKind'] as Enum$FilterKind?);

  Enum$SortingEnum? get sorting => (_$data['sorting'] as Enum$SortingEnum?);

  Enum$SortingOrder? get sortingOrder =>
      (_$data['sortingOrder'] as Enum$SortingOrder?);

  Map<String, dynamic> toJson() {
    final result$data = <String, dynamic>{};
    final l$name = name;
    result$data['name'] = l$name;
    final l$libraryId = libraryId;
    result$data['libraryId'] = l$libraryId;
    final l$type = type;
    result$data['type'] = toJson$Enum$PlaylistType(l$type);
    if (_$data.containsKey('filter')) {
      final l$filter = filter;
      result$data['filter'] = l$filter?.toJson();
    }
    if (_$data.containsKey('filterKind')) {
      final l$filterKind = filterKind;
      result$data['filterKind'] = l$filterKind == null
          ? null
          : toJson$Enum$FilterKind(l$filterKind);
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

  CopyWith$Input$PlaylistInput<Input$PlaylistInput> get copyWith =>
      CopyWith$Input$PlaylistInput(this, (i) => i);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Input$PlaylistInput || runtimeType != other.runtimeType) {
      return false;
    }
    final l$name = name;
    final lOther$name = other.name;
    if (l$name != lOther$name) {
      return false;
    }
    final l$libraryId = libraryId;
    final lOther$libraryId = other.libraryId;
    if (l$libraryId != lOther$libraryId) {
      return false;
    }
    final l$type = type;
    final lOther$type = other.type;
    if (l$type != lOther$type) {
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
    final l$filterKind = filterKind;
    final lOther$filterKind = other.filterKind;
    if (_$data.containsKey('filterKind') !=
        other._$data.containsKey('filterKind')) {
      return false;
    }
    if (l$filterKind != lOther$filterKind) {
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
    final l$name = name;
    final l$libraryId = libraryId;
    final l$type = type;
    final l$filter = filter;
    final l$filterKind = filterKind;
    final l$sorting = sorting;
    final l$sortingOrder = sortingOrder;
    return Object.hashAll([
      l$name,
      l$libraryId,
      l$type,
      _$data.containsKey('filter') ? l$filter : const {},
      _$data.containsKey('filterKind') ? l$filterKind : const {},
      _$data.containsKey('sorting') ? l$sorting : const {},
      _$data.containsKey('sortingOrder') ? l$sortingOrder : const {},
    ]);
  }
}

abstract class CopyWith$Input$PlaylistInput<TRes> {
  factory CopyWith$Input$PlaylistInput(
    Input$PlaylistInput instance,
    TRes Function(Input$PlaylistInput) then,
  ) = _CopyWithImpl$Input$PlaylistInput;

  factory CopyWith$Input$PlaylistInput.stub(TRes res) =
      _CopyWithStubImpl$Input$PlaylistInput;

  TRes call({
    String? name,
    String? libraryId,
    Enum$PlaylistType? type,
    Input$MediaFilterInput? filter,
    Enum$FilterKind? filterKind,
    Enum$SortingEnum? sorting,
    Enum$SortingOrder? sortingOrder,
  });
  CopyWith$Input$MediaFilterInput<TRes> get filter;
}

class _CopyWithImpl$Input$PlaylistInput<TRes>
    implements CopyWith$Input$PlaylistInput<TRes> {
  _CopyWithImpl$Input$PlaylistInput(this._instance, this._then);

  final Input$PlaylistInput _instance;

  final TRes Function(Input$PlaylistInput) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? name = _undefined,
    Object? libraryId = _undefined,
    Object? type = _undefined,
    Object? filter = _undefined,
    Object? filterKind = _undefined,
    Object? sorting = _undefined,
    Object? sortingOrder = _undefined,
  }) => _then(
    Input$PlaylistInput._({
      ..._instance._$data,
      if (name != _undefined && name != null) 'name': (name as String),
      if (libraryId != _undefined && libraryId != null)
        'libraryId': (libraryId as String),
      if (type != _undefined && type != null)
        'type': (type as Enum$PlaylistType),
      if (filter != _undefined) 'filter': (filter as Input$MediaFilterInput?),
      if (filterKind != _undefined)
        'filterKind': (filterKind as Enum$FilterKind?),
      if (sorting != _undefined) 'sorting': (sorting as Enum$SortingEnum?),
      if (sortingOrder != _undefined)
        'sortingOrder': (sortingOrder as Enum$SortingOrder?),
    }),
  );

  CopyWith$Input$MediaFilterInput<TRes> get filter {
    final local$filter = _instance.filter;
    return local$filter == null
        ? CopyWith$Input$MediaFilterInput.stub(_then(_instance))
        : CopyWith$Input$MediaFilterInput(local$filter, (e) => call(filter: e));
  }
}

class _CopyWithStubImpl$Input$PlaylistInput<TRes>
    implements CopyWith$Input$PlaylistInput<TRes> {
  _CopyWithStubImpl$Input$PlaylistInput(this._res);

  TRes _res;

  call({
    String? name,
    String? libraryId,
    Enum$PlaylistType? type,
    Input$MediaFilterInput? filter,
    Enum$FilterKind? filterKind,
    Enum$SortingEnum? sorting,
    Enum$SortingOrder? sortingOrder,
  }) => _res;

  CopyWith$Input$MediaFilterInput<TRes> get filter =>
      CopyWith$Input$MediaFilterInput.stub(_res);
}

class Input$StreamSettingsInput {
  factory Input$StreamSettingsInput({
    required bool direct,
    required bool transcode,
    Enum$SubtitleFormat? subtitleFormat,
  }) => Input$StreamSettingsInput._({
    r'direct': direct,
    r'transcode': transcode,
    if (subtitleFormat != null) r'subtitleFormat': subtitleFormat,
  });

  Input$StreamSettingsInput._(this._$data);

  factory Input$StreamSettingsInput.fromJson(Map<String, dynamic> data) {
    final result$data = <String, dynamic>{};
    final l$direct = data['direct'];
    result$data['direct'] = (l$direct as bool);
    final l$transcode = data['transcode'];
    result$data['transcode'] = (l$transcode as bool);
    if (data.containsKey('subtitleFormat')) {
      final l$subtitleFormat = data['subtitleFormat'];
      result$data['subtitleFormat'] = l$subtitleFormat == null
          ? null
          : fromJson$Enum$SubtitleFormat((l$subtitleFormat as String));
    }
    return Input$StreamSettingsInput._(result$data);
  }

  Map<String, dynamic> _$data;

  bool get direct => (_$data['direct'] as bool);

  bool get transcode => (_$data['transcode'] as bool);

  Enum$SubtitleFormat? get subtitleFormat =>
      (_$data['subtitleFormat'] as Enum$SubtitleFormat?);

  Map<String, dynamic> toJson() {
    final result$data = <String, dynamic>{};
    final l$direct = direct;
    result$data['direct'] = l$direct;
    final l$transcode = transcode;
    result$data['transcode'] = l$transcode;
    if (_$data.containsKey('subtitleFormat')) {
      final l$subtitleFormat = subtitleFormat;
      result$data['subtitleFormat'] = l$subtitleFormat == null
          ? null
          : toJson$Enum$SubtitleFormat(l$subtitleFormat);
    }
    return result$data;
  }

  CopyWith$Input$StreamSettingsInput<Input$StreamSettingsInput> get copyWith =>
      CopyWith$Input$StreamSettingsInput(this, (i) => i);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Input$StreamSettingsInput ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$direct = direct;
    final lOther$direct = other.direct;
    if (l$direct != lOther$direct) {
      return false;
    }
    final l$transcode = transcode;
    final lOther$transcode = other.transcode;
    if (l$transcode != lOther$transcode) {
      return false;
    }
    final l$subtitleFormat = subtitleFormat;
    final lOther$subtitleFormat = other.subtitleFormat;
    if (_$data.containsKey('subtitleFormat') !=
        other._$data.containsKey('subtitleFormat')) {
      return false;
    }
    if (l$subtitleFormat != lOther$subtitleFormat) {
      return false;
    }
    return true;
  }

  @override
  int get hashCode {
    final l$direct = direct;
    final l$transcode = transcode;
    final l$subtitleFormat = subtitleFormat;
    return Object.hashAll([
      l$direct,
      l$transcode,
      _$data.containsKey('subtitleFormat') ? l$subtitleFormat : const {},
    ]);
  }
}

abstract class CopyWith$Input$StreamSettingsInput<TRes> {
  factory CopyWith$Input$StreamSettingsInput(
    Input$StreamSettingsInput instance,
    TRes Function(Input$StreamSettingsInput) then,
  ) = _CopyWithImpl$Input$StreamSettingsInput;

  factory CopyWith$Input$StreamSettingsInput.stub(TRes res) =
      _CopyWithStubImpl$Input$StreamSettingsInput;

  TRes call({
    bool? direct,
    bool? transcode,
    Enum$SubtitleFormat? subtitleFormat,
  });
}

class _CopyWithImpl$Input$StreamSettingsInput<TRes>
    implements CopyWith$Input$StreamSettingsInput<TRes> {
  _CopyWithImpl$Input$StreamSettingsInput(this._instance, this._then);

  final Input$StreamSettingsInput _instance;

  final TRes Function(Input$StreamSettingsInput) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? direct = _undefined,
    Object? transcode = _undefined,
    Object? subtitleFormat = _undefined,
  }) => _then(
    Input$StreamSettingsInput._({
      ..._instance._$data,
      if (direct != _undefined && direct != null) 'direct': (direct as bool),
      if (transcode != _undefined && transcode != null)
        'transcode': (transcode as bool),
      if (subtitleFormat != _undefined)
        'subtitleFormat': (subtitleFormat as Enum$SubtitleFormat?),
    }),
  );
}

class _CopyWithStubImpl$Input$StreamSettingsInput<TRes>
    implements CopyWith$Input$StreamSettingsInput<TRes> {
  _CopyWithStubImpl$Input$StreamSettingsInput(this._res);

  TRes _res;

  call({bool? direct, bool? transcode, Enum$SubtitleFormat? subtitleFormat}) =>
      _res;
}

class Input$UserSettingsInput {
  factory Input$UserSettingsInput({
    required List<String> preferredAudioLanguages,
    required List<String> preferredSubtitleLanguages,
    required bool directPlay,
    required bool transcode,
    int? maxVideoHeight,
    bool? autoSkipIntro,
  }) => Input$UserSettingsInput._({
    r'preferredAudioLanguages': preferredAudioLanguages,
    r'preferredSubtitleLanguages': preferredSubtitleLanguages,
    r'directPlay': directPlay,
    r'transcode': transcode,
    if (maxVideoHeight != null) r'maxVideoHeight': maxVideoHeight,
    if (autoSkipIntro != null) r'autoSkipIntro': autoSkipIntro,
  });

  Input$UserSettingsInput._(this._$data);

  factory Input$UserSettingsInput.fromJson(Map<String, dynamic> data) {
    final result$data = <String, dynamic>{};
    final l$preferredAudioLanguages = data['preferredAudioLanguages'];
    result$data['preferredAudioLanguages'] =
        (l$preferredAudioLanguages as List<dynamic>)
            .map((e) => (e as String))
            .toList();
    final l$preferredSubtitleLanguages = data['preferredSubtitleLanguages'];
    result$data['preferredSubtitleLanguages'] =
        (l$preferredSubtitleLanguages as List<dynamic>)
            .map((e) => (e as String))
            .toList();
    final l$directPlay = data['directPlay'];
    result$data['directPlay'] = (l$directPlay as bool);
    final l$transcode = data['transcode'];
    result$data['transcode'] = (l$transcode as bool);
    if (data.containsKey('maxVideoHeight')) {
      final l$maxVideoHeight = data['maxVideoHeight'];
      result$data['maxVideoHeight'] = (l$maxVideoHeight as int?);
    }
    if (data.containsKey('autoSkipIntro')) {
      final l$autoSkipIntro = data['autoSkipIntro'];
      result$data['autoSkipIntro'] = (l$autoSkipIntro as bool);
    }
    return Input$UserSettingsInput._(result$data);
  }

  Map<String, dynamic> _$data;

  List<String> get preferredAudioLanguages =>
      (_$data['preferredAudioLanguages'] as List<String>);

  List<String> get preferredSubtitleLanguages =>
      (_$data['preferredSubtitleLanguages'] as List<String>);

  bool get directPlay => (_$data['directPlay'] as bool);

  bool get transcode => (_$data['transcode'] as bool);

  int? get maxVideoHeight => (_$data['maxVideoHeight'] as int?);

  bool? get autoSkipIntro => (_$data['autoSkipIntro'] as bool?);

  Map<String, dynamic> toJson() {
    final result$data = <String, dynamic>{};
    final l$preferredAudioLanguages = preferredAudioLanguages;
    result$data['preferredAudioLanguages'] = l$preferredAudioLanguages
        .map((e) => e)
        .toList();
    final l$preferredSubtitleLanguages = preferredSubtitleLanguages;
    result$data['preferredSubtitleLanguages'] = l$preferredSubtitleLanguages
        .map((e) => e)
        .toList();
    final l$directPlay = directPlay;
    result$data['directPlay'] = l$directPlay;
    final l$transcode = transcode;
    result$data['transcode'] = l$transcode;
    if (_$data.containsKey('maxVideoHeight')) {
      final l$maxVideoHeight = maxVideoHeight;
      result$data['maxVideoHeight'] = l$maxVideoHeight;
    }
    if (_$data.containsKey('autoSkipIntro')) {
      final l$autoSkipIntro = autoSkipIntro;
      result$data['autoSkipIntro'] = (l$autoSkipIntro as bool);
    }
    return result$data;
  }

  CopyWith$Input$UserSettingsInput<Input$UserSettingsInput> get copyWith =>
      CopyWith$Input$UserSettingsInput(this, (i) => i);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Input$UserSettingsInput || runtimeType != other.runtimeType) {
      return false;
    }
    final l$preferredAudioLanguages = preferredAudioLanguages;
    final lOther$preferredAudioLanguages = other.preferredAudioLanguages;
    if (l$preferredAudioLanguages.length !=
        lOther$preferredAudioLanguages.length) {
      return false;
    }
    for (int i = 0; i < l$preferredAudioLanguages.length; i++) {
      final l$preferredAudioLanguages$entry = l$preferredAudioLanguages[i];
      final lOther$preferredAudioLanguages$entry =
          lOther$preferredAudioLanguages[i];
      if (l$preferredAudioLanguages$entry !=
          lOther$preferredAudioLanguages$entry) {
        return false;
      }
    }
    final l$preferredSubtitleLanguages = preferredSubtitleLanguages;
    final lOther$preferredSubtitleLanguages = other.preferredSubtitleLanguages;
    if (l$preferredSubtitleLanguages.length !=
        lOther$preferredSubtitleLanguages.length) {
      return false;
    }
    for (int i = 0; i < l$preferredSubtitleLanguages.length; i++) {
      final l$preferredSubtitleLanguages$entry =
          l$preferredSubtitleLanguages[i];
      final lOther$preferredSubtitleLanguages$entry =
          lOther$preferredSubtitleLanguages[i];
      if (l$preferredSubtitleLanguages$entry !=
          lOther$preferredSubtitleLanguages$entry) {
        return false;
      }
    }
    final l$directPlay = directPlay;
    final lOther$directPlay = other.directPlay;
    if (l$directPlay != lOther$directPlay) {
      return false;
    }
    final l$transcode = transcode;
    final lOther$transcode = other.transcode;
    if (l$transcode != lOther$transcode) {
      return false;
    }
    final l$maxVideoHeight = maxVideoHeight;
    final lOther$maxVideoHeight = other.maxVideoHeight;
    if (_$data.containsKey('maxVideoHeight') !=
        other._$data.containsKey('maxVideoHeight')) {
      return false;
    }
    if (l$maxVideoHeight != lOther$maxVideoHeight) {
      return false;
    }
    final l$autoSkipIntro = autoSkipIntro;
    final lOther$autoSkipIntro = other.autoSkipIntro;
    if (_$data.containsKey('autoSkipIntro') !=
        other._$data.containsKey('autoSkipIntro')) {
      return false;
    }
    if (l$autoSkipIntro != lOther$autoSkipIntro) {
      return false;
    }
    return true;
  }

  @override
  int get hashCode {
    final l$preferredAudioLanguages = preferredAudioLanguages;
    final l$preferredSubtitleLanguages = preferredSubtitleLanguages;
    final l$directPlay = directPlay;
    final l$transcode = transcode;
    final l$maxVideoHeight = maxVideoHeight;
    final l$autoSkipIntro = autoSkipIntro;
    return Object.hashAll([
      Object.hashAll(l$preferredAudioLanguages.map((v) => v)),
      Object.hashAll(l$preferredSubtitleLanguages.map((v) => v)),
      l$directPlay,
      l$transcode,
      _$data.containsKey('maxVideoHeight') ? l$maxVideoHeight : const {},
      _$data.containsKey('autoSkipIntro') ? l$autoSkipIntro : const {},
    ]);
  }
}

abstract class CopyWith$Input$UserSettingsInput<TRes> {
  factory CopyWith$Input$UserSettingsInput(
    Input$UserSettingsInput instance,
    TRes Function(Input$UserSettingsInput) then,
  ) = _CopyWithImpl$Input$UserSettingsInput;

  factory CopyWith$Input$UserSettingsInput.stub(TRes res) =
      _CopyWithStubImpl$Input$UserSettingsInput;

  TRes call({
    List<String>? preferredAudioLanguages,
    List<String>? preferredSubtitleLanguages,
    bool? directPlay,
    bool? transcode,
    int? maxVideoHeight,
    bool? autoSkipIntro,
  });
}

class _CopyWithImpl$Input$UserSettingsInput<TRes>
    implements CopyWith$Input$UserSettingsInput<TRes> {
  _CopyWithImpl$Input$UserSettingsInput(this._instance, this._then);

  final Input$UserSettingsInput _instance;

  final TRes Function(Input$UserSettingsInput) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? preferredAudioLanguages = _undefined,
    Object? preferredSubtitleLanguages = _undefined,
    Object? directPlay = _undefined,
    Object? transcode = _undefined,
    Object? maxVideoHeight = _undefined,
    Object? autoSkipIntro = _undefined,
  }) => _then(
    Input$UserSettingsInput._({
      ..._instance._$data,
      if (preferredAudioLanguages != _undefined &&
          preferredAudioLanguages != null)
        'preferredAudioLanguages': (preferredAudioLanguages as List<String>),
      if (preferredSubtitleLanguages != _undefined &&
          preferredSubtitleLanguages != null)
        'preferredSubtitleLanguages':
            (preferredSubtitleLanguages as List<String>),
      if (directPlay != _undefined && directPlay != null)
        'directPlay': (directPlay as bool),
      if (transcode != _undefined && transcode != null)
        'transcode': (transcode as bool),
      if (maxVideoHeight != _undefined)
        'maxVideoHeight': (maxVideoHeight as int?),
      if (autoSkipIntro != _undefined && autoSkipIntro != null)
        'autoSkipIntro': (autoSkipIntro as bool),
    }),
  );
}

class _CopyWithStubImpl$Input$UserSettingsInput<TRes>
    implements CopyWith$Input$UserSettingsInput<TRes> {
  _CopyWithStubImpl$Input$UserSettingsInput(this._res);

  TRes _res;

  call({
    List<String>? preferredAudioLanguages,
    List<String>? preferredSubtitleLanguages,
    bool? directPlay,
    bool? transcode,
    int? maxVideoHeight,
    bool? autoSkipIntro,
  }) => _res;
}

class Input$CreatePlayQueueInput {
  factory Input$CreatePlayQueueInput({
    required Enum$PlayQueueSourceType sourceType,
    String? sourceId,
    String? startId,
    bool? shuffle,
    Enum$RankKind? rankKind,
    Input$MediaFilterInput? filter,
    Enum$FilterKind? filterKind,
    String? libraryId,
    Enum$SortingEnum? sorting,
    Enum$SortingOrder? sortingOrder,
  }) => Input$CreatePlayQueueInput._({
    r'sourceType': sourceType,
    if (sourceId != null) r'sourceId': sourceId,
    if (startId != null) r'startId': startId,
    if (shuffle != null) r'shuffle': shuffle,
    if (rankKind != null) r'rankKind': rankKind,
    if (filter != null) r'filter': filter,
    if (filterKind != null) r'filterKind': filterKind,
    if (libraryId != null) r'libraryId': libraryId,
    if (sorting != null) r'sorting': sorting,
    if (sortingOrder != null) r'sortingOrder': sortingOrder,
  });

  Input$CreatePlayQueueInput._(this._$data);

  factory Input$CreatePlayQueueInput.fromJson(Map<String, dynamic> data) {
    final result$data = <String, dynamic>{};
    final l$sourceType = data['sourceType'];
    result$data['sourceType'] = fromJson$Enum$PlayQueueSourceType(
      (l$sourceType as String),
    );
    if (data.containsKey('sourceId')) {
      final l$sourceId = data['sourceId'];
      result$data['sourceId'] = (l$sourceId as String?);
    }
    if (data.containsKey('startId')) {
      final l$startId = data['startId'];
      result$data['startId'] = (l$startId as String?);
    }
    if (data.containsKey('shuffle')) {
      final l$shuffle = data['shuffle'];
      result$data['shuffle'] = (l$shuffle as bool?);
    }
    if (data.containsKey('rankKind')) {
      final l$rankKind = data['rankKind'];
      result$data['rankKind'] = l$rankKind == null
          ? null
          : fromJson$Enum$RankKind((l$rankKind as String));
    }
    if (data.containsKey('filter')) {
      final l$filter = data['filter'];
      result$data['filter'] = l$filter == null
          ? null
          : Input$MediaFilterInput.fromJson((l$filter as Map<String, dynamic>));
    }
    if (data.containsKey('filterKind')) {
      final l$filterKind = data['filterKind'];
      result$data['filterKind'] = l$filterKind == null
          ? null
          : fromJson$Enum$FilterKind((l$filterKind as String));
    }
    if (data.containsKey('libraryId')) {
      final l$libraryId = data['libraryId'];
      result$data['libraryId'] = (l$libraryId as String?);
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
    return Input$CreatePlayQueueInput._(result$data);
  }

  Map<String, dynamic> _$data;

  Enum$PlayQueueSourceType get sourceType =>
      (_$data['sourceType'] as Enum$PlayQueueSourceType);

  String? get sourceId => (_$data['sourceId'] as String?);

  String? get startId => (_$data['startId'] as String?);

  bool? get shuffle => (_$data['shuffle'] as bool?);

  Enum$RankKind? get rankKind => (_$data['rankKind'] as Enum$RankKind?);

  Input$MediaFilterInput? get filter =>
      (_$data['filter'] as Input$MediaFilterInput?);

  Enum$FilterKind? get filterKind => (_$data['filterKind'] as Enum$FilterKind?);

  String? get libraryId => (_$data['libraryId'] as String?);

  Enum$SortingEnum? get sorting => (_$data['sorting'] as Enum$SortingEnum?);

  Enum$SortingOrder? get sortingOrder =>
      (_$data['sortingOrder'] as Enum$SortingOrder?);

  Map<String, dynamic> toJson() {
    final result$data = <String, dynamic>{};
    final l$sourceType = sourceType;
    result$data['sourceType'] = toJson$Enum$PlayQueueSourceType(l$sourceType);
    if (_$data.containsKey('sourceId')) {
      final l$sourceId = sourceId;
      result$data['sourceId'] = l$sourceId;
    }
    if (_$data.containsKey('startId')) {
      final l$startId = startId;
      result$data['startId'] = l$startId;
    }
    if (_$data.containsKey('shuffle')) {
      final l$shuffle = shuffle;
      result$data['shuffle'] = l$shuffle;
    }
    if (_$data.containsKey('rankKind')) {
      final l$rankKind = rankKind;
      result$data['rankKind'] = l$rankKind == null
          ? null
          : toJson$Enum$RankKind(l$rankKind);
    }
    if (_$data.containsKey('filter')) {
      final l$filter = filter;
      result$data['filter'] = l$filter?.toJson();
    }
    if (_$data.containsKey('filterKind')) {
      final l$filterKind = filterKind;
      result$data['filterKind'] = l$filterKind == null
          ? null
          : toJson$Enum$FilterKind(l$filterKind);
    }
    if (_$data.containsKey('libraryId')) {
      final l$libraryId = libraryId;
      result$data['libraryId'] = l$libraryId;
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

  CopyWith$Input$CreatePlayQueueInput<Input$CreatePlayQueueInput>
  get copyWith => CopyWith$Input$CreatePlayQueueInput(this, (i) => i);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Input$CreatePlayQueueInput ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$sourceType = sourceType;
    final lOther$sourceType = other.sourceType;
    if (l$sourceType != lOther$sourceType) {
      return false;
    }
    final l$sourceId = sourceId;
    final lOther$sourceId = other.sourceId;
    if (_$data.containsKey('sourceId') !=
        other._$data.containsKey('sourceId')) {
      return false;
    }
    if (l$sourceId != lOther$sourceId) {
      return false;
    }
    final l$startId = startId;
    final lOther$startId = other.startId;
    if (_$data.containsKey('startId') != other._$data.containsKey('startId')) {
      return false;
    }
    if (l$startId != lOther$startId) {
      return false;
    }
    final l$shuffle = shuffle;
    final lOther$shuffle = other.shuffle;
    if (_$data.containsKey('shuffle') != other._$data.containsKey('shuffle')) {
      return false;
    }
    if (l$shuffle != lOther$shuffle) {
      return false;
    }
    final l$rankKind = rankKind;
    final lOther$rankKind = other.rankKind;
    if (_$data.containsKey('rankKind') !=
        other._$data.containsKey('rankKind')) {
      return false;
    }
    if (l$rankKind != lOther$rankKind) {
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
    final l$filterKind = filterKind;
    final lOther$filterKind = other.filterKind;
    if (_$data.containsKey('filterKind') !=
        other._$data.containsKey('filterKind')) {
      return false;
    }
    if (l$filterKind != lOther$filterKind) {
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
    final l$sourceType = sourceType;
    final l$sourceId = sourceId;
    final l$startId = startId;
    final l$shuffle = shuffle;
    final l$rankKind = rankKind;
    final l$filter = filter;
    final l$filterKind = filterKind;
    final l$libraryId = libraryId;
    final l$sorting = sorting;
    final l$sortingOrder = sortingOrder;
    return Object.hashAll([
      l$sourceType,
      _$data.containsKey('sourceId') ? l$sourceId : const {},
      _$data.containsKey('startId') ? l$startId : const {},
      _$data.containsKey('shuffle') ? l$shuffle : const {},
      _$data.containsKey('rankKind') ? l$rankKind : const {},
      _$data.containsKey('filter') ? l$filter : const {},
      _$data.containsKey('filterKind') ? l$filterKind : const {},
      _$data.containsKey('libraryId') ? l$libraryId : const {},
      _$data.containsKey('sorting') ? l$sorting : const {},
      _$data.containsKey('sortingOrder') ? l$sortingOrder : const {},
    ]);
  }
}

abstract class CopyWith$Input$CreatePlayQueueInput<TRes> {
  factory CopyWith$Input$CreatePlayQueueInput(
    Input$CreatePlayQueueInput instance,
    TRes Function(Input$CreatePlayQueueInput) then,
  ) = _CopyWithImpl$Input$CreatePlayQueueInput;

  factory CopyWith$Input$CreatePlayQueueInput.stub(TRes res) =
      _CopyWithStubImpl$Input$CreatePlayQueueInput;

  TRes call({
    Enum$PlayQueueSourceType? sourceType,
    String? sourceId,
    String? startId,
    bool? shuffle,
    Enum$RankKind? rankKind,
    Input$MediaFilterInput? filter,
    Enum$FilterKind? filterKind,
    String? libraryId,
    Enum$SortingEnum? sorting,
    Enum$SortingOrder? sortingOrder,
  });
  CopyWith$Input$MediaFilterInput<TRes> get filter;
}

class _CopyWithImpl$Input$CreatePlayQueueInput<TRes>
    implements CopyWith$Input$CreatePlayQueueInput<TRes> {
  _CopyWithImpl$Input$CreatePlayQueueInput(this._instance, this._then);

  final Input$CreatePlayQueueInput _instance;

  final TRes Function(Input$CreatePlayQueueInput) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? sourceType = _undefined,
    Object? sourceId = _undefined,
    Object? startId = _undefined,
    Object? shuffle = _undefined,
    Object? rankKind = _undefined,
    Object? filter = _undefined,
    Object? filterKind = _undefined,
    Object? libraryId = _undefined,
    Object? sorting = _undefined,
    Object? sortingOrder = _undefined,
  }) => _then(
    Input$CreatePlayQueueInput._({
      ..._instance._$data,
      if (sourceType != _undefined && sourceType != null)
        'sourceType': (sourceType as Enum$PlayQueueSourceType),
      if (sourceId != _undefined) 'sourceId': (sourceId as String?),
      if (startId != _undefined) 'startId': (startId as String?),
      if (shuffle != _undefined) 'shuffle': (shuffle as bool?),
      if (rankKind != _undefined) 'rankKind': (rankKind as Enum$RankKind?),
      if (filter != _undefined) 'filter': (filter as Input$MediaFilterInput?),
      if (filterKind != _undefined)
        'filterKind': (filterKind as Enum$FilterKind?),
      if (libraryId != _undefined) 'libraryId': (libraryId as String?),
      if (sorting != _undefined) 'sorting': (sorting as Enum$SortingEnum?),
      if (sortingOrder != _undefined)
        'sortingOrder': (sortingOrder as Enum$SortingOrder?),
    }),
  );

  CopyWith$Input$MediaFilterInput<TRes> get filter {
    final local$filter = _instance.filter;
    return local$filter == null
        ? CopyWith$Input$MediaFilterInput.stub(_then(_instance))
        : CopyWith$Input$MediaFilterInput(local$filter, (e) => call(filter: e));
  }
}

class _CopyWithStubImpl$Input$CreatePlayQueueInput<TRes>
    implements CopyWith$Input$CreatePlayQueueInput<TRes> {
  _CopyWithStubImpl$Input$CreatePlayQueueInput(this._res);

  TRes _res;

  call({
    Enum$PlayQueueSourceType? sourceType,
    String? sourceId,
    String? startId,
    bool? shuffle,
    Enum$RankKind? rankKind,
    Input$MediaFilterInput? filter,
    Enum$FilterKind? filterKind,
    String? libraryId,
    Enum$SortingEnum? sorting,
    Enum$SortingOrder? sortingOrder,
  }) => _res;

  CopyWith$Input$MediaFilterInput<TRes> get filter =>
      CopyWith$Input$MediaFilterInput.stub(_res);
}

class Input$PlaybackSharingSettingsInput {
  factory Input$PlaybackSharingSettingsInput({
    required Enum$SharingScope nowPlayingScope,
    required Enum$RemoteControlScope controlScope,
    required List<String> nowPlayingAllowedUserIds,
    required List<String> controlAllowedUserIds,
  }) => Input$PlaybackSharingSettingsInput._({
    r'nowPlayingScope': nowPlayingScope,
    r'controlScope': controlScope,
    r'nowPlayingAllowedUserIds': nowPlayingAllowedUserIds,
    r'controlAllowedUserIds': controlAllowedUserIds,
  });

  Input$PlaybackSharingSettingsInput._(this._$data);

  factory Input$PlaybackSharingSettingsInput.fromJson(
    Map<String, dynamic> data,
  ) {
    final result$data = <String, dynamic>{};
    final l$nowPlayingScope = data['nowPlayingScope'];
    result$data['nowPlayingScope'] = fromJson$Enum$SharingScope(
      (l$nowPlayingScope as String),
    );
    final l$controlScope = data['controlScope'];
    result$data['controlScope'] = fromJson$Enum$RemoteControlScope(
      (l$controlScope as String),
    );
    final l$nowPlayingAllowedUserIds = data['nowPlayingAllowedUserIds'];
    result$data['nowPlayingAllowedUserIds'] =
        (l$nowPlayingAllowedUserIds as List<dynamic>)
            .map((e) => (e as String))
            .toList();
    final l$controlAllowedUserIds = data['controlAllowedUserIds'];
    result$data['controlAllowedUserIds'] =
        (l$controlAllowedUserIds as List<dynamic>)
            .map((e) => (e as String))
            .toList();
    return Input$PlaybackSharingSettingsInput._(result$data);
  }

  Map<String, dynamic> _$data;

  Enum$SharingScope get nowPlayingScope =>
      (_$data['nowPlayingScope'] as Enum$SharingScope);

  Enum$RemoteControlScope get controlScope =>
      (_$data['controlScope'] as Enum$RemoteControlScope);

  List<String> get nowPlayingAllowedUserIds =>
      (_$data['nowPlayingAllowedUserIds'] as List<String>);

  List<String> get controlAllowedUserIds =>
      (_$data['controlAllowedUserIds'] as List<String>);

  Map<String, dynamic> toJson() {
    final result$data = <String, dynamic>{};
    final l$nowPlayingScope = nowPlayingScope;
    result$data['nowPlayingScope'] = toJson$Enum$SharingScope(
      l$nowPlayingScope,
    );
    final l$controlScope = controlScope;
    result$data['controlScope'] = toJson$Enum$RemoteControlScope(
      l$controlScope,
    );
    final l$nowPlayingAllowedUserIds = nowPlayingAllowedUserIds;
    result$data['nowPlayingAllowedUserIds'] = l$nowPlayingAllowedUserIds
        .map((e) => e)
        .toList();
    final l$controlAllowedUserIds = controlAllowedUserIds;
    result$data['controlAllowedUserIds'] = l$controlAllowedUserIds
        .map((e) => e)
        .toList();
    return result$data;
  }

  CopyWith$Input$PlaybackSharingSettingsInput<
    Input$PlaybackSharingSettingsInput
  >
  get copyWith => CopyWith$Input$PlaybackSharingSettingsInput(this, (i) => i);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Input$PlaybackSharingSettingsInput ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$nowPlayingScope = nowPlayingScope;
    final lOther$nowPlayingScope = other.nowPlayingScope;
    if (l$nowPlayingScope != lOther$nowPlayingScope) {
      return false;
    }
    final l$controlScope = controlScope;
    final lOther$controlScope = other.controlScope;
    if (l$controlScope != lOther$controlScope) {
      return false;
    }
    final l$nowPlayingAllowedUserIds = nowPlayingAllowedUserIds;
    final lOther$nowPlayingAllowedUserIds = other.nowPlayingAllowedUserIds;
    if (l$nowPlayingAllowedUserIds.length !=
        lOther$nowPlayingAllowedUserIds.length) {
      return false;
    }
    for (int i = 0; i < l$nowPlayingAllowedUserIds.length; i++) {
      final l$nowPlayingAllowedUserIds$entry = l$nowPlayingAllowedUserIds[i];
      final lOther$nowPlayingAllowedUserIds$entry =
          lOther$nowPlayingAllowedUserIds[i];
      if (l$nowPlayingAllowedUserIds$entry !=
          lOther$nowPlayingAllowedUserIds$entry) {
        return false;
      }
    }
    final l$controlAllowedUserIds = controlAllowedUserIds;
    final lOther$controlAllowedUserIds = other.controlAllowedUserIds;
    if (l$controlAllowedUserIds.length != lOther$controlAllowedUserIds.length) {
      return false;
    }
    for (int i = 0; i < l$controlAllowedUserIds.length; i++) {
      final l$controlAllowedUserIds$entry = l$controlAllowedUserIds[i];
      final lOther$controlAllowedUserIds$entry =
          lOther$controlAllowedUserIds[i];
      if (l$controlAllowedUserIds$entry != lOther$controlAllowedUserIds$entry) {
        return false;
      }
    }
    return true;
  }

  @override
  int get hashCode {
    final l$nowPlayingScope = nowPlayingScope;
    final l$controlScope = controlScope;
    final l$nowPlayingAllowedUserIds = nowPlayingAllowedUserIds;
    final l$controlAllowedUserIds = controlAllowedUserIds;
    return Object.hashAll([
      l$nowPlayingScope,
      l$controlScope,
      Object.hashAll(l$nowPlayingAllowedUserIds.map((v) => v)),
      Object.hashAll(l$controlAllowedUserIds.map((v) => v)),
    ]);
  }
}

abstract class CopyWith$Input$PlaybackSharingSettingsInput<TRes> {
  factory CopyWith$Input$PlaybackSharingSettingsInput(
    Input$PlaybackSharingSettingsInput instance,
    TRes Function(Input$PlaybackSharingSettingsInput) then,
  ) = _CopyWithImpl$Input$PlaybackSharingSettingsInput;

  factory CopyWith$Input$PlaybackSharingSettingsInput.stub(TRes res) =
      _CopyWithStubImpl$Input$PlaybackSharingSettingsInput;

  TRes call({
    Enum$SharingScope? nowPlayingScope,
    Enum$RemoteControlScope? controlScope,
    List<String>? nowPlayingAllowedUserIds,
    List<String>? controlAllowedUserIds,
  });
}

class _CopyWithImpl$Input$PlaybackSharingSettingsInput<TRes>
    implements CopyWith$Input$PlaybackSharingSettingsInput<TRes> {
  _CopyWithImpl$Input$PlaybackSharingSettingsInput(this._instance, this._then);

  final Input$PlaybackSharingSettingsInput _instance;

  final TRes Function(Input$PlaybackSharingSettingsInput) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? nowPlayingScope = _undefined,
    Object? controlScope = _undefined,
    Object? nowPlayingAllowedUserIds = _undefined,
    Object? controlAllowedUserIds = _undefined,
  }) => _then(
    Input$PlaybackSharingSettingsInput._({
      ..._instance._$data,
      if (nowPlayingScope != _undefined && nowPlayingScope != null)
        'nowPlayingScope': (nowPlayingScope as Enum$SharingScope),
      if (controlScope != _undefined && controlScope != null)
        'controlScope': (controlScope as Enum$RemoteControlScope),
      if (nowPlayingAllowedUserIds != _undefined &&
          nowPlayingAllowedUserIds != null)
        'nowPlayingAllowedUserIds': (nowPlayingAllowedUserIds as List<String>),
      if (controlAllowedUserIds != _undefined && controlAllowedUserIds != null)
        'controlAllowedUserIds': (controlAllowedUserIds as List<String>),
    }),
  );
}

class _CopyWithStubImpl$Input$PlaybackSharingSettingsInput<TRes>
    implements CopyWith$Input$PlaybackSharingSettingsInput<TRes> {
  _CopyWithStubImpl$Input$PlaybackSharingSettingsInput(this._res);

  TRes _res;

  call({
    Enum$SharingScope? nowPlayingScope,
    Enum$RemoteControlScope? controlScope,
    List<String>? nowPlayingAllowedUserIds,
    List<String>? controlAllowedUserIds,
  }) => _res;
}

enum Enum$MetadataSource {
  TMDB,
  MUSICBRAINZ,
  COVER_ART_ARCHIVE,
  WIKIMEDIA_COMMONS,
  WIKIPEDIA,
  WIKIDATA,
  OPEN_LIBRARY,
  PODCAST_FEED,
  LOCAL_FILE,
  $unknown;

  factory Enum$MetadataSource.fromJson(String value) =>
      fromJson$Enum$MetadataSource(value);

  String toJson() => toJson$Enum$MetadataSource(this);
}

String toJson$Enum$MetadataSource(Enum$MetadataSource e) {
  switch (e) {
    case Enum$MetadataSource.TMDB:
      return r'TMDB';
    case Enum$MetadataSource.MUSICBRAINZ:
      return r'MUSICBRAINZ';
    case Enum$MetadataSource.COVER_ART_ARCHIVE:
      return r'COVER_ART_ARCHIVE';
    case Enum$MetadataSource.WIKIMEDIA_COMMONS:
      return r'WIKIMEDIA_COMMONS';
    case Enum$MetadataSource.WIKIPEDIA:
      return r'WIKIPEDIA';
    case Enum$MetadataSource.WIKIDATA:
      return r'WIKIDATA';
    case Enum$MetadataSource.OPEN_LIBRARY:
      return r'OPEN_LIBRARY';
    case Enum$MetadataSource.PODCAST_FEED:
      return r'PODCAST_FEED';
    case Enum$MetadataSource.LOCAL_FILE:
      return r'LOCAL_FILE';
    case Enum$MetadataSource.$unknown:
      return r'$unknown';
  }
}

Enum$MetadataSource fromJson$Enum$MetadataSource(String value) {
  switch (value) {
    case r'TMDB':
      return Enum$MetadataSource.TMDB;
    case r'MUSICBRAINZ':
      return Enum$MetadataSource.MUSICBRAINZ;
    case r'COVER_ART_ARCHIVE':
      return Enum$MetadataSource.COVER_ART_ARCHIVE;
    case r'WIKIMEDIA_COMMONS':
      return Enum$MetadataSource.WIKIMEDIA_COMMONS;
    case r'WIKIPEDIA':
      return Enum$MetadataSource.WIKIPEDIA;
    case r'WIKIDATA':
      return Enum$MetadataSource.WIKIDATA;
    case r'OPEN_LIBRARY':
      return Enum$MetadataSource.OPEN_LIBRARY;
    case r'PODCAST_FEED':
      return Enum$MetadataSource.PODCAST_FEED;
    case r'LOCAL_FILE':
      return Enum$MetadataSource.LOCAL_FILE;
    default:
      return Enum$MetadataSource.$unknown;
  }
}

enum Enum$DevicePlatform {
  ANDROID,
  ANDROID_TV,
  IOS,
  LINUX,
  MACOS,
  WINDOWS,
  WEB,
  OTHER,
  $unknown;

  factory Enum$DevicePlatform.fromJson(String value) =>
      fromJson$Enum$DevicePlatform(value);

  String toJson() => toJson$Enum$DevicePlatform(this);
}

String toJson$Enum$DevicePlatform(Enum$DevicePlatform e) {
  switch (e) {
    case Enum$DevicePlatform.ANDROID:
      return r'ANDROID';
    case Enum$DevicePlatform.ANDROID_TV:
      return r'ANDROID_TV';
    case Enum$DevicePlatform.IOS:
      return r'IOS';
    case Enum$DevicePlatform.LINUX:
      return r'LINUX';
    case Enum$DevicePlatform.MACOS:
      return r'MACOS';
    case Enum$DevicePlatform.WINDOWS:
      return r'WINDOWS';
    case Enum$DevicePlatform.WEB:
      return r'WEB';
    case Enum$DevicePlatform.OTHER:
      return r'OTHER';
    case Enum$DevicePlatform.$unknown:
      return r'$unknown';
  }
}

Enum$DevicePlatform fromJson$Enum$DevicePlatform(String value) {
  switch (value) {
    case r'ANDROID':
      return Enum$DevicePlatform.ANDROID;
    case r'ANDROID_TV':
      return Enum$DevicePlatform.ANDROID_TV;
    case r'IOS':
      return Enum$DevicePlatform.IOS;
    case r'LINUX':
      return Enum$DevicePlatform.LINUX;
    case r'MACOS':
      return Enum$DevicePlatform.MACOS;
    case r'WINDOWS':
      return Enum$DevicePlatform.WINDOWS;
    case r'WEB':
      return Enum$DevicePlatform.WEB;
    case r'OTHER':
      return Enum$DevicePlatform.OTHER;
    default:
      return Enum$DevicePlatform.$unknown;
  }
}

enum Enum$DeviceCommandType {
  PLAY_MEDIA,
  TAKEOVER_QUEUE,
  START_FOLLOW,
  HANDOFF_QUEUE,
  $unknown;

  factory Enum$DeviceCommandType.fromJson(String value) =>
      fromJson$Enum$DeviceCommandType(value);

  String toJson() => toJson$Enum$DeviceCommandType(this);
}

String toJson$Enum$DeviceCommandType(Enum$DeviceCommandType e) {
  switch (e) {
    case Enum$DeviceCommandType.PLAY_MEDIA:
      return r'PLAY_MEDIA';
    case Enum$DeviceCommandType.TAKEOVER_QUEUE:
      return r'TAKEOVER_QUEUE';
    case Enum$DeviceCommandType.START_FOLLOW:
      return r'START_FOLLOW';
    case Enum$DeviceCommandType.HANDOFF_QUEUE:
      return r'HANDOFF_QUEUE';
    case Enum$DeviceCommandType.$unknown:
      return r'$unknown';
  }
}

Enum$DeviceCommandType fromJson$Enum$DeviceCommandType(String value) {
  switch (value) {
    case r'PLAY_MEDIA':
      return Enum$DeviceCommandType.PLAY_MEDIA;
    case r'TAKEOVER_QUEUE':
      return Enum$DeviceCommandType.TAKEOVER_QUEUE;
    case r'START_FOLLOW':
      return Enum$DeviceCommandType.START_FOLLOW;
    case r'HANDOFF_QUEUE':
      return Enum$DeviceCommandType.HANDOFF_QUEUE;
    default:
      return Enum$DeviceCommandType.$unknown;
  }
}

enum Enum$FollowResult {
  OK,
  NOT_FOUND,
  NO_LIBRARY_ACCESS,
  $unknown;

  factory Enum$FollowResult.fromJson(String value) =>
      fromJson$Enum$FollowResult(value);

  String toJson() => toJson$Enum$FollowResult(this);
}

String toJson$Enum$FollowResult(Enum$FollowResult e) {
  switch (e) {
    case Enum$FollowResult.OK:
      return r'OK';
    case Enum$FollowResult.NOT_FOUND:
      return r'NOT_FOUND';
    case Enum$FollowResult.NO_LIBRARY_ACCESS:
      return r'NO_LIBRARY_ACCESS';
    case Enum$FollowResult.$unknown:
      return r'$unknown';
  }
}

Enum$FollowResult fromJson$Enum$FollowResult(String value) {
  switch (value) {
    case r'OK':
      return Enum$FollowResult.OK;
    case r'NOT_FOUND':
      return Enum$FollowResult.NOT_FOUND;
    case r'NO_LIBRARY_ACCESS':
      return Enum$FollowResult.NO_LIBRARY_ACCESS;
    default:
      return Enum$FollowResult.$unknown;
  }
}

enum Enum$PlaybackCommandType {
  PLAY,
  PAUSE,
  NEXT,
  PREVIOUS,
  SEEK,
  SKIP_TO_ITEM,
  QUEUE_CHANGED,
  STOP_FOLLOW,
  SET_REPEAT,
  STOP,
  $unknown;

  factory Enum$PlaybackCommandType.fromJson(String value) =>
      fromJson$Enum$PlaybackCommandType(value);

  String toJson() => toJson$Enum$PlaybackCommandType(this);
}

String toJson$Enum$PlaybackCommandType(Enum$PlaybackCommandType e) {
  switch (e) {
    case Enum$PlaybackCommandType.PLAY:
      return r'PLAY';
    case Enum$PlaybackCommandType.PAUSE:
      return r'PAUSE';
    case Enum$PlaybackCommandType.NEXT:
      return r'NEXT';
    case Enum$PlaybackCommandType.PREVIOUS:
      return r'PREVIOUS';
    case Enum$PlaybackCommandType.SEEK:
      return r'SEEK';
    case Enum$PlaybackCommandType.SKIP_TO_ITEM:
      return r'SKIP_TO_ITEM';
    case Enum$PlaybackCommandType.QUEUE_CHANGED:
      return r'QUEUE_CHANGED';
    case Enum$PlaybackCommandType.STOP_FOLLOW:
      return r'STOP_FOLLOW';
    case Enum$PlaybackCommandType.SET_REPEAT:
      return r'SET_REPEAT';
    case Enum$PlaybackCommandType.STOP:
      return r'STOP';
    case Enum$PlaybackCommandType.$unknown:
      return r'$unknown';
  }
}

Enum$PlaybackCommandType fromJson$Enum$PlaybackCommandType(String value) {
  switch (value) {
    case r'PLAY':
      return Enum$PlaybackCommandType.PLAY;
    case r'PAUSE':
      return Enum$PlaybackCommandType.PAUSE;
    case r'NEXT':
      return Enum$PlaybackCommandType.NEXT;
    case r'PREVIOUS':
      return Enum$PlaybackCommandType.PREVIOUS;
    case r'SEEK':
      return Enum$PlaybackCommandType.SEEK;
    case r'SKIP_TO_ITEM':
      return Enum$PlaybackCommandType.SKIP_TO_ITEM;
    case r'QUEUE_CHANGED':
      return Enum$PlaybackCommandType.QUEUE_CHANGED;
    case r'STOP_FOLLOW':
      return Enum$PlaybackCommandType.STOP_FOLLOW;
    case r'SET_REPEAT':
      return Enum$PlaybackCommandType.SET_REPEAT;
    case r'STOP':
      return Enum$PlaybackCommandType.STOP;
    default:
      return Enum$PlaybackCommandType.$unknown;
  }
}

enum Enum$RepeatMode {
  NONE,
  ALL,
  ONE,
  $unknown;

  factory Enum$RepeatMode.fromJson(String value) =>
      fromJson$Enum$RepeatMode(value);

  String toJson() => toJson$Enum$RepeatMode(this);
}

String toJson$Enum$RepeatMode(Enum$RepeatMode e) {
  switch (e) {
    case Enum$RepeatMode.NONE:
      return r'NONE';
    case Enum$RepeatMode.ALL:
      return r'ALL';
    case Enum$RepeatMode.ONE:
      return r'ONE';
    case Enum$RepeatMode.$unknown:
      return r'$unknown';
  }
}

Enum$RepeatMode fromJson$Enum$RepeatMode(String value) {
  switch (value) {
    case r'NONE':
      return Enum$RepeatMode.NONE;
    case r'ALL':
      return Enum$RepeatMode.ALL;
    case r'ONE':
      return Enum$RepeatMode.ONE;
    default:
      return Enum$RepeatMode.$unknown;
  }
}

enum Enum$PlayState {
  PLAYING,
  PAUSED,
  $unknown;

  factory Enum$PlayState.fromJson(String value) =>
      fromJson$Enum$PlayState(value);

  String toJson() => toJson$Enum$PlayState(this);
}

String toJson$Enum$PlayState(Enum$PlayState e) {
  switch (e) {
    case Enum$PlayState.PLAYING:
      return r'PLAYING';
    case Enum$PlayState.PAUSED:
      return r'PAUSED';
    case Enum$PlayState.$unknown:
      return r'$unknown';
  }
}

Enum$PlayState fromJson$Enum$PlayState(String value) {
  switch (value) {
    case r'PLAYING':
      return Enum$PlayState.PLAYING;
    case r'PAUSED':
      return Enum$PlayState.PAUSED;
    default:
      return Enum$PlayState.$unknown;
  }
}

enum Enum$ServerActivityEventType {
  NODE_ACTIVITY,
  QUEUE_STATS,
  FAILURE,
  TRANSCODE_ACTIVITY,
  $unknown;

  factory Enum$ServerActivityEventType.fromJson(String value) =>
      fromJson$Enum$ServerActivityEventType(value);

  String toJson() => toJson$Enum$ServerActivityEventType(this);
}

String toJson$Enum$ServerActivityEventType(Enum$ServerActivityEventType e) {
  switch (e) {
    case Enum$ServerActivityEventType.NODE_ACTIVITY:
      return r'NODE_ACTIVITY';
    case Enum$ServerActivityEventType.QUEUE_STATS:
      return r'QUEUE_STATS';
    case Enum$ServerActivityEventType.FAILURE:
      return r'FAILURE';
    case Enum$ServerActivityEventType.TRANSCODE_ACTIVITY:
      return r'TRANSCODE_ACTIVITY';
    case Enum$ServerActivityEventType.$unknown:
      return r'$unknown';
  }
}

Enum$ServerActivityEventType fromJson$Enum$ServerActivityEventType(
  String value,
) {
  switch (value) {
    case r'NODE_ACTIVITY':
      return Enum$ServerActivityEventType.NODE_ACTIVITY;
    case r'QUEUE_STATS':
      return Enum$ServerActivityEventType.QUEUE_STATS;
    case r'FAILURE':
      return Enum$ServerActivityEventType.FAILURE;
    case r'TRANSCODE_ACTIVITY':
      return Enum$ServerActivityEventType.TRANSCODE_ACTIVITY;
    default:
      return Enum$ServerActivityEventType.$unknown;
  }
}

enum Enum$SortingEnum {
  DATE_CREATED,
  NAME,
  RELEASE_YEAR,
  $unknown;

  factory Enum$SortingEnum.fromJson(String value) =>
      fromJson$Enum$SortingEnum(value);

  String toJson() => toJson$Enum$SortingEnum(this);
}

String toJson$Enum$SortingEnum(Enum$SortingEnum e) {
  switch (e) {
    case Enum$SortingEnum.DATE_CREATED:
      return r'DATE_CREATED';
    case Enum$SortingEnum.NAME:
      return r'NAME';
    case Enum$SortingEnum.RELEASE_YEAR:
      return r'RELEASE_YEAR';
    case Enum$SortingEnum.$unknown:
      return r'$unknown';
  }
}

Enum$SortingEnum fromJson$Enum$SortingEnum(String value) {
  switch (value) {
    case r'DATE_CREATED':
      return Enum$SortingEnum.DATE_CREATED;
    case r'NAME':
      return Enum$SortingEnum.NAME;
    case r'RELEASE_YEAR':
      return Enum$SortingEnum.RELEASE_YEAR;
    default:
      return Enum$SortingEnum.$unknown;
  }
}

enum Enum$SortingOrder {
  DESCENDING,
  ASCENDING,
  $unknown;

  factory Enum$SortingOrder.fromJson(String value) =>
      fromJson$Enum$SortingOrder(value);

  String toJson() => toJson$Enum$SortingOrder(this);
}

String toJson$Enum$SortingOrder(Enum$SortingOrder e) {
  switch (e) {
    case Enum$SortingOrder.DESCENDING:
      return r'DESCENDING';
    case Enum$SortingOrder.ASCENDING:
      return r'ASCENDING';
    case Enum$SortingOrder.$unknown:
      return r'$unknown';
  }
}

Enum$SortingOrder fromJson$Enum$SortingOrder(String value) {
  switch (value) {
    case r'DESCENDING':
      return Enum$SortingOrder.DESCENDING;
    case r'ASCENDING':
      return Enum$SortingOrder.ASCENDING;
    default:
      return Enum$SortingOrder.$unknown;
  }
}

enum Enum$FilterKind {
  ARTIST,
  ALBUM,
  TRACK,
  MOVIE,
  SHOW,
  EPISODE,
  $unknown;

  factory Enum$FilterKind.fromJson(String value) =>
      fromJson$Enum$FilterKind(value);

  String toJson() => toJson$Enum$FilterKind(this);
}

String toJson$Enum$FilterKind(Enum$FilterKind e) {
  switch (e) {
    case Enum$FilterKind.ARTIST:
      return r'ARTIST';
    case Enum$FilterKind.ALBUM:
      return r'ALBUM';
    case Enum$FilterKind.TRACK:
      return r'TRACK';
    case Enum$FilterKind.MOVIE:
      return r'MOVIE';
    case Enum$FilterKind.SHOW:
      return r'SHOW';
    case Enum$FilterKind.EPISODE:
      return r'EPISODE';
    case Enum$FilterKind.$unknown:
      return r'$unknown';
  }
}

Enum$FilterKind fromJson$Enum$FilterKind(String value) {
  switch (value) {
    case r'ARTIST':
      return Enum$FilterKind.ARTIST;
    case r'ALBUM':
      return Enum$FilterKind.ALBUM;
    case r'TRACK':
      return Enum$FilterKind.TRACK;
    case r'MOVIE':
      return Enum$FilterKind.MOVIE;
    case r'SHOW':
      return Enum$FilterKind.SHOW;
    case r'EPISODE':
      return Enum$FilterKind.EPISODE;
    default:
      return Enum$FilterKind.$unknown;
  }
}

enum Enum$FilterMatch {
  ALL,
  ANY,
  $unknown;

  factory Enum$FilterMatch.fromJson(String value) =>
      fromJson$Enum$FilterMatch(value);

  String toJson() => toJson$Enum$FilterMatch(this);
}

String toJson$Enum$FilterMatch(Enum$FilterMatch e) {
  switch (e) {
    case Enum$FilterMatch.ALL:
      return r'ALL';
    case Enum$FilterMatch.ANY:
      return r'ANY';
    case Enum$FilterMatch.$unknown:
      return r'$unknown';
  }
}

Enum$FilterMatch fromJson$Enum$FilterMatch(String value) {
  switch (value) {
    case r'ALL':
      return Enum$FilterMatch.ALL;
    case r'ANY':
      return Enum$FilterMatch.ANY;
    default:
      return Enum$FilterMatch.$unknown;
  }
}

enum Enum$FilterField {
  TITLE,
  ARTIST_NAME,
  ALBUM_NAME,
  RELEASE_YEAR,
  BIRTH_YEAR,
  GENRE,
  RATING,
  PLAY_COUNT,
  LAST_PLAYED_AT,
  DURATION,
  WATCHED,
  DATE_ADDED,
  $unknown;

  factory Enum$FilterField.fromJson(String value) =>
      fromJson$Enum$FilterField(value);

  String toJson() => toJson$Enum$FilterField(this);
}

String toJson$Enum$FilterField(Enum$FilterField e) {
  switch (e) {
    case Enum$FilterField.TITLE:
      return r'TITLE';
    case Enum$FilterField.ARTIST_NAME:
      return r'ARTIST_NAME';
    case Enum$FilterField.ALBUM_NAME:
      return r'ALBUM_NAME';
    case Enum$FilterField.RELEASE_YEAR:
      return r'RELEASE_YEAR';
    case Enum$FilterField.BIRTH_YEAR:
      return r'BIRTH_YEAR';
    case Enum$FilterField.GENRE:
      return r'GENRE';
    case Enum$FilterField.RATING:
      return r'RATING';
    case Enum$FilterField.PLAY_COUNT:
      return r'PLAY_COUNT';
    case Enum$FilterField.LAST_PLAYED_AT:
      return r'LAST_PLAYED_AT';
    case Enum$FilterField.DURATION:
      return r'DURATION';
    case Enum$FilterField.WATCHED:
      return r'WATCHED';
    case Enum$FilterField.DATE_ADDED:
      return r'DATE_ADDED';
    case Enum$FilterField.$unknown:
      return r'$unknown';
  }
}

Enum$FilterField fromJson$Enum$FilterField(String value) {
  switch (value) {
    case r'TITLE':
      return Enum$FilterField.TITLE;
    case r'ARTIST_NAME':
      return Enum$FilterField.ARTIST_NAME;
    case r'ALBUM_NAME':
      return Enum$FilterField.ALBUM_NAME;
    case r'RELEASE_YEAR':
      return Enum$FilterField.RELEASE_YEAR;
    case r'BIRTH_YEAR':
      return Enum$FilterField.BIRTH_YEAR;
    case r'GENRE':
      return Enum$FilterField.GENRE;
    case r'RATING':
      return Enum$FilterField.RATING;
    case r'PLAY_COUNT':
      return Enum$FilterField.PLAY_COUNT;
    case r'LAST_PLAYED_AT':
      return Enum$FilterField.LAST_PLAYED_AT;
    case r'DURATION':
      return Enum$FilterField.DURATION;
    case r'WATCHED':
      return Enum$FilterField.WATCHED;
    case r'DATE_ADDED':
      return Enum$FilterField.DATE_ADDED;
    default:
      return Enum$FilterField.$unknown;
  }
}

enum Enum$FilterOperator {
  EQUALS,
  NOT_EQUALS,
  CONTAINS,
  NOT_CONTAINS,
  LESS_THAN,
  GREATER_THAN,
  BEFORE,
  AFTER,
  IN_LAST_DAYS,
  IS_SET,
  IS_NOT_SET,
  $unknown;

  factory Enum$FilterOperator.fromJson(String value) =>
      fromJson$Enum$FilterOperator(value);

  String toJson() => toJson$Enum$FilterOperator(this);
}

String toJson$Enum$FilterOperator(Enum$FilterOperator e) {
  switch (e) {
    case Enum$FilterOperator.EQUALS:
      return r'EQUALS';
    case Enum$FilterOperator.NOT_EQUALS:
      return r'NOT_EQUALS';
    case Enum$FilterOperator.CONTAINS:
      return r'CONTAINS';
    case Enum$FilterOperator.NOT_CONTAINS:
      return r'NOT_CONTAINS';
    case Enum$FilterOperator.LESS_THAN:
      return r'LESS_THAN';
    case Enum$FilterOperator.GREATER_THAN:
      return r'GREATER_THAN';
    case Enum$FilterOperator.BEFORE:
      return r'BEFORE';
    case Enum$FilterOperator.AFTER:
      return r'AFTER';
    case Enum$FilterOperator.IN_LAST_DAYS:
      return r'IN_LAST_DAYS';
    case Enum$FilterOperator.IS_SET:
      return r'IS_SET';
    case Enum$FilterOperator.IS_NOT_SET:
      return r'IS_NOT_SET';
    case Enum$FilterOperator.$unknown:
      return r'$unknown';
  }
}

Enum$FilterOperator fromJson$Enum$FilterOperator(String value) {
  switch (value) {
    case r'EQUALS':
      return Enum$FilterOperator.EQUALS;
    case r'NOT_EQUALS':
      return Enum$FilterOperator.NOT_EQUALS;
    case r'CONTAINS':
      return Enum$FilterOperator.CONTAINS;
    case r'NOT_CONTAINS':
      return Enum$FilterOperator.NOT_CONTAINS;
    case r'LESS_THAN':
      return Enum$FilterOperator.LESS_THAN;
    case r'GREATER_THAN':
      return Enum$FilterOperator.GREATER_THAN;
    case r'BEFORE':
      return Enum$FilterOperator.BEFORE;
    case r'AFTER':
      return Enum$FilterOperator.AFTER;
    case r'IN_LAST_DAYS':
      return Enum$FilterOperator.IN_LAST_DAYS;
    case r'IS_SET':
      return Enum$FilterOperator.IS_SET;
    case r'IS_NOT_SET':
      return Enum$FilterOperator.IS_NOT_SET;
    default:
      return Enum$FilterOperator.$unknown;
  }
}

enum Enum$PlaylistType {
  MANUAL,
  SMART,
  $unknown;

  factory Enum$PlaylistType.fromJson(String value) =>
      fromJson$Enum$PlaylistType(value);

  String toJson() => toJson$Enum$PlaylistType(this);
}

String toJson$Enum$PlaylistType(Enum$PlaylistType e) {
  switch (e) {
    case Enum$PlaylistType.MANUAL:
      return r'MANUAL';
    case Enum$PlaylistType.SMART:
      return r'SMART';
    case Enum$PlaylistType.$unknown:
      return r'$unknown';
  }
}

Enum$PlaylistType fromJson$Enum$PlaylistType(String value) {
  switch (value) {
    case r'MANUAL':
      return Enum$PlaylistType.MANUAL;
    case r'SMART':
      return Enum$PlaylistType.SMART;
    default:
      return Enum$PlaylistType.$unknown;
  }
}

enum Enum$RankKind {
  RECENTLY_PLAYED,
  MOST_PLAYED,
  HIGHEST_RATED,
  RECENTLY_ADDED,
  $unknown;

  factory Enum$RankKind.fromJson(String value) => fromJson$Enum$RankKind(value);

  String toJson() => toJson$Enum$RankKind(this);
}

String toJson$Enum$RankKind(Enum$RankKind e) {
  switch (e) {
    case Enum$RankKind.RECENTLY_PLAYED:
      return r'RECENTLY_PLAYED';
    case Enum$RankKind.MOST_PLAYED:
      return r'MOST_PLAYED';
    case Enum$RankKind.HIGHEST_RATED:
      return r'HIGHEST_RATED';
    case Enum$RankKind.RECENTLY_ADDED:
      return r'RECENTLY_ADDED';
    case Enum$RankKind.$unknown:
      return r'$unknown';
  }
}

Enum$RankKind fromJson$Enum$RankKind(String value) {
  switch (value) {
    case r'RECENTLY_PLAYED':
      return Enum$RankKind.RECENTLY_PLAYED;
    case r'MOST_PLAYED':
      return Enum$RankKind.MOST_PLAYED;
    case r'HIGHEST_RATED':
      return Enum$RankKind.HIGHEST_RATED;
    case r'RECENTLY_ADDED':
      return Enum$RankKind.RECENTLY_ADDED;
    default:
      return Enum$RankKind.$unknown;
  }
}

enum Enum$ReadingDirection {
  LTR,
  RTL,
  $unknown;

  factory Enum$ReadingDirection.fromJson(String value) =>
      fromJson$Enum$ReadingDirection(value);

  String toJson() => toJson$Enum$ReadingDirection(this);
}

String toJson$Enum$ReadingDirection(Enum$ReadingDirection e) {
  switch (e) {
    case Enum$ReadingDirection.LTR:
      return r'LTR';
    case Enum$ReadingDirection.RTL:
      return r'RTL';
    case Enum$ReadingDirection.$unknown:
      return r'$unknown';
  }
}

Enum$ReadingDirection fromJson$Enum$ReadingDirection(String value) {
  switch (value) {
    case r'LTR':
      return Enum$ReadingDirection.LTR;
    case r'RTL':
      return Enum$ReadingDirection.RTL;
    default:
      return Enum$ReadingDirection.$unknown;
  }
}

enum Enum$LibraryType {
  MOVIE,
  SHOW,
  MUSIC,
  BOOK,
  PODCAST,
  COMIC,
  $unknown;

  factory Enum$LibraryType.fromJson(String value) =>
      fromJson$Enum$LibraryType(value);

  String toJson() => toJson$Enum$LibraryType(this);
}

String toJson$Enum$LibraryType(Enum$LibraryType e) {
  switch (e) {
    case Enum$LibraryType.MOVIE:
      return r'MOVIE';
    case Enum$LibraryType.SHOW:
      return r'SHOW';
    case Enum$LibraryType.MUSIC:
      return r'MUSIC';
    case Enum$LibraryType.BOOK:
      return r'BOOK';
    case Enum$LibraryType.PODCAST:
      return r'PODCAST';
    case Enum$LibraryType.COMIC:
      return r'COMIC';
    case Enum$LibraryType.$unknown:
      return r'$unknown';
  }
}

Enum$LibraryType fromJson$Enum$LibraryType(String value) {
  switch (value) {
    case r'MOVIE':
      return Enum$LibraryType.MOVIE;
    case r'SHOW':
      return Enum$LibraryType.SHOW;
    case r'MUSIC':
      return Enum$LibraryType.MUSIC;
    case r'BOOK':
      return Enum$LibraryType.BOOK;
    case r'PODCAST':
      return Enum$LibraryType.PODCAST;
    case r'COMIC':
      return Enum$LibraryType.COMIC;
    default:
      return Enum$LibraryType.$unknown;
  }
}

enum Enum$MediaType {
  MOVIE,
  EPISODE,
  TRACK,
  CHAPTER,
  BOOK,
  PODCAST_EPISODE,
  COMIC,
  $unknown;

  factory Enum$MediaType.fromJson(String value) =>
      fromJson$Enum$MediaType(value);

  String toJson() => toJson$Enum$MediaType(this);
}

String toJson$Enum$MediaType(Enum$MediaType e) {
  switch (e) {
    case Enum$MediaType.MOVIE:
      return r'MOVIE';
    case Enum$MediaType.EPISODE:
      return r'EPISODE';
    case Enum$MediaType.TRACK:
      return r'TRACK';
    case Enum$MediaType.CHAPTER:
      return r'CHAPTER';
    case Enum$MediaType.BOOK:
      return r'BOOK';
    case Enum$MediaType.PODCAST_EPISODE:
      return r'PODCAST_EPISODE';
    case Enum$MediaType.COMIC:
      return r'COMIC';
    case Enum$MediaType.$unknown:
      return r'$unknown';
  }
}

Enum$MediaType fromJson$Enum$MediaType(String value) {
  switch (value) {
    case r'MOVIE':
      return Enum$MediaType.MOVIE;
    case r'EPISODE':
      return Enum$MediaType.EPISODE;
    case r'TRACK':
      return Enum$MediaType.TRACK;
    case r'CHAPTER':
      return Enum$MediaType.CHAPTER;
    case r'BOOK':
      return Enum$MediaType.BOOK;
    case r'PODCAST_EPISODE':
      return Enum$MediaType.PODCAST_EPISODE;
    case r'COMIC':
      return Enum$MediaType.COMIC;
    default:
      return Enum$MediaType.$unknown;
  }
}

enum Enum$RatingMediaType {
  MOVIE,
  SHOW,
  EPISODE,
  ALBUM,
  TRACK,
  BOOK,
  PODCAST,
  $unknown;

  factory Enum$RatingMediaType.fromJson(String value) =>
      fromJson$Enum$RatingMediaType(value);

  String toJson() => toJson$Enum$RatingMediaType(this);
}

String toJson$Enum$RatingMediaType(Enum$RatingMediaType e) {
  switch (e) {
    case Enum$RatingMediaType.MOVIE:
      return r'MOVIE';
    case Enum$RatingMediaType.SHOW:
      return r'SHOW';
    case Enum$RatingMediaType.EPISODE:
      return r'EPISODE';
    case Enum$RatingMediaType.ALBUM:
      return r'ALBUM';
    case Enum$RatingMediaType.TRACK:
      return r'TRACK';
    case Enum$RatingMediaType.BOOK:
      return r'BOOK';
    case Enum$RatingMediaType.PODCAST:
      return r'PODCAST';
    case Enum$RatingMediaType.$unknown:
      return r'$unknown';
  }
}

Enum$RatingMediaType fromJson$Enum$RatingMediaType(String value) {
  switch (value) {
    case r'MOVIE':
      return Enum$RatingMediaType.MOVIE;
    case r'SHOW':
      return Enum$RatingMediaType.SHOW;
    case r'EPISODE':
      return Enum$RatingMediaType.EPISODE;
    case r'ALBUM':
      return Enum$RatingMediaType.ALBUM;
    case r'TRACK':
      return Enum$RatingMediaType.TRACK;
    case r'BOOK':
      return Enum$RatingMediaType.BOOK;
    case r'PODCAST':
      return Enum$RatingMediaType.PODCAST;
    default:
      return Enum$RatingMediaType.$unknown;
  }
}

enum Enum$PlayQueueSourceType {
  MOVIE,
  SHOW,
  ALBUM,
  LIBRARY,
  BOOK,
  PODCAST,
  ARTIST,
  FILTER,
  PLAYLIST,
  $unknown;

  factory Enum$PlayQueueSourceType.fromJson(String value) =>
      fromJson$Enum$PlayQueueSourceType(value);

  String toJson() => toJson$Enum$PlayQueueSourceType(this);
}

String toJson$Enum$PlayQueueSourceType(Enum$PlayQueueSourceType e) {
  switch (e) {
    case Enum$PlayQueueSourceType.MOVIE:
      return r'MOVIE';
    case Enum$PlayQueueSourceType.SHOW:
      return r'SHOW';
    case Enum$PlayQueueSourceType.ALBUM:
      return r'ALBUM';
    case Enum$PlayQueueSourceType.LIBRARY:
      return r'LIBRARY';
    case Enum$PlayQueueSourceType.BOOK:
      return r'BOOK';
    case Enum$PlayQueueSourceType.PODCAST:
      return r'PODCAST';
    case Enum$PlayQueueSourceType.ARTIST:
      return r'ARTIST';
    case Enum$PlayQueueSourceType.FILTER:
      return r'FILTER';
    case Enum$PlayQueueSourceType.PLAYLIST:
      return r'PLAYLIST';
    case Enum$PlayQueueSourceType.$unknown:
      return r'$unknown';
  }
}

Enum$PlayQueueSourceType fromJson$Enum$PlayQueueSourceType(String value) {
  switch (value) {
    case r'MOVIE':
      return Enum$PlayQueueSourceType.MOVIE;
    case r'SHOW':
      return Enum$PlayQueueSourceType.SHOW;
    case r'ALBUM':
      return Enum$PlayQueueSourceType.ALBUM;
    case r'LIBRARY':
      return Enum$PlayQueueSourceType.LIBRARY;
    case r'BOOK':
      return Enum$PlayQueueSourceType.BOOK;
    case r'PODCAST':
      return Enum$PlayQueueSourceType.PODCAST;
    case r'ARTIST':
      return Enum$PlayQueueSourceType.ARTIST;
    case r'FILTER':
      return Enum$PlayQueueSourceType.FILTER;
    case r'PLAYLIST':
      return Enum$PlayQueueSourceType.PLAYLIST;
    default:
      return Enum$PlayQueueSourceType.$unknown;
  }
}

enum Enum$SubtitleFormat {
  WEBVTT,
  SRT,
  $unknown;

  factory Enum$SubtitleFormat.fromJson(String value) =>
      fromJson$Enum$SubtitleFormat(value);

  String toJson() => toJson$Enum$SubtitleFormat(this);
}

String toJson$Enum$SubtitleFormat(Enum$SubtitleFormat e) {
  switch (e) {
    case Enum$SubtitleFormat.WEBVTT:
      return r'WEBVTT';
    case Enum$SubtitleFormat.SRT:
      return r'SRT';
    case Enum$SubtitleFormat.$unknown:
      return r'$unknown';
  }
}

Enum$SubtitleFormat fromJson$Enum$SubtitleFormat(String value) {
  switch (value) {
    case r'WEBVTT':
      return Enum$SubtitleFormat.WEBVTT;
    case r'SRT':
      return Enum$SubtitleFormat.SRT;
    default:
      return Enum$SubtitleFormat.$unknown;
  }
}

enum Enum$DirectoryType {
  LIBRARY,
  CACHE,
  $unknown;

  factory Enum$DirectoryType.fromJson(String value) =>
      fromJson$Enum$DirectoryType(value);

  String toJson() => toJson$Enum$DirectoryType(this);
}

String toJson$Enum$DirectoryType(Enum$DirectoryType e) {
  switch (e) {
    case Enum$DirectoryType.LIBRARY:
      return r'LIBRARY';
    case Enum$DirectoryType.CACHE:
      return r'CACHE';
    case Enum$DirectoryType.$unknown:
      return r'$unknown';
  }
}

Enum$DirectoryType fromJson$Enum$DirectoryType(String value) {
  switch (value) {
    case r'LIBRARY':
      return Enum$DirectoryType.LIBRARY;
    case r'CACHE':
      return Enum$DirectoryType.CACHE;
    default:
      return Enum$DirectoryType.$unknown;
  }
}

enum Enum$MediaSegmentType {
  INTRO,
  OUTRO,
  $unknown;

  factory Enum$MediaSegmentType.fromJson(String value) =>
      fromJson$Enum$MediaSegmentType(value);

  String toJson() => toJson$Enum$MediaSegmentType(this);
}

String toJson$Enum$MediaSegmentType(Enum$MediaSegmentType e) {
  switch (e) {
    case Enum$MediaSegmentType.INTRO:
      return r'INTRO';
    case Enum$MediaSegmentType.OUTRO:
      return r'OUTRO';
    case Enum$MediaSegmentType.$unknown:
      return r'$unknown';
  }
}

Enum$MediaSegmentType fromJson$Enum$MediaSegmentType(String value) {
  switch (value) {
    case r'INTRO':
      return Enum$MediaSegmentType.INTRO;
    case r'OUTRO':
      return Enum$MediaSegmentType.OUTRO;
    default:
      return Enum$MediaSegmentType.$unknown;
  }
}

enum Enum$SharingScope {
  EVERYONE,
  ALLOWLIST,
  PRIVATE,
  $unknown;

  factory Enum$SharingScope.fromJson(String value) =>
      fromJson$Enum$SharingScope(value);

  String toJson() => toJson$Enum$SharingScope(this);
}

String toJson$Enum$SharingScope(Enum$SharingScope e) {
  switch (e) {
    case Enum$SharingScope.EVERYONE:
      return r'EVERYONE';
    case Enum$SharingScope.ALLOWLIST:
      return r'ALLOWLIST';
    case Enum$SharingScope.PRIVATE:
      return r'PRIVATE';
    case Enum$SharingScope.$unknown:
      return r'$unknown';
  }
}

Enum$SharingScope fromJson$Enum$SharingScope(String value) {
  switch (value) {
    case r'EVERYONE':
      return Enum$SharingScope.EVERYONE;
    case r'ALLOWLIST':
      return Enum$SharingScope.ALLOWLIST;
    case r'PRIVATE':
      return Enum$SharingScope.PRIVATE;
    default:
      return Enum$SharingScope.$unknown;
  }
}

enum Enum$RemoteControlScope {
  PRIVATE,
  EVERYONE,
  ALLOWLIST,
  SAME_AS_NOW_PLAYING,
  $unknown;

  factory Enum$RemoteControlScope.fromJson(String value) =>
      fromJson$Enum$RemoteControlScope(value);

  String toJson() => toJson$Enum$RemoteControlScope(this);
}

String toJson$Enum$RemoteControlScope(Enum$RemoteControlScope e) {
  switch (e) {
    case Enum$RemoteControlScope.PRIVATE:
      return r'PRIVATE';
    case Enum$RemoteControlScope.EVERYONE:
      return r'EVERYONE';
    case Enum$RemoteControlScope.ALLOWLIST:
      return r'ALLOWLIST';
    case Enum$RemoteControlScope.SAME_AS_NOW_PLAYING:
      return r'SAME_AS_NOW_PLAYING';
    case Enum$RemoteControlScope.$unknown:
      return r'$unknown';
  }
}

Enum$RemoteControlScope fromJson$Enum$RemoteControlScope(String value) {
  switch (value) {
    case r'PRIVATE':
      return Enum$RemoteControlScope.PRIVATE;
    case r'EVERYONE':
      return Enum$RemoteControlScope.EVERYONE;
    case r'ALLOWLIST':
      return Enum$RemoteControlScope.ALLOWLIST;
    case r'SAME_AS_NOW_PLAYING':
      return Enum$RemoteControlScope.SAME_AS_NOW_PLAYING;
    default:
      return Enum$RemoteControlScope.$unknown;
  }
}

enum Enum$CreditType {
  CAST,
  GUEST_STAR,
  $unknown;

  factory Enum$CreditType.fromJson(String value) =>
      fromJson$Enum$CreditType(value);

  String toJson() => toJson$Enum$CreditType(this);
}

String toJson$Enum$CreditType(Enum$CreditType e) {
  switch (e) {
    case Enum$CreditType.CAST:
      return r'CAST';
    case Enum$CreditType.GUEST_STAR:
      return r'GUEST_STAR';
    case Enum$CreditType.$unknown:
      return r'$unknown';
  }
}

Enum$CreditType fromJson$Enum$CreditType(String value) {
  switch (value) {
    case r'CAST':
      return Enum$CreditType.CAST;
    case r'GUEST_STAR':
      return Enum$CreditType.GUEST_STAR;
    default:
      return Enum$CreditType.$unknown;
  }
}

enum Enum$TrackCreditType {
  PRIMARY,
  FEATURED,
  $unknown;

  factory Enum$TrackCreditType.fromJson(String value) =>
      fromJson$Enum$TrackCreditType(value);

  String toJson() => toJson$Enum$TrackCreditType(this);
}

String toJson$Enum$TrackCreditType(Enum$TrackCreditType e) {
  switch (e) {
    case Enum$TrackCreditType.PRIMARY:
      return r'PRIMARY';
    case Enum$TrackCreditType.FEATURED:
      return r'FEATURED';
    case Enum$TrackCreditType.$unknown:
      return r'$unknown';
  }
}

Enum$TrackCreditType fromJson$Enum$TrackCreditType(String value) {
  switch (value) {
    case r'PRIMARY':
      return Enum$TrackCreditType.PRIMARY;
    case r'FEATURED':
      return Enum$TrackCreditType.FEATURED;
    default:
      return Enum$TrackCreditType.$unknown;
  }
}

enum Enum$BookProgressMode {
  READING,
  LISTENING,
  $unknown;

  factory Enum$BookProgressMode.fromJson(String value) =>
      fromJson$Enum$BookProgressMode(value);

  String toJson() => toJson$Enum$BookProgressMode(this);
}

String toJson$Enum$BookProgressMode(Enum$BookProgressMode e) {
  switch (e) {
    case Enum$BookProgressMode.READING:
      return r'READING';
    case Enum$BookProgressMode.LISTENING:
      return r'LISTENING';
    case Enum$BookProgressMode.$unknown:
      return r'$unknown';
  }
}

Enum$BookProgressMode fromJson$Enum$BookProgressMode(String value) {
  switch (value) {
    case r'READING':
      return Enum$BookProgressMode.READING;
    case r'LISTENING':
      return Enum$BookProgressMode.LISTENING;
    default:
      return Enum$BookProgressMode.$unknown;
  }
}

enum Enum$__TypeKind {
  SCALAR,
  OBJECT,
  INTERFACE,
  UNION,
  ENUM,
  INPUT_OBJECT,
  LIST,
  NON_NULL,
  $unknown;

  factory Enum$__TypeKind.fromJson(String value) =>
      fromJson$Enum$__TypeKind(value);

  String toJson() => toJson$Enum$__TypeKind(this);
}

String toJson$Enum$__TypeKind(Enum$__TypeKind e) {
  switch (e) {
    case Enum$__TypeKind.SCALAR:
      return r'SCALAR';
    case Enum$__TypeKind.OBJECT:
      return r'OBJECT';
    case Enum$__TypeKind.INTERFACE:
      return r'INTERFACE';
    case Enum$__TypeKind.UNION:
      return r'UNION';
    case Enum$__TypeKind.ENUM:
      return r'ENUM';
    case Enum$__TypeKind.INPUT_OBJECT:
      return r'INPUT_OBJECT';
    case Enum$__TypeKind.LIST:
      return r'LIST';
    case Enum$__TypeKind.NON_NULL:
      return r'NON_NULL';
    case Enum$__TypeKind.$unknown:
      return r'$unknown';
  }
}

Enum$__TypeKind fromJson$Enum$__TypeKind(String value) {
  switch (value) {
    case r'SCALAR':
      return Enum$__TypeKind.SCALAR;
    case r'OBJECT':
      return Enum$__TypeKind.OBJECT;
    case r'INTERFACE':
      return Enum$__TypeKind.INTERFACE;
    case r'UNION':
      return Enum$__TypeKind.UNION;
    case r'ENUM':
      return Enum$__TypeKind.ENUM;
    case r'INPUT_OBJECT':
      return Enum$__TypeKind.INPUT_OBJECT;
    case r'LIST':
      return Enum$__TypeKind.LIST;
    case r'NON_NULL':
      return Enum$__TypeKind.NON_NULL;
    default:
      return Enum$__TypeKind.$unknown;
  }
}

enum Enum$__DirectiveLocation {
  QUERY,
  MUTATION,
  SUBSCRIPTION,
  FIELD,
  FRAGMENT_DEFINITION,
  FRAGMENT_SPREAD,
  INLINE_FRAGMENT,
  VARIABLE_DEFINITION,
  SCHEMA,
  SCALAR,
  OBJECT,
  FIELD_DEFINITION,
  ARGUMENT_DEFINITION,
  INTERFACE,
  UNION,
  ENUM,
  ENUM_VALUE,
  INPUT_OBJECT,
  INPUT_FIELD_DEFINITION,
  $unknown;

  factory Enum$__DirectiveLocation.fromJson(String value) =>
      fromJson$Enum$__DirectiveLocation(value);

  String toJson() => toJson$Enum$__DirectiveLocation(this);
}

String toJson$Enum$__DirectiveLocation(Enum$__DirectiveLocation e) {
  switch (e) {
    case Enum$__DirectiveLocation.QUERY:
      return r'QUERY';
    case Enum$__DirectiveLocation.MUTATION:
      return r'MUTATION';
    case Enum$__DirectiveLocation.SUBSCRIPTION:
      return r'SUBSCRIPTION';
    case Enum$__DirectiveLocation.FIELD:
      return r'FIELD';
    case Enum$__DirectiveLocation.FRAGMENT_DEFINITION:
      return r'FRAGMENT_DEFINITION';
    case Enum$__DirectiveLocation.FRAGMENT_SPREAD:
      return r'FRAGMENT_SPREAD';
    case Enum$__DirectiveLocation.INLINE_FRAGMENT:
      return r'INLINE_FRAGMENT';
    case Enum$__DirectiveLocation.VARIABLE_DEFINITION:
      return r'VARIABLE_DEFINITION';
    case Enum$__DirectiveLocation.SCHEMA:
      return r'SCHEMA';
    case Enum$__DirectiveLocation.SCALAR:
      return r'SCALAR';
    case Enum$__DirectiveLocation.OBJECT:
      return r'OBJECT';
    case Enum$__DirectiveLocation.FIELD_DEFINITION:
      return r'FIELD_DEFINITION';
    case Enum$__DirectiveLocation.ARGUMENT_DEFINITION:
      return r'ARGUMENT_DEFINITION';
    case Enum$__DirectiveLocation.INTERFACE:
      return r'INTERFACE';
    case Enum$__DirectiveLocation.UNION:
      return r'UNION';
    case Enum$__DirectiveLocation.ENUM:
      return r'ENUM';
    case Enum$__DirectiveLocation.ENUM_VALUE:
      return r'ENUM_VALUE';
    case Enum$__DirectiveLocation.INPUT_OBJECT:
      return r'INPUT_OBJECT';
    case Enum$__DirectiveLocation.INPUT_FIELD_DEFINITION:
      return r'INPUT_FIELD_DEFINITION';
    case Enum$__DirectiveLocation.$unknown:
      return r'$unknown';
  }
}

Enum$__DirectiveLocation fromJson$Enum$__DirectiveLocation(String value) {
  switch (value) {
    case r'QUERY':
      return Enum$__DirectiveLocation.QUERY;
    case r'MUTATION':
      return Enum$__DirectiveLocation.MUTATION;
    case r'SUBSCRIPTION':
      return Enum$__DirectiveLocation.SUBSCRIPTION;
    case r'FIELD':
      return Enum$__DirectiveLocation.FIELD;
    case r'FRAGMENT_DEFINITION':
      return Enum$__DirectiveLocation.FRAGMENT_DEFINITION;
    case r'FRAGMENT_SPREAD':
      return Enum$__DirectiveLocation.FRAGMENT_SPREAD;
    case r'INLINE_FRAGMENT':
      return Enum$__DirectiveLocation.INLINE_FRAGMENT;
    case r'VARIABLE_DEFINITION':
      return Enum$__DirectiveLocation.VARIABLE_DEFINITION;
    case r'SCHEMA':
      return Enum$__DirectiveLocation.SCHEMA;
    case r'SCALAR':
      return Enum$__DirectiveLocation.SCALAR;
    case r'OBJECT':
      return Enum$__DirectiveLocation.OBJECT;
    case r'FIELD_DEFINITION':
      return Enum$__DirectiveLocation.FIELD_DEFINITION;
    case r'ARGUMENT_DEFINITION':
      return Enum$__DirectiveLocation.ARGUMENT_DEFINITION;
    case r'INTERFACE':
      return Enum$__DirectiveLocation.INTERFACE;
    case r'UNION':
      return Enum$__DirectiveLocation.UNION;
    case r'ENUM':
      return Enum$__DirectiveLocation.ENUM;
    case r'ENUM_VALUE':
      return Enum$__DirectiveLocation.ENUM_VALUE;
    case r'INPUT_OBJECT':
      return Enum$__DirectiveLocation.INPUT_OBJECT;
    case r'INPUT_FIELD_DEFINITION':
      return Enum$__DirectiveLocation.INPUT_FIELD_DEFINITION;
    default:
      return Enum$__DirectiveLocation.$unknown;
  }
}

const possibleTypesMap = <String, Set<String>>{
  'SearchResult': {
    'Movie',
    'Show',
    'Episode',
    'Person',
    'Album',
    'Track',
    'Book',
    'Podcast',
  },
};

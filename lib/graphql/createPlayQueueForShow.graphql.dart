import 'package:gql/ast.dart';

class Variables$Mutation$createPlayQueueForShow {
  factory Variables$Mutation$createPlayQueueForShow({
    required String id,
    required String episodeId,
  }) =>
      Variables$Mutation$createPlayQueueForShow._({
        r'id': id,
        r'episodeId': episodeId,
      });

  Variables$Mutation$createPlayQueueForShow._(this._$data);

  factory Variables$Mutation$createPlayQueueForShow.fromJson(
      Map<String, dynamic> data) {
    final result$data = <String, dynamic>{};
    final l$id = data['id'];
    result$data['id'] = (l$id as String);
    final l$episodeId = data['episodeId'];
    result$data['episodeId'] = (l$episodeId as String);
    return Variables$Mutation$createPlayQueueForShow._(result$data);
  }

  Map<String, dynamic> _$data;

  String get id => (_$data['id'] as String);

  String get episodeId => (_$data['episodeId'] as String);

  Map<String, dynamic> toJson() {
    final result$data = <String, dynamic>{};
    final l$id = id;
    result$data['id'] = l$id;
    final l$episodeId = episodeId;
    result$data['episodeId'] = l$episodeId;
    return result$data;
  }

  CopyWith$Variables$Mutation$createPlayQueueForShow<
          Variables$Mutation$createPlayQueueForShow>
      get copyWith => CopyWith$Variables$Mutation$createPlayQueueForShow(
            this,
            (i) => i,
          );

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Variables$Mutation$createPlayQueueForShow ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$id = id;
    final lOther$id = other.id;
    if (l$id != lOther$id) {
      return false;
    }
    final l$episodeId = episodeId;
    final lOther$episodeId = other.episodeId;
    if (l$episodeId != lOther$episodeId) {
      return false;
    }
    return true;
  }

  @override
  int get hashCode {
    final l$id = id;
    final l$episodeId = episodeId;
    return Object.hashAll([
      l$id,
      l$episodeId,
    ]);
  }
}

abstract class CopyWith$Variables$Mutation$createPlayQueueForShow<TRes> {
  factory CopyWith$Variables$Mutation$createPlayQueueForShow(
    Variables$Mutation$createPlayQueueForShow instance,
    TRes Function(Variables$Mutation$createPlayQueueForShow) then,
  ) = _CopyWithImpl$Variables$Mutation$createPlayQueueForShow;

  factory CopyWith$Variables$Mutation$createPlayQueueForShow.stub(TRes res) =
      _CopyWithStubImpl$Variables$Mutation$createPlayQueueForShow;

  TRes call({
    String? id,
    String? episodeId,
  });
}

class _CopyWithImpl$Variables$Mutation$createPlayQueueForShow<TRes>
    implements CopyWith$Variables$Mutation$createPlayQueueForShow<TRes> {
  _CopyWithImpl$Variables$Mutation$createPlayQueueForShow(
    this._instance,
    this._then,
  );

  final Variables$Mutation$createPlayQueueForShow _instance;

  final TRes Function(Variables$Mutation$createPlayQueueForShow) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? id = _undefined,
    Object? episodeId = _undefined,
  }) =>
      _then(Variables$Mutation$createPlayQueueForShow._({
        ..._instance._$data,
        if (id != _undefined && id != null) 'id': (id as String),
        if (episodeId != _undefined && episodeId != null)
          'episodeId': (episodeId as String),
      }));
}

class _CopyWithStubImpl$Variables$Mutation$createPlayQueueForShow<TRes>
    implements CopyWith$Variables$Mutation$createPlayQueueForShow<TRes> {
  _CopyWithStubImpl$Variables$Mutation$createPlayQueueForShow(this._res);

  TRes _res;

  call({
    String? id,
    String? episodeId,
  }) =>
      _res;
}

class Mutation$createPlayQueueForShow {
  Mutation$createPlayQueueForShow({
    this.createPlayQueueForShow,
    this.$__typename = 'Mutation',
  });

  factory Mutation$createPlayQueueForShow.fromJson(Map<String, dynamic> json) {
    final l$createPlayQueueForShow = json['createPlayQueueForShow'];
    final l$$__typename = json['__typename'];
    return Mutation$createPlayQueueForShow(
      createPlayQueueForShow: l$createPlayQueueForShow == null
          ? null
          : Mutation$createPlayQueueForShow$createPlayQueueForShow.fromJson(
              (l$createPlayQueueForShow as Map<String, dynamic>)),
      $__typename: (l$$__typename as String),
    );
  }

  final Mutation$createPlayQueueForShow$createPlayQueueForShow?
      createPlayQueueForShow;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$createPlayQueueForShow = createPlayQueueForShow;
    _resultData['createPlayQueueForShow'] = l$createPlayQueueForShow?.toJson();
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$createPlayQueueForShow = createPlayQueueForShow;
    final l$$__typename = $__typename;
    return Object.hashAll([
      l$createPlayQueueForShow,
      l$$__typename,
    ]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Mutation$createPlayQueueForShow ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$createPlayQueueForShow = createPlayQueueForShow;
    final lOther$createPlayQueueForShow = other.createPlayQueueForShow;
    if (l$createPlayQueueForShow != lOther$createPlayQueueForShow) {
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

extension UtilityExtension$Mutation$createPlayQueueForShow
    on Mutation$createPlayQueueForShow {
  CopyWith$Mutation$createPlayQueueForShow<Mutation$createPlayQueueForShow>
      get copyWith => CopyWith$Mutation$createPlayQueueForShow(
            this,
            (i) => i,
          );
}

abstract class CopyWith$Mutation$createPlayQueueForShow<TRes> {
  factory CopyWith$Mutation$createPlayQueueForShow(
    Mutation$createPlayQueueForShow instance,
    TRes Function(Mutation$createPlayQueueForShow) then,
  ) = _CopyWithImpl$Mutation$createPlayQueueForShow;

  factory CopyWith$Mutation$createPlayQueueForShow.stub(TRes res) =
      _CopyWithStubImpl$Mutation$createPlayQueueForShow;

  TRes call({
    Mutation$createPlayQueueForShow$createPlayQueueForShow?
        createPlayQueueForShow,
    String? $__typename,
  });
  CopyWith$Mutation$createPlayQueueForShow$createPlayQueueForShow<TRes>
      get createPlayQueueForShow;
}

class _CopyWithImpl$Mutation$createPlayQueueForShow<TRes>
    implements CopyWith$Mutation$createPlayQueueForShow<TRes> {
  _CopyWithImpl$Mutation$createPlayQueueForShow(
    this._instance,
    this._then,
  );

  final Mutation$createPlayQueueForShow _instance;

  final TRes Function(Mutation$createPlayQueueForShow) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? createPlayQueueForShow = _undefined,
    Object? $__typename = _undefined,
  }) =>
      _then(Mutation$createPlayQueueForShow(
        createPlayQueueForShow: createPlayQueueForShow == _undefined
            ? _instance.createPlayQueueForShow
            : (createPlayQueueForShow
                as Mutation$createPlayQueueForShow$createPlayQueueForShow?),
        $__typename: $__typename == _undefined || $__typename == null
            ? _instance.$__typename
            : ($__typename as String),
      ));

  CopyWith$Mutation$createPlayQueueForShow$createPlayQueueForShow<TRes>
      get createPlayQueueForShow {
    final local$createPlayQueueForShow = _instance.createPlayQueueForShow;
    return local$createPlayQueueForShow == null
        ? CopyWith$Mutation$createPlayQueueForShow$createPlayQueueForShow.stub(
            _then(_instance))
        : CopyWith$Mutation$createPlayQueueForShow$createPlayQueueForShow(
            local$createPlayQueueForShow,
            (e) => call(createPlayQueueForShow: e));
  }
}

class _CopyWithStubImpl$Mutation$createPlayQueueForShow<TRes>
    implements CopyWith$Mutation$createPlayQueueForShow<TRes> {
  _CopyWithStubImpl$Mutation$createPlayQueueForShow(this._res);

  TRes _res;

  call({
    Mutation$createPlayQueueForShow$createPlayQueueForShow?
        createPlayQueueForShow,
    String? $__typename,
  }) =>
      _res;

  CopyWith$Mutation$createPlayQueueForShow$createPlayQueueForShow<TRes>
      get createPlayQueueForShow =>
          CopyWith$Mutation$createPlayQueueForShow$createPlayQueueForShow.stub(
              _res);
}

const documentNodeMutationcreatePlayQueueForShow = DocumentNode(definitions: [
  OperationDefinitionNode(
    type: OperationType.mutation,
    name: NameNode(value: 'createPlayQueueForShow'),
    variableDefinitions: [
      VariableDefinitionNode(
        variable: VariableNode(name: NameNode(value: 'id')),
        type: NamedTypeNode(
          name: NameNode(value: 'ID'),
          isNonNull: true,
        ),
        defaultValue: DefaultValueNode(value: null),
        directives: [],
      ),
      VariableDefinitionNode(
        variable: VariableNode(name: NameNode(value: 'episodeId')),
        type: NamedTypeNode(
          name: NameNode(value: 'ID'),
          isNonNull: true,
        ),
        defaultValue: DefaultValueNode(value: null),
        directives: [],
      ),
    ],
    directives: [],
    selectionSet: SelectionSetNode(selections: [
      FieldNode(
        name: NameNode(value: 'createPlayQueueForShow'),
        alias: null,
        arguments: [
          ArgumentNode(
            name: NameNode(value: 'showId'),
            value: VariableNode(name: NameNode(value: 'id')),
          ),
          ArgumentNode(
            name: NameNode(value: 'episodeId'),
            value: VariableNode(name: NameNode(value: 'episodeId')),
          ),
        ],
        directives: [],
        selectionSet: SelectionSetNode(selections: [
          FieldNode(
            name: NameNode(value: 'id'),
            alias: null,
            arguments: [],
            directives: [],
            selectionSet: null,
          ),
          FieldNode(
            name: NameNode(value: 'playQueueItems'),
            alias: null,
            arguments: [],
            directives: [],
            selectionSet: SelectionSetNode(selections: [
              FieldNode(
                name: NameNode(value: 'id'),
                alias: null,
                arguments: [],
                directives: [],
                selectionSet: null,
              ),
              FieldNode(
                name: NameNode(value: 'itemId'),
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
            ]),
          ),
          FieldNode(
            name: NameNode(value: 'currentItem'),
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
        ]),
      ),
      FieldNode(
        name: NameNode(value: '__typename'),
        alias: null,
        arguments: [],
        directives: [],
        selectionSet: null,
      ),
    ]),
  ),
]);

class Mutation$createPlayQueueForShow$createPlayQueueForShow {
  Mutation$createPlayQueueForShow$createPlayQueueForShow({
    required this.id,
    this.playQueueItems,
    this.currentItem,
    this.$__typename = 'PlayQueue',
  });

  factory Mutation$createPlayQueueForShow$createPlayQueueForShow.fromJson(
      Map<String, dynamic> json) {
    final l$id = json['id'];
    final l$playQueueItems = json['playQueueItems'];
    final l$currentItem = json['currentItem'];
    final l$$__typename = json['__typename'];
    return Mutation$createPlayQueueForShow$createPlayQueueForShow(
      id: (l$id as String),
      playQueueItems: (l$playQueueItems as List<dynamic>?)
          ?.map((e) =>
              Mutation$createPlayQueueForShow$createPlayQueueForShow$playQueueItems
                  .fromJson((e as Map<String, dynamic>)))
          .toList(),
      currentItem: (l$currentItem as String?),
      $__typename: (l$$__typename as String),
    );
  }

  final String id;

  final List<
          Mutation$createPlayQueueForShow$createPlayQueueForShow$playQueueItems>?
      playQueueItems;

  final String? currentItem;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$id = id;
    _resultData['id'] = l$id;
    final l$playQueueItems = playQueueItems;
    _resultData['playQueueItems'] =
        l$playQueueItems?.map((e) => e.toJson()).toList();
    final l$currentItem = currentItem;
    _resultData['currentItem'] = l$currentItem;
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$id = id;
    final l$playQueueItems = playQueueItems;
    final l$currentItem = currentItem;
    final l$$__typename = $__typename;
    return Object.hashAll([
      l$id,
      l$playQueueItems == null
          ? null
          : Object.hashAll(l$playQueueItems.map((v) => v)),
      l$currentItem,
      l$$__typename,
    ]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Mutation$createPlayQueueForShow$createPlayQueueForShow ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$id = id;
    final lOther$id = other.id;
    if (l$id != lOther$id) {
      return false;
    }
    final l$playQueueItems = playQueueItems;
    final lOther$playQueueItems = other.playQueueItems;
    if (l$playQueueItems != null && lOther$playQueueItems != null) {
      if (l$playQueueItems.length != lOther$playQueueItems.length) {
        return false;
      }
      for (int i = 0; i < l$playQueueItems.length; i++) {
        final l$playQueueItems$entry = l$playQueueItems[i];
        final lOther$playQueueItems$entry = lOther$playQueueItems[i];
        if (l$playQueueItems$entry != lOther$playQueueItems$entry) {
          return false;
        }
      }
    } else if (l$playQueueItems != lOther$playQueueItems) {
      return false;
    }
    final l$currentItem = currentItem;
    final lOther$currentItem = other.currentItem;
    if (l$currentItem != lOther$currentItem) {
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

extension UtilityExtension$Mutation$createPlayQueueForShow$createPlayQueueForShow
    on Mutation$createPlayQueueForShow$createPlayQueueForShow {
  CopyWith$Mutation$createPlayQueueForShow$createPlayQueueForShow<
          Mutation$createPlayQueueForShow$createPlayQueueForShow>
      get copyWith =>
          CopyWith$Mutation$createPlayQueueForShow$createPlayQueueForShow(
            this,
            (i) => i,
          );
}

abstract class CopyWith$Mutation$createPlayQueueForShow$createPlayQueueForShow<
    TRes> {
  factory CopyWith$Mutation$createPlayQueueForShow$createPlayQueueForShow(
    Mutation$createPlayQueueForShow$createPlayQueueForShow instance,
    TRes Function(Mutation$createPlayQueueForShow$createPlayQueueForShow) then,
  ) = _CopyWithImpl$Mutation$createPlayQueueForShow$createPlayQueueForShow;

  factory CopyWith$Mutation$createPlayQueueForShow$createPlayQueueForShow.stub(
          TRes res) =
      _CopyWithStubImpl$Mutation$createPlayQueueForShow$createPlayQueueForShow;

  TRes call({
    String? id,
    List<Mutation$createPlayQueueForShow$createPlayQueueForShow$playQueueItems>?
        playQueueItems,
    String? currentItem,
    String? $__typename,
  });
  TRes playQueueItems(
      Iterable<Mutation$createPlayQueueForShow$createPlayQueueForShow$playQueueItems>? Function(
              Iterable<
                  CopyWith$Mutation$createPlayQueueForShow$createPlayQueueForShow$playQueueItems<
                      Mutation$createPlayQueueForShow$createPlayQueueForShow$playQueueItems>>?)
          _fn);
}

class _CopyWithImpl$Mutation$createPlayQueueForShow$createPlayQueueForShow<TRes>
    implements
        CopyWith$Mutation$createPlayQueueForShow$createPlayQueueForShow<TRes> {
  _CopyWithImpl$Mutation$createPlayQueueForShow$createPlayQueueForShow(
    this._instance,
    this._then,
  );

  final Mutation$createPlayQueueForShow$createPlayQueueForShow _instance;

  final TRes Function(Mutation$createPlayQueueForShow$createPlayQueueForShow)
      _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? id = _undefined,
    Object? playQueueItems = _undefined,
    Object? currentItem = _undefined,
    Object? $__typename = _undefined,
  }) =>
      _then(Mutation$createPlayQueueForShow$createPlayQueueForShow(
        id: id == _undefined || id == null ? _instance.id : (id as String),
        playQueueItems: playQueueItems == _undefined
            ? _instance.playQueueItems
            : (playQueueItems as List<
                Mutation$createPlayQueueForShow$createPlayQueueForShow$playQueueItems>?),
        currentItem: currentItem == _undefined
            ? _instance.currentItem
            : (currentItem as String?),
        $__typename: $__typename == _undefined || $__typename == null
            ? _instance.$__typename
            : ($__typename as String),
      ));

  TRes playQueueItems(
          Iterable<Mutation$createPlayQueueForShow$createPlayQueueForShow$playQueueItems>? Function(
                  Iterable<
                      CopyWith$Mutation$createPlayQueueForShow$createPlayQueueForShow$playQueueItems<
                          Mutation$createPlayQueueForShow$createPlayQueueForShow$playQueueItems>>?)
              _fn) =>
      call(
          playQueueItems: _fn(_instance.playQueueItems?.map((e) =>
              CopyWith$Mutation$createPlayQueueForShow$createPlayQueueForShow$playQueueItems(
                e,
                (i) => i,
              )))?.toList());
}

class _CopyWithStubImpl$Mutation$createPlayQueueForShow$createPlayQueueForShow<
        TRes>
    implements
        CopyWith$Mutation$createPlayQueueForShow$createPlayQueueForShow<TRes> {
  _CopyWithStubImpl$Mutation$createPlayQueueForShow$createPlayQueueForShow(
      this._res);

  TRes _res;

  call({
    String? id,
    List<Mutation$createPlayQueueForShow$createPlayQueueForShow$playQueueItems>?
        playQueueItems,
    String? currentItem,
    String? $__typename,
  }) =>
      _res;

  playQueueItems(_fn) => _res;
}

class Mutation$createPlayQueueForShow$createPlayQueueForShow$playQueueItems {
  Mutation$createPlayQueueForShow$createPlayQueueForShow$playQueueItems({
    required this.id,
    required this.itemId,
    this.$__typename = 'PlayQueueItem',
  });

  factory Mutation$createPlayQueueForShow$createPlayQueueForShow$playQueueItems.fromJson(
      Map<String, dynamic> json) {
    final l$id = json['id'];
    final l$itemId = json['itemId'];
    final l$$__typename = json['__typename'];
    return Mutation$createPlayQueueForShow$createPlayQueueForShow$playQueueItems(
      id: (l$id as String),
      itemId: (l$itemId as String),
      $__typename: (l$$__typename as String),
    );
  }

  final String id;

  final String itemId;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$id = id;
    _resultData['id'] = l$id;
    final l$itemId = itemId;
    _resultData['itemId'] = l$itemId;
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$id = id;
    final l$itemId = itemId;
    final l$$__typename = $__typename;
    return Object.hashAll([
      l$id,
      l$itemId,
      l$$__typename,
    ]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other
            is! Mutation$createPlayQueueForShow$createPlayQueueForShow$playQueueItems ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$id = id;
    final lOther$id = other.id;
    if (l$id != lOther$id) {
      return false;
    }
    final l$itemId = itemId;
    final lOther$itemId = other.itemId;
    if (l$itemId != lOther$itemId) {
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

extension UtilityExtension$Mutation$createPlayQueueForShow$createPlayQueueForShow$playQueueItems
    on Mutation$createPlayQueueForShow$createPlayQueueForShow$playQueueItems {
  CopyWith$Mutation$createPlayQueueForShow$createPlayQueueForShow$playQueueItems<
          Mutation$createPlayQueueForShow$createPlayQueueForShow$playQueueItems>
      get copyWith =>
          CopyWith$Mutation$createPlayQueueForShow$createPlayQueueForShow$playQueueItems(
            this,
            (i) => i,
          );
}

abstract class CopyWith$Mutation$createPlayQueueForShow$createPlayQueueForShow$playQueueItems<
    TRes> {
  factory CopyWith$Mutation$createPlayQueueForShow$createPlayQueueForShow$playQueueItems(
    Mutation$createPlayQueueForShow$createPlayQueueForShow$playQueueItems
        instance,
    TRes Function(
            Mutation$createPlayQueueForShow$createPlayQueueForShow$playQueueItems)
        then,
  ) = _CopyWithImpl$Mutation$createPlayQueueForShow$createPlayQueueForShow$playQueueItems;

  factory CopyWith$Mutation$createPlayQueueForShow$createPlayQueueForShow$playQueueItems.stub(
          TRes res) =
      _CopyWithStubImpl$Mutation$createPlayQueueForShow$createPlayQueueForShow$playQueueItems;

  TRes call({
    String? id,
    String? itemId,
    String? $__typename,
  });
}

class _CopyWithImpl$Mutation$createPlayQueueForShow$createPlayQueueForShow$playQueueItems<
        TRes>
    implements
        CopyWith$Mutation$createPlayQueueForShow$createPlayQueueForShow$playQueueItems<
            TRes> {
  _CopyWithImpl$Mutation$createPlayQueueForShow$createPlayQueueForShow$playQueueItems(
    this._instance,
    this._then,
  );

  final Mutation$createPlayQueueForShow$createPlayQueueForShow$playQueueItems
      _instance;

  final TRes Function(
          Mutation$createPlayQueueForShow$createPlayQueueForShow$playQueueItems)
      _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? id = _undefined,
    Object? itemId = _undefined,
    Object? $__typename = _undefined,
  }) =>
      _then(
          Mutation$createPlayQueueForShow$createPlayQueueForShow$playQueueItems(
        id: id == _undefined || id == null ? _instance.id : (id as String),
        itemId: itemId == _undefined || itemId == null
            ? _instance.itemId
            : (itemId as String),
        $__typename: $__typename == _undefined || $__typename == null
            ? _instance.$__typename
            : ($__typename as String),
      ));
}

class _CopyWithStubImpl$Mutation$createPlayQueueForShow$createPlayQueueForShow$playQueueItems<
        TRes>
    implements
        CopyWith$Mutation$createPlayQueueForShow$createPlayQueueForShow$playQueueItems<
            TRes> {
  _CopyWithStubImpl$Mutation$createPlayQueueForShow$createPlayQueueForShow$playQueueItems(
      this._res);

  TRes _res;

  call({
    String? id,
    String? itemId,
    String? $__typename,
  }) =>
      _res;
}

import 'fragmentBook.graphql.dart';
import 'fragmentCredit.graphql.dart';
import 'fragmentEpisode.graphql.dart';
import 'fragmentImages.graphql.dart';
import 'fragmentMediafiles.graphql.dart';
import 'fragmentMetadata.graphql.dart';
import 'fragmentMovie.graphql.dart';
import 'fragmentPlaylist.graphql.dart';
import 'fragmentPlaylistItem.graphql.dart';
import 'fragmentWatchStatus.graphql.dart';
import 'package:gql/ast.dart';
import 'schema.graphql.dart';

class Variables$Query$playlists {
  factory Variables$Query$playlists({String? libraryId}) =>
      Variables$Query$playlists._({
        if (libraryId != null) r'libraryId': libraryId,
      });

  Variables$Query$playlists._(this._$data);

  factory Variables$Query$playlists.fromJson(Map<String, dynamic> data) {
    final result$data = <String, dynamic>{};
    if (data.containsKey('libraryId')) {
      final l$libraryId = data['libraryId'];
      result$data['libraryId'] = (l$libraryId as String?);
    }
    return Variables$Query$playlists._(result$data);
  }

  Map<String, dynamic> _$data;

  String? get libraryId => (_$data['libraryId'] as String?);

  Map<String, dynamic> toJson() {
    final result$data = <String, dynamic>{};
    if (_$data.containsKey('libraryId')) {
      final l$libraryId = libraryId;
      result$data['libraryId'] = l$libraryId;
    }
    return result$data;
  }

  CopyWith$Variables$Query$playlists<Variables$Query$playlists> get copyWith =>
      CopyWith$Variables$Query$playlists(this, (i) => i);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Variables$Query$playlists ||
        runtimeType != other.runtimeType) {
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
    final l$libraryId = libraryId;
    return Object.hashAll([
      _$data.containsKey('libraryId') ? l$libraryId : const {},
    ]);
  }
}

abstract class CopyWith$Variables$Query$playlists<TRes> {
  factory CopyWith$Variables$Query$playlists(
    Variables$Query$playlists instance,
    TRes Function(Variables$Query$playlists) then,
  ) = _CopyWithImpl$Variables$Query$playlists;

  factory CopyWith$Variables$Query$playlists.stub(TRes res) =
      _CopyWithStubImpl$Variables$Query$playlists;

  TRes call({String? libraryId});
}

class _CopyWithImpl$Variables$Query$playlists<TRes>
    implements CopyWith$Variables$Query$playlists<TRes> {
  _CopyWithImpl$Variables$Query$playlists(this._instance, this._then);

  final Variables$Query$playlists _instance;

  final TRes Function(Variables$Query$playlists) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({Object? libraryId = _undefined}) => _then(
    Variables$Query$playlists._({
      ..._instance._$data,
      if (libraryId != _undefined) 'libraryId': (libraryId as String?),
    }),
  );
}

class _CopyWithStubImpl$Variables$Query$playlists<TRes>
    implements CopyWith$Variables$Query$playlists<TRes> {
  _CopyWithStubImpl$Variables$Query$playlists(this._res);

  TRes _res;

  call({String? libraryId}) => _res;
}

class Query$playlists {
  Query$playlists({required this.playlists, this.$__typename = 'Query'});

  factory Query$playlists.fromJson(Map<String, dynamic> json) {
    final l$playlists = json['playlists'];
    final l$$__typename = json['__typename'];
    return Query$playlists(
      playlists: (l$playlists as List<dynamic>)
          .map(
            (e) =>
                Fragment$fragmentPlaylist.fromJson((e as Map<String, dynamic>)),
          )
          .toList(),
      $__typename: (l$$__typename as String),
    );
  }

  final List<Fragment$fragmentPlaylist> playlists;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$playlists = playlists;
    _resultData['playlists'] = l$playlists.map((e) => e.toJson()).toList();
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$playlists = playlists;
    final l$$__typename = $__typename;
    return Object.hashAll([
      Object.hashAll(l$playlists.map((v) => v)),
      l$$__typename,
    ]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Query$playlists || runtimeType != other.runtimeType) {
      return false;
    }
    final l$playlists = playlists;
    final lOther$playlists = other.playlists;
    if (l$playlists.length != lOther$playlists.length) {
      return false;
    }
    for (int i = 0; i < l$playlists.length; i++) {
      final l$playlists$entry = l$playlists[i];
      final lOther$playlists$entry = lOther$playlists[i];
      if (l$playlists$entry != lOther$playlists$entry) {
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

extension UtilityExtension$Query$playlists on Query$playlists {
  CopyWith$Query$playlists<Query$playlists> get copyWith =>
      CopyWith$Query$playlists(this, (i) => i);
}

abstract class CopyWith$Query$playlists<TRes> {
  factory CopyWith$Query$playlists(
    Query$playlists instance,
    TRes Function(Query$playlists) then,
  ) = _CopyWithImpl$Query$playlists;

  factory CopyWith$Query$playlists.stub(TRes res) =
      _CopyWithStubImpl$Query$playlists;

  TRes call({List<Fragment$fragmentPlaylist>? playlists, String? $__typename});
  TRes playlists(
    Iterable<Fragment$fragmentPlaylist> Function(
      Iterable<CopyWith$Fragment$fragmentPlaylist<Fragment$fragmentPlaylist>>,
    )
    _fn,
  );
}

class _CopyWithImpl$Query$playlists<TRes>
    implements CopyWith$Query$playlists<TRes> {
  _CopyWithImpl$Query$playlists(this._instance, this._then);

  final Query$playlists _instance;

  final TRes Function(Query$playlists) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? playlists = _undefined,
    Object? $__typename = _undefined,
  }) => _then(
    Query$playlists(
      playlists: playlists == _undefined || playlists == null
          ? _instance.playlists
          : (playlists as List<Fragment$fragmentPlaylist>),
      $__typename: $__typename == _undefined || $__typename == null
          ? _instance.$__typename
          : ($__typename as String),
    ),
  );

  TRes playlists(
    Iterable<Fragment$fragmentPlaylist> Function(
      Iterable<CopyWith$Fragment$fragmentPlaylist<Fragment$fragmentPlaylist>>,
    )
    _fn,
  ) => call(
    playlists: _fn(
      _instance.playlists.map(
        (e) => CopyWith$Fragment$fragmentPlaylist(e, (i) => i),
      ),
    ).toList(),
  );
}

class _CopyWithStubImpl$Query$playlists<TRes>
    implements CopyWith$Query$playlists<TRes> {
  _CopyWithStubImpl$Query$playlists(this._res);

  TRes _res;

  call({List<Fragment$fragmentPlaylist>? playlists, String? $__typename}) =>
      _res;

  playlists(_fn) => _res;
}

const documentNodeQueryplaylists = DocumentNode(
  definitions: [
    OperationDefinitionNode(
      type: OperationType.query,
      name: NameNode(value: 'playlists'),
      variableDefinitions: [
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
            name: NameNode(value: 'playlists'),
            alias: null,
            arguments: [
              ArgumentNode(
                name: NameNode(value: 'libraryId'),
                value: VariableNode(name: NameNode(value: 'libraryId')),
              ),
            ],
            directives: [],
            selectionSet: SelectionSetNode(
              selections: [
                FragmentSpreadNode(
                  name: NameNode(value: 'fragmentPlaylist'),
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
    fragmentDefinitionfragmentPlaylist,
  ],
);

class Variables$Query$playlistById {
  factory Variables$Query$playlistById({required String id}) =>
      Variables$Query$playlistById._({r'id': id});

  Variables$Query$playlistById._(this._$data);

  factory Variables$Query$playlistById.fromJson(Map<String, dynamic> data) {
    final result$data = <String, dynamic>{};
    final l$id = data['id'];
    result$data['id'] = (l$id as String);
    return Variables$Query$playlistById._(result$data);
  }

  Map<String, dynamic> _$data;

  String get id => (_$data['id'] as String);

  Map<String, dynamic> toJson() {
    final result$data = <String, dynamic>{};
    final l$id = id;
    result$data['id'] = l$id;
    return result$data;
  }

  CopyWith$Variables$Query$playlistById<Variables$Query$playlistById>
  get copyWith => CopyWith$Variables$Query$playlistById(this, (i) => i);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Variables$Query$playlistById ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$id = id;
    final lOther$id = other.id;
    if (l$id != lOther$id) {
      return false;
    }
    return true;
  }

  @override
  int get hashCode {
    final l$id = id;
    return Object.hashAll([l$id]);
  }
}

abstract class CopyWith$Variables$Query$playlistById<TRes> {
  factory CopyWith$Variables$Query$playlistById(
    Variables$Query$playlistById instance,
    TRes Function(Variables$Query$playlistById) then,
  ) = _CopyWithImpl$Variables$Query$playlistById;

  factory CopyWith$Variables$Query$playlistById.stub(TRes res) =
      _CopyWithStubImpl$Variables$Query$playlistById;

  TRes call({String? id});
}

class _CopyWithImpl$Variables$Query$playlistById<TRes>
    implements CopyWith$Variables$Query$playlistById<TRes> {
  _CopyWithImpl$Variables$Query$playlistById(this._instance, this._then);

  final Variables$Query$playlistById _instance;

  final TRes Function(Variables$Query$playlistById) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({Object? id = _undefined}) => _then(
    Variables$Query$playlistById._({
      ..._instance._$data,
      if (id != _undefined && id != null) 'id': (id as String),
    }),
  );
}

class _CopyWithStubImpl$Variables$Query$playlistById<TRes>
    implements CopyWith$Variables$Query$playlistById<TRes> {
  _CopyWithStubImpl$Variables$Query$playlistById(this._res);

  TRes _res;

  call({String? id}) => _res;
}

class Query$playlistById {
  Query$playlistById({this.playlistById, this.$__typename = 'Query'});

  factory Query$playlistById.fromJson(Map<String, dynamic> json) {
    final l$playlistById = json['playlistById'];
    final l$$__typename = json['__typename'];
    return Query$playlistById(
      playlistById: l$playlistById == null
          ? null
          : Query$playlistById$playlistById.fromJson(
              (l$playlistById as Map<String, dynamic>),
            ),
      $__typename: (l$$__typename as String),
    );
  }

  final Query$playlistById$playlistById? playlistById;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$playlistById = playlistById;
    _resultData['playlistById'] = l$playlistById?.toJson();
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$playlistById = playlistById;
    final l$$__typename = $__typename;
    return Object.hashAll([l$playlistById, l$$__typename]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Query$playlistById || runtimeType != other.runtimeType) {
      return false;
    }
    final l$playlistById = playlistById;
    final lOther$playlistById = other.playlistById;
    if (l$playlistById != lOther$playlistById) {
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

extension UtilityExtension$Query$playlistById on Query$playlistById {
  CopyWith$Query$playlistById<Query$playlistById> get copyWith =>
      CopyWith$Query$playlistById(this, (i) => i);
}

abstract class CopyWith$Query$playlistById<TRes> {
  factory CopyWith$Query$playlistById(
    Query$playlistById instance,
    TRes Function(Query$playlistById) then,
  ) = _CopyWithImpl$Query$playlistById;

  factory CopyWith$Query$playlistById.stub(TRes res) =
      _CopyWithStubImpl$Query$playlistById;

  TRes call({
    Query$playlistById$playlistById? playlistById,
    String? $__typename,
  });
  CopyWith$Query$playlistById$playlistById<TRes> get playlistById;
}

class _CopyWithImpl$Query$playlistById<TRes>
    implements CopyWith$Query$playlistById<TRes> {
  _CopyWithImpl$Query$playlistById(this._instance, this._then);

  final Query$playlistById _instance;

  final TRes Function(Query$playlistById) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? playlistById = _undefined,
    Object? $__typename = _undefined,
  }) => _then(
    Query$playlistById(
      playlistById: playlistById == _undefined
          ? _instance.playlistById
          : (playlistById as Query$playlistById$playlistById?),
      $__typename: $__typename == _undefined || $__typename == null
          ? _instance.$__typename
          : ($__typename as String),
    ),
  );

  CopyWith$Query$playlistById$playlistById<TRes> get playlistById {
    final local$playlistById = _instance.playlistById;
    return local$playlistById == null
        ? CopyWith$Query$playlistById$playlistById.stub(_then(_instance))
        : CopyWith$Query$playlistById$playlistById(
            local$playlistById,
            (e) => call(playlistById: e),
          );
  }
}

class _CopyWithStubImpl$Query$playlistById<TRes>
    implements CopyWith$Query$playlistById<TRes> {
  _CopyWithStubImpl$Query$playlistById(this._res);

  TRes _res;

  call({Query$playlistById$playlistById? playlistById, String? $__typename}) =>
      _res;

  CopyWith$Query$playlistById$playlistById<TRes> get playlistById =>
      CopyWith$Query$playlistById$playlistById.stub(_res);
}

const documentNodeQueryplaylistById = DocumentNode(
  definitions: [
    OperationDefinitionNode(
      type: OperationType.query,
      name: NameNode(value: 'playlistById'),
      variableDefinitions: [
        VariableDefinitionNode(
          variable: VariableNode(name: NameNode(value: 'id')),
          type: NamedTypeNode(name: NameNode(value: 'ID'), isNonNull: true),
          defaultValue: DefaultValueNode(value: null),
          directives: [],
        ),
      ],
      directives: [],
      selectionSet: SelectionSetNode(
        selections: [
          FieldNode(
            name: NameNode(value: 'playlistById'),
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
                  name: NameNode(value: 'fragmentPlaylist'),
                  directives: [],
                ),
                FieldNode(
                  name: NameNode(value: 'items'),
                  alias: null,
                  arguments: [],
                  directives: [],
                  selectionSet: SelectionSetNode(
                    selections: [
                      FragmentSpreadNode(
                        name: NameNode(value: 'fragmentPlaylistItem'),
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
    fragmentDefinitionfragmentPlaylist,
    fragmentDefinitionfragmentPlaylistItem,
    fragmentDefinitionfragmentEpisode,
    fragmentDefinitionfragmentMetadata,
    fragmentDefinitionfragmentImages,
    fragmentDefinitionfragmentMediaFiles,
    fragmentDefinitionfragmentCastMember,
    fragmentDefinitionfragmentMovie,
    fragmentDefinitionfragmentBook,
    fragmentDefinitionfragmentWatchStatus,
  ],
);

class Query$playlistById$playlistById implements Fragment$fragmentPlaylist {
  Query$playlistById$playlistById({
    required this.id,
    required this.name,
    required this.type,
    required this.libraryId,
    required this.libraryType,
    this.itemCount,
    this.filterKind,
    this.sorting,
    this.sortingOrder,
    this.filter,
    this.$__typename = 'Playlist',
    required this.items,
  });

  factory Query$playlistById$playlistById.fromJson(Map<String, dynamic> json) {
    final l$id = json['id'];
    final l$name = json['name'];
    final l$type = json['type'];
    final l$libraryId = json['libraryId'];
    final l$libraryType = json['libraryType'];
    final l$itemCount = json['itemCount'];
    final l$filterKind = json['filterKind'];
    final l$sorting = json['sorting'];
    final l$sortingOrder = json['sortingOrder'];
    final l$filter = json['filter'];
    final l$$__typename = json['__typename'];
    final l$items = json['items'];
    return Query$playlistById$playlistById(
      id: (l$id as String),
      name: (l$name as String),
      type: fromJson$Enum$PlaylistType((l$type as String)),
      libraryId: (l$libraryId as String),
      libraryType: fromJson$Enum$LibraryType((l$libraryType as String)),
      itemCount: (l$itemCount as int?),
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
          : Query$playlistById$playlistById$filter.fromJson(
              (l$filter as Map<String, dynamic>),
            ),
      $__typename: (l$$__typename as String),
      items: (l$items as List<dynamic>)
          .map(
            (e) => Fragment$fragmentPlaylistItem.fromJson(
              (e as Map<String, dynamic>),
            ),
          )
          .toList(),
    );
  }

  final String id;

  final String name;

  final Enum$PlaylistType type;

  final String libraryId;

  final Enum$LibraryType libraryType;

  final int? itemCount;

  final Enum$FilterKind? filterKind;

  final Enum$SortingEnum? sorting;

  final Enum$SortingOrder? sortingOrder;

  final Query$playlistById$playlistById$filter? filter;

  final String $__typename;

  final List<Fragment$fragmentPlaylistItem> items;

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
    final l$items = items;
    _resultData['items'] = l$items.map((e) => e.toJson()).toList();
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
    final l$filterKind = filterKind;
    final l$sorting = sorting;
    final l$sortingOrder = sortingOrder;
    final l$filter = filter;
    final l$$__typename = $__typename;
    final l$items = items;
    return Object.hashAll([
      l$id,
      l$name,
      l$type,
      l$libraryId,
      l$libraryType,
      l$itemCount,
      l$filterKind,
      l$sorting,
      l$sortingOrder,
      l$filter,
      l$$__typename,
      Object.hashAll(l$items.map((v) => v)),
    ]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Query$playlistById$playlistById ||
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
    final l$items = items;
    final lOther$items = other.items;
    if (l$items.length != lOther$items.length) {
      return false;
    }
    for (int i = 0; i < l$items.length; i++) {
      final l$items$entry = l$items[i];
      final lOther$items$entry = lOther$items[i];
      if (l$items$entry != lOther$items$entry) {
        return false;
      }
    }
    return true;
  }
}

extension UtilityExtension$Query$playlistById$playlistById
    on Query$playlistById$playlistById {
  CopyWith$Query$playlistById$playlistById<Query$playlistById$playlistById>
  get copyWith => CopyWith$Query$playlistById$playlistById(this, (i) => i);
}

abstract class CopyWith$Query$playlistById$playlistById<TRes> {
  factory CopyWith$Query$playlistById$playlistById(
    Query$playlistById$playlistById instance,
    TRes Function(Query$playlistById$playlistById) then,
  ) = _CopyWithImpl$Query$playlistById$playlistById;

  factory CopyWith$Query$playlistById$playlistById.stub(TRes res) =
      _CopyWithStubImpl$Query$playlistById$playlistById;

  TRes call({
    String? id,
    String? name,
    Enum$PlaylistType? type,
    String? libraryId,
    Enum$LibraryType? libraryType,
    int? itemCount,
    Enum$FilterKind? filterKind,
    Enum$SortingEnum? sorting,
    Enum$SortingOrder? sortingOrder,
    Query$playlistById$playlistById$filter? filter,
    String? $__typename,
    List<Fragment$fragmentPlaylistItem>? items,
  });
  CopyWith$Query$playlistById$playlistById$filter<TRes> get filter;
  TRes items(
    Iterable<Fragment$fragmentPlaylistItem> Function(
      Iterable<
        CopyWith$Fragment$fragmentPlaylistItem<Fragment$fragmentPlaylistItem>
      >,
    )
    _fn,
  );
}

class _CopyWithImpl$Query$playlistById$playlistById<TRes>
    implements CopyWith$Query$playlistById$playlistById<TRes> {
  _CopyWithImpl$Query$playlistById$playlistById(this._instance, this._then);

  final Query$playlistById$playlistById _instance;

  final TRes Function(Query$playlistById$playlistById) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? id = _undefined,
    Object? name = _undefined,
    Object? type = _undefined,
    Object? libraryId = _undefined,
    Object? libraryType = _undefined,
    Object? itemCount = _undefined,
    Object? filterKind = _undefined,
    Object? sorting = _undefined,
    Object? sortingOrder = _undefined,
    Object? filter = _undefined,
    Object? $__typename = _undefined,
    Object? items = _undefined,
  }) => _then(
    Query$playlistById$playlistById(
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
          : (filter as Query$playlistById$playlistById$filter?),
      $__typename: $__typename == _undefined || $__typename == null
          ? _instance.$__typename
          : ($__typename as String),
      items: items == _undefined || items == null
          ? _instance.items
          : (items as List<Fragment$fragmentPlaylistItem>),
    ),
  );

  CopyWith$Query$playlistById$playlistById$filter<TRes> get filter {
    final local$filter = _instance.filter;
    return local$filter == null
        ? CopyWith$Query$playlistById$playlistById$filter.stub(_then(_instance))
        : CopyWith$Query$playlistById$playlistById$filter(
            local$filter,
            (e) => call(filter: e),
          );
  }

  TRes items(
    Iterable<Fragment$fragmentPlaylistItem> Function(
      Iterable<
        CopyWith$Fragment$fragmentPlaylistItem<Fragment$fragmentPlaylistItem>
      >,
    )
    _fn,
  ) => call(
    items: _fn(
      _instance.items.map(
        (e) => CopyWith$Fragment$fragmentPlaylistItem(e, (i) => i),
      ),
    ).toList(),
  );
}

class _CopyWithStubImpl$Query$playlistById$playlistById<TRes>
    implements CopyWith$Query$playlistById$playlistById<TRes> {
  _CopyWithStubImpl$Query$playlistById$playlistById(this._res);

  TRes _res;

  call({
    String? id,
    String? name,
    Enum$PlaylistType? type,
    String? libraryId,
    Enum$LibraryType? libraryType,
    int? itemCount,
    Enum$FilterKind? filterKind,
    Enum$SortingEnum? sorting,
    Enum$SortingOrder? sortingOrder,
    Query$playlistById$playlistById$filter? filter,
    String? $__typename,
    List<Fragment$fragmentPlaylistItem>? items,
  }) => _res;

  CopyWith$Query$playlistById$playlistById$filter<TRes> get filter =>
      CopyWith$Query$playlistById$playlistById$filter.stub(_res);

  items(_fn) => _res;
}

class Query$playlistById$playlistById$filter
    implements Fragment$fragmentPlaylist$filter {
  Query$playlistById$playlistById$filter({
    required this.match,
    this.limit,
    required this.conditions,
    required this.groups,
    this.$__typename = 'FilterGroup',
  });

  factory Query$playlistById$playlistById$filter.fromJson(
    Map<String, dynamic> json,
  ) {
    final l$match = json['match'];
    final l$limit = json['limit'];
    final l$conditions = json['conditions'];
    final l$groups = json['groups'];
    final l$$__typename = json['__typename'];
    return Query$playlistById$playlistById$filter(
      match: fromJson$Enum$FilterMatch((l$match as String)),
      limit: (l$limit as int?),
      conditions: (l$conditions as List<dynamic>)
          .map(
            (e) => Query$playlistById$playlistById$filter$conditions.fromJson(
              (e as Map<String, dynamic>),
            ),
          )
          .toList(),
      groups: (l$groups as List<dynamic>)
          .map(
            (e) => Query$playlistById$playlistById$filter$groups.fromJson(
              (e as Map<String, dynamic>),
            ),
          )
          .toList(),
      $__typename: (l$$__typename as String),
    );
  }

  final Enum$FilterMatch match;

  final int? limit;

  final List<Query$playlistById$playlistById$filter$conditions> conditions;

  final List<Query$playlistById$playlistById$filter$groups> groups;

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
    if (other is! Query$playlistById$playlistById$filter ||
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

extension UtilityExtension$Query$playlistById$playlistById$filter
    on Query$playlistById$playlistById$filter {
  CopyWith$Query$playlistById$playlistById$filter<
    Query$playlistById$playlistById$filter
  >
  get copyWith =>
      CopyWith$Query$playlistById$playlistById$filter(this, (i) => i);
}

abstract class CopyWith$Query$playlistById$playlistById$filter<TRes> {
  factory CopyWith$Query$playlistById$playlistById$filter(
    Query$playlistById$playlistById$filter instance,
    TRes Function(Query$playlistById$playlistById$filter) then,
  ) = _CopyWithImpl$Query$playlistById$playlistById$filter;

  factory CopyWith$Query$playlistById$playlistById$filter.stub(TRes res) =
      _CopyWithStubImpl$Query$playlistById$playlistById$filter;

  TRes call({
    Enum$FilterMatch? match,
    int? limit,
    List<Query$playlistById$playlistById$filter$conditions>? conditions,
    List<Query$playlistById$playlistById$filter$groups>? groups,
    String? $__typename,
  });
  TRes conditions(
    Iterable<Query$playlistById$playlistById$filter$conditions> Function(
      Iterable<
        CopyWith$Query$playlistById$playlistById$filter$conditions<
          Query$playlistById$playlistById$filter$conditions
        >
      >,
    )
    _fn,
  );
  TRes groups(
    Iterable<Query$playlistById$playlistById$filter$groups> Function(
      Iterable<
        CopyWith$Query$playlistById$playlistById$filter$groups<
          Query$playlistById$playlistById$filter$groups
        >
      >,
    )
    _fn,
  );
}

class _CopyWithImpl$Query$playlistById$playlistById$filter<TRes>
    implements CopyWith$Query$playlistById$playlistById$filter<TRes> {
  _CopyWithImpl$Query$playlistById$playlistById$filter(
    this._instance,
    this._then,
  );

  final Query$playlistById$playlistById$filter _instance;

  final TRes Function(Query$playlistById$playlistById$filter) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? match = _undefined,
    Object? limit = _undefined,
    Object? conditions = _undefined,
    Object? groups = _undefined,
    Object? $__typename = _undefined,
  }) => _then(
    Query$playlistById$playlistById$filter(
      match: match == _undefined || match == null
          ? _instance.match
          : (match as Enum$FilterMatch),
      limit: limit == _undefined ? _instance.limit : (limit as int?),
      conditions: conditions == _undefined || conditions == null
          ? _instance.conditions
          : (conditions
                as List<Query$playlistById$playlistById$filter$conditions>),
      groups: groups == _undefined || groups == null
          ? _instance.groups
          : (groups as List<Query$playlistById$playlistById$filter$groups>),
      $__typename: $__typename == _undefined || $__typename == null
          ? _instance.$__typename
          : ($__typename as String),
    ),
  );

  TRes conditions(
    Iterable<Query$playlistById$playlistById$filter$conditions> Function(
      Iterable<
        CopyWith$Query$playlistById$playlistById$filter$conditions<
          Query$playlistById$playlistById$filter$conditions
        >
      >,
    )
    _fn,
  ) => call(
    conditions: _fn(
      _instance.conditions.map(
        (e) => CopyWith$Query$playlistById$playlistById$filter$conditions(
          e,
          (i) => i,
        ),
      ),
    ).toList(),
  );

  TRes groups(
    Iterable<Query$playlistById$playlistById$filter$groups> Function(
      Iterable<
        CopyWith$Query$playlistById$playlistById$filter$groups<
          Query$playlistById$playlistById$filter$groups
        >
      >,
    )
    _fn,
  ) => call(
    groups: _fn(
      _instance.groups.map(
        (e) =>
            CopyWith$Query$playlistById$playlistById$filter$groups(e, (i) => i),
      ),
    ).toList(),
  );
}

class _CopyWithStubImpl$Query$playlistById$playlistById$filter<TRes>
    implements CopyWith$Query$playlistById$playlistById$filter<TRes> {
  _CopyWithStubImpl$Query$playlistById$playlistById$filter(this._res);

  TRes _res;

  call({
    Enum$FilterMatch? match,
    int? limit,
    List<Query$playlistById$playlistById$filter$conditions>? conditions,
    List<Query$playlistById$playlistById$filter$groups>? groups,
    String? $__typename,
  }) => _res;

  conditions(_fn) => _res;

  groups(_fn) => _res;
}

class Query$playlistById$playlistById$filter$conditions
    implements Fragment$fragmentPlaylist$filter$conditions {
  Query$playlistById$playlistById$filter$conditions({
    required this.field,
    required this.$operator,
    this.value,
    this.$__typename = 'FilterConditionValue',
  });

  factory Query$playlistById$playlistById$filter$conditions.fromJson(
    Map<String, dynamic> json,
  ) {
    final l$field = json['field'];
    final l$$operator = json['operator'];
    final l$value = json['value'];
    final l$$__typename = json['__typename'];
    return Query$playlistById$playlistById$filter$conditions(
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
    if (other is! Query$playlistById$playlistById$filter$conditions ||
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

extension UtilityExtension$Query$playlistById$playlistById$filter$conditions
    on Query$playlistById$playlistById$filter$conditions {
  CopyWith$Query$playlistById$playlistById$filter$conditions<
    Query$playlistById$playlistById$filter$conditions
  >
  get copyWith => CopyWith$Query$playlistById$playlistById$filter$conditions(
    this,
    (i) => i,
  );
}

abstract class CopyWith$Query$playlistById$playlistById$filter$conditions<
  TRes
> {
  factory CopyWith$Query$playlistById$playlistById$filter$conditions(
    Query$playlistById$playlistById$filter$conditions instance,
    TRes Function(Query$playlistById$playlistById$filter$conditions) then,
  ) = _CopyWithImpl$Query$playlistById$playlistById$filter$conditions;

  factory CopyWith$Query$playlistById$playlistById$filter$conditions.stub(
    TRes res,
  ) = _CopyWithStubImpl$Query$playlistById$playlistById$filter$conditions;

  TRes call({
    Enum$FilterField? field,
    Enum$FilterOperator? $operator,
    String? value,
    String? $__typename,
  });
}

class _CopyWithImpl$Query$playlistById$playlistById$filter$conditions<TRes>
    implements
        CopyWith$Query$playlistById$playlistById$filter$conditions<TRes> {
  _CopyWithImpl$Query$playlistById$playlistById$filter$conditions(
    this._instance,
    this._then,
  );

  final Query$playlistById$playlistById$filter$conditions _instance;

  final TRes Function(Query$playlistById$playlistById$filter$conditions) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? field = _undefined,
    Object? $operator = _undefined,
    Object? value = _undefined,
    Object? $__typename = _undefined,
  }) => _then(
    Query$playlistById$playlistById$filter$conditions(
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

class _CopyWithStubImpl$Query$playlistById$playlistById$filter$conditions<TRes>
    implements
        CopyWith$Query$playlistById$playlistById$filter$conditions<TRes> {
  _CopyWithStubImpl$Query$playlistById$playlistById$filter$conditions(
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

class Query$playlistById$playlistById$filter$groups
    implements Fragment$fragmentPlaylist$filter$groups {
  Query$playlistById$playlistById$filter$groups({
    required this.match,
    required this.conditions,
    required this.groups,
    this.$__typename = 'FilterGroup',
  });

  factory Query$playlistById$playlistById$filter$groups.fromJson(
    Map<String, dynamic> json,
  ) {
    final l$match = json['match'];
    final l$conditions = json['conditions'];
    final l$groups = json['groups'];
    final l$$__typename = json['__typename'];
    return Query$playlistById$playlistById$filter$groups(
      match: fromJson$Enum$FilterMatch((l$match as String)),
      conditions: (l$conditions as List<dynamic>)
          .map(
            (e) =>
                Query$playlistById$playlistById$filter$groups$conditions.fromJson(
                  (e as Map<String, dynamic>),
                ),
          )
          .toList(),
      groups: (l$groups as List<dynamic>)
          .map(
            (e) =>
                Query$playlistById$playlistById$filter$groups$groups.fromJson(
                  (e as Map<String, dynamic>),
                ),
          )
          .toList(),
      $__typename: (l$$__typename as String),
    );
  }

  final Enum$FilterMatch match;

  final List<Query$playlistById$playlistById$filter$groups$conditions>
  conditions;

  final List<Query$playlistById$playlistById$filter$groups$groups> groups;

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
    if (other is! Query$playlistById$playlistById$filter$groups ||
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

extension UtilityExtension$Query$playlistById$playlistById$filter$groups
    on Query$playlistById$playlistById$filter$groups {
  CopyWith$Query$playlistById$playlistById$filter$groups<
    Query$playlistById$playlistById$filter$groups
  >
  get copyWith =>
      CopyWith$Query$playlistById$playlistById$filter$groups(this, (i) => i);
}

abstract class CopyWith$Query$playlistById$playlistById$filter$groups<TRes> {
  factory CopyWith$Query$playlistById$playlistById$filter$groups(
    Query$playlistById$playlistById$filter$groups instance,
    TRes Function(Query$playlistById$playlistById$filter$groups) then,
  ) = _CopyWithImpl$Query$playlistById$playlistById$filter$groups;

  factory CopyWith$Query$playlistById$playlistById$filter$groups.stub(
    TRes res,
  ) = _CopyWithStubImpl$Query$playlistById$playlistById$filter$groups;

  TRes call({
    Enum$FilterMatch? match,
    List<Query$playlistById$playlistById$filter$groups$conditions>? conditions,
    List<Query$playlistById$playlistById$filter$groups$groups>? groups,
    String? $__typename,
  });
  TRes conditions(
    Iterable<Query$playlistById$playlistById$filter$groups$conditions> Function(
      Iterable<
        CopyWith$Query$playlistById$playlistById$filter$groups$conditions<
          Query$playlistById$playlistById$filter$groups$conditions
        >
      >,
    )
    _fn,
  );
  TRes groups(
    Iterable<Query$playlistById$playlistById$filter$groups$groups> Function(
      Iterable<
        CopyWith$Query$playlistById$playlistById$filter$groups$groups<
          Query$playlistById$playlistById$filter$groups$groups
        >
      >,
    )
    _fn,
  );
}

class _CopyWithImpl$Query$playlistById$playlistById$filter$groups<TRes>
    implements CopyWith$Query$playlistById$playlistById$filter$groups<TRes> {
  _CopyWithImpl$Query$playlistById$playlistById$filter$groups(
    this._instance,
    this._then,
  );

  final Query$playlistById$playlistById$filter$groups _instance;

  final TRes Function(Query$playlistById$playlistById$filter$groups) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? match = _undefined,
    Object? conditions = _undefined,
    Object? groups = _undefined,
    Object? $__typename = _undefined,
  }) => _then(
    Query$playlistById$playlistById$filter$groups(
      match: match == _undefined || match == null
          ? _instance.match
          : (match as Enum$FilterMatch),
      conditions: conditions == _undefined || conditions == null
          ? _instance.conditions
          : (conditions
                as List<
                  Query$playlistById$playlistById$filter$groups$conditions
                >),
      groups: groups == _undefined || groups == null
          ? _instance.groups
          : (groups
                as List<Query$playlistById$playlistById$filter$groups$groups>),
      $__typename: $__typename == _undefined || $__typename == null
          ? _instance.$__typename
          : ($__typename as String),
    ),
  );

  TRes conditions(
    Iterable<Query$playlistById$playlistById$filter$groups$conditions> Function(
      Iterable<
        CopyWith$Query$playlistById$playlistById$filter$groups$conditions<
          Query$playlistById$playlistById$filter$groups$conditions
        >
      >,
    )
    _fn,
  ) => call(
    conditions: _fn(
      _instance.conditions.map(
        (e) =>
            CopyWith$Query$playlistById$playlistById$filter$groups$conditions(
              e,
              (i) => i,
            ),
      ),
    ).toList(),
  );

  TRes groups(
    Iterable<Query$playlistById$playlistById$filter$groups$groups> Function(
      Iterable<
        CopyWith$Query$playlistById$playlistById$filter$groups$groups<
          Query$playlistById$playlistById$filter$groups$groups
        >
      >,
    )
    _fn,
  ) => call(
    groups: _fn(
      _instance.groups.map(
        (e) => CopyWith$Query$playlistById$playlistById$filter$groups$groups(
          e,
          (i) => i,
        ),
      ),
    ).toList(),
  );
}

class _CopyWithStubImpl$Query$playlistById$playlistById$filter$groups<TRes>
    implements CopyWith$Query$playlistById$playlistById$filter$groups<TRes> {
  _CopyWithStubImpl$Query$playlistById$playlistById$filter$groups(this._res);

  TRes _res;

  call({
    Enum$FilterMatch? match,
    List<Query$playlistById$playlistById$filter$groups$conditions>? conditions,
    List<Query$playlistById$playlistById$filter$groups$groups>? groups,
    String? $__typename,
  }) => _res;

  conditions(_fn) => _res;

  groups(_fn) => _res;
}

class Query$playlistById$playlistById$filter$groups$conditions
    implements Fragment$fragmentPlaylist$filter$groups$conditions {
  Query$playlistById$playlistById$filter$groups$conditions({
    required this.field,
    required this.$operator,
    this.value,
    this.$__typename = 'FilterConditionValue',
  });

  factory Query$playlistById$playlistById$filter$groups$conditions.fromJson(
    Map<String, dynamic> json,
  ) {
    final l$field = json['field'];
    final l$$operator = json['operator'];
    final l$value = json['value'];
    final l$$__typename = json['__typename'];
    return Query$playlistById$playlistById$filter$groups$conditions(
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
    if (other is! Query$playlistById$playlistById$filter$groups$conditions ||
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

extension UtilityExtension$Query$playlistById$playlistById$filter$groups$conditions
    on Query$playlistById$playlistById$filter$groups$conditions {
  CopyWith$Query$playlistById$playlistById$filter$groups$conditions<
    Query$playlistById$playlistById$filter$groups$conditions
  >
  get copyWith =>
      CopyWith$Query$playlistById$playlistById$filter$groups$conditions(
        this,
        (i) => i,
      );
}

abstract class CopyWith$Query$playlistById$playlistById$filter$groups$conditions<
  TRes
> {
  factory CopyWith$Query$playlistById$playlistById$filter$groups$conditions(
    Query$playlistById$playlistById$filter$groups$conditions instance,
    TRes Function(Query$playlistById$playlistById$filter$groups$conditions)
    then,
  ) = _CopyWithImpl$Query$playlistById$playlistById$filter$groups$conditions;

  factory CopyWith$Query$playlistById$playlistById$filter$groups$conditions.stub(
    TRes res,
  ) = _CopyWithStubImpl$Query$playlistById$playlistById$filter$groups$conditions;

  TRes call({
    Enum$FilterField? field,
    Enum$FilterOperator? $operator,
    String? value,
    String? $__typename,
  });
}

class _CopyWithImpl$Query$playlistById$playlistById$filter$groups$conditions<
  TRes
>
    implements
        CopyWith$Query$playlistById$playlistById$filter$groups$conditions<
          TRes
        > {
  _CopyWithImpl$Query$playlistById$playlistById$filter$groups$conditions(
    this._instance,
    this._then,
  );

  final Query$playlistById$playlistById$filter$groups$conditions _instance;

  final TRes Function(Query$playlistById$playlistById$filter$groups$conditions)
  _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? field = _undefined,
    Object? $operator = _undefined,
    Object? value = _undefined,
    Object? $__typename = _undefined,
  }) => _then(
    Query$playlistById$playlistById$filter$groups$conditions(
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

class _CopyWithStubImpl$Query$playlistById$playlistById$filter$groups$conditions<
  TRes
>
    implements
        CopyWith$Query$playlistById$playlistById$filter$groups$conditions<
          TRes
        > {
  _CopyWithStubImpl$Query$playlistById$playlistById$filter$groups$conditions(
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

class Query$playlistById$playlistById$filter$groups$groups
    implements Fragment$fragmentPlaylist$filter$groups$groups {
  Query$playlistById$playlistById$filter$groups$groups({
    required this.match,
    required this.conditions,
    this.$__typename = 'FilterGroup',
  });

  factory Query$playlistById$playlistById$filter$groups$groups.fromJson(
    Map<String, dynamic> json,
  ) {
    final l$match = json['match'];
    final l$conditions = json['conditions'];
    final l$$__typename = json['__typename'];
    return Query$playlistById$playlistById$filter$groups$groups(
      match: fromJson$Enum$FilterMatch((l$match as String)),
      conditions: (l$conditions as List<dynamic>)
          .map(
            (e) =>
                Query$playlistById$playlistById$filter$groups$groups$conditions.fromJson(
                  (e as Map<String, dynamic>),
                ),
          )
          .toList(),
      $__typename: (l$$__typename as String),
    );
  }

  final Enum$FilterMatch match;

  final List<Query$playlistById$playlistById$filter$groups$groups$conditions>
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
    if (other is! Query$playlistById$playlistById$filter$groups$groups ||
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

extension UtilityExtension$Query$playlistById$playlistById$filter$groups$groups
    on Query$playlistById$playlistById$filter$groups$groups {
  CopyWith$Query$playlistById$playlistById$filter$groups$groups<
    Query$playlistById$playlistById$filter$groups$groups
  >
  get copyWith => CopyWith$Query$playlistById$playlistById$filter$groups$groups(
    this,
    (i) => i,
  );
}

abstract class CopyWith$Query$playlistById$playlistById$filter$groups$groups<
  TRes
> {
  factory CopyWith$Query$playlistById$playlistById$filter$groups$groups(
    Query$playlistById$playlistById$filter$groups$groups instance,
    TRes Function(Query$playlistById$playlistById$filter$groups$groups) then,
  ) = _CopyWithImpl$Query$playlistById$playlistById$filter$groups$groups;

  factory CopyWith$Query$playlistById$playlistById$filter$groups$groups.stub(
    TRes res,
  ) = _CopyWithStubImpl$Query$playlistById$playlistById$filter$groups$groups;

  TRes call({
    Enum$FilterMatch? match,
    List<Query$playlistById$playlistById$filter$groups$groups$conditions>?
    conditions,
    String? $__typename,
  });
  TRes conditions(
    Iterable<Query$playlistById$playlistById$filter$groups$groups$conditions>
    Function(
      Iterable<
        CopyWith$Query$playlistById$playlistById$filter$groups$groups$conditions<
          Query$playlistById$playlistById$filter$groups$groups$conditions
        >
      >,
    )
    _fn,
  );
}

class _CopyWithImpl$Query$playlistById$playlistById$filter$groups$groups<TRes>
    implements
        CopyWith$Query$playlistById$playlistById$filter$groups$groups<TRes> {
  _CopyWithImpl$Query$playlistById$playlistById$filter$groups$groups(
    this._instance,
    this._then,
  );

  final Query$playlistById$playlistById$filter$groups$groups _instance;

  final TRes Function(Query$playlistById$playlistById$filter$groups$groups)
  _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? match = _undefined,
    Object? conditions = _undefined,
    Object? $__typename = _undefined,
  }) => _then(
    Query$playlistById$playlistById$filter$groups$groups(
      match: match == _undefined || match == null
          ? _instance.match
          : (match as Enum$FilterMatch),
      conditions: conditions == _undefined || conditions == null
          ? _instance.conditions
          : (conditions
                as List<
                  Query$playlistById$playlistById$filter$groups$groups$conditions
                >),
      $__typename: $__typename == _undefined || $__typename == null
          ? _instance.$__typename
          : ($__typename as String),
    ),
  );

  TRes conditions(
    Iterable<Query$playlistById$playlistById$filter$groups$groups$conditions>
    Function(
      Iterable<
        CopyWith$Query$playlistById$playlistById$filter$groups$groups$conditions<
          Query$playlistById$playlistById$filter$groups$groups$conditions
        >
      >,
    )
    _fn,
  ) => call(
    conditions: _fn(
      _instance.conditions.map(
        (e) =>
            CopyWith$Query$playlistById$playlistById$filter$groups$groups$conditions(
              e,
              (i) => i,
            ),
      ),
    ).toList(),
  );
}

class _CopyWithStubImpl$Query$playlistById$playlistById$filter$groups$groups<
  TRes
>
    implements
        CopyWith$Query$playlistById$playlistById$filter$groups$groups<TRes> {
  _CopyWithStubImpl$Query$playlistById$playlistById$filter$groups$groups(
    this._res,
  );

  TRes _res;

  call({
    Enum$FilterMatch? match,
    List<Query$playlistById$playlistById$filter$groups$groups$conditions>?
    conditions,
    String? $__typename,
  }) => _res;

  conditions(_fn) => _res;
}

class Query$playlistById$playlistById$filter$groups$groups$conditions
    implements Fragment$fragmentPlaylist$filter$groups$groups$conditions {
  Query$playlistById$playlistById$filter$groups$groups$conditions({
    required this.field,
    required this.$operator,
    this.value,
    this.$__typename = 'FilterConditionValue',
  });

  factory Query$playlistById$playlistById$filter$groups$groups$conditions.fromJson(
    Map<String, dynamic> json,
  ) {
    final l$field = json['field'];
    final l$$operator = json['operator'];
    final l$value = json['value'];
    final l$$__typename = json['__typename'];
    return Query$playlistById$playlistById$filter$groups$groups$conditions(
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
    if (other
            is! Query$playlistById$playlistById$filter$groups$groups$conditions ||
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

extension UtilityExtension$Query$playlistById$playlistById$filter$groups$groups$conditions
    on Query$playlistById$playlistById$filter$groups$groups$conditions {
  CopyWith$Query$playlistById$playlistById$filter$groups$groups$conditions<
    Query$playlistById$playlistById$filter$groups$groups$conditions
  >
  get copyWith =>
      CopyWith$Query$playlistById$playlistById$filter$groups$groups$conditions(
        this,
        (i) => i,
      );
}

abstract class CopyWith$Query$playlistById$playlistById$filter$groups$groups$conditions<
  TRes
> {
  factory CopyWith$Query$playlistById$playlistById$filter$groups$groups$conditions(
    Query$playlistById$playlistById$filter$groups$groups$conditions instance,
    TRes Function(
      Query$playlistById$playlistById$filter$groups$groups$conditions,
    )
    then,
  ) = _CopyWithImpl$Query$playlistById$playlistById$filter$groups$groups$conditions;

  factory CopyWith$Query$playlistById$playlistById$filter$groups$groups$conditions.stub(
    TRes res,
  ) = _CopyWithStubImpl$Query$playlistById$playlistById$filter$groups$groups$conditions;

  TRes call({
    Enum$FilterField? field,
    Enum$FilterOperator? $operator,
    String? value,
    String? $__typename,
  });
}

class _CopyWithImpl$Query$playlistById$playlistById$filter$groups$groups$conditions<
  TRes
>
    implements
        CopyWith$Query$playlistById$playlistById$filter$groups$groups$conditions<
          TRes
        > {
  _CopyWithImpl$Query$playlistById$playlistById$filter$groups$groups$conditions(
    this._instance,
    this._then,
  );

  final Query$playlistById$playlistById$filter$groups$groups$conditions
  _instance;

  final TRes Function(
    Query$playlistById$playlistById$filter$groups$groups$conditions,
  )
  _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? field = _undefined,
    Object? $operator = _undefined,
    Object? value = _undefined,
    Object? $__typename = _undefined,
  }) => _then(
    Query$playlistById$playlistById$filter$groups$groups$conditions(
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

class _CopyWithStubImpl$Query$playlistById$playlistById$filter$groups$groups$conditions<
  TRes
>
    implements
        CopyWith$Query$playlistById$playlistById$filter$groups$groups$conditions<
          TRes
        > {
  _CopyWithStubImpl$Query$playlistById$playlistById$filter$groups$groups$conditions(
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

class Variables$Mutation$createPlaylist {
  factory Variables$Mutation$createPlaylist({
    required Input$PlaylistInput input,
  }) => Variables$Mutation$createPlaylist._({r'input': input});

  Variables$Mutation$createPlaylist._(this._$data);

  factory Variables$Mutation$createPlaylist.fromJson(
    Map<String, dynamic> data,
  ) {
    final result$data = <String, dynamic>{};
    final l$input = data['input'];
    result$data['input'] = Input$PlaylistInput.fromJson(
      (l$input as Map<String, dynamic>),
    );
    return Variables$Mutation$createPlaylist._(result$data);
  }

  Map<String, dynamic> _$data;

  Input$PlaylistInput get input => (_$data['input'] as Input$PlaylistInput);

  Map<String, dynamic> toJson() {
    final result$data = <String, dynamic>{};
    final l$input = input;
    result$data['input'] = l$input.toJson();
    return result$data;
  }

  CopyWith$Variables$Mutation$createPlaylist<Variables$Mutation$createPlaylist>
  get copyWith => CopyWith$Variables$Mutation$createPlaylist(this, (i) => i);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Variables$Mutation$createPlaylist ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$input = input;
    final lOther$input = other.input;
    if (l$input != lOther$input) {
      return false;
    }
    return true;
  }

  @override
  int get hashCode {
    final l$input = input;
    return Object.hashAll([l$input]);
  }
}

abstract class CopyWith$Variables$Mutation$createPlaylist<TRes> {
  factory CopyWith$Variables$Mutation$createPlaylist(
    Variables$Mutation$createPlaylist instance,
    TRes Function(Variables$Mutation$createPlaylist) then,
  ) = _CopyWithImpl$Variables$Mutation$createPlaylist;

  factory CopyWith$Variables$Mutation$createPlaylist.stub(TRes res) =
      _CopyWithStubImpl$Variables$Mutation$createPlaylist;

  TRes call({Input$PlaylistInput? input});
}

class _CopyWithImpl$Variables$Mutation$createPlaylist<TRes>
    implements CopyWith$Variables$Mutation$createPlaylist<TRes> {
  _CopyWithImpl$Variables$Mutation$createPlaylist(this._instance, this._then);

  final Variables$Mutation$createPlaylist _instance;

  final TRes Function(Variables$Mutation$createPlaylist) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({Object? input = _undefined}) => _then(
    Variables$Mutation$createPlaylist._({
      ..._instance._$data,
      if (input != _undefined && input != null)
        'input': (input as Input$PlaylistInput),
    }),
  );
}

class _CopyWithStubImpl$Variables$Mutation$createPlaylist<TRes>
    implements CopyWith$Variables$Mutation$createPlaylist<TRes> {
  _CopyWithStubImpl$Variables$Mutation$createPlaylist(this._res);

  TRes _res;

  call({Input$PlaylistInput? input}) => _res;
}

class Mutation$createPlaylist {
  Mutation$createPlaylist({
    required this.createPlaylist,
    this.$__typename = 'Mutation',
  });

  factory Mutation$createPlaylist.fromJson(Map<String, dynamic> json) {
    final l$createPlaylist = json['createPlaylist'];
    final l$$__typename = json['__typename'];
    return Mutation$createPlaylist(
      createPlaylist: Fragment$fragmentPlaylist.fromJson(
        (l$createPlaylist as Map<String, dynamic>),
      ),
      $__typename: (l$$__typename as String),
    );
  }

  final Fragment$fragmentPlaylist createPlaylist;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$createPlaylist = createPlaylist;
    _resultData['createPlaylist'] = l$createPlaylist.toJson();
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$createPlaylist = createPlaylist;
    final l$$__typename = $__typename;
    return Object.hashAll([l$createPlaylist, l$$__typename]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Mutation$createPlaylist || runtimeType != other.runtimeType) {
      return false;
    }
    final l$createPlaylist = createPlaylist;
    final lOther$createPlaylist = other.createPlaylist;
    if (l$createPlaylist != lOther$createPlaylist) {
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

extension UtilityExtension$Mutation$createPlaylist on Mutation$createPlaylist {
  CopyWith$Mutation$createPlaylist<Mutation$createPlaylist> get copyWith =>
      CopyWith$Mutation$createPlaylist(this, (i) => i);
}

abstract class CopyWith$Mutation$createPlaylist<TRes> {
  factory CopyWith$Mutation$createPlaylist(
    Mutation$createPlaylist instance,
    TRes Function(Mutation$createPlaylist) then,
  ) = _CopyWithImpl$Mutation$createPlaylist;

  factory CopyWith$Mutation$createPlaylist.stub(TRes res) =
      _CopyWithStubImpl$Mutation$createPlaylist;

  TRes call({Fragment$fragmentPlaylist? createPlaylist, String? $__typename});
  CopyWith$Fragment$fragmentPlaylist<TRes> get createPlaylist;
}

class _CopyWithImpl$Mutation$createPlaylist<TRes>
    implements CopyWith$Mutation$createPlaylist<TRes> {
  _CopyWithImpl$Mutation$createPlaylist(this._instance, this._then);

  final Mutation$createPlaylist _instance;

  final TRes Function(Mutation$createPlaylist) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? createPlaylist = _undefined,
    Object? $__typename = _undefined,
  }) => _then(
    Mutation$createPlaylist(
      createPlaylist: createPlaylist == _undefined || createPlaylist == null
          ? _instance.createPlaylist
          : (createPlaylist as Fragment$fragmentPlaylist),
      $__typename: $__typename == _undefined || $__typename == null
          ? _instance.$__typename
          : ($__typename as String),
    ),
  );

  CopyWith$Fragment$fragmentPlaylist<TRes> get createPlaylist {
    final local$createPlaylist = _instance.createPlaylist;
    return CopyWith$Fragment$fragmentPlaylist(
      local$createPlaylist,
      (e) => call(createPlaylist: e),
    );
  }
}

class _CopyWithStubImpl$Mutation$createPlaylist<TRes>
    implements CopyWith$Mutation$createPlaylist<TRes> {
  _CopyWithStubImpl$Mutation$createPlaylist(this._res);

  TRes _res;

  call({Fragment$fragmentPlaylist? createPlaylist, String? $__typename}) =>
      _res;

  CopyWith$Fragment$fragmentPlaylist<TRes> get createPlaylist =>
      CopyWith$Fragment$fragmentPlaylist.stub(_res);
}

const documentNodeMutationcreatePlaylist = DocumentNode(
  definitions: [
    OperationDefinitionNode(
      type: OperationType.mutation,
      name: NameNode(value: 'createPlaylist'),
      variableDefinitions: [
        VariableDefinitionNode(
          variable: VariableNode(name: NameNode(value: 'input')),
          type: NamedTypeNode(
            name: NameNode(value: 'PlaylistInput'),
            isNonNull: true,
          ),
          defaultValue: DefaultValueNode(value: null),
          directives: [],
        ),
      ],
      directives: [],
      selectionSet: SelectionSetNode(
        selections: [
          FieldNode(
            name: NameNode(value: 'createPlaylist'),
            alias: null,
            arguments: [
              ArgumentNode(
                name: NameNode(value: 'input'),
                value: VariableNode(name: NameNode(value: 'input')),
              ),
            ],
            directives: [],
            selectionSet: SelectionSetNode(
              selections: [
                FragmentSpreadNode(
                  name: NameNode(value: 'fragmentPlaylist'),
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
    fragmentDefinitionfragmentPlaylist,
  ],
);

class Variables$Mutation$updatePlaylist {
  factory Variables$Mutation$updatePlaylist({
    required String id,
    required Input$PlaylistInput input,
  }) => Variables$Mutation$updatePlaylist._({r'id': id, r'input': input});

  Variables$Mutation$updatePlaylist._(this._$data);

  factory Variables$Mutation$updatePlaylist.fromJson(
    Map<String, dynamic> data,
  ) {
    final result$data = <String, dynamic>{};
    final l$id = data['id'];
    result$data['id'] = (l$id as String);
    final l$input = data['input'];
    result$data['input'] = Input$PlaylistInput.fromJson(
      (l$input as Map<String, dynamic>),
    );
    return Variables$Mutation$updatePlaylist._(result$data);
  }

  Map<String, dynamic> _$data;

  String get id => (_$data['id'] as String);

  Input$PlaylistInput get input => (_$data['input'] as Input$PlaylistInput);

  Map<String, dynamic> toJson() {
    final result$data = <String, dynamic>{};
    final l$id = id;
    result$data['id'] = l$id;
    final l$input = input;
    result$data['input'] = l$input.toJson();
    return result$data;
  }

  CopyWith$Variables$Mutation$updatePlaylist<Variables$Mutation$updatePlaylist>
  get copyWith => CopyWith$Variables$Mutation$updatePlaylist(this, (i) => i);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Variables$Mutation$updatePlaylist ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$id = id;
    final lOther$id = other.id;
    if (l$id != lOther$id) {
      return false;
    }
    final l$input = input;
    final lOther$input = other.input;
    if (l$input != lOther$input) {
      return false;
    }
    return true;
  }

  @override
  int get hashCode {
    final l$id = id;
    final l$input = input;
    return Object.hashAll([l$id, l$input]);
  }
}

abstract class CopyWith$Variables$Mutation$updatePlaylist<TRes> {
  factory CopyWith$Variables$Mutation$updatePlaylist(
    Variables$Mutation$updatePlaylist instance,
    TRes Function(Variables$Mutation$updatePlaylist) then,
  ) = _CopyWithImpl$Variables$Mutation$updatePlaylist;

  factory CopyWith$Variables$Mutation$updatePlaylist.stub(TRes res) =
      _CopyWithStubImpl$Variables$Mutation$updatePlaylist;

  TRes call({String? id, Input$PlaylistInput? input});
}

class _CopyWithImpl$Variables$Mutation$updatePlaylist<TRes>
    implements CopyWith$Variables$Mutation$updatePlaylist<TRes> {
  _CopyWithImpl$Variables$Mutation$updatePlaylist(this._instance, this._then);

  final Variables$Mutation$updatePlaylist _instance;

  final TRes Function(Variables$Mutation$updatePlaylist) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({Object? id = _undefined, Object? input = _undefined}) => _then(
    Variables$Mutation$updatePlaylist._({
      ..._instance._$data,
      if (id != _undefined && id != null) 'id': (id as String),
      if (input != _undefined && input != null)
        'input': (input as Input$PlaylistInput),
    }),
  );
}

class _CopyWithStubImpl$Variables$Mutation$updatePlaylist<TRes>
    implements CopyWith$Variables$Mutation$updatePlaylist<TRes> {
  _CopyWithStubImpl$Variables$Mutation$updatePlaylist(this._res);

  TRes _res;

  call({String? id, Input$PlaylistInput? input}) => _res;
}

class Mutation$updatePlaylist {
  Mutation$updatePlaylist({
    required this.updatePlaylist,
    this.$__typename = 'Mutation',
  });

  factory Mutation$updatePlaylist.fromJson(Map<String, dynamic> json) {
    final l$updatePlaylist = json['updatePlaylist'];
    final l$$__typename = json['__typename'];
    return Mutation$updatePlaylist(
      updatePlaylist: Fragment$fragmentPlaylist.fromJson(
        (l$updatePlaylist as Map<String, dynamic>),
      ),
      $__typename: (l$$__typename as String),
    );
  }

  final Fragment$fragmentPlaylist updatePlaylist;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$updatePlaylist = updatePlaylist;
    _resultData['updatePlaylist'] = l$updatePlaylist.toJson();
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$updatePlaylist = updatePlaylist;
    final l$$__typename = $__typename;
    return Object.hashAll([l$updatePlaylist, l$$__typename]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Mutation$updatePlaylist || runtimeType != other.runtimeType) {
      return false;
    }
    final l$updatePlaylist = updatePlaylist;
    final lOther$updatePlaylist = other.updatePlaylist;
    if (l$updatePlaylist != lOther$updatePlaylist) {
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

extension UtilityExtension$Mutation$updatePlaylist on Mutation$updatePlaylist {
  CopyWith$Mutation$updatePlaylist<Mutation$updatePlaylist> get copyWith =>
      CopyWith$Mutation$updatePlaylist(this, (i) => i);
}

abstract class CopyWith$Mutation$updatePlaylist<TRes> {
  factory CopyWith$Mutation$updatePlaylist(
    Mutation$updatePlaylist instance,
    TRes Function(Mutation$updatePlaylist) then,
  ) = _CopyWithImpl$Mutation$updatePlaylist;

  factory CopyWith$Mutation$updatePlaylist.stub(TRes res) =
      _CopyWithStubImpl$Mutation$updatePlaylist;

  TRes call({Fragment$fragmentPlaylist? updatePlaylist, String? $__typename});
  CopyWith$Fragment$fragmentPlaylist<TRes> get updatePlaylist;
}

class _CopyWithImpl$Mutation$updatePlaylist<TRes>
    implements CopyWith$Mutation$updatePlaylist<TRes> {
  _CopyWithImpl$Mutation$updatePlaylist(this._instance, this._then);

  final Mutation$updatePlaylist _instance;

  final TRes Function(Mutation$updatePlaylist) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? updatePlaylist = _undefined,
    Object? $__typename = _undefined,
  }) => _then(
    Mutation$updatePlaylist(
      updatePlaylist: updatePlaylist == _undefined || updatePlaylist == null
          ? _instance.updatePlaylist
          : (updatePlaylist as Fragment$fragmentPlaylist),
      $__typename: $__typename == _undefined || $__typename == null
          ? _instance.$__typename
          : ($__typename as String),
    ),
  );

  CopyWith$Fragment$fragmentPlaylist<TRes> get updatePlaylist {
    final local$updatePlaylist = _instance.updatePlaylist;
    return CopyWith$Fragment$fragmentPlaylist(
      local$updatePlaylist,
      (e) => call(updatePlaylist: e),
    );
  }
}

class _CopyWithStubImpl$Mutation$updatePlaylist<TRes>
    implements CopyWith$Mutation$updatePlaylist<TRes> {
  _CopyWithStubImpl$Mutation$updatePlaylist(this._res);

  TRes _res;

  call({Fragment$fragmentPlaylist? updatePlaylist, String? $__typename}) =>
      _res;

  CopyWith$Fragment$fragmentPlaylist<TRes> get updatePlaylist =>
      CopyWith$Fragment$fragmentPlaylist.stub(_res);
}

const documentNodeMutationupdatePlaylist = DocumentNode(
  definitions: [
    OperationDefinitionNode(
      type: OperationType.mutation,
      name: NameNode(value: 'updatePlaylist'),
      variableDefinitions: [
        VariableDefinitionNode(
          variable: VariableNode(name: NameNode(value: 'id')),
          type: NamedTypeNode(name: NameNode(value: 'ID'), isNonNull: true),
          defaultValue: DefaultValueNode(value: null),
          directives: [],
        ),
        VariableDefinitionNode(
          variable: VariableNode(name: NameNode(value: 'input')),
          type: NamedTypeNode(
            name: NameNode(value: 'PlaylistInput'),
            isNonNull: true,
          ),
          defaultValue: DefaultValueNode(value: null),
          directives: [],
        ),
      ],
      directives: [],
      selectionSet: SelectionSetNode(
        selections: [
          FieldNode(
            name: NameNode(value: 'updatePlaylist'),
            alias: null,
            arguments: [
              ArgumentNode(
                name: NameNode(value: 'id'),
                value: VariableNode(name: NameNode(value: 'id')),
              ),
              ArgumentNode(
                name: NameNode(value: 'input'),
                value: VariableNode(name: NameNode(value: 'input')),
              ),
            ],
            directives: [],
            selectionSet: SelectionSetNode(
              selections: [
                FragmentSpreadNode(
                  name: NameNode(value: 'fragmentPlaylist'),
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
    fragmentDefinitionfragmentPlaylist,
  ],
);

class Variables$Mutation$deletePlaylist {
  factory Variables$Mutation$deletePlaylist({required String id}) =>
      Variables$Mutation$deletePlaylist._({r'id': id});

  Variables$Mutation$deletePlaylist._(this._$data);

  factory Variables$Mutation$deletePlaylist.fromJson(
    Map<String, dynamic> data,
  ) {
    final result$data = <String, dynamic>{};
    final l$id = data['id'];
    result$data['id'] = (l$id as String);
    return Variables$Mutation$deletePlaylist._(result$data);
  }

  Map<String, dynamic> _$data;

  String get id => (_$data['id'] as String);

  Map<String, dynamic> toJson() {
    final result$data = <String, dynamic>{};
    final l$id = id;
    result$data['id'] = l$id;
    return result$data;
  }

  CopyWith$Variables$Mutation$deletePlaylist<Variables$Mutation$deletePlaylist>
  get copyWith => CopyWith$Variables$Mutation$deletePlaylist(this, (i) => i);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Variables$Mutation$deletePlaylist ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$id = id;
    final lOther$id = other.id;
    if (l$id != lOther$id) {
      return false;
    }
    return true;
  }

  @override
  int get hashCode {
    final l$id = id;
    return Object.hashAll([l$id]);
  }
}

abstract class CopyWith$Variables$Mutation$deletePlaylist<TRes> {
  factory CopyWith$Variables$Mutation$deletePlaylist(
    Variables$Mutation$deletePlaylist instance,
    TRes Function(Variables$Mutation$deletePlaylist) then,
  ) = _CopyWithImpl$Variables$Mutation$deletePlaylist;

  factory CopyWith$Variables$Mutation$deletePlaylist.stub(TRes res) =
      _CopyWithStubImpl$Variables$Mutation$deletePlaylist;

  TRes call({String? id});
}

class _CopyWithImpl$Variables$Mutation$deletePlaylist<TRes>
    implements CopyWith$Variables$Mutation$deletePlaylist<TRes> {
  _CopyWithImpl$Variables$Mutation$deletePlaylist(this._instance, this._then);

  final Variables$Mutation$deletePlaylist _instance;

  final TRes Function(Variables$Mutation$deletePlaylist) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({Object? id = _undefined}) => _then(
    Variables$Mutation$deletePlaylist._({
      ..._instance._$data,
      if (id != _undefined && id != null) 'id': (id as String),
    }),
  );
}

class _CopyWithStubImpl$Variables$Mutation$deletePlaylist<TRes>
    implements CopyWith$Variables$Mutation$deletePlaylist<TRes> {
  _CopyWithStubImpl$Variables$Mutation$deletePlaylist(this._res);

  TRes _res;

  call({String? id}) => _res;
}

class Mutation$deletePlaylist {
  Mutation$deletePlaylist({
    required this.deletePlaylist,
    this.$__typename = 'Mutation',
  });

  factory Mutation$deletePlaylist.fromJson(Map<String, dynamic> json) {
    final l$deletePlaylist = json['deletePlaylist'];
    final l$$__typename = json['__typename'];
    return Mutation$deletePlaylist(
      deletePlaylist: (l$deletePlaylist as bool),
      $__typename: (l$$__typename as String),
    );
  }

  final bool deletePlaylist;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$deletePlaylist = deletePlaylist;
    _resultData['deletePlaylist'] = l$deletePlaylist;
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$deletePlaylist = deletePlaylist;
    final l$$__typename = $__typename;
    return Object.hashAll([l$deletePlaylist, l$$__typename]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Mutation$deletePlaylist || runtimeType != other.runtimeType) {
      return false;
    }
    final l$deletePlaylist = deletePlaylist;
    final lOther$deletePlaylist = other.deletePlaylist;
    if (l$deletePlaylist != lOther$deletePlaylist) {
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

extension UtilityExtension$Mutation$deletePlaylist on Mutation$deletePlaylist {
  CopyWith$Mutation$deletePlaylist<Mutation$deletePlaylist> get copyWith =>
      CopyWith$Mutation$deletePlaylist(this, (i) => i);
}

abstract class CopyWith$Mutation$deletePlaylist<TRes> {
  factory CopyWith$Mutation$deletePlaylist(
    Mutation$deletePlaylist instance,
    TRes Function(Mutation$deletePlaylist) then,
  ) = _CopyWithImpl$Mutation$deletePlaylist;

  factory CopyWith$Mutation$deletePlaylist.stub(TRes res) =
      _CopyWithStubImpl$Mutation$deletePlaylist;

  TRes call({bool? deletePlaylist, String? $__typename});
}

class _CopyWithImpl$Mutation$deletePlaylist<TRes>
    implements CopyWith$Mutation$deletePlaylist<TRes> {
  _CopyWithImpl$Mutation$deletePlaylist(this._instance, this._then);

  final Mutation$deletePlaylist _instance;

  final TRes Function(Mutation$deletePlaylist) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? deletePlaylist = _undefined,
    Object? $__typename = _undefined,
  }) => _then(
    Mutation$deletePlaylist(
      deletePlaylist: deletePlaylist == _undefined || deletePlaylist == null
          ? _instance.deletePlaylist
          : (deletePlaylist as bool),
      $__typename: $__typename == _undefined || $__typename == null
          ? _instance.$__typename
          : ($__typename as String),
    ),
  );
}

class _CopyWithStubImpl$Mutation$deletePlaylist<TRes>
    implements CopyWith$Mutation$deletePlaylist<TRes> {
  _CopyWithStubImpl$Mutation$deletePlaylist(this._res);

  TRes _res;

  call({bool? deletePlaylist, String? $__typename}) => _res;
}

const documentNodeMutationdeletePlaylist = DocumentNode(
  definitions: [
    OperationDefinitionNode(
      type: OperationType.mutation,
      name: NameNode(value: 'deletePlaylist'),
      variableDefinitions: [
        VariableDefinitionNode(
          variable: VariableNode(name: NameNode(value: 'id')),
          type: NamedTypeNode(name: NameNode(value: 'ID'), isNonNull: true),
          defaultValue: DefaultValueNode(value: null),
          directives: [],
        ),
      ],
      directives: [],
      selectionSet: SelectionSetNode(
        selections: [
          FieldNode(
            name: NameNode(value: 'deletePlaylist'),
            alias: null,
            arguments: [
              ArgumentNode(
                name: NameNode(value: 'id'),
                value: VariableNode(name: NameNode(value: 'id')),
              ),
            ],
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
  ],
);

class Variables$Mutation$addPlaylistItem {
  factory Variables$Mutation$addPlaylistItem({
    required String playlistId,
    required String mediaId,
    String? afterPlaylistItemId,
  }) => Variables$Mutation$addPlaylistItem._({
    r'playlistId': playlistId,
    r'mediaId': mediaId,
    if (afterPlaylistItemId != null)
      r'afterPlaylistItemId': afterPlaylistItemId,
  });

  Variables$Mutation$addPlaylistItem._(this._$data);

  factory Variables$Mutation$addPlaylistItem.fromJson(
    Map<String, dynamic> data,
  ) {
    final result$data = <String, dynamic>{};
    final l$playlistId = data['playlistId'];
    result$data['playlistId'] = (l$playlistId as String);
    final l$mediaId = data['mediaId'];
    result$data['mediaId'] = (l$mediaId as String);
    if (data.containsKey('afterPlaylistItemId')) {
      final l$afterPlaylistItemId = data['afterPlaylistItemId'];
      result$data['afterPlaylistItemId'] = (l$afterPlaylistItemId as String?);
    }
    return Variables$Mutation$addPlaylistItem._(result$data);
  }

  Map<String, dynamic> _$data;

  String get playlistId => (_$data['playlistId'] as String);

  String get mediaId => (_$data['mediaId'] as String);

  String? get afterPlaylistItemId => (_$data['afterPlaylistItemId'] as String?);

  Map<String, dynamic> toJson() {
    final result$data = <String, dynamic>{};
    final l$playlistId = playlistId;
    result$data['playlistId'] = l$playlistId;
    final l$mediaId = mediaId;
    result$data['mediaId'] = l$mediaId;
    if (_$data.containsKey('afterPlaylistItemId')) {
      final l$afterPlaylistItemId = afterPlaylistItemId;
      result$data['afterPlaylistItemId'] = l$afterPlaylistItemId;
    }
    return result$data;
  }

  CopyWith$Variables$Mutation$addPlaylistItem<
    Variables$Mutation$addPlaylistItem
  >
  get copyWith => CopyWith$Variables$Mutation$addPlaylistItem(this, (i) => i);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Variables$Mutation$addPlaylistItem ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$playlistId = playlistId;
    final lOther$playlistId = other.playlistId;
    if (l$playlistId != lOther$playlistId) {
      return false;
    }
    final l$mediaId = mediaId;
    final lOther$mediaId = other.mediaId;
    if (l$mediaId != lOther$mediaId) {
      return false;
    }
    final l$afterPlaylistItemId = afterPlaylistItemId;
    final lOther$afterPlaylistItemId = other.afterPlaylistItemId;
    if (_$data.containsKey('afterPlaylistItemId') !=
        other._$data.containsKey('afterPlaylistItemId')) {
      return false;
    }
    if (l$afterPlaylistItemId != lOther$afterPlaylistItemId) {
      return false;
    }
    return true;
  }

  @override
  int get hashCode {
    final l$playlistId = playlistId;
    final l$mediaId = mediaId;
    final l$afterPlaylistItemId = afterPlaylistItemId;
    return Object.hashAll([
      l$playlistId,
      l$mediaId,
      _$data.containsKey('afterPlaylistItemId')
          ? l$afterPlaylistItemId
          : const {},
    ]);
  }
}

abstract class CopyWith$Variables$Mutation$addPlaylistItem<TRes> {
  factory CopyWith$Variables$Mutation$addPlaylistItem(
    Variables$Mutation$addPlaylistItem instance,
    TRes Function(Variables$Mutation$addPlaylistItem) then,
  ) = _CopyWithImpl$Variables$Mutation$addPlaylistItem;

  factory CopyWith$Variables$Mutation$addPlaylistItem.stub(TRes res) =
      _CopyWithStubImpl$Variables$Mutation$addPlaylistItem;

  TRes call({String? playlistId, String? mediaId, String? afterPlaylistItemId});
}

class _CopyWithImpl$Variables$Mutation$addPlaylistItem<TRes>
    implements CopyWith$Variables$Mutation$addPlaylistItem<TRes> {
  _CopyWithImpl$Variables$Mutation$addPlaylistItem(this._instance, this._then);

  final Variables$Mutation$addPlaylistItem _instance;

  final TRes Function(Variables$Mutation$addPlaylistItem) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? playlistId = _undefined,
    Object? mediaId = _undefined,
    Object? afterPlaylistItemId = _undefined,
  }) => _then(
    Variables$Mutation$addPlaylistItem._({
      ..._instance._$data,
      if (playlistId != _undefined && playlistId != null)
        'playlistId': (playlistId as String),
      if (mediaId != _undefined && mediaId != null)
        'mediaId': (mediaId as String),
      if (afterPlaylistItemId != _undefined)
        'afterPlaylistItemId': (afterPlaylistItemId as String?),
    }),
  );
}

class _CopyWithStubImpl$Variables$Mutation$addPlaylistItem<TRes>
    implements CopyWith$Variables$Mutation$addPlaylistItem<TRes> {
  _CopyWithStubImpl$Variables$Mutation$addPlaylistItem(this._res);

  TRes _res;

  call({String? playlistId, String? mediaId, String? afterPlaylistItemId}) =>
      _res;
}

class Mutation$addPlaylistItem {
  Mutation$addPlaylistItem({
    required this.addPlaylistItem,
    this.$__typename = 'Mutation',
  });

  factory Mutation$addPlaylistItem.fromJson(Map<String, dynamic> json) {
    final l$addPlaylistItem = json['addPlaylistItem'];
    final l$$__typename = json['__typename'];
    return Mutation$addPlaylistItem(
      addPlaylistItem: Mutation$addPlaylistItem$addPlaylistItem.fromJson(
        (l$addPlaylistItem as Map<String, dynamic>),
      ),
      $__typename: (l$$__typename as String),
    );
  }

  final Mutation$addPlaylistItem$addPlaylistItem addPlaylistItem;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$addPlaylistItem = addPlaylistItem;
    _resultData['addPlaylistItem'] = l$addPlaylistItem.toJson();
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$addPlaylistItem = addPlaylistItem;
    final l$$__typename = $__typename;
    return Object.hashAll([l$addPlaylistItem, l$$__typename]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Mutation$addPlaylistItem ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$addPlaylistItem = addPlaylistItem;
    final lOther$addPlaylistItem = other.addPlaylistItem;
    if (l$addPlaylistItem != lOther$addPlaylistItem) {
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

extension UtilityExtension$Mutation$addPlaylistItem
    on Mutation$addPlaylistItem {
  CopyWith$Mutation$addPlaylistItem<Mutation$addPlaylistItem> get copyWith =>
      CopyWith$Mutation$addPlaylistItem(this, (i) => i);
}

abstract class CopyWith$Mutation$addPlaylistItem<TRes> {
  factory CopyWith$Mutation$addPlaylistItem(
    Mutation$addPlaylistItem instance,
    TRes Function(Mutation$addPlaylistItem) then,
  ) = _CopyWithImpl$Mutation$addPlaylistItem;

  factory CopyWith$Mutation$addPlaylistItem.stub(TRes res) =
      _CopyWithStubImpl$Mutation$addPlaylistItem;

  TRes call({
    Mutation$addPlaylistItem$addPlaylistItem? addPlaylistItem,
    String? $__typename,
  });
  CopyWith$Mutation$addPlaylistItem$addPlaylistItem<TRes> get addPlaylistItem;
}

class _CopyWithImpl$Mutation$addPlaylistItem<TRes>
    implements CopyWith$Mutation$addPlaylistItem<TRes> {
  _CopyWithImpl$Mutation$addPlaylistItem(this._instance, this._then);

  final Mutation$addPlaylistItem _instance;

  final TRes Function(Mutation$addPlaylistItem) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? addPlaylistItem = _undefined,
    Object? $__typename = _undefined,
  }) => _then(
    Mutation$addPlaylistItem(
      addPlaylistItem: addPlaylistItem == _undefined || addPlaylistItem == null
          ? _instance.addPlaylistItem
          : (addPlaylistItem as Mutation$addPlaylistItem$addPlaylistItem),
      $__typename: $__typename == _undefined || $__typename == null
          ? _instance.$__typename
          : ($__typename as String),
    ),
  );

  CopyWith$Mutation$addPlaylistItem$addPlaylistItem<TRes> get addPlaylistItem {
    final local$addPlaylistItem = _instance.addPlaylistItem;
    return CopyWith$Mutation$addPlaylistItem$addPlaylistItem(
      local$addPlaylistItem,
      (e) => call(addPlaylistItem: e),
    );
  }
}

class _CopyWithStubImpl$Mutation$addPlaylistItem<TRes>
    implements CopyWith$Mutation$addPlaylistItem<TRes> {
  _CopyWithStubImpl$Mutation$addPlaylistItem(this._res);

  TRes _res;

  call({
    Mutation$addPlaylistItem$addPlaylistItem? addPlaylistItem,
    String? $__typename,
  }) => _res;

  CopyWith$Mutation$addPlaylistItem$addPlaylistItem<TRes> get addPlaylistItem =>
      CopyWith$Mutation$addPlaylistItem$addPlaylistItem.stub(_res);
}

const documentNodeMutationaddPlaylistItem = DocumentNode(
  definitions: [
    OperationDefinitionNode(
      type: OperationType.mutation,
      name: NameNode(value: 'addPlaylistItem'),
      variableDefinitions: [
        VariableDefinitionNode(
          variable: VariableNode(name: NameNode(value: 'playlistId')),
          type: NamedTypeNode(name: NameNode(value: 'ID'), isNonNull: true),
          defaultValue: DefaultValueNode(value: null),
          directives: [],
        ),
        VariableDefinitionNode(
          variable: VariableNode(name: NameNode(value: 'mediaId')),
          type: NamedTypeNode(name: NameNode(value: 'ID'), isNonNull: true),
          defaultValue: DefaultValueNode(value: null),
          directives: [],
        ),
        VariableDefinitionNode(
          variable: VariableNode(name: NameNode(value: 'afterPlaylistItemId')),
          type: NamedTypeNode(name: NameNode(value: 'ID'), isNonNull: false),
          defaultValue: DefaultValueNode(value: null),
          directives: [],
        ),
      ],
      directives: [],
      selectionSet: SelectionSetNode(
        selections: [
          FieldNode(
            name: NameNode(value: 'addPlaylistItem'),
            alias: null,
            arguments: [
              ArgumentNode(
                name: NameNode(value: 'playlistId'),
                value: VariableNode(name: NameNode(value: 'playlistId')),
              ),
              ArgumentNode(
                name: NameNode(value: 'mediaId'),
                value: VariableNode(name: NameNode(value: 'mediaId')),
              ),
              ArgumentNode(
                name: NameNode(value: 'afterPlaylistItemId'),
                value: VariableNode(
                  name: NameNode(value: 'afterPlaylistItemId'),
                ),
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
                  name: NameNode(value: 'itemCount'),
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
  ],
);

class Mutation$addPlaylistItem$addPlaylistItem {
  Mutation$addPlaylistItem$addPlaylistItem({
    required this.id,
    this.itemCount,
    this.$__typename = 'Playlist',
  });

  factory Mutation$addPlaylistItem$addPlaylistItem.fromJson(
    Map<String, dynamic> json,
  ) {
    final l$id = json['id'];
    final l$itemCount = json['itemCount'];
    final l$$__typename = json['__typename'];
    return Mutation$addPlaylistItem$addPlaylistItem(
      id: (l$id as String),
      itemCount: (l$itemCount as int?),
      $__typename: (l$$__typename as String),
    );
  }

  final String id;

  final int? itemCount;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$id = id;
    _resultData['id'] = l$id;
    final l$itemCount = itemCount;
    _resultData['itemCount'] = l$itemCount;
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$id = id;
    final l$itemCount = itemCount;
    final l$$__typename = $__typename;
    return Object.hashAll([l$id, l$itemCount, l$$__typename]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Mutation$addPlaylistItem$addPlaylistItem ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$id = id;
    final lOther$id = other.id;
    if (l$id != lOther$id) {
      return false;
    }
    final l$itemCount = itemCount;
    final lOther$itemCount = other.itemCount;
    if (l$itemCount != lOther$itemCount) {
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

extension UtilityExtension$Mutation$addPlaylistItem$addPlaylistItem
    on Mutation$addPlaylistItem$addPlaylistItem {
  CopyWith$Mutation$addPlaylistItem$addPlaylistItem<
    Mutation$addPlaylistItem$addPlaylistItem
  >
  get copyWith =>
      CopyWith$Mutation$addPlaylistItem$addPlaylistItem(this, (i) => i);
}

abstract class CopyWith$Mutation$addPlaylistItem$addPlaylistItem<TRes> {
  factory CopyWith$Mutation$addPlaylistItem$addPlaylistItem(
    Mutation$addPlaylistItem$addPlaylistItem instance,
    TRes Function(Mutation$addPlaylistItem$addPlaylistItem) then,
  ) = _CopyWithImpl$Mutation$addPlaylistItem$addPlaylistItem;

  factory CopyWith$Mutation$addPlaylistItem$addPlaylistItem.stub(TRes res) =
      _CopyWithStubImpl$Mutation$addPlaylistItem$addPlaylistItem;

  TRes call({String? id, int? itemCount, String? $__typename});
}

class _CopyWithImpl$Mutation$addPlaylistItem$addPlaylistItem<TRes>
    implements CopyWith$Mutation$addPlaylistItem$addPlaylistItem<TRes> {
  _CopyWithImpl$Mutation$addPlaylistItem$addPlaylistItem(
    this._instance,
    this._then,
  );

  final Mutation$addPlaylistItem$addPlaylistItem _instance;

  final TRes Function(Mutation$addPlaylistItem$addPlaylistItem) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? id = _undefined,
    Object? itemCount = _undefined,
    Object? $__typename = _undefined,
  }) => _then(
    Mutation$addPlaylistItem$addPlaylistItem(
      id: id == _undefined || id == null ? _instance.id : (id as String),
      itemCount: itemCount == _undefined
          ? _instance.itemCount
          : (itemCount as int?),
      $__typename: $__typename == _undefined || $__typename == null
          ? _instance.$__typename
          : ($__typename as String),
    ),
  );
}

class _CopyWithStubImpl$Mutation$addPlaylistItem$addPlaylistItem<TRes>
    implements CopyWith$Mutation$addPlaylistItem$addPlaylistItem<TRes> {
  _CopyWithStubImpl$Mutation$addPlaylistItem$addPlaylistItem(this._res);

  TRes _res;

  call({String? id, int? itemCount, String? $__typename}) => _res;
}

class Variables$Mutation$movePlaylistItem {
  factory Variables$Mutation$movePlaylistItem({
    required String playlistId,
    required String playlistItemId,
    String? afterPlaylistItemId,
  }) => Variables$Mutation$movePlaylistItem._({
    r'playlistId': playlistId,
    r'playlistItemId': playlistItemId,
    if (afterPlaylistItemId != null)
      r'afterPlaylistItemId': afterPlaylistItemId,
  });

  Variables$Mutation$movePlaylistItem._(this._$data);

  factory Variables$Mutation$movePlaylistItem.fromJson(
    Map<String, dynamic> data,
  ) {
    final result$data = <String, dynamic>{};
    final l$playlistId = data['playlistId'];
    result$data['playlistId'] = (l$playlistId as String);
    final l$playlistItemId = data['playlistItemId'];
    result$data['playlistItemId'] = (l$playlistItemId as String);
    if (data.containsKey('afterPlaylistItemId')) {
      final l$afterPlaylistItemId = data['afterPlaylistItemId'];
      result$data['afterPlaylistItemId'] = (l$afterPlaylistItemId as String?);
    }
    return Variables$Mutation$movePlaylistItem._(result$data);
  }

  Map<String, dynamic> _$data;

  String get playlistId => (_$data['playlistId'] as String);

  String get playlistItemId => (_$data['playlistItemId'] as String);

  String? get afterPlaylistItemId => (_$data['afterPlaylistItemId'] as String?);

  Map<String, dynamic> toJson() {
    final result$data = <String, dynamic>{};
    final l$playlistId = playlistId;
    result$data['playlistId'] = l$playlistId;
    final l$playlistItemId = playlistItemId;
    result$data['playlistItemId'] = l$playlistItemId;
    if (_$data.containsKey('afterPlaylistItemId')) {
      final l$afterPlaylistItemId = afterPlaylistItemId;
      result$data['afterPlaylistItemId'] = l$afterPlaylistItemId;
    }
    return result$data;
  }

  CopyWith$Variables$Mutation$movePlaylistItem<
    Variables$Mutation$movePlaylistItem
  >
  get copyWith => CopyWith$Variables$Mutation$movePlaylistItem(this, (i) => i);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Variables$Mutation$movePlaylistItem ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$playlistId = playlistId;
    final lOther$playlistId = other.playlistId;
    if (l$playlistId != lOther$playlistId) {
      return false;
    }
    final l$playlistItemId = playlistItemId;
    final lOther$playlistItemId = other.playlistItemId;
    if (l$playlistItemId != lOther$playlistItemId) {
      return false;
    }
    final l$afterPlaylistItemId = afterPlaylistItemId;
    final lOther$afterPlaylistItemId = other.afterPlaylistItemId;
    if (_$data.containsKey('afterPlaylistItemId') !=
        other._$data.containsKey('afterPlaylistItemId')) {
      return false;
    }
    if (l$afterPlaylistItemId != lOther$afterPlaylistItemId) {
      return false;
    }
    return true;
  }

  @override
  int get hashCode {
    final l$playlistId = playlistId;
    final l$playlistItemId = playlistItemId;
    final l$afterPlaylistItemId = afterPlaylistItemId;
    return Object.hashAll([
      l$playlistId,
      l$playlistItemId,
      _$data.containsKey('afterPlaylistItemId')
          ? l$afterPlaylistItemId
          : const {},
    ]);
  }
}

abstract class CopyWith$Variables$Mutation$movePlaylistItem<TRes> {
  factory CopyWith$Variables$Mutation$movePlaylistItem(
    Variables$Mutation$movePlaylistItem instance,
    TRes Function(Variables$Mutation$movePlaylistItem) then,
  ) = _CopyWithImpl$Variables$Mutation$movePlaylistItem;

  factory CopyWith$Variables$Mutation$movePlaylistItem.stub(TRes res) =
      _CopyWithStubImpl$Variables$Mutation$movePlaylistItem;

  TRes call({
    String? playlistId,
    String? playlistItemId,
    String? afterPlaylistItemId,
  });
}

class _CopyWithImpl$Variables$Mutation$movePlaylistItem<TRes>
    implements CopyWith$Variables$Mutation$movePlaylistItem<TRes> {
  _CopyWithImpl$Variables$Mutation$movePlaylistItem(this._instance, this._then);

  final Variables$Mutation$movePlaylistItem _instance;

  final TRes Function(Variables$Mutation$movePlaylistItem) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? playlistId = _undefined,
    Object? playlistItemId = _undefined,
    Object? afterPlaylistItemId = _undefined,
  }) => _then(
    Variables$Mutation$movePlaylistItem._({
      ..._instance._$data,
      if (playlistId != _undefined && playlistId != null)
        'playlistId': (playlistId as String),
      if (playlistItemId != _undefined && playlistItemId != null)
        'playlistItemId': (playlistItemId as String),
      if (afterPlaylistItemId != _undefined)
        'afterPlaylistItemId': (afterPlaylistItemId as String?),
    }),
  );
}

class _CopyWithStubImpl$Variables$Mutation$movePlaylistItem<TRes>
    implements CopyWith$Variables$Mutation$movePlaylistItem<TRes> {
  _CopyWithStubImpl$Variables$Mutation$movePlaylistItem(this._res);

  TRes _res;

  call({
    String? playlistId,
    String? playlistItemId,
    String? afterPlaylistItemId,
  }) => _res;
}

class Mutation$movePlaylistItem {
  Mutation$movePlaylistItem({
    required this.movePlaylistItem,
    this.$__typename = 'Mutation',
  });

  factory Mutation$movePlaylistItem.fromJson(Map<String, dynamic> json) {
    final l$movePlaylistItem = json['movePlaylistItem'];
    final l$$__typename = json['__typename'];
    return Mutation$movePlaylistItem(
      movePlaylistItem: Mutation$movePlaylistItem$movePlaylistItem.fromJson(
        (l$movePlaylistItem as Map<String, dynamic>),
      ),
      $__typename: (l$$__typename as String),
    );
  }

  final Mutation$movePlaylistItem$movePlaylistItem movePlaylistItem;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$movePlaylistItem = movePlaylistItem;
    _resultData['movePlaylistItem'] = l$movePlaylistItem.toJson();
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$movePlaylistItem = movePlaylistItem;
    final l$$__typename = $__typename;
    return Object.hashAll([l$movePlaylistItem, l$$__typename]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Mutation$movePlaylistItem ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$movePlaylistItem = movePlaylistItem;
    final lOther$movePlaylistItem = other.movePlaylistItem;
    if (l$movePlaylistItem != lOther$movePlaylistItem) {
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

extension UtilityExtension$Mutation$movePlaylistItem
    on Mutation$movePlaylistItem {
  CopyWith$Mutation$movePlaylistItem<Mutation$movePlaylistItem> get copyWith =>
      CopyWith$Mutation$movePlaylistItem(this, (i) => i);
}

abstract class CopyWith$Mutation$movePlaylistItem<TRes> {
  factory CopyWith$Mutation$movePlaylistItem(
    Mutation$movePlaylistItem instance,
    TRes Function(Mutation$movePlaylistItem) then,
  ) = _CopyWithImpl$Mutation$movePlaylistItem;

  factory CopyWith$Mutation$movePlaylistItem.stub(TRes res) =
      _CopyWithStubImpl$Mutation$movePlaylistItem;

  TRes call({
    Mutation$movePlaylistItem$movePlaylistItem? movePlaylistItem,
    String? $__typename,
  });
  CopyWith$Mutation$movePlaylistItem$movePlaylistItem<TRes>
  get movePlaylistItem;
}

class _CopyWithImpl$Mutation$movePlaylistItem<TRes>
    implements CopyWith$Mutation$movePlaylistItem<TRes> {
  _CopyWithImpl$Mutation$movePlaylistItem(this._instance, this._then);

  final Mutation$movePlaylistItem _instance;

  final TRes Function(Mutation$movePlaylistItem) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? movePlaylistItem = _undefined,
    Object? $__typename = _undefined,
  }) => _then(
    Mutation$movePlaylistItem(
      movePlaylistItem:
          movePlaylistItem == _undefined || movePlaylistItem == null
          ? _instance.movePlaylistItem
          : (movePlaylistItem as Mutation$movePlaylistItem$movePlaylistItem),
      $__typename: $__typename == _undefined || $__typename == null
          ? _instance.$__typename
          : ($__typename as String),
    ),
  );

  CopyWith$Mutation$movePlaylistItem$movePlaylistItem<TRes>
  get movePlaylistItem {
    final local$movePlaylistItem = _instance.movePlaylistItem;
    return CopyWith$Mutation$movePlaylistItem$movePlaylistItem(
      local$movePlaylistItem,
      (e) => call(movePlaylistItem: e),
    );
  }
}

class _CopyWithStubImpl$Mutation$movePlaylistItem<TRes>
    implements CopyWith$Mutation$movePlaylistItem<TRes> {
  _CopyWithStubImpl$Mutation$movePlaylistItem(this._res);

  TRes _res;

  call({
    Mutation$movePlaylistItem$movePlaylistItem? movePlaylistItem,
    String? $__typename,
  }) => _res;

  CopyWith$Mutation$movePlaylistItem$movePlaylistItem<TRes>
  get movePlaylistItem =>
      CopyWith$Mutation$movePlaylistItem$movePlaylistItem.stub(_res);
}

const documentNodeMutationmovePlaylistItem = DocumentNode(
  definitions: [
    OperationDefinitionNode(
      type: OperationType.mutation,
      name: NameNode(value: 'movePlaylistItem'),
      variableDefinitions: [
        VariableDefinitionNode(
          variable: VariableNode(name: NameNode(value: 'playlistId')),
          type: NamedTypeNode(name: NameNode(value: 'ID'), isNonNull: true),
          defaultValue: DefaultValueNode(value: null),
          directives: [],
        ),
        VariableDefinitionNode(
          variable: VariableNode(name: NameNode(value: 'playlistItemId')),
          type: NamedTypeNode(name: NameNode(value: 'ID'), isNonNull: true),
          defaultValue: DefaultValueNode(value: null),
          directives: [],
        ),
        VariableDefinitionNode(
          variable: VariableNode(name: NameNode(value: 'afterPlaylistItemId')),
          type: NamedTypeNode(name: NameNode(value: 'ID'), isNonNull: false),
          defaultValue: DefaultValueNode(value: null),
          directives: [],
        ),
      ],
      directives: [],
      selectionSet: SelectionSetNode(
        selections: [
          FieldNode(
            name: NameNode(value: 'movePlaylistItem'),
            alias: null,
            arguments: [
              ArgumentNode(
                name: NameNode(value: 'playlistId'),
                value: VariableNode(name: NameNode(value: 'playlistId')),
              ),
              ArgumentNode(
                name: NameNode(value: 'playlistItemId'),
                value: VariableNode(name: NameNode(value: 'playlistItemId')),
              ),
              ArgumentNode(
                name: NameNode(value: 'afterPlaylistItemId'),
                value: VariableNode(
                  name: NameNode(value: 'afterPlaylistItemId'),
                ),
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
                  name: NameNode(value: 'items'),
                  alias: null,
                  arguments: [],
                  directives: [],
                  selectionSet: SelectionSetNode(
                    selections: [
                      FragmentSpreadNode(
                        name: NameNode(value: 'fragmentPlaylistItem'),
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
    fragmentDefinitionfragmentPlaylistItem,
    fragmentDefinitionfragmentEpisode,
    fragmentDefinitionfragmentMetadata,
    fragmentDefinitionfragmentImages,
    fragmentDefinitionfragmentMediaFiles,
    fragmentDefinitionfragmentCastMember,
    fragmentDefinitionfragmentMovie,
    fragmentDefinitionfragmentBook,
    fragmentDefinitionfragmentWatchStatus,
  ],
);

class Mutation$movePlaylistItem$movePlaylistItem {
  Mutation$movePlaylistItem$movePlaylistItem({
    required this.id,
    required this.items,
    this.$__typename = 'Playlist',
  });

  factory Mutation$movePlaylistItem$movePlaylistItem.fromJson(
    Map<String, dynamic> json,
  ) {
    final l$id = json['id'];
    final l$items = json['items'];
    final l$$__typename = json['__typename'];
    return Mutation$movePlaylistItem$movePlaylistItem(
      id: (l$id as String),
      items: (l$items as List<dynamic>)
          .map(
            (e) => Fragment$fragmentPlaylistItem.fromJson(
              (e as Map<String, dynamic>),
            ),
          )
          .toList(),
      $__typename: (l$$__typename as String),
    );
  }

  final String id;

  final List<Fragment$fragmentPlaylistItem> items;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$id = id;
    _resultData['id'] = l$id;
    final l$items = items;
    _resultData['items'] = l$items.map((e) => e.toJson()).toList();
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$id = id;
    final l$items = items;
    final l$$__typename = $__typename;
    return Object.hashAll([
      l$id,
      Object.hashAll(l$items.map((v) => v)),
      l$$__typename,
    ]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Mutation$movePlaylistItem$movePlaylistItem ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$id = id;
    final lOther$id = other.id;
    if (l$id != lOther$id) {
      return false;
    }
    final l$items = items;
    final lOther$items = other.items;
    if (l$items.length != lOther$items.length) {
      return false;
    }
    for (int i = 0; i < l$items.length; i++) {
      final l$items$entry = l$items[i];
      final lOther$items$entry = lOther$items[i];
      if (l$items$entry != lOther$items$entry) {
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

extension UtilityExtension$Mutation$movePlaylistItem$movePlaylistItem
    on Mutation$movePlaylistItem$movePlaylistItem {
  CopyWith$Mutation$movePlaylistItem$movePlaylistItem<
    Mutation$movePlaylistItem$movePlaylistItem
  >
  get copyWith =>
      CopyWith$Mutation$movePlaylistItem$movePlaylistItem(this, (i) => i);
}

abstract class CopyWith$Mutation$movePlaylistItem$movePlaylistItem<TRes> {
  factory CopyWith$Mutation$movePlaylistItem$movePlaylistItem(
    Mutation$movePlaylistItem$movePlaylistItem instance,
    TRes Function(Mutation$movePlaylistItem$movePlaylistItem) then,
  ) = _CopyWithImpl$Mutation$movePlaylistItem$movePlaylistItem;

  factory CopyWith$Mutation$movePlaylistItem$movePlaylistItem.stub(TRes res) =
      _CopyWithStubImpl$Mutation$movePlaylistItem$movePlaylistItem;

  TRes call({
    String? id,
    List<Fragment$fragmentPlaylistItem>? items,
    String? $__typename,
  });
  TRes items(
    Iterable<Fragment$fragmentPlaylistItem> Function(
      Iterable<
        CopyWith$Fragment$fragmentPlaylistItem<Fragment$fragmentPlaylistItem>
      >,
    )
    _fn,
  );
}

class _CopyWithImpl$Mutation$movePlaylistItem$movePlaylistItem<TRes>
    implements CopyWith$Mutation$movePlaylistItem$movePlaylistItem<TRes> {
  _CopyWithImpl$Mutation$movePlaylistItem$movePlaylistItem(
    this._instance,
    this._then,
  );

  final Mutation$movePlaylistItem$movePlaylistItem _instance;

  final TRes Function(Mutation$movePlaylistItem$movePlaylistItem) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? id = _undefined,
    Object? items = _undefined,
    Object? $__typename = _undefined,
  }) => _then(
    Mutation$movePlaylistItem$movePlaylistItem(
      id: id == _undefined || id == null ? _instance.id : (id as String),
      items: items == _undefined || items == null
          ? _instance.items
          : (items as List<Fragment$fragmentPlaylistItem>),
      $__typename: $__typename == _undefined || $__typename == null
          ? _instance.$__typename
          : ($__typename as String),
    ),
  );

  TRes items(
    Iterable<Fragment$fragmentPlaylistItem> Function(
      Iterable<
        CopyWith$Fragment$fragmentPlaylistItem<Fragment$fragmentPlaylistItem>
      >,
    )
    _fn,
  ) => call(
    items: _fn(
      _instance.items.map(
        (e) => CopyWith$Fragment$fragmentPlaylistItem(e, (i) => i),
      ),
    ).toList(),
  );
}

class _CopyWithStubImpl$Mutation$movePlaylistItem$movePlaylistItem<TRes>
    implements CopyWith$Mutation$movePlaylistItem$movePlaylistItem<TRes> {
  _CopyWithStubImpl$Mutation$movePlaylistItem$movePlaylistItem(this._res);

  TRes _res;

  call({
    String? id,
    List<Fragment$fragmentPlaylistItem>? items,
    String? $__typename,
  }) => _res;

  items(_fn) => _res;
}

class Variables$Mutation$removePlaylistItem {
  factory Variables$Mutation$removePlaylistItem({
    required String playlistId,
    required String playlistItemId,
  }) => Variables$Mutation$removePlaylistItem._({
    r'playlistId': playlistId,
    r'playlistItemId': playlistItemId,
  });

  Variables$Mutation$removePlaylistItem._(this._$data);

  factory Variables$Mutation$removePlaylistItem.fromJson(
    Map<String, dynamic> data,
  ) {
    final result$data = <String, dynamic>{};
    final l$playlistId = data['playlistId'];
    result$data['playlistId'] = (l$playlistId as String);
    final l$playlistItemId = data['playlistItemId'];
    result$data['playlistItemId'] = (l$playlistItemId as String);
    return Variables$Mutation$removePlaylistItem._(result$data);
  }

  Map<String, dynamic> _$data;

  String get playlistId => (_$data['playlistId'] as String);

  String get playlistItemId => (_$data['playlistItemId'] as String);

  Map<String, dynamic> toJson() {
    final result$data = <String, dynamic>{};
    final l$playlistId = playlistId;
    result$data['playlistId'] = l$playlistId;
    final l$playlistItemId = playlistItemId;
    result$data['playlistItemId'] = l$playlistItemId;
    return result$data;
  }

  CopyWith$Variables$Mutation$removePlaylistItem<
    Variables$Mutation$removePlaylistItem
  >
  get copyWith =>
      CopyWith$Variables$Mutation$removePlaylistItem(this, (i) => i);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Variables$Mutation$removePlaylistItem ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$playlistId = playlistId;
    final lOther$playlistId = other.playlistId;
    if (l$playlistId != lOther$playlistId) {
      return false;
    }
    final l$playlistItemId = playlistItemId;
    final lOther$playlistItemId = other.playlistItemId;
    if (l$playlistItemId != lOther$playlistItemId) {
      return false;
    }
    return true;
  }

  @override
  int get hashCode {
    final l$playlistId = playlistId;
    final l$playlistItemId = playlistItemId;
    return Object.hashAll([l$playlistId, l$playlistItemId]);
  }
}

abstract class CopyWith$Variables$Mutation$removePlaylistItem<TRes> {
  factory CopyWith$Variables$Mutation$removePlaylistItem(
    Variables$Mutation$removePlaylistItem instance,
    TRes Function(Variables$Mutation$removePlaylistItem) then,
  ) = _CopyWithImpl$Variables$Mutation$removePlaylistItem;

  factory CopyWith$Variables$Mutation$removePlaylistItem.stub(TRes res) =
      _CopyWithStubImpl$Variables$Mutation$removePlaylistItem;

  TRes call({String? playlistId, String? playlistItemId});
}

class _CopyWithImpl$Variables$Mutation$removePlaylistItem<TRes>
    implements CopyWith$Variables$Mutation$removePlaylistItem<TRes> {
  _CopyWithImpl$Variables$Mutation$removePlaylistItem(
    this._instance,
    this._then,
  );

  final Variables$Mutation$removePlaylistItem _instance;

  final TRes Function(Variables$Mutation$removePlaylistItem) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? playlistId = _undefined,
    Object? playlistItemId = _undefined,
  }) => _then(
    Variables$Mutation$removePlaylistItem._({
      ..._instance._$data,
      if (playlistId != _undefined && playlistId != null)
        'playlistId': (playlistId as String),
      if (playlistItemId != _undefined && playlistItemId != null)
        'playlistItemId': (playlistItemId as String),
    }),
  );
}

class _CopyWithStubImpl$Variables$Mutation$removePlaylistItem<TRes>
    implements CopyWith$Variables$Mutation$removePlaylistItem<TRes> {
  _CopyWithStubImpl$Variables$Mutation$removePlaylistItem(this._res);

  TRes _res;

  call({String? playlistId, String? playlistItemId}) => _res;
}

class Mutation$removePlaylistItem {
  Mutation$removePlaylistItem({
    required this.removePlaylistItem,
    this.$__typename = 'Mutation',
  });

  factory Mutation$removePlaylistItem.fromJson(Map<String, dynamic> json) {
    final l$removePlaylistItem = json['removePlaylistItem'];
    final l$$__typename = json['__typename'];
    return Mutation$removePlaylistItem(
      removePlaylistItem:
          Mutation$removePlaylistItem$removePlaylistItem.fromJson(
            (l$removePlaylistItem as Map<String, dynamic>),
          ),
      $__typename: (l$$__typename as String),
    );
  }

  final Mutation$removePlaylistItem$removePlaylistItem removePlaylistItem;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$removePlaylistItem = removePlaylistItem;
    _resultData['removePlaylistItem'] = l$removePlaylistItem.toJson();
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$removePlaylistItem = removePlaylistItem;
    final l$$__typename = $__typename;
    return Object.hashAll([l$removePlaylistItem, l$$__typename]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Mutation$removePlaylistItem ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$removePlaylistItem = removePlaylistItem;
    final lOther$removePlaylistItem = other.removePlaylistItem;
    if (l$removePlaylistItem != lOther$removePlaylistItem) {
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

extension UtilityExtension$Mutation$removePlaylistItem
    on Mutation$removePlaylistItem {
  CopyWith$Mutation$removePlaylistItem<Mutation$removePlaylistItem>
  get copyWith => CopyWith$Mutation$removePlaylistItem(this, (i) => i);
}

abstract class CopyWith$Mutation$removePlaylistItem<TRes> {
  factory CopyWith$Mutation$removePlaylistItem(
    Mutation$removePlaylistItem instance,
    TRes Function(Mutation$removePlaylistItem) then,
  ) = _CopyWithImpl$Mutation$removePlaylistItem;

  factory CopyWith$Mutation$removePlaylistItem.stub(TRes res) =
      _CopyWithStubImpl$Mutation$removePlaylistItem;

  TRes call({
    Mutation$removePlaylistItem$removePlaylistItem? removePlaylistItem,
    String? $__typename,
  });
  CopyWith$Mutation$removePlaylistItem$removePlaylistItem<TRes>
  get removePlaylistItem;
}

class _CopyWithImpl$Mutation$removePlaylistItem<TRes>
    implements CopyWith$Mutation$removePlaylistItem<TRes> {
  _CopyWithImpl$Mutation$removePlaylistItem(this._instance, this._then);

  final Mutation$removePlaylistItem _instance;

  final TRes Function(Mutation$removePlaylistItem) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? removePlaylistItem = _undefined,
    Object? $__typename = _undefined,
  }) => _then(
    Mutation$removePlaylistItem(
      removePlaylistItem:
          removePlaylistItem == _undefined || removePlaylistItem == null
          ? _instance.removePlaylistItem
          : (removePlaylistItem
                as Mutation$removePlaylistItem$removePlaylistItem),
      $__typename: $__typename == _undefined || $__typename == null
          ? _instance.$__typename
          : ($__typename as String),
    ),
  );

  CopyWith$Mutation$removePlaylistItem$removePlaylistItem<TRes>
  get removePlaylistItem {
    final local$removePlaylistItem = _instance.removePlaylistItem;
    return CopyWith$Mutation$removePlaylistItem$removePlaylistItem(
      local$removePlaylistItem,
      (e) => call(removePlaylistItem: e),
    );
  }
}

class _CopyWithStubImpl$Mutation$removePlaylistItem<TRes>
    implements CopyWith$Mutation$removePlaylistItem<TRes> {
  _CopyWithStubImpl$Mutation$removePlaylistItem(this._res);

  TRes _res;

  call({
    Mutation$removePlaylistItem$removePlaylistItem? removePlaylistItem,
    String? $__typename,
  }) => _res;

  CopyWith$Mutation$removePlaylistItem$removePlaylistItem<TRes>
  get removePlaylistItem =>
      CopyWith$Mutation$removePlaylistItem$removePlaylistItem.stub(_res);
}

const documentNodeMutationremovePlaylistItem = DocumentNode(
  definitions: [
    OperationDefinitionNode(
      type: OperationType.mutation,
      name: NameNode(value: 'removePlaylistItem'),
      variableDefinitions: [
        VariableDefinitionNode(
          variable: VariableNode(name: NameNode(value: 'playlistId')),
          type: NamedTypeNode(name: NameNode(value: 'ID'), isNonNull: true),
          defaultValue: DefaultValueNode(value: null),
          directives: [],
        ),
        VariableDefinitionNode(
          variable: VariableNode(name: NameNode(value: 'playlistItemId')),
          type: NamedTypeNode(name: NameNode(value: 'ID'), isNonNull: true),
          defaultValue: DefaultValueNode(value: null),
          directives: [],
        ),
      ],
      directives: [],
      selectionSet: SelectionSetNode(
        selections: [
          FieldNode(
            name: NameNode(value: 'removePlaylistItem'),
            alias: null,
            arguments: [
              ArgumentNode(
                name: NameNode(value: 'playlistId'),
                value: VariableNode(name: NameNode(value: 'playlistId')),
              ),
              ArgumentNode(
                name: NameNode(value: 'playlistItemId'),
                value: VariableNode(name: NameNode(value: 'playlistItemId')),
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
                  name: NameNode(value: 'items'),
                  alias: null,
                  arguments: [],
                  directives: [],
                  selectionSet: SelectionSetNode(
                    selections: [
                      FragmentSpreadNode(
                        name: NameNode(value: 'fragmentPlaylistItem'),
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
    fragmentDefinitionfragmentPlaylistItem,
    fragmentDefinitionfragmentEpisode,
    fragmentDefinitionfragmentMetadata,
    fragmentDefinitionfragmentImages,
    fragmentDefinitionfragmentMediaFiles,
    fragmentDefinitionfragmentCastMember,
    fragmentDefinitionfragmentMovie,
    fragmentDefinitionfragmentBook,
    fragmentDefinitionfragmentWatchStatus,
  ],
);

class Mutation$removePlaylistItem$removePlaylistItem {
  Mutation$removePlaylistItem$removePlaylistItem({
    required this.id,
    required this.items,
    this.$__typename = 'Playlist',
  });

  factory Mutation$removePlaylistItem$removePlaylistItem.fromJson(
    Map<String, dynamic> json,
  ) {
    final l$id = json['id'];
    final l$items = json['items'];
    final l$$__typename = json['__typename'];
    return Mutation$removePlaylistItem$removePlaylistItem(
      id: (l$id as String),
      items: (l$items as List<dynamic>)
          .map(
            (e) => Fragment$fragmentPlaylistItem.fromJson(
              (e as Map<String, dynamic>),
            ),
          )
          .toList(),
      $__typename: (l$$__typename as String),
    );
  }

  final String id;

  final List<Fragment$fragmentPlaylistItem> items;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$id = id;
    _resultData['id'] = l$id;
    final l$items = items;
    _resultData['items'] = l$items.map((e) => e.toJson()).toList();
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$id = id;
    final l$items = items;
    final l$$__typename = $__typename;
    return Object.hashAll([
      l$id,
      Object.hashAll(l$items.map((v) => v)),
      l$$__typename,
    ]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Mutation$removePlaylistItem$removePlaylistItem ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$id = id;
    final lOther$id = other.id;
    if (l$id != lOther$id) {
      return false;
    }
    final l$items = items;
    final lOther$items = other.items;
    if (l$items.length != lOther$items.length) {
      return false;
    }
    for (int i = 0; i < l$items.length; i++) {
      final l$items$entry = l$items[i];
      final lOther$items$entry = lOther$items[i];
      if (l$items$entry != lOther$items$entry) {
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

extension UtilityExtension$Mutation$removePlaylistItem$removePlaylistItem
    on Mutation$removePlaylistItem$removePlaylistItem {
  CopyWith$Mutation$removePlaylistItem$removePlaylistItem<
    Mutation$removePlaylistItem$removePlaylistItem
  >
  get copyWith =>
      CopyWith$Mutation$removePlaylistItem$removePlaylistItem(this, (i) => i);
}

abstract class CopyWith$Mutation$removePlaylistItem$removePlaylistItem<TRes> {
  factory CopyWith$Mutation$removePlaylistItem$removePlaylistItem(
    Mutation$removePlaylistItem$removePlaylistItem instance,
    TRes Function(Mutation$removePlaylistItem$removePlaylistItem) then,
  ) = _CopyWithImpl$Mutation$removePlaylistItem$removePlaylistItem;

  factory CopyWith$Mutation$removePlaylistItem$removePlaylistItem.stub(
    TRes res,
  ) = _CopyWithStubImpl$Mutation$removePlaylistItem$removePlaylistItem;

  TRes call({
    String? id,
    List<Fragment$fragmentPlaylistItem>? items,
    String? $__typename,
  });
  TRes items(
    Iterable<Fragment$fragmentPlaylistItem> Function(
      Iterable<
        CopyWith$Fragment$fragmentPlaylistItem<Fragment$fragmentPlaylistItem>
      >,
    )
    _fn,
  );
}

class _CopyWithImpl$Mutation$removePlaylistItem$removePlaylistItem<TRes>
    implements CopyWith$Mutation$removePlaylistItem$removePlaylistItem<TRes> {
  _CopyWithImpl$Mutation$removePlaylistItem$removePlaylistItem(
    this._instance,
    this._then,
  );

  final Mutation$removePlaylistItem$removePlaylistItem _instance;

  final TRes Function(Mutation$removePlaylistItem$removePlaylistItem) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? id = _undefined,
    Object? items = _undefined,
    Object? $__typename = _undefined,
  }) => _then(
    Mutation$removePlaylistItem$removePlaylistItem(
      id: id == _undefined || id == null ? _instance.id : (id as String),
      items: items == _undefined || items == null
          ? _instance.items
          : (items as List<Fragment$fragmentPlaylistItem>),
      $__typename: $__typename == _undefined || $__typename == null
          ? _instance.$__typename
          : ($__typename as String),
    ),
  );

  TRes items(
    Iterable<Fragment$fragmentPlaylistItem> Function(
      Iterable<
        CopyWith$Fragment$fragmentPlaylistItem<Fragment$fragmentPlaylistItem>
      >,
    )
    _fn,
  ) => call(
    items: _fn(
      _instance.items.map(
        (e) => CopyWith$Fragment$fragmentPlaylistItem(e, (i) => i),
      ),
    ).toList(),
  );
}

class _CopyWithStubImpl$Mutation$removePlaylistItem$removePlaylistItem<TRes>
    implements CopyWith$Mutation$removePlaylistItem$removePlaylistItem<TRes> {
  _CopyWithStubImpl$Mutation$removePlaylistItem$removePlaylistItem(this._res);

  TRes _res;

  call({
    String? id,
    List<Fragment$fragmentPlaylistItem>? items,
    String? $__typename,
  }) => _res;

  items(_fn) => _res;
}

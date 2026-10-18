import 'fragmentGame.graphql.dart';
import 'fragmentImages.graphql.dart';
import 'fragmentMetadata.graphql.dart';

import 'package:gql/ast.dart';

import 'schema.graphql.dart';

class Variables$Query$games {
  factory Variables$Query$games({
    int? page,
    int? size,
    Enum$SortingEnum? sorting,
    Enum$SortingOrder? sortingOrder,
    String? libraryId,
    Enum$GamePlatform? platform,
  }) => Variables$Query$games._({
    if (page != null) r'page': page,
    if (size != null) r'size': size,
    if (sorting != null) r'sorting': sorting,
    if (sortingOrder != null) r'sortingOrder': sortingOrder,
    if (libraryId != null) r'libraryId': libraryId,
    if (platform != null) r'platform': platform,
  });

  Variables$Query$games._(this._$data);

  factory Variables$Query$games.fromJson(Map<String, dynamic> data) {
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
    if (data.containsKey('platform')) {
      final l$platform = data['platform'];
      result$data['platform'] = l$platform == null
          ? null
          : fromJson$Enum$GamePlatform((l$platform as String));
    }
    return Variables$Query$games._(result$data);
  }

  Map<String, dynamic> _$data;

  int? get page => (_$data['page'] as int?);

  int? get size => (_$data['size'] as int?);

  Enum$SortingEnum? get sorting => (_$data['sorting'] as Enum$SortingEnum?);

  Enum$SortingOrder? get sortingOrder =>
      (_$data['sortingOrder'] as Enum$SortingOrder?);

  String? get libraryId => (_$data['libraryId'] as String?);

  Enum$GamePlatform? get platform => (_$data['platform'] as Enum$GamePlatform?);

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
    if (_$data.containsKey('platform')) {
      final l$platform = platform;
      result$data['platform'] = l$platform == null
          ? null
          : toJson$Enum$GamePlatform(l$platform);
    }
    return result$data;
  }

  CopyWith$Variables$Query$games<Variables$Query$games> get copyWith =>
      CopyWith$Variables$Query$games(this, (i) => i);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Variables$Query$games || runtimeType != other.runtimeType) {
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
    final l$platform = platform;
    final lOther$platform = other.platform;
    if (_$data.containsKey('platform') !=
        other._$data.containsKey('platform')) {
      return false;
    }
    if (l$platform != lOther$platform) {
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
    final l$platform = platform;
    return Object.hashAll([
      _$data.containsKey('page') ? l$page : const {},
      _$data.containsKey('size') ? l$size : const {},
      _$data.containsKey('sorting') ? l$sorting : const {},
      _$data.containsKey('sortingOrder') ? l$sortingOrder : const {},
      _$data.containsKey('libraryId') ? l$libraryId : const {},
      _$data.containsKey('platform') ? l$platform : const {},
    ]);
  }
}

abstract class CopyWith$Variables$Query$games<TRes> {
  factory CopyWith$Variables$Query$games(
    Variables$Query$games instance,
    TRes Function(Variables$Query$games) then,
  ) = _CopyWithImpl$Variables$Query$games;

  factory CopyWith$Variables$Query$games.stub(TRes res) =
      _CopyWithStubImpl$Variables$Query$games;

  TRes call({
    int? page,
    int? size,
    Enum$SortingEnum? sorting,
    Enum$SortingOrder? sortingOrder,
    String? libraryId,
    Enum$GamePlatform? platform,
  });
}

class _CopyWithImpl$Variables$Query$games<TRes>
    implements CopyWith$Variables$Query$games<TRes> {
  _CopyWithImpl$Variables$Query$games(this._instance, this._then);

  final Variables$Query$games _instance;

  final TRes Function(Variables$Query$games) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? page = _undefined,
    Object? size = _undefined,
    Object? sorting = _undefined,
    Object? sortingOrder = _undefined,
    Object? libraryId = _undefined,
    Object? platform = _undefined,
  }) => _then(
    Variables$Query$games._({
      ..._instance._$data,
      if (page != _undefined) 'page': (page as int?),
      if (size != _undefined) 'size': (size as int?),
      if (sorting != _undefined) 'sorting': (sorting as Enum$SortingEnum?),
      if (sortingOrder != _undefined)
        'sortingOrder': (sortingOrder as Enum$SortingOrder?),
      if (libraryId != _undefined) 'libraryId': (libraryId as String?),
      if (platform != _undefined) 'platform': (platform as Enum$GamePlatform?),
    }),
  );
}

class _CopyWithStubImpl$Variables$Query$games<TRes>
    implements CopyWith$Variables$Query$games<TRes> {
  _CopyWithStubImpl$Variables$Query$games(this._res);

  TRes _res;

  call({
    int? page,
    int? size,
    Enum$SortingEnum? sorting,
    Enum$SortingOrder? sortingOrder,
    String? libraryId,
    Enum$GamePlatform? platform,
  }) => _res;
}

class Query$games {
  Query$games({this.games, this.$__typename = 'Query'});

  factory Query$games.fromJson(Map<String, dynamic> json) {
    final l$games = json['games'];
    final l$$__typename = json['__typename'];
    return Query$games(
      games: l$games == null
          ? null
          : Query$games$games.fromJson((l$games as Map<String, dynamic>)),
      $__typename: (l$$__typename as String),
    );
  }

  final Query$games$games? games;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$games = games;
    _resultData['games'] = l$games?.toJson();
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$games = games;
    final l$$__typename = $__typename;
    return Object.hashAll([l$games, l$$__typename]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Query$games || runtimeType != other.runtimeType) {
      return false;
    }
    final l$games = games;
    final lOther$games = other.games;
    if (l$games != lOther$games) {
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

extension UtilityExtension$Query$games on Query$games {
  CopyWith$Query$games<Query$games> get copyWith =>
      CopyWith$Query$games(this, (i) => i);
}

abstract class CopyWith$Query$games<TRes> {
  factory CopyWith$Query$games(
    Query$games instance,
    TRes Function(Query$games) then,
  ) = _CopyWithImpl$Query$games;

  factory CopyWith$Query$games.stub(TRes res) = _CopyWithStubImpl$Query$games;

  TRes call({Query$games$games? games, String? $__typename});
  CopyWith$Query$games$games<TRes> get games;
}

class _CopyWithImpl$Query$games<TRes> implements CopyWith$Query$games<TRes> {
  _CopyWithImpl$Query$games(this._instance, this._then);

  final Query$games _instance;

  final TRes Function(Query$games) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({Object? games = _undefined, Object? $__typename = _undefined}) =>
      _then(
        Query$games(
          games: games == _undefined
              ? _instance.games
              : (games as Query$games$games?),
          $__typename: $__typename == _undefined || $__typename == null
              ? _instance.$__typename
              : ($__typename as String),
        ),
      );

  CopyWith$Query$games$games<TRes> get games {
    final local$games = _instance.games;
    return local$games == null
        ? CopyWith$Query$games$games.stub(_then(_instance))
        : CopyWith$Query$games$games(local$games, (e) => call(games: e));
  }
}

class _CopyWithStubImpl$Query$games<TRes>
    implements CopyWith$Query$games<TRes> {
  _CopyWithStubImpl$Query$games(this._res);

  TRes _res;

  call({Query$games$games? games, String? $__typename}) => _res;

  CopyWith$Query$games$games<TRes> get games =>
      CopyWith$Query$games$games.stub(_res);
}

const documentNodeQuerygames = DocumentNode(
  definitions: [
    OperationDefinitionNode(
      type: OperationType.query,
      name: NameNode(value: 'games'),
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
          variable: VariableNode(name: NameNode(value: 'platform')),
          type: NamedTypeNode(
            name: NameNode(value: 'GamePlatform'),
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
            name: NameNode(value: 'games'),
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
                name: NameNode(value: 'platform'),
                value: VariableNode(name: NameNode(value: 'platform')),
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
                        name: NameNode(value: 'fragmentGame'),
                        directives: [],
                      ),
                      FieldNode(
                        name: NameNode(value: 'savePathSource'),
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
    fragmentDefinitionfragmentGame,
    fragmentDefinitionfragmentImages,
    fragmentDefinitionfragmentMetadata,
  ],
);

class Query$games$games {
  Query$games$games({
    required this.content,
    required this.totalPages,
    required this.totalElements,
    required this.number,
    required this.size,
    this.$__typename = 'GamePage',
  });

  factory Query$games$games.fromJson(Map<String, dynamic> json) {
    final l$content = json['content'];
    final l$totalPages = json['totalPages'];
    final l$totalElements = json['totalElements'];
    final l$number = json['number'];
    final l$size = json['size'];
    final l$$__typename = json['__typename'];
    return Query$games$games(
      content: (l$content as List<dynamic>)
          .map(
            (e) =>
                Query$games$games$content.fromJson((e as Map<String, dynamic>)),
          )
          .toList(),
      totalPages: (l$totalPages as int),
      totalElements: (l$totalElements as int),
      number: (l$number as int),
      size: (l$size as int),
      $__typename: (l$$__typename as String),
    );
  }

  final List<Query$games$games$content> content;

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
    if (other is! Query$games$games || runtimeType != other.runtimeType) {
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

extension UtilityExtension$Query$games$games on Query$games$games {
  CopyWith$Query$games$games<Query$games$games> get copyWith =>
      CopyWith$Query$games$games(this, (i) => i);
}

abstract class CopyWith$Query$games$games<TRes> {
  factory CopyWith$Query$games$games(
    Query$games$games instance,
    TRes Function(Query$games$games) then,
  ) = _CopyWithImpl$Query$games$games;

  factory CopyWith$Query$games$games.stub(TRes res) =
      _CopyWithStubImpl$Query$games$games;

  TRes call({
    List<Query$games$games$content>? content,
    int? totalPages,
    int? totalElements,
    int? number,
    int? size,
    String? $__typename,
  });
  TRes content(
    Iterable<Query$games$games$content> Function(
      Iterable<CopyWith$Query$games$games$content<Query$games$games$content>>,
    )
    _fn,
  );
}

class _CopyWithImpl$Query$games$games<TRes>
    implements CopyWith$Query$games$games<TRes> {
  _CopyWithImpl$Query$games$games(this._instance, this._then);

  final Query$games$games _instance;

  final TRes Function(Query$games$games) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? content = _undefined,
    Object? totalPages = _undefined,
    Object? totalElements = _undefined,
    Object? number = _undefined,
    Object? size = _undefined,
    Object? $__typename = _undefined,
  }) => _then(
    Query$games$games(
      content: content == _undefined || content == null
          ? _instance.content
          : (content as List<Query$games$games$content>),
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
    Iterable<Query$games$games$content> Function(
      Iterable<CopyWith$Query$games$games$content<Query$games$games$content>>,
    )
    _fn,
  ) => call(
    content: _fn(
      _instance.content.map(
        (e) => CopyWith$Query$games$games$content(e, (i) => i),
      ),
    ).toList(),
  );
}

class _CopyWithStubImpl$Query$games$games<TRes>
    implements CopyWith$Query$games$games<TRes> {
  _CopyWithStubImpl$Query$games$games(this._res);

  TRes _res;

  call({
    List<Query$games$games$content>? content,
    int? totalPages,
    int? totalElements,
    int? number,
    int? size,
    String? $__typename,
  }) => _res;

  content(_fn) => _res;
}

class Query$games$games$content implements Fragment$fragmentGame {
  Query$games$games$content({
    required this.id,
    required this.name,
    required this.title,
    required this.releaseYear,
    required this.platform,
    required this.form,
    this.entryPath,
    this.titleId,
    this.steamAppId,
    this.steamInstallDir,
    required this.steamCloud,
    required this.sizeBytes,
    required this.fileCount,
    required this.launcher,
    this.images,
    this.metadata,
    this.rating,
    this.lastPlayed,
    required this.playTimeMs,
    this.$__typename = 'Game',
    required this.savePathSource,
  });

  factory Query$games$games$content.fromJson(Map<String, dynamic> json) {
    final l$id = json['id'];
    final l$name = json['name'];
    final l$title = json['title'];
    final l$releaseYear = json['releaseYear'];
    final l$platform = json['platform'];
    final l$form = json['form'];
    final l$entryPath = json['entryPath'];
    final l$titleId = json['titleId'];
    final l$steamAppId = json['steamAppId'];
    final l$steamInstallDir = json['steamInstallDir'];
    final l$steamCloud = json['steamCloud'];
    final l$sizeBytes = json['sizeBytes'];
    final l$fileCount = json['fileCount'];
    final l$launcher = json['launcher'];
    final l$images = json['images'];
    final l$metadata = json['metadata'];
    final l$rating = json['rating'];
    final l$lastPlayed = json['lastPlayed'];
    final l$playTimeMs = json['playTimeMs'];
    final l$$__typename = json['__typename'];
    final l$savePathSource = json['savePathSource'];
    return Query$games$games$content(
      id: (l$id as String),
      name: (l$name as String),
      title: (l$title as String),
      releaseYear: (l$releaseYear as int),
      platform: fromJson$Enum$GamePlatform((l$platform as String)),
      form: fromJson$Enum$GameForm((l$form as String)),
      entryPath: (l$entryPath as String?),
      titleId: (l$titleId as String?),
      steamAppId: (l$steamAppId as String?),
      steamInstallDir: (l$steamInstallDir as String?),
      steamCloud: (l$steamCloud as bool),
      sizeBytes: (l$sizeBytes as num).toDouble(),
      fileCount: (l$fileCount as int),
      launcher: Query$games$games$content$launcher.fromJson(
        (l$launcher as Map<String, dynamic>),
      ),
      images: (l$images as List<dynamic>?)
          ?.map(
            (e) =>
                Fragment$fragmentImages.fromJson((e as Map<String, dynamic>)),
          )
          .toList(),
      metadata: (l$metadata as List<dynamic>?)
          ?.map(
            (e) =>
                Fragment$fragmentMetadata.fromJson((e as Map<String, dynamic>)),
          )
          .toList(),
      rating: (l$rating as int?),
      lastPlayed: (l$lastPlayed as String?),
      playTimeMs: (l$playTimeMs as num).toDouble(),
      $__typename: (l$$__typename as String),
      savePathSource: (l$savePathSource as String),
    );
  }

  final String id;

  final String name;

  final String title;

  final int releaseYear;

  final Enum$GamePlatform platform;

  final Enum$GameForm form;

  final String? entryPath;

  final String? titleId;

  final String? steamAppId;

  final String? steamInstallDir;

  final bool steamCloud;

  final double sizeBytes;

  final int fileCount;

  final Query$games$games$content$launcher launcher;

  final List<Fragment$fragmentImages>? images;

  final List<Fragment$fragmentMetadata>? metadata;

  final int? rating;

  final String? lastPlayed;

  final double playTimeMs;

  final String $__typename;

  final String savePathSource;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$id = id;
    _resultData['id'] = l$id;
    final l$name = name;
    _resultData['name'] = l$name;
    final l$title = title;
    _resultData['title'] = l$title;
    final l$releaseYear = releaseYear;
    _resultData['releaseYear'] = l$releaseYear;
    final l$platform = platform;
    _resultData['platform'] = toJson$Enum$GamePlatform(l$platform);
    final l$form = form;
    _resultData['form'] = toJson$Enum$GameForm(l$form);
    final l$entryPath = entryPath;
    _resultData['entryPath'] = l$entryPath;
    final l$titleId = titleId;
    _resultData['titleId'] = l$titleId;
    final l$steamAppId = steamAppId;
    _resultData['steamAppId'] = l$steamAppId;
    final l$steamInstallDir = steamInstallDir;
    _resultData['steamInstallDir'] = l$steamInstallDir;
    final l$steamCloud = steamCloud;
    _resultData['steamCloud'] = l$steamCloud;
    final l$sizeBytes = sizeBytes;
    _resultData['sizeBytes'] = l$sizeBytes;
    final l$fileCount = fileCount;
    _resultData['fileCount'] = l$fileCount;
    final l$launcher = launcher;
    _resultData['launcher'] = l$launcher.toJson();
    final l$images = images;
    _resultData['images'] = l$images?.map((e) => e.toJson()).toList();
    final l$metadata = metadata;
    _resultData['metadata'] = l$metadata?.map((e) => e.toJson()).toList();
    final l$rating = rating;
    _resultData['rating'] = l$rating;
    final l$lastPlayed = lastPlayed;
    _resultData['lastPlayed'] = l$lastPlayed;
    final l$playTimeMs = playTimeMs;
    _resultData['playTimeMs'] = l$playTimeMs;
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    final l$savePathSource = savePathSource;
    _resultData['savePathSource'] = l$savePathSource;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$id = id;
    final l$name = name;
    final l$title = title;
    final l$releaseYear = releaseYear;
    final l$platform = platform;
    final l$form = form;
    final l$entryPath = entryPath;
    final l$titleId = titleId;
    final l$steamAppId = steamAppId;
    final l$steamInstallDir = steamInstallDir;
    final l$steamCloud = steamCloud;
    final l$sizeBytes = sizeBytes;
    final l$fileCount = fileCount;
    final l$launcher = launcher;
    final l$images = images;
    final l$metadata = metadata;
    final l$rating = rating;
    final l$lastPlayed = lastPlayed;
    final l$playTimeMs = playTimeMs;
    final l$$__typename = $__typename;
    final l$savePathSource = savePathSource;
    return Object.hashAll([
      l$id,
      l$name,
      l$title,
      l$releaseYear,
      l$platform,
      l$form,
      l$entryPath,
      l$titleId,
      l$steamAppId,
      l$steamInstallDir,
      l$steamCloud,
      l$sizeBytes,
      l$fileCount,
      l$launcher,
      l$images == null ? null : Object.hashAll(l$images.map((v) => v)),
      l$metadata == null ? null : Object.hashAll(l$metadata.map((v) => v)),
      l$rating,
      l$lastPlayed,
      l$playTimeMs,
      l$$__typename,
      l$savePathSource,
    ]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Query$games$games$content ||
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
    final l$title = title;
    final lOther$title = other.title;
    if (l$title != lOther$title) {
      return false;
    }
    final l$releaseYear = releaseYear;
    final lOther$releaseYear = other.releaseYear;
    if (l$releaseYear != lOther$releaseYear) {
      return false;
    }
    final l$platform = platform;
    final lOther$platform = other.platform;
    if (l$platform != lOther$platform) {
      return false;
    }
    final l$form = form;
    final lOther$form = other.form;
    if (l$form != lOther$form) {
      return false;
    }
    final l$entryPath = entryPath;
    final lOther$entryPath = other.entryPath;
    if (l$entryPath != lOther$entryPath) {
      return false;
    }
    final l$titleId = titleId;
    final lOther$titleId = other.titleId;
    if (l$titleId != lOther$titleId) {
      return false;
    }
    final l$steamAppId = steamAppId;
    final lOther$steamAppId = other.steamAppId;
    if (l$steamAppId != lOther$steamAppId) {
      return false;
    }
    final l$steamInstallDir = steamInstallDir;
    final lOther$steamInstallDir = other.steamInstallDir;
    if (l$steamInstallDir != lOther$steamInstallDir) {
      return false;
    }
    final l$steamCloud = steamCloud;
    final lOther$steamCloud = other.steamCloud;
    if (l$steamCloud != lOther$steamCloud) {
      return false;
    }
    final l$sizeBytes = sizeBytes;
    final lOther$sizeBytes = other.sizeBytes;
    if (l$sizeBytes != lOther$sizeBytes) {
      return false;
    }
    final l$fileCount = fileCount;
    final lOther$fileCount = other.fileCount;
    if (l$fileCount != lOther$fileCount) {
      return false;
    }
    final l$launcher = launcher;
    final lOther$launcher = other.launcher;
    if (l$launcher != lOther$launcher) {
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
    final l$rating = rating;
    final lOther$rating = other.rating;
    if (l$rating != lOther$rating) {
      return false;
    }
    final l$lastPlayed = lastPlayed;
    final lOther$lastPlayed = other.lastPlayed;
    if (l$lastPlayed != lOther$lastPlayed) {
      return false;
    }
    final l$playTimeMs = playTimeMs;
    final lOther$playTimeMs = other.playTimeMs;
    if (l$playTimeMs != lOther$playTimeMs) {
      return false;
    }
    final l$$__typename = $__typename;
    final lOther$$__typename = other.$__typename;
    if (l$$__typename != lOther$$__typename) {
      return false;
    }
    final l$savePathSource = savePathSource;
    final lOther$savePathSource = other.savePathSource;
    if (l$savePathSource != lOther$savePathSource) {
      return false;
    }
    return true;
  }
}

extension UtilityExtension$Query$games$games$content
    on Query$games$games$content {
  CopyWith$Query$games$games$content<Query$games$games$content> get copyWith =>
      CopyWith$Query$games$games$content(this, (i) => i);
}

abstract class CopyWith$Query$games$games$content<TRes> {
  factory CopyWith$Query$games$games$content(
    Query$games$games$content instance,
    TRes Function(Query$games$games$content) then,
  ) = _CopyWithImpl$Query$games$games$content;

  factory CopyWith$Query$games$games$content.stub(TRes res) =
      _CopyWithStubImpl$Query$games$games$content;

  TRes call({
    String? id,
    String? name,
    String? title,
    int? releaseYear,
    Enum$GamePlatform? platform,
    Enum$GameForm? form,
    String? entryPath,
    String? titleId,
    String? steamAppId,
    String? steamInstallDir,
    bool? steamCloud,
    double? sizeBytes,
    int? fileCount,
    Query$games$games$content$launcher? launcher,
    List<Fragment$fragmentImages>? images,
    List<Fragment$fragmentMetadata>? metadata,
    int? rating,
    String? lastPlayed,
    double? playTimeMs,
    String? $__typename,
    String? savePathSource,
  });
  CopyWith$Query$games$games$content$launcher<TRes> get launcher;
  TRes images(
    Iterable<Fragment$fragmentImages>? Function(
      Iterable<CopyWith$Fragment$fragmentImages<Fragment$fragmentImages>>?,
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

class _CopyWithImpl$Query$games$games$content<TRes>
    implements CopyWith$Query$games$games$content<TRes> {
  _CopyWithImpl$Query$games$games$content(this._instance, this._then);

  final Query$games$games$content _instance;

  final TRes Function(Query$games$games$content) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? id = _undefined,
    Object? name = _undefined,
    Object? title = _undefined,
    Object? releaseYear = _undefined,
    Object? platform = _undefined,
    Object? form = _undefined,
    Object? entryPath = _undefined,
    Object? titleId = _undefined,
    Object? steamAppId = _undefined,
    Object? steamInstallDir = _undefined,
    Object? steamCloud = _undefined,
    Object? sizeBytes = _undefined,
    Object? fileCount = _undefined,
    Object? launcher = _undefined,
    Object? images = _undefined,
    Object? metadata = _undefined,
    Object? rating = _undefined,
    Object? lastPlayed = _undefined,
    Object? playTimeMs = _undefined,
    Object? $__typename = _undefined,
    Object? savePathSource = _undefined,
  }) => _then(
    Query$games$games$content(
      id: id == _undefined || id == null ? _instance.id : (id as String),
      name: name == _undefined || name == null
          ? _instance.name
          : (name as String),
      title: title == _undefined || title == null
          ? _instance.title
          : (title as String),
      releaseYear: releaseYear == _undefined || releaseYear == null
          ? _instance.releaseYear
          : (releaseYear as int),
      platform: platform == _undefined || platform == null
          ? _instance.platform
          : (platform as Enum$GamePlatform),
      form: form == _undefined || form == null
          ? _instance.form
          : (form as Enum$GameForm),
      entryPath: entryPath == _undefined
          ? _instance.entryPath
          : (entryPath as String?),
      titleId: titleId == _undefined ? _instance.titleId : (titleId as String?),
      steamAppId: steamAppId == _undefined
          ? _instance.steamAppId
          : (steamAppId as String?),
      steamInstallDir: steamInstallDir == _undefined
          ? _instance.steamInstallDir
          : (steamInstallDir as String?),
      steamCloud: steamCloud == _undefined || steamCloud == null
          ? _instance.steamCloud
          : (steamCloud as bool),
      sizeBytes: sizeBytes == _undefined || sizeBytes == null
          ? _instance.sizeBytes
          : (sizeBytes as double),
      fileCount: fileCount == _undefined || fileCount == null
          ? _instance.fileCount
          : (fileCount as int),
      launcher: launcher == _undefined || launcher == null
          ? _instance.launcher
          : (launcher as Query$games$games$content$launcher),
      images: images == _undefined
          ? _instance.images
          : (images as List<Fragment$fragmentImages>?),
      metadata: metadata == _undefined
          ? _instance.metadata
          : (metadata as List<Fragment$fragmentMetadata>?),
      rating: rating == _undefined ? _instance.rating : (rating as int?),
      lastPlayed: lastPlayed == _undefined
          ? _instance.lastPlayed
          : (lastPlayed as String?),
      playTimeMs: playTimeMs == _undefined || playTimeMs == null
          ? _instance.playTimeMs
          : (playTimeMs as double),
      $__typename: $__typename == _undefined || $__typename == null
          ? _instance.$__typename
          : ($__typename as String),
      savePathSource: savePathSource == _undefined || savePathSource == null
          ? _instance.savePathSource
          : (savePathSource as String),
    ),
  );

  CopyWith$Query$games$games$content$launcher<TRes> get launcher {
    final local$launcher = _instance.launcher;
    return CopyWith$Query$games$games$content$launcher(
      local$launcher,
      (e) => call(launcher: e),
    );
  }

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

class _CopyWithStubImpl$Query$games$games$content<TRes>
    implements CopyWith$Query$games$games$content<TRes> {
  _CopyWithStubImpl$Query$games$games$content(this._res);

  TRes _res;

  call({
    String? id,
    String? name,
    String? title,
    int? releaseYear,
    Enum$GamePlatform? platform,
    Enum$GameForm? form,
    String? entryPath,
    String? titleId,
    String? steamAppId,
    String? steamInstallDir,
    bool? steamCloud,
    double? sizeBytes,
    int? fileCount,
    Query$games$games$content$launcher? launcher,
    List<Fragment$fragmentImages>? images,
    List<Fragment$fragmentMetadata>? metadata,
    int? rating,
    String? lastPlayed,
    double? playTimeMs,
    String? $__typename,
    String? savePathSource,
  }) => _res;

  CopyWith$Query$games$games$content$launcher<TRes> get launcher =>
      CopyWith$Query$games$games$content$launcher.stub(_res);

  images(_fn) => _res;

  metadata(_fn) => _res;
}

class Query$games$games$content$launcher
    implements Fragment$fragmentGame$launcher {
  Query$games$games$content$launcher({
    required this.kind,
    this.retroArchCore,
    this.$__typename = 'GameLauncherHint',
  });

  factory Query$games$games$content$launcher.fromJson(
    Map<String, dynamic> json,
  ) {
    final l$kind = json['kind'];
    final l$retroArchCore = json['retroArchCore'];
    final l$$__typename = json['__typename'];
    return Query$games$games$content$launcher(
      kind: fromJson$Enum$GameLauncherKind((l$kind as String)),
      retroArchCore: (l$retroArchCore as String?),
      $__typename: (l$$__typename as String),
    );
  }

  final Enum$GameLauncherKind kind;

  final String? retroArchCore;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$kind = kind;
    _resultData['kind'] = toJson$Enum$GameLauncherKind(l$kind);
    final l$retroArchCore = retroArchCore;
    _resultData['retroArchCore'] = l$retroArchCore;
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$kind = kind;
    final l$retroArchCore = retroArchCore;
    final l$$__typename = $__typename;
    return Object.hashAll([l$kind, l$retroArchCore, l$$__typename]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Query$games$games$content$launcher ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$kind = kind;
    final lOther$kind = other.kind;
    if (l$kind != lOther$kind) {
      return false;
    }
    final l$retroArchCore = retroArchCore;
    final lOther$retroArchCore = other.retroArchCore;
    if (l$retroArchCore != lOther$retroArchCore) {
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

extension UtilityExtension$Query$games$games$content$launcher
    on Query$games$games$content$launcher {
  CopyWith$Query$games$games$content$launcher<
    Query$games$games$content$launcher
  >
  get copyWith => CopyWith$Query$games$games$content$launcher(this, (i) => i);
}

abstract class CopyWith$Query$games$games$content$launcher<TRes> {
  factory CopyWith$Query$games$games$content$launcher(
    Query$games$games$content$launcher instance,
    TRes Function(Query$games$games$content$launcher) then,
  ) = _CopyWithImpl$Query$games$games$content$launcher;

  factory CopyWith$Query$games$games$content$launcher.stub(TRes res) =
      _CopyWithStubImpl$Query$games$games$content$launcher;

  TRes call({
    Enum$GameLauncherKind? kind,
    String? retroArchCore,
    String? $__typename,
  });
}

class _CopyWithImpl$Query$games$games$content$launcher<TRes>
    implements CopyWith$Query$games$games$content$launcher<TRes> {
  _CopyWithImpl$Query$games$games$content$launcher(this._instance, this._then);

  final Query$games$games$content$launcher _instance;

  final TRes Function(Query$games$games$content$launcher) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? kind = _undefined,
    Object? retroArchCore = _undefined,
    Object? $__typename = _undefined,
  }) => _then(
    Query$games$games$content$launcher(
      kind: kind == _undefined || kind == null
          ? _instance.kind
          : (kind as Enum$GameLauncherKind),
      retroArchCore: retroArchCore == _undefined
          ? _instance.retroArchCore
          : (retroArchCore as String?),
      $__typename: $__typename == _undefined || $__typename == null
          ? _instance.$__typename
          : ($__typename as String),
    ),
  );
}

class _CopyWithStubImpl$Query$games$games$content$launcher<TRes>
    implements CopyWith$Query$games$games$content$launcher<TRes> {
  _CopyWithStubImpl$Query$games$games$content$launcher(this._res);

  TRes _res;

  call({
    Enum$GameLauncherKind? kind,
    String? retroArchCore,
    String? $__typename,
  }) => _res;
}

import 'fragmentImages.graphql.dart';
import 'fragmentMetadata.graphql.dart';
import 'package:gql/ast.dart';

class Query$showsRecentAdded {
  Query$showsRecentAdded({this.showsRecentAdded, this.$__typename = 'Query'});

  factory Query$showsRecentAdded.fromJson(Map<String, dynamic> json) {
    final l$showsRecentAdded = json['showsRecentAdded'];
    final l$$__typename = json['__typename'];
    return Query$showsRecentAdded(
      showsRecentAdded: (l$showsRecentAdded as List<dynamic>?)
          ?.map(
            (e) => Query$showsRecentAdded$showsRecentAdded.fromJson(
              (e as Map<String, dynamic>),
            ),
          )
          .toList(),
      $__typename: (l$$__typename as String),
    );
  }

  final List<Query$showsRecentAdded$showsRecentAdded>? showsRecentAdded;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$showsRecentAdded = showsRecentAdded;
    _resultData['showsRecentAdded'] = l$showsRecentAdded
        ?.map((e) => e.toJson())
        .toList();
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$showsRecentAdded = showsRecentAdded;
    final l$$__typename = $__typename;
    return Object.hashAll([
      l$showsRecentAdded == null
          ? null
          : Object.hashAll(l$showsRecentAdded.map((v) => v)),
      l$$__typename,
    ]);
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
    if (l$showsRecentAdded != null && lOther$showsRecentAdded != null) {
      if (l$showsRecentAdded.length != lOther$showsRecentAdded.length) {
        return false;
      }
      for (int i = 0; i < l$showsRecentAdded.length; i++) {
        final l$showsRecentAdded$entry = l$showsRecentAdded[i];
        final lOther$showsRecentAdded$entry = lOther$showsRecentAdded[i];
        if (l$showsRecentAdded$entry != lOther$showsRecentAdded$entry) {
          return false;
        }
      }
    } else if (l$showsRecentAdded != lOther$showsRecentAdded) {
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
    List<Query$showsRecentAdded$showsRecentAdded>? showsRecentAdded,
    String? $__typename,
  });
  TRes showsRecentAdded(
    Iterable<Query$showsRecentAdded$showsRecentAdded>? Function(
      Iterable<
        CopyWith$Query$showsRecentAdded$showsRecentAdded<
          Query$showsRecentAdded$showsRecentAdded
        >
      >?,
    )
    _fn,
  );
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
          : (showsRecentAdded
                as List<Query$showsRecentAdded$showsRecentAdded>?),
      $__typename: $__typename == _undefined || $__typename == null
          ? _instance.$__typename
          : ($__typename as String),
    ),
  );

  TRes showsRecentAdded(
    Iterable<Query$showsRecentAdded$showsRecentAdded>? Function(
      Iterable<
        CopyWith$Query$showsRecentAdded$showsRecentAdded<
          Query$showsRecentAdded$showsRecentAdded
        >
      >?,
    )
    _fn,
  ) => call(
    showsRecentAdded: _fn(
      _instance.showsRecentAdded?.map(
        (e) => CopyWith$Query$showsRecentAdded$showsRecentAdded(e, (i) => i),
      ),
    )?.toList(),
  );
}

class _CopyWithStubImpl$Query$showsRecentAdded<TRes>
    implements CopyWith$Query$showsRecentAdded<TRes> {
  _CopyWithStubImpl$Query$showsRecentAdded(this._res);

  TRes _res;

  call({
    List<Query$showsRecentAdded$showsRecentAdded>? showsRecentAdded,
    String? $__typename,
  }) => _res;

  showsRecentAdded(_fn) => _res;
}

const documentNodeQueryshowsRecentAdded = DocumentNode(
  definitions: [
    OperationDefinitionNode(
      type: OperationType.query,
      name: NameNode(value: 'showsRecentAdded'),
      variableDefinitions: [],
      directives: [],
      selectionSet: SelectionSetNode(
        selections: [
          FieldNode(
            name: NameNode(value: 'showsRecentAdded'),
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
    fragmentDefinitionfragmentImages,
    fragmentDefinitionfragmentMetadata,
  ],
);

class Query$showsRecentAdded$showsRecentAdded {
  Query$showsRecentAdded$showsRecentAdded({
    required this.id,
    required this.releaseYear,
    required this.name,
    this.images,
    this.episodes,
    this.metadata,
    this.$__typename = 'Show',
  });

  factory Query$showsRecentAdded$showsRecentAdded.fromJson(
    Map<String, dynamic> json,
  ) {
    final l$id = json['id'];
    final l$releaseYear = json['releaseYear'];
    final l$name = json['name'];
    final l$images = json['images'];
    final l$episodes = json['episodes'];
    final l$metadata = json['metadata'];
    final l$$__typename = json['__typename'];
    return Query$showsRecentAdded$showsRecentAdded(
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
            (e) => Query$showsRecentAdded$showsRecentAdded$episodes.fromJson(
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

  final List<Query$showsRecentAdded$showsRecentAdded$episodes>? episodes;

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
    if (other is! Query$showsRecentAdded$showsRecentAdded ||
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
    String? id,
    int? releaseYear,
    String? name,
    List<Fragment$fragmentImages>? images,
    List<Query$showsRecentAdded$showsRecentAdded$episodes>? episodes,
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
    Iterable<Query$showsRecentAdded$showsRecentAdded$episodes>? Function(
      Iterable<
        CopyWith$Query$showsRecentAdded$showsRecentAdded$episodes<
          Query$showsRecentAdded$showsRecentAdded$episodes
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
    Object? id = _undefined,
    Object? releaseYear = _undefined,
    Object? name = _undefined,
    Object? images = _undefined,
    Object? episodes = _undefined,
    Object? metadata = _undefined,
    Object? $__typename = _undefined,
  }) => _then(
    Query$showsRecentAdded$showsRecentAdded(
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
                as List<Query$showsRecentAdded$showsRecentAdded$episodes>?),
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
    Iterable<Query$showsRecentAdded$showsRecentAdded$episodes>? Function(
      Iterable<
        CopyWith$Query$showsRecentAdded$showsRecentAdded$episodes<
          Query$showsRecentAdded$showsRecentAdded$episodes
        >
      >?,
    )
    _fn,
  ) => call(
    episodes: _fn(
      _instance.episodes?.map(
        (e) => CopyWith$Query$showsRecentAdded$showsRecentAdded$episodes(
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

class _CopyWithStubImpl$Query$showsRecentAdded$showsRecentAdded<TRes>
    implements CopyWith$Query$showsRecentAdded$showsRecentAdded<TRes> {
  _CopyWithStubImpl$Query$showsRecentAdded$showsRecentAdded(this._res);

  TRes _res;

  call({
    String? id,
    int? releaseYear,
    String? name,
    List<Fragment$fragmentImages>? images,
    List<Query$showsRecentAdded$showsRecentAdded$episodes>? episodes,
    List<Fragment$fragmentMetadata>? metadata,
    String? $__typename,
  }) => _res;

  images(_fn) => _res;

  episodes(_fn) => _res;

  metadata(_fn) => _res;
}

class Query$showsRecentAdded$showsRecentAdded$episodes {
  Query$showsRecentAdded$showsRecentAdded$episodes({
    this.number,
    this.$__typename = 'Episode',
  });

  factory Query$showsRecentAdded$showsRecentAdded$episodes.fromJson(
    Map<String, dynamic> json,
  ) {
    final l$number = json['number'];
    final l$$__typename = json['__typename'];
    return Query$showsRecentAdded$showsRecentAdded$episodes(
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
    if (other is! Query$showsRecentAdded$showsRecentAdded$episodes ||
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

extension UtilityExtension$Query$showsRecentAdded$showsRecentAdded$episodes
    on Query$showsRecentAdded$showsRecentAdded$episodes {
  CopyWith$Query$showsRecentAdded$showsRecentAdded$episodes<
    Query$showsRecentAdded$showsRecentAdded$episodes
  >
  get copyWith =>
      CopyWith$Query$showsRecentAdded$showsRecentAdded$episodes(this, (i) => i);
}

abstract class CopyWith$Query$showsRecentAdded$showsRecentAdded$episodes<TRes> {
  factory CopyWith$Query$showsRecentAdded$showsRecentAdded$episodes(
    Query$showsRecentAdded$showsRecentAdded$episodes instance,
    TRes Function(Query$showsRecentAdded$showsRecentAdded$episodes) then,
  ) = _CopyWithImpl$Query$showsRecentAdded$showsRecentAdded$episodes;

  factory CopyWith$Query$showsRecentAdded$showsRecentAdded$episodes.stub(
    TRes res,
  ) = _CopyWithStubImpl$Query$showsRecentAdded$showsRecentAdded$episodes;

  TRes call({int? number, String? $__typename});
}

class _CopyWithImpl$Query$showsRecentAdded$showsRecentAdded$episodes<TRes>
    implements CopyWith$Query$showsRecentAdded$showsRecentAdded$episodes<TRes> {
  _CopyWithImpl$Query$showsRecentAdded$showsRecentAdded$episodes(
    this._instance,
    this._then,
  );

  final Query$showsRecentAdded$showsRecentAdded$episodes _instance;

  final TRes Function(Query$showsRecentAdded$showsRecentAdded$episodes) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({Object? number = _undefined, Object? $__typename = _undefined}) =>
      _then(
        Query$showsRecentAdded$showsRecentAdded$episodes(
          number: number == _undefined ? _instance.number : (number as int?),
          $__typename: $__typename == _undefined || $__typename == null
              ? _instance.$__typename
              : ($__typename as String),
        ),
      );
}

class _CopyWithStubImpl$Query$showsRecentAdded$showsRecentAdded$episodes<TRes>
    implements CopyWith$Query$showsRecentAdded$showsRecentAdded$episodes<TRes> {
  _CopyWithStubImpl$Query$showsRecentAdded$showsRecentAdded$episodes(this._res);

  TRes _res;

  call({int? number, String? $__typename}) => _res;
}

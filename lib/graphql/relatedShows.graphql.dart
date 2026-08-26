import 'fragmentImages.graphql.dart';
import 'fragmentMetadata.graphql.dart';

import 'package:gql/ast.dart';

class Variables$Query$relatedShows {
  factory Variables$Query$relatedShows({required String id, int? limit}) =>
      Variables$Query$relatedShows._({
        r'id': id,
        if (limit != null) r'limit': limit,
      });

  Variables$Query$relatedShows._(this._$data);

  factory Variables$Query$relatedShows.fromJson(Map<String, dynamic> data) {
    final result$data = <String, dynamic>{};
    final l$id = data['id'];
    result$data['id'] = (l$id as String);
    if (data.containsKey('limit')) {
      final l$limit = data['limit'];
      result$data['limit'] = (l$limit as int?);
    }
    return Variables$Query$relatedShows._(result$data);
  }

  Map<String, dynamic> _$data;

  String get id => (_$data['id'] as String);

  int? get limit => (_$data['limit'] as int?);

  Map<String, dynamic> toJson() {
    final result$data = <String, dynamic>{};
    final l$id = id;
    result$data['id'] = l$id;
    if (_$data.containsKey('limit')) {
      final l$limit = limit;
      result$data['limit'] = l$limit;
    }
    return result$data;
  }

  CopyWith$Variables$Query$relatedShows<Variables$Query$relatedShows>
  get copyWith => CopyWith$Variables$Query$relatedShows(this, (i) => i);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Variables$Query$relatedShows ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$id = id;
    final lOther$id = other.id;
    if (l$id != lOther$id) {
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
    final l$id = id;
    final l$limit = limit;
    return Object.hashAll([
      l$id,
      _$data.containsKey('limit') ? l$limit : const {},
    ]);
  }
}

abstract class CopyWith$Variables$Query$relatedShows<TRes> {
  factory CopyWith$Variables$Query$relatedShows(
    Variables$Query$relatedShows instance,
    TRes Function(Variables$Query$relatedShows) then,
  ) = _CopyWithImpl$Variables$Query$relatedShows;

  factory CopyWith$Variables$Query$relatedShows.stub(TRes res) =
      _CopyWithStubImpl$Variables$Query$relatedShows;

  TRes call({String? id, int? limit});
}

class _CopyWithImpl$Variables$Query$relatedShows<TRes>
    implements CopyWith$Variables$Query$relatedShows<TRes> {
  _CopyWithImpl$Variables$Query$relatedShows(this._instance, this._then);

  final Variables$Query$relatedShows _instance;

  final TRes Function(Variables$Query$relatedShows) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({Object? id = _undefined, Object? limit = _undefined}) => _then(
    Variables$Query$relatedShows._({
      ..._instance._$data,
      if (id != _undefined && id != null) 'id': (id as String),
      if (limit != _undefined) 'limit': (limit as int?),
    }),
  );
}

class _CopyWithStubImpl$Variables$Query$relatedShows<TRes>
    implements CopyWith$Variables$Query$relatedShows<TRes> {
  _CopyWithStubImpl$Variables$Query$relatedShows(this._res);

  TRes _res;

  call({String? id, int? limit}) => _res;
}

class Query$relatedShows {
  Query$relatedShows({this.showById, this.$__typename = 'Query'});

  factory Query$relatedShows.fromJson(Map<String, dynamic> json) {
    final l$showById = json['showById'];
    final l$$__typename = json['__typename'];
    return Query$relatedShows(
      showById: l$showById == null
          ? null
          : Query$relatedShows$showById.fromJson(
              (l$showById as Map<String, dynamic>),
            ),
      $__typename: (l$$__typename as String),
    );
  }

  final Query$relatedShows$showById? showById;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$showById = showById;
    _resultData['showById'] = l$showById?.toJson();
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$showById = showById;
    final l$$__typename = $__typename;
    return Object.hashAll([l$showById, l$$__typename]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Query$relatedShows || runtimeType != other.runtimeType) {
      return false;
    }
    final l$showById = showById;
    final lOther$showById = other.showById;
    if (l$showById != lOther$showById) {
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

extension UtilityExtension$Query$relatedShows on Query$relatedShows {
  CopyWith$Query$relatedShows<Query$relatedShows> get copyWith =>
      CopyWith$Query$relatedShows(this, (i) => i);
}

abstract class CopyWith$Query$relatedShows<TRes> {
  factory CopyWith$Query$relatedShows(
    Query$relatedShows instance,
    TRes Function(Query$relatedShows) then,
  ) = _CopyWithImpl$Query$relatedShows;

  factory CopyWith$Query$relatedShows.stub(TRes res) =
      _CopyWithStubImpl$Query$relatedShows;

  TRes call({Query$relatedShows$showById? showById, String? $__typename});
  CopyWith$Query$relatedShows$showById<TRes> get showById;
}

class _CopyWithImpl$Query$relatedShows<TRes>
    implements CopyWith$Query$relatedShows<TRes> {
  _CopyWithImpl$Query$relatedShows(this._instance, this._then);

  final Query$relatedShows _instance;

  final TRes Function(Query$relatedShows) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? showById = _undefined,
    Object? $__typename = _undefined,
  }) => _then(
    Query$relatedShows(
      showById: showById == _undefined
          ? _instance.showById
          : (showById as Query$relatedShows$showById?),
      $__typename: $__typename == _undefined || $__typename == null
          ? _instance.$__typename
          : ($__typename as String),
    ),
  );

  CopyWith$Query$relatedShows$showById<TRes> get showById {
    final local$showById = _instance.showById;
    return local$showById == null
        ? CopyWith$Query$relatedShows$showById.stub(_then(_instance))
        : CopyWith$Query$relatedShows$showById(
            local$showById,
            (e) => call(showById: e),
          );
  }
}

class _CopyWithStubImpl$Query$relatedShows<TRes>
    implements CopyWith$Query$relatedShows<TRes> {
  _CopyWithStubImpl$Query$relatedShows(this._res);

  TRes _res;

  call({Query$relatedShows$showById? showById, String? $__typename}) => _res;

  CopyWith$Query$relatedShows$showById<TRes> get showById =>
      CopyWith$Query$relatedShows$showById.stub(_res);
}

const documentNodeQueryrelatedShows = DocumentNode(
  definitions: [
    OperationDefinitionNode(
      type: OperationType.query,
      name: NameNode(value: 'relatedShows'),
      variableDefinitions: [
        VariableDefinitionNode(
          variable: VariableNode(name: NameNode(value: 'id')),
          type: NamedTypeNode(name: NameNode(value: 'ID'), isNonNull: true),
          defaultValue: DefaultValueNode(value: null),
          directives: [],
        ),
        VariableDefinitionNode(
          variable: VariableNode(name: NameNode(value: 'limit')),
          type: NamedTypeNode(name: NameNode(value: 'Int'), isNonNull: false),
          defaultValue: DefaultValueNode(value: null),
          directives: [],
        ),
      ],
      directives: [],
      selectionSet: SelectionSetNode(
        selections: [
          FieldNode(
            name: NameNode(value: 'showById'),
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
                FieldNode(
                  name: NameNode(value: 'id'),
                  alias: null,
                  arguments: [],
                  directives: [],
                  selectionSet: null,
                ),
                FieldNode(
                  name: NameNode(value: 'related'),
                  alias: null,
                  arguments: [
                    ArgumentNode(
                      name: NameNode(value: 'limit'),
                      value: VariableNode(name: NameNode(value: 'limit')),
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
                        name: NameNode(value: 'name'),
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

class Query$relatedShows$showById {
  Query$relatedShows$showById({
    required this.id,
    required this.related,
    this.$__typename = 'Show',
  });

  factory Query$relatedShows$showById.fromJson(Map<String, dynamic> json) {
    final l$id = json['id'];
    final l$related = json['related'];
    final l$$__typename = json['__typename'];
    return Query$relatedShows$showById(
      id: (l$id as String),
      related: (l$related as List<dynamic>)
          .map(
            (e) => Query$relatedShows$showById$related.fromJson(
              (e as Map<String, dynamic>),
            ),
          )
          .toList(),
      $__typename: (l$$__typename as String),
    );
  }

  final String id;

  final List<Query$relatedShows$showById$related> related;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$id = id;
    _resultData['id'] = l$id;
    final l$related = related;
    _resultData['related'] = l$related.map((e) => e.toJson()).toList();
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$id = id;
    final l$related = related;
    final l$$__typename = $__typename;
    return Object.hashAll([
      l$id,
      Object.hashAll(l$related.map((v) => v)),
      l$$__typename,
    ]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Query$relatedShows$showById ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$id = id;
    final lOther$id = other.id;
    if (l$id != lOther$id) {
      return false;
    }
    final l$related = related;
    final lOther$related = other.related;
    if (l$related.length != lOther$related.length) {
      return false;
    }
    for (int i = 0; i < l$related.length; i++) {
      final l$related$entry = l$related[i];
      final lOther$related$entry = lOther$related[i];
      if (l$related$entry != lOther$related$entry) {
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

extension UtilityExtension$Query$relatedShows$showById
    on Query$relatedShows$showById {
  CopyWith$Query$relatedShows$showById<Query$relatedShows$showById>
  get copyWith => CopyWith$Query$relatedShows$showById(this, (i) => i);
}

abstract class CopyWith$Query$relatedShows$showById<TRes> {
  factory CopyWith$Query$relatedShows$showById(
    Query$relatedShows$showById instance,
    TRes Function(Query$relatedShows$showById) then,
  ) = _CopyWithImpl$Query$relatedShows$showById;

  factory CopyWith$Query$relatedShows$showById.stub(TRes res) =
      _CopyWithStubImpl$Query$relatedShows$showById;

  TRes call({
    String? id,
    List<Query$relatedShows$showById$related>? related,
    String? $__typename,
  });
  TRes related(
    Iterable<Query$relatedShows$showById$related> Function(
      Iterable<
        CopyWith$Query$relatedShows$showById$related<
          Query$relatedShows$showById$related
        >
      >,
    )
    _fn,
  );
}

class _CopyWithImpl$Query$relatedShows$showById<TRes>
    implements CopyWith$Query$relatedShows$showById<TRes> {
  _CopyWithImpl$Query$relatedShows$showById(this._instance, this._then);

  final Query$relatedShows$showById _instance;

  final TRes Function(Query$relatedShows$showById) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? id = _undefined,
    Object? related = _undefined,
    Object? $__typename = _undefined,
  }) => _then(
    Query$relatedShows$showById(
      id: id == _undefined || id == null ? _instance.id : (id as String),
      related: related == _undefined || related == null
          ? _instance.related
          : (related as List<Query$relatedShows$showById$related>),
      $__typename: $__typename == _undefined || $__typename == null
          ? _instance.$__typename
          : ($__typename as String),
    ),
  );

  TRes related(
    Iterable<Query$relatedShows$showById$related> Function(
      Iterable<
        CopyWith$Query$relatedShows$showById$related<
          Query$relatedShows$showById$related
        >
      >,
    )
    _fn,
  ) => call(
    related: _fn(
      _instance.related.map(
        (e) => CopyWith$Query$relatedShows$showById$related(e, (i) => i),
      ),
    ).toList(),
  );
}

class _CopyWithStubImpl$Query$relatedShows$showById<TRes>
    implements CopyWith$Query$relatedShows$showById<TRes> {
  _CopyWithStubImpl$Query$relatedShows$showById(this._res);

  TRes _res;

  call({
    String? id,
    List<Query$relatedShows$showById$related>? related,
    String? $__typename,
  }) => _res;

  related(_fn) => _res;
}

class Query$relatedShows$showById$related {
  Query$relatedShows$showById$related({
    required this.id,
    required this.name,
    required this.releaseYear,
    this.images,
    this.metadata,
    this.$__typename = 'Show',
  });

  factory Query$relatedShows$showById$related.fromJson(
    Map<String, dynamic> json,
  ) {
    final l$id = json['id'];
    final l$name = json['name'];
    final l$releaseYear = json['releaseYear'];
    final l$images = json['images'];
    final l$metadata = json['metadata'];
    final l$$__typename = json['__typename'];
    return Query$relatedShows$showById$related(
      id: (l$id as String),
      name: (l$name as String),
      releaseYear: (l$releaseYear as int),
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
      $__typename: (l$$__typename as String),
    );
  }

  final String id;

  final String name;

  final int releaseYear;

  final List<Fragment$fragmentImages>? images;

  final List<Fragment$fragmentMetadata>? metadata;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$id = id;
    _resultData['id'] = l$id;
    final l$name = name;
    _resultData['name'] = l$name;
    final l$releaseYear = releaseYear;
    _resultData['releaseYear'] = l$releaseYear;
    final l$images = images;
    _resultData['images'] = l$images?.map((e) => e.toJson()).toList();
    final l$metadata = metadata;
    _resultData['metadata'] = l$metadata?.map((e) => e.toJson()).toList();
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$id = id;
    final l$name = name;
    final l$releaseYear = releaseYear;
    final l$images = images;
    final l$metadata = metadata;
    final l$$__typename = $__typename;
    return Object.hashAll([
      l$id,
      l$name,
      l$releaseYear,
      l$images == null ? null : Object.hashAll(l$images.map((v) => v)),
      l$metadata == null ? null : Object.hashAll(l$metadata.map((v) => v)),
      l$$__typename,
    ]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Query$relatedShows$showById$related ||
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
    final l$releaseYear = releaseYear;
    final lOther$releaseYear = other.releaseYear;
    if (l$releaseYear != lOther$releaseYear) {
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
    final l$$__typename = $__typename;
    final lOther$$__typename = other.$__typename;
    if (l$$__typename != lOther$$__typename) {
      return false;
    }
    return true;
  }
}

extension UtilityExtension$Query$relatedShows$showById$related
    on Query$relatedShows$showById$related {
  CopyWith$Query$relatedShows$showById$related<
    Query$relatedShows$showById$related
  >
  get copyWith => CopyWith$Query$relatedShows$showById$related(this, (i) => i);
}

abstract class CopyWith$Query$relatedShows$showById$related<TRes> {
  factory CopyWith$Query$relatedShows$showById$related(
    Query$relatedShows$showById$related instance,
    TRes Function(Query$relatedShows$showById$related) then,
  ) = _CopyWithImpl$Query$relatedShows$showById$related;

  factory CopyWith$Query$relatedShows$showById$related.stub(TRes res) =
      _CopyWithStubImpl$Query$relatedShows$showById$related;

  TRes call({
    String? id,
    String? name,
    int? releaseYear,
    List<Fragment$fragmentImages>? images,
    List<Fragment$fragmentMetadata>? metadata,
    String? $__typename,
  });
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

class _CopyWithImpl$Query$relatedShows$showById$related<TRes>
    implements CopyWith$Query$relatedShows$showById$related<TRes> {
  _CopyWithImpl$Query$relatedShows$showById$related(this._instance, this._then);

  final Query$relatedShows$showById$related _instance;

  final TRes Function(Query$relatedShows$showById$related) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? id = _undefined,
    Object? name = _undefined,
    Object? releaseYear = _undefined,
    Object? images = _undefined,
    Object? metadata = _undefined,
    Object? $__typename = _undefined,
  }) => _then(
    Query$relatedShows$showById$related(
      id: id == _undefined || id == null ? _instance.id : (id as String),
      name: name == _undefined || name == null
          ? _instance.name
          : (name as String),
      releaseYear: releaseYear == _undefined || releaseYear == null
          ? _instance.releaseYear
          : (releaseYear as int),
      images: images == _undefined
          ? _instance.images
          : (images as List<Fragment$fragmentImages>?),
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

class _CopyWithStubImpl$Query$relatedShows$showById$related<TRes>
    implements CopyWith$Query$relatedShows$showById$related<TRes> {
  _CopyWithStubImpl$Query$relatedShows$showById$related(this._res);

  TRes _res;

  call({
    String? id,
    String? name,
    int? releaseYear,
    List<Fragment$fragmentImages>? images,
    List<Fragment$fragmentMetadata>? metadata,
    String? $__typename,
  }) => _res;

  images(_fn) => _res;

  metadata(_fn) => _res;
}

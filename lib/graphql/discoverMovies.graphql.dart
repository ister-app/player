import 'fragmentImages.graphql.dart';
import 'fragmentMetadata.graphql.dart';

import 'package:gql/ast.dart';

class Variables$Query$discoverMovies {
  factory Variables$Query$discoverMovies({
    required String libraryId,
    int? limit,
  }) => Variables$Query$discoverMovies._({
    r'libraryId': libraryId,
    if (limit != null) r'limit': limit,
  });

  Variables$Query$discoverMovies._(this._$data);

  factory Variables$Query$discoverMovies.fromJson(Map<String, dynamic> data) {
    final result$data = <String, dynamic>{};
    final l$libraryId = data['libraryId'];
    result$data['libraryId'] = (l$libraryId as String);
    if (data.containsKey('limit')) {
      final l$limit = data['limit'];
      result$data['limit'] = (l$limit as int?);
    }
    return Variables$Query$discoverMovies._(result$data);
  }

  Map<String, dynamic> _$data;

  String get libraryId => (_$data['libraryId'] as String);

  int? get limit => (_$data['limit'] as int?);

  Map<String, dynamic> toJson() {
    final result$data = <String, dynamic>{};
    final l$libraryId = libraryId;
    result$data['libraryId'] = l$libraryId;
    if (_$data.containsKey('limit')) {
      final l$limit = limit;
      result$data['limit'] = l$limit;
    }
    return result$data;
  }

  CopyWith$Variables$Query$discoverMovies<Variables$Query$discoverMovies>
  get copyWith => CopyWith$Variables$Query$discoverMovies(this, (i) => i);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Variables$Query$discoverMovies ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$libraryId = libraryId;
    final lOther$libraryId = other.libraryId;
    if (l$libraryId != lOther$libraryId) {
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
    final l$libraryId = libraryId;
    final l$limit = limit;
    return Object.hashAll([
      l$libraryId,
      _$data.containsKey('limit') ? l$limit : const {},
    ]);
  }
}

abstract class CopyWith$Variables$Query$discoverMovies<TRes> {
  factory CopyWith$Variables$Query$discoverMovies(
    Variables$Query$discoverMovies instance,
    TRes Function(Variables$Query$discoverMovies) then,
  ) = _CopyWithImpl$Variables$Query$discoverMovies;

  factory CopyWith$Variables$Query$discoverMovies.stub(TRes res) =
      _CopyWithStubImpl$Variables$Query$discoverMovies;

  TRes call({String? libraryId, int? limit});
}

class _CopyWithImpl$Variables$Query$discoverMovies<TRes>
    implements CopyWith$Variables$Query$discoverMovies<TRes> {
  _CopyWithImpl$Variables$Query$discoverMovies(this._instance, this._then);

  final Variables$Query$discoverMovies _instance;

  final TRes Function(Variables$Query$discoverMovies) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({Object? libraryId = _undefined, Object? limit = _undefined}) =>
      _then(
        Variables$Query$discoverMovies._({
          ..._instance._$data,
          if (libraryId != _undefined && libraryId != null)
            'libraryId': (libraryId as String),
          if (limit != _undefined) 'limit': (limit as int?),
        }),
      );
}

class _CopyWithStubImpl$Variables$Query$discoverMovies<TRes>
    implements CopyWith$Variables$Query$discoverMovies<TRes> {
  _CopyWithStubImpl$Variables$Query$discoverMovies(this._res);

  TRes _res;

  call({String? libraryId, int? limit}) => _res;
}

class Query$discoverMovies {
  Query$discoverMovies({this.libraryById, this.$__typename = 'Query'});

  factory Query$discoverMovies.fromJson(Map<String, dynamic> json) {
    final l$libraryById = json['libraryById'];
    final l$$__typename = json['__typename'];
    return Query$discoverMovies(
      libraryById: l$libraryById == null
          ? null
          : Query$discoverMovies$libraryById.fromJson(
              (l$libraryById as Map<String, dynamic>),
            ),
      $__typename: (l$$__typename as String),
    );
  }

  final Query$discoverMovies$libraryById? libraryById;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$libraryById = libraryById;
    _resultData['libraryById'] = l$libraryById?.toJson();
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$libraryById = libraryById;
    final l$$__typename = $__typename;
    return Object.hashAll([l$libraryById, l$$__typename]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Query$discoverMovies || runtimeType != other.runtimeType) {
      return false;
    }
    final l$libraryById = libraryById;
    final lOther$libraryById = other.libraryById;
    if (l$libraryById != lOther$libraryById) {
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

extension UtilityExtension$Query$discoverMovies on Query$discoverMovies {
  CopyWith$Query$discoverMovies<Query$discoverMovies> get copyWith =>
      CopyWith$Query$discoverMovies(this, (i) => i);
}

abstract class CopyWith$Query$discoverMovies<TRes> {
  factory CopyWith$Query$discoverMovies(
    Query$discoverMovies instance,
    TRes Function(Query$discoverMovies) then,
  ) = _CopyWithImpl$Query$discoverMovies;

  factory CopyWith$Query$discoverMovies.stub(TRes res) =
      _CopyWithStubImpl$Query$discoverMovies;

  TRes call({
    Query$discoverMovies$libraryById? libraryById,
    String? $__typename,
  });
  CopyWith$Query$discoverMovies$libraryById<TRes> get libraryById;
}

class _CopyWithImpl$Query$discoverMovies<TRes>
    implements CopyWith$Query$discoverMovies<TRes> {
  _CopyWithImpl$Query$discoverMovies(this._instance, this._then);

  final Query$discoverMovies _instance;

  final TRes Function(Query$discoverMovies) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? libraryById = _undefined,
    Object? $__typename = _undefined,
  }) => _then(
    Query$discoverMovies(
      libraryById: libraryById == _undefined
          ? _instance.libraryById
          : (libraryById as Query$discoverMovies$libraryById?),
      $__typename: $__typename == _undefined || $__typename == null
          ? _instance.$__typename
          : ($__typename as String),
    ),
  );

  CopyWith$Query$discoverMovies$libraryById<TRes> get libraryById {
    final local$libraryById = _instance.libraryById;
    return local$libraryById == null
        ? CopyWith$Query$discoverMovies$libraryById.stub(_then(_instance))
        : CopyWith$Query$discoverMovies$libraryById(
            local$libraryById,
            (e) => call(libraryById: e),
          );
  }
}

class _CopyWithStubImpl$Query$discoverMovies<TRes>
    implements CopyWith$Query$discoverMovies<TRes> {
  _CopyWithStubImpl$Query$discoverMovies(this._res);

  TRes _res;

  call({Query$discoverMovies$libraryById? libraryById, String? $__typename}) =>
      _res;

  CopyWith$Query$discoverMovies$libraryById<TRes> get libraryById =>
      CopyWith$Query$discoverMovies$libraryById.stub(_res);
}

const documentNodeQuerydiscoverMovies = DocumentNode(
  definitions: [
    OperationDefinitionNode(
      type: OperationType.query,
      name: NameNode(value: 'discoverMovies'),
      variableDefinitions: [
        VariableDefinitionNode(
          variable: VariableNode(name: NameNode(value: 'libraryId')),
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
            name: NameNode(value: 'libraryById'),
            alias: null,
            arguments: [
              ArgumentNode(
                name: NameNode(value: 'id'),
                value: VariableNode(name: NameNode(value: 'libraryId')),
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
                  name: NameNode(value: 'recentlyPlayedMovies'),
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
                  name: NameNode(value: 'mostPlayedMovies'),
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
                  name: NameNode(value: 'highestRatedMovies'),
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

class Query$discoverMovies$libraryById {
  Query$discoverMovies$libraryById({
    required this.id,
    required this.recentlyPlayedMovies,
    required this.mostPlayedMovies,
    required this.highestRatedMovies,
    this.$__typename = 'Library',
  });

  factory Query$discoverMovies$libraryById.fromJson(Map<String, dynamic> json) {
    final l$id = json['id'];
    final l$recentlyPlayedMovies = json['recentlyPlayedMovies'];
    final l$mostPlayedMovies = json['mostPlayedMovies'];
    final l$highestRatedMovies = json['highestRatedMovies'];
    final l$$__typename = json['__typename'];
    return Query$discoverMovies$libraryById(
      id: (l$id as String),
      recentlyPlayedMovies: (l$recentlyPlayedMovies as List<dynamic>)
          .map(
            (e) =>
                Query$discoverMovies$libraryById$recentlyPlayedMovies.fromJson(
                  (e as Map<String, dynamic>),
                ),
          )
          .toList(),
      mostPlayedMovies: (l$mostPlayedMovies as List<dynamic>)
          .map(
            (e) => Query$discoverMovies$libraryById$mostPlayedMovies.fromJson(
              (e as Map<String, dynamic>),
            ),
          )
          .toList(),
      highestRatedMovies: (l$highestRatedMovies as List<dynamic>)
          .map(
            (e) => Query$discoverMovies$libraryById$highestRatedMovies.fromJson(
              (e as Map<String, dynamic>),
            ),
          )
          .toList(),
      $__typename: (l$$__typename as String),
    );
  }

  final String id;

  final List<Query$discoverMovies$libraryById$recentlyPlayedMovies>
  recentlyPlayedMovies;

  final List<Query$discoverMovies$libraryById$mostPlayedMovies>
  mostPlayedMovies;

  final List<Query$discoverMovies$libraryById$highestRatedMovies>
  highestRatedMovies;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$id = id;
    _resultData['id'] = l$id;
    final l$recentlyPlayedMovies = recentlyPlayedMovies;
    _resultData['recentlyPlayedMovies'] = l$recentlyPlayedMovies
        .map((e) => e.toJson())
        .toList();
    final l$mostPlayedMovies = mostPlayedMovies;
    _resultData['mostPlayedMovies'] = l$mostPlayedMovies
        .map((e) => e.toJson())
        .toList();
    final l$highestRatedMovies = highestRatedMovies;
    _resultData['highestRatedMovies'] = l$highestRatedMovies
        .map((e) => e.toJson())
        .toList();
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$id = id;
    final l$recentlyPlayedMovies = recentlyPlayedMovies;
    final l$mostPlayedMovies = mostPlayedMovies;
    final l$highestRatedMovies = highestRatedMovies;
    final l$$__typename = $__typename;
    return Object.hashAll([
      l$id,
      Object.hashAll(l$recentlyPlayedMovies.map((v) => v)),
      Object.hashAll(l$mostPlayedMovies.map((v) => v)),
      Object.hashAll(l$highestRatedMovies.map((v) => v)),
      l$$__typename,
    ]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Query$discoverMovies$libraryById ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$id = id;
    final lOther$id = other.id;
    if (l$id != lOther$id) {
      return false;
    }
    final l$recentlyPlayedMovies = recentlyPlayedMovies;
    final lOther$recentlyPlayedMovies = other.recentlyPlayedMovies;
    if (l$recentlyPlayedMovies.length != lOther$recentlyPlayedMovies.length) {
      return false;
    }
    for (int i = 0; i < l$recentlyPlayedMovies.length; i++) {
      final l$recentlyPlayedMovies$entry = l$recentlyPlayedMovies[i];
      final lOther$recentlyPlayedMovies$entry = lOther$recentlyPlayedMovies[i];
      if (l$recentlyPlayedMovies$entry != lOther$recentlyPlayedMovies$entry) {
        return false;
      }
    }
    final l$mostPlayedMovies = mostPlayedMovies;
    final lOther$mostPlayedMovies = other.mostPlayedMovies;
    if (l$mostPlayedMovies.length != lOther$mostPlayedMovies.length) {
      return false;
    }
    for (int i = 0; i < l$mostPlayedMovies.length; i++) {
      final l$mostPlayedMovies$entry = l$mostPlayedMovies[i];
      final lOther$mostPlayedMovies$entry = lOther$mostPlayedMovies[i];
      if (l$mostPlayedMovies$entry != lOther$mostPlayedMovies$entry) {
        return false;
      }
    }
    final l$highestRatedMovies = highestRatedMovies;
    final lOther$highestRatedMovies = other.highestRatedMovies;
    if (l$highestRatedMovies.length != lOther$highestRatedMovies.length) {
      return false;
    }
    for (int i = 0; i < l$highestRatedMovies.length; i++) {
      final l$highestRatedMovies$entry = l$highestRatedMovies[i];
      final lOther$highestRatedMovies$entry = lOther$highestRatedMovies[i];
      if (l$highestRatedMovies$entry != lOther$highestRatedMovies$entry) {
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

extension UtilityExtension$Query$discoverMovies$libraryById
    on Query$discoverMovies$libraryById {
  CopyWith$Query$discoverMovies$libraryById<Query$discoverMovies$libraryById>
  get copyWith => CopyWith$Query$discoverMovies$libraryById(this, (i) => i);
}

abstract class CopyWith$Query$discoverMovies$libraryById<TRes> {
  factory CopyWith$Query$discoverMovies$libraryById(
    Query$discoverMovies$libraryById instance,
    TRes Function(Query$discoverMovies$libraryById) then,
  ) = _CopyWithImpl$Query$discoverMovies$libraryById;

  factory CopyWith$Query$discoverMovies$libraryById.stub(TRes res) =
      _CopyWithStubImpl$Query$discoverMovies$libraryById;

  TRes call({
    String? id,
    List<Query$discoverMovies$libraryById$recentlyPlayedMovies>?
    recentlyPlayedMovies,
    List<Query$discoverMovies$libraryById$mostPlayedMovies>? mostPlayedMovies,
    List<Query$discoverMovies$libraryById$highestRatedMovies>?
    highestRatedMovies,
    String? $__typename,
  });
  TRes recentlyPlayedMovies(
    Iterable<Query$discoverMovies$libraryById$recentlyPlayedMovies> Function(
      Iterable<
        CopyWith$Query$discoverMovies$libraryById$recentlyPlayedMovies<
          Query$discoverMovies$libraryById$recentlyPlayedMovies
        >
      >,
    )
    _fn,
  );
  TRes mostPlayedMovies(
    Iterable<Query$discoverMovies$libraryById$mostPlayedMovies> Function(
      Iterable<
        CopyWith$Query$discoverMovies$libraryById$mostPlayedMovies<
          Query$discoverMovies$libraryById$mostPlayedMovies
        >
      >,
    )
    _fn,
  );
  TRes highestRatedMovies(
    Iterable<Query$discoverMovies$libraryById$highestRatedMovies> Function(
      Iterable<
        CopyWith$Query$discoverMovies$libraryById$highestRatedMovies<
          Query$discoverMovies$libraryById$highestRatedMovies
        >
      >,
    )
    _fn,
  );
}

class _CopyWithImpl$Query$discoverMovies$libraryById<TRes>
    implements CopyWith$Query$discoverMovies$libraryById<TRes> {
  _CopyWithImpl$Query$discoverMovies$libraryById(this._instance, this._then);

  final Query$discoverMovies$libraryById _instance;

  final TRes Function(Query$discoverMovies$libraryById) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? id = _undefined,
    Object? recentlyPlayedMovies = _undefined,
    Object? mostPlayedMovies = _undefined,
    Object? highestRatedMovies = _undefined,
    Object? $__typename = _undefined,
  }) => _then(
    Query$discoverMovies$libraryById(
      id: id == _undefined || id == null ? _instance.id : (id as String),
      recentlyPlayedMovies:
          recentlyPlayedMovies == _undefined || recentlyPlayedMovies == null
          ? _instance.recentlyPlayedMovies
          : (recentlyPlayedMovies
                as List<Query$discoverMovies$libraryById$recentlyPlayedMovies>),
      mostPlayedMovies:
          mostPlayedMovies == _undefined || mostPlayedMovies == null
          ? _instance.mostPlayedMovies
          : (mostPlayedMovies
                as List<Query$discoverMovies$libraryById$mostPlayedMovies>),
      highestRatedMovies:
          highestRatedMovies == _undefined || highestRatedMovies == null
          ? _instance.highestRatedMovies
          : (highestRatedMovies
                as List<Query$discoverMovies$libraryById$highestRatedMovies>),
      $__typename: $__typename == _undefined || $__typename == null
          ? _instance.$__typename
          : ($__typename as String),
    ),
  );

  TRes recentlyPlayedMovies(
    Iterable<Query$discoverMovies$libraryById$recentlyPlayedMovies> Function(
      Iterable<
        CopyWith$Query$discoverMovies$libraryById$recentlyPlayedMovies<
          Query$discoverMovies$libraryById$recentlyPlayedMovies
        >
      >,
    )
    _fn,
  ) => call(
    recentlyPlayedMovies: _fn(
      _instance.recentlyPlayedMovies.map(
        (e) => CopyWith$Query$discoverMovies$libraryById$recentlyPlayedMovies(
          e,
          (i) => i,
        ),
      ),
    ).toList(),
  );

  TRes mostPlayedMovies(
    Iterable<Query$discoverMovies$libraryById$mostPlayedMovies> Function(
      Iterable<
        CopyWith$Query$discoverMovies$libraryById$mostPlayedMovies<
          Query$discoverMovies$libraryById$mostPlayedMovies
        >
      >,
    )
    _fn,
  ) => call(
    mostPlayedMovies: _fn(
      _instance.mostPlayedMovies.map(
        (e) => CopyWith$Query$discoverMovies$libraryById$mostPlayedMovies(
          e,
          (i) => i,
        ),
      ),
    ).toList(),
  );

  TRes highestRatedMovies(
    Iterable<Query$discoverMovies$libraryById$highestRatedMovies> Function(
      Iterable<
        CopyWith$Query$discoverMovies$libraryById$highestRatedMovies<
          Query$discoverMovies$libraryById$highestRatedMovies
        >
      >,
    )
    _fn,
  ) => call(
    highestRatedMovies: _fn(
      _instance.highestRatedMovies.map(
        (e) => CopyWith$Query$discoverMovies$libraryById$highestRatedMovies(
          e,
          (i) => i,
        ),
      ),
    ).toList(),
  );
}

class _CopyWithStubImpl$Query$discoverMovies$libraryById<TRes>
    implements CopyWith$Query$discoverMovies$libraryById<TRes> {
  _CopyWithStubImpl$Query$discoverMovies$libraryById(this._res);

  TRes _res;

  call({
    String? id,
    List<Query$discoverMovies$libraryById$recentlyPlayedMovies>?
    recentlyPlayedMovies,
    List<Query$discoverMovies$libraryById$mostPlayedMovies>? mostPlayedMovies,
    List<Query$discoverMovies$libraryById$highestRatedMovies>?
    highestRatedMovies,
    String? $__typename,
  }) => _res;

  recentlyPlayedMovies(_fn) => _res;

  mostPlayedMovies(_fn) => _res;

  highestRatedMovies(_fn) => _res;
}

class Query$discoverMovies$libraryById$recentlyPlayedMovies {
  Query$discoverMovies$libraryById$recentlyPlayedMovies({
    required this.id,
    required this.name,
    required this.releaseYear,
    this.images,
    this.metadata,
    this.$__typename = 'Movie',
  });

  factory Query$discoverMovies$libraryById$recentlyPlayedMovies.fromJson(
    Map<String, dynamic> json,
  ) {
    final l$id = json['id'];
    final l$name = json['name'];
    final l$releaseYear = json['releaseYear'];
    final l$images = json['images'];
    final l$metadata = json['metadata'];
    final l$$__typename = json['__typename'];
    return Query$discoverMovies$libraryById$recentlyPlayedMovies(
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
    if (other is! Query$discoverMovies$libraryById$recentlyPlayedMovies ||
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

extension UtilityExtension$Query$discoverMovies$libraryById$recentlyPlayedMovies
    on Query$discoverMovies$libraryById$recentlyPlayedMovies {
  CopyWith$Query$discoverMovies$libraryById$recentlyPlayedMovies<
    Query$discoverMovies$libraryById$recentlyPlayedMovies
  >
  get copyWith =>
      CopyWith$Query$discoverMovies$libraryById$recentlyPlayedMovies(
        this,
        (i) => i,
      );
}

abstract class CopyWith$Query$discoverMovies$libraryById$recentlyPlayedMovies<
  TRes
> {
  factory CopyWith$Query$discoverMovies$libraryById$recentlyPlayedMovies(
    Query$discoverMovies$libraryById$recentlyPlayedMovies instance,
    TRes Function(Query$discoverMovies$libraryById$recentlyPlayedMovies) then,
  ) = _CopyWithImpl$Query$discoverMovies$libraryById$recentlyPlayedMovies;

  factory CopyWith$Query$discoverMovies$libraryById$recentlyPlayedMovies.stub(
    TRes res,
  ) = _CopyWithStubImpl$Query$discoverMovies$libraryById$recentlyPlayedMovies;

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

class _CopyWithImpl$Query$discoverMovies$libraryById$recentlyPlayedMovies<TRes>
    implements
        CopyWith$Query$discoverMovies$libraryById$recentlyPlayedMovies<TRes> {
  _CopyWithImpl$Query$discoverMovies$libraryById$recentlyPlayedMovies(
    this._instance,
    this._then,
  );

  final Query$discoverMovies$libraryById$recentlyPlayedMovies _instance;

  final TRes Function(Query$discoverMovies$libraryById$recentlyPlayedMovies)
  _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? id = _undefined,
    Object? name = _undefined,
    Object? releaseYear = _undefined,
    Object? images = _undefined,
    Object? metadata = _undefined,
    Object? $__typename = _undefined,
  }) => _then(
    Query$discoverMovies$libraryById$recentlyPlayedMovies(
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

class _CopyWithStubImpl$Query$discoverMovies$libraryById$recentlyPlayedMovies<
  TRes
>
    implements
        CopyWith$Query$discoverMovies$libraryById$recentlyPlayedMovies<TRes> {
  _CopyWithStubImpl$Query$discoverMovies$libraryById$recentlyPlayedMovies(
    this._res,
  );

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

class Query$discoverMovies$libraryById$mostPlayedMovies {
  Query$discoverMovies$libraryById$mostPlayedMovies({
    required this.id,
    required this.name,
    required this.releaseYear,
    this.images,
    this.metadata,
    this.$__typename = 'Movie',
  });

  factory Query$discoverMovies$libraryById$mostPlayedMovies.fromJson(
    Map<String, dynamic> json,
  ) {
    final l$id = json['id'];
    final l$name = json['name'];
    final l$releaseYear = json['releaseYear'];
    final l$images = json['images'];
    final l$metadata = json['metadata'];
    final l$$__typename = json['__typename'];
    return Query$discoverMovies$libraryById$mostPlayedMovies(
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
    if (other is! Query$discoverMovies$libraryById$mostPlayedMovies ||
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

extension UtilityExtension$Query$discoverMovies$libraryById$mostPlayedMovies
    on Query$discoverMovies$libraryById$mostPlayedMovies {
  CopyWith$Query$discoverMovies$libraryById$mostPlayedMovies<
    Query$discoverMovies$libraryById$mostPlayedMovies
  >
  get copyWith => CopyWith$Query$discoverMovies$libraryById$mostPlayedMovies(
    this,
    (i) => i,
  );
}

abstract class CopyWith$Query$discoverMovies$libraryById$mostPlayedMovies<
  TRes
> {
  factory CopyWith$Query$discoverMovies$libraryById$mostPlayedMovies(
    Query$discoverMovies$libraryById$mostPlayedMovies instance,
    TRes Function(Query$discoverMovies$libraryById$mostPlayedMovies) then,
  ) = _CopyWithImpl$Query$discoverMovies$libraryById$mostPlayedMovies;

  factory CopyWith$Query$discoverMovies$libraryById$mostPlayedMovies.stub(
    TRes res,
  ) = _CopyWithStubImpl$Query$discoverMovies$libraryById$mostPlayedMovies;

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

class _CopyWithImpl$Query$discoverMovies$libraryById$mostPlayedMovies<TRes>
    implements
        CopyWith$Query$discoverMovies$libraryById$mostPlayedMovies<TRes> {
  _CopyWithImpl$Query$discoverMovies$libraryById$mostPlayedMovies(
    this._instance,
    this._then,
  );

  final Query$discoverMovies$libraryById$mostPlayedMovies _instance;

  final TRes Function(Query$discoverMovies$libraryById$mostPlayedMovies) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? id = _undefined,
    Object? name = _undefined,
    Object? releaseYear = _undefined,
    Object? images = _undefined,
    Object? metadata = _undefined,
    Object? $__typename = _undefined,
  }) => _then(
    Query$discoverMovies$libraryById$mostPlayedMovies(
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

class _CopyWithStubImpl$Query$discoverMovies$libraryById$mostPlayedMovies<TRes>
    implements
        CopyWith$Query$discoverMovies$libraryById$mostPlayedMovies<TRes> {
  _CopyWithStubImpl$Query$discoverMovies$libraryById$mostPlayedMovies(
    this._res,
  );

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

class Query$discoverMovies$libraryById$highestRatedMovies {
  Query$discoverMovies$libraryById$highestRatedMovies({
    required this.id,
    required this.name,
    required this.releaseYear,
    this.images,
    this.metadata,
    this.$__typename = 'Movie',
  });

  factory Query$discoverMovies$libraryById$highestRatedMovies.fromJson(
    Map<String, dynamic> json,
  ) {
    final l$id = json['id'];
    final l$name = json['name'];
    final l$releaseYear = json['releaseYear'];
    final l$images = json['images'];
    final l$metadata = json['metadata'];
    final l$$__typename = json['__typename'];
    return Query$discoverMovies$libraryById$highestRatedMovies(
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
    if (other is! Query$discoverMovies$libraryById$highestRatedMovies ||
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

extension UtilityExtension$Query$discoverMovies$libraryById$highestRatedMovies
    on Query$discoverMovies$libraryById$highestRatedMovies {
  CopyWith$Query$discoverMovies$libraryById$highestRatedMovies<
    Query$discoverMovies$libraryById$highestRatedMovies
  >
  get copyWith => CopyWith$Query$discoverMovies$libraryById$highestRatedMovies(
    this,
    (i) => i,
  );
}

abstract class CopyWith$Query$discoverMovies$libraryById$highestRatedMovies<
  TRes
> {
  factory CopyWith$Query$discoverMovies$libraryById$highestRatedMovies(
    Query$discoverMovies$libraryById$highestRatedMovies instance,
    TRes Function(Query$discoverMovies$libraryById$highestRatedMovies) then,
  ) = _CopyWithImpl$Query$discoverMovies$libraryById$highestRatedMovies;

  factory CopyWith$Query$discoverMovies$libraryById$highestRatedMovies.stub(
    TRes res,
  ) = _CopyWithStubImpl$Query$discoverMovies$libraryById$highestRatedMovies;

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

class _CopyWithImpl$Query$discoverMovies$libraryById$highestRatedMovies<TRes>
    implements
        CopyWith$Query$discoverMovies$libraryById$highestRatedMovies<TRes> {
  _CopyWithImpl$Query$discoverMovies$libraryById$highestRatedMovies(
    this._instance,
    this._then,
  );

  final Query$discoverMovies$libraryById$highestRatedMovies _instance;

  final TRes Function(Query$discoverMovies$libraryById$highestRatedMovies)
  _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? id = _undefined,
    Object? name = _undefined,
    Object? releaseYear = _undefined,
    Object? images = _undefined,
    Object? metadata = _undefined,
    Object? $__typename = _undefined,
  }) => _then(
    Query$discoverMovies$libraryById$highestRatedMovies(
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

class _CopyWithStubImpl$Query$discoverMovies$libraryById$highestRatedMovies<
  TRes
>
    implements
        CopyWith$Query$discoverMovies$libraryById$highestRatedMovies<TRes> {
  _CopyWithStubImpl$Query$discoverMovies$libraryById$highestRatedMovies(
    this._res,
  );

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

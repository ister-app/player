import 'fragmentImages.graphql.dart';
import 'fragmentMetadata.graphql.dart';

import 'package:gql/ast.dart';

class Variables$Query$discoverShows {
  factory Variables$Query$discoverShows({
    required String libraryId,
    int? limit,
  }) => Variables$Query$discoverShows._({
    r'libraryId': libraryId,
    if (limit != null) r'limit': limit,
  });

  Variables$Query$discoverShows._(this._$data);

  factory Variables$Query$discoverShows.fromJson(Map<String, dynamic> data) {
    final result$data = <String, dynamic>{};
    final l$libraryId = data['libraryId'];
    result$data['libraryId'] = (l$libraryId as String);
    if (data.containsKey('limit')) {
      final l$limit = data['limit'];
      result$data['limit'] = (l$limit as int?);
    }
    return Variables$Query$discoverShows._(result$data);
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

  CopyWith$Variables$Query$discoverShows<Variables$Query$discoverShows>
  get copyWith => CopyWith$Variables$Query$discoverShows(this, (i) => i);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Variables$Query$discoverShows ||
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

abstract class CopyWith$Variables$Query$discoverShows<TRes> {
  factory CopyWith$Variables$Query$discoverShows(
    Variables$Query$discoverShows instance,
    TRes Function(Variables$Query$discoverShows) then,
  ) = _CopyWithImpl$Variables$Query$discoverShows;

  factory CopyWith$Variables$Query$discoverShows.stub(TRes res) =
      _CopyWithStubImpl$Variables$Query$discoverShows;

  TRes call({String? libraryId, int? limit});
}

class _CopyWithImpl$Variables$Query$discoverShows<TRes>
    implements CopyWith$Variables$Query$discoverShows<TRes> {
  _CopyWithImpl$Variables$Query$discoverShows(this._instance, this._then);

  final Variables$Query$discoverShows _instance;

  final TRes Function(Variables$Query$discoverShows) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({Object? libraryId = _undefined, Object? limit = _undefined}) =>
      _then(
        Variables$Query$discoverShows._({
          ..._instance._$data,
          if (libraryId != _undefined && libraryId != null)
            'libraryId': (libraryId as String),
          if (limit != _undefined) 'limit': (limit as int?),
        }),
      );
}

class _CopyWithStubImpl$Variables$Query$discoverShows<TRes>
    implements CopyWith$Variables$Query$discoverShows<TRes> {
  _CopyWithStubImpl$Variables$Query$discoverShows(this._res);

  TRes _res;

  call({String? libraryId, int? limit}) => _res;
}

class Query$discoverShows {
  Query$discoverShows({this.libraryById, this.$__typename = 'Query'});

  factory Query$discoverShows.fromJson(Map<String, dynamic> json) {
    final l$libraryById = json['libraryById'];
    final l$$__typename = json['__typename'];
    return Query$discoverShows(
      libraryById: l$libraryById == null
          ? null
          : Query$discoverShows$libraryById.fromJson(
              (l$libraryById as Map<String, dynamic>),
            ),
      $__typename: (l$$__typename as String),
    );
  }

  final Query$discoverShows$libraryById? libraryById;

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
    if (other is! Query$discoverShows || runtimeType != other.runtimeType) {
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

extension UtilityExtension$Query$discoverShows on Query$discoverShows {
  CopyWith$Query$discoverShows<Query$discoverShows> get copyWith =>
      CopyWith$Query$discoverShows(this, (i) => i);
}

abstract class CopyWith$Query$discoverShows<TRes> {
  factory CopyWith$Query$discoverShows(
    Query$discoverShows instance,
    TRes Function(Query$discoverShows) then,
  ) = _CopyWithImpl$Query$discoverShows;

  factory CopyWith$Query$discoverShows.stub(TRes res) =
      _CopyWithStubImpl$Query$discoverShows;

  TRes call({
    Query$discoverShows$libraryById? libraryById,
    String? $__typename,
  });
  CopyWith$Query$discoverShows$libraryById<TRes> get libraryById;
}

class _CopyWithImpl$Query$discoverShows<TRes>
    implements CopyWith$Query$discoverShows<TRes> {
  _CopyWithImpl$Query$discoverShows(this._instance, this._then);

  final Query$discoverShows _instance;

  final TRes Function(Query$discoverShows) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? libraryById = _undefined,
    Object? $__typename = _undefined,
  }) => _then(
    Query$discoverShows(
      libraryById: libraryById == _undefined
          ? _instance.libraryById
          : (libraryById as Query$discoverShows$libraryById?),
      $__typename: $__typename == _undefined || $__typename == null
          ? _instance.$__typename
          : ($__typename as String),
    ),
  );

  CopyWith$Query$discoverShows$libraryById<TRes> get libraryById {
    final local$libraryById = _instance.libraryById;
    return local$libraryById == null
        ? CopyWith$Query$discoverShows$libraryById.stub(_then(_instance))
        : CopyWith$Query$discoverShows$libraryById(
            local$libraryById,
            (e) => call(libraryById: e),
          );
  }
}

class _CopyWithStubImpl$Query$discoverShows<TRes>
    implements CopyWith$Query$discoverShows<TRes> {
  _CopyWithStubImpl$Query$discoverShows(this._res);

  TRes _res;

  call({Query$discoverShows$libraryById? libraryById, String? $__typename}) =>
      _res;

  CopyWith$Query$discoverShows$libraryById<TRes> get libraryById =>
      CopyWith$Query$discoverShows$libraryById.stub(_res);
}

const documentNodeQuerydiscoverShows = DocumentNode(
  definitions: [
    OperationDefinitionNode(
      type: OperationType.query,
      name: NameNode(value: 'discoverShows'),
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
                  name: NameNode(value: 'recentlyPlayedShows'),
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
                  name: NameNode(value: 'mostPlayedShows'),
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
                  name: NameNode(value: 'highestRatedShows'),
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

class Query$discoverShows$libraryById {
  Query$discoverShows$libraryById({
    required this.id,
    required this.recentlyPlayedShows,
    required this.mostPlayedShows,
    required this.highestRatedShows,
    this.$__typename = 'Library',
  });

  factory Query$discoverShows$libraryById.fromJson(Map<String, dynamic> json) {
    final l$id = json['id'];
    final l$recentlyPlayedShows = json['recentlyPlayedShows'];
    final l$mostPlayedShows = json['mostPlayedShows'];
    final l$highestRatedShows = json['highestRatedShows'];
    final l$$__typename = json['__typename'];
    return Query$discoverShows$libraryById(
      id: (l$id as String),
      recentlyPlayedShows: (l$recentlyPlayedShows as List<dynamic>)
          .map(
            (e) => Query$discoverShows$libraryById$recentlyPlayedShows.fromJson(
              (e as Map<String, dynamic>),
            ),
          )
          .toList(),
      mostPlayedShows: (l$mostPlayedShows as List<dynamic>)
          .map(
            (e) => Query$discoverShows$libraryById$mostPlayedShows.fromJson(
              (e as Map<String, dynamic>),
            ),
          )
          .toList(),
      highestRatedShows: (l$highestRatedShows as List<dynamic>)
          .map(
            (e) => Query$discoverShows$libraryById$highestRatedShows.fromJson(
              (e as Map<String, dynamic>),
            ),
          )
          .toList(),
      $__typename: (l$$__typename as String),
    );
  }

  final String id;

  final List<Query$discoverShows$libraryById$recentlyPlayedShows>
  recentlyPlayedShows;

  final List<Query$discoverShows$libraryById$mostPlayedShows> mostPlayedShows;

  final List<Query$discoverShows$libraryById$highestRatedShows>
  highestRatedShows;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$id = id;
    _resultData['id'] = l$id;
    final l$recentlyPlayedShows = recentlyPlayedShows;
    _resultData['recentlyPlayedShows'] = l$recentlyPlayedShows
        .map((e) => e.toJson())
        .toList();
    final l$mostPlayedShows = mostPlayedShows;
    _resultData['mostPlayedShows'] = l$mostPlayedShows
        .map((e) => e.toJson())
        .toList();
    final l$highestRatedShows = highestRatedShows;
    _resultData['highestRatedShows'] = l$highestRatedShows
        .map((e) => e.toJson())
        .toList();
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$id = id;
    final l$recentlyPlayedShows = recentlyPlayedShows;
    final l$mostPlayedShows = mostPlayedShows;
    final l$highestRatedShows = highestRatedShows;
    final l$$__typename = $__typename;
    return Object.hashAll([
      l$id,
      Object.hashAll(l$recentlyPlayedShows.map((v) => v)),
      Object.hashAll(l$mostPlayedShows.map((v) => v)),
      Object.hashAll(l$highestRatedShows.map((v) => v)),
      l$$__typename,
    ]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Query$discoverShows$libraryById ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$id = id;
    final lOther$id = other.id;
    if (l$id != lOther$id) {
      return false;
    }
    final l$recentlyPlayedShows = recentlyPlayedShows;
    final lOther$recentlyPlayedShows = other.recentlyPlayedShows;
    if (l$recentlyPlayedShows.length != lOther$recentlyPlayedShows.length) {
      return false;
    }
    for (int i = 0; i < l$recentlyPlayedShows.length; i++) {
      final l$recentlyPlayedShows$entry = l$recentlyPlayedShows[i];
      final lOther$recentlyPlayedShows$entry = lOther$recentlyPlayedShows[i];
      if (l$recentlyPlayedShows$entry != lOther$recentlyPlayedShows$entry) {
        return false;
      }
    }
    final l$mostPlayedShows = mostPlayedShows;
    final lOther$mostPlayedShows = other.mostPlayedShows;
    if (l$mostPlayedShows.length != lOther$mostPlayedShows.length) {
      return false;
    }
    for (int i = 0; i < l$mostPlayedShows.length; i++) {
      final l$mostPlayedShows$entry = l$mostPlayedShows[i];
      final lOther$mostPlayedShows$entry = lOther$mostPlayedShows[i];
      if (l$mostPlayedShows$entry != lOther$mostPlayedShows$entry) {
        return false;
      }
    }
    final l$highestRatedShows = highestRatedShows;
    final lOther$highestRatedShows = other.highestRatedShows;
    if (l$highestRatedShows.length != lOther$highestRatedShows.length) {
      return false;
    }
    for (int i = 0; i < l$highestRatedShows.length; i++) {
      final l$highestRatedShows$entry = l$highestRatedShows[i];
      final lOther$highestRatedShows$entry = lOther$highestRatedShows[i];
      if (l$highestRatedShows$entry != lOther$highestRatedShows$entry) {
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

extension UtilityExtension$Query$discoverShows$libraryById
    on Query$discoverShows$libraryById {
  CopyWith$Query$discoverShows$libraryById<Query$discoverShows$libraryById>
  get copyWith => CopyWith$Query$discoverShows$libraryById(this, (i) => i);
}

abstract class CopyWith$Query$discoverShows$libraryById<TRes> {
  factory CopyWith$Query$discoverShows$libraryById(
    Query$discoverShows$libraryById instance,
    TRes Function(Query$discoverShows$libraryById) then,
  ) = _CopyWithImpl$Query$discoverShows$libraryById;

  factory CopyWith$Query$discoverShows$libraryById.stub(TRes res) =
      _CopyWithStubImpl$Query$discoverShows$libraryById;

  TRes call({
    String? id,
    List<Query$discoverShows$libraryById$recentlyPlayedShows>?
    recentlyPlayedShows,
    List<Query$discoverShows$libraryById$mostPlayedShows>? mostPlayedShows,
    List<Query$discoverShows$libraryById$highestRatedShows>? highestRatedShows,
    String? $__typename,
  });
  TRes recentlyPlayedShows(
    Iterable<Query$discoverShows$libraryById$recentlyPlayedShows> Function(
      Iterable<
        CopyWith$Query$discoverShows$libraryById$recentlyPlayedShows<
          Query$discoverShows$libraryById$recentlyPlayedShows
        >
      >,
    )
    _fn,
  );
  TRes mostPlayedShows(
    Iterable<Query$discoverShows$libraryById$mostPlayedShows> Function(
      Iterable<
        CopyWith$Query$discoverShows$libraryById$mostPlayedShows<
          Query$discoverShows$libraryById$mostPlayedShows
        >
      >,
    )
    _fn,
  );
  TRes highestRatedShows(
    Iterable<Query$discoverShows$libraryById$highestRatedShows> Function(
      Iterable<
        CopyWith$Query$discoverShows$libraryById$highestRatedShows<
          Query$discoverShows$libraryById$highestRatedShows
        >
      >,
    )
    _fn,
  );
}

class _CopyWithImpl$Query$discoverShows$libraryById<TRes>
    implements CopyWith$Query$discoverShows$libraryById<TRes> {
  _CopyWithImpl$Query$discoverShows$libraryById(this._instance, this._then);

  final Query$discoverShows$libraryById _instance;

  final TRes Function(Query$discoverShows$libraryById) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? id = _undefined,
    Object? recentlyPlayedShows = _undefined,
    Object? mostPlayedShows = _undefined,
    Object? highestRatedShows = _undefined,
    Object? $__typename = _undefined,
  }) => _then(
    Query$discoverShows$libraryById(
      id: id == _undefined || id == null ? _instance.id : (id as String),
      recentlyPlayedShows:
          recentlyPlayedShows == _undefined || recentlyPlayedShows == null
          ? _instance.recentlyPlayedShows
          : (recentlyPlayedShows
                as List<Query$discoverShows$libraryById$recentlyPlayedShows>),
      mostPlayedShows: mostPlayedShows == _undefined || mostPlayedShows == null
          ? _instance.mostPlayedShows
          : (mostPlayedShows
                as List<Query$discoverShows$libraryById$mostPlayedShows>),
      highestRatedShows:
          highestRatedShows == _undefined || highestRatedShows == null
          ? _instance.highestRatedShows
          : (highestRatedShows
                as List<Query$discoverShows$libraryById$highestRatedShows>),
      $__typename: $__typename == _undefined || $__typename == null
          ? _instance.$__typename
          : ($__typename as String),
    ),
  );

  TRes recentlyPlayedShows(
    Iterable<Query$discoverShows$libraryById$recentlyPlayedShows> Function(
      Iterable<
        CopyWith$Query$discoverShows$libraryById$recentlyPlayedShows<
          Query$discoverShows$libraryById$recentlyPlayedShows
        >
      >,
    )
    _fn,
  ) => call(
    recentlyPlayedShows: _fn(
      _instance.recentlyPlayedShows.map(
        (e) => CopyWith$Query$discoverShows$libraryById$recentlyPlayedShows(
          e,
          (i) => i,
        ),
      ),
    ).toList(),
  );

  TRes mostPlayedShows(
    Iterable<Query$discoverShows$libraryById$mostPlayedShows> Function(
      Iterable<
        CopyWith$Query$discoverShows$libraryById$mostPlayedShows<
          Query$discoverShows$libraryById$mostPlayedShows
        >
      >,
    )
    _fn,
  ) => call(
    mostPlayedShows: _fn(
      _instance.mostPlayedShows.map(
        (e) => CopyWith$Query$discoverShows$libraryById$mostPlayedShows(
          e,
          (i) => i,
        ),
      ),
    ).toList(),
  );

  TRes highestRatedShows(
    Iterable<Query$discoverShows$libraryById$highestRatedShows> Function(
      Iterable<
        CopyWith$Query$discoverShows$libraryById$highestRatedShows<
          Query$discoverShows$libraryById$highestRatedShows
        >
      >,
    )
    _fn,
  ) => call(
    highestRatedShows: _fn(
      _instance.highestRatedShows.map(
        (e) => CopyWith$Query$discoverShows$libraryById$highestRatedShows(
          e,
          (i) => i,
        ),
      ),
    ).toList(),
  );
}

class _CopyWithStubImpl$Query$discoverShows$libraryById<TRes>
    implements CopyWith$Query$discoverShows$libraryById<TRes> {
  _CopyWithStubImpl$Query$discoverShows$libraryById(this._res);

  TRes _res;

  call({
    String? id,
    List<Query$discoverShows$libraryById$recentlyPlayedShows>?
    recentlyPlayedShows,
    List<Query$discoverShows$libraryById$mostPlayedShows>? mostPlayedShows,
    List<Query$discoverShows$libraryById$highestRatedShows>? highestRatedShows,
    String? $__typename,
  }) => _res;

  recentlyPlayedShows(_fn) => _res;

  mostPlayedShows(_fn) => _res;

  highestRatedShows(_fn) => _res;
}

class Query$discoverShows$libraryById$recentlyPlayedShows {
  Query$discoverShows$libraryById$recentlyPlayedShows({
    required this.id,
    required this.name,
    required this.releaseYear,
    this.images,
    this.metadata,
    this.$__typename = 'Show',
  });

  factory Query$discoverShows$libraryById$recentlyPlayedShows.fromJson(
    Map<String, dynamic> json,
  ) {
    final l$id = json['id'];
    final l$name = json['name'];
    final l$releaseYear = json['releaseYear'];
    final l$images = json['images'];
    final l$metadata = json['metadata'];
    final l$$__typename = json['__typename'];
    return Query$discoverShows$libraryById$recentlyPlayedShows(
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
    if (other is! Query$discoverShows$libraryById$recentlyPlayedShows ||
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

extension UtilityExtension$Query$discoverShows$libraryById$recentlyPlayedShows
    on Query$discoverShows$libraryById$recentlyPlayedShows {
  CopyWith$Query$discoverShows$libraryById$recentlyPlayedShows<
    Query$discoverShows$libraryById$recentlyPlayedShows
  >
  get copyWith => CopyWith$Query$discoverShows$libraryById$recentlyPlayedShows(
    this,
    (i) => i,
  );
}

abstract class CopyWith$Query$discoverShows$libraryById$recentlyPlayedShows<
  TRes
> {
  factory CopyWith$Query$discoverShows$libraryById$recentlyPlayedShows(
    Query$discoverShows$libraryById$recentlyPlayedShows instance,
    TRes Function(Query$discoverShows$libraryById$recentlyPlayedShows) then,
  ) = _CopyWithImpl$Query$discoverShows$libraryById$recentlyPlayedShows;

  factory CopyWith$Query$discoverShows$libraryById$recentlyPlayedShows.stub(
    TRes res,
  ) = _CopyWithStubImpl$Query$discoverShows$libraryById$recentlyPlayedShows;

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

class _CopyWithImpl$Query$discoverShows$libraryById$recentlyPlayedShows<TRes>
    implements
        CopyWith$Query$discoverShows$libraryById$recentlyPlayedShows<TRes> {
  _CopyWithImpl$Query$discoverShows$libraryById$recentlyPlayedShows(
    this._instance,
    this._then,
  );

  final Query$discoverShows$libraryById$recentlyPlayedShows _instance;

  final TRes Function(Query$discoverShows$libraryById$recentlyPlayedShows)
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
    Query$discoverShows$libraryById$recentlyPlayedShows(
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

class _CopyWithStubImpl$Query$discoverShows$libraryById$recentlyPlayedShows<
  TRes
>
    implements
        CopyWith$Query$discoverShows$libraryById$recentlyPlayedShows<TRes> {
  _CopyWithStubImpl$Query$discoverShows$libraryById$recentlyPlayedShows(
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

class Query$discoverShows$libraryById$mostPlayedShows {
  Query$discoverShows$libraryById$mostPlayedShows({
    required this.id,
    required this.name,
    required this.releaseYear,
    this.images,
    this.metadata,
    this.$__typename = 'Show',
  });

  factory Query$discoverShows$libraryById$mostPlayedShows.fromJson(
    Map<String, dynamic> json,
  ) {
    final l$id = json['id'];
    final l$name = json['name'];
    final l$releaseYear = json['releaseYear'];
    final l$images = json['images'];
    final l$metadata = json['metadata'];
    final l$$__typename = json['__typename'];
    return Query$discoverShows$libraryById$mostPlayedShows(
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
    if (other is! Query$discoverShows$libraryById$mostPlayedShows ||
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

extension UtilityExtension$Query$discoverShows$libraryById$mostPlayedShows
    on Query$discoverShows$libraryById$mostPlayedShows {
  CopyWith$Query$discoverShows$libraryById$mostPlayedShows<
    Query$discoverShows$libraryById$mostPlayedShows
  >
  get copyWith =>
      CopyWith$Query$discoverShows$libraryById$mostPlayedShows(this, (i) => i);
}

abstract class CopyWith$Query$discoverShows$libraryById$mostPlayedShows<TRes> {
  factory CopyWith$Query$discoverShows$libraryById$mostPlayedShows(
    Query$discoverShows$libraryById$mostPlayedShows instance,
    TRes Function(Query$discoverShows$libraryById$mostPlayedShows) then,
  ) = _CopyWithImpl$Query$discoverShows$libraryById$mostPlayedShows;

  factory CopyWith$Query$discoverShows$libraryById$mostPlayedShows.stub(
    TRes res,
  ) = _CopyWithStubImpl$Query$discoverShows$libraryById$mostPlayedShows;

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

class _CopyWithImpl$Query$discoverShows$libraryById$mostPlayedShows<TRes>
    implements CopyWith$Query$discoverShows$libraryById$mostPlayedShows<TRes> {
  _CopyWithImpl$Query$discoverShows$libraryById$mostPlayedShows(
    this._instance,
    this._then,
  );

  final Query$discoverShows$libraryById$mostPlayedShows _instance;

  final TRes Function(Query$discoverShows$libraryById$mostPlayedShows) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? id = _undefined,
    Object? name = _undefined,
    Object? releaseYear = _undefined,
    Object? images = _undefined,
    Object? metadata = _undefined,
    Object? $__typename = _undefined,
  }) => _then(
    Query$discoverShows$libraryById$mostPlayedShows(
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

class _CopyWithStubImpl$Query$discoverShows$libraryById$mostPlayedShows<TRes>
    implements CopyWith$Query$discoverShows$libraryById$mostPlayedShows<TRes> {
  _CopyWithStubImpl$Query$discoverShows$libraryById$mostPlayedShows(this._res);

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

class Query$discoverShows$libraryById$highestRatedShows {
  Query$discoverShows$libraryById$highestRatedShows({
    required this.id,
    required this.name,
    required this.releaseYear,
    this.images,
    this.metadata,
    this.$__typename = 'Show',
  });

  factory Query$discoverShows$libraryById$highestRatedShows.fromJson(
    Map<String, dynamic> json,
  ) {
    final l$id = json['id'];
    final l$name = json['name'];
    final l$releaseYear = json['releaseYear'];
    final l$images = json['images'];
    final l$metadata = json['metadata'];
    final l$$__typename = json['__typename'];
    return Query$discoverShows$libraryById$highestRatedShows(
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
    if (other is! Query$discoverShows$libraryById$highestRatedShows ||
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

extension UtilityExtension$Query$discoverShows$libraryById$highestRatedShows
    on Query$discoverShows$libraryById$highestRatedShows {
  CopyWith$Query$discoverShows$libraryById$highestRatedShows<
    Query$discoverShows$libraryById$highestRatedShows
  >
  get copyWith => CopyWith$Query$discoverShows$libraryById$highestRatedShows(
    this,
    (i) => i,
  );
}

abstract class CopyWith$Query$discoverShows$libraryById$highestRatedShows<
  TRes
> {
  factory CopyWith$Query$discoverShows$libraryById$highestRatedShows(
    Query$discoverShows$libraryById$highestRatedShows instance,
    TRes Function(Query$discoverShows$libraryById$highestRatedShows) then,
  ) = _CopyWithImpl$Query$discoverShows$libraryById$highestRatedShows;

  factory CopyWith$Query$discoverShows$libraryById$highestRatedShows.stub(
    TRes res,
  ) = _CopyWithStubImpl$Query$discoverShows$libraryById$highestRatedShows;

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

class _CopyWithImpl$Query$discoverShows$libraryById$highestRatedShows<TRes>
    implements
        CopyWith$Query$discoverShows$libraryById$highestRatedShows<TRes> {
  _CopyWithImpl$Query$discoverShows$libraryById$highestRatedShows(
    this._instance,
    this._then,
  );

  final Query$discoverShows$libraryById$highestRatedShows _instance;

  final TRes Function(Query$discoverShows$libraryById$highestRatedShows) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? id = _undefined,
    Object? name = _undefined,
    Object? releaseYear = _undefined,
    Object? images = _undefined,
    Object? metadata = _undefined,
    Object? $__typename = _undefined,
  }) => _then(
    Query$discoverShows$libraryById$highestRatedShows(
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

class _CopyWithStubImpl$Query$discoverShows$libraryById$highestRatedShows<TRes>
    implements
        CopyWith$Query$discoverShows$libraryById$highestRatedShows<TRes> {
  _CopyWithStubImpl$Query$discoverShows$libraryById$highestRatedShows(
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

import 'fragmentImages.graphql.dart';
import 'fragmentMetadata.graphql.dart';
import 'fragmentPodcast.graphql.dart';
import 'package:gql/ast.dart';

class Variables$Query$discoverPodcasts {
  factory Variables$Query$discoverPodcasts({
    required String libraryId,
    int? limit,
  }) => Variables$Query$discoverPodcasts._({
    r'libraryId': libraryId,
    if (limit != null) r'limit': limit,
  });

  Variables$Query$discoverPodcasts._(this._$data);

  factory Variables$Query$discoverPodcasts.fromJson(Map<String, dynamic> data) {
    final result$data = <String, dynamic>{};
    final l$libraryId = data['libraryId'];
    result$data['libraryId'] = (l$libraryId as String);
    if (data.containsKey('limit')) {
      final l$limit = data['limit'];
      result$data['limit'] = (l$limit as int?);
    }
    return Variables$Query$discoverPodcasts._(result$data);
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

  CopyWith$Variables$Query$discoverPodcasts<Variables$Query$discoverPodcasts>
  get copyWith => CopyWith$Variables$Query$discoverPodcasts(this, (i) => i);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Variables$Query$discoverPodcasts ||
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

abstract class CopyWith$Variables$Query$discoverPodcasts<TRes> {
  factory CopyWith$Variables$Query$discoverPodcasts(
    Variables$Query$discoverPodcasts instance,
    TRes Function(Variables$Query$discoverPodcasts) then,
  ) = _CopyWithImpl$Variables$Query$discoverPodcasts;

  factory CopyWith$Variables$Query$discoverPodcasts.stub(TRes res) =
      _CopyWithStubImpl$Variables$Query$discoverPodcasts;

  TRes call({String? libraryId, int? limit});
}

class _CopyWithImpl$Variables$Query$discoverPodcasts<TRes>
    implements CopyWith$Variables$Query$discoverPodcasts<TRes> {
  _CopyWithImpl$Variables$Query$discoverPodcasts(this._instance, this._then);

  final Variables$Query$discoverPodcasts _instance;

  final TRes Function(Variables$Query$discoverPodcasts) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({Object? libraryId = _undefined, Object? limit = _undefined}) =>
      _then(
        Variables$Query$discoverPodcasts._({
          ..._instance._$data,
          if (libraryId != _undefined && libraryId != null)
            'libraryId': (libraryId as String),
          if (limit != _undefined) 'limit': (limit as int?),
        }),
      );
}

class _CopyWithStubImpl$Variables$Query$discoverPodcasts<TRes>
    implements CopyWith$Variables$Query$discoverPodcasts<TRes> {
  _CopyWithStubImpl$Variables$Query$discoverPodcasts(this._res);

  TRes _res;

  call({String? libraryId, int? limit}) => _res;
}

class Query$discoverPodcasts {
  Query$discoverPodcasts({this.libraryById, this.$__typename = 'Query'});

  factory Query$discoverPodcasts.fromJson(Map<String, dynamic> json) {
    final l$libraryById = json['libraryById'];
    final l$$__typename = json['__typename'];
    return Query$discoverPodcasts(
      libraryById: l$libraryById == null
          ? null
          : Query$discoverPodcasts$libraryById.fromJson(
              (l$libraryById as Map<String, dynamic>),
            ),
      $__typename: (l$$__typename as String),
    );
  }

  final Query$discoverPodcasts$libraryById? libraryById;

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
    if (other is! Query$discoverPodcasts || runtimeType != other.runtimeType) {
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

extension UtilityExtension$Query$discoverPodcasts on Query$discoverPodcasts {
  CopyWith$Query$discoverPodcasts<Query$discoverPodcasts> get copyWith =>
      CopyWith$Query$discoverPodcasts(this, (i) => i);
}

abstract class CopyWith$Query$discoverPodcasts<TRes> {
  factory CopyWith$Query$discoverPodcasts(
    Query$discoverPodcasts instance,
    TRes Function(Query$discoverPodcasts) then,
  ) = _CopyWithImpl$Query$discoverPodcasts;

  factory CopyWith$Query$discoverPodcasts.stub(TRes res) =
      _CopyWithStubImpl$Query$discoverPodcasts;

  TRes call({
    Query$discoverPodcasts$libraryById? libraryById,
    String? $__typename,
  });
  CopyWith$Query$discoverPodcasts$libraryById<TRes> get libraryById;
}

class _CopyWithImpl$Query$discoverPodcasts<TRes>
    implements CopyWith$Query$discoverPodcasts<TRes> {
  _CopyWithImpl$Query$discoverPodcasts(this._instance, this._then);

  final Query$discoverPodcasts _instance;

  final TRes Function(Query$discoverPodcasts) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? libraryById = _undefined,
    Object? $__typename = _undefined,
  }) => _then(
    Query$discoverPodcasts(
      libraryById: libraryById == _undefined
          ? _instance.libraryById
          : (libraryById as Query$discoverPodcasts$libraryById?),
      $__typename: $__typename == _undefined || $__typename == null
          ? _instance.$__typename
          : ($__typename as String),
    ),
  );

  CopyWith$Query$discoverPodcasts$libraryById<TRes> get libraryById {
    final local$libraryById = _instance.libraryById;
    return local$libraryById == null
        ? CopyWith$Query$discoverPodcasts$libraryById.stub(_then(_instance))
        : CopyWith$Query$discoverPodcasts$libraryById(
            local$libraryById,
            (e) => call(libraryById: e),
          );
  }
}

class _CopyWithStubImpl$Query$discoverPodcasts<TRes>
    implements CopyWith$Query$discoverPodcasts<TRes> {
  _CopyWithStubImpl$Query$discoverPodcasts(this._res);

  TRes _res;

  call({
    Query$discoverPodcasts$libraryById? libraryById,
    String? $__typename,
  }) => _res;

  CopyWith$Query$discoverPodcasts$libraryById<TRes> get libraryById =>
      CopyWith$Query$discoverPodcasts$libraryById.stub(_res);
}

const documentNodeQuerydiscoverPodcasts = DocumentNode(
  definitions: [
    OperationDefinitionNode(
      type: OperationType.query,
      name: NameNode(value: 'discoverPodcasts'),
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
                  name: NameNode(value: 'recentlyPlayedPodcasts'),
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
                      FragmentSpreadNode(
                        name: NameNode(value: 'fragmentPodcast'),
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
                  name: NameNode(value: 'mostPlayedPodcasts'),
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
                      FragmentSpreadNode(
                        name: NameNode(value: 'fragmentPodcast'),
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
                  name: NameNode(value: 'highestRatedPodcasts'),
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
                      FragmentSpreadNode(
                        name: NameNode(value: 'fragmentPodcast'),
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
    fragmentDefinitionfragmentPodcast,
    fragmentDefinitionfragmentImages,
    fragmentDefinitionfragmentMetadata,
  ],
);

class Query$discoverPodcasts$libraryById {
  Query$discoverPodcasts$libraryById({
    required this.id,
    required this.recentlyPlayedPodcasts,
    required this.mostPlayedPodcasts,
    required this.highestRatedPodcasts,
    this.$__typename = 'Library',
  });

  factory Query$discoverPodcasts$libraryById.fromJson(
    Map<String, dynamic> json,
  ) {
    final l$id = json['id'];
    final l$recentlyPlayedPodcasts = json['recentlyPlayedPodcasts'];
    final l$mostPlayedPodcasts = json['mostPlayedPodcasts'];
    final l$highestRatedPodcasts = json['highestRatedPodcasts'];
    final l$$__typename = json['__typename'];
    return Query$discoverPodcasts$libraryById(
      id: (l$id as String),
      recentlyPlayedPodcasts: (l$recentlyPlayedPodcasts as List<dynamic>)
          .map(
            (e) =>
                Fragment$fragmentPodcast.fromJson((e as Map<String, dynamic>)),
          )
          .toList(),
      mostPlayedPodcasts: (l$mostPlayedPodcasts as List<dynamic>)
          .map(
            (e) =>
                Fragment$fragmentPodcast.fromJson((e as Map<String, dynamic>)),
          )
          .toList(),
      highestRatedPodcasts: (l$highestRatedPodcasts as List<dynamic>)
          .map(
            (e) =>
                Fragment$fragmentPodcast.fromJson((e as Map<String, dynamic>)),
          )
          .toList(),
      $__typename: (l$$__typename as String),
    );
  }

  final String id;

  final List<Fragment$fragmentPodcast> recentlyPlayedPodcasts;

  final List<Fragment$fragmentPodcast> mostPlayedPodcasts;

  final List<Fragment$fragmentPodcast> highestRatedPodcasts;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$id = id;
    _resultData['id'] = l$id;
    final l$recentlyPlayedPodcasts = recentlyPlayedPodcasts;
    _resultData['recentlyPlayedPodcasts'] = l$recentlyPlayedPodcasts
        .map((e) => e.toJson())
        .toList();
    final l$mostPlayedPodcasts = mostPlayedPodcasts;
    _resultData['mostPlayedPodcasts'] = l$mostPlayedPodcasts
        .map((e) => e.toJson())
        .toList();
    final l$highestRatedPodcasts = highestRatedPodcasts;
    _resultData['highestRatedPodcasts'] = l$highestRatedPodcasts
        .map((e) => e.toJson())
        .toList();
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$id = id;
    final l$recentlyPlayedPodcasts = recentlyPlayedPodcasts;
    final l$mostPlayedPodcasts = mostPlayedPodcasts;
    final l$highestRatedPodcasts = highestRatedPodcasts;
    final l$$__typename = $__typename;
    return Object.hashAll([
      l$id,
      Object.hashAll(l$recentlyPlayedPodcasts.map((v) => v)),
      Object.hashAll(l$mostPlayedPodcasts.map((v) => v)),
      Object.hashAll(l$highestRatedPodcasts.map((v) => v)),
      l$$__typename,
    ]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Query$discoverPodcasts$libraryById ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$id = id;
    final lOther$id = other.id;
    if (l$id != lOther$id) {
      return false;
    }
    final l$recentlyPlayedPodcasts = recentlyPlayedPodcasts;
    final lOther$recentlyPlayedPodcasts = other.recentlyPlayedPodcasts;
    if (l$recentlyPlayedPodcasts.length !=
        lOther$recentlyPlayedPodcasts.length) {
      return false;
    }
    for (int i = 0; i < l$recentlyPlayedPodcasts.length; i++) {
      final l$recentlyPlayedPodcasts$entry = l$recentlyPlayedPodcasts[i];
      final lOther$recentlyPlayedPodcasts$entry =
          lOther$recentlyPlayedPodcasts[i];
      if (l$recentlyPlayedPodcasts$entry !=
          lOther$recentlyPlayedPodcasts$entry) {
        return false;
      }
    }
    final l$mostPlayedPodcasts = mostPlayedPodcasts;
    final lOther$mostPlayedPodcasts = other.mostPlayedPodcasts;
    if (l$mostPlayedPodcasts.length != lOther$mostPlayedPodcasts.length) {
      return false;
    }
    for (int i = 0; i < l$mostPlayedPodcasts.length; i++) {
      final l$mostPlayedPodcasts$entry = l$mostPlayedPodcasts[i];
      final lOther$mostPlayedPodcasts$entry = lOther$mostPlayedPodcasts[i];
      if (l$mostPlayedPodcasts$entry != lOther$mostPlayedPodcasts$entry) {
        return false;
      }
    }
    final l$highestRatedPodcasts = highestRatedPodcasts;
    final lOther$highestRatedPodcasts = other.highestRatedPodcasts;
    if (l$highestRatedPodcasts.length != lOther$highestRatedPodcasts.length) {
      return false;
    }
    for (int i = 0; i < l$highestRatedPodcasts.length; i++) {
      final l$highestRatedPodcasts$entry = l$highestRatedPodcasts[i];
      final lOther$highestRatedPodcasts$entry = lOther$highestRatedPodcasts[i];
      if (l$highestRatedPodcasts$entry != lOther$highestRatedPodcasts$entry) {
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

extension UtilityExtension$Query$discoverPodcasts$libraryById
    on Query$discoverPodcasts$libraryById {
  CopyWith$Query$discoverPodcasts$libraryById<
    Query$discoverPodcasts$libraryById
  >
  get copyWith => CopyWith$Query$discoverPodcasts$libraryById(this, (i) => i);
}

abstract class CopyWith$Query$discoverPodcasts$libraryById<TRes> {
  factory CopyWith$Query$discoverPodcasts$libraryById(
    Query$discoverPodcasts$libraryById instance,
    TRes Function(Query$discoverPodcasts$libraryById) then,
  ) = _CopyWithImpl$Query$discoverPodcasts$libraryById;

  factory CopyWith$Query$discoverPodcasts$libraryById.stub(TRes res) =
      _CopyWithStubImpl$Query$discoverPodcasts$libraryById;

  TRes call({
    String? id,
    List<Fragment$fragmentPodcast>? recentlyPlayedPodcasts,
    List<Fragment$fragmentPodcast>? mostPlayedPodcasts,
    List<Fragment$fragmentPodcast>? highestRatedPodcasts,
    String? $__typename,
  });
  TRes recentlyPlayedPodcasts(
    Iterable<Fragment$fragmentPodcast> Function(
      Iterable<CopyWith$Fragment$fragmentPodcast<Fragment$fragmentPodcast>>,
    )
    _fn,
  );
  TRes mostPlayedPodcasts(
    Iterable<Fragment$fragmentPodcast> Function(
      Iterable<CopyWith$Fragment$fragmentPodcast<Fragment$fragmentPodcast>>,
    )
    _fn,
  );
  TRes highestRatedPodcasts(
    Iterable<Fragment$fragmentPodcast> Function(
      Iterable<CopyWith$Fragment$fragmentPodcast<Fragment$fragmentPodcast>>,
    )
    _fn,
  );
}

class _CopyWithImpl$Query$discoverPodcasts$libraryById<TRes>
    implements CopyWith$Query$discoverPodcasts$libraryById<TRes> {
  _CopyWithImpl$Query$discoverPodcasts$libraryById(this._instance, this._then);

  final Query$discoverPodcasts$libraryById _instance;

  final TRes Function(Query$discoverPodcasts$libraryById) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? id = _undefined,
    Object? recentlyPlayedPodcasts = _undefined,
    Object? mostPlayedPodcasts = _undefined,
    Object? highestRatedPodcasts = _undefined,
    Object? $__typename = _undefined,
  }) => _then(
    Query$discoverPodcasts$libraryById(
      id: id == _undefined || id == null ? _instance.id : (id as String),
      recentlyPlayedPodcasts:
          recentlyPlayedPodcasts == _undefined || recentlyPlayedPodcasts == null
          ? _instance.recentlyPlayedPodcasts
          : (recentlyPlayedPodcasts as List<Fragment$fragmentPodcast>),
      mostPlayedPodcasts:
          mostPlayedPodcasts == _undefined || mostPlayedPodcasts == null
          ? _instance.mostPlayedPodcasts
          : (mostPlayedPodcasts as List<Fragment$fragmentPodcast>),
      highestRatedPodcasts:
          highestRatedPodcasts == _undefined || highestRatedPodcasts == null
          ? _instance.highestRatedPodcasts
          : (highestRatedPodcasts as List<Fragment$fragmentPodcast>),
      $__typename: $__typename == _undefined || $__typename == null
          ? _instance.$__typename
          : ($__typename as String),
    ),
  );

  TRes recentlyPlayedPodcasts(
    Iterable<Fragment$fragmentPodcast> Function(
      Iterable<CopyWith$Fragment$fragmentPodcast<Fragment$fragmentPodcast>>,
    )
    _fn,
  ) => call(
    recentlyPlayedPodcasts: _fn(
      _instance.recentlyPlayedPodcasts.map(
        (e) => CopyWith$Fragment$fragmentPodcast(e, (i) => i),
      ),
    ).toList(),
  );

  TRes mostPlayedPodcasts(
    Iterable<Fragment$fragmentPodcast> Function(
      Iterable<CopyWith$Fragment$fragmentPodcast<Fragment$fragmentPodcast>>,
    )
    _fn,
  ) => call(
    mostPlayedPodcasts: _fn(
      _instance.mostPlayedPodcasts.map(
        (e) => CopyWith$Fragment$fragmentPodcast(e, (i) => i),
      ),
    ).toList(),
  );

  TRes highestRatedPodcasts(
    Iterable<Fragment$fragmentPodcast> Function(
      Iterable<CopyWith$Fragment$fragmentPodcast<Fragment$fragmentPodcast>>,
    )
    _fn,
  ) => call(
    highestRatedPodcasts: _fn(
      _instance.highestRatedPodcasts.map(
        (e) => CopyWith$Fragment$fragmentPodcast(e, (i) => i),
      ),
    ).toList(),
  );
}

class _CopyWithStubImpl$Query$discoverPodcasts$libraryById<TRes>
    implements CopyWith$Query$discoverPodcasts$libraryById<TRes> {
  _CopyWithStubImpl$Query$discoverPodcasts$libraryById(this._res);

  TRes _res;

  call({
    String? id,
    List<Fragment$fragmentPodcast>? recentlyPlayedPodcasts,
    List<Fragment$fragmentPodcast>? mostPlayedPodcasts,
    List<Fragment$fragmentPodcast>? highestRatedPodcasts,
    String? $__typename,
  }) => _res;

  recentlyPlayedPodcasts(_fn) => _res;

  mostPlayedPodcasts(_fn) => _res;

  highestRatedPodcasts(_fn) => _res;
}

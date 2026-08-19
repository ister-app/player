import 'fragmentAlbum.graphql.dart';
import 'fragmentImages.graphql.dart';
import 'fragmentMetadata.graphql.dart';

import 'package:gql/ast.dart';

class Variables$Query$discoverAlbums {
  factory Variables$Query$discoverAlbums({
    required String libraryId,
    int? limit,
  }) => Variables$Query$discoverAlbums._({
    r'libraryId': libraryId,
    if (limit != null) r'limit': limit,
  });

  Variables$Query$discoverAlbums._(this._$data);

  factory Variables$Query$discoverAlbums.fromJson(Map<String, dynamic> data) {
    final result$data = <String, dynamic>{};
    final l$libraryId = data['libraryId'];
    result$data['libraryId'] = (l$libraryId as String);
    if (data.containsKey('limit')) {
      final l$limit = data['limit'];
      result$data['limit'] = (l$limit as int?);
    }
    return Variables$Query$discoverAlbums._(result$data);
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

  CopyWith$Variables$Query$discoverAlbums<Variables$Query$discoverAlbums>
  get copyWith => CopyWith$Variables$Query$discoverAlbums(this, (i) => i);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Variables$Query$discoverAlbums ||
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

abstract class CopyWith$Variables$Query$discoverAlbums<TRes> {
  factory CopyWith$Variables$Query$discoverAlbums(
    Variables$Query$discoverAlbums instance,
    TRes Function(Variables$Query$discoverAlbums) then,
  ) = _CopyWithImpl$Variables$Query$discoverAlbums;

  factory CopyWith$Variables$Query$discoverAlbums.stub(TRes res) =
      _CopyWithStubImpl$Variables$Query$discoverAlbums;

  TRes call({String? libraryId, int? limit});
}

class _CopyWithImpl$Variables$Query$discoverAlbums<TRes>
    implements CopyWith$Variables$Query$discoverAlbums<TRes> {
  _CopyWithImpl$Variables$Query$discoverAlbums(this._instance, this._then);

  final Variables$Query$discoverAlbums _instance;

  final TRes Function(Variables$Query$discoverAlbums) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({Object? libraryId = _undefined, Object? limit = _undefined}) =>
      _then(
        Variables$Query$discoverAlbums._({
          ..._instance._$data,
          if (libraryId != _undefined && libraryId != null)
            'libraryId': (libraryId as String),
          if (limit != _undefined) 'limit': (limit as int?),
        }),
      );
}

class _CopyWithStubImpl$Variables$Query$discoverAlbums<TRes>
    implements CopyWith$Variables$Query$discoverAlbums<TRes> {
  _CopyWithStubImpl$Variables$Query$discoverAlbums(this._res);

  TRes _res;

  call({String? libraryId, int? limit}) => _res;
}

class Query$discoverAlbums {
  Query$discoverAlbums({this.libraryById, this.$__typename = 'Query'});

  factory Query$discoverAlbums.fromJson(Map<String, dynamic> json) {
    final l$libraryById = json['libraryById'];
    final l$$__typename = json['__typename'];
    return Query$discoverAlbums(
      libraryById: l$libraryById == null
          ? null
          : Query$discoverAlbums$libraryById.fromJson(
              (l$libraryById as Map<String, dynamic>),
            ),
      $__typename: (l$$__typename as String),
    );
  }

  final Query$discoverAlbums$libraryById? libraryById;

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
    if (other is! Query$discoverAlbums || runtimeType != other.runtimeType) {
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

extension UtilityExtension$Query$discoverAlbums on Query$discoverAlbums {
  CopyWith$Query$discoverAlbums<Query$discoverAlbums> get copyWith =>
      CopyWith$Query$discoverAlbums(this, (i) => i);
}

abstract class CopyWith$Query$discoverAlbums<TRes> {
  factory CopyWith$Query$discoverAlbums(
    Query$discoverAlbums instance,
    TRes Function(Query$discoverAlbums) then,
  ) = _CopyWithImpl$Query$discoverAlbums;

  factory CopyWith$Query$discoverAlbums.stub(TRes res) =
      _CopyWithStubImpl$Query$discoverAlbums;

  TRes call({
    Query$discoverAlbums$libraryById? libraryById,
    String? $__typename,
  });
  CopyWith$Query$discoverAlbums$libraryById<TRes> get libraryById;
}

class _CopyWithImpl$Query$discoverAlbums<TRes>
    implements CopyWith$Query$discoverAlbums<TRes> {
  _CopyWithImpl$Query$discoverAlbums(this._instance, this._then);

  final Query$discoverAlbums _instance;

  final TRes Function(Query$discoverAlbums) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? libraryById = _undefined,
    Object? $__typename = _undefined,
  }) => _then(
    Query$discoverAlbums(
      libraryById: libraryById == _undefined
          ? _instance.libraryById
          : (libraryById as Query$discoverAlbums$libraryById?),
      $__typename: $__typename == _undefined || $__typename == null
          ? _instance.$__typename
          : ($__typename as String),
    ),
  );

  CopyWith$Query$discoverAlbums$libraryById<TRes> get libraryById {
    final local$libraryById = _instance.libraryById;
    return local$libraryById == null
        ? CopyWith$Query$discoverAlbums$libraryById.stub(_then(_instance))
        : CopyWith$Query$discoverAlbums$libraryById(
            local$libraryById,
            (e) => call(libraryById: e),
          );
  }
}

class _CopyWithStubImpl$Query$discoverAlbums<TRes>
    implements CopyWith$Query$discoverAlbums<TRes> {
  _CopyWithStubImpl$Query$discoverAlbums(this._res);

  TRes _res;

  call({Query$discoverAlbums$libraryById? libraryById, String? $__typename}) =>
      _res;

  CopyWith$Query$discoverAlbums$libraryById<TRes> get libraryById =>
      CopyWith$Query$discoverAlbums$libraryById.stub(_res);
}

const documentNodeQuerydiscoverAlbums = DocumentNode(
  definitions: [
    OperationDefinitionNode(
      type: OperationType.query,
      name: NameNode(value: 'discoverAlbums'),
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
                  name: NameNode(value: 'recentlyPlayedAlbums'),
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
                        name: NameNode(value: 'fragmentAlbum'),
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
                  name: NameNode(value: 'mostPlayedAlbums'),
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
                        name: NameNode(value: 'fragmentAlbum'),
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
                  name: NameNode(value: 'highestRatedAlbums'),
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
                        name: NameNode(value: 'fragmentAlbum'),
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
    fragmentDefinitionfragmentAlbum,
    fragmentDefinitionfragmentImages,
    fragmentDefinitionfragmentMetadata,
  ],
);

class Query$discoverAlbums$libraryById {
  Query$discoverAlbums$libraryById({
    required this.id,
    required this.recentlyPlayedAlbums,
    required this.mostPlayedAlbums,
    required this.highestRatedAlbums,
    this.$__typename = 'Library',
  });

  factory Query$discoverAlbums$libraryById.fromJson(Map<String, dynamic> json) {
    final l$id = json['id'];
    final l$recentlyPlayedAlbums = json['recentlyPlayedAlbums'];
    final l$mostPlayedAlbums = json['mostPlayedAlbums'];
    final l$highestRatedAlbums = json['highestRatedAlbums'];
    final l$$__typename = json['__typename'];
    return Query$discoverAlbums$libraryById(
      id: (l$id as String),
      recentlyPlayedAlbums: (l$recentlyPlayedAlbums as List<dynamic>)
          .map(
            (e) => Fragment$fragmentAlbum.fromJson((e as Map<String, dynamic>)),
          )
          .toList(),
      mostPlayedAlbums: (l$mostPlayedAlbums as List<dynamic>)
          .map(
            (e) => Fragment$fragmentAlbum.fromJson((e as Map<String, dynamic>)),
          )
          .toList(),
      highestRatedAlbums: (l$highestRatedAlbums as List<dynamic>)
          .map(
            (e) => Fragment$fragmentAlbum.fromJson((e as Map<String, dynamic>)),
          )
          .toList(),
      $__typename: (l$$__typename as String),
    );
  }

  final String id;

  final List<Fragment$fragmentAlbum> recentlyPlayedAlbums;

  final List<Fragment$fragmentAlbum> mostPlayedAlbums;

  final List<Fragment$fragmentAlbum> highestRatedAlbums;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$id = id;
    _resultData['id'] = l$id;
    final l$recentlyPlayedAlbums = recentlyPlayedAlbums;
    _resultData['recentlyPlayedAlbums'] = l$recentlyPlayedAlbums
        .map((e) => e.toJson())
        .toList();
    final l$mostPlayedAlbums = mostPlayedAlbums;
    _resultData['mostPlayedAlbums'] = l$mostPlayedAlbums
        .map((e) => e.toJson())
        .toList();
    final l$highestRatedAlbums = highestRatedAlbums;
    _resultData['highestRatedAlbums'] = l$highestRatedAlbums
        .map((e) => e.toJson())
        .toList();
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$id = id;
    final l$recentlyPlayedAlbums = recentlyPlayedAlbums;
    final l$mostPlayedAlbums = mostPlayedAlbums;
    final l$highestRatedAlbums = highestRatedAlbums;
    final l$$__typename = $__typename;
    return Object.hashAll([
      l$id,
      Object.hashAll(l$recentlyPlayedAlbums.map((v) => v)),
      Object.hashAll(l$mostPlayedAlbums.map((v) => v)),
      Object.hashAll(l$highestRatedAlbums.map((v) => v)),
      l$$__typename,
    ]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Query$discoverAlbums$libraryById ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$id = id;
    final lOther$id = other.id;
    if (l$id != lOther$id) {
      return false;
    }
    final l$recentlyPlayedAlbums = recentlyPlayedAlbums;
    final lOther$recentlyPlayedAlbums = other.recentlyPlayedAlbums;
    if (l$recentlyPlayedAlbums.length != lOther$recentlyPlayedAlbums.length) {
      return false;
    }
    for (int i = 0; i < l$recentlyPlayedAlbums.length; i++) {
      final l$recentlyPlayedAlbums$entry = l$recentlyPlayedAlbums[i];
      final lOther$recentlyPlayedAlbums$entry = lOther$recentlyPlayedAlbums[i];
      if (l$recentlyPlayedAlbums$entry != lOther$recentlyPlayedAlbums$entry) {
        return false;
      }
    }
    final l$mostPlayedAlbums = mostPlayedAlbums;
    final lOther$mostPlayedAlbums = other.mostPlayedAlbums;
    if (l$mostPlayedAlbums.length != lOther$mostPlayedAlbums.length) {
      return false;
    }
    for (int i = 0; i < l$mostPlayedAlbums.length; i++) {
      final l$mostPlayedAlbums$entry = l$mostPlayedAlbums[i];
      final lOther$mostPlayedAlbums$entry = lOther$mostPlayedAlbums[i];
      if (l$mostPlayedAlbums$entry != lOther$mostPlayedAlbums$entry) {
        return false;
      }
    }
    final l$highestRatedAlbums = highestRatedAlbums;
    final lOther$highestRatedAlbums = other.highestRatedAlbums;
    if (l$highestRatedAlbums.length != lOther$highestRatedAlbums.length) {
      return false;
    }
    for (int i = 0; i < l$highestRatedAlbums.length; i++) {
      final l$highestRatedAlbums$entry = l$highestRatedAlbums[i];
      final lOther$highestRatedAlbums$entry = lOther$highestRatedAlbums[i];
      if (l$highestRatedAlbums$entry != lOther$highestRatedAlbums$entry) {
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

extension UtilityExtension$Query$discoverAlbums$libraryById
    on Query$discoverAlbums$libraryById {
  CopyWith$Query$discoverAlbums$libraryById<Query$discoverAlbums$libraryById>
  get copyWith => CopyWith$Query$discoverAlbums$libraryById(this, (i) => i);
}

abstract class CopyWith$Query$discoverAlbums$libraryById<TRes> {
  factory CopyWith$Query$discoverAlbums$libraryById(
    Query$discoverAlbums$libraryById instance,
    TRes Function(Query$discoverAlbums$libraryById) then,
  ) = _CopyWithImpl$Query$discoverAlbums$libraryById;

  factory CopyWith$Query$discoverAlbums$libraryById.stub(TRes res) =
      _CopyWithStubImpl$Query$discoverAlbums$libraryById;

  TRes call({
    String? id,
    List<Fragment$fragmentAlbum>? recentlyPlayedAlbums,
    List<Fragment$fragmentAlbum>? mostPlayedAlbums,
    List<Fragment$fragmentAlbum>? highestRatedAlbums,
    String? $__typename,
  });
  TRes recentlyPlayedAlbums(
    Iterable<Fragment$fragmentAlbum> Function(
      Iterable<CopyWith$Fragment$fragmentAlbum<Fragment$fragmentAlbum>>,
    )
    _fn,
  );
  TRes mostPlayedAlbums(
    Iterable<Fragment$fragmentAlbum> Function(
      Iterable<CopyWith$Fragment$fragmentAlbum<Fragment$fragmentAlbum>>,
    )
    _fn,
  );
  TRes highestRatedAlbums(
    Iterable<Fragment$fragmentAlbum> Function(
      Iterable<CopyWith$Fragment$fragmentAlbum<Fragment$fragmentAlbum>>,
    )
    _fn,
  );
}

class _CopyWithImpl$Query$discoverAlbums$libraryById<TRes>
    implements CopyWith$Query$discoverAlbums$libraryById<TRes> {
  _CopyWithImpl$Query$discoverAlbums$libraryById(this._instance, this._then);

  final Query$discoverAlbums$libraryById _instance;

  final TRes Function(Query$discoverAlbums$libraryById) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? id = _undefined,
    Object? recentlyPlayedAlbums = _undefined,
    Object? mostPlayedAlbums = _undefined,
    Object? highestRatedAlbums = _undefined,
    Object? $__typename = _undefined,
  }) => _then(
    Query$discoverAlbums$libraryById(
      id: id == _undefined || id == null ? _instance.id : (id as String),
      recentlyPlayedAlbums:
          recentlyPlayedAlbums == _undefined || recentlyPlayedAlbums == null
          ? _instance.recentlyPlayedAlbums
          : (recentlyPlayedAlbums as List<Fragment$fragmentAlbum>),
      mostPlayedAlbums:
          mostPlayedAlbums == _undefined || mostPlayedAlbums == null
          ? _instance.mostPlayedAlbums
          : (mostPlayedAlbums as List<Fragment$fragmentAlbum>),
      highestRatedAlbums:
          highestRatedAlbums == _undefined || highestRatedAlbums == null
          ? _instance.highestRatedAlbums
          : (highestRatedAlbums as List<Fragment$fragmentAlbum>),
      $__typename: $__typename == _undefined || $__typename == null
          ? _instance.$__typename
          : ($__typename as String),
    ),
  );

  TRes recentlyPlayedAlbums(
    Iterable<Fragment$fragmentAlbum> Function(
      Iterable<CopyWith$Fragment$fragmentAlbum<Fragment$fragmentAlbum>>,
    )
    _fn,
  ) => call(
    recentlyPlayedAlbums: _fn(
      _instance.recentlyPlayedAlbums.map(
        (e) => CopyWith$Fragment$fragmentAlbum(e, (i) => i),
      ),
    ).toList(),
  );

  TRes mostPlayedAlbums(
    Iterable<Fragment$fragmentAlbum> Function(
      Iterable<CopyWith$Fragment$fragmentAlbum<Fragment$fragmentAlbum>>,
    )
    _fn,
  ) => call(
    mostPlayedAlbums: _fn(
      _instance.mostPlayedAlbums.map(
        (e) => CopyWith$Fragment$fragmentAlbum(e, (i) => i),
      ),
    ).toList(),
  );

  TRes highestRatedAlbums(
    Iterable<Fragment$fragmentAlbum> Function(
      Iterable<CopyWith$Fragment$fragmentAlbum<Fragment$fragmentAlbum>>,
    )
    _fn,
  ) => call(
    highestRatedAlbums: _fn(
      _instance.highestRatedAlbums.map(
        (e) => CopyWith$Fragment$fragmentAlbum(e, (i) => i),
      ),
    ).toList(),
  );
}

class _CopyWithStubImpl$Query$discoverAlbums$libraryById<TRes>
    implements CopyWith$Query$discoverAlbums$libraryById<TRes> {
  _CopyWithStubImpl$Query$discoverAlbums$libraryById(this._res);

  TRes _res;

  call({
    String? id,
    List<Fragment$fragmentAlbum>? recentlyPlayedAlbums,
    List<Fragment$fragmentAlbum>? mostPlayedAlbums,
    List<Fragment$fragmentAlbum>? highestRatedAlbums,
    String? $__typename,
  }) => _res;

  recentlyPlayedAlbums(_fn) => _res;

  mostPlayedAlbums(_fn) => _res;

  highestRatedAlbums(_fn) => _res;
}

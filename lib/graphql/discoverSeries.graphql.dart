import 'fragmentImages.graphql.dart';
import 'fragmentMetadata.graphql.dart';
import 'fragmentSeries.graphql.dart';

import 'package:gql/ast.dart';

class Variables$Query$discoverSeries {
  factory Variables$Query$discoverSeries({
    required String libraryId,
    int? limit,
  }) => Variables$Query$discoverSeries._({
    r'libraryId': libraryId,
    if (limit != null) r'limit': limit,
  });

  Variables$Query$discoverSeries._(this._$data);

  factory Variables$Query$discoverSeries.fromJson(Map<String, dynamic> data) {
    final result$data = <String, dynamic>{};
    final l$libraryId = data['libraryId'];
    result$data['libraryId'] = (l$libraryId as String);
    if (data.containsKey('limit')) {
      final l$limit = data['limit'];
      result$data['limit'] = (l$limit as int?);
    }
    return Variables$Query$discoverSeries._(result$data);
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

  CopyWith$Variables$Query$discoverSeries<Variables$Query$discoverSeries>
  get copyWith => CopyWith$Variables$Query$discoverSeries(this, (i) => i);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Variables$Query$discoverSeries ||
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

abstract class CopyWith$Variables$Query$discoverSeries<TRes> {
  factory CopyWith$Variables$Query$discoverSeries(
    Variables$Query$discoverSeries instance,
    TRes Function(Variables$Query$discoverSeries) then,
  ) = _CopyWithImpl$Variables$Query$discoverSeries;

  factory CopyWith$Variables$Query$discoverSeries.stub(TRes res) =
      _CopyWithStubImpl$Variables$Query$discoverSeries;

  TRes call({String? libraryId, int? limit});
}

class _CopyWithImpl$Variables$Query$discoverSeries<TRes>
    implements CopyWith$Variables$Query$discoverSeries<TRes> {
  _CopyWithImpl$Variables$Query$discoverSeries(this._instance, this._then);

  final Variables$Query$discoverSeries _instance;

  final TRes Function(Variables$Query$discoverSeries) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({Object? libraryId = _undefined, Object? limit = _undefined}) =>
      _then(
        Variables$Query$discoverSeries._({
          ..._instance._$data,
          if (libraryId != _undefined && libraryId != null)
            'libraryId': (libraryId as String),
          if (limit != _undefined) 'limit': (limit as int?),
        }),
      );
}

class _CopyWithStubImpl$Variables$Query$discoverSeries<TRes>
    implements CopyWith$Variables$Query$discoverSeries<TRes> {
  _CopyWithStubImpl$Variables$Query$discoverSeries(this._res);

  TRes _res;

  call({String? libraryId, int? limit}) => _res;
}

class Query$discoverSeries {
  Query$discoverSeries({this.libraryById, this.$__typename = 'Query'});

  factory Query$discoverSeries.fromJson(Map<String, dynamic> json) {
    final l$libraryById = json['libraryById'];
    final l$$__typename = json['__typename'];
    return Query$discoverSeries(
      libraryById: l$libraryById == null
          ? null
          : Query$discoverSeries$libraryById.fromJson(
              (l$libraryById as Map<String, dynamic>),
            ),
      $__typename: (l$$__typename as String),
    );
  }

  final Query$discoverSeries$libraryById? libraryById;

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
    if (other is! Query$discoverSeries || runtimeType != other.runtimeType) {
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

extension UtilityExtension$Query$discoverSeries on Query$discoverSeries {
  CopyWith$Query$discoverSeries<Query$discoverSeries> get copyWith =>
      CopyWith$Query$discoverSeries(this, (i) => i);
}

abstract class CopyWith$Query$discoverSeries<TRes> {
  factory CopyWith$Query$discoverSeries(
    Query$discoverSeries instance,
    TRes Function(Query$discoverSeries) then,
  ) = _CopyWithImpl$Query$discoverSeries;

  factory CopyWith$Query$discoverSeries.stub(TRes res) =
      _CopyWithStubImpl$Query$discoverSeries;

  TRes call({
    Query$discoverSeries$libraryById? libraryById,
    String? $__typename,
  });
  CopyWith$Query$discoverSeries$libraryById<TRes> get libraryById;
}

class _CopyWithImpl$Query$discoverSeries<TRes>
    implements CopyWith$Query$discoverSeries<TRes> {
  _CopyWithImpl$Query$discoverSeries(this._instance, this._then);

  final Query$discoverSeries _instance;

  final TRes Function(Query$discoverSeries) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? libraryById = _undefined,
    Object? $__typename = _undefined,
  }) => _then(
    Query$discoverSeries(
      libraryById: libraryById == _undefined
          ? _instance.libraryById
          : (libraryById as Query$discoverSeries$libraryById?),
      $__typename: $__typename == _undefined || $__typename == null
          ? _instance.$__typename
          : ($__typename as String),
    ),
  );

  CopyWith$Query$discoverSeries$libraryById<TRes> get libraryById {
    final local$libraryById = _instance.libraryById;
    return local$libraryById == null
        ? CopyWith$Query$discoverSeries$libraryById.stub(_then(_instance))
        : CopyWith$Query$discoverSeries$libraryById(
            local$libraryById,
            (e) => call(libraryById: e),
          );
  }
}

class _CopyWithStubImpl$Query$discoverSeries<TRes>
    implements CopyWith$Query$discoverSeries<TRes> {
  _CopyWithStubImpl$Query$discoverSeries(this._res);

  TRes _res;

  call({Query$discoverSeries$libraryById? libraryById, String? $__typename}) =>
      _res;

  CopyWith$Query$discoverSeries$libraryById<TRes> get libraryById =>
      CopyWith$Query$discoverSeries$libraryById.stub(_res);
}

const documentNodeQuerydiscoverSeries = DocumentNode(
  definitions: [
    OperationDefinitionNode(
      type: OperationType.query,
      name: NameNode(value: 'discoverSeries'),
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
                  name: NameNode(value: 'recentlyReadSeries'),
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
                        name: NameNode(value: 'fragmentSeries'),
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
    fragmentDefinitionfragmentSeries,
    fragmentDefinitionfragmentImages,
    fragmentDefinitionfragmentMetadata,
  ],
);

class Query$discoverSeries$libraryById {
  Query$discoverSeries$libraryById({
    required this.id,
    required this.recentlyReadSeries,
    this.$__typename = 'Library',
  });

  factory Query$discoverSeries$libraryById.fromJson(Map<String, dynamic> json) {
    final l$id = json['id'];
    final l$recentlyReadSeries = json['recentlyReadSeries'];
    final l$$__typename = json['__typename'];
    return Query$discoverSeries$libraryById(
      id: (l$id as String),
      recentlyReadSeries: (l$recentlyReadSeries as List<dynamic>)
          .map(
            (e) =>
                Fragment$fragmentSeries.fromJson((e as Map<String, dynamic>)),
          )
          .toList(),
      $__typename: (l$$__typename as String),
    );
  }

  final String id;

  final List<Fragment$fragmentSeries> recentlyReadSeries;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$id = id;
    _resultData['id'] = l$id;
    final l$recentlyReadSeries = recentlyReadSeries;
    _resultData['recentlyReadSeries'] = l$recentlyReadSeries
        .map((e) => e.toJson())
        .toList();
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$id = id;
    final l$recentlyReadSeries = recentlyReadSeries;
    final l$$__typename = $__typename;
    return Object.hashAll([
      l$id,
      Object.hashAll(l$recentlyReadSeries.map((v) => v)),
      l$$__typename,
    ]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Query$discoverSeries$libraryById ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$id = id;
    final lOther$id = other.id;
    if (l$id != lOther$id) {
      return false;
    }
    final l$recentlyReadSeries = recentlyReadSeries;
    final lOther$recentlyReadSeries = other.recentlyReadSeries;
    if (l$recentlyReadSeries.length != lOther$recentlyReadSeries.length) {
      return false;
    }
    for (int i = 0; i < l$recentlyReadSeries.length; i++) {
      final l$recentlyReadSeries$entry = l$recentlyReadSeries[i];
      final lOther$recentlyReadSeries$entry = lOther$recentlyReadSeries[i];
      if (l$recentlyReadSeries$entry != lOther$recentlyReadSeries$entry) {
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

extension UtilityExtension$Query$discoverSeries$libraryById
    on Query$discoverSeries$libraryById {
  CopyWith$Query$discoverSeries$libraryById<Query$discoverSeries$libraryById>
  get copyWith => CopyWith$Query$discoverSeries$libraryById(this, (i) => i);
}

abstract class CopyWith$Query$discoverSeries$libraryById<TRes> {
  factory CopyWith$Query$discoverSeries$libraryById(
    Query$discoverSeries$libraryById instance,
    TRes Function(Query$discoverSeries$libraryById) then,
  ) = _CopyWithImpl$Query$discoverSeries$libraryById;

  factory CopyWith$Query$discoverSeries$libraryById.stub(TRes res) =
      _CopyWithStubImpl$Query$discoverSeries$libraryById;

  TRes call({
    String? id,
    List<Fragment$fragmentSeries>? recentlyReadSeries,
    String? $__typename,
  });
  TRes recentlyReadSeries(
    Iterable<Fragment$fragmentSeries> Function(
      Iterable<CopyWith$Fragment$fragmentSeries<Fragment$fragmentSeries>>,
    )
    _fn,
  );
}

class _CopyWithImpl$Query$discoverSeries$libraryById<TRes>
    implements CopyWith$Query$discoverSeries$libraryById<TRes> {
  _CopyWithImpl$Query$discoverSeries$libraryById(this._instance, this._then);

  final Query$discoverSeries$libraryById _instance;

  final TRes Function(Query$discoverSeries$libraryById) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? id = _undefined,
    Object? recentlyReadSeries = _undefined,
    Object? $__typename = _undefined,
  }) => _then(
    Query$discoverSeries$libraryById(
      id: id == _undefined || id == null ? _instance.id : (id as String),
      recentlyReadSeries:
          recentlyReadSeries == _undefined || recentlyReadSeries == null
          ? _instance.recentlyReadSeries
          : (recentlyReadSeries as List<Fragment$fragmentSeries>),
      $__typename: $__typename == _undefined || $__typename == null
          ? _instance.$__typename
          : ($__typename as String),
    ),
  );

  TRes recentlyReadSeries(
    Iterable<Fragment$fragmentSeries> Function(
      Iterable<CopyWith$Fragment$fragmentSeries<Fragment$fragmentSeries>>,
    )
    _fn,
  ) => call(
    recentlyReadSeries: _fn(
      _instance.recentlyReadSeries.map(
        (e) => CopyWith$Fragment$fragmentSeries(e, (i) => i),
      ),
    ).toList(),
  );
}

class _CopyWithStubImpl$Query$discoverSeries$libraryById<TRes>
    implements CopyWith$Query$discoverSeries$libraryById<TRes> {
  _CopyWithStubImpl$Query$discoverSeries$libraryById(this._res);

  TRes _res;

  call({
    String? id,
    List<Fragment$fragmentSeries>? recentlyReadSeries,
    String? $__typename,
  }) => _res;

  recentlyReadSeries(_fn) => _res;
}

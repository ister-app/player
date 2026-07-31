import 'fragmentImages.graphql.dart';
import 'fragmentMetadata.graphql.dart';
import 'fragmentSeries.graphql.dart';
import 'package:gql/ast.dart';
import 'schema.graphql.dart';

class Variables$Query$rankedSeries {
  factory Variables$Query$rankedSeries({
    required String libraryId,
    required Enum$RankKind kind,
    int? page,
    int? size,
  }) => Variables$Query$rankedSeries._({
    r'libraryId': libraryId,
    r'kind': kind,
    if (page != null) r'page': page,
    if (size != null) r'size': size,
  });

  Variables$Query$rankedSeries._(this._$data);

  factory Variables$Query$rankedSeries.fromJson(Map<String, dynamic> data) {
    final result$data = <String, dynamic>{};
    final l$libraryId = data['libraryId'];
    result$data['libraryId'] = (l$libraryId as String);
    final l$kind = data['kind'];
    result$data['kind'] = fromJson$Enum$RankKind((l$kind as String));
    if (data.containsKey('page')) {
      final l$page = data['page'];
      result$data['page'] = (l$page as int?);
    }
    if (data.containsKey('size')) {
      final l$size = data['size'];
      result$data['size'] = (l$size as int?);
    }
    return Variables$Query$rankedSeries._(result$data);
  }

  Map<String, dynamic> _$data;

  String get libraryId => (_$data['libraryId'] as String);

  Enum$RankKind get kind => (_$data['kind'] as Enum$RankKind);

  int? get page => (_$data['page'] as int?);

  int? get size => (_$data['size'] as int?);

  Map<String, dynamic> toJson() {
    final result$data = <String, dynamic>{};
    final l$libraryId = libraryId;
    result$data['libraryId'] = l$libraryId;
    final l$kind = kind;
    result$data['kind'] = toJson$Enum$RankKind(l$kind);
    if (_$data.containsKey('page')) {
      final l$page = page;
      result$data['page'] = l$page;
    }
    if (_$data.containsKey('size')) {
      final l$size = size;
      result$data['size'] = l$size;
    }
    return result$data;
  }

  CopyWith$Variables$Query$rankedSeries<Variables$Query$rankedSeries>
  get copyWith => CopyWith$Variables$Query$rankedSeries(this, (i) => i);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Variables$Query$rankedSeries ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$libraryId = libraryId;
    final lOther$libraryId = other.libraryId;
    if (l$libraryId != lOther$libraryId) {
      return false;
    }
    final l$kind = kind;
    final lOther$kind = other.kind;
    if (l$kind != lOther$kind) {
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
    return true;
  }

  @override
  int get hashCode {
    final l$libraryId = libraryId;
    final l$kind = kind;
    final l$page = page;
    final l$size = size;
    return Object.hashAll([
      l$libraryId,
      l$kind,
      _$data.containsKey('page') ? l$page : const {},
      _$data.containsKey('size') ? l$size : const {},
    ]);
  }
}

abstract class CopyWith$Variables$Query$rankedSeries<TRes> {
  factory CopyWith$Variables$Query$rankedSeries(
    Variables$Query$rankedSeries instance,
    TRes Function(Variables$Query$rankedSeries) then,
  ) = _CopyWithImpl$Variables$Query$rankedSeries;

  factory CopyWith$Variables$Query$rankedSeries.stub(TRes res) =
      _CopyWithStubImpl$Variables$Query$rankedSeries;

  TRes call({String? libraryId, Enum$RankKind? kind, int? page, int? size});
}

class _CopyWithImpl$Variables$Query$rankedSeries<TRes>
    implements CopyWith$Variables$Query$rankedSeries<TRes> {
  _CopyWithImpl$Variables$Query$rankedSeries(this._instance, this._then);

  final Variables$Query$rankedSeries _instance;

  final TRes Function(Variables$Query$rankedSeries) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? libraryId = _undefined,
    Object? kind = _undefined,
    Object? page = _undefined,
    Object? size = _undefined,
  }) => _then(
    Variables$Query$rankedSeries._({
      ..._instance._$data,
      if (libraryId != _undefined && libraryId != null)
        'libraryId': (libraryId as String),
      if (kind != _undefined && kind != null) 'kind': (kind as Enum$RankKind),
      if (page != _undefined) 'page': (page as int?),
      if (size != _undefined) 'size': (size as int?),
    }),
  );
}

class _CopyWithStubImpl$Variables$Query$rankedSeries<TRes>
    implements CopyWith$Variables$Query$rankedSeries<TRes> {
  _CopyWithStubImpl$Variables$Query$rankedSeries(this._res);

  TRes _res;

  call({String? libraryId, Enum$RankKind? kind, int? page, int? size}) => _res;
}

class Query$rankedSeries {
  Query$rankedSeries({this.libraryById, this.$__typename = 'Query'});

  factory Query$rankedSeries.fromJson(Map<String, dynamic> json) {
    final l$libraryById = json['libraryById'];
    final l$$__typename = json['__typename'];
    return Query$rankedSeries(
      libraryById: l$libraryById == null
          ? null
          : Query$rankedSeries$libraryById.fromJson(
              (l$libraryById as Map<String, dynamic>),
            ),
      $__typename: (l$$__typename as String),
    );
  }

  final Query$rankedSeries$libraryById? libraryById;

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
    if (other is! Query$rankedSeries || runtimeType != other.runtimeType) {
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

extension UtilityExtension$Query$rankedSeries on Query$rankedSeries {
  CopyWith$Query$rankedSeries<Query$rankedSeries> get copyWith =>
      CopyWith$Query$rankedSeries(this, (i) => i);
}

abstract class CopyWith$Query$rankedSeries<TRes> {
  factory CopyWith$Query$rankedSeries(
    Query$rankedSeries instance,
    TRes Function(Query$rankedSeries) then,
  ) = _CopyWithImpl$Query$rankedSeries;

  factory CopyWith$Query$rankedSeries.stub(TRes res) =
      _CopyWithStubImpl$Query$rankedSeries;

  TRes call({Query$rankedSeries$libraryById? libraryById, String? $__typename});
  CopyWith$Query$rankedSeries$libraryById<TRes> get libraryById;
}

class _CopyWithImpl$Query$rankedSeries<TRes>
    implements CopyWith$Query$rankedSeries<TRes> {
  _CopyWithImpl$Query$rankedSeries(this._instance, this._then);

  final Query$rankedSeries _instance;

  final TRes Function(Query$rankedSeries) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? libraryById = _undefined,
    Object? $__typename = _undefined,
  }) => _then(
    Query$rankedSeries(
      libraryById: libraryById == _undefined
          ? _instance.libraryById
          : (libraryById as Query$rankedSeries$libraryById?),
      $__typename: $__typename == _undefined || $__typename == null
          ? _instance.$__typename
          : ($__typename as String),
    ),
  );

  CopyWith$Query$rankedSeries$libraryById<TRes> get libraryById {
    final local$libraryById = _instance.libraryById;
    return local$libraryById == null
        ? CopyWith$Query$rankedSeries$libraryById.stub(_then(_instance))
        : CopyWith$Query$rankedSeries$libraryById(
            local$libraryById,
            (e) => call(libraryById: e),
          );
  }
}

class _CopyWithStubImpl$Query$rankedSeries<TRes>
    implements CopyWith$Query$rankedSeries<TRes> {
  _CopyWithStubImpl$Query$rankedSeries(this._res);

  TRes _res;

  call({Query$rankedSeries$libraryById? libraryById, String? $__typename}) =>
      _res;

  CopyWith$Query$rankedSeries$libraryById<TRes> get libraryById =>
      CopyWith$Query$rankedSeries$libraryById.stub(_res);
}

const documentNodeQueryrankedSeries = DocumentNode(
  definitions: [
    OperationDefinitionNode(
      type: OperationType.query,
      name: NameNode(value: 'rankedSeries'),
      variableDefinitions: [
        VariableDefinitionNode(
          variable: VariableNode(name: NameNode(value: 'libraryId')),
          type: NamedTypeNode(name: NameNode(value: 'ID'), isNonNull: true),
          defaultValue: DefaultValueNode(value: null),
          directives: [],
        ),
        VariableDefinitionNode(
          variable: VariableNode(name: NameNode(value: 'kind')),
          type: NamedTypeNode(
            name: NameNode(value: 'RankKind'),
            isNonNull: true,
          ),
          defaultValue: DefaultValueNode(value: null),
          directives: [],
        ),
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
                  name: NameNode(value: 'rankedSeries'),
                  alias: null,
                  arguments: [
                    ArgumentNode(
                      name: NameNode(value: 'kind'),
                      value: VariableNode(name: NameNode(value: 'kind')),
                    ),
                    ArgumentNode(
                      name: NameNode(value: 'page'),
                      value: VariableNode(name: NameNode(value: 'page')),
                    ),
                    ArgumentNode(
                      name: NameNode(value: 'size'),
                      value: VariableNode(name: NameNode(value: 'size')),
                    ),
                  ],
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
                        name: NameNode(value: 'size'),
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
                        name: NameNode(value: 'totalPages'),
                        alias: null,
                        arguments: [],
                        directives: [],
                        selectionSet: null,
                      ),
                      FieldNode(
                        name: NameNode(value: 'content'),
                        alias: null,
                        arguments: [],
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

class Query$rankedSeries$libraryById {
  Query$rankedSeries$libraryById({
    required this.id,
    required this.rankedSeries,
    this.$__typename = 'Library',
  });

  factory Query$rankedSeries$libraryById.fromJson(Map<String, dynamic> json) {
    final l$id = json['id'];
    final l$rankedSeries = json['rankedSeries'];
    final l$$__typename = json['__typename'];
    return Query$rankedSeries$libraryById(
      id: (l$id as String),
      rankedSeries: Query$rankedSeries$libraryById$rankedSeries.fromJson(
        (l$rankedSeries as Map<String, dynamic>),
      ),
      $__typename: (l$$__typename as String),
    );
  }

  final String id;

  final Query$rankedSeries$libraryById$rankedSeries rankedSeries;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$id = id;
    _resultData['id'] = l$id;
    final l$rankedSeries = rankedSeries;
    _resultData['rankedSeries'] = l$rankedSeries.toJson();
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$id = id;
    final l$rankedSeries = rankedSeries;
    final l$$__typename = $__typename;
    return Object.hashAll([l$id, l$rankedSeries, l$$__typename]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Query$rankedSeries$libraryById ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$id = id;
    final lOther$id = other.id;
    if (l$id != lOther$id) {
      return false;
    }
    final l$rankedSeries = rankedSeries;
    final lOther$rankedSeries = other.rankedSeries;
    if (l$rankedSeries != lOther$rankedSeries) {
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

extension UtilityExtension$Query$rankedSeries$libraryById
    on Query$rankedSeries$libraryById {
  CopyWith$Query$rankedSeries$libraryById<Query$rankedSeries$libraryById>
  get copyWith => CopyWith$Query$rankedSeries$libraryById(this, (i) => i);
}

abstract class CopyWith$Query$rankedSeries$libraryById<TRes> {
  factory CopyWith$Query$rankedSeries$libraryById(
    Query$rankedSeries$libraryById instance,
    TRes Function(Query$rankedSeries$libraryById) then,
  ) = _CopyWithImpl$Query$rankedSeries$libraryById;

  factory CopyWith$Query$rankedSeries$libraryById.stub(TRes res) =
      _CopyWithStubImpl$Query$rankedSeries$libraryById;

  TRes call({
    String? id,
    Query$rankedSeries$libraryById$rankedSeries? rankedSeries,
    String? $__typename,
  });
  CopyWith$Query$rankedSeries$libraryById$rankedSeries<TRes> get rankedSeries;
}

class _CopyWithImpl$Query$rankedSeries$libraryById<TRes>
    implements CopyWith$Query$rankedSeries$libraryById<TRes> {
  _CopyWithImpl$Query$rankedSeries$libraryById(this._instance, this._then);

  final Query$rankedSeries$libraryById _instance;

  final TRes Function(Query$rankedSeries$libraryById) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? id = _undefined,
    Object? rankedSeries = _undefined,
    Object? $__typename = _undefined,
  }) => _then(
    Query$rankedSeries$libraryById(
      id: id == _undefined || id == null ? _instance.id : (id as String),
      rankedSeries: rankedSeries == _undefined || rankedSeries == null
          ? _instance.rankedSeries
          : (rankedSeries as Query$rankedSeries$libraryById$rankedSeries),
      $__typename: $__typename == _undefined || $__typename == null
          ? _instance.$__typename
          : ($__typename as String),
    ),
  );

  CopyWith$Query$rankedSeries$libraryById$rankedSeries<TRes> get rankedSeries {
    final local$rankedSeries = _instance.rankedSeries;
    return CopyWith$Query$rankedSeries$libraryById$rankedSeries(
      local$rankedSeries,
      (e) => call(rankedSeries: e),
    );
  }
}

class _CopyWithStubImpl$Query$rankedSeries$libraryById<TRes>
    implements CopyWith$Query$rankedSeries$libraryById<TRes> {
  _CopyWithStubImpl$Query$rankedSeries$libraryById(this._res);

  TRes _res;

  call({
    String? id,
    Query$rankedSeries$libraryById$rankedSeries? rankedSeries,
    String? $__typename,
  }) => _res;

  CopyWith$Query$rankedSeries$libraryById$rankedSeries<TRes> get rankedSeries =>
      CopyWith$Query$rankedSeries$libraryById$rankedSeries.stub(_res);
}

class Query$rankedSeries$libraryById$rankedSeries {
  Query$rankedSeries$libraryById$rankedSeries({
    required this.number,
    required this.size,
    required this.totalElements,
    required this.totalPages,
    required this.content,
    this.$__typename = 'SeriesPage',
  });

  factory Query$rankedSeries$libraryById$rankedSeries.fromJson(
    Map<String, dynamic> json,
  ) {
    final l$number = json['number'];
    final l$size = json['size'];
    final l$totalElements = json['totalElements'];
    final l$totalPages = json['totalPages'];
    final l$content = json['content'];
    final l$$__typename = json['__typename'];
    return Query$rankedSeries$libraryById$rankedSeries(
      number: (l$number as int),
      size: (l$size as int),
      totalElements: (l$totalElements as int),
      totalPages: (l$totalPages as int),
      content: (l$content as List<dynamic>)
          .map(
            (e) =>
                Fragment$fragmentSeries.fromJson((e as Map<String, dynamic>)),
          )
          .toList(),
      $__typename: (l$$__typename as String),
    );
  }

  final int number;

  final int size;

  final int totalElements;

  final int totalPages;

  final List<Fragment$fragmentSeries> content;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$number = number;
    _resultData['number'] = l$number;
    final l$size = size;
    _resultData['size'] = l$size;
    final l$totalElements = totalElements;
    _resultData['totalElements'] = l$totalElements;
    final l$totalPages = totalPages;
    _resultData['totalPages'] = l$totalPages;
    final l$content = content;
    _resultData['content'] = l$content.map((e) => e.toJson()).toList();
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$number = number;
    final l$size = size;
    final l$totalElements = totalElements;
    final l$totalPages = totalPages;
    final l$content = content;
    final l$$__typename = $__typename;
    return Object.hashAll([
      l$number,
      l$size,
      l$totalElements,
      l$totalPages,
      Object.hashAll(l$content.map((v) => v)),
      l$$__typename,
    ]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Query$rankedSeries$libraryById$rankedSeries ||
        runtimeType != other.runtimeType) {
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
    final l$totalElements = totalElements;
    final lOther$totalElements = other.totalElements;
    if (l$totalElements != lOther$totalElements) {
      return false;
    }
    final l$totalPages = totalPages;
    final lOther$totalPages = other.totalPages;
    if (l$totalPages != lOther$totalPages) {
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
    final l$$__typename = $__typename;
    final lOther$$__typename = other.$__typename;
    if (l$$__typename != lOther$$__typename) {
      return false;
    }
    return true;
  }
}

extension UtilityExtension$Query$rankedSeries$libraryById$rankedSeries
    on Query$rankedSeries$libraryById$rankedSeries {
  CopyWith$Query$rankedSeries$libraryById$rankedSeries<
    Query$rankedSeries$libraryById$rankedSeries
  >
  get copyWith =>
      CopyWith$Query$rankedSeries$libraryById$rankedSeries(this, (i) => i);
}

abstract class CopyWith$Query$rankedSeries$libraryById$rankedSeries<TRes> {
  factory CopyWith$Query$rankedSeries$libraryById$rankedSeries(
    Query$rankedSeries$libraryById$rankedSeries instance,
    TRes Function(Query$rankedSeries$libraryById$rankedSeries) then,
  ) = _CopyWithImpl$Query$rankedSeries$libraryById$rankedSeries;

  factory CopyWith$Query$rankedSeries$libraryById$rankedSeries.stub(TRes res) =
      _CopyWithStubImpl$Query$rankedSeries$libraryById$rankedSeries;

  TRes call({
    int? number,
    int? size,
    int? totalElements,
    int? totalPages,
    List<Fragment$fragmentSeries>? content,
    String? $__typename,
  });
  TRes content(
    Iterable<Fragment$fragmentSeries> Function(
      Iterable<CopyWith$Fragment$fragmentSeries<Fragment$fragmentSeries>>,
    )
    _fn,
  );
}

class _CopyWithImpl$Query$rankedSeries$libraryById$rankedSeries<TRes>
    implements CopyWith$Query$rankedSeries$libraryById$rankedSeries<TRes> {
  _CopyWithImpl$Query$rankedSeries$libraryById$rankedSeries(
    this._instance,
    this._then,
  );

  final Query$rankedSeries$libraryById$rankedSeries _instance;

  final TRes Function(Query$rankedSeries$libraryById$rankedSeries) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? number = _undefined,
    Object? size = _undefined,
    Object? totalElements = _undefined,
    Object? totalPages = _undefined,
    Object? content = _undefined,
    Object? $__typename = _undefined,
  }) => _then(
    Query$rankedSeries$libraryById$rankedSeries(
      number: number == _undefined || number == null
          ? _instance.number
          : (number as int),
      size: size == _undefined || size == null ? _instance.size : (size as int),
      totalElements: totalElements == _undefined || totalElements == null
          ? _instance.totalElements
          : (totalElements as int),
      totalPages: totalPages == _undefined || totalPages == null
          ? _instance.totalPages
          : (totalPages as int),
      content: content == _undefined || content == null
          ? _instance.content
          : (content as List<Fragment$fragmentSeries>),
      $__typename: $__typename == _undefined || $__typename == null
          ? _instance.$__typename
          : ($__typename as String),
    ),
  );

  TRes content(
    Iterable<Fragment$fragmentSeries> Function(
      Iterable<CopyWith$Fragment$fragmentSeries<Fragment$fragmentSeries>>,
    )
    _fn,
  ) => call(
    content: _fn(
      _instance.content.map(
        (e) => CopyWith$Fragment$fragmentSeries(e, (i) => i),
      ),
    ).toList(),
  );
}

class _CopyWithStubImpl$Query$rankedSeries$libraryById$rankedSeries<TRes>
    implements CopyWith$Query$rankedSeries$libraryById$rankedSeries<TRes> {
  _CopyWithStubImpl$Query$rankedSeries$libraryById$rankedSeries(this._res);

  TRes _res;

  call({
    int? number,
    int? size,
    int? totalElements,
    int? totalPages,
    List<Fragment$fragmentSeries>? content,
    String? $__typename,
  }) => _res;

  content(_fn) => _res;
}

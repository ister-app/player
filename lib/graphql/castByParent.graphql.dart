import 'fragmentCredit.graphql.dart';
import 'fragmentImages.graphql.dart';
import 'package:gql/ast.dart';

class Variables$Query$castByParent {
  factory Variables$Query$castByParent({
    String? showId,
    String? movieId,
    String? episodeId,
    int? page,
    int? size,
  }) => Variables$Query$castByParent._({
    if (showId != null) r'showId': showId,
    if (movieId != null) r'movieId': movieId,
    if (episodeId != null) r'episodeId': episodeId,
    if (page != null) r'page': page,
    if (size != null) r'size': size,
  });

  Variables$Query$castByParent._(this._$data);

  factory Variables$Query$castByParent.fromJson(Map<String, dynamic> data) {
    final result$data = <String, dynamic>{};
    if (data.containsKey('showId')) {
      final l$showId = data['showId'];
      result$data['showId'] = (l$showId as String?);
    }
    if (data.containsKey('movieId')) {
      final l$movieId = data['movieId'];
      result$data['movieId'] = (l$movieId as String?);
    }
    if (data.containsKey('episodeId')) {
      final l$episodeId = data['episodeId'];
      result$data['episodeId'] = (l$episodeId as String?);
    }
    if (data.containsKey('page')) {
      final l$page = data['page'];
      result$data['page'] = (l$page as int?);
    }
    if (data.containsKey('size')) {
      final l$size = data['size'];
      result$data['size'] = (l$size as int?);
    }
    return Variables$Query$castByParent._(result$data);
  }

  Map<String, dynamic> _$data;

  String? get showId => (_$data['showId'] as String?);

  String? get movieId => (_$data['movieId'] as String?);

  String? get episodeId => (_$data['episodeId'] as String?);

  int? get page => (_$data['page'] as int?);

  int? get size => (_$data['size'] as int?);

  Map<String, dynamic> toJson() {
    final result$data = <String, dynamic>{};
    if (_$data.containsKey('showId')) {
      final l$showId = showId;
      result$data['showId'] = l$showId;
    }
    if (_$data.containsKey('movieId')) {
      final l$movieId = movieId;
      result$data['movieId'] = l$movieId;
    }
    if (_$data.containsKey('episodeId')) {
      final l$episodeId = episodeId;
      result$data['episodeId'] = l$episodeId;
    }
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

  CopyWith$Variables$Query$castByParent<Variables$Query$castByParent>
  get copyWith => CopyWith$Variables$Query$castByParent(this, (i) => i);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Variables$Query$castByParent ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$showId = showId;
    final lOther$showId = other.showId;
    if (_$data.containsKey('showId') != other._$data.containsKey('showId')) {
      return false;
    }
    if (l$showId != lOther$showId) {
      return false;
    }
    final l$movieId = movieId;
    final lOther$movieId = other.movieId;
    if (_$data.containsKey('movieId') != other._$data.containsKey('movieId')) {
      return false;
    }
    if (l$movieId != lOther$movieId) {
      return false;
    }
    final l$episodeId = episodeId;
    final lOther$episodeId = other.episodeId;
    if (_$data.containsKey('episodeId') !=
        other._$data.containsKey('episodeId')) {
      return false;
    }
    if (l$episodeId != lOther$episodeId) {
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
    final l$showId = showId;
    final l$movieId = movieId;
    final l$episodeId = episodeId;
    final l$page = page;
    final l$size = size;
    return Object.hashAll([
      _$data.containsKey('showId') ? l$showId : const {},
      _$data.containsKey('movieId') ? l$movieId : const {},
      _$data.containsKey('episodeId') ? l$episodeId : const {},
      _$data.containsKey('page') ? l$page : const {},
      _$data.containsKey('size') ? l$size : const {},
    ]);
  }
}

abstract class CopyWith$Variables$Query$castByParent<TRes> {
  factory CopyWith$Variables$Query$castByParent(
    Variables$Query$castByParent instance,
    TRes Function(Variables$Query$castByParent) then,
  ) = _CopyWithImpl$Variables$Query$castByParent;

  factory CopyWith$Variables$Query$castByParent.stub(TRes res) =
      _CopyWithStubImpl$Variables$Query$castByParent;

  TRes call({
    String? showId,
    String? movieId,
    String? episodeId,
    int? page,
    int? size,
  });
}

class _CopyWithImpl$Variables$Query$castByParent<TRes>
    implements CopyWith$Variables$Query$castByParent<TRes> {
  _CopyWithImpl$Variables$Query$castByParent(this._instance, this._then);

  final Variables$Query$castByParent _instance;

  final TRes Function(Variables$Query$castByParent) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? showId = _undefined,
    Object? movieId = _undefined,
    Object? episodeId = _undefined,
    Object? page = _undefined,
    Object? size = _undefined,
  }) => _then(
    Variables$Query$castByParent._({
      ..._instance._$data,
      if (showId != _undefined) 'showId': (showId as String?),
      if (movieId != _undefined) 'movieId': (movieId as String?),
      if (episodeId != _undefined) 'episodeId': (episodeId as String?),
      if (page != _undefined) 'page': (page as int?),
      if (size != _undefined) 'size': (size as int?),
    }),
  );
}

class _CopyWithStubImpl$Variables$Query$castByParent<TRes>
    implements CopyWith$Variables$Query$castByParent<TRes> {
  _CopyWithStubImpl$Variables$Query$castByParent(this._res);

  TRes _res;

  call({
    String? showId,
    String? movieId,
    String? episodeId,
    int? page,
    int? size,
  }) => _res;
}

class Query$castByParent {
  Query$castByParent({this.cast, this.$__typename = 'Query'});

  factory Query$castByParent.fromJson(Map<String, dynamic> json) {
    final l$cast = json['cast'];
    final l$$__typename = json['__typename'];
    return Query$castByParent(
      cast: l$cast == null
          ? null
          : Query$castByParent$cast.fromJson((l$cast as Map<String, dynamic>)),
      $__typename: (l$$__typename as String),
    );
  }

  final Query$castByParent$cast? cast;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$cast = cast;
    _resultData['cast'] = l$cast?.toJson();
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$cast = cast;
    final l$$__typename = $__typename;
    return Object.hashAll([l$cast, l$$__typename]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Query$castByParent || runtimeType != other.runtimeType) {
      return false;
    }
    final l$cast = cast;
    final lOther$cast = other.cast;
    if (l$cast != lOther$cast) {
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

extension UtilityExtension$Query$castByParent on Query$castByParent {
  CopyWith$Query$castByParent<Query$castByParent> get copyWith =>
      CopyWith$Query$castByParent(this, (i) => i);
}

abstract class CopyWith$Query$castByParent<TRes> {
  factory CopyWith$Query$castByParent(
    Query$castByParent instance,
    TRes Function(Query$castByParent) then,
  ) = _CopyWithImpl$Query$castByParent;

  factory CopyWith$Query$castByParent.stub(TRes res) =
      _CopyWithStubImpl$Query$castByParent;

  TRes call({Query$castByParent$cast? cast, String? $__typename});
  CopyWith$Query$castByParent$cast<TRes> get cast;
}

class _CopyWithImpl$Query$castByParent<TRes>
    implements CopyWith$Query$castByParent<TRes> {
  _CopyWithImpl$Query$castByParent(this._instance, this._then);

  final Query$castByParent _instance;

  final TRes Function(Query$castByParent) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({Object? cast = _undefined, Object? $__typename = _undefined}) =>
      _then(
        Query$castByParent(
          cast: cast == _undefined
              ? _instance.cast
              : (cast as Query$castByParent$cast?),
          $__typename: $__typename == _undefined || $__typename == null
              ? _instance.$__typename
              : ($__typename as String),
        ),
      );

  CopyWith$Query$castByParent$cast<TRes> get cast {
    final local$cast = _instance.cast;
    return local$cast == null
        ? CopyWith$Query$castByParent$cast.stub(_then(_instance))
        : CopyWith$Query$castByParent$cast(local$cast, (e) => call(cast: e));
  }
}

class _CopyWithStubImpl$Query$castByParent<TRes>
    implements CopyWith$Query$castByParent<TRes> {
  _CopyWithStubImpl$Query$castByParent(this._res);

  TRes _res;

  call({Query$castByParent$cast? cast, String? $__typename}) => _res;

  CopyWith$Query$castByParent$cast<TRes> get cast =>
      CopyWith$Query$castByParent$cast.stub(_res);
}

const documentNodeQuerycastByParent = DocumentNode(
  definitions: [
    OperationDefinitionNode(
      type: OperationType.query,
      name: NameNode(value: 'castByParent'),
      variableDefinitions: [
        VariableDefinitionNode(
          variable: VariableNode(name: NameNode(value: 'showId')),
          type: NamedTypeNode(name: NameNode(value: 'ID'), isNonNull: false),
          defaultValue: DefaultValueNode(value: null),
          directives: [],
        ),
        VariableDefinitionNode(
          variable: VariableNode(name: NameNode(value: 'movieId')),
          type: NamedTypeNode(name: NameNode(value: 'ID'), isNonNull: false),
          defaultValue: DefaultValueNode(value: null),
          directives: [],
        ),
        VariableDefinitionNode(
          variable: VariableNode(name: NameNode(value: 'episodeId')),
          type: NamedTypeNode(name: NameNode(value: 'ID'), isNonNull: false),
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
            name: NameNode(value: 'cast'),
            alias: null,
            arguments: [
              ArgumentNode(
                name: NameNode(value: 'showId'),
                value: VariableNode(name: NameNode(value: 'showId')),
              ),
              ArgumentNode(
                name: NameNode(value: 'movieId'),
                value: VariableNode(name: NameNode(value: 'movieId')),
              ),
              ArgumentNode(
                name: NameNode(value: 'episodeId'),
                value: VariableNode(name: NameNode(value: 'episodeId')),
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
                        name: NameNode(value: 'fragmentCastMember'),
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
    fragmentDefinitionfragmentCastMember,
    fragmentDefinitionfragmentImages,
  ],
);

class Query$castByParent$cast {
  Query$castByParent$cast({
    required this.number,
    required this.size,
    required this.totalElements,
    required this.totalPages,
    required this.content,
    this.$__typename = 'CreditPage',
  });

  factory Query$castByParent$cast.fromJson(Map<String, dynamic> json) {
    final l$number = json['number'];
    final l$size = json['size'];
    final l$totalElements = json['totalElements'];
    final l$totalPages = json['totalPages'];
    final l$content = json['content'];
    final l$$__typename = json['__typename'];
    return Query$castByParent$cast(
      number: (l$number as int),
      size: (l$size as int),
      totalElements: (l$totalElements as int),
      totalPages: (l$totalPages as int),
      content: (l$content as List<dynamic>)
          .map(
            (e) => Fragment$fragmentCastMember.fromJson(
              (e as Map<String, dynamic>),
            ),
          )
          .toList(),
      $__typename: (l$$__typename as String),
    );
  }

  final int number;

  final int size;

  final int totalElements;

  final int totalPages;

  final List<Fragment$fragmentCastMember> content;

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
    if (other is! Query$castByParent$cast || runtimeType != other.runtimeType) {
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

extension UtilityExtension$Query$castByParent$cast on Query$castByParent$cast {
  CopyWith$Query$castByParent$cast<Query$castByParent$cast> get copyWith =>
      CopyWith$Query$castByParent$cast(this, (i) => i);
}

abstract class CopyWith$Query$castByParent$cast<TRes> {
  factory CopyWith$Query$castByParent$cast(
    Query$castByParent$cast instance,
    TRes Function(Query$castByParent$cast) then,
  ) = _CopyWithImpl$Query$castByParent$cast;

  factory CopyWith$Query$castByParent$cast.stub(TRes res) =
      _CopyWithStubImpl$Query$castByParent$cast;

  TRes call({
    int? number,
    int? size,
    int? totalElements,
    int? totalPages,
    List<Fragment$fragmentCastMember>? content,
    String? $__typename,
  });
  TRes content(
    Iterable<Fragment$fragmentCastMember> Function(
      Iterable<
        CopyWith$Fragment$fragmentCastMember<Fragment$fragmentCastMember>
      >,
    )
    _fn,
  );
}

class _CopyWithImpl$Query$castByParent$cast<TRes>
    implements CopyWith$Query$castByParent$cast<TRes> {
  _CopyWithImpl$Query$castByParent$cast(this._instance, this._then);

  final Query$castByParent$cast _instance;

  final TRes Function(Query$castByParent$cast) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? number = _undefined,
    Object? size = _undefined,
    Object? totalElements = _undefined,
    Object? totalPages = _undefined,
    Object? content = _undefined,
    Object? $__typename = _undefined,
  }) => _then(
    Query$castByParent$cast(
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
          : (content as List<Fragment$fragmentCastMember>),
      $__typename: $__typename == _undefined || $__typename == null
          ? _instance.$__typename
          : ($__typename as String),
    ),
  );

  TRes content(
    Iterable<Fragment$fragmentCastMember> Function(
      Iterable<
        CopyWith$Fragment$fragmentCastMember<Fragment$fragmentCastMember>
      >,
    )
    _fn,
  ) => call(
    content: _fn(
      _instance.content.map(
        (e) => CopyWith$Fragment$fragmentCastMember(e, (i) => i),
      ),
    ).toList(),
  );
}

class _CopyWithStubImpl$Query$castByParent$cast<TRes>
    implements CopyWith$Query$castByParent$cast<TRes> {
  _CopyWithStubImpl$Query$castByParent$cast(this._res);

  TRes _res;

  call({
    int? number,
    int? size,
    int? totalElements,
    int? totalPages,
    List<Fragment$fragmentCastMember>? content,
    String? $__typename,
  }) => _res;

  content(_fn) => _res;
}

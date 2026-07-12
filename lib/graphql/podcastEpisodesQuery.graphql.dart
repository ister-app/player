import 'fragmentMediafiles.graphql.dart';
import 'fragmentMetadata.graphql.dart';
import 'fragmentPodcastEpisode.graphql.dart';
import 'package:gql/ast.dart';

class Variables$Query$podcastEpisodes {
  factory Variables$Query$podcastEpisodes({
    required String podcastId,
    int? page,
    int? size,
  }) => Variables$Query$podcastEpisodes._({
    r'podcastId': podcastId,
    if (page != null) r'page': page,
    if (size != null) r'size': size,
  });

  Variables$Query$podcastEpisodes._(this._$data);

  factory Variables$Query$podcastEpisodes.fromJson(Map<String, dynamic> data) {
    final result$data = <String, dynamic>{};
    final l$podcastId = data['podcastId'];
    result$data['podcastId'] = (l$podcastId as String);
    if (data.containsKey('page')) {
      final l$page = data['page'];
      result$data['page'] = (l$page as int?);
    }
    if (data.containsKey('size')) {
      final l$size = data['size'];
      result$data['size'] = (l$size as int?);
    }
    return Variables$Query$podcastEpisodes._(result$data);
  }

  Map<String, dynamic> _$data;

  String get podcastId => (_$data['podcastId'] as String);

  int? get page => (_$data['page'] as int?);

  int? get size => (_$data['size'] as int?);

  Map<String, dynamic> toJson() {
    final result$data = <String, dynamic>{};
    final l$podcastId = podcastId;
    result$data['podcastId'] = l$podcastId;
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

  CopyWith$Variables$Query$podcastEpisodes<Variables$Query$podcastEpisodes>
  get copyWith => CopyWith$Variables$Query$podcastEpisodes(this, (i) => i);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Variables$Query$podcastEpisodes ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$podcastId = podcastId;
    final lOther$podcastId = other.podcastId;
    if (l$podcastId != lOther$podcastId) {
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
    final l$podcastId = podcastId;
    final l$page = page;
    final l$size = size;
    return Object.hashAll([
      l$podcastId,
      _$data.containsKey('page') ? l$page : const {},
      _$data.containsKey('size') ? l$size : const {},
    ]);
  }
}

abstract class CopyWith$Variables$Query$podcastEpisodes<TRes> {
  factory CopyWith$Variables$Query$podcastEpisodes(
    Variables$Query$podcastEpisodes instance,
    TRes Function(Variables$Query$podcastEpisodes) then,
  ) = _CopyWithImpl$Variables$Query$podcastEpisodes;

  factory CopyWith$Variables$Query$podcastEpisodes.stub(TRes res) =
      _CopyWithStubImpl$Variables$Query$podcastEpisodes;

  TRes call({String? podcastId, int? page, int? size});
}

class _CopyWithImpl$Variables$Query$podcastEpisodes<TRes>
    implements CopyWith$Variables$Query$podcastEpisodes<TRes> {
  _CopyWithImpl$Variables$Query$podcastEpisodes(this._instance, this._then);

  final Variables$Query$podcastEpisodes _instance;

  final TRes Function(Variables$Query$podcastEpisodes) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? podcastId = _undefined,
    Object? page = _undefined,
    Object? size = _undefined,
  }) => _then(
    Variables$Query$podcastEpisodes._({
      ..._instance._$data,
      if (podcastId != _undefined && podcastId != null)
        'podcastId': (podcastId as String),
      if (page != _undefined) 'page': (page as int?),
      if (size != _undefined) 'size': (size as int?),
    }),
  );
}

class _CopyWithStubImpl$Variables$Query$podcastEpisodes<TRes>
    implements CopyWith$Variables$Query$podcastEpisodes<TRes> {
  _CopyWithStubImpl$Variables$Query$podcastEpisodes(this._res);

  TRes _res;

  call({String? podcastId, int? page, int? size}) => _res;
}

class Query$podcastEpisodes {
  Query$podcastEpisodes({
    required this.podcastEpisodes,
    this.$__typename = 'Query',
  });

  factory Query$podcastEpisodes.fromJson(Map<String, dynamic> json) {
    final l$podcastEpisodes = json['podcastEpisodes'];
    final l$$__typename = json['__typename'];
    return Query$podcastEpisodes(
      podcastEpisodes: Query$podcastEpisodes$podcastEpisodes.fromJson(
        (l$podcastEpisodes as Map<String, dynamic>),
      ),
      $__typename: (l$$__typename as String),
    );
  }

  final Query$podcastEpisodes$podcastEpisodes podcastEpisodes;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$podcastEpisodes = podcastEpisodes;
    _resultData['podcastEpisodes'] = l$podcastEpisodes.toJson();
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$podcastEpisodes = podcastEpisodes;
    final l$$__typename = $__typename;
    return Object.hashAll([l$podcastEpisodes, l$$__typename]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Query$podcastEpisodes || runtimeType != other.runtimeType) {
      return false;
    }
    final l$podcastEpisodes = podcastEpisodes;
    final lOther$podcastEpisodes = other.podcastEpisodes;
    if (l$podcastEpisodes != lOther$podcastEpisodes) {
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

extension UtilityExtension$Query$podcastEpisodes on Query$podcastEpisodes {
  CopyWith$Query$podcastEpisodes<Query$podcastEpisodes> get copyWith =>
      CopyWith$Query$podcastEpisodes(this, (i) => i);
}

abstract class CopyWith$Query$podcastEpisodes<TRes> {
  factory CopyWith$Query$podcastEpisodes(
    Query$podcastEpisodes instance,
    TRes Function(Query$podcastEpisodes) then,
  ) = _CopyWithImpl$Query$podcastEpisodes;

  factory CopyWith$Query$podcastEpisodes.stub(TRes res) =
      _CopyWithStubImpl$Query$podcastEpisodes;

  TRes call({
    Query$podcastEpisodes$podcastEpisodes? podcastEpisodes,
    String? $__typename,
  });
  CopyWith$Query$podcastEpisodes$podcastEpisodes<TRes> get podcastEpisodes;
}

class _CopyWithImpl$Query$podcastEpisodes<TRes>
    implements CopyWith$Query$podcastEpisodes<TRes> {
  _CopyWithImpl$Query$podcastEpisodes(this._instance, this._then);

  final Query$podcastEpisodes _instance;

  final TRes Function(Query$podcastEpisodes) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? podcastEpisodes = _undefined,
    Object? $__typename = _undefined,
  }) => _then(
    Query$podcastEpisodes(
      podcastEpisodes: podcastEpisodes == _undefined || podcastEpisodes == null
          ? _instance.podcastEpisodes
          : (podcastEpisodes as Query$podcastEpisodes$podcastEpisodes),
      $__typename: $__typename == _undefined || $__typename == null
          ? _instance.$__typename
          : ($__typename as String),
    ),
  );

  CopyWith$Query$podcastEpisodes$podcastEpisodes<TRes> get podcastEpisodes {
    final local$podcastEpisodes = _instance.podcastEpisodes;
    return CopyWith$Query$podcastEpisodes$podcastEpisodes(
      local$podcastEpisodes,
      (e) => call(podcastEpisodes: e),
    );
  }
}

class _CopyWithStubImpl$Query$podcastEpisodes<TRes>
    implements CopyWith$Query$podcastEpisodes<TRes> {
  _CopyWithStubImpl$Query$podcastEpisodes(this._res);

  TRes _res;

  call({
    Query$podcastEpisodes$podcastEpisodes? podcastEpisodes,
    String? $__typename,
  }) => _res;

  CopyWith$Query$podcastEpisodes$podcastEpisodes<TRes> get podcastEpisodes =>
      CopyWith$Query$podcastEpisodes$podcastEpisodes.stub(_res);
}

const documentNodeQuerypodcastEpisodes = DocumentNode(
  definitions: [
    OperationDefinitionNode(
      type: OperationType.query,
      name: NameNode(value: 'podcastEpisodes'),
      variableDefinitions: [
        VariableDefinitionNode(
          variable: VariableNode(name: NameNode(value: 'podcastId')),
          type: NamedTypeNode(name: NameNode(value: 'ID'), isNonNull: true),
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
            name: NameNode(value: 'podcastEpisodes'),
            alias: null,
            arguments: [
              ArgumentNode(
                name: NameNode(value: 'podcastId'),
                value: VariableNode(name: NameNode(value: 'podcastId')),
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
                  name: NameNode(value: 'content'),
                  alias: null,
                  arguments: [],
                  directives: [],
                  selectionSet: SelectionSetNode(
                    selections: [
                      FragmentSpreadNode(
                        name: NameNode(value: 'fragmentPodcastEpisode'),
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
    fragmentDefinitionfragmentPodcastEpisode,
    fragmentDefinitionfragmentMetadata,
    fragmentDefinitionfragmentMediaFiles,
  ],
);

class Query$podcastEpisodes$podcastEpisodes {
  Query$podcastEpisodes$podcastEpisodes({
    required this.content,
    required this.totalPages,
    required this.totalElements,
    required this.number,
    required this.size,
    this.$__typename = 'PodcastEpisodePage',
  });

  factory Query$podcastEpisodes$podcastEpisodes.fromJson(
    Map<String, dynamic> json,
  ) {
    final l$content = json['content'];
    final l$totalPages = json['totalPages'];
    final l$totalElements = json['totalElements'];
    final l$number = json['number'];
    final l$size = json['size'];
    final l$$__typename = json['__typename'];
    return Query$podcastEpisodes$podcastEpisodes(
      content: (l$content as List<dynamic>)
          .map(
            (e) => Fragment$fragmentPodcastEpisode.fromJson(
              (e as Map<String, dynamic>),
            ),
          )
          .toList(),
      totalPages: (l$totalPages as int),
      totalElements: (l$totalElements as int),
      number: (l$number as int),
      size: (l$size as int),
      $__typename: (l$$__typename as String),
    );
  }

  final List<Fragment$fragmentPodcastEpisode> content;

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
    if (other is! Query$podcastEpisodes$podcastEpisodes ||
        runtimeType != other.runtimeType) {
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

extension UtilityExtension$Query$podcastEpisodes$podcastEpisodes
    on Query$podcastEpisodes$podcastEpisodes {
  CopyWith$Query$podcastEpisodes$podcastEpisodes<
    Query$podcastEpisodes$podcastEpisodes
  >
  get copyWith =>
      CopyWith$Query$podcastEpisodes$podcastEpisodes(this, (i) => i);
}

abstract class CopyWith$Query$podcastEpisodes$podcastEpisodes<TRes> {
  factory CopyWith$Query$podcastEpisodes$podcastEpisodes(
    Query$podcastEpisodes$podcastEpisodes instance,
    TRes Function(Query$podcastEpisodes$podcastEpisodes) then,
  ) = _CopyWithImpl$Query$podcastEpisodes$podcastEpisodes;

  factory CopyWith$Query$podcastEpisodes$podcastEpisodes.stub(TRes res) =
      _CopyWithStubImpl$Query$podcastEpisodes$podcastEpisodes;

  TRes call({
    List<Fragment$fragmentPodcastEpisode>? content,
    int? totalPages,
    int? totalElements,
    int? number,
    int? size,
    String? $__typename,
  });
  TRes content(
    Iterable<Fragment$fragmentPodcastEpisode> Function(
      Iterable<
        CopyWith$Fragment$fragmentPodcastEpisode<
          Fragment$fragmentPodcastEpisode
        >
      >,
    )
    _fn,
  );
}

class _CopyWithImpl$Query$podcastEpisodes$podcastEpisodes<TRes>
    implements CopyWith$Query$podcastEpisodes$podcastEpisodes<TRes> {
  _CopyWithImpl$Query$podcastEpisodes$podcastEpisodes(
    this._instance,
    this._then,
  );

  final Query$podcastEpisodes$podcastEpisodes _instance;

  final TRes Function(Query$podcastEpisodes$podcastEpisodes) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? content = _undefined,
    Object? totalPages = _undefined,
    Object? totalElements = _undefined,
    Object? number = _undefined,
    Object? size = _undefined,
    Object? $__typename = _undefined,
  }) => _then(
    Query$podcastEpisodes$podcastEpisodes(
      content: content == _undefined || content == null
          ? _instance.content
          : (content as List<Fragment$fragmentPodcastEpisode>),
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
    Iterable<Fragment$fragmentPodcastEpisode> Function(
      Iterable<
        CopyWith$Fragment$fragmentPodcastEpisode<
          Fragment$fragmentPodcastEpisode
        >
      >,
    )
    _fn,
  ) => call(
    content: _fn(
      _instance.content.map(
        (e) => CopyWith$Fragment$fragmentPodcastEpisode(e, (i) => i),
      ),
    ).toList(),
  );
}

class _CopyWithStubImpl$Query$podcastEpisodes$podcastEpisodes<TRes>
    implements CopyWith$Query$podcastEpisodes$podcastEpisodes<TRes> {
  _CopyWithStubImpl$Query$podcastEpisodes$podcastEpisodes(this._res);

  TRes _res;

  call({
    List<Fragment$fragmentPodcastEpisode>? content,
    int? totalPages,
    int? totalElements,
    int? number,
    int? size,
    String? $__typename,
  }) => _res;

  content(_fn) => _res;
}

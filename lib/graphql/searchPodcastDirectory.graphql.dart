import 'package:gql/ast.dart';

class Variables$Query$searchPodcastDirectory {
  factory Variables$Query$searchPodcastDirectory({required String term}) =>
      Variables$Query$searchPodcastDirectory._({r'term': term});

  Variables$Query$searchPodcastDirectory._(this._$data);

  factory Variables$Query$searchPodcastDirectory.fromJson(
    Map<String, dynamic> data,
  ) {
    final result$data = <String, dynamic>{};
    final l$term = data['term'];
    result$data['term'] = (l$term as String);
    return Variables$Query$searchPodcastDirectory._(result$data);
  }

  Map<String, dynamic> _$data;

  String get term => (_$data['term'] as String);

  Map<String, dynamic> toJson() {
    final result$data = <String, dynamic>{};
    final l$term = term;
    result$data['term'] = l$term;
    return result$data;
  }

  CopyWith$Variables$Query$searchPodcastDirectory<
    Variables$Query$searchPodcastDirectory
  >
  get copyWith =>
      CopyWith$Variables$Query$searchPodcastDirectory(this, (i) => i);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Variables$Query$searchPodcastDirectory ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$term = term;
    final lOther$term = other.term;
    if (l$term != lOther$term) {
      return false;
    }
    return true;
  }

  @override
  int get hashCode {
    final l$term = term;
    return Object.hashAll([l$term]);
  }
}

abstract class CopyWith$Variables$Query$searchPodcastDirectory<TRes> {
  factory CopyWith$Variables$Query$searchPodcastDirectory(
    Variables$Query$searchPodcastDirectory instance,
    TRes Function(Variables$Query$searchPodcastDirectory) then,
  ) = _CopyWithImpl$Variables$Query$searchPodcastDirectory;

  factory CopyWith$Variables$Query$searchPodcastDirectory.stub(TRes res) =
      _CopyWithStubImpl$Variables$Query$searchPodcastDirectory;

  TRes call({String? term});
}

class _CopyWithImpl$Variables$Query$searchPodcastDirectory<TRes>
    implements CopyWith$Variables$Query$searchPodcastDirectory<TRes> {
  _CopyWithImpl$Variables$Query$searchPodcastDirectory(
    this._instance,
    this._then,
  );

  final Variables$Query$searchPodcastDirectory _instance;

  final TRes Function(Variables$Query$searchPodcastDirectory) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({Object? term = _undefined}) => _then(
    Variables$Query$searchPodcastDirectory._({
      ..._instance._$data,
      if (term != _undefined && term != null) 'term': (term as String),
    }),
  );
}

class _CopyWithStubImpl$Variables$Query$searchPodcastDirectory<TRes>
    implements CopyWith$Variables$Query$searchPodcastDirectory<TRes> {
  _CopyWithStubImpl$Variables$Query$searchPodcastDirectory(this._res);

  TRes _res;

  call({String? term}) => _res;
}

class Query$searchPodcastDirectory {
  Query$searchPodcastDirectory({
    required this.searchPodcastDirectory,
    this.$__typename = 'Query',
  });

  factory Query$searchPodcastDirectory.fromJson(Map<String, dynamic> json) {
    final l$searchPodcastDirectory = json['searchPodcastDirectory'];
    final l$$__typename = json['__typename'];
    return Query$searchPodcastDirectory(
      searchPodcastDirectory: (l$searchPodcastDirectory as List<dynamic>)
          .map(
            (e) => Query$searchPodcastDirectory$searchPodcastDirectory.fromJson(
              (e as Map<String, dynamic>),
            ),
          )
          .toList(),
      $__typename: (l$$__typename as String),
    );
  }

  final List<Query$searchPodcastDirectory$searchPodcastDirectory>
  searchPodcastDirectory;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$searchPodcastDirectory = searchPodcastDirectory;
    _resultData['searchPodcastDirectory'] = l$searchPodcastDirectory
        .map((e) => e.toJson())
        .toList();
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$searchPodcastDirectory = searchPodcastDirectory;
    final l$$__typename = $__typename;
    return Object.hashAll([
      Object.hashAll(l$searchPodcastDirectory.map((v) => v)),
      l$$__typename,
    ]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Query$searchPodcastDirectory ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$searchPodcastDirectory = searchPodcastDirectory;
    final lOther$searchPodcastDirectory = other.searchPodcastDirectory;
    if (l$searchPodcastDirectory.length !=
        lOther$searchPodcastDirectory.length) {
      return false;
    }
    for (int i = 0; i < l$searchPodcastDirectory.length; i++) {
      final l$searchPodcastDirectory$entry = l$searchPodcastDirectory[i];
      final lOther$searchPodcastDirectory$entry =
          lOther$searchPodcastDirectory[i];
      if (l$searchPodcastDirectory$entry !=
          lOther$searchPodcastDirectory$entry) {
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

extension UtilityExtension$Query$searchPodcastDirectory
    on Query$searchPodcastDirectory {
  CopyWith$Query$searchPodcastDirectory<Query$searchPodcastDirectory>
  get copyWith => CopyWith$Query$searchPodcastDirectory(this, (i) => i);
}

abstract class CopyWith$Query$searchPodcastDirectory<TRes> {
  factory CopyWith$Query$searchPodcastDirectory(
    Query$searchPodcastDirectory instance,
    TRes Function(Query$searchPodcastDirectory) then,
  ) = _CopyWithImpl$Query$searchPodcastDirectory;

  factory CopyWith$Query$searchPodcastDirectory.stub(TRes res) =
      _CopyWithStubImpl$Query$searchPodcastDirectory;

  TRes call({
    List<Query$searchPodcastDirectory$searchPodcastDirectory>?
    searchPodcastDirectory,
    String? $__typename,
  });
  TRes searchPodcastDirectory(
    Iterable<Query$searchPodcastDirectory$searchPodcastDirectory> Function(
      Iterable<
        CopyWith$Query$searchPodcastDirectory$searchPodcastDirectory<
          Query$searchPodcastDirectory$searchPodcastDirectory
        >
      >,
    )
    _fn,
  );
}

class _CopyWithImpl$Query$searchPodcastDirectory<TRes>
    implements CopyWith$Query$searchPodcastDirectory<TRes> {
  _CopyWithImpl$Query$searchPodcastDirectory(this._instance, this._then);

  final Query$searchPodcastDirectory _instance;

  final TRes Function(Query$searchPodcastDirectory) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? searchPodcastDirectory = _undefined,
    Object? $__typename = _undefined,
  }) => _then(
    Query$searchPodcastDirectory(
      searchPodcastDirectory:
          searchPodcastDirectory == _undefined || searchPodcastDirectory == null
          ? _instance.searchPodcastDirectory
          : (searchPodcastDirectory
                as List<Query$searchPodcastDirectory$searchPodcastDirectory>),
      $__typename: $__typename == _undefined || $__typename == null
          ? _instance.$__typename
          : ($__typename as String),
    ),
  );

  TRes searchPodcastDirectory(
    Iterable<Query$searchPodcastDirectory$searchPodcastDirectory> Function(
      Iterable<
        CopyWith$Query$searchPodcastDirectory$searchPodcastDirectory<
          Query$searchPodcastDirectory$searchPodcastDirectory
        >
      >,
    )
    _fn,
  ) => call(
    searchPodcastDirectory: _fn(
      _instance.searchPodcastDirectory.map(
        (e) => CopyWith$Query$searchPodcastDirectory$searchPodcastDirectory(
          e,
          (i) => i,
        ),
      ),
    ).toList(),
  );
}

class _CopyWithStubImpl$Query$searchPodcastDirectory<TRes>
    implements CopyWith$Query$searchPodcastDirectory<TRes> {
  _CopyWithStubImpl$Query$searchPodcastDirectory(this._res);

  TRes _res;

  call({
    List<Query$searchPodcastDirectory$searchPodcastDirectory>?
    searchPodcastDirectory,
    String? $__typename,
  }) => _res;

  searchPodcastDirectory(_fn) => _res;
}

const documentNodeQuerysearchPodcastDirectory = DocumentNode(
  definitions: [
    OperationDefinitionNode(
      type: OperationType.query,
      name: NameNode(value: 'searchPodcastDirectory'),
      variableDefinitions: [
        VariableDefinitionNode(
          variable: VariableNode(name: NameNode(value: 'term')),
          type: NamedTypeNode(name: NameNode(value: 'String'), isNonNull: true),
          defaultValue: DefaultValueNode(value: null),
          directives: [],
        ),
      ],
      directives: [],
      selectionSet: SelectionSetNode(
        selections: [
          FieldNode(
            name: NameNode(value: 'searchPodcastDirectory'),
            alias: null,
            arguments: [
              ArgumentNode(
                name: NameNode(value: 'term'),
                value: VariableNode(name: NameNode(value: 'term')),
              ),
            ],
            directives: [],
            selectionSet: SelectionSetNode(
              selections: [
                FieldNode(
                  name: NameNode(value: 'name'),
                  alias: null,
                  arguments: [],
                  directives: [],
                  selectionSet: null,
                ),
                FieldNode(
                  name: NameNode(value: 'author'),
                  alias: null,
                  arguments: [],
                  directives: [],
                  selectionSet: null,
                ),
                FieldNode(
                  name: NameNode(value: 'feedUrl'),
                  alias: null,
                  arguments: [],
                  directives: [],
                  selectionSet: null,
                ),
                FieldNode(
                  name: NameNode(value: 'artworkUrl'),
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
  ],
);

class Query$searchPodcastDirectory$searchPodcastDirectory {
  Query$searchPodcastDirectory$searchPodcastDirectory({
    this.name,
    this.author,
    required this.feedUrl,
    this.artworkUrl,
    this.$__typename = 'PodcastDirectoryResult',
  });

  factory Query$searchPodcastDirectory$searchPodcastDirectory.fromJson(
    Map<String, dynamic> json,
  ) {
    final l$name = json['name'];
    final l$author = json['author'];
    final l$feedUrl = json['feedUrl'];
    final l$artworkUrl = json['artworkUrl'];
    final l$$__typename = json['__typename'];
    return Query$searchPodcastDirectory$searchPodcastDirectory(
      name: (l$name as String?),
      author: (l$author as String?),
      feedUrl: (l$feedUrl as String),
      artworkUrl: (l$artworkUrl as String?),
      $__typename: (l$$__typename as String),
    );
  }

  final String? name;

  final String? author;

  final String feedUrl;

  final String? artworkUrl;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$name = name;
    _resultData['name'] = l$name;
    final l$author = author;
    _resultData['author'] = l$author;
    final l$feedUrl = feedUrl;
    _resultData['feedUrl'] = l$feedUrl;
    final l$artworkUrl = artworkUrl;
    _resultData['artworkUrl'] = l$artworkUrl;
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$name = name;
    final l$author = author;
    final l$feedUrl = feedUrl;
    final l$artworkUrl = artworkUrl;
    final l$$__typename = $__typename;
    return Object.hashAll([
      l$name,
      l$author,
      l$feedUrl,
      l$artworkUrl,
      l$$__typename,
    ]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Query$searchPodcastDirectory$searchPodcastDirectory ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$name = name;
    final lOther$name = other.name;
    if (l$name != lOther$name) {
      return false;
    }
    final l$author = author;
    final lOther$author = other.author;
    if (l$author != lOther$author) {
      return false;
    }
    final l$feedUrl = feedUrl;
    final lOther$feedUrl = other.feedUrl;
    if (l$feedUrl != lOther$feedUrl) {
      return false;
    }
    final l$artworkUrl = artworkUrl;
    final lOther$artworkUrl = other.artworkUrl;
    if (l$artworkUrl != lOther$artworkUrl) {
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

extension UtilityExtension$Query$searchPodcastDirectory$searchPodcastDirectory
    on Query$searchPodcastDirectory$searchPodcastDirectory {
  CopyWith$Query$searchPodcastDirectory$searchPodcastDirectory<
    Query$searchPodcastDirectory$searchPodcastDirectory
  >
  get copyWith => CopyWith$Query$searchPodcastDirectory$searchPodcastDirectory(
    this,
    (i) => i,
  );
}

abstract class CopyWith$Query$searchPodcastDirectory$searchPodcastDirectory<
  TRes
> {
  factory CopyWith$Query$searchPodcastDirectory$searchPodcastDirectory(
    Query$searchPodcastDirectory$searchPodcastDirectory instance,
    TRes Function(Query$searchPodcastDirectory$searchPodcastDirectory) then,
  ) = _CopyWithImpl$Query$searchPodcastDirectory$searchPodcastDirectory;

  factory CopyWith$Query$searchPodcastDirectory$searchPodcastDirectory.stub(
    TRes res,
  ) = _CopyWithStubImpl$Query$searchPodcastDirectory$searchPodcastDirectory;

  TRes call({
    String? name,
    String? author,
    String? feedUrl,
    String? artworkUrl,
    String? $__typename,
  });
}

class _CopyWithImpl$Query$searchPodcastDirectory$searchPodcastDirectory<TRes>
    implements
        CopyWith$Query$searchPodcastDirectory$searchPodcastDirectory<TRes> {
  _CopyWithImpl$Query$searchPodcastDirectory$searchPodcastDirectory(
    this._instance,
    this._then,
  );

  final Query$searchPodcastDirectory$searchPodcastDirectory _instance;

  final TRes Function(Query$searchPodcastDirectory$searchPodcastDirectory)
  _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? name = _undefined,
    Object? author = _undefined,
    Object? feedUrl = _undefined,
    Object? artworkUrl = _undefined,
    Object? $__typename = _undefined,
  }) => _then(
    Query$searchPodcastDirectory$searchPodcastDirectory(
      name: name == _undefined ? _instance.name : (name as String?),
      author: author == _undefined ? _instance.author : (author as String?),
      feedUrl: feedUrl == _undefined || feedUrl == null
          ? _instance.feedUrl
          : (feedUrl as String),
      artworkUrl: artworkUrl == _undefined
          ? _instance.artworkUrl
          : (artworkUrl as String?),
      $__typename: $__typename == _undefined || $__typename == null
          ? _instance.$__typename
          : ($__typename as String),
    ),
  );
}

class _CopyWithStubImpl$Query$searchPodcastDirectory$searchPodcastDirectory<
  TRes
>
    implements
        CopyWith$Query$searchPodcastDirectory$searchPodcastDirectory<TRes> {
  _CopyWithStubImpl$Query$searchPodcastDirectory$searchPodcastDirectory(
    this._res,
  );

  TRes _res;

  call({
    String? name,
    String? author,
    String? feedUrl,
    String? artworkUrl,
    String? $__typename,
  }) => _res;
}

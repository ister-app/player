import 'package:gql/ast.dart';

class Fragment$fragmentImages {
  Fragment$fragmentImages({
    required this.type,
    required this.id,
    this.language,
    this.blurHash,
    required this.directory,
    this.$__typename = 'Image',
  });

  factory Fragment$fragmentImages.fromJson(Map<String, dynamic> json) {
    final l$type = json['type'];
    final l$id = json['id'];
    final l$language = json['language'];
    final l$blurHash = json['blurHash'];
    final l$directory = json['directory'];
    final l$$__typename = json['__typename'];
    return Fragment$fragmentImages(
      type: (l$type as String),
      id: (l$id as String),
      language: (l$language as String?),
      blurHash: (l$blurHash as String?),
      directory: Fragment$fragmentImages$directory.fromJson(
        (l$directory as Map<String, dynamic>),
      ),
      $__typename: (l$$__typename as String),
    );
  }

  final String type;

  final String id;

  final String? language;

  final String? blurHash;

  final Fragment$fragmentImages$directory directory;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$type = type;
    _resultData['type'] = l$type;
    final l$id = id;
    _resultData['id'] = l$id;
    final l$language = language;
    _resultData['language'] = l$language;
    final l$blurHash = blurHash;
    _resultData['blurHash'] = l$blurHash;
    final l$directory = directory;
    _resultData['directory'] = l$directory.toJson();
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$type = type;
    final l$id = id;
    final l$language = language;
    final l$blurHash = blurHash;
    final l$directory = directory;
    final l$$__typename = $__typename;
    return Object.hashAll([
      l$type,
      l$id,
      l$language,
      l$blurHash,
      l$directory,
      l$$__typename,
    ]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Fragment$fragmentImages || runtimeType != other.runtimeType) {
      return false;
    }
    final l$type = type;
    final lOther$type = other.type;
    if (l$type != lOther$type) {
      return false;
    }
    final l$id = id;
    final lOther$id = other.id;
    if (l$id != lOther$id) {
      return false;
    }
    final l$language = language;
    final lOther$language = other.language;
    if (l$language != lOther$language) {
      return false;
    }
    final l$blurHash = blurHash;
    final lOther$blurHash = other.blurHash;
    if (l$blurHash != lOther$blurHash) {
      return false;
    }
    final l$directory = directory;
    final lOther$directory = other.directory;
    if (l$directory != lOther$directory) {
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

extension UtilityExtension$Fragment$fragmentImages on Fragment$fragmentImages {
  CopyWith$Fragment$fragmentImages<Fragment$fragmentImages> get copyWith =>
      CopyWith$Fragment$fragmentImages(this, (i) => i);
}

abstract class CopyWith$Fragment$fragmentImages<TRes> {
  factory CopyWith$Fragment$fragmentImages(
    Fragment$fragmentImages instance,
    TRes Function(Fragment$fragmentImages) then,
  ) = _CopyWithImpl$Fragment$fragmentImages;

  factory CopyWith$Fragment$fragmentImages.stub(TRes res) =
      _CopyWithStubImpl$Fragment$fragmentImages;

  TRes call({
    String? type,
    String? id,
    String? language,
    String? blurHash,
    Fragment$fragmentImages$directory? directory,
    String? $__typename,
  });
  CopyWith$Fragment$fragmentImages$directory<TRes> get directory;
}

class _CopyWithImpl$Fragment$fragmentImages<TRes>
    implements CopyWith$Fragment$fragmentImages<TRes> {
  _CopyWithImpl$Fragment$fragmentImages(this._instance, this._then);

  final Fragment$fragmentImages _instance;

  final TRes Function(Fragment$fragmentImages) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? type = _undefined,
    Object? id = _undefined,
    Object? language = _undefined,
    Object? blurHash = _undefined,
    Object? directory = _undefined,
    Object? $__typename = _undefined,
  }) => _then(
    Fragment$fragmentImages(
      type: type == _undefined || type == null
          ? _instance.type
          : (type as String),
      id: id == _undefined || id == null ? _instance.id : (id as String),
      language: language == _undefined
          ? _instance.language
          : (language as String?),
      blurHash: blurHash == _undefined
          ? _instance.blurHash
          : (blurHash as String?),
      directory: directory == _undefined || directory == null
          ? _instance.directory
          : (directory as Fragment$fragmentImages$directory),
      $__typename: $__typename == _undefined || $__typename == null
          ? _instance.$__typename
          : ($__typename as String),
    ),
  );

  CopyWith$Fragment$fragmentImages$directory<TRes> get directory {
    final local$directory = _instance.directory;
    return CopyWith$Fragment$fragmentImages$directory(
      local$directory,
      (e) => call(directory: e),
    );
  }
}

class _CopyWithStubImpl$Fragment$fragmentImages<TRes>
    implements CopyWith$Fragment$fragmentImages<TRes> {
  _CopyWithStubImpl$Fragment$fragmentImages(this._res);

  TRes _res;

  call({
    String? type,
    String? id,
    String? language,
    String? blurHash,
    Fragment$fragmentImages$directory? directory,
    String? $__typename,
  }) => _res;

  CopyWith$Fragment$fragmentImages$directory<TRes> get directory =>
      CopyWith$Fragment$fragmentImages$directory.stub(_res);
}

const fragmentDefinitionfragmentImages = FragmentDefinitionNode(
  name: NameNode(value: 'fragmentImages'),
  typeCondition: TypeConditionNode(
    on: NamedTypeNode(name: NameNode(value: 'Image'), isNonNull: false),
  ),
  directives: [],
  selectionSet: SelectionSetNode(
    selections: [
      FieldNode(
        name: NameNode(value: 'type'),
        alias: null,
        arguments: [],
        directives: [],
        selectionSet: null,
      ),
      FieldNode(
        name: NameNode(value: 'id'),
        alias: null,
        arguments: [],
        directives: [],
        selectionSet: null,
      ),
      FieldNode(
        name: NameNode(value: 'language'),
        alias: null,
        arguments: [],
        directives: [],
        selectionSet: null,
      ),
      FieldNode(
        name: NameNode(value: 'blurHash'),
        alias: null,
        arguments: [],
        directives: [],
        selectionSet: null,
      ),
      FieldNode(
        name: NameNode(value: 'directory'),
        alias: null,
        arguments: [],
        directives: [],
        selectionSet: SelectionSetNode(
          selections: [
            FieldNode(
              name: NameNode(value: 'node'),
              alias: null,
              arguments: [],
              directives: [],
              selectionSet: SelectionSetNode(
                selections: [
                  FieldNode(
                    name: NameNode(value: 'url'),
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
      FieldNode(
        name: NameNode(value: '__typename'),
        alias: null,
        arguments: [],
        directives: [],
        selectionSet: null,
      ),
    ],
  ),
);
const documentNodeFragmentfragmentImages = DocumentNode(
  definitions: [fragmentDefinitionfragmentImages],
);

class Fragment$fragmentImages$directory {
  Fragment$fragmentImages$directory({
    required this.node,
    this.$__typename = 'Directory',
  });

  factory Fragment$fragmentImages$directory.fromJson(
    Map<String, dynamic> json,
  ) {
    final l$node = json['node'];
    final l$$__typename = json['__typename'];
    return Fragment$fragmentImages$directory(
      node: Fragment$fragmentImages$directory$node.fromJson(
        (l$node as Map<String, dynamic>),
      ),
      $__typename: (l$$__typename as String),
    );
  }

  final Fragment$fragmentImages$directory$node node;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$node = node;
    _resultData['node'] = l$node.toJson();
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$node = node;
    final l$$__typename = $__typename;
    return Object.hashAll([l$node, l$$__typename]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Fragment$fragmentImages$directory ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$node = node;
    final lOther$node = other.node;
    if (l$node != lOther$node) {
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

extension UtilityExtension$Fragment$fragmentImages$directory
    on Fragment$fragmentImages$directory {
  CopyWith$Fragment$fragmentImages$directory<Fragment$fragmentImages$directory>
  get copyWith => CopyWith$Fragment$fragmentImages$directory(this, (i) => i);
}

abstract class CopyWith$Fragment$fragmentImages$directory<TRes> {
  factory CopyWith$Fragment$fragmentImages$directory(
    Fragment$fragmentImages$directory instance,
    TRes Function(Fragment$fragmentImages$directory) then,
  ) = _CopyWithImpl$Fragment$fragmentImages$directory;

  factory CopyWith$Fragment$fragmentImages$directory.stub(TRes res) =
      _CopyWithStubImpl$Fragment$fragmentImages$directory;

  TRes call({
    Fragment$fragmentImages$directory$node? node,
    String? $__typename,
  });
  CopyWith$Fragment$fragmentImages$directory$node<TRes> get node;
}

class _CopyWithImpl$Fragment$fragmentImages$directory<TRes>
    implements CopyWith$Fragment$fragmentImages$directory<TRes> {
  _CopyWithImpl$Fragment$fragmentImages$directory(this._instance, this._then);

  final Fragment$fragmentImages$directory _instance;

  final TRes Function(Fragment$fragmentImages$directory) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({Object? node = _undefined, Object? $__typename = _undefined}) =>
      _then(
        Fragment$fragmentImages$directory(
          node: node == _undefined || node == null
              ? _instance.node
              : (node as Fragment$fragmentImages$directory$node),
          $__typename: $__typename == _undefined || $__typename == null
              ? _instance.$__typename
              : ($__typename as String),
        ),
      );

  CopyWith$Fragment$fragmentImages$directory$node<TRes> get node {
    final local$node = _instance.node;
    return CopyWith$Fragment$fragmentImages$directory$node(
      local$node,
      (e) => call(node: e),
    );
  }
}

class _CopyWithStubImpl$Fragment$fragmentImages$directory<TRes>
    implements CopyWith$Fragment$fragmentImages$directory<TRes> {
  _CopyWithStubImpl$Fragment$fragmentImages$directory(this._res);

  TRes _res;

  call({Fragment$fragmentImages$directory$node? node, String? $__typename}) =>
      _res;

  CopyWith$Fragment$fragmentImages$directory$node<TRes> get node =>
      CopyWith$Fragment$fragmentImages$directory$node.stub(_res);
}

class Fragment$fragmentImages$directory$node {
  Fragment$fragmentImages$directory$node({
    required this.url,
    this.$__typename = 'Node',
  });

  factory Fragment$fragmentImages$directory$node.fromJson(
    Map<String, dynamic> json,
  ) {
    final l$url = json['url'];
    final l$$__typename = json['__typename'];
    return Fragment$fragmentImages$directory$node(
      url: (l$url as String),
      $__typename: (l$$__typename as String),
    );
  }

  final String url;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$url = url;
    _resultData['url'] = l$url;
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$url = url;
    final l$$__typename = $__typename;
    return Object.hashAll([l$url, l$$__typename]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Fragment$fragmentImages$directory$node ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$url = url;
    final lOther$url = other.url;
    if (l$url != lOther$url) {
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

extension UtilityExtension$Fragment$fragmentImages$directory$node
    on Fragment$fragmentImages$directory$node {
  CopyWith$Fragment$fragmentImages$directory$node<
    Fragment$fragmentImages$directory$node
  >
  get copyWith =>
      CopyWith$Fragment$fragmentImages$directory$node(this, (i) => i);
}

abstract class CopyWith$Fragment$fragmentImages$directory$node<TRes> {
  factory CopyWith$Fragment$fragmentImages$directory$node(
    Fragment$fragmentImages$directory$node instance,
    TRes Function(Fragment$fragmentImages$directory$node) then,
  ) = _CopyWithImpl$Fragment$fragmentImages$directory$node;

  factory CopyWith$Fragment$fragmentImages$directory$node.stub(TRes res) =
      _CopyWithStubImpl$Fragment$fragmentImages$directory$node;

  TRes call({String? url, String? $__typename});
}

class _CopyWithImpl$Fragment$fragmentImages$directory$node<TRes>
    implements CopyWith$Fragment$fragmentImages$directory$node<TRes> {
  _CopyWithImpl$Fragment$fragmentImages$directory$node(
    this._instance,
    this._then,
  );

  final Fragment$fragmentImages$directory$node _instance;

  final TRes Function(Fragment$fragmentImages$directory$node) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({Object? url = _undefined, Object? $__typename = _undefined}) =>
      _then(
        Fragment$fragmentImages$directory$node(
          url: url == _undefined || url == null
              ? _instance.url
              : (url as String),
          $__typename: $__typename == _undefined || $__typename == null
              ? _instance.$__typename
              : ($__typename as String),
        ),
      );
}

class _CopyWithStubImpl$Fragment$fragmentImages$directory$node<TRes>
    implements CopyWith$Fragment$fragmentImages$directory$node<TRes> {
  _CopyWithStubImpl$Fragment$fragmentImages$directory$node(this._res);

  TRes _res;

  call({String? url, String? $__typename}) => _res;
}

import 'package:gql/ast.dart';

import 'schema.graphql.dart';

class Fragment$fragmentImages {
  Fragment$fragmentImages({
    required this.type,
    required this.id,
    this.language,
    this.source,
    this.blurHash,
    required this.directory,
    this.$__typename = 'Image',
  });

  factory Fragment$fragmentImages.fromJson(Map<String, dynamic> json) {
    final l$type = json['type'];
    final l$id = json['id'];
    final l$language = json['language'];
    final l$source = json['source'];
    final l$blurHash = json['blurHash'];
    final l$directory = json['directory'];
    final l$$__typename = json['__typename'];
    return Fragment$fragmentImages(
      type: (l$type as String),
      id: (l$id as String),
      language: (l$language as String?),
      source: l$source == null
          ? null
          : fromJson$Enum$MetadataSource((l$source as String)),
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

  final Enum$MetadataSource? source;

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
    final l$source = source;
    _resultData['source'] = l$source == null
        ? null
        : toJson$Enum$MetadataSource(l$source);
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
    final l$source = source;
    final l$blurHash = blurHash;
    final l$directory = directory;
    final l$$__typename = $__typename;
    return Object.hashAll([
      l$type,
      l$id,
      l$language,
      l$source,
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
    final l$source = source;
    final lOther$source = other.source;
    if (l$source != lOther$source) {
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
    Enum$MetadataSource? source,
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
    Object? source = _undefined,
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
      source: source == _undefined
          ? _instance.source
          : (source as Enum$MetadataSource?),
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
    Enum$MetadataSource? source,
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
        name: NameNode(value: 'source'),
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
              name: NameNode(value: 'servingNode'),
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
    required this.servingNode,
    this.$__typename = 'Directory',
  });

  factory Fragment$fragmentImages$directory.fromJson(
    Map<String, dynamic> json,
  ) {
    final l$servingNode = json['servingNode'];
    final l$$__typename = json['__typename'];
    return Fragment$fragmentImages$directory(
      servingNode: Fragment$fragmentImages$directory$servingNode.fromJson(
        (l$servingNode as Map<String, dynamic>),
      ),
      $__typename: (l$$__typename as String),
    );
  }

  final Fragment$fragmentImages$directory$servingNode servingNode;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$servingNode = servingNode;
    _resultData['servingNode'] = l$servingNode.toJson();
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$servingNode = servingNode;
    final l$$__typename = $__typename;
    return Object.hashAll([l$servingNode, l$$__typename]);
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
    final l$servingNode = servingNode;
    final lOther$servingNode = other.servingNode;
    if (l$servingNode != lOther$servingNode) {
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
    Fragment$fragmentImages$directory$servingNode? servingNode,
    String? $__typename,
  });
  CopyWith$Fragment$fragmentImages$directory$servingNode<TRes> get servingNode;
}

class _CopyWithImpl$Fragment$fragmentImages$directory<TRes>
    implements CopyWith$Fragment$fragmentImages$directory<TRes> {
  _CopyWithImpl$Fragment$fragmentImages$directory(this._instance, this._then);

  final Fragment$fragmentImages$directory _instance;

  final TRes Function(Fragment$fragmentImages$directory) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? servingNode = _undefined,
    Object? $__typename = _undefined,
  }) => _then(
    Fragment$fragmentImages$directory(
      servingNode: servingNode == _undefined || servingNode == null
          ? _instance.servingNode
          : (servingNode as Fragment$fragmentImages$directory$servingNode),
      $__typename: $__typename == _undefined || $__typename == null
          ? _instance.$__typename
          : ($__typename as String),
    ),
  );

  CopyWith$Fragment$fragmentImages$directory$servingNode<TRes> get servingNode {
    final local$servingNode = _instance.servingNode;
    return CopyWith$Fragment$fragmentImages$directory$servingNode(
      local$servingNode,
      (e) => call(servingNode: e),
    );
  }
}

class _CopyWithStubImpl$Fragment$fragmentImages$directory<TRes>
    implements CopyWith$Fragment$fragmentImages$directory<TRes> {
  _CopyWithStubImpl$Fragment$fragmentImages$directory(this._res);

  TRes _res;

  call({
    Fragment$fragmentImages$directory$servingNode? servingNode,
    String? $__typename,
  }) => _res;

  CopyWith$Fragment$fragmentImages$directory$servingNode<TRes>
  get servingNode =>
      CopyWith$Fragment$fragmentImages$directory$servingNode.stub(_res);
}

class Fragment$fragmentImages$directory$servingNode {
  Fragment$fragmentImages$directory$servingNode({
    required this.url,
    this.$__typename = 'Node',
  });

  factory Fragment$fragmentImages$directory$servingNode.fromJson(
    Map<String, dynamic> json,
  ) {
    final l$url = json['url'];
    final l$$__typename = json['__typename'];
    return Fragment$fragmentImages$directory$servingNode(
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
    if (other is! Fragment$fragmentImages$directory$servingNode ||
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

extension UtilityExtension$Fragment$fragmentImages$directory$servingNode
    on Fragment$fragmentImages$directory$servingNode {
  CopyWith$Fragment$fragmentImages$directory$servingNode<
    Fragment$fragmentImages$directory$servingNode
  >
  get copyWith =>
      CopyWith$Fragment$fragmentImages$directory$servingNode(this, (i) => i);
}

abstract class CopyWith$Fragment$fragmentImages$directory$servingNode<TRes> {
  factory CopyWith$Fragment$fragmentImages$directory$servingNode(
    Fragment$fragmentImages$directory$servingNode instance,
    TRes Function(Fragment$fragmentImages$directory$servingNode) then,
  ) = _CopyWithImpl$Fragment$fragmentImages$directory$servingNode;

  factory CopyWith$Fragment$fragmentImages$directory$servingNode.stub(
    TRes res,
  ) = _CopyWithStubImpl$Fragment$fragmentImages$directory$servingNode;

  TRes call({String? url, String? $__typename});
}

class _CopyWithImpl$Fragment$fragmentImages$directory$servingNode<TRes>
    implements CopyWith$Fragment$fragmentImages$directory$servingNode<TRes> {
  _CopyWithImpl$Fragment$fragmentImages$directory$servingNode(
    this._instance,
    this._then,
  );

  final Fragment$fragmentImages$directory$servingNode _instance;

  final TRes Function(Fragment$fragmentImages$directory$servingNode) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({Object? url = _undefined, Object? $__typename = _undefined}) =>
      _then(
        Fragment$fragmentImages$directory$servingNode(
          url: url == _undefined || url == null
              ? _instance.url
              : (url as String),
          $__typename: $__typename == _undefined || $__typename == null
              ? _instance.$__typename
              : ($__typename as String),
        ),
      );
}

class _CopyWithStubImpl$Fragment$fragmentImages$directory$servingNode<TRes>
    implements CopyWith$Fragment$fragmentImages$directory$servingNode<TRes> {
  _CopyWithStubImpl$Fragment$fragmentImages$directory$servingNode(this._res);

  TRes _res;

  call({String? url, String? $__typename}) => _res;
}

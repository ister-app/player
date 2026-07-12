import 'fragmentImages.graphql.dart';
import 'fragmentMetadata.graphql.dart';
import 'package:gql/ast.dart';

class Fragment$fragmentBook {
  Fragment$fragmentBook({
    required this.id,
    required this.name,
    required this.releaseYear,
    required this.author,
    this.images,
    this.metadata,
    this.rating,
    this.$__typename = 'Book',
  });

  factory Fragment$fragmentBook.fromJson(Map<String, dynamic> json) {
    final l$id = json['id'];
    final l$name = json['name'];
    final l$releaseYear = json['releaseYear'];
    final l$author = json['author'];
    final l$images = json['images'];
    final l$metadata = json['metadata'];
    final l$rating = json['rating'];
    final l$$__typename = json['__typename'];
    return Fragment$fragmentBook(
      id: (l$id as String),
      name: (l$name as String),
      releaseYear: (l$releaseYear as int),
      author: Fragment$fragmentBook$author.fromJson(
        (l$author as Map<String, dynamic>),
      ),
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
      rating: (l$rating as int?),
      $__typename: (l$$__typename as String),
    );
  }

  final String id;

  final String name;

  final int releaseYear;

  final Fragment$fragmentBook$author author;

  final List<Fragment$fragmentImages>? images;

  final List<Fragment$fragmentMetadata>? metadata;

  final int? rating;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$id = id;
    _resultData['id'] = l$id;
    final l$name = name;
    _resultData['name'] = l$name;
    final l$releaseYear = releaseYear;
    _resultData['releaseYear'] = l$releaseYear;
    final l$author = author;
    _resultData['author'] = l$author.toJson();
    final l$images = images;
    _resultData['images'] = l$images?.map((e) => e.toJson()).toList();
    final l$metadata = metadata;
    _resultData['metadata'] = l$metadata?.map((e) => e.toJson()).toList();
    final l$rating = rating;
    _resultData['rating'] = l$rating;
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$id = id;
    final l$name = name;
    final l$releaseYear = releaseYear;
    final l$author = author;
    final l$images = images;
    final l$metadata = metadata;
    final l$rating = rating;
    final l$$__typename = $__typename;
    return Object.hashAll([
      l$id,
      l$name,
      l$releaseYear,
      l$author,
      l$images == null ? null : Object.hashAll(l$images.map((v) => v)),
      l$metadata == null ? null : Object.hashAll(l$metadata.map((v) => v)),
      l$rating,
      l$$__typename,
    ]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Fragment$fragmentBook || runtimeType != other.runtimeType) {
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
    final l$author = author;
    final lOther$author = other.author;
    if (l$author != lOther$author) {
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
    final l$rating = rating;
    final lOther$rating = other.rating;
    if (l$rating != lOther$rating) {
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

extension UtilityExtension$Fragment$fragmentBook on Fragment$fragmentBook {
  CopyWith$Fragment$fragmentBook<Fragment$fragmentBook> get copyWith =>
      CopyWith$Fragment$fragmentBook(this, (i) => i);
}

abstract class CopyWith$Fragment$fragmentBook<TRes> {
  factory CopyWith$Fragment$fragmentBook(
    Fragment$fragmentBook instance,
    TRes Function(Fragment$fragmentBook) then,
  ) = _CopyWithImpl$Fragment$fragmentBook;

  factory CopyWith$Fragment$fragmentBook.stub(TRes res) =
      _CopyWithStubImpl$Fragment$fragmentBook;

  TRes call({
    String? id,
    String? name,
    int? releaseYear,
    Fragment$fragmentBook$author? author,
    List<Fragment$fragmentImages>? images,
    List<Fragment$fragmentMetadata>? metadata,
    int? rating,
    String? $__typename,
  });
  CopyWith$Fragment$fragmentBook$author<TRes> get author;
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

class _CopyWithImpl$Fragment$fragmentBook<TRes>
    implements CopyWith$Fragment$fragmentBook<TRes> {
  _CopyWithImpl$Fragment$fragmentBook(this._instance, this._then);

  final Fragment$fragmentBook _instance;

  final TRes Function(Fragment$fragmentBook) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? id = _undefined,
    Object? name = _undefined,
    Object? releaseYear = _undefined,
    Object? author = _undefined,
    Object? images = _undefined,
    Object? metadata = _undefined,
    Object? rating = _undefined,
    Object? $__typename = _undefined,
  }) => _then(
    Fragment$fragmentBook(
      id: id == _undefined || id == null ? _instance.id : (id as String),
      name: name == _undefined || name == null
          ? _instance.name
          : (name as String),
      releaseYear: releaseYear == _undefined || releaseYear == null
          ? _instance.releaseYear
          : (releaseYear as int),
      author: author == _undefined || author == null
          ? _instance.author
          : (author as Fragment$fragmentBook$author),
      images: images == _undefined
          ? _instance.images
          : (images as List<Fragment$fragmentImages>?),
      metadata: metadata == _undefined
          ? _instance.metadata
          : (metadata as List<Fragment$fragmentMetadata>?),
      rating: rating == _undefined ? _instance.rating : (rating as int?),
      $__typename: $__typename == _undefined || $__typename == null
          ? _instance.$__typename
          : ($__typename as String),
    ),
  );

  CopyWith$Fragment$fragmentBook$author<TRes> get author {
    final local$author = _instance.author;
    return CopyWith$Fragment$fragmentBook$author(
      local$author,
      (e) => call(author: e),
    );
  }

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

class _CopyWithStubImpl$Fragment$fragmentBook<TRes>
    implements CopyWith$Fragment$fragmentBook<TRes> {
  _CopyWithStubImpl$Fragment$fragmentBook(this._res);

  TRes _res;

  call({
    String? id,
    String? name,
    int? releaseYear,
    Fragment$fragmentBook$author? author,
    List<Fragment$fragmentImages>? images,
    List<Fragment$fragmentMetadata>? metadata,
    int? rating,
    String? $__typename,
  }) => _res;

  CopyWith$Fragment$fragmentBook$author<TRes> get author =>
      CopyWith$Fragment$fragmentBook$author.stub(_res);

  images(_fn) => _res;

  metadata(_fn) => _res;
}

const fragmentDefinitionfragmentBook = FragmentDefinitionNode(
  name: NameNode(value: 'fragmentBook'),
  typeCondition: TypeConditionNode(
    on: NamedTypeNode(name: NameNode(value: 'Book'), isNonNull: false),
  ),
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
        name: NameNode(value: 'author'),
        alias: null,
        arguments: [],
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
        name: NameNode(value: 'rating'),
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
);
const documentNodeFragmentfragmentBook = DocumentNode(
  definitions: [
    fragmentDefinitionfragmentBook,
    fragmentDefinitionfragmentImages,
    fragmentDefinitionfragmentMetadata,
  ],
);

class Fragment$fragmentBook$author {
  Fragment$fragmentBook$author({
    required this.id,
    required this.name,
    this.$__typename = 'Person',
  });

  factory Fragment$fragmentBook$author.fromJson(Map<String, dynamic> json) {
    final l$id = json['id'];
    final l$name = json['name'];
    final l$$__typename = json['__typename'];
    return Fragment$fragmentBook$author(
      id: (l$id as String),
      name: (l$name as String),
      $__typename: (l$$__typename as String),
    );
  }

  final String id;

  final String name;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$id = id;
    _resultData['id'] = l$id;
    final l$name = name;
    _resultData['name'] = l$name;
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$id = id;
    final l$name = name;
    final l$$__typename = $__typename;
    return Object.hashAll([l$id, l$name, l$$__typename]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Fragment$fragmentBook$author ||
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
    final l$$__typename = $__typename;
    final lOther$$__typename = other.$__typename;
    if (l$$__typename != lOther$$__typename) {
      return false;
    }
    return true;
  }
}

extension UtilityExtension$Fragment$fragmentBook$author
    on Fragment$fragmentBook$author {
  CopyWith$Fragment$fragmentBook$author<Fragment$fragmentBook$author>
  get copyWith => CopyWith$Fragment$fragmentBook$author(this, (i) => i);
}

abstract class CopyWith$Fragment$fragmentBook$author<TRes> {
  factory CopyWith$Fragment$fragmentBook$author(
    Fragment$fragmentBook$author instance,
    TRes Function(Fragment$fragmentBook$author) then,
  ) = _CopyWithImpl$Fragment$fragmentBook$author;

  factory CopyWith$Fragment$fragmentBook$author.stub(TRes res) =
      _CopyWithStubImpl$Fragment$fragmentBook$author;

  TRes call({String? id, String? name, String? $__typename});
}

class _CopyWithImpl$Fragment$fragmentBook$author<TRes>
    implements CopyWith$Fragment$fragmentBook$author<TRes> {
  _CopyWithImpl$Fragment$fragmentBook$author(this._instance, this._then);

  final Fragment$fragmentBook$author _instance;

  final TRes Function(Fragment$fragmentBook$author) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? id = _undefined,
    Object? name = _undefined,
    Object? $__typename = _undefined,
  }) => _then(
    Fragment$fragmentBook$author(
      id: id == _undefined || id == null ? _instance.id : (id as String),
      name: name == _undefined || name == null
          ? _instance.name
          : (name as String),
      $__typename: $__typename == _undefined || $__typename == null
          ? _instance.$__typename
          : ($__typename as String),
    ),
  );
}

class _CopyWithStubImpl$Fragment$fragmentBook$author<TRes>
    implements CopyWith$Fragment$fragmentBook$author<TRes> {
  _CopyWithStubImpl$Fragment$fragmentBook$author(this._res);

  TRes _res;

  call({String? id, String? name, String? $__typename}) => _res;
}

import 'fragmentImages.graphql.dart';
import 'fragmentMetadata.graphql.dart';
import 'package:gql/ast.dart';

class Fragment$fragmentBook {
  Fragment$fragmentBook({
    required this.id,
    required this.name,
    required this.title,
    required this.releaseYear,
    this.seriesIndex,
    this.author,
    this.series,
    this.images,
    this.metadata,
    this.rating,
    this.$__typename = 'Book',
  });

  factory Fragment$fragmentBook.fromJson(Map<String, dynamic> json) {
    final l$id = json['id'];
    final l$name = json['name'];
    final l$title = json['title'];
    final l$releaseYear = json['releaseYear'];
    final l$seriesIndex = json['seriesIndex'];
    final l$author = json['author'];
    final l$series = json['series'];
    final l$images = json['images'];
    final l$metadata = json['metadata'];
    final l$rating = json['rating'];
    final l$$__typename = json['__typename'];
    return Fragment$fragmentBook(
      id: (l$id as String),
      name: (l$name as String),
      title: (l$title as String),
      releaseYear: (l$releaseYear as int),
      seriesIndex: (l$seriesIndex as num?)?.toDouble(),
      author: l$author == null
          ? null
          : Fragment$fragmentBook$author.fromJson(
              (l$author as Map<String, dynamic>),
            ),
      series: l$series == null
          ? null
          : Fragment$fragmentBook$series.fromJson(
              (l$series as Map<String, dynamic>),
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

  final String title;

  final int releaseYear;

  final double? seriesIndex;

  final Fragment$fragmentBook$author? author;

  final Fragment$fragmentBook$series? series;

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
    final l$title = title;
    _resultData['title'] = l$title;
    final l$releaseYear = releaseYear;
    _resultData['releaseYear'] = l$releaseYear;
    final l$seriesIndex = seriesIndex;
    _resultData['seriesIndex'] = l$seriesIndex;
    final l$author = author;
    _resultData['author'] = l$author?.toJson();
    final l$series = series;
    _resultData['series'] = l$series?.toJson();
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
    final l$title = title;
    final l$releaseYear = releaseYear;
    final l$seriesIndex = seriesIndex;
    final l$author = author;
    final l$series = series;
    final l$images = images;
    final l$metadata = metadata;
    final l$rating = rating;
    final l$$__typename = $__typename;
    return Object.hashAll([
      l$id,
      l$name,
      l$title,
      l$releaseYear,
      l$seriesIndex,
      l$author,
      l$series,
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
    final l$title = title;
    final lOther$title = other.title;
    if (l$title != lOther$title) {
      return false;
    }
    final l$releaseYear = releaseYear;
    final lOther$releaseYear = other.releaseYear;
    if (l$releaseYear != lOther$releaseYear) {
      return false;
    }
    final l$seriesIndex = seriesIndex;
    final lOther$seriesIndex = other.seriesIndex;
    if (l$seriesIndex != lOther$seriesIndex) {
      return false;
    }
    final l$author = author;
    final lOther$author = other.author;
    if (l$author != lOther$author) {
      return false;
    }
    final l$series = series;
    final lOther$series = other.series;
    if (l$series != lOther$series) {
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
    String? title,
    int? releaseYear,
    double? seriesIndex,
    Fragment$fragmentBook$author? author,
    Fragment$fragmentBook$series? series,
    List<Fragment$fragmentImages>? images,
    List<Fragment$fragmentMetadata>? metadata,
    int? rating,
    String? $__typename,
  });
  CopyWith$Fragment$fragmentBook$author<TRes> get author;
  CopyWith$Fragment$fragmentBook$series<TRes> get series;
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
    Object? title = _undefined,
    Object? releaseYear = _undefined,
    Object? seriesIndex = _undefined,
    Object? author = _undefined,
    Object? series = _undefined,
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
      title: title == _undefined || title == null
          ? _instance.title
          : (title as String),
      releaseYear: releaseYear == _undefined || releaseYear == null
          ? _instance.releaseYear
          : (releaseYear as int),
      seriesIndex: seriesIndex == _undefined
          ? _instance.seriesIndex
          : (seriesIndex as double?),
      author: author == _undefined
          ? _instance.author
          : (author as Fragment$fragmentBook$author?),
      series: series == _undefined
          ? _instance.series
          : (series as Fragment$fragmentBook$series?),
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
    return local$author == null
        ? CopyWith$Fragment$fragmentBook$author.stub(_then(_instance))
        : CopyWith$Fragment$fragmentBook$author(
            local$author,
            (e) => call(author: e),
          );
  }

  CopyWith$Fragment$fragmentBook$series<TRes> get series {
    final local$series = _instance.series;
    return local$series == null
        ? CopyWith$Fragment$fragmentBook$series.stub(_then(_instance))
        : CopyWith$Fragment$fragmentBook$series(
            local$series,
            (e) => call(series: e),
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
    String? title,
    int? releaseYear,
    double? seriesIndex,
    Fragment$fragmentBook$author? author,
    Fragment$fragmentBook$series? series,
    List<Fragment$fragmentImages>? images,
    List<Fragment$fragmentMetadata>? metadata,
    int? rating,
    String? $__typename,
  }) => _res;

  CopyWith$Fragment$fragmentBook$author<TRes> get author =>
      CopyWith$Fragment$fragmentBook$author.stub(_res);

  CopyWith$Fragment$fragmentBook$series<TRes> get series =>
      CopyWith$Fragment$fragmentBook$series.stub(_res);

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
        name: NameNode(value: 'title'),
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
        name: NameNode(value: 'seriesIndex'),
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
        name: NameNode(value: 'series'),
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

class Fragment$fragmentBook$series {
  Fragment$fragmentBook$series({
    required this.id,
    required this.name,
    this.$__typename = 'Series',
  });

  factory Fragment$fragmentBook$series.fromJson(Map<String, dynamic> json) {
    final l$id = json['id'];
    final l$name = json['name'];
    final l$$__typename = json['__typename'];
    return Fragment$fragmentBook$series(
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
    if (other is! Fragment$fragmentBook$series ||
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

extension UtilityExtension$Fragment$fragmentBook$series
    on Fragment$fragmentBook$series {
  CopyWith$Fragment$fragmentBook$series<Fragment$fragmentBook$series>
  get copyWith => CopyWith$Fragment$fragmentBook$series(this, (i) => i);
}

abstract class CopyWith$Fragment$fragmentBook$series<TRes> {
  factory CopyWith$Fragment$fragmentBook$series(
    Fragment$fragmentBook$series instance,
    TRes Function(Fragment$fragmentBook$series) then,
  ) = _CopyWithImpl$Fragment$fragmentBook$series;

  factory CopyWith$Fragment$fragmentBook$series.stub(TRes res) =
      _CopyWithStubImpl$Fragment$fragmentBook$series;

  TRes call({String? id, String? name, String? $__typename});
}

class _CopyWithImpl$Fragment$fragmentBook$series<TRes>
    implements CopyWith$Fragment$fragmentBook$series<TRes> {
  _CopyWithImpl$Fragment$fragmentBook$series(this._instance, this._then);

  final Fragment$fragmentBook$series _instance;

  final TRes Function(Fragment$fragmentBook$series) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? id = _undefined,
    Object? name = _undefined,
    Object? $__typename = _undefined,
  }) => _then(
    Fragment$fragmentBook$series(
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

class _CopyWithStubImpl$Fragment$fragmentBook$series<TRes>
    implements CopyWith$Fragment$fragmentBook$series<TRes> {
  _CopyWithStubImpl$Fragment$fragmentBook$series(this._res);

  TRes _res;

  call({String? id, String? name, String? $__typename}) => _res;
}

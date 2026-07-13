import 'fragmentImages.graphql.dart';
import 'fragmentMetadata.graphql.dart';
import 'package:gql/ast.dart';
import 'schema.graphql.dart';

class Fragment$fragmentPodcast {
  Fragment$fragmentPodcast({
    required this.id,
    required this.title,
    this.author,
    required this.feedUrl,
    required this.active,
    this.images,
    this.metadata,
    this.rating,
    required this.episodeOrder,
    this.$__typename = 'Podcast',
  });

  factory Fragment$fragmentPodcast.fromJson(Map<String, dynamic> json) {
    final l$id = json['id'];
    final l$title = json['title'];
    final l$author = json['author'];
    final l$feedUrl = json['feedUrl'];
    final l$active = json['active'];
    final l$images = json['images'];
    final l$metadata = json['metadata'];
    final l$rating = json['rating'];
    final l$episodeOrder = json['episodeOrder'];
    final l$$__typename = json['__typename'];
    return Fragment$fragmentPodcast(
      id: (l$id as String),
      title: (l$title as String),
      author: (l$author as String?),
      feedUrl: (l$feedUrl as String),
      active: (l$active as bool),
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
      episodeOrder: fromJson$Enum$SortingOrder((l$episodeOrder as String)),
      $__typename: (l$$__typename as String),
    );
  }

  final String id;

  final String title;

  final String? author;

  final String feedUrl;

  final bool active;

  final List<Fragment$fragmentImages>? images;

  final List<Fragment$fragmentMetadata>? metadata;

  final int? rating;

  final Enum$SortingOrder episodeOrder;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$id = id;
    _resultData['id'] = l$id;
    final l$title = title;
    _resultData['title'] = l$title;
    final l$author = author;
    _resultData['author'] = l$author;
    final l$feedUrl = feedUrl;
    _resultData['feedUrl'] = l$feedUrl;
    final l$active = active;
    _resultData['active'] = l$active;
    final l$images = images;
    _resultData['images'] = l$images?.map((e) => e.toJson()).toList();
    final l$metadata = metadata;
    _resultData['metadata'] = l$metadata?.map((e) => e.toJson()).toList();
    final l$rating = rating;
    _resultData['rating'] = l$rating;
    final l$episodeOrder = episodeOrder;
    _resultData['episodeOrder'] = toJson$Enum$SortingOrder(l$episodeOrder);
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$id = id;
    final l$title = title;
    final l$author = author;
    final l$feedUrl = feedUrl;
    final l$active = active;
    final l$images = images;
    final l$metadata = metadata;
    final l$rating = rating;
    final l$episodeOrder = episodeOrder;
    final l$$__typename = $__typename;
    return Object.hashAll([
      l$id,
      l$title,
      l$author,
      l$feedUrl,
      l$active,
      l$images == null ? null : Object.hashAll(l$images.map((v) => v)),
      l$metadata == null ? null : Object.hashAll(l$metadata.map((v) => v)),
      l$rating,
      l$episodeOrder,
      l$$__typename,
    ]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Fragment$fragmentPodcast ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$id = id;
    final lOther$id = other.id;
    if (l$id != lOther$id) {
      return false;
    }
    final l$title = title;
    final lOther$title = other.title;
    if (l$title != lOther$title) {
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
    final l$active = active;
    final lOther$active = other.active;
    if (l$active != lOther$active) {
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
    final l$episodeOrder = episodeOrder;
    final lOther$episodeOrder = other.episodeOrder;
    if (l$episodeOrder != lOther$episodeOrder) {
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

extension UtilityExtension$Fragment$fragmentPodcast
    on Fragment$fragmentPodcast {
  CopyWith$Fragment$fragmentPodcast<Fragment$fragmentPodcast> get copyWith =>
      CopyWith$Fragment$fragmentPodcast(this, (i) => i);
}

abstract class CopyWith$Fragment$fragmentPodcast<TRes> {
  factory CopyWith$Fragment$fragmentPodcast(
    Fragment$fragmentPodcast instance,
    TRes Function(Fragment$fragmentPodcast) then,
  ) = _CopyWithImpl$Fragment$fragmentPodcast;

  factory CopyWith$Fragment$fragmentPodcast.stub(TRes res) =
      _CopyWithStubImpl$Fragment$fragmentPodcast;

  TRes call({
    String? id,
    String? title,
    String? author,
    String? feedUrl,
    bool? active,
    List<Fragment$fragmentImages>? images,
    List<Fragment$fragmentMetadata>? metadata,
    int? rating,
    Enum$SortingOrder? episodeOrder,
    String? $__typename,
  });
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

class _CopyWithImpl$Fragment$fragmentPodcast<TRes>
    implements CopyWith$Fragment$fragmentPodcast<TRes> {
  _CopyWithImpl$Fragment$fragmentPodcast(this._instance, this._then);

  final Fragment$fragmentPodcast _instance;

  final TRes Function(Fragment$fragmentPodcast) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? id = _undefined,
    Object? title = _undefined,
    Object? author = _undefined,
    Object? feedUrl = _undefined,
    Object? active = _undefined,
    Object? images = _undefined,
    Object? metadata = _undefined,
    Object? rating = _undefined,
    Object? episodeOrder = _undefined,
    Object? $__typename = _undefined,
  }) => _then(
    Fragment$fragmentPodcast(
      id: id == _undefined || id == null ? _instance.id : (id as String),
      title: title == _undefined || title == null
          ? _instance.title
          : (title as String),
      author: author == _undefined ? _instance.author : (author as String?),
      feedUrl: feedUrl == _undefined || feedUrl == null
          ? _instance.feedUrl
          : (feedUrl as String),
      active: active == _undefined || active == null
          ? _instance.active
          : (active as bool),
      images: images == _undefined
          ? _instance.images
          : (images as List<Fragment$fragmentImages>?),
      metadata: metadata == _undefined
          ? _instance.metadata
          : (metadata as List<Fragment$fragmentMetadata>?),
      rating: rating == _undefined ? _instance.rating : (rating as int?),
      episodeOrder: episodeOrder == _undefined || episodeOrder == null
          ? _instance.episodeOrder
          : (episodeOrder as Enum$SortingOrder),
      $__typename: $__typename == _undefined || $__typename == null
          ? _instance.$__typename
          : ($__typename as String),
    ),
  );

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

class _CopyWithStubImpl$Fragment$fragmentPodcast<TRes>
    implements CopyWith$Fragment$fragmentPodcast<TRes> {
  _CopyWithStubImpl$Fragment$fragmentPodcast(this._res);

  TRes _res;

  call({
    String? id,
    String? title,
    String? author,
    String? feedUrl,
    bool? active,
    List<Fragment$fragmentImages>? images,
    List<Fragment$fragmentMetadata>? metadata,
    int? rating,
    Enum$SortingOrder? episodeOrder,
    String? $__typename,
  }) => _res;

  images(_fn) => _res;

  metadata(_fn) => _res;
}

const fragmentDefinitionfragmentPodcast = FragmentDefinitionNode(
  name: NameNode(value: 'fragmentPodcast'),
  typeCondition: TypeConditionNode(
    on: NamedTypeNode(name: NameNode(value: 'Podcast'), isNonNull: false),
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
        name: NameNode(value: 'title'),
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
        name: NameNode(value: 'active'),
        alias: null,
        arguments: [],
        directives: [],
        selectionSet: null,
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
        name: NameNode(value: 'episodeOrder'),
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
const documentNodeFragmentfragmentPodcast = DocumentNode(
  definitions: [
    fragmentDefinitionfragmentPodcast,
    fragmentDefinitionfragmentImages,
    fragmentDefinitionfragmentMetadata,
  ],
);

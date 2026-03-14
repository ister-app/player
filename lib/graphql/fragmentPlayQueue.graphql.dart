import 'fragmentEpisode.graphql.dart';
import 'fragmentImages.graphql.dart';
import 'fragmentMediafiles.graphql.dart';
import 'fragmentMetadata.graphql.dart';
import 'package:gql/ast.dart';

class Fragment$fragmentPlayQueue {
  Fragment$fragmentPlayQueue({
    required this.id,
    this.currentItemId,
    this.playQueueItems,
    this.$__typename = 'PlayQueue',
  });

  factory Fragment$fragmentPlayQueue.fromJson(Map<String, dynamic> json) {
    final l$id = json['id'];
    final l$currentItemId = json['currentItemId'];
    final l$playQueueItems = json['playQueueItems'];
    final l$$__typename = json['__typename'];
    return Fragment$fragmentPlayQueue(
      id: (l$id as String),
      currentItemId: (l$currentItemId as String?),
      playQueueItems: (l$playQueueItems as List<dynamic>?)
          ?.map(
            (e) => Fragment$fragmentPlayQueue$playQueueItems.fromJson(
              (e as Map<String, dynamic>),
            ),
          )
          .toList(),
      $__typename: (l$$__typename as String),
    );
  }

  final String id;

  final String? currentItemId;

  final List<Fragment$fragmentPlayQueue$playQueueItems>? playQueueItems;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$id = id;
    _resultData['id'] = l$id;
    final l$currentItemId = currentItemId;
    _resultData['currentItemId'] = l$currentItemId;
    final l$playQueueItems = playQueueItems;
    _resultData['playQueueItems'] = l$playQueueItems
        ?.map((e) => e.toJson())
        .toList();
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$id = id;
    final l$currentItemId = currentItemId;
    final l$playQueueItems = playQueueItems;
    final l$$__typename = $__typename;
    return Object.hashAll([
      l$id,
      l$currentItemId,
      l$playQueueItems == null
          ? null
          : Object.hashAll(l$playQueueItems.map((v) => v)),
      l$$__typename,
    ]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Fragment$fragmentPlayQueue ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$id = id;
    final lOther$id = other.id;
    if (l$id != lOther$id) {
      return false;
    }
    final l$currentItemId = currentItemId;
    final lOther$currentItemId = other.currentItemId;
    if (l$currentItemId != lOther$currentItemId) {
      return false;
    }
    final l$playQueueItems = playQueueItems;
    final lOther$playQueueItems = other.playQueueItems;
    if (l$playQueueItems != null && lOther$playQueueItems != null) {
      if (l$playQueueItems.length != lOther$playQueueItems.length) {
        return false;
      }
      for (int i = 0; i < l$playQueueItems.length; i++) {
        final l$playQueueItems$entry = l$playQueueItems[i];
        final lOther$playQueueItems$entry = lOther$playQueueItems[i];
        if (l$playQueueItems$entry != lOther$playQueueItems$entry) {
          return false;
        }
      }
    } else if (l$playQueueItems != lOther$playQueueItems) {
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

extension UtilityExtension$Fragment$fragmentPlayQueue
    on Fragment$fragmentPlayQueue {
  CopyWith$Fragment$fragmentPlayQueue<Fragment$fragmentPlayQueue>
  get copyWith => CopyWith$Fragment$fragmentPlayQueue(this, (i) => i);
}

abstract class CopyWith$Fragment$fragmentPlayQueue<TRes> {
  factory CopyWith$Fragment$fragmentPlayQueue(
    Fragment$fragmentPlayQueue instance,
    TRes Function(Fragment$fragmentPlayQueue) then,
  ) = _CopyWithImpl$Fragment$fragmentPlayQueue;

  factory CopyWith$Fragment$fragmentPlayQueue.stub(TRes res) =
      _CopyWithStubImpl$Fragment$fragmentPlayQueue;

  TRes call({
    String? id,
    String? currentItemId,
    List<Fragment$fragmentPlayQueue$playQueueItems>? playQueueItems,
    String? $__typename,
  });
  TRes playQueueItems(
    Iterable<Fragment$fragmentPlayQueue$playQueueItems>? Function(
      Iterable<
        CopyWith$Fragment$fragmentPlayQueue$playQueueItems<
          Fragment$fragmentPlayQueue$playQueueItems
        >
      >?,
    )
    _fn,
  );
}

class _CopyWithImpl$Fragment$fragmentPlayQueue<TRes>
    implements CopyWith$Fragment$fragmentPlayQueue<TRes> {
  _CopyWithImpl$Fragment$fragmentPlayQueue(this._instance, this._then);

  final Fragment$fragmentPlayQueue _instance;

  final TRes Function(Fragment$fragmentPlayQueue) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? id = _undefined,
    Object? currentItemId = _undefined,
    Object? playQueueItems = _undefined,
    Object? $__typename = _undefined,
  }) => _then(
    Fragment$fragmentPlayQueue(
      id: id == _undefined || id == null ? _instance.id : (id as String),
      currentItemId: currentItemId == _undefined
          ? _instance.currentItemId
          : (currentItemId as String?),
      playQueueItems: playQueueItems == _undefined
          ? _instance.playQueueItems
          : (playQueueItems
                as List<Fragment$fragmentPlayQueue$playQueueItems>?),
      $__typename: $__typename == _undefined || $__typename == null
          ? _instance.$__typename
          : ($__typename as String),
    ),
  );

  TRes playQueueItems(
    Iterable<Fragment$fragmentPlayQueue$playQueueItems>? Function(
      Iterable<
        CopyWith$Fragment$fragmentPlayQueue$playQueueItems<
          Fragment$fragmentPlayQueue$playQueueItems
        >
      >?,
    )
    _fn,
  ) => call(
    playQueueItems: _fn(
      _instance.playQueueItems?.map(
        (e) => CopyWith$Fragment$fragmentPlayQueue$playQueueItems(e, (i) => i),
      ),
    )?.toList(),
  );
}

class _CopyWithStubImpl$Fragment$fragmentPlayQueue<TRes>
    implements CopyWith$Fragment$fragmentPlayQueue<TRes> {
  _CopyWithStubImpl$Fragment$fragmentPlayQueue(this._res);

  TRes _res;

  call({
    String? id,
    String? currentItemId,
    List<Fragment$fragmentPlayQueue$playQueueItems>? playQueueItems,
    String? $__typename,
  }) => _res;

  playQueueItems(_fn) => _res;
}

const fragmentDefinitionfragmentPlayQueue = FragmentDefinitionNode(
  name: NameNode(value: 'fragmentPlayQueue'),
  typeCondition: TypeConditionNode(
    on: NamedTypeNode(name: NameNode(value: 'PlayQueue'), isNonNull: false),
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
        name: NameNode(value: 'currentItemId'),
        alias: null,
        arguments: [],
        directives: [],
        selectionSet: null,
      ),
      FieldNode(
        name: NameNode(value: 'playQueueItems'),
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
              name: NameNode(value: 'episode'),
              alias: null,
              arguments: [],
              directives: [],
              selectionSet: SelectionSetNode(
                selections: [
                  FragmentSpreadNode(
                    name: NameNode(value: 'fragmentEpisode'),
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
              name: NameNode(value: 'movie'),
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
                    name: NameNode(value: 'mediaFile'),
                    alias: null,
                    arguments: [],
                    directives: [],
                    selectionSet: SelectionSetNode(
                      selections: [
                        FragmentSpreadNode(
                          name: NameNode(value: 'fragmentMediaFiles'),
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
);
const documentNodeFragmentfragmentPlayQueue = DocumentNode(
  definitions: [
    fragmentDefinitionfragmentPlayQueue,
    fragmentDefinitionfragmentEpisode,
    fragmentDefinitionfragmentMetadata,
    fragmentDefinitionfragmentImages,
    fragmentDefinitionfragmentMediaFiles,
  ],
);

class Fragment$fragmentPlayQueue$playQueueItems {
  Fragment$fragmentPlayQueue$playQueueItems({
    required this.id,
    this.episode,
    this.movie,
    this.$__typename = 'PlayQueueItem',
  });

  factory Fragment$fragmentPlayQueue$playQueueItems.fromJson(
    Map<String, dynamic> json,
  ) {
    final l$id = json['id'];
    final l$episode = json['episode'];
    final l$movie = json['movie'];
    final l$$__typename = json['__typename'];
    return Fragment$fragmentPlayQueue$playQueueItems(
      id: (l$id as String),
      episode: l$episode == null
          ? null
          : Fragment$fragmentEpisode.fromJson(
              (l$episode as Map<String, dynamic>),
            ),
      movie: l$movie == null
          ? null
          : Fragment$fragmentPlayQueue$playQueueItems$movie.fromJson(
              (l$movie as Map<String, dynamic>),
            ),
      $__typename: (l$$__typename as String),
    );
  }

  final String id;

  final Fragment$fragmentEpisode? episode;

  final Fragment$fragmentPlayQueue$playQueueItems$movie? movie;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$id = id;
    _resultData['id'] = l$id;
    final l$episode = episode;
    _resultData['episode'] = l$episode?.toJson();
    final l$movie = movie;
    _resultData['movie'] = l$movie?.toJson();
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$id = id;
    final l$episode = episode;
    final l$movie = movie;
    final l$$__typename = $__typename;
    return Object.hashAll([l$id, l$episode, l$movie, l$$__typename]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Fragment$fragmentPlayQueue$playQueueItems ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$id = id;
    final lOther$id = other.id;
    if (l$id != lOther$id) {
      return false;
    }
    final l$episode = episode;
    final lOther$episode = other.episode;
    if (l$episode != lOther$episode) {
      return false;
    }
    final l$movie = movie;
    final lOther$movie = other.movie;
    if (l$movie != lOther$movie) {
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

extension UtilityExtension$Fragment$fragmentPlayQueue$playQueueItems
    on Fragment$fragmentPlayQueue$playQueueItems {
  CopyWith$Fragment$fragmentPlayQueue$playQueueItems<
    Fragment$fragmentPlayQueue$playQueueItems
  >
  get copyWith =>
      CopyWith$Fragment$fragmentPlayQueue$playQueueItems(this, (i) => i);
}

abstract class CopyWith$Fragment$fragmentPlayQueue$playQueueItems<TRes> {
  factory CopyWith$Fragment$fragmentPlayQueue$playQueueItems(
    Fragment$fragmentPlayQueue$playQueueItems instance,
    TRes Function(Fragment$fragmentPlayQueue$playQueueItems) then,
  ) = _CopyWithImpl$Fragment$fragmentPlayQueue$playQueueItems;

  factory CopyWith$Fragment$fragmentPlayQueue$playQueueItems.stub(TRes res) =
      _CopyWithStubImpl$Fragment$fragmentPlayQueue$playQueueItems;

  TRes call({
    String? id,
    Fragment$fragmentEpisode? episode,
    Fragment$fragmentPlayQueue$playQueueItems$movie? movie,
    String? $__typename,
  });
  CopyWith$Fragment$fragmentEpisode<TRes> get episode;
  CopyWith$Fragment$fragmentPlayQueue$playQueueItems$movie<TRes> get movie;
}

class _CopyWithImpl$Fragment$fragmentPlayQueue$playQueueItems<TRes>
    implements CopyWith$Fragment$fragmentPlayQueue$playQueueItems<TRes> {
  _CopyWithImpl$Fragment$fragmentPlayQueue$playQueueItems(
    this._instance,
    this._then,
  );

  final Fragment$fragmentPlayQueue$playQueueItems _instance;

  final TRes Function(Fragment$fragmentPlayQueue$playQueueItems) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? id = _undefined,
    Object? episode = _undefined,
    Object? movie = _undefined,
    Object? $__typename = _undefined,
  }) => _then(
    Fragment$fragmentPlayQueue$playQueueItems(
      id: id == _undefined || id == null ? _instance.id : (id as String),
      episode: episode == _undefined
          ? _instance.episode
          : (episode as Fragment$fragmentEpisode?),
      movie: movie == _undefined
          ? _instance.movie
          : (movie as Fragment$fragmentPlayQueue$playQueueItems$movie?),
      $__typename: $__typename == _undefined || $__typename == null
          ? _instance.$__typename
          : ($__typename as String),
    ),
  );

  CopyWith$Fragment$fragmentEpisode<TRes> get episode {
    final local$episode = _instance.episode;
    return local$episode == null
        ? CopyWith$Fragment$fragmentEpisode.stub(_then(_instance))
        : CopyWith$Fragment$fragmentEpisode(
            local$episode,
            (e) => call(episode: e),
          );
  }

  CopyWith$Fragment$fragmentPlayQueue$playQueueItems$movie<TRes> get movie {
    final local$movie = _instance.movie;
    return local$movie == null
        ? CopyWith$Fragment$fragmentPlayQueue$playQueueItems$movie.stub(
            _then(_instance),
          )
        : CopyWith$Fragment$fragmentPlayQueue$playQueueItems$movie(
            local$movie,
            (e) => call(movie: e),
          );
  }
}

class _CopyWithStubImpl$Fragment$fragmentPlayQueue$playQueueItems<TRes>
    implements CopyWith$Fragment$fragmentPlayQueue$playQueueItems<TRes> {
  _CopyWithStubImpl$Fragment$fragmentPlayQueue$playQueueItems(this._res);

  TRes _res;

  call({
    String? id,
    Fragment$fragmentEpisode? episode,
    Fragment$fragmentPlayQueue$playQueueItems$movie? movie,
    String? $__typename,
  }) => _res;

  CopyWith$Fragment$fragmentEpisode<TRes> get episode =>
      CopyWith$Fragment$fragmentEpisode.stub(_res);

  CopyWith$Fragment$fragmentPlayQueue$playQueueItems$movie<TRes> get movie =>
      CopyWith$Fragment$fragmentPlayQueue$playQueueItems$movie.stub(_res);
}

class Fragment$fragmentPlayQueue$playQueueItems$movie {
  Fragment$fragmentPlayQueue$playQueueItems$movie({
    required this.id,
    this.metadata,
    this.images,
    this.mediaFile,
    this.$__typename = 'Movie',
  });

  factory Fragment$fragmentPlayQueue$playQueueItems$movie.fromJson(
    Map<String, dynamic> json,
  ) {
    final l$id = json['id'];
    final l$metadata = json['metadata'];
    final l$images = json['images'];
    final l$mediaFile = json['mediaFile'];
    final l$$__typename = json['__typename'];
    return Fragment$fragmentPlayQueue$playQueueItems$movie(
      id: (l$id as String),
      metadata: (l$metadata as List<dynamic>?)
          ?.map(
            (e) =>
                Fragment$fragmentMetadata.fromJson((e as Map<String, dynamic>)),
          )
          .toList(),
      images: (l$images as List<dynamic>?)
          ?.map(
            (e) =>
                Fragment$fragmentImages.fromJson((e as Map<String, dynamic>)),
          )
          .toList(),
      mediaFile: (l$mediaFile as List<dynamic>?)
          ?.map(
            (e) => Fragment$fragmentMediaFiles.fromJson(
              (e as Map<String, dynamic>),
            ),
          )
          .toList(),
      $__typename: (l$$__typename as String),
    );
  }

  final String id;

  final List<Fragment$fragmentMetadata>? metadata;

  final List<Fragment$fragmentImages>? images;

  final List<Fragment$fragmentMediaFiles>? mediaFile;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$id = id;
    _resultData['id'] = l$id;
    final l$metadata = metadata;
    _resultData['metadata'] = l$metadata?.map((e) => e.toJson()).toList();
    final l$images = images;
    _resultData['images'] = l$images?.map((e) => e.toJson()).toList();
    final l$mediaFile = mediaFile;
    _resultData['mediaFile'] = l$mediaFile?.map((e) => e.toJson()).toList();
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$id = id;
    final l$metadata = metadata;
    final l$images = images;
    final l$mediaFile = mediaFile;
    final l$$__typename = $__typename;
    return Object.hashAll([
      l$id,
      l$metadata == null ? null : Object.hashAll(l$metadata.map((v) => v)),
      l$images == null ? null : Object.hashAll(l$images.map((v) => v)),
      l$mediaFile == null ? null : Object.hashAll(l$mediaFile.map((v) => v)),
      l$$__typename,
    ]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Fragment$fragmentPlayQueue$playQueueItems$movie ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$id = id;
    final lOther$id = other.id;
    if (l$id != lOther$id) {
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
    final l$mediaFile = mediaFile;
    final lOther$mediaFile = other.mediaFile;
    if (l$mediaFile != null && lOther$mediaFile != null) {
      if (l$mediaFile.length != lOther$mediaFile.length) {
        return false;
      }
      for (int i = 0; i < l$mediaFile.length; i++) {
        final l$mediaFile$entry = l$mediaFile[i];
        final lOther$mediaFile$entry = lOther$mediaFile[i];
        if (l$mediaFile$entry != lOther$mediaFile$entry) {
          return false;
        }
      }
    } else if (l$mediaFile != lOther$mediaFile) {
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

extension UtilityExtension$Fragment$fragmentPlayQueue$playQueueItems$movie
    on Fragment$fragmentPlayQueue$playQueueItems$movie {
  CopyWith$Fragment$fragmentPlayQueue$playQueueItems$movie<
    Fragment$fragmentPlayQueue$playQueueItems$movie
  >
  get copyWith =>
      CopyWith$Fragment$fragmentPlayQueue$playQueueItems$movie(this, (i) => i);
}

abstract class CopyWith$Fragment$fragmentPlayQueue$playQueueItems$movie<TRes> {
  factory CopyWith$Fragment$fragmentPlayQueue$playQueueItems$movie(
    Fragment$fragmentPlayQueue$playQueueItems$movie instance,
    TRes Function(Fragment$fragmentPlayQueue$playQueueItems$movie) then,
  ) = _CopyWithImpl$Fragment$fragmentPlayQueue$playQueueItems$movie;

  factory CopyWith$Fragment$fragmentPlayQueue$playQueueItems$movie.stub(
    TRes res,
  ) = _CopyWithStubImpl$Fragment$fragmentPlayQueue$playQueueItems$movie;

  TRes call({
    String? id,
    List<Fragment$fragmentMetadata>? metadata,
    List<Fragment$fragmentImages>? images,
    List<Fragment$fragmentMediaFiles>? mediaFile,
    String? $__typename,
  });
  TRes metadata(
    Iterable<Fragment$fragmentMetadata>? Function(
      Iterable<CopyWith$Fragment$fragmentMetadata<Fragment$fragmentMetadata>>?,
    )
    _fn,
  );
  TRes images(
    Iterable<Fragment$fragmentImages>? Function(
      Iterable<CopyWith$Fragment$fragmentImages<Fragment$fragmentImages>>?,
    )
    _fn,
  );
  TRes mediaFile(
    Iterable<Fragment$fragmentMediaFiles>? Function(
      Iterable<
        CopyWith$Fragment$fragmentMediaFiles<Fragment$fragmentMediaFiles>
      >?,
    )
    _fn,
  );
}

class _CopyWithImpl$Fragment$fragmentPlayQueue$playQueueItems$movie<TRes>
    implements CopyWith$Fragment$fragmentPlayQueue$playQueueItems$movie<TRes> {
  _CopyWithImpl$Fragment$fragmentPlayQueue$playQueueItems$movie(
    this._instance,
    this._then,
  );

  final Fragment$fragmentPlayQueue$playQueueItems$movie _instance;

  final TRes Function(Fragment$fragmentPlayQueue$playQueueItems$movie) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? id = _undefined,
    Object? metadata = _undefined,
    Object? images = _undefined,
    Object? mediaFile = _undefined,
    Object? $__typename = _undefined,
  }) => _then(
    Fragment$fragmentPlayQueue$playQueueItems$movie(
      id: id == _undefined || id == null ? _instance.id : (id as String),
      metadata: metadata == _undefined
          ? _instance.metadata
          : (metadata as List<Fragment$fragmentMetadata>?),
      images: images == _undefined
          ? _instance.images
          : (images as List<Fragment$fragmentImages>?),
      mediaFile: mediaFile == _undefined
          ? _instance.mediaFile
          : (mediaFile as List<Fragment$fragmentMediaFiles>?),
      $__typename: $__typename == _undefined || $__typename == null
          ? _instance.$__typename
          : ($__typename as String),
    ),
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

  TRes mediaFile(
    Iterable<Fragment$fragmentMediaFiles>? Function(
      Iterable<
        CopyWith$Fragment$fragmentMediaFiles<Fragment$fragmentMediaFiles>
      >?,
    )
    _fn,
  ) => call(
    mediaFile: _fn(
      _instance.mediaFile?.map(
        (e) => CopyWith$Fragment$fragmentMediaFiles(e, (i) => i),
      ),
    )?.toList(),
  );
}

class _CopyWithStubImpl$Fragment$fragmentPlayQueue$playQueueItems$movie<TRes>
    implements CopyWith$Fragment$fragmentPlayQueue$playQueueItems$movie<TRes> {
  _CopyWithStubImpl$Fragment$fragmentPlayQueue$playQueueItems$movie(this._res);

  TRes _res;

  call({
    String? id,
    List<Fragment$fragmentMetadata>? metadata,
    List<Fragment$fragmentImages>? images,
    List<Fragment$fragmentMediaFiles>? mediaFile,
    String? $__typename,
  }) => _res;

  metadata(_fn) => _res;

  images(_fn) => _res;

  mediaFile(_fn) => _res;
}

import 'fragmentCredit.graphql.dart';
import 'fragmentEpisode.graphql.dart';
import 'fragmentImages.graphql.dart';
import 'fragmentMediafiles.graphql.dart';
import 'fragmentMetadata.graphql.dart';
import 'fragmentMovie.graphql.dart';
import 'fragmentWatchStatus.graphql.dart';
import 'package:gql/ast.dart';
import 'schema.graphql.dart';

class Fragment$fragmentPlayQueue {
  Fragment$fragmentPlayQueue({
    required this.id,
    this.currentItemId,
    required this.shuffle,
    this.sourceType,
    required this.sourceExhausted,
    this.playQueueItems,
    this.$__typename = 'PlayQueue',
  });

  factory Fragment$fragmentPlayQueue.fromJson(Map<String, dynamic> json) {
    final l$id = json['id'];
    final l$currentItemId = json['currentItemId'];
    final l$shuffle = json['shuffle'];
    final l$sourceType = json['sourceType'];
    final l$sourceExhausted = json['sourceExhausted'];
    final l$playQueueItems = json['playQueueItems'];
    final l$$__typename = json['__typename'];
    return Fragment$fragmentPlayQueue(
      id: (l$id as String),
      currentItemId: (l$currentItemId as String?),
      shuffle: (l$shuffle as bool),
      sourceType: l$sourceType == null
          ? null
          : fromJson$Enum$PlayQueueSourceType((l$sourceType as String)),
      sourceExhausted: (l$sourceExhausted as bool),
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

  final bool shuffle;

  final Enum$PlayQueueSourceType? sourceType;

  final bool sourceExhausted;

  final List<Fragment$fragmentPlayQueue$playQueueItems>? playQueueItems;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$id = id;
    _resultData['id'] = l$id;
    final l$currentItemId = currentItemId;
    _resultData['currentItemId'] = l$currentItemId;
    final l$shuffle = shuffle;
    _resultData['shuffle'] = l$shuffle;
    final l$sourceType = sourceType;
    _resultData['sourceType'] = l$sourceType == null
        ? null
        : toJson$Enum$PlayQueueSourceType(l$sourceType);
    final l$sourceExhausted = sourceExhausted;
    _resultData['sourceExhausted'] = l$sourceExhausted;
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
    final l$shuffle = shuffle;
    final l$sourceType = sourceType;
    final l$sourceExhausted = sourceExhausted;
    final l$playQueueItems = playQueueItems;
    final l$$__typename = $__typename;
    return Object.hashAll([
      l$id,
      l$currentItemId,
      l$shuffle,
      l$sourceType,
      l$sourceExhausted,
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
    final l$shuffle = shuffle;
    final lOther$shuffle = other.shuffle;
    if (l$shuffle != lOther$shuffle) {
      return false;
    }
    final l$sourceType = sourceType;
    final lOther$sourceType = other.sourceType;
    if (l$sourceType != lOther$sourceType) {
      return false;
    }
    final l$sourceExhausted = sourceExhausted;
    final lOther$sourceExhausted = other.sourceExhausted;
    if (l$sourceExhausted != lOther$sourceExhausted) {
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
    bool? shuffle,
    Enum$PlayQueueSourceType? sourceType,
    bool? sourceExhausted,
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
    Object? shuffle = _undefined,
    Object? sourceType = _undefined,
    Object? sourceExhausted = _undefined,
    Object? playQueueItems = _undefined,
    Object? $__typename = _undefined,
  }) => _then(
    Fragment$fragmentPlayQueue(
      id: id == _undefined || id == null ? _instance.id : (id as String),
      currentItemId: currentItemId == _undefined
          ? _instance.currentItemId
          : (currentItemId as String?),
      shuffle: shuffle == _undefined || shuffle == null
          ? _instance.shuffle
          : (shuffle as bool),
      sourceType: sourceType == _undefined
          ? _instance.sourceType
          : (sourceType as Enum$PlayQueueSourceType?),
      sourceExhausted: sourceExhausted == _undefined || sourceExhausted == null
          ? _instance.sourceExhausted
          : (sourceExhausted as bool),
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
    bool? shuffle,
    Enum$PlayQueueSourceType? sourceType,
    bool? sourceExhausted,
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
        name: NameNode(value: 'shuffle'),
        alias: null,
        arguments: [],
        directives: [],
        selectionSet: null,
      ),
      FieldNode(
        name: NameNode(value: 'sourceType'),
        alias: null,
        arguments: [],
        directives: [],
        selectionSet: null,
      ),
      FieldNode(
        name: NameNode(value: 'sourceExhausted'),
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
              name: NameNode(value: 'position'),
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
                  FragmentSpreadNode(
                    name: NameNode(value: 'fragmentMovie'),
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
              name: NameNode(value: 'track'),
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
                    name: NameNode(value: 'number'),
                    alias: null,
                    arguments: [],
                    directives: [],
                    selectionSet: null,
                  ),
                  FieldNode(
                    name: NameNode(value: 'discNumber'),
                    alias: null,
                    arguments: [],
                    directives: [],
                    selectionSet: null,
                  ),
                  FieldNode(
                    name: NameNode(value: 'artist'),
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
                    name: NameNode(value: 'album'),
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
            ),
            FieldNode(
              name: NameNode(value: 'chapter'),
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
                    name: NameNode(value: 'number'),
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
                    name: NameNode(value: 'book'),
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
                    name: NameNode(value: 'watchStatus'),
                    alias: null,
                    arguments: [],
                    directives: [],
                    selectionSet: SelectionSetNode(
                      selections: [
                        FragmentSpreadNode(
                          name: NameNode(value: 'fragmentWatchStatus'),
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
              name: NameNode(value: 'podcastEpisode'),
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
                    name: NameNode(value: 'publishedAt'),
                    alias: null,
                    arguments: [],
                    directives: [],
                    selectionSet: null,
                  ),
                  FieldNode(
                    name: NameNode(value: 'podcast'),
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
                    name: NameNode(value: 'watchStatus'),
                    alias: null,
                    arguments: [],
                    directives: [],
                    selectionSet: SelectionSetNode(
                      selections: [
                        FragmentSpreadNode(
                          name: NameNode(value: 'fragmentWatchStatus'),
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
    fragmentDefinitionfragmentCastMember,
    fragmentDefinitionfragmentMovie,
    fragmentDefinitionfragmentWatchStatus,
  ],
);

class Fragment$fragmentPlayQueue$playQueueItems {
  Fragment$fragmentPlayQueue$playQueueItems({
    required this.id,
    required this.position,
    this.episode,
    this.movie,
    this.track,
    this.chapter,
    this.podcastEpisode,
    this.$__typename = 'PlayQueueItem',
  });

  factory Fragment$fragmentPlayQueue$playQueueItems.fromJson(
    Map<String, dynamic> json,
  ) {
    final l$id = json['id'];
    final l$position = json['position'];
    final l$episode = json['episode'];
    final l$movie = json['movie'];
    final l$track = json['track'];
    final l$chapter = json['chapter'];
    final l$podcastEpisode = json['podcastEpisode'];
    final l$$__typename = json['__typename'];
    return Fragment$fragmentPlayQueue$playQueueItems(
      id: (l$id as String),
      position: (l$position as num).toDouble(),
      episode: l$episode == null
          ? null
          : Fragment$fragmentEpisode.fromJson(
              (l$episode as Map<String, dynamic>),
            ),
      movie: l$movie == null
          ? null
          : Fragment$fragmentMovie.fromJson((l$movie as Map<String, dynamic>)),
      track: l$track == null
          ? null
          : Fragment$fragmentPlayQueue$playQueueItems$track.fromJson(
              (l$track as Map<String, dynamic>),
            ),
      chapter: l$chapter == null
          ? null
          : Fragment$fragmentPlayQueue$playQueueItems$chapter.fromJson(
              (l$chapter as Map<String, dynamic>),
            ),
      podcastEpisode: l$podcastEpisode == null
          ? null
          : Fragment$fragmentPlayQueue$playQueueItems$podcastEpisode.fromJson(
              (l$podcastEpisode as Map<String, dynamic>),
            ),
      $__typename: (l$$__typename as String),
    );
  }

  final String id;

  final double position;

  final Fragment$fragmentEpisode? episode;

  final Fragment$fragmentMovie? movie;

  final Fragment$fragmentPlayQueue$playQueueItems$track? track;

  final Fragment$fragmentPlayQueue$playQueueItems$chapter? chapter;

  final Fragment$fragmentPlayQueue$playQueueItems$podcastEpisode?
  podcastEpisode;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$id = id;
    _resultData['id'] = l$id;
    final l$position = position;
    _resultData['position'] = l$position;
    final l$episode = episode;
    _resultData['episode'] = l$episode?.toJson();
    final l$movie = movie;
    _resultData['movie'] = l$movie?.toJson();
    final l$track = track;
    _resultData['track'] = l$track?.toJson();
    final l$chapter = chapter;
    _resultData['chapter'] = l$chapter?.toJson();
    final l$podcastEpisode = podcastEpisode;
    _resultData['podcastEpisode'] = l$podcastEpisode?.toJson();
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$id = id;
    final l$position = position;
    final l$episode = episode;
    final l$movie = movie;
    final l$track = track;
    final l$chapter = chapter;
    final l$podcastEpisode = podcastEpisode;
    final l$$__typename = $__typename;
    return Object.hashAll([
      l$id,
      l$position,
      l$episode,
      l$movie,
      l$track,
      l$chapter,
      l$podcastEpisode,
      l$$__typename,
    ]);
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
    final l$position = position;
    final lOther$position = other.position;
    if (l$position != lOther$position) {
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
    final l$track = track;
    final lOther$track = other.track;
    if (l$track != lOther$track) {
      return false;
    }
    final l$chapter = chapter;
    final lOther$chapter = other.chapter;
    if (l$chapter != lOther$chapter) {
      return false;
    }
    final l$podcastEpisode = podcastEpisode;
    final lOther$podcastEpisode = other.podcastEpisode;
    if (l$podcastEpisode != lOther$podcastEpisode) {
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
    double? position,
    Fragment$fragmentEpisode? episode,
    Fragment$fragmentMovie? movie,
    Fragment$fragmentPlayQueue$playQueueItems$track? track,
    Fragment$fragmentPlayQueue$playQueueItems$chapter? chapter,
    Fragment$fragmentPlayQueue$playQueueItems$podcastEpisode? podcastEpisode,
    String? $__typename,
  });
  CopyWith$Fragment$fragmentEpisode<TRes> get episode;
  CopyWith$Fragment$fragmentMovie<TRes> get movie;
  CopyWith$Fragment$fragmentPlayQueue$playQueueItems$track<TRes> get track;
  CopyWith$Fragment$fragmentPlayQueue$playQueueItems$chapter<TRes> get chapter;
  CopyWith$Fragment$fragmentPlayQueue$playQueueItems$podcastEpisode<TRes>
  get podcastEpisode;
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
    Object? position = _undefined,
    Object? episode = _undefined,
    Object? movie = _undefined,
    Object? track = _undefined,
    Object? chapter = _undefined,
    Object? podcastEpisode = _undefined,
    Object? $__typename = _undefined,
  }) => _then(
    Fragment$fragmentPlayQueue$playQueueItems(
      id: id == _undefined || id == null ? _instance.id : (id as String),
      position: position == _undefined || position == null
          ? _instance.position
          : (position as double),
      episode: episode == _undefined
          ? _instance.episode
          : (episode as Fragment$fragmentEpisode?),
      movie: movie == _undefined
          ? _instance.movie
          : (movie as Fragment$fragmentMovie?),
      track: track == _undefined
          ? _instance.track
          : (track as Fragment$fragmentPlayQueue$playQueueItems$track?),
      chapter: chapter == _undefined
          ? _instance.chapter
          : (chapter as Fragment$fragmentPlayQueue$playQueueItems$chapter?),
      podcastEpisode: podcastEpisode == _undefined
          ? _instance.podcastEpisode
          : (podcastEpisode
                as Fragment$fragmentPlayQueue$playQueueItems$podcastEpisode?),
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

  CopyWith$Fragment$fragmentMovie<TRes> get movie {
    final local$movie = _instance.movie;
    return local$movie == null
        ? CopyWith$Fragment$fragmentMovie.stub(_then(_instance))
        : CopyWith$Fragment$fragmentMovie(local$movie, (e) => call(movie: e));
  }

  CopyWith$Fragment$fragmentPlayQueue$playQueueItems$track<TRes> get track {
    final local$track = _instance.track;
    return local$track == null
        ? CopyWith$Fragment$fragmentPlayQueue$playQueueItems$track.stub(
            _then(_instance),
          )
        : CopyWith$Fragment$fragmentPlayQueue$playQueueItems$track(
            local$track,
            (e) => call(track: e),
          );
  }

  CopyWith$Fragment$fragmentPlayQueue$playQueueItems$chapter<TRes> get chapter {
    final local$chapter = _instance.chapter;
    return local$chapter == null
        ? CopyWith$Fragment$fragmentPlayQueue$playQueueItems$chapter.stub(
            _then(_instance),
          )
        : CopyWith$Fragment$fragmentPlayQueue$playQueueItems$chapter(
            local$chapter,
            (e) => call(chapter: e),
          );
  }

  CopyWith$Fragment$fragmentPlayQueue$playQueueItems$podcastEpisode<TRes>
  get podcastEpisode {
    final local$podcastEpisode = _instance.podcastEpisode;
    return local$podcastEpisode == null
        ? CopyWith$Fragment$fragmentPlayQueue$playQueueItems$podcastEpisode.stub(
            _then(_instance),
          )
        : CopyWith$Fragment$fragmentPlayQueue$playQueueItems$podcastEpisode(
            local$podcastEpisode,
            (e) => call(podcastEpisode: e),
          );
  }
}

class _CopyWithStubImpl$Fragment$fragmentPlayQueue$playQueueItems<TRes>
    implements CopyWith$Fragment$fragmentPlayQueue$playQueueItems<TRes> {
  _CopyWithStubImpl$Fragment$fragmentPlayQueue$playQueueItems(this._res);

  TRes _res;

  call({
    String? id,
    double? position,
    Fragment$fragmentEpisode? episode,
    Fragment$fragmentMovie? movie,
    Fragment$fragmentPlayQueue$playQueueItems$track? track,
    Fragment$fragmentPlayQueue$playQueueItems$chapter? chapter,
    Fragment$fragmentPlayQueue$playQueueItems$podcastEpisode? podcastEpisode,
    String? $__typename,
  }) => _res;

  CopyWith$Fragment$fragmentEpisode<TRes> get episode =>
      CopyWith$Fragment$fragmentEpisode.stub(_res);

  CopyWith$Fragment$fragmentMovie<TRes> get movie =>
      CopyWith$Fragment$fragmentMovie.stub(_res);

  CopyWith$Fragment$fragmentPlayQueue$playQueueItems$track<TRes> get track =>
      CopyWith$Fragment$fragmentPlayQueue$playQueueItems$track.stub(_res);

  CopyWith$Fragment$fragmentPlayQueue$playQueueItems$chapter<TRes>
  get chapter =>
      CopyWith$Fragment$fragmentPlayQueue$playQueueItems$chapter.stub(_res);

  CopyWith$Fragment$fragmentPlayQueue$playQueueItems$podcastEpisode<TRes>
  get podcastEpisode =>
      CopyWith$Fragment$fragmentPlayQueue$playQueueItems$podcastEpisode.stub(
        _res,
      );
}

class Fragment$fragmentPlayQueue$playQueueItems$track {
  Fragment$fragmentPlayQueue$playQueueItems$track({
    required this.id,
    required this.number,
    required this.discNumber,
    required this.artist,
    required this.album,
    this.metadata,
    this.mediaFile,
    this.rating,
    this.$__typename = 'Track',
  });

  factory Fragment$fragmentPlayQueue$playQueueItems$track.fromJson(
    Map<String, dynamic> json,
  ) {
    final l$id = json['id'];
    final l$number = json['number'];
    final l$discNumber = json['discNumber'];
    final l$artist = json['artist'];
    final l$album = json['album'];
    final l$metadata = json['metadata'];
    final l$mediaFile = json['mediaFile'];
    final l$rating = json['rating'];
    final l$$__typename = json['__typename'];
    return Fragment$fragmentPlayQueue$playQueueItems$track(
      id: (l$id as String),
      number: (l$number as int),
      discNumber: (l$discNumber as int),
      artist: Fragment$fragmentPlayQueue$playQueueItems$track$artist.fromJson(
        (l$artist as Map<String, dynamic>),
      ),
      album: Fragment$fragmentPlayQueue$playQueueItems$track$album.fromJson(
        (l$album as Map<String, dynamic>),
      ),
      metadata: (l$metadata as List<dynamic>?)
          ?.map(
            (e) =>
                Fragment$fragmentMetadata.fromJson((e as Map<String, dynamic>)),
          )
          .toList(),
      mediaFile: (l$mediaFile as List<dynamic>?)
          ?.map(
            (e) => Fragment$fragmentMediaFiles.fromJson(
              (e as Map<String, dynamic>),
            ),
          )
          .toList(),
      rating: (l$rating as int?),
      $__typename: (l$$__typename as String),
    );
  }

  final String id;

  final int number;

  final int discNumber;

  final Fragment$fragmentPlayQueue$playQueueItems$track$artist artist;

  final Fragment$fragmentPlayQueue$playQueueItems$track$album album;

  final List<Fragment$fragmentMetadata>? metadata;

  final List<Fragment$fragmentMediaFiles>? mediaFile;

  final int? rating;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$id = id;
    _resultData['id'] = l$id;
    final l$number = number;
    _resultData['number'] = l$number;
    final l$discNumber = discNumber;
    _resultData['discNumber'] = l$discNumber;
    final l$artist = artist;
    _resultData['artist'] = l$artist.toJson();
    final l$album = album;
    _resultData['album'] = l$album.toJson();
    final l$metadata = metadata;
    _resultData['metadata'] = l$metadata?.map((e) => e.toJson()).toList();
    final l$mediaFile = mediaFile;
    _resultData['mediaFile'] = l$mediaFile?.map((e) => e.toJson()).toList();
    final l$rating = rating;
    _resultData['rating'] = l$rating;
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$id = id;
    final l$number = number;
    final l$discNumber = discNumber;
    final l$artist = artist;
    final l$album = album;
    final l$metadata = metadata;
    final l$mediaFile = mediaFile;
    final l$rating = rating;
    final l$$__typename = $__typename;
    return Object.hashAll([
      l$id,
      l$number,
      l$discNumber,
      l$artist,
      l$album,
      l$metadata == null ? null : Object.hashAll(l$metadata.map((v) => v)),
      l$mediaFile == null ? null : Object.hashAll(l$mediaFile.map((v) => v)),
      l$rating,
      l$$__typename,
    ]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Fragment$fragmentPlayQueue$playQueueItems$track ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$id = id;
    final lOther$id = other.id;
    if (l$id != lOther$id) {
      return false;
    }
    final l$number = number;
    final lOther$number = other.number;
    if (l$number != lOther$number) {
      return false;
    }
    final l$discNumber = discNumber;
    final lOther$discNumber = other.discNumber;
    if (l$discNumber != lOther$discNumber) {
      return false;
    }
    final l$artist = artist;
    final lOther$artist = other.artist;
    if (l$artist != lOther$artist) {
      return false;
    }
    final l$album = album;
    final lOther$album = other.album;
    if (l$album != lOther$album) {
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

extension UtilityExtension$Fragment$fragmentPlayQueue$playQueueItems$track
    on Fragment$fragmentPlayQueue$playQueueItems$track {
  CopyWith$Fragment$fragmentPlayQueue$playQueueItems$track<
    Fragment$fragmentPlayQueue$playQueueItems$track
  >
  get copyWith =>
      CopyWith$Fragment$fragmentPlayQueue$playQueueItems$track(this, (i) => i);
}

abstract class CopyWith$Fragment$fragmentPlayQueue$playQueueItems$track<TRes> {
  factory CopyWith$Fragment$fragmentPlayQueue$playQueueItems$track(
    Fragment$fragmentPlayQueue$playQueueItems$track instance,
    TRes Function(Fragment$fragmentPlayQueue$playQueueItems$track) then,
  ) = _CopyWithImpl$Fragment$fragmentPlayQueue$playQueueItems$track;

  factory CopyWith$Fragment$fragmentPlayQueue$playQueueItems$track.stub(
    TRes res,
  ) = _CopyWithStubImpl$Fragment$fragmentPlayQueue$playQueueItems$track;

  TRes call({
    String? id,
    int? number,
    int? discNumber,
    Fragment$fragmentPlayQueue$playQueueItems$track$artist? artist,
    Fragment$fragmentPlayQueue$playQueueItems$track$album? album,
    List<Fragment$fragmentMetadata>? metadata,
    List<Fragment$fragmentMediaFiles>? mediaFile,
    int? rating,
    String? $__typename,
  });
  CopyWith$Fragment$fragmentPlayQueue$playQueueItems$track$artist<TRes>
  get artist;
  CopyWith$Fragment$fragmentPlayQueue$playQueueItems$track$album<TRes>
  get album;
  TRes metadata(
    Iterable<Fragment$fragmentMetadata>? Function(
      Iterable<CopyWith$Fragment$fragmentMetadata<Fragment$fragmentMetadata>>?,
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

class _CopyWithImpl$Fragment$fragmentPlayQueue$playQueueItems$track<TRes>
    implements CopyWith$Fragment$fragmentPlayQueue$playQueueItems$track<TRes> {
  _CopyWithImpl$Fragment$fragmentPlayQueue$playQueueItems$track(
    this._instance,
    this._then,
  );

  final Fragment$fragmentPlayQueue$playQueueItems$track _instance;

  final TRes Function(Fragment$fragmentPlayQueue$playQueueItems$track) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? id = _undefined,
    Object? number = _undefined,
    Object? discNumber = _undefined,
    Object? artist = _undefined,
    Object? album = _undefined,
    Object? metadata = _undefined,
    Object? mediaFile = _undefined,
    Object? rating = _undefined,
    Object? $__typename = _undefined,
  }) => _then(
    Fragment$fragmentPlayQueue$playQueueItems$track(
      id: id == _undefined || id == null ? _instance.id : (id as String),
      number: number == _undefined || number == null
          ? _instance.number
          : (number as int),
      discNumber: discNumber == _undefined || discNumber == null
          ? _instance.discNumber
          : (discNumber as int),
      artist: artist == _undefined || artist == null
          ? _instance.artist
          : (artist as Fragment$fragmentPlayQueue$playQueueItems$track$artist),
      album: album == _undefined || album == null
          ? _instance.album
          : (album as Fragment$fragmentPlayQueue$playQueueItems$track$album),
      metadata: metadata == _undefined
          ? _instance.metadata
          : (metadata as List<Fragment$fragmentMetadata>?),
      mediaFile: mediaFile == _undefined
          ? _instance.mediaFile
          : (mediaFile as List<Fragment$fragmentMediaFiles>?),
      rating: rating == _undefined ? _instance.rating : (rating as int?),
      $__typename: $__typename == _undefined || $__typename == null
          ? _instance.$__typename
          : ($__typename as String),
    ),
  );

  CopyWith$Fragment$fragmentPlayQueue$playQueueItems$track$artist<TRes>
  get artist {
    final local$artist = _instance.artist;
    return CopyWith$Fragment$fragmentPlayQueue$playQueueItems$track$artist(
      local$artist,
      (e) => call(artist: e),
    );
  }

  CopyWith$Fragment$fragmentPlayQueue$playQueueItems$track$album<TRes>
  get album {
    final local$album = _instance.album;
    return CopyWith$Fragment$fragmentPlayQueue$playQueueItems$track$album(
      local$album,
      (e) => call(album: e),
    );
  }

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

class _CopyWithStubImpl$Fragment$fragmentPlayQueue$playQueueItems$track<TRes>
    implements CopyWith$Fragment$fragmentPlayQueue$playQueueItems$track<TRes> {
  _CopyWithStubImpl$Fragment$fragmentPlayQueue$playQueueItems$track(this._res);

  TRes _res;

  call({
    String? id,
    int? number,
    int? discNumber,
    Fragment$fragmentPlayQueue$playQueueItems$track$artist? artist,
    Fragment$fragmentPlayQueue$playQueueItems$track$album? album,
    List<Fragment$fragmentMetadata>? metadata,
    List<Fragment$fragmentMediaFiles>? mediaFile,
    int? rating,
    String? $__typename,
  }) => _res;

  CopyWith$Fragment$fragmentPlayQueue$playQueueItems$track$artist<TRes>
  get artist =>
      CopyWith$Fragment$fragmentPlayQueue$playQueueItems$track$artist.stub(
        _res,
      );

  CopyWith$Fragment$fragmentPlayQueue$playQueueItems$track$album<TRes>
  get album =>
      CopyWith$Fragment$fragmentPlayQueue$playQueueItems$track$album.stub(_res);

  metadata(_fn) => _res;

  mediaFile(_fn) => _res;
}

class Fragment$fragmentPlayQueue$playQueueItems$track$artist {
  Fragment$fragmentPlayQueue$playQueueItems$track$artist({
    required this.id,
    required this.name,
    this.$__typename = 'Person',
  });

  factory Fragment$fragmentPlayQueue$playQueueItems$track$artist.fromJson(
    Map<String, dynamic> json,
  ) {
    final l$id = json['id'];
    final l$name = json['name'];
    final l$$__typename = json['__typename'];
    return Fragment$fragmentPlayQueue$playQueueItems$track$artist(
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
    if (other is! Fragment$fragmentPlayQueue$playQueueItems$track$artist ||
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

extension UtilityExtension$Fragment$fragmentPlayQueue$playQueueItems$track$artist
    on Fragment$fragmentPlayQueue$playQueueItems$track$artist {
  CopyWith$Fragment$fragmentPlayQueue$playQueueItems$track$artist<
    Fragment$fragmentPlayQueue$playQueueItems$track$artist
  >
  get copyWith =>
      CopyWith$Fragment$fragmentPlayQueue$playQueueItems$track$artist(
        this,
        (i) => i,
      );
}

abstract class CopyWith$Fragment$fragmentPlayQueue$playQueueItems$track$artist<
  TRes
> {
  factory CopyWith$Fragment$fragmentPlayQueue$playQueueItems$track$artist(
    Fragment$fragmentPlayQueue$playQueueItems$track$artist instance,
    TRes Function(Fragment$fragmentPlayQueue$playQueueItems$track$artist) then,
  ) = _CopyWithImpl$Fragment$fragmentPlayQueue$playQueueItems$track$artist;

  factory CopyWith$Fragment$fragmentPlayQueue$playQueueItems$track$artist.stub(
    TRes res,
  ) = _CopyWithStubImpl$Fragment$fragmentPlayQueue$playQueueItems$track$artist;

  TRes call({String? id, String? name, String? $__typename});
}

class _CopyWithImpl$Fragment$fragmentPlayQueue$playQueueItems$track$artist<TRes>
    implements
        CopyWith$Fragment$fragmentPlayQueue$playQueueItems$track$artist<TRes> {
  _CopyWithImpl$Fragment$fragmentPlayQueue$playQueueItems$track$artist(
    this._instance,
    this._then,
  );

  final Fragment$fragmentPlayQueue$playQueueItems$track$artist _instance;

  final TRes Function(Fragment$fragmentPlayQueue$playQueueItems$track$artist)
  _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? id = _undefined,
    Object? name = _undefined,
    Object? $__typename = _undefined,
  }) => _then(
    Fragment$fragmentPlayQueue$playQueueItems$track$artist(
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

class _CopyWithStubImpl$Fragment$fragmentPlayQueue$playQueueItems$track$artist<
  TRes
>
    implements
        CopyWith$Fragment$fragmentPlayQueue$playQueueItems$track$artist<TRes> {
  _CopyWithStubImpl$Fragment$fragmentPlayQueue$playQueueItems$track$artist(
    this._res,
  );

  TRes _res;

  call({String? id, String? name, String? $__typename}) => _res;
}

class Fragment$fragmentPlayQueue$playQueueItems$track$album {
  Fragment$fragmentPlayQueue$playQueueItems$track$album({
    required this.id,
    required this.name,
    this.images,
    this.$__typename = 'Album',
  });

  factory Fragment$fragmentPlayQueue$playQueueItems$track$album.fromJson(
    Map<String, dynamic> json,
  ) {
    final l$id = json['id'];
    final l$name = json['name'];
    final l$images = json['images'];
    final l$$__typename = json['__typename'];
    return Fragment$fragmentPlayQueue$playQueueItems$track$album(
      id: (l$id as String),
      name: (l$name as String),
      images: (l$images as List<dynamic>?)
          ?.map(
            (e) =>
                Fragment$fragmentImages.fromJson((e as Map<String, dynamic>)),
          )
          .toList(),
      $__typename: (l$$__typename as String),
    );
  }

  final String id;

  final String name;

  final List<Fragment$fragmentImages>? images;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$id = id;
    _resultData['id'] = l$id;
    final l$name = name;
    _resultData['name'] = l$name;
    final l$images = images;
    _resultData['images'] = l$images?.map((e) => e.toJson()).toList();
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$id = id;
    final l$name = name;
    final l$images = images;
    final l$$__typename = $__typename;
    return Object.hashAll([
      l$id,
      l$name,
      l$images == null ? null : Object.hashAll(l$images.map((v) => v)),
      l$$__typename,
    ]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Fragment$fragmentPlayQueue$playQueueItems$track$album ||
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
    final l$$__typename = $__typename;
    final lOther$$__typename = other.$__typename;
    if (l$$__typename != lOther$$__typename) {
      return false;
    }
    return true;
  }
}

extension UtilityExtension$Fragment$fragmentPlayQueue$playQueueItems$track$album
    on Fragment$fragmentPlayQueue$playQueueItems$track$album {
  CopyWith$Fragment$fragmentPlayQueue$playQueueItems$track$album<
    Fragment$fragmentPlayQueue$playQueueItems$track$album
  >
  get copyWith =>
      CopyWith$Fragment$fragmentPlayQueue$playQueueItems$track$album(
        this,
        (i) => i,
      );
}

abstract class CopyWith$Fragment$fragmentPlayQueue$playQueueItems$track$album<
  TRes
> {
  factory CopyWith$Fragment$fragmentPlayQueue$playQueueItems$track$album(
    Fragment$fragmentPlayQueue$playQueueItems$track$album instance,
    TRes Function(Fragment$fragmentPlayQueue$playQueueItems$track$album) then,
  ) = _CopyWithImpl$Fragment$fragmentPlayQueue$playQueueItems$track$album;

  factory CopyWith$Fragment$fragmentPlayQueue$playQueueItems$track$album.stub(
    TRes res,
  ) = _CopyWithStubImpl$Fragment$fragmentPlayQueue$playQueueItems$track$album;

  TRes call({
    String? id,
    String? name,
    List<Fragment$fragmentImages>? images,
    String? $__typename,
  });
  TRes images(
    Iterable<Fragment$fragmentImages>? Function(
      Iterable<CopyWith$Fragment$fragmentImages<Fragment$fragmentImages>>?,
    )
    _fn,
  );
}

class _CopyWithImpl$Fragment$fragmentPlayQueue$playQueueItems$track$album<TRes>
    implements
        CopyWith$Fragment$fragmentPlayQueue$playQueueItems$track$album<TRes> {
  _CopyWithImpl$Fragment$fragmentPlayQueue$playQueueItems$track$album(
    this._instance,
    this._then,
  );

  final Fragment$fragmentPlayQueue$playQueueItems$track$album _instance;

  final TRes Function(Fragment$fragmentPlayQueue$playQueueItems$track$album)
  _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? id = _undefined,
    Object? name = _undefined,
    Object? images = _undefined,
    Object? $__typename = _undefined,
  }) => _then(
    Fragment$fragmentPlayQueue$playQueueItems$track$album(
      id: id == _undefined || id == null ? _instance.id : (id as String),
      name: name == _undefined || name == null
          ? _instance.name
          : (name as String),
      images: images == _undefined
          ? _instance.images
          : (images as List<Fragment$fragmentImages>?),
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
}

class _CopyWithStubImpl$Fragment$fragmentPlayQueue$playQueueItems$track$album<
  TRes
>
    implements
        CopyWith$Fragment$fragmentPlayQueue$playQueueItems$track$album<TRes> {
  _CopyWithStubImpl$Fragment$fragmentPlayQueue$playQueueItems$track$album(
    this._res,
  );

  TRes _res;

  call({
    String? id,
    String? name,
    List<Fragment$fragmentImages>? images,
    String? $__typename,
  }) => _res;

  images(_fn) => _res;
}

class Fragment$fragmentPlayQueue$playQueueItems$chapter {
  Fragment$fragmentPlayQueue$playQueueItems$chapter({
    required this.id,
    required this.number,
    required this.author,
    required this.book,
    this.metadata,
    this.mediaFile,
    this.watchStatus,
    this.$__typename = 'Chapter',
  });

  factory Fragment$fragmentPlayQueue$playQueueItems$chapter.fromJson(
    Map<String, dynamic> json,
  ) {
    final l$id = json['id'];
    final l$number = json['number'];
    final l$author = json['author'];
    final l$book = json['book'];
    final l$metadata = json['metadata'];
    final l$mediaFile = json['mediaFile'];
    final l$watchStatus = json['watchStatus'];
    final l$$__typename = json['__typename'];
    return Fragment$fragmentPlayQueue$playQueueItems$chapter(
      id: (l$id as String),
      number: (l$number as int),
      author: Fragment$fragmentPlayQueue$playQueueItems$chapter$author.fromJson(
        (l$author as Map<String, dynamic>),
      ),
      book: Fragment$fragmentPlayQueue$playQueueItems$chapter$book.fromJson(
        (l$book as Map<String, dynamic>),
      ),
      metadata: (l$metadata as List<dynamic>?)
          ?.map(
            (e) =>
                Fragment$fragmentMetadata.fromJson((e as Map<String, dynamic>)),
          )
          .toList(),
      mediaFile: (l$mediaFile as List<dynamic>?)
          ?.map(
            (e) => Fragment$fragmentMediaFiles.fromJson(
              (e as Map<String, dynamic>),
            ),
          )
          .toList(),
      watchStatus: (l$watchStatus as List<dynamic>?)
          ?.map(
            (e) => Fragment$fragmentWatchStatus.fromJson(
              (e as Map<String, dynamic>),
            ),
          )
          .toList(),
      $__typename: (l$$__typename as String),
    );
  }

  final String id;

  final int number;

  final Fragment$fragmentPlayQueue$playQueueItems$chapter$author author;

  final Fragment$fragmentPlayQueue$playQueueItems$chapter$book book;

  final List<Fragment$fragmentMetadata>? metadata;

  final List<Fragment$fragmentMediaFiles>? mediaFile;

  final List<Fragment$fragmentWatchStatus>? watchStatus;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$id = id;
    _resultData['id'] = l$id;
    final l$number = number;
    _resultData['number'] = l$number;
    final l$author = author;
    _resultData['author'] = l$author.toJson();
    final l$book = book;
    _resultData['book'] = l$book.toJson();
    final l$metadata = metadata;
    _resultData['metadata'] = l$metadata?.map((e) => e.toJson()).toList();
    final l$mediaFile = mediaFile;
    _resultData['mediaFile'] = l$mediaFile?.map((e) => e.toJson()).toList();
    final l$watchStatus = watchStatus;
    _resultData['watchStatus'] = l$watchStatus?.map((e) => e.toJson()).toList();
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$id = id;
    final l$number = number;
    final l$author = author;
    final l$book = book;
    final l$metadata = metadata;
    final l$mediaFile = mediaFile;
    final l$watchStatus = watchStatus;
    final l$$__typename = $__typename;
    return Object.hashAll([
      l$id,
      l$number,
      l$author,
      l$book,
      l$metadata == null ? null : Object.hashAll(l$metadata.map((v) => v)),
      l$mediaFile == null ? null : Object.hashAll(l$mediaFile.map((v) => v)),
      l$watchStatus == null
          ? null
          : Object.hashAll(l$watchStatus.map((v) => v)),
      l$$__typename,
    ]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Fragment$fragmentPlayQueue$playQueueItems$chapter ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$id = id;
    final lOther$id = other.id;
    if (l$id != lOther$id) {
      return false;
    }
    final l$number = number;
    final lOther$number = other.number;
    if (l$number != lOther$number) {
      return false;
    }
    final l$author = author;
    final lOther$author = other.author;
    if (l$author != lOther$author) {
      return false;
    }
    final l$book = book;
    final lOther$book = other.book;
    if (l$book != lOther$book) {
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
    final l$watchStatus = watchStatus;
    final lOther$watchStatus = other.watchStatus;
    if (l$watchStatus != null && lOther$watchStatus != null) {
      if (l$watchStatus.length != lOther$watchStatus.length) {
        return false;
      }
      for (int i = 0; i < l$watchStatus.length; i++) {
        final l$watchStatus$entry = l$watchStatus[i];
        final lOther$watchStatus$entry = lOther$watchStatus[i];
        if (l$watchStatus$entry != lOther$watchStatus$entry) {
          return false;
        }
      }
    } else if (l$watchStatus != lOther$watchStatus) {
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

extension UtilityExtension$Fragment$fragmentPlayQueue$playQueueItems$chapter
    on Fragment$fragmentPlayQueue$playQueueItems$chapter {
  CopyWith$Fragment$fragmentPlayQueue$playQueueItems$chapter<
    Fragment$fragmentPlayQueue$playQueueItems$chapter
  >
  get copyWith => CopyWith$Fragment$fragmentPlayQueue$playQueueItems$chapter(
    this,
    (i) => i,
  );
}

abstract class CopyWith$Fragment$fragmentPlayQueue$playQueueItems$chapter<
  TRes
> {
  factory CopyWith$Fragment$fragmentPlayQueue$playQueueItems$chapter(
    Fragment$fragmentPlayQueue$playQueueItems$chapter instance,
    TRes Function(Fragment$fragmentPlayQueue$playQueueItems$chapter) then,
  ) = _CopyWithImpl$Fragment$fragmentPlayQueue$playQueueItems$chapter;

  factory CopyWith$Fragment$fragmentPlayQueue$playQueueItems$chapter.stub(
    TRes res,
  ) = _CopyWithStubImpl$Fragment$fragmentPlayQueue$playQueueItems$chapter;

  TRes call({
    String? id,
    int? number,
    Fragment$fragmentPlayQueue$playQueueItems$chapter$author? author,
    Fragment$fragmentPlayQueue$playQueueItems$chapter$book? book,
    List<Fragment$fragmentMetadata>? metadata,
    List<Fragment$fragmentMediaFiles>? mediaFile,
    List<Fragment$fragmentWatchStatus>? watchStatus,
    String? $__typename,
  });
  CopyWith$Fragment$fragmentPlayQueue$playQueueItems$chapter$author<TRes>
  get author;
  CopyWith$Fragment$fragmentPlayQueue$playQueueItems$chapter$book<TRes>
  get book;
  TRes metadata(
    Iterable<Fragment$fragmentMetadata>? Function(
      Iterable<CopyWith$Fragment$fragmentMetadata<Fragment$fragmentMetadata>>?,
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
  TRes watchStatus(
    Iterable<Fragment$fragmentWatchStatus>? Function(
      Iterable<
        CopyWith$Fragment$fragmentWatchStatus<Fragment$fragmentWatchStatus>
      >?,
    )
    _fn,
  );
}

class _CopyWithImpl$Fragment$fragmentPlayQueue$playQueueItems$chapter<TRes>
    implements
        CopyWith$Fragment$fragmentPlayQueue$playQueueItems$chapter<TRes> {
  _CopyWithImpl$Fragment$fragmentPlayQueue$playQueueItems$chapter(
    this._instance,
    this._then,
  );

  final Fragment$fragmentPlayQueue$playQueueItems$chapter _instance;

  final TRes Function(Fragment$fragmentPlayQueue$playQueueItems$chapter) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? id = _undefined,
    Object? number = _undefined,
    Object? author = _undefined,
    Object? book = _undefined,
    Object? metadata = _undefined,
    Object? mediaFile = _undefined,
    Object? watchStatus = _undefined,
    Object? $__typename = _undefined,
  }) => _then(
    Fragment$fragmentPlayQueue$playQueueItems$chapter(
      id: id == _undefined || id == null ? _instance.id : (id as String),
      number: number == _undefined || number == null
          ? _instance.number
          : (number as int),
      author: author == _undefined || author == null
          ? _instance.author
          : (author
                as Fragment$fragmentPlayQueue$playQueueItems$chapter$author),
      book: book == _undefined || book == null
          ? _instance.book
          : (book as Fragment$fragmentPlayQueue$playQueueItems$chapter$book),
      metadata: metadata == _undefined
          ? _instance.metadata
          : (metadata as List<Fragment$fragmentMetadata>?),
      mediaFile: mediaFile == _undefined
          ? _instance.mediaFile
          : (mediaFile as List<Fragment$fragmentMediaFiles>?),
      watchStatus: watchStatus == _undefined
          ? _instance.watchStatus
          : (watchStatus as List<Fragment$fragmentWatchStatus>?),
      $__typename: $__typename == _undefined || $__typename == null
          ? _instance.$__typename
          : ($__typename as String),
    ),
  );

  CopyWith$Fragment$fragmentPlayQueue$playQueueItems$chapter$author<TRes>
  get author {
    final local$author = _instance.author;
    return CopyWith$Fragment$fragmentPlayQueue$playQueueItems$chapter$author(
      local$author,
      (e) => call(author: e),
    );
  }

  CopyWith$Fragment$fragmentPlayQueue$playQueueItems$chapter$book<TRes>
  get book {
    final local$book = _instance.book;
    return CopyWith$Fragment$fragmentPlayQueue$playQueueItems$chapter$book(
      local$book,
      (e) => call(book: e),
    );
  }

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

  TRes watchStatus(
    Iterable<Fragment$fragmentWatchStatus>? Function(
      Iterable<
        CopyWith$Fragment$fragmentWatchStatus<Fragment$fragmentWatchStatus>
      >?,
    )
    _fn,
  ) => call(
    watchStatus: _fn(
      _instance.watchStatus?.map(
        (e) => CopyWith$Fragment$fragmentWatchStatus(e, (i) => i),
      ),
    )?.toList(),
  );
}

class _CopyWithStubImpl$Fragment$fragmentPlayQueue$playQueueItems$chapter<TRes>
    implements
        CopyWith$Fragment$fragmentPlayQueue$playQueueItems$chapter<TRes> {
  _CopyWithStubImpl$Fragment$fragmentPlayQueue$playQueueItems$chapter(
    this._res,
  );

  TRes _res;

  call({
    String? id,
    int? number,
    Fragment$fragmentPlayQueue$playQueueItems$chapter$author? author,
    Fragment$fragmentPlayQueue$playQueueItems$chapter$book? book,
    List<Fragment$fragmentMetadata>? metadata,
    List<Fragment$fragmentMediaFiles>? mediaFile,
    List<Fragment$fragmentWatchStatus>? watchStatus,
    String? $__typename,
  }) => _res;

  CopyWith$Fragment$fragmentPlayQueue$playQueueItems$chapter$author<TRes>
  get author =>
      CopyWith$Fragment$fragmentPlayQueue$playQueueItems$chapter$author.stub(
        _res,
      );

  CopyWith$Fragment$fragmentPlayQueue$playQueueItems$chapter$book<TRes>
  get book =>
      CopyWith$Fragment$fragmentPlayQueue$playQueueItems$chapter$book.stub(
        _res,
      );

  metadata(_fn) => _res;

  mediaFile(_fn) => _res;

  watchStatus(_fn) => _res;
}

class Fragment$fragmentPlayQueue$playQueueItems$chapter$author {
  Fragment$fragmentPlayQueue$playQueueItems$chapter$author({
    required this.id,
    required this.name,
    this.$__typename = 'Person',
  });

  factory Fragment$fragmentPlayQueue$playQueueItems$chapter$author.fromJson(
    Map<String, dynamic> json,
  ) {
    final l$id = json['id'];
    final l$name = json['name'];
    final l$$__typename = json['__typename'];
    return Fragment$fragmentPlayQueue$playQueueItems$chapter$author(
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
    if (other is! Fragment$fragmentPlayQueue$playQueueItems$chapter$author ||
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

extension UtilityExtension$Fragment$fragmentPlayQueue$playQueueItems$chapter$author
    on Fragment$fragmentPlayQueue$playQueueItems$chapter$author {
  CopyWith$Fragment$fragmentPlayQueue$playQueueItems$chapter$author<
    Fragment$fragmentPlayQueue$playQueueItems$chapter$author
  >
  get copyWith =>
      CopyWith$Fragment$fragmentPlayQueue$playQueueItems$chapter$author(
        this,
        (i) => i,
      );
}

abstract class CopyWith$Fragment$fragmentPlayQueue$playQueueItems$chapter$author<
  TRes
> {
  factory CopyWith$Fragment$fragmentPlayQueue$playQueueItems$chapter$author(
    Fragment$fragmentPlayQueue$playQueueItems$chapter$author instance,
    TRes Function(Fragment$fragmentPlayQueue$playQueueItems$chapter$author)
    then,
  ) = _CopyWithImpl$Fragment$fragmentPlayQueue$playQueueItems$chapter$author;

  factory CopyWith$Fragment$fragmentPlayQueue$playQueueItems$chapter$author.stub(
    TRes res,
  ) = _CopyWithStubImpl$Fragment$fragmentPlayQueue$playQueueItems$chapter$author;

  TRes call({String? id, String? name, String? $__typename});
}

class _CopyWithImpl$Fragment$fragmentPlayQueue$playQueueItems$chapter$author<
  TRes
>
    implements
        CopyWith$Fragment$fragmentPlayQueue$playQueueItems$chapter$author<
          TRes
        > {
  _CopyWithImpl$Fragment$fragmentPlayQueue$playQueueItems$chapter$author(
    this._instance,
    this._then,
  );

  final Fragment$fragmentPlayQueue$playQueueItems$chapter$author _instance;

  final TRes Function(Fragment$fragmentPlayQueue$playQueueItems$chapter$author)
  _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? id = _undefined,
    Object? name = _undefined,
    Object? $__typename = _undefined,
  }) => _then(
    Fragment$fragmentPlayQueue$playQueueItems$chapter$author(
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

class _CopyWithStubImpl$Fragment$fragmentPlayQueue$playQueueItems$chapter$author<
  TRes
>
    implements
        CopyWith$Fragment$fragmentPlayQueue$playQueueItems$chapter$author<
          TRes
        > {
  _CopyWithStubImpl$Fragment$fragmentPlayQueue$playQueueItems$chapter$author(
    this._res,
  );

  TRes _res;

  call({String? id, String? name, String? $__typename}) => _res;
}

class Fragment$fragmentPlayQueue$playQueueItems$chapter$book {
  Fragment$fragmentPlayQueue$playQueueItems$chapter$book({
    required this.id,
    required this.name,
    this.images,
    this.$__typename = 'Book',
  });

  factory Fragment$fragmentPlayQueue$playQueueItems$chapter$book.fromJson(
    Map<String, dynamic> json,
  ) {
    final l$id = json['id'];
    final l$name = json['name'];
    final l$images = json['images'];
    final l$$__typename = json['__typename'];
    return Fragment$fragmentPlayQueue$playQueueItems$chapter$book(
      id: (l$id as String),
      name: (l$name as String),
      images: (l$images as List<dynamic>?)
          ?.map(
            (e) =>
                Fragment$fragmentImages.fromJson((e as Map<String, dynamic>)),
          )
          .toList(),
      $__typename: (l$$__typename as String),
    );
  }

  final String id;

  final String name;

  final List<Fragment$fragmentImages>? images;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$id = id;
    _resultData['id'] = l$id;
    final l$name = name;
    _resultData['name'] = l$name;
    final l$images = images;
    _resultData['images'] = l$images?.map((e) => e.toJson()).toList();
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$id = id;
    final l$name = name;
    final l$images = images;
    final l$$__typename = $__typename;
    return Object.hashAll([
      l$id,
      l$name,
      l$images == null ? null : Object.hashAll(l$images.map((v) => v)),
      l$$__typename,
    ]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Fragment$fragmentPlayQueue$playQueueItems$chapter$book ||
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
    final l$$__typename = $__typename;
    final lOther$$__typename = other.$__typename;
    if (l$$__typename != lOther$$__typename) {
      return false;
    }
    return true;
  }
}

extension UtilityExtension$Fragment$fragmentPlayQueue$playQueueItems$chapter$book
    on Fragment$fragmentPlayQueue$playQueueItems$chapter$book {
  CopyWith$Fragment$fragmentPlayQueue$playQueueItems$chapter$book<
    Fragment$fragmentPlayQueue$playQueueItems$chapter$book
  >
  get copyWith =>
      CopyWith$Fragment$fragmentPlayQueue$playQueueItems$chapter$book(
        this,
        (i) => i,
      );
}

abstract class CopyWith$Fragment$fragmentPlayQueue$playQueueItems$chapter$book<
  TRes
> {
  factory CopyWith$Fragment$fragmentPlayQueue$playQueueItems$chapter$book(
    Fragment$fragmentPlayQueue$playQueueItems$chapter$book instance,
    TRes Function(Fragment$fragmentPlayQueue$playQueueItems$chapter$book) then,
  ) = _CopyWithImpl$Fragment$fragmentPlayQueue$playQueueItems$chapter$book;

  factory CopyWith$Fragment$fragmentPlayQueue$playQueueItems$chapter$book.stub(
    TRes res,
  ) = _CopyWithStubImpl$Fragment$fragmentPlayQueue$playQueueItems$chapter$book;

  TRes call({
    String? id,
    String? name,
    List<Fragment$fragmentImages>? images,
    String? $__typename,
  });
  TRes images(
    Iterable<Fragment$fragmentImages>? Function(
      Iterable<CopyWith$Fragment$fragmentImages<Fragment$fragmentImages>>?,
    )
    _fn,
  );
}

class _CopyWithImpl$Fragment$fragmentPlayQueue$playQueueItems$chapter$book<TRes>
    implements
        CopyWith$Fragment$fragmentPlayQueue$playQueueItems$chapter$book<TRes> {
  _CopyWithImpl$Fragment$fragmentPlayQueue$playQueueItems$chapter$book(
    this._instance,
    this._then,
  );

  final Fragment$fragmentPlayQueue$playQueueItems$chapter$book _instance;

  final TRes Function(Fragment$fragmentPlayQueue$playQueueItems$chapter$book)
  _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? id = _undefined,
    Object? name = _undefined,
    Object? images = _undefined,
    Object? $__typename = _undefined,
  }) => _then(
    Fragment$fragmentPlayQueue$playQueueItems$chapter$book(
      id: id == _undefined || id == null ? _instance.id : (id as String),
      name: name == _undefined || name == null
          ? _instance.name
          : (name as String),
      images: images == _undefined
          ? _instance.images
          : (images as List<Fragment$fragmentImages>?),
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
}

class _CopyWithStubImpl$Fragment$fragmentPlayQueue$playQueueItems$chapter$book<
  TRes
>
    implements
        CopyWith$Fragment$fragmentPlayQueue$playQueueItems$chapter$book<TRes> {
  _CopyWithStubImpl$Fragment$fragmentPlayQueue$playQueueItems$chapter$book(
    this._res,
  );

  TRes _res;

  call({
    String? id,
    String? name,
    List<Fragment$fragmentImages>? images,
    String? $__typename,
  }) => _res;

  images(_fn) => _res;
}

class Fragment$fragmentPlayQueue$playQueueItems$podcastEpisode {
  Fragment$fragmentPlayQueue$playQueueItems$podcastEpisode({
    required this.id,
    this.publishedAt,
    required this.podcast,
    this.metadata,
    this.mediaFile,
    this.watchStatus,
    this.$__typename = 'PodcastEpisode',
  });

  factory Fragment$fragmentPlayQueue$playQueueItems$podcastEpisode.fromJson(
    Map<String, dynamic> json,
  ) {
    final l$id = json['id'];
    final l$publishedAt = json['publishedAt'];
    final l$podcast = json['podcast'];
    final l$metadata = json['metadata'];
    final l$mediaFile = json['mediaFile'];
    final l$watchStatus = json['watchStatus'];
    final l$$__typename = json['__typename'];
    return Fragment$fragmentPlayQueue$playQueueItems$podcastEpisode(
      id: (l$id as String),
      publishedAt: (l$publishedAt as String?),
      podcast:
          Fragment$fragmentPlayQueue$playQueueItems$podcastEpisode$podcast.fromJson(
            (l$podcast as Map<String, dynamic>),
          ),
      metadata: (l$metadata as List<dynamic>?)
          ?.map(
            (e) =>
                Fragment$fragmentMetadata.fromJson((e as Map<String, dynamic>)),
          )
          .toList(),
      mediaFile: (l$mediaFile as List<dynamic>?)
          ?.map(
            (e) => Fragment$fragmentMediaFiles.fromJson(
              (e as Map<String, dynamic>),
            ),
          )
          .toList(),
      watchStatus: (l$watchStatus as List<dynamic>?)
          ?.map(
            (e) => Fragment$fragmentWatchStatus.fromJson(
              (e as Map<String, dynamic>),
            ),
          )
          .toList(),
      $__typename: (l$$__typename as String),
    );
  }

  final String id;

  final String? publishedAt;

  final Fragment$fragmentPlayQueue$playQueueItems$podcastEpisode$podcast
  podcast;

  final List<Fragment$fragmentMetadata>? metadata;

  final List<Fragment$fragmentMediaFiles>? mediaFile;

  final List<Fragment$fragmentWatchStatus>? watchStatus;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$id = id;
    _resultData['id'] = l$id;
    final l$publishedAt = publishedAt;
    _resultData['publishedAt'] = l$publishedAt;
    final l$podcast = podcast;
    _resultData['podcast'] = l$podcast.toJson();
    final l$metadata = metadata;
    _resultData['metadata'] = l$metadata?.map((e) => e.toJson()).toList();
    final l$mediaFile = mediaFile;
    _resultData['mediaFile'] = l$mediaFile?.map((e) => e.toJson()).toList();
    final l$watchStatus = watchStatus;
    _resultData['watchStatus'] = l$watchStatus?.map((e) => e.toJson()).toList();
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$id = id;
    final l$publishedAt = publishedAt;
    final l$podcast = podcast;
    final l$metadata = metadata;
    final l$mediaFile = mediaFile;
    final l$watchStatus = watchStatus;
    final l$$__typename = $__typename;
    return Object.hashAll([
      l$id,
      l$publishedAt,
      l$podcast,
      l$metadata == null ? null : Object.hashAll(l$metadata.map((v) => v)),
      l$mediaFile == null ? null : Object.hashAll(l$mediaFile.map((v) => v)),
      l$watchStatus == null
          ? null
          : Object.hashAll(l$watchStatus.map((v) => v)),
      l$$__typename,
    ]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Fragment$fragmentPlayQueue$playQueueItems$podcastEpisode ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$id = id;
    final lOther$id = other.id;
    if (l$id != lOther$id) {
      return false;
    }
    final l$publishedAt = publishedAt;
    final lOther$publishedAt = other.publishedAt;
    if (l$publishedAt != lOther$publishedAt) {
      return false;
    }
    final l$podcast = podcast;
    final lOther$podcast = other.podcast;
    if (l$podcast != lOther$podcast) {
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
    final l$watchStatus = watchStatus;
    final lOther$watchStatus = other.watchStatus;
    if (l$watchStatus != null && lOther$watchStatus != null) {
      if (l$watchStatus.length != lOther$watchStatus.length) {
        return false;
      }
      for (int i = 0; i < l$watchStatus.length; i++) {
        final l$watchStatus$entry = l$watchStatus[i];
        final lOther$watchStatus$entry = lOther$watchStatus[i];
        if (l$watchStatus$entry != lOther$watchStatus$entry) {
          return false;
        }
      }
    } else if (l$watchStatus != lOther$watchStatus) {
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

extension UtilityExtension$Fragment$fragmentPlayQueue$playQueueItems$podcastEpisode
    on Fragment$fragmentPlayQueue$playQueueItems$podcastEpisode {
  CopyWith$Fragment$fragmentPlayQueue$playQueueItems$podcastEpisode<
    Fragment$fragmentPlayQueue$playQueueItems$podcastEpisode
  >
  get copyWith =>
      CopyWith$Fragment$fragmentPlayQueue$playQueueItems$podcastEpisode(
        this,
        (i) => i,
      );
}

abstract class CopyWith$Fragment$fragmentPlayQueue$playQueueItems$podcastEpisode<
  TRes
> {
  factory CopyWith$Fragment$fragmentPlayQueue$playQueueItems$podcastEpisode(
    Fragment$fragmentPlayQueue$playQueueItems$podcastEpisode instance,
    TRes Function(Fragment$fragmentPlayQueue$playQueueItems$podcastEpisode)
    then,
  ) = _CopyWithImpl$Fragment$fragmentPlayQueue$playQueueItems$podcastEpisode;

  factory CopyWith$Fragment$fragmentPlayQueue$playQueueItems$podcastEpisode.stub(
    TRes res,
  ) = _CopyWithStubImpl$Fragment$fragmentPlayQueue$playQueueItems$podcastEpisode;

  TRes call({
    String? id,
    String? publishedAt,
    Fragment$fragmentPlayQueue$playQueueItems$podcastEpisode$podcast? podcast,
    List<Fragment$fragmentMetadata>? metadata,
    List<Fragment$fragmentMediaFiles>? mediaFile,
    List<Fragment$fragmentWatchStatus>? watchStatus,
    String? $__typename,
  });
  CopyWith$Fragment$fragmentPlayQueue$playQueueItems$podcastEpisode$podcast<
    TRes
  >
  get podcast;
  TRes metadata(
    Iterable<Fragment$fragmentMetadata>? Function(
      Iterable<CopyWith$Fragment$fragmentMetadata<Fragment$fragmentMetadata>>?,
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
  TRes watchStatus(
    Iterable<Fragment$fragmentWatchStatus>? Function(
      Iterable<
        CopyWith$Fragment$fragmentWatchStatus<Fragment$fragmentWatchStatus>
      >?,
    )
    _fn,
  );
}

class _CopyWithImpl$Fragment$fragmentPlayQueue$playQueueItems$podcastEpisode<
  TRes
>
    implements
        CopyWith$Fragment$fragmentPlayQueue$playQueueItems$podcastEpisode<
          TRes
        > {
  _CopyWithImpl$Fragment$fragmentPlayQueue$playQueueItems$podcastEpisode(
    this._instance,
    this._then,
  );

  final Fragment$fragmentPlayQueue$playQueueItems$podcastEpisode _instance;

  final TRes Function(Fragment$fragmentPlayQueue$playQueueItems$podcastEpisode)
  _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? id = _undefined,
    Object? publishedAt = _undefined,
    Object? podcast = _undefined,
    Object? metadata = _undefined,
    Object? mediaFile = _undefined,
    Object? watchStatus = _undefined,
    Object? $__typename = _undefined,
  }) => _then(
    Fragment$fragmentPlayQueue$playQueueItems$podcastEpisode(
      id: id == _undefined || id == null ? _instance.id : (id as String),
      publishedAt: publishedAt == _undefined
          ? _instance.publishedAt
          : (publishedAt as String?),
      podcast: podcast == _undefined || podcast == null
          ? _instance.podcast
          : (podcast
                as Fragment$fragmentPlayQueue$playQueueItems$podcastEpisode$podcast),
      metadata: metadata == _undefined
          ? _instance.metadata
          : (metadata as List<Fragment$fragmentMetadata>?),
      mediaFile: mediaFile == _undefined
          ? _instance.mediaFile
          : (mediaFile as List<Fragment$fragmentMediaFiles>?),
      watchStatus: watchStatus == _undefined
          ? _instance.watchStatus
          : (watchStatus as List<Fragment$fragmentWatchStatus>?),
      $__typename: $__typename == _undefined || $__typename == null
          ? _instance.$__typename
          : ($__typename as String),
    ),
  );

  CopyWith$Fragment$fragmentPlayQueue$playQueueItems$podcastEpisode$podcast<
    TRes
  >
  get podcast {
    final local$podcast = _instance.podcast;
    return CopyWith$Fragment$fragmentPlayQueue$playQueueItems$podcastEpisode$podcast(
      local$podcast,
      (e) => call(podcast: e),
    );
  }

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

  TRes watchStatus(
    Iterable<Fragment$fragmentWatchStatus>? Function(
      Iterable<
        CopyWith$Fragment$fragmentWatchStatus<Fragment$fragmentWatchStatus>
      >?,
    )
    _fn,
  ) => call(
    watchStatus: _fn(
      _instance.watchStatus?.map(
        (e) => CopyWith$Fragment$fragmentWatchStatus(e, (i) => i),
      ),
    )?.toList(),
  );
}

class _CopyWithStubImpl$Fragment$fragmentPlayQueue$playQueueItems$podcastEpisode<
  TRes
>
    implements
        CopyWith$Fragment$fragmentPlayQueue$playQueueItems$podcastEpisode<
          TRes
        > {
  _CopyWithStubImpl$Fragment$fragmentPlayQueue$playQueueItems$podcastEpisode(
    this._res,
  );

  TRes _res;

  call({
    String? id,
    String? publishedAt,
    Fragment$fragmentPlayQueue$playQueueItems$podcastEpisode$podcast? podcast,
    List<Fragment$fragmentMetadata>? metadata,
    List<Fragment$fragmentMediaFiles>? mediaFile,
    List<Fragment$fragmentWatchStatus>? watchStatus,
    String? $__typename,
  }) => _res;

  CopyWith$Fragment$fragmentPlayQueue$playQueueItems$podcastEpisode$podcast<
    TRes
  >
  get podcast =>
      CopyWith$Fragment$fragmentPlayQueue$playQueueItems$podcastEpisode$podcast.stub(
        _res,
      );

  metadata(_fn) => _res;

  mediaFile(_fn) => _res;

  watchStatus(_fn) => _res;
}

class Fragment$fragmentPlayQueue$playQueueItems$podcastEpisode$podcast {
  Fragment$fragmentPlayQueue$playQueueItems$podcastEpisode$podcast({
    required this.id,
    required this.title,
    this.author,
    this.images,
    this.$__typename = 'Podcast',
  });

  factory Fragment$fragmentPlayQueue$playQueueItems$podcastEpisode$podcast.fromJson(
    Map<String, dynamic> json,
  ) {
    final l$id = json['id'];
    final l$title = json['title'];
    final l$author = json['author'];
    final l$images = json['images'];
    final l$$__typename = json['__typename'];
    return Fragment$fragmentPlayQueue$playQueueItems$podcastEpisode$podcast(
      id: (l$id as String),
      title: (l$title as String),
      author: (l$author as String?),
      images: (l$images as List<dynamic>?)
          ?.map(
            (e) =>
                Fragment$fragmentImages.fromJson((e as Map<String, dynamic>)),
          )
          .toList(),
      $__typename: (l$$__typename as String),
    );
  }

  final String id;

  final String title;

  final String? author;

  final List<Fragment$fragmentImages>? images;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$id = id;
    _resultData['id'] = l$id;
    final l$title = title;
    _resultData['title'] = l$title;
    final l$author = author;
    _resultData['author'] = l$author;
    final l$images = images;
    _resultData['images'] = l$images?.map((e) => e.toJson()).toList();
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$id = id;
    final l$title = title;
    final l$author = author;
    final l$images = images;
    final l$$__typename = $__typename;
    return Object.hashAll([
      l$id,
      l$title,
      l$author,
      l$images == null ? null : Object.hashAll(l$images.map((v) => v)),
      l$$__typename,
    ]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other
            is! Fragment$fragmentPlayQueue$playQueueItems$podcastEpisode$podcast ||
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
    final l$$__typename = $__typename;
    final lOther$$__typename = other.$__typename;
    if (l$$__typename != lOther$$__typename) {
      return false;
    }
    return true;
  }
}

extension UtilityExtension$Fragment$fragmentPlayQueue$playQueueItems$podcastEpisode$podcast
    on Fragment$fragmentPlayQueue$playQueueItems$podcastEpisode$podcast {
  CopyWith$Fragment$fragmentPlayQueue$playQueueItems$podcastEpisode$podcast<
    Fragment$fragmentPlayQueue$playQueueItems$podcastEpisode$podcast
  >
  get copyWith =>
      CopyWith$Fragment$fragmentPlayQueue$playQueueItems$podcastEpisode$podcast(
        this,
        (i) => i,
      );
}

abstract class CopyWith$Fragment$fragmentPlayQueue$playQueueItems$podcastEpisode$podcast<
  TRes
> {
  factory CopyWith$Fragment$fragmentPlayQueue$playQueueItems$podcastEpisode$podcast(
    Fragment$fragmentPlayQueue$playQueueItems$podcastEpisode$podcast instance,
    TRes Function(
      Fragment$fragmentPlayQueue$playQueueItems$podcastEpisode$podcast,
    )
    then,
  ) = _CopyWithImpl$Fragment$fragmentPlayQueue$playQueueItems$podcastEpisode$podcast;

  factory CopyWith$Fragment$fragmentPlayQueue$playQueueItems$podcastEpisode$podcast.stub(
    TRes res,
  ) = _CopyWithStubImpl$Fragment$fragmentPlayQueue$playQueueItems$podcastEpisode$podcast;

  TRes call({
    String? id,
    String? title,
    String? author,
    List<Fragment$fragmentImages>? images,
    String? $__typename,
  });
  TRes images(
    Iterable<Fragment$fragmentImages>? Function(
      Iterable<CopyWith$Fragment$fragmentImages<Fragment$fragmentImages>>?,
    )
    _fn,
  );
}

class _CopyWithImpl$Fragment$fragmentPlayQueue$playQueueItems$podcastEpisode$podcast<
  TRes
>
    implements
        CopyWith$Fragment$fragmentPlayQueue$playQueueItems$podcastEpisode$podcast<
          TRes
        > {
  _CopyWithImpl$Fragment$fragmentPlayQueue$playQueueItems$podcastEpisode$podcast(
    this._instance,
    this._then,
  );

  final Fragment$fragmentPlayQueue$playQueueItems$podcastEpisode$podcast
  _instance;

  final TRes Function(
    Fragment$fragmentPlayQueue$playQueueItems$podcastEpisode$podcast,
  )
  _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? id = _undefined,
    Object? title = _undefined,
    Object? author = _undefined,
    Object? images = _undefined,
    Object? $__typename = _undefined,
  }) => _then(
    Fragment$fragmentPlayQueue$playQueueItems$podcastEpisode$podcast(
      id: id == _undefined || id == null ? _instance.id : (id as String),
      title: title == _undefined || title == null
          ? _instance.title
          : (title as String),
      author: author == _undefined ? _instance.author : (author as String?),
      images: images == _undefined
          ? _instance.images
          : (images as List<Fragment$fragmentImages>?),
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
}

class _CopyWithStubImpl$Fragment$fragmentPlayQueue$playQueueItems$podcastEpisode$podcast<
  TRes
>
    implements
        CopyWith$Fragment$fragmentPlayQueue$playQueueItems$podcastEpisode$podcast<
          TRes
        > {
  _CopyWithStubImpl$Fragment$fragmentPlayQueue$playQueueItems$podcastEpisode$podcast(
    this._res,
  );

  TRes _res;

  call({
    String? id,
    String? title,
    String? author,
    List<Fragment$fragmentImages>? images,
    String? $__typename,
  }) => _res;

  images(_fn) => _res;
}

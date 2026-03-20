import 'fragmentImages.graphql.dart';
import 'fragmentMetadata.graphql.dart';
import 'package:gql/ast.dart';
import 'schema.graphql.dart';

class Query$recentlyWatched {
  Query$recentlyWatched({this.recentlyWatched, this.$__typename = 'Query'});

  factory Query$recentlyWatched.fromJson(Map<String, dynamic> json) {
    final l$recentlyWatched = json['recentlyWatched'];
    final l$$__typename = json['__typename'];
    return Query$recentlyWatched(
      recentlyWatched: (l$recentlyWatched as List<dynamic>?)
          ?.map(
            (e) => Query$recentlyWatched$recentlyWatched.fromJson(
              (e as Map<String, dynamic>),
            ),
          )
          .toList(),
      $__typename: (l$$__typename as String),
    );
  }

  final List<Query$recentlyWatched$recentlyWatched>? recentlyWatched;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$recentlyWatched = recentlyWatched;
    _resultData['recentlyWatched'] = l$recentlyWatched
        ?.map((e) => e.toJson())
        .toList();
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$recentlyWatched = recentlyWatched;
    final l$$__typename = $__typename;
    return Object.hashAll([
      l$recentlyWatched == null
          ? null
          : Object.hashAll(l$recentlyWatched.map((v) => v)),
      l$$__typename,
    ]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Query$recentlyWatched || runtimeType != other.runtimeType) {
      return false;
    }
    final l$recentlyWatched = recentlyWatched;
    final lOther$recentlyWatched = other.recentlyWatched;
    if (l$recentlyWatched != null && lOther$recentlyWatched != null) {
      if (l$recentlyWatched.length != lOther$recentlyWatched.length) {
        return false;
      }
      for (int i = 0; i < l$recentlyWatched.length; i++) {
        final l$recentlyWatched$entry = l$recentlyWatched[i];
        final lOther$recentlyWatched$entry = lOther$recentlyWatched[i];
        if (l$recentlyWatched$entry != lOther$recentlyWatched$entry) {
          return false;
        }
      }
    } else if (l$recentlyWatched != lOther$recentlyWatched) {
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

extension UtilityExtension$Query$recentlyWatched on Query$recentlyWatched {
  CopyWith$Query$recentlyWatched<Query$recentlyWatched> get copyWith =>
      CopyWith$Query$recentlyWatched(this, (i) => i);
}

abstract class CopyWith$Query$recentlyWatched<TRes> {
  factory CopyWith$Query$recentlyWatched(
    Query$recentlyWatched instance,
    TRes Function(Query$recentlyWatched) then,
  ) = _CopyWithImpl$Query$recentlyWatched;

  factory CopyWith$Query$recentlyWatched.stub(TRes res) =
      _CopyWithStubImpl$Query$recentlyWatched;

  TRes call({
    List<Query$recentlyWatched$recentlyWatched>? recentlyWatched,
    String? $__typename,
  });
  TRes recentlyWatched(
    Iterable<Query$recentlyWatched$recentlyWatched>? Function(
      Iterable<
        CopyWith$Query$recentlyWatched$recentlyWatched<
          Query$recentlyWatched$recentlyWatched
        >
      >?,
    )
    _fn,
  );
}

class _CopyWithImpl$Query$recentlyWatched<TRes>
    implements CopyWith$Query$recentlyWatched<TRes> {
  _CopyWithImpl$Query$recentlyWatched(this._instance, this._then);

  final Query$recentlyWatched _instance;

  final TRes Function(Query$recentlyWatched) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? recentlyWatched = _undefined,
    Object? $__typename = _undefined,
  }) => _then(
    Query$recentlyWatched(
      recentlyWatched: recentlyWatched == _undefined
          ? _instance.recentlyWatched
          : (recentlyWatched as List<Query$recentlyWatched$recentlyWatched>?),
      $__typename: $__typename == _undefined || $__typename == null
          ? _instance.$__typename
          : ($__typename as String),
    ),
  );

  TRes recentlyWatched(
    Iterable<Query$recentlyWatched$recentlyWatched>? Function(
      Iterable<
        CopyWith$Query$recentlyWatched$recentlyWatched<
          Query$recentlyWatched$recentlyWatched
        >
      >?,
    )
    _fn,
  ) => call(
    recentlyWatched: _fn(
      _instance.recentlyWatched?.map(
        (e) => CopyWith$Query$recentlyWatched$recentlyWatched(e, (i) => i),
      ),
    )?.toList(),
  );
}

class _CopyWithStubImpl$Query$recentlyWatched<TRes>
    implements CopyWith$Query$recentlyWatched<TRes> {
  _CopyWithStubImpl$Query$recentlyWatched(this._res);

  TRes _res;

  call({
    List<Query$recentlyWatched$recentlyWatched>? recentlyWatched,
    String? $__typename,
  }) => _res;

  recentlyWatched(_fn) => _res;
}

const documentNodeQueryrecentlyWatched = DocumentNode(
  definitions: [
    OperationDefinitionNode(
      type: OperationType.query,
      name: NameNode(value: 'recentlyWatched'),
      variableDefinitions: [],
      directives: [],
      selectionSet: SelectionSetNode(
        selections: [
          FieldNode(
            name: NameNode(value: 'recentlyWatched'),
            alias: null,
            arguments: [],
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
                  name: NameNode(value: 'episode'),
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
                        name: NameNode(value: 'show'),
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
                        name: NameNode(value: 'season'),
                        alias: null,
                        arguments: [],
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
                            FieldNode(
                              name: NameNode(value: 'id'),
                              alias: null,
                              arguments: [],
                              directives: [],
                              selectionSet: null,
                            ),
                            FieldNode(
                              name: NameNode(value: 'playQueueItemId'),
                              alias: null,
                              arguments: [],
                              directives: [],
                              selectionSet: null,
                            ),
                            FieldNode(
                              name: NameNode(value: 'progressInMilliseconds'),
                              alias: null,
                              arguments: [],
                              directives: [],
                              selectionSet: null,
                            ),
                            FieldNode(
                              name: NameNode(value: 'watched'),
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
                        name: NameNode(value: 'mediaFile'),
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
                              name: NameNode(value: 'durationInMilliseconds'),
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
                        name: NameNode(value: 'watchStatus'),
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
                              name: NameNode(value: 'playQueueItemId'),
                              alias: null,
                              arguments: [],
                              directives: [],
                              selectionSet: null,
                            ),
                            FieldNode(
                              name: NameNode(value: 'progressInMilliseconds'),
                              alias: null,
                              arguments: [],
                              directives: [],
                              selectionSet: null,
                            ),
                            FieldNode(
                              name: NameNode(value: 'watched'),
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
                        name: NameNode(value: 'mediaFile'),
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
                              name: NameNode(value: 'durationInMilliseconds'),
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
    fragmentDefinitionfragmentMetadata,
    fragmentDefinitionfragmentImages,
  ],
);

class Query$recentlyWatched$recentlyWatched {
  Query$recentlyWatched$recentlyWatched({
    required this.type,
    this.episode,
    this.movie,
    this.$__typename = 'RecentlyWatched',
  });

  factory Query$recentlyWatched$recentlyWatched.fromJson(
    Map<String, dynamic> json,
  ) {
    final l$type = json['type'];
    final l$episode = json['episode'];
    final l$movie = json['movie'];
    final l$$__typename = json['__typename'];
    return Query$recentlyWatched$recentlyWatched(
      type: fromJson$Enum$MediaType((l$type as String)),
      episode: l$episode == null
          ? null
          : Query$recentlyWatched$recentlyWatched$episode.fromJson(
              (l$episode as Map<String, dynamic>),
            ),
      movie: l$movie == null
          ? null
          : Query$recentlyWatched$recentlyWatched$movie.fromJson(
              (l$movie as Map<String, dynamic>),
            ),
      $__typename: (l$$__typename as String),
    );
  }

  final Enum$MediaType type;

  final Query$recentlyWatched$recentlyWatched$episode? episode;

  final Query$recentlyWatched$recentlyWatched$movie? movie;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$type = type;
    _resultData['type'] = toJson$Enum$MediaType(l$type);
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
    final l$type = type;
    final l$episode = episode;
    final l$movie = movie;
    final l$$__typename = $__typename;
    return Object.hashAll([l$type, l$episode, l$movie, l$$__typename]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Query$recentlyWatched$recentlyWatched ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$type = type;
    final lOther$type = other.type;
    if (l$type != lOther$type) {
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

extension UtilityExtension$Query$recentlyWatched$recentlyWatched
    on Query$recentlyWatched$recentlyWatched {
  CopyWith$Query$recentlyWatched$recentlyWatched<
    Query$recentlyWatched$recentlyWatched
  >
  get copyWith =>
      CopyWith$Query$recentlyWatched$recentlyWatched(this, (i) => i);
}

abstract class CopyWith$Query$recentlyWatched$recentlyWatched<TRes> {
  factory CopyWith$Query$recentlyWatched$recentlyWatched(
    Query$recentlyWatched$recentlyWatched instance,
    TRes Function(Query$recentlyWatched$recentlyWatched) then,
  ) = _CopyWithImpl$Query$recentlyWatched$recentlyWatched;

  factory CopyWith$Query$recentlyWatched$recentlyWatched.stub(TRes res) =
      _CopyWithStubImpl$Query$recentlyWatched$recentlyWatched;

  TRes call({
    Enum$MediaType? type,
    Query$recentlyWatched$recentlyWatched$episode? episode,
    Query$recentlyWatched$recentlyWatched$movie? movie,
    String? $__typename,
  });
  CopyWith$Query$recentlyWatched$recentlyWatched$episode<TRes> get episode;
  CopyWith$Query$recentlyWatched$recentlyWatched$movie<TRes> get movie;
}

class _CopyWithImpl$Query$recentlyWatched$recentlyWatched<TRes>
    implements CopyWith$Query$recentlyWatched$recentlyWatched<TRes> {
  _CopyWithImpl$Query$recentlyWatched$recentlyWatched(
    this._instance,
    this._then,
  );

  final Query$recentlyWatched$recentlyWatched _instance;

  final TRes Function(Query$recentlyWatched$recentlyWatched) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? type = _undefined,
    Object? episode = _undefined,
    Object? movie = _undefined,
    Object? $__typename = _undefined,
  }) => _then(
    Query$recentlyWatched$recentlyWatched(
      type: type == _undefined || type == null
          ? _instance.type
          : (type as Enum$MediaType),
      episode: episode == _undefined
          ? _instance.episode
          : (episode as Query$recentlyWatched$recentlyWatched$episode?),
      movie: movie == _undefined
          ? _instance.movie
          : (movie as Query$recentlyWatched$recentlyWatched$movie?),
      $__typename: $__typename == _undefined || $__typename == null
          ? _instance.$__typename
          : ($__typename as String),
    ),
  );

  CopyWith$Query$recentlyWatched$recentlyWatched$episode<TRes> get episode {
    final local$episode = _instance.episode;
    return local$episode == null
        ? CopyWith$Query$recentlyWatched$recentlyWatched$episode.stub(
            _then(_instance),
          )
        : CopyWith$Query$recentlyWatched$recentlyWatched$episode(
            local$episode,
            (e) => call(episode: e),
          );
  }

  CopyWith$Query$recentlyWatched$recentlyWatched$movie<TRes> get movie {
    final local$movie = _instance.movie;
    return local$movie == null
        ? CopyWith$Query$recentlyWatched$recentlyWatched$movie.stub(
            _then(_instance),
          )
        : CopyWith$Query$recentlyWatched$recentlyWatched$movie(
            local$movie,
            (e) => call(movie: e),
          );
  }
}

class _CopyWithStubImpl$Query$recentlyWatched$recentlyWatched<TRes>
    implements CopyWith$Query$recentlyWatched$recentlyWatched<TRes> {
  _CopyWithStubImpl$Query$recentlyWatched$recentlyWatched(this._res);

  TRes _res;

  call({
    Enum$MediaType? type,
    Query$recentlyWatched$recentlyWatched$episode? episode,
    Query$recentlyWatched$recentlyWatched$movie? movie,
    String? $__typename,
  }) => _res;

  CopyWith$Query$recentlyWatched$recentlyWatched$episode<TRes> get episode =>
      CopyWith$Query$recentlyWatched$recentlyWatched$episode.stub(_res);

  CopyWith$Query$recentlyWatched$recentlyWatched$movie<TRes> get movie =>
      CopyWith$Query$recentlyWatched$recentlyWatched$movie.stub(_res);
}

class Query$recentlyWatched$recentlyWatched$episode {
  Query$recentlyWatched$recentlyWatched$episode({
    required this.id,
    this.number,
    this.$show,
    this.season,
    this.watchStatus,
    this.mediaFile,
    this.metadata,
    this.images,
    this.$__typename = 'Episode',
  });

  factory Query$recentlyWatched$recentlyWatched$episode.fromJson(
    Map<String, dynamic> json,
  ) {
    final l$id = json['id'];
    final l$number = json['number'];
    final l$$show = json['show'];
    final l$season = json['season'];
    final l$watchStatus = json['watchStatus'];
    final l$mediaFile = json['mediaFile'];
    final l$metadata = json['metadata'];
    final l$images = json['images'];
    final l$$__typename = json['__typename'];
    return Query$recentlyWatched$recentlyWatched$episode(
      id: (l$id as String),
      number: (l$number as int?),
      $show: l$$show == null
          ? null
          : Query$recentlyWatched$recentlyWatched$episode$show.fromJson(
              (l$$show as Map<String, dynamic>),
            ),
      season: l$season == null
          ? null
          : Query$recentlyWatched$recentlyWatched$episode$season.fromJson(
              (l$season as Map<String, dynamic>),
            ),
      watchStatus: (l$watchStatus as List<dynamic>?)
          ?.map(
            (e) =>
                Query$recentlyWatched$recentlyWatched$episode$watchStatus.fromJson(
                  (e as Map<String, dynamic>),
                ),
          )
          .toList(),
      mediaFile: (l$mediaFile as List<dynamic>?)
          ?.map(
            (e) =>
                Query$recentlyWatched$recentlyWatched$episode$mediaFile.fromJson(
                  (e as Map<String, dynamic>),
                ),
          )
          .toList(),
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
      $__typename: (l$$__typename as String),
    );
  }

  final String id;

  final int? number;

  final Query$recentlyWatched$recentlyWatched$episode$show? $show;

  final Query$recentlyWatched$recentlyWatched$episode$season? season;

  final List<Query$recentlyWatched$recentlyWatched$episode$watchStatus>?
  watchStatus;

  final List<Query$recentlyWatched$recentlyWatched$episode$mediaFile>?
  mediaFile;

  final List<Fragment$fragmentMetadata>? metadata;

  final List<Fragment$fragmentImages>? images;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$id = id;
    _resultData['id'] = l$id;
    final l$number = number;
    _resultData['number'] = l$number;
    final l$$show = $show;
    _resultData['show'] = l$$show?.toJson();
    final l$season = season;
    _resultData['season'] = l$season?.toJson();
    final l$watchStatus = watchStatus;
    _resultData['watchStatus'] = l$watchStatus?.map((e) => e.toJson()).toList();
    final l$mediaFile = mediaFile;
    _resultData['mediaFile'] = l$mediaFile?.map((e) => e.toJson()).toList();
    final l$metadata = metadata;
    _resultData['metadata'] = l$metadata?.map((e) => e.toJson()).toList();
    final l$images = images;
    _resultData['images'] = l$images?.map((e) => e.toJson()).toList();
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$id = id;
    final l$number = number;
    final l$$show = $show;
    final l$season = season;
    final l$watchStatus = watchStatus;
    final l$mediaFile = mediaFile;
    final l$metadata = metadata;
    final l$images = images;
    final l$$__typename = $__typename;
    return Object.hashAll([
      l$id,
      l$number,
      l$$show,
      l$season,
      l$watchStatus == null
          ? null
          : Object.hashAll(l$watchStatus.map((v) => v)),
      l$mediaFile == null ? null : Object.hashAll(l$mediaFile.map((v) => v)),
      l$metadata == null ? null : Object.hashAll(l$metadata.map((v) => v)),
      l$images == null ? null : Object.hashAll(l$images.map((v) => v)),
      l$$__typename,
    ]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Query$recentlyWatched$recentlyWatched$episode ||
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
    final l$$show = $show;
    final lOther$$show = other.$show;
    if (l$$show != lOther$$show) {
      return false;
    }
    final l$season = season;
    final lOther$season = other.season;
    if (l$season != lOther$season) {
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
    final l$$__typename = $__typename;
    final lOther$$__typename = other.$__typename;
    if (l$$__typename != lOther$$__typename) {
      return false;
    }
    return true;
  }
}

extension UtilityExtension$Query$recentlyWatched$recentlyWatched$episode
    on Query$recentlyWatched$recentlyWatched$episode {
  CopyWith$Query$recentlyWatched$recentlyWatched$episode<
    Query$recentlyWatched$recentlyWatched$episode
  >
  get copyWith =>
      CopyWith$Query$recentlyWatched$recentlyWatched$episode(this, (i) => i);
}

abstract class CopyWith$Query$recentlyWatched$recentlyWatched$episode<TRes> {
  factory CopyWith$Query$recentlyWatched$recentlyWatched$episode(
    Query$recentlyWatched$recentlyWatched$episode instance,
    TRes Function(Query$recentlyWatched$recentlyWatched$episode) then,
  ) = _CopyWithImpl$Query$recentlyWatched$recentlyWatched$episode;

  factory CopyWith$Query$recentlyWatched$recentlyWatched$episode.stub(
    TRes res,
  ) = _CopyWithStubImpl$Query$recentlyWatched$recentlyWatched$episode;

  TRes call({
    String? id,
    int? number,
    Query$recentlyWatched$recentlyWatched$episode$show? $show,
    Query$recentlyWatched$recentlyWatched$episode$season? season,
    List<Query$recentlyWatched$recentlyWatched$episode$watchStatus>?
    watchStatus,
    List<Query$recentlyWatched$recentlyWatched$episode$mediaFile>? mediaFile,
    List<Fragment$fragmentMetadata>? metadata,
    List<Fragment$fragmentImages>? images,
    String? $__typename,
  });
  CopyWith$Query$recentlyWatched$recentlyWatched$episode$show<TRes> get $show;
  CopyWith$Query$recentlyWatched$recentlyWatched$episode$season<TRes>
  get season;
  TRes watchStatus(
    Iterable<Query$recentlyWatched$recentlyWatched$episode$watchStatus>?
    Function(
      Iterable<
        CopyWith$Query$recentlyWatched$recentlyWatched$episode$watchStatus<
          Query$recentlyWatched$recentlyWatched$episode$watchStatus
        >
      >?,
    )
    _fn,
  );
  TRes mediaFile(
    Iterable<Query$recentlyWatched$recentlyWatched$episode$mediaFile>? Function(
      Iterable<
        CopyWith$Query$recentlyWatched$recentlyWatched$episode$mediaFile<
          Query$recentlyWatched$recentlyWatched$episode$mediaFile
        >
      >?,
    )
    _fn,
  );
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
}

class _CopyWithImpl$Query$recentlyWatched$recentlyWatched$episode<TRes>
    implements CopyWith$Query$recentlyWatched$recentlyWatched$episode<TRes> {
  _CopyWithImpl$Query$recentlyWatched$recentlyWatched$episode(
    this._instance,
    this._then,
  );

  final Query$recentlyWatched$recentlyWatched$episode _instance;

  final TRes Function(Query$recentlyWatched$recentlyWatched$episode) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? id = _undefined,
    Object? number = _undefined,
    Object? $show = _undefined,
    Object? season = _undefined,
    Object? watchStatus = _undefined,
    Object? mediaFile = _undefined,
    Object? metadata = _undefined,
    Object? images = _undefined,
    Object? $__typename = _undefined,
  }) => _then(
    Query$recentlyWatched$recentlyWatched$episode(
      id: id == _undefined || id == null ? _instance.id : (id as String),
      number: number == _undefined ? _instance.number : (number as int?),
      $show: $show == _undefined
          ? _instance.$show
          : ($show as Query$recentlyWatched$recentlyWatched$episode$show?),
      season: season == _undefined
          ? _instance.season
          : (season as Query$recentlyWatched$recentlyWatched$episode$season?),
      watchStatus: watchStatus == _undefined
          ? _instance.watchStatus
          : (watchStatus
                as List<
                  Query$recentlyWatched$recentlyWatched$episode$watchStatus
                >?),
      mediaFile: mediaFile == _undefined
          ? _instance.mediaFile
          : (mediaFile
                as List<
                  Query$recentlyWatched$recentlyWatched$episode$mediaFile
                >?),
      metadata: metadata == _undefined
          ? _instance.metadata
          : (metadata as List<Fragment$fragmentMetadata>?),
      images: images == _undefined
          ? _instance.images
          : (images as List<Fragment$fragmentImages>?),
      $__typename: $__typename == _undefined || $__typename == null
          ? _instance.$__typename
          : ($__typename as String),
    ),
  );

  CopyWith$Query$recentlyWatched$recentlyWatched$episode$show<TRes> get $show {
    final local$$show = _instance.$show;
    return local$$show == null
        ? CopyWith$Query$recentlyWatched$recentlyWatched$episode$show.stub(
            _then(_instance),
          )
        : CopyWith$Query$recentlyWatched$recentlyWatched$episode$show(
            local$$show,
            (e) => call($show: e),
          );
  }

  CopyWith$Query$recentlyWatched$recentlyWatched$episode$season<TRes>
  get season {
    final local$season = _instance.season;
    return local$season == null
        ? CopyWith$Query$recentlyWatched$recentlyWatched$episode$season.stub(
            _then(_instance),
          )
        : CopyWith$Query$recentlyWatched$recentlyWatched$episode$season(
            local$season,
            (e) => call(season: e),
          );
  }

  TRes watchStatus(
    Iterable<Query$recentlyWatched$recentlyWatched$episode$watchStatus>?
    Function(
      Iterable<
        CopyWith$Query$recentlyWatched$recentlyWatched$episode$watchStatus<
          Query$recentlyWatched$recentlyWatched$episode$watchStatus
        >
      >?,
    )
    _fn,
  ) => call(
    watchStatus: _fn(
      _instance.watchStatus?.map(
        (e) =>
            CopyWith$Query$recentlyWatched$recentlyWatched$episode$watchStatus(
              e,
              (i) => i,
            ),
      ),
    )?.toList(),
  );

  TRes mediaFile(
    Iterable<Query$recentlyWatched$recentlyWatched$episode$mediaFile>? Function(
      Iterable<
        CopyWith$Query$recentlyWatched$recentlyWatched$episode$mediaFile<
          Query$recentlyWatched$recentlyWatched$episode$mediaFile
        >
      >?,
    )
    _fn,
  ) => call(
    mediaFile: _fn(
      _instance.mediaFile?.map(
        (e) => CopyWith$Query$recentlyWatched$recentlyWatched$episode$mediaFile(
          e,
          (i) => i,
        ),
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

class _CopyWithStubImpl$Query$recentlyWatched$recentlyWatched$episode<TRes>
    implements CopyWith$Query$recentlyWatched$recentlyWatched$episode<TRes> {
  _CopyWithStubImpl$Query$recentlyWatched$recentlyWatched$episode(this._res);

  TRes _res;

  call({
    String? id,
    int? number,
    Query$recentlyWatched$recentlyWatched$episode$show? $show,
    Query$recentlyWatched$recentlyWatched$episode$season? season,
    List<Query$recentlyWatched$recentlyWatched$episode$watchStatus>?
    watchStatus,
    List<Query$recentlyWatched$recentlyWatched$episode$mediaFile>? mediaFile,
    List<Fragment$fragmentMetadata>? metadata,
    List<Fragment$fragmentImages>? images,
    String? $__typename,
  }) => _res;

  CopyWith$Query$recentlyWatched$recentlyWatched$episode$show<TRes> get $show =>
      CopyWith$Query$recentlyWatched$recentlyWatched$episode$show.stub(_res);

  CopyWith$Query$recentlyWatched$recentlyWatched$episode$season<TRes>
  get season =>
      CopyWith$Query$recentlyWatched$recentlyWatched$episode$season.stub(_res);

  watchStatus(_fn) => _res;

  mediaFile(_fn) => _res;

  metadata(_fn) => _res;

  images(_fn) => _res;
}

class Query$recentlyWatched$recentlyWatched$episode$show {
  Query$recentlyWatched$recentlyWatched$episode$show({
    required this.id,
    this.metadata,
    this.images,
    this.$__typename = 'Show',
  });

  factory Query$recentlyWatched$recentlyWatched$episode$show.fromJson(
    Map<String, dynamic> json,
  ) {
    final l$id = json['id'];
    final l$metadata = json['metadata'];
    final l$images = json['images'];
    final l$$__typename = json['__typename'];
    return Query$recentlyWatched$recentlyWatched$episode$show(
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
      $__typename: (l$$__typename as String),
    );
  }

  final String id;

  final List<Fragment$fragmentMetadata>? metadata;

  final List<Fragment$fragmentImages>? images;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$id = id;
    _resultData['id'] = l$id;
    final l$metadata = metadata;
    _resultData['metadata'] = l$metadata?.map((e) => e.toJson()).toList();
    final l$images = images;
    _resultData['images'] = l$images?.map((e) => e.toJson()).toList();
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$id = id;
    final l$metadata = metadata;
    final l$images = images;
    final l$$__typename = $__typename;
    return Object.hashAll([
      l$id,
      l$metadata == null ? null : Object.hashAll(l$metadata.map((v) => v)),
      l$images == null ? null : Object.hashAll(l$images.map((v) => v)),
      l$$__typename,
    ]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Query$recentlyWatched$recentlyWatched$episode$show ||
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
    final l$$__typename = $__typename;
    final lOther$$__typename = other.$__typename;
    if (l$$__typename != lOther$$__typename) {
      return false;
    }
    return true;
  }
}

extension UtilityExtension$Query$recentlyWatched$recentlyWatched$episode$show
    on Query$recentlyWatched$recentlyWatched$episode$show {
  CopyWith$Query$recentlyWatched$recentlyWatched$episode$show<
    Query$recentlyWatched$recentlyWatched$episode$show
  >
  get copyWith => CopyWith$Query$recentlyWatched$recentlyWatched$episode$show(
    this,
    (i) => i,
  );
}

abstract class CopyWith$Query$recentlyWatched$recentlyWatched$episode$show<
  TRes
> {
  factory CopyWith$Query$recentlyWatched$recentlyWatched$episode$show(
    Query$recentlyWatched$recentlyWatched$episode$show instance,
    TRes Function(Query$recentlyWatched$recentlyWatched$episode$show) then,
  ) = _CopyWithImpl$Query$recentlyWatched$recentlyWatched$episode$show;

  factory CopyWith$Query$recentlyWatched$recentlyWatched$episode$show.stub(
    TRes res,
  ) = _CopyWithStubImpl$Query$recentlyWatched$recentlyWatched$episode$show;

  TRes call({
    String? id,
    List<Fragment$fragmentMetadata>? metadata,
    List<Fragment$fragmentImages>? images,
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
}

class _CopyWithImpl$Query$recentlyWatched$recentlyWatched$episode$show<TRes>
    implements
        CopyWith$Query$recentlyWatched$recentlyWatched$episode$show<TRes> {
  _CopyWithImpl$Query$recentlyWatched$recentlyWatched$episode$show(
    this._instance,
    this._then,
  );

  final Query$recentlyWatched$recentlyWatched$episode$show _instance;

  final TRes Function(Query$recentlyWatched$recentlyWatched$episode$show) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? id = _undefined,
    Object? metadata = _undefined,
    Object? images = _undefined,
    Object? $__typename = _undefined,
  }) => _then(
    Query$recentlyWatched$recentlyWatched$episode$show(
      id: id == _undefined || id == null ? _instance.id : (id as String),
      metadata: metadata == _undefined
          ? _instance.metadata
          : (metadata as List<Fragment$fragmentMetadata>?),
      images: images == _undefined
          ? _instance.images
          : (images as List<Fragment$fragmentImages>?),
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
}

class _CopyWithStubImpl$Query$recentlyWatched$recentlyWatched$episode$show<TRes>
    implements
        CopyWith$Query$recentlyWatched$recentlyWatched$episode$show<TRes> {
  _CopyWithStubImpl$Query$recentlyWatched$recentlyWatched$episode$show(
    this._res,
  );

  TRes _res;

  call({
    String? id,
    List<Fragment$fragmentMetadata>? metadata,
    List<Fragment$fragmentImages>? images,
    String? $__typename,
  }) => _res;

  metadata(_fn) => _res;

  images(_fn) => _res;
}

class Query$recentlyWatched$recentlyWatched$episode$season {
  Query$recentlyWatched$recentlyWatched$episode$season({
    required this.number,
    this.$__typename = 'Season',
  });

  factory Query$recentlyWatched$recentlyWatched$episode$season.fromJson(
    Map<String, dynamic> json,
  ) {
    final l$number = json['number'];
    final l$$__typename = json['__typename'];
    return Query$recentlyWatched$recentlyWatched$episode$season(
      number: (l$number as int),
      $__typename: (l$$__typename as String),
    );
  }

  final int number;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$number = number;
    _resultData['number'] = l$number;
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$number = number;
    final l$$__typename = $__typename;
    return Object.hashAll([l$number, l$$__typename]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Query$recentlyWatched$recentlyWatched$episode$season ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$number = number;
    final lOther$number = other.number;
    if (l$number != lOther$number) {
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

extension UtilityExtension$Query$recentlyWatched$recentlyWatched$episode$season
    on Query$recentlyWatched$recentlyWatched$episode$season {
  CopyWith$Query$recentlyWatched$recentlyWatched$episode$season<
    Query$recentlyWatched$recentlyWatched$episode$season
  >
  get copyWith => CopyWith$Query$recentlyWatched$recentlyWatched$episode$season(
    this,
    (i) => i,
  );
}

abstract class CopyWith$Query$recentlyWatched$recentlyWatched$episode$season<
  TRes
> {
  factory CopyWith$Query$recentlyWatched$recentlyWatched$episode$season(
    Query$recentlyWatched$recentlyWatched$episode$season instance,
    TRes Function(Query$recentlyWatched$recentlyWatched$episode$season) then,
  ) = _CopyWithImpl$Query$recentlyWatched$recentlyWatched$episode$season;

  factory CopyWith$Query$recentlyWatched$recentlyWatched$episode$season.stub(
    TRes res,
  ) = _CopyWithStubImpl$Query$recentlyWatched$recentlyWatched$episode$season;

  TRes call({int? number, String? $__typename});
}

class _CopyWithImpl$Query$recentlyWatched$recentlyWatched$episode$season<TRes>
    implements
        CopyWith$Query$recentlyWatched$recentlyWatched$episode$season<TRes> {
  _CopyWithImpl$Query$recentlyWatched$recentlyWatched$episode$season(
    this._instance,
    this._then,
  );

  final Query$recentlyWatched$recentlyWatched$episode$season _instance;

  final TRes Function(Query$recentlyWatched$recentlyWatched$episode$season)
  _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({Object? number = _undefined, Object? $__typename = _undefined}) =>
      _then(
        Query$recentlyWatched$recentlyWatched$episode$season(
          number: number == _undefined || number == null
              ? _instance.number
              : (number as int),
          $__typename: $__typename == _undefined || $__typename == null
              ? _instance.$__typename
              : ($__typename as String),
        ),
      );
}

class _CopyWithStubImpl$Query$recentlyWatched$recentlyWatched$episode$season<
  TRes
>
    implements
        CopyWith$Query$recentlyWatched$recentlyWatched$episode$season<TRes> {
  _CopyWithStubImpl$Query$recentlyWatched$recentlyWatched$episode$season(
    this._res,
  );

  TRes _res;

  call({int? number, String? $__typename}) => _res;
}

class Query$recentlyWatched$recentlyWatched$episode$watchStatus {
  Query$recentlyWatched$recentlyWatched$episode$watchStatus({
    required this.id,
    required this.playQueueItemId,
    required this.progressInMilliseconds,
    required this.watched,
    this.$__typename = 'WatchStatus',
  });

  factory Query$recentlyWatched$recentlyWatched$episode$watchStatus.fromJson(
    Map<String, dynamic> json,
  ) {
    final l$id = json['id'];
    final l$playQueueItemId = json['playQueueItemId'];
    final l$progressInMilliseconds = json['progressInMilliseconds'];
    final l$watched = json['watched'];
    final l$$__typename = json['__typename'];
    return Query$recentlyWatched$recentlyWatched$episode$watchStatus(
      id: (l$id as String),
      playQueueItemId: (l$playQueueItemId as String),
      progressInMilliseconds: (l$progressInMilliseconds as int),
      watched: (l$watched as bool),
      $__typename: (l$$__typename as String),
    );
  }

  final String id;

  final String playQueueItemId;

  final int progressInMilliseconds;

  final bool watched;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$id = id;
    _resultData['id'] = l$id;
    final l$playQueueItemId = playQueueItemId;
    _resultData['playQueueItemId'] = l$playQueueItemId;
    final l$progressInMilliseconds = progressInMilliseconds;
    _resultData['progressInMilliseconds'] = l$progressInMilliseconds;
    final l$watched = watched;
    _resultData['watched'] = l$watched;
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$id = id;
    final l$playQueueItemId = playQueueItemId;
    final l$progressInMilliseconds = progressInMilliseconds;
    final l$watched = watched;
    final l$$__typename = $__typename;
    return Object.hashAll([
      l$id,
      l$playQueueItemId,
      l$progressInMilliseconds,
      l$watched,
      l$$__typename,
    ]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Query$recentlyWatched$recentlyWatched$episode$watchStatus ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$id = id;
    final lOther$id = other.id;
    if (l$id != lOther$id) {
      return false;
    }
    final l$playQueueItemId = playQueueItemId;
    final lOther$playQueueItemId = other.playQueueItemId;
    if (l$playQueueItemId != lOther$playQueueItemId) {
      return false;
    }
    final l$progressInMilliseconds = progressInMilliseconds;
    final lOther$progressInMilliseconds = other.progressInMilliseconds;
    if (l$progressInMilliseconds != lOther$progressInMilliseconds) {
      return false;
    }
    final l$watched = watched;
    final lOther$watched = other.watched;
    if (l$watched != lOther$watched) {
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

extension UtilityExtension$Query$recentlyWatched$recentlyWatched$episode$watchStatus
    on Query$recentlyWatched$recentlyWatched$episode$watchStatus {
  CopyWith$Query$recentlyWatched$recentlyWatched$episode$watchStatus<
    Query$recentlyWatched$recentlyWatched$episode$watchStatus
  >
  get copyWith =>
      CopyWith$Query$recentlyWatched$recentlyWatched$episode$watchStatus(
        this,
        (i) => i,
      );
}

abstract class CopyWith$Query$recentlyWatched$recentlyWatched$episode$watchStatus<
  TRes
> {
  factory CopyWith$Query$recentlyWatched$recentlyWatched$episode$watchStatus(
    Query$recentlyWatched$recentlyWatched$episode$watchStatus instance,
    TRes Function(Query$recentlyWatched$recentlyWatched$episode$watchStatus)
    then,
  ) = _CopyWithImpl$Query$recentlyWatched$recentlyWatched$episode$watchStatus;

  factory CopyWith$Query$recentlyWatched$recentlyWatched$episode$watchStatus.stub(
    TRes res,
  ) = _CopyWithStubImpl$Query$recentlyWatched$recentlyWatched$episode$watchStatus;

  TRes call({
    String? id,
    String? playQueueItemId,
    int? progressInMilliseconds,
    bool? watched,
    String? $__typename,
  });
}

class _CopyWithImpl$Query$recentlyWatched$recentlyWatched$episode$watchStatus<
  TRes
>
    implements
        CopyWith$Query$recentlyWatched$recentlyWatched$episode$watchStatus<
          TRes
        > {
  _CopyWithImpl$Query$recentlyWatched$recentlyWatched$episode$watchStatus(
    this._instance,
    this._then,
  );

  final Query$recentlyWatched$recentlyWatched$episode$watchStatus _instance;

  final TRes Function(Query$recentlyWatched$recentlyWatched$episode$watchStatus)
  _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? id = _undefined,
    Object? playQueueItemId = _undefined,
    Object? progressInMilliseconds = _undefined,
    Object? watched = _undefined,
    Object? $__typename = _undefined,
  }) => _then(
    Query$recentlyWatched$recentlyWatched$episode$watchStatus(
      id: id == _undefined || id == null ? _instance.id : (id as String),
      playQueueItemId: playQueueItemId == _undefined || playQueueItemId == null
          ? _instance.playQueueItemId
          : (playQueueItemId as String),
      progressInMilliseconds:
          progressInMilliseconds == _undefined || progressInMilliseconds == null
          ? _instance.progressInMilliseconds
          : (progressInMilliseconds as int),
      watched: watched == _undefined || watched == null
          ? _instance.watched
          : (watched as bool),
      $__typename: $__typename == _undefined || $__typename == null
          ? _instance.$__typename
          : ($__typename as String),
    ),
  );
}

class _CopyWithStubImpl$Query$recentlyWatched$recentlyWatched$episode$watchStatus<
  TRes
>
    implements
        CopyWith$Query$recentlyWatched$recentlyWatched$episode$watchStatus<
          TRes
        > {
  _CopyWithStubImpl$Query$recentlyWatched$recentlyWatched$episode$watchStatus(
    this._res,
  );

  TRes _res;

  call({
    String? id,
    String? playQueueItemId,
    int? progressInMilliseconds,
    bool? watched,
    String? $__typename,
  }) => _res;
}

class Query$recentlyWatched$recentlyWatched$episode$mediaFile {
  Query$recentlyWatched$recentlyWatched$episode$mediaFile({
    required this.id,
    this.durationInMilliseconds,
    this.$__typename = 'MediaFile',
  });

  factory Query$recentlyWatched$recentlyWatched$episode$mediaFile.fromJson(
    Map<String, dynamic> json,
  ) {
    final l$id = json['id'];
    final l$durationInMilliseconds = json['durationInMilliseconds'];
    final l$$__typename = json['__typename'];
    return Query$recentlyWatched$recentlyWatched$episode$mediaFile(
      id: (l$id as String),
      durationInMilliseconds: (l$durationInMilliseconds as int?),
      $__typename: (l$$__typename as String),
    );
  }

  final String id;

  final int? durationInMilliseconds;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$id = id;
    _resultData['id'] = l$id;
    final l$durationInMilliseconds = durationInMilliseconds;
    _resultData['durationInMilliseconds'] = l$durationInMilliseconds;
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$id = id;
    final l$durationInMilliseconds = durationInMilliseconds;
    final l$$__typename = $__typename;
    return Object.hashAll([l$id, l$durationInMilliseconds, l$$__typename]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Query$recentlyWatched$recentlyWatched$episode$mediaFile ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$id = id;
    final lOther$id = other.id;
    if (l$id != lOther$id) {
      return false;
    }
    final l$durationInMilliseconds = durationInMilliseconds;
    final lOther$durationInMilliseconds = other.durationInMilliseconds;
    if (l$durationInMilliseconds != lOther$durationInMilliseconds) {
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

extension UtilityExtension$Query$recentlyWatched$recentlyWatched$episode$mediaFile
    on Query$recentlyWatched$recentlyWatched$episode$mediaFile {
  CopyWith$Query$recentlyWatched$recentlyWatched$episode$mediaFile<
    Query$recentlyWatched$recentlyWatched$episode$mediaFile
  >
  get copyWith =>
      CopyWith$Query$recentlyWatched$recentlyWatched$episode$mediaFile(
        this,
        (i) => i,
      );
}

abstract class CopyWith$Query$recentlyWatched$recentlyWatched$episode$mediaFile<
  TRes
> {
  factory CopyWith$Query$recentlyWatched$recentlyWatched$episode$mediaFile(
    Query$recentlyWatched$recentlyWatched$episode$mediaFile instance,
    TRes Function(Query$recentlyWatched$recentlyWatched$episode$mediaFile) then,
  ) = _CopyWithImpl$Query$recentlyWatched$recentlyWatched$episode$mediaFile;

  factory CopyWith$Query$recentlyWatched$recentlyWatched$episode$mediaFile.stub(
    TRes res,
  ) = _CopyWithStubImpl$Query$recentlyWatched$recentlyWatched$episode$mediaFile;

  TRes call({String? id, int? durationInMilliseconds, String? $__typename});
}

class _CopyWithImpl$Query$recentlyWatched$recentlyWatched$episode$mediaFile<
  TRes
>
    implements
        CopyWith$Query$recentlyWatched$recentlyWatched$episode$mediaFile<TRes> {
  _CopyWithImpl$Query$recentlyWatched$recentlyWatched$episode$mediaFile(
    this._instance,
    this._then,
  );

  final Query$recentlyWatched$recentlyWatched$episode$mediaFile _instance;

  final TRes Function(Query$recentlyWatched$recentlyWatched$episode$mediaFile)
  _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? id = _undefined,
    Object? durationInMilliseconds = _undefined,
    Object? $__typename = _undefined,
  }) => _then(
    Query$recentlyWatched$recentlyWatched$episode$mediaFile(
      id: id == _undefined || id == null ? _instance.id : (id as String),
      durationInMilliseconds: durationInMilliseconds == _undefined
          ? _instance.durationInMilliseconds
          : (durationInMilliseconds as int?),
      $__typename: $__typename == _undefined || $__typename == null
          ? _instance.$__typename
          : ($__typename as String),
    ),
  );
}

class _CopyWithStubImpl$Query$recentlyWatched$recentlyWatched$episode$mediaFile<
  TRes
>
    implements
        CopyWith$Query$recentlyWatched$recentlyWatched$episode$mediaFile<TRes> {
  _CopyWithStubImpl$Query$recentlyWatched$recentlyWatched$episode$mediaFile(
    this._res,
  );

  TRes _res;

  call({String? id, int? durationInMilliseconds, String? $__typename}) => _res;
}

class Query$recentlyWatched$recentlyWatched$movie {
  Query$recentlyWatched$recentlyWatched$movie({
    required this.id,
    required this.name,
    this.images,
    this.metadata,
    this.watchStatus,
    this.mediaFile,
    this.$__typename = 'Movie',
  });

  factory Query$recentlyWatched$recentlyWatched$movie.fromJson(
    Map<String, dynamic> json,
  ) {
    final l$id = json['id'];
    final l$name = json['name'];
    final l$images = json['images'];
    final l$metadata = json['metadata'];
    final l$watchStatus = json['watchStatus'];
    final l$mediaFile = json['mediaFile'];
    final l$$__typename = json['__typename'];
    return Query$recentlyWatched$recentlyWatched$movie(
      id: (l$id as String),
      name: (l$name as String),
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
      watchStatus: (l$watchStatus as List<dynamic>?)
          ?.map(
            (e) =>
                Query$recentlyWatched$recentlyWatched$movie$watchStatus.fromJson(
                  (e as Map<String, dynamic>),
                ),
          )
          .toList(),
      mediaFile: (l$mediaFile as List<dynamic>?)
          ?.map(
            (e) =>
                Query$recentlyWatched$recentlyWatched$movie$mediaFile.fromJson(
                  (e as Map<String, dynamic>),
                ),
          )
          .toList(),
      $__typename: (l$$__typename as String),
    );
  }

  final String id;

  final String name;

  final List<Fragment$fragmentImages>? images;

  final List<Fragment$fragmentMetadata>? metadata;

  final List<Query$recentlyWatched$recentlyWatched$movie$watchStatus>?
  watchStatus;

  final List<Query$recentlyWatched$recentlyWatched$movie$mediaFile>? mediaFile;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$id = id;
    _resultData['id'] = l$id;
    final l$name = name;
    _resultData['name'] = l$name;
    final l$images = images;
    _resultData['images'] = l$images?.map((e) => e.toJson()).toList();
    final l$metadata = metadata;
    _resultData['metadata'] = l$metadata?.map((e) => e.toJson()).toList();
    final l$watchStatus = watchStatus;
    _resultData['watchStatus'] = l$watchStatus?.map((e) => e.toJson()).toList();
    final l$mediaFile = mediaFile;
    _resultData['mediaFile'] = l$mediaFile?.map((e) => e.toJson()).toList();
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$id = id;
    final l$name = name;
    final l$images = images;
    final l$metadata = metadata;
    final l$watchStatus = watchStatus;
    final l$mediaFile = mediaFile;
    final l$$__typename = $__typename;
    return Object.hashAll([
      l$id,
      l$name,
      l$images == null ? null : Object.hashAll(l$images.map((v) => v)),
      l$metadata == null ? null : Object.hashAll(l$metadata.map((v) => v)),
      l$watchStatus == null
          ? null
          : Object.hashAll(l$watchStatus.map((v) => v)),
      l$mediaFile == null ? null : Object.hashAll(l$mediaFile.map((v) => v)),
      l$$__typename,
    ]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Query$recentlyWatched$recentlyWatched$movie ||
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

extension UtilityExtension$Query$recentlyWatched$recentlyWatched$movie
    on Query$recentlyWatched$recentlyWatched$movie {
  CopyWith$Query$recentlyWatched$recentlyWatched$movie<
    Query$recentlyWatched$recentlyWatched$movie
  >
  get copyWith =>
      CopyWith$Query$recentlyWatched$recentlyWatched$movie(this, (i) => i);
}

abstract class CopyWith$Query$recentlyWatched$recentlyWatched$movie<TRes> {
  factory CopyWith$Query$recentlyWatched$recentlyWatched$movie(
    Query$recentlyWatched$recentlyWatched$movie instance,
    TRes Function(Query$recentlyWatched$recentlyWatched$movie) then,
  ) = _CopyWithImpl$Query$recentlyWatched$recentlyWatched$movie;

  factory CopyWith$Query$recentlyWatched$recentlyWatched$movie.stub(TRes res) =
      _CopyWithStubImpl$Query$recentlyWatched$recentlyWatched$movie;

  TRes call({
    String? id,
    String? name,
    List<Fragment$fragmentImages>? images,
    List<Fragment$fragmentMetadata>? metadata,
    List<Query$recentlyWatched$recentlyWatched$movie$watchStatus>? watchStatus,
    List<Query$recentlyWatched$recentlyWatched$movie$mediaFile>? mediaFile,
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
  TRes watchStatus(
    Iterable<Query$recentlyWatched$recentlyWatched$movie$watchStatus>? Function(
      Iterable<
        CopyWith$Query$recentlyWatched$recentlyWatched$movie$watchStatus<
          Query$recentlyWatched$recentlyWatched$movie$watchStatus
        >
      >?,
    )
    _fn,
  );
  TRes mediaFile(
    Iterable<Query$recentlyWatched$recentlyWatched$movie$mediaFile>? Function(
      Iterable<
        CopyWith$Query$recentlyWatched$recentlyWatched$movie$mediaFile<
          Query$recentlyWatched$recentlyWatched$movie$mediaFile
        >
      >?,
    )
    _fn,
  );
}

class _CopyWithImpl$Query$recentlyWatched$recentlyWatched$movie<TRes>
    implements CopyWith$Query$recentlyWatched$recentlyWatched$movie<TRes> {
  _CopyWithImpl$Query$recentlyWatched$recentlyWatched$movie(
    this._instance,
    this._then,
  );

  final Query$recentlyWatched$recentlyWatched$movie _instance;

  final TRes Function(Query$recentlyWatched$recentlyWatched$movie) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? id = _undefined,
    Object? name = _undefined,
    Object? images = _undefined,
    Object? metadata = _undefined,
    Object? watchStatus = _undefined,
    Object? mediaFile = _undefined,
    Object? $__typename = _undefined,
  }) => _then(
    Query$recentlyWatched$recentlyWatched$movie(
      id: id == _undefined || id == null ? _instance.id : (id as String),
      name: name == _undefined || name == null
          ? _instance.name
          : (name as String),
      images: images == _undefined
          ? _instance.images
          : (images as List<Fragment$fragmentImages>?),
      metadata: metadata == _undefined
          ? _instance.metadata
          : (metadata as List<Fragment$fragmentMetadata>?),
      watchStatus: watchStatus == _undefined
          ? _instance.watchStatus
          : (watchStatus
                as List<
                  Query$recentlyWatched$recentlyWatched$movie$watchStatus
                >?),
      mediaFile: mediaFile == _undefined
          ? _instance.mediaFile
          : (mediaFile
                as List<
                  Query$recentlyWatched$recentlyWatched$movie$mediaFile
                >?),
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

  TRes watchStatus(
    Iterable<Query$recentlyWatched$recentlyWatched$movie$watchStatus>? Function(
      Iterable<
        CopyWith$Query$recentlyWatched$recentlyWatched$movie$watchStatus<
          Query$recentlyWatched$recentlyWatched$movie$watchStatus
        >
      >?,
    )
    _fn,
  ) => call(
    watchStatus: _fn(
      _instance.watchStatus?.map(
        (e) => CopyWith$Query$recentlyWatched$recentlyWatched$movie$watchStatus(
          e,
          (i) => i,
        ),
      ),
    )?.toList(),
  );

  TRes mediaFile(
    Iterable<Query$recentlyWatched$recentlyWatched$movie$mediaFile>? Function(
      Iterable<
        CopyWith$Query$recentlyWatched$recentlyWatched$movie$mediaFile<
          Query$recentlyWatched$recentlyWatched$movie$mediaFile
        >
      >?,
    )
    _fn,
  ) => call(
    mediaFile: _fn(
      _instance.mediaFile?.map(
        (e) => CopyWith$Query$recentlyWatched$recentlyWatched$movie$mediaFile(
          e,
          (i) => i,
        ),
      ),
    )?.toList(),
  );
}

class _CopyWithStubImpl$Query$recentlyWatched$recentlyWatched$movie<TRes>
    implements CopyWith$Query$recentlyWatched$recentlyWatched$movie<TRes> {
  _CopyWithStubImpl$Query$recentlyWatched$recentlyWatched$movie(this._res);

  TRes _res;

  call({
    String? id,
    String? name,
    List<Fragment$fragmentImages>? images,
    List<Fragment$fragmentMetadata>? metadata,
    List<Query$recentlyWatched$recentlyWatched$movie$watchStatus>? watchStatus,
    List<Query$recentlyWatched$recentlyWatched$movie$mediaFile>? mediaFile,
    String? $__typename,
  }) => _res;

  images(_fn) => _res;

  metadata(_fn) => _res;

  watchStatus(_fn) => _res;

  mediaFile(_fn) => _res;
}

class Query$recentlyWatched$recentlyWatched$movie$watchStatus {
  Query$recentlyWatched$recentlyWatched$movie$watchStatus({
    required this.id,
    required this.playQueueItemId,
    required this.progressInMilliseconds,
    required this.watched,
    this.$__typename = 'WatchStatus',
  });

  factory Query$recentlyWatched$recentlyWatched$movie$watchStatus.fromJson(
    Map<String, dynamic> json,
  ) {
    final l$id = json['id'];
    final l$playQueueItemId = json['playQueueItemId'];
    final l$progressInMilliseconds = json['progressInMilliseconds'];
    final l$watched = json['watched'];
    final l$$__typename = json['__typename'];
    return Query$recentlyWatched$recentlyWatched$movie$watchStatus(
      id: (l$id as String),
      playQueueItemId: (l$playQueueItemId as String),
      progressInMilliseconds: (l$progressInMilliseconds as int),
      watched: (l$watched as bool),
      $__typename: (l$$__typename as String),
    );
  }

  final String id;

  final String playQueueItemId;

  final int progressInMilliseconds;

  final bool watched;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$id = id;
    _resultData['id'] = l$id;
    final l$playQueueItemId = playQueueItemId;
    _resultData['playQueueItemId'] = l$playQueueItemId;
    final l$progressInMilliseconds = progressInMilliseconds;
    _resultData['progressInMilliseconds'] = l$progressInMilliseconds;
    final l$watched = watched;
    _resultData['watched'] = l$watched;
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$id = id;
    final l$playQueueItemId = playQueueItemId;
    final l$progressInMilliseconds = progressInMilliseconds;
    final l$watched = watched;
    final l$$__typename = $__typename;
    return Object.hashAll([
      l$id,
      l$playQueueItemId,
      l$progressInMilliseconds,
      l$watched,
      l$$__typename,
    ]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Query$recentlyWatched$recentlyWatched$movie$watchStatus ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$id = id;
    final lOther$id = other.id;
    if (l$id != lOther$id) {
      return false;
    }
    final l$playQueueItemId = playQueueItemId;
    final lOther$playQueueItemId = other.playQueueItemId;
    if (l$playQueueItemId != lOther$playQueueItemId) {
      return false;
    }
    final l$progressInMilliseconds = progressInMilliseconds;
    final lOther$progressInMilliseconds = other.progressInMilliseconds;
    if (l$progressInMilliseconds != lOther$progressInMilliseconds) {
      return false;
    }
    final l$watched = watched;
    final lOther$watched = other.watched;
    if (l$watched != lOther$watched) {
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

extension UtilityExtension$Query$recentlyWatched$recentlyWatched$movie$watchStatus
    on Query$recentlyWatched$recentlyWatched$movie$watchStatus {
  CopyWith$Query$recentlyWatched$recentlyWatched$movie$watchStatus<
    Query$recentlyWatched$recentlyWatched$movie$watchStatus
  >
  get copyWith =>
      CopyWith$Query$recentlyWatched$recentlyWatched$movie$watchStatus(
        this,
        (i) => i,
      );
}

abstract class CopyWith$Query$recentlyWatched$recentlyWatched$movie$watchStatus<
  TRes
> {
  factory CopyWith$Query$recentlyWatched$recentlyWatched$movie$watchStatus(
    Query$recentlyWatched$recentlyWatched$movie$watchStatus instance,
    TRes Function(Query$recentlyWatched$recentlyWatched$movie$watchStatus) then,
  ) = _CopyWithImpl$Query$recentlyWatched$recentlyWatched$movie$watchStatus;

  factory CopyWith$Query$recentlyWatched$recentlyWatched$movie$watchStatus.stub(
    TRes res,
  ) = _CopyWithStubImpl$Query$recentlyWatched$recentlyWatched$movie$watchStatus;

  TRes call({
    String? id,
    String? playQueueItemId,
    int? progressInMilliseconds,
    bool? watched,
    String? $__typename,
  });
}

class _CopyWithImpl$Query$recentlyWatched$recentlyWatched$movie$watchStatus<
  TRes
>
    implements
        CopyWith$Query$recentlyWatched$recentlyWatched$movie$watchStatus<TRes> {
  _CopyWithImpl$Query$recentlyWatched$recentlyWatched$movie$watchStatus(
    this._instance,
    this._then,
  );

  final Query$recentlyWatched$recentlyWatched$movie$watchStatus _instance;

  final TRes Function(Query$recentlyWatched$recentlyWatched$movie$watchStatus)
  _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? id = _undefined,
    Object? playQueueItemId = _undefined,
    Object? progressInMilliseconds = _undefined,
    Object? watched = _undefined,
    Object? $__typename = _undefined,
  }) => _then(
    Query$recentlyWatched$recentlyWatched$movie$watchStatus(
      id: id == _undefined || id == null ? _instance.id : (id as String),
      playQueueItemId: playQueueItemId == _undefined || playQueueItemId == null
          ? _instance.playQueueItemId
          : (playQueueItemId as String),
      progressInMilliseconds:
          progressInMilliseconds == _undefined || progressInMilliseconds == null
          ? _instance.progressInMilliseconds
          : (progressInMilliseconds as int),
      watched: watched == _undefined || watched == null
          ? _instance.watched
          : (watched as bool),
      $__typename: $__typename == _undefined || $__typename == null
          ? _instance.$__typename
          : ($__typename as String),
    ),
  );
}

class _CopyWithStubImpl$Query$recentlyWatched$recentlyWatched$movie$watchStatus<
  TRes
>
    implements
        CopyWith$Query$recentlyWatched$recentlyWatched$movie$watchStatus<TRes> {
  _CopyWithStubImpl$Query$recentlyWatched$recentlyWatched$movie$watchStatus(
    this._res,
  );

  TRes _res;

  call({
    String? id,
    String? playQueueItemId,
    int? progressInMilliseconds,
    bool? watched,
    String? $__typename,
  }) => _res;
}

class Query$recentlyWatched$recentlyWatched$movie$mediaFile {
  Query$recentlyWatched$recentlyWatched$movie$mediaFile({
    required this.id,
    this.durationInMilliseconds,
    this.$__typename = 'MediaFile',
  });

  factory Query$recentlyWatched$recentlyWatched$movie$mediaFile.fromJson(
    Map<String, dynamic> json,
  ) {
    final l$id = json['id'];
    final l$durationInMilliseconds = json['durationInMilliseconds'];
    final l$$__typename = json['__typename'];
    return Query$recentlyWatched$recentlyWatched$movie$mediaFile(
      id: (l$id as String),
      durationInMilliseconds: (l$durationInMilliseconds as int?),
      $__typename: (l$$__typename as String),
    );
  }

  final String id;

  final int? durationInMilliseconds;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$id = id;
    _resultData['id'] = l$id;
    final l$durationInMilliseconds = durationInMilliseconds;
    _resultData['durationInMilliseconds'] = l$durationInMilliseconds;
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$id = id;
    final l$durationInMilliseconds = durationInMilliseconds;
    final l$$__typename = $__typename;
    return Object.hashAll([l$id, l$durationInMilliseconds, l$$__typename]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Query$recentlyWatched$recentlyWatched$movie$mediaFile ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$id = id;
    final lOther$id = other.id;
    if (l$id != lOther$id) {
      return false;
    }
    final l$durationInMilliseconds = durationInMilliseconds;
    final lOther$durationInMilliseconds = other.durationInMilliseconds;
    if (l$durationInMilliseconds != lOther$durationInMilliseconds) {
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

extension UtilityExtension$Query$recentlyWatched$recentlyWatched$movie$mediaFile
    on Query$recentlyWatched$recentlyWatched$movie$mediaFile {
  CopyWith$Query$recentlyWatched$recentlyWatched$movie$mediaFile<
    Query$recentlyWatched$recentlyWatched$movie$mediaFile
  >
  get copyWith =>
      CopyWith$Query$recentlyWatched$recentlyWatched$movie$mediaFile(
        this,
        (i) => i,
      );
}

abstract class CopyWith$Query$recentlyWatched$recentlyWatched$movie$mediaFile<
  TRes
> {
  factory CopyWith$Query$recentlyWatched$recentlyWatched$movie$mediaFile(
    Query$recentlyWatched$recentlyWatched$movie$mediaFile instance,
    TRes Function(Query$recentlyWatched$recentlyWatched$movie$mediaFile) then,
  ) = _CopyWithImpl$Query$recentlyWatched$recentlyWatched$movie$mediaFile;

  factory CopyWith$Query$recentlyWatched$recentlyWatched$movie$mediaFile.stub(
    TRes res,
  ) = _CopyWithStubImpl$Query$recentlyWatched$recentlyWatched$movie$mediaFile;

  TRes call({String? id, int? durationInMilliseconds, String? $__typename});
}

class _CopyWithImpl$Query$recentlyWatched$recentlyWatched$movie$mediaFile<TRes>
    implements
        CopyWith$Query$recentlyWatched$recentlyWatched$movie$mediaFile<TRes> {
  _CopyWithImpl$Query$recentlyWatched$recentlyWatched$movie$mediaFile(
    this._instance,
    this._then,
  );

  final Query$recentlyWatched$recentlyWatched$movie$mediaFile _instance;

  final TRes Function(Query$recentlyWatched$recentlyWatched$movie$mediaFile)
  _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? id = _undefined,
    Object? durationInMilliseconds = _undefined,
    Object? $__typename = _undefined,
  }) => _then(
    Query$recentlyWatched$recentlyWatched$movie$mediaFile(
      id: id == _undefined || id == null ? _instance.id : (id as String),
      durationInMilliseconds: durationInMilliseconds == _undefined
          ? _instance.durationInMilliseconds
          : (durationInMilliseconds as int?),
      $__typename: $__typename == _undefined || $__typename == null
          ? _instance.$__typename
          : ($__typename as String),
    ),
  );
}

class _CopyWithStubImpl$Query$recentlyWatched$recentlyWatched$movie$mediaFile<
  TRes
>
    implements
        CopyWith$Query$recentlyWatched$recentlyWatched$movie$mediaFile<TRes> {
  _CopyWithStubImpl$Query$recentlyWatched$recentlyWatched$movie$mediaFile(
    this._res,
  );

  TRes _res;

  call({String? id, int? durationInMilliseconds, String? $__typename}) => _res;
}

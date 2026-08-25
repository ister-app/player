import 'fragmentCredit.graphql.dart';
import 'fragmentImages.graphql.dart';
import 'fragmentMetadata.graphql.dart';

import 'package:gql/ast.dart';

class Variables$Query$showById {
  factory Variables$Query$showById({required String id}) =>
      Variables$Query$showById._({r'id': id});

  Variables$Query$showById._(this._$data);

  factory Variables$Query$showById.fromJson(Map<String, dynamic> data) {
    final result$data = <String, dynamic>{};
    final l$id = data['id'];
    result$data['id'] = (l$id as String);
    return Variables$Query$showById._(result$data);
  }

  Map<String, dynamic> _$data;

  String get id => (_$data['id'] as String);

  Map<String, dynamic> toJson() {
    final result$data = <String, dynamic>{};
    final l$id = id;
    result$data['id'] = l$id;
    return result$data;
  }

  CopyWith$Variables$Query$showById<Variables$Query$showById> get copyWith =>
      CopyWith$Variables$Query$showById(this, (i) => i);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Variables$Query$showById ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$id = id;
    final lOther$id = other.id;
    if (l$id != lOther$id) {
      return false;
    }
    return true;
  }

  @override
  int get hashCode {
    final l$id = id;
    return Object.hashAll([l$id]);
  }
}

abstract class CopyWith$Variables$Query$showById<TRes> {
  factory CopyWith$Variables$Query$showById(
    Variables$Query$showById instance,
    TRes Function(Variables$Query$showById) then,
  ) = _CopyWithImpl$Variables$Query$showById;

  factory CopyWith$Variables$Query$showById.stub(TRes res) =
      _CopyWithStubImpl$Variables$Query$showById;

  TRes call({String? id});
}

class _CopyWithImpl$Variables$Query$showById<TRes>
    implements CopyWith$Variables$Query$showById<TRes> {
  _CopyWithImpl$Variables$Query$showById(this._instance, this._then);

  final Variables$Query$showById _instance;

  final TRes Function(Variables$Query$showById) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({Object? id = _undefined}) => _then(
    Variables$Query$showById._({
      ..._instance._$data,
      if (id != _undefined && id != null) 'id': (id as String),
    }),
  );
}

class _CopyWithStubImpl$Variables$Query$showById<TRes>
    implements CopyWith$Variables$Query$showById<TRes> {
  _CopyWithStubImpl$Variables$Query$showById(this._res);

  TRes _res;

  call({String? id}) => _res;
}

class Query$showById {
  Query$showById({this.showById, this.$__typename = 'Query'});

  factory Query$showById.fromJson(Map<String, dynamic> json) {
    final l$showById = json['showById'];
    final l$$__typename = json['__typename'];
    return Query$showById(
      showById: l$showById == null
          ? null
          : Query$showById$showById.fromJson(
              (l$showById as Map<String, dynamic>),
            ),
      $__typename: (l$$__typename as String),
    );
  }

  final Query$showById$showById? showById;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$showById = showById;
    _resultData['showById'] = l$showById?.toJson();
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$showById = showById;
    final l$$__typename = $__typename;
    return Object.hashAll([l$showById, l$$__typename]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Query$showById || runtimeType != other.runtimeType) {
      return false;
    }
    final l$showById = showById;
    final lOther$showById = other.showById;
    if (l$showById != lOther$showById) {
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

extension UtilityExtension$Query$showById on Query$showById {
  CopyWith$Query$showById<Query$showById> get copyWith =>
      CopyWith$Query$showById(this, (i) => i);
}

abstract class CopyWith$Query$showById<TRes> {
  factory CopyWith$Query$showById(
    Query$showById instance,
    TRes Function(Query$showById) then,
  ) = _CopyWithImpl$Query$showById;

  factory CopyWith$Query$showById.stub(TRes res) =
      _CopyWithStubImpl$Query$showById;

  TRes call({Query$showById$showById? showById, String? $__typename});
  CopyWith$Query$showById$showById<TRes> get showById;
}

class _CopyWithImpl$Query$showById<TRes>
    implements CopyWith$Query$showById<TRes> {
  _CopyWithImpl$Query$showById(this._instance, this._then);

  final Query$showById _instance;

  final TRes Function(Query$showById) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? showById = _undefined,
    Object? $__typename = _undefined,
  }) => _then(
    Query$showById(
      showById: showById == _undefined
          ? _instance.showById
          : (showById as Query$showById$showById?),
      $__typename: $__typename == _undefined || $__typename == null
          ? _instance.$__typename
          : ($__typename as String),
    ),
  );

  CopyWith$Query$showById$showById<TRes> get showById {
    final local$showById = _instance.showById;
    return local$showById == null
        ? CopyWith$Query$showById$showById.stub(_then(_instance))
        : CopyWith$Query$showById$showById(
            local$showById,
            (e) => call(showById: e),
          );
  }
}

class _CopyWithStubImpl$Query$showById<TRes>
    implements CopyWith$Query$showById<TRes> {
  _CopyWithStubImpl$Query$showById(this._res);

  TRes _res;

  call({Query$showById$showById? showById, String? $__typename}) => _res;

  CopyWith$Query$showById$showById<TRes> get showById =>
      CopyWith$Query$showById$showById.stub(_res);
}

const documentNodeQueryshowById = DocumentNode(
  definitions: [
    OperationDefinitionNode(
      type: OperationType.query,
      name: NameNode(value: 'showById'),
      variableDefinitions: [
        VariableDefinitionNode(
          variable: VariableNode(name: NameNode(value: 'id')),
          type: NamedTypeNode(name: NameNode(value: 'ID'), isNonNull: true),
          defaultValue: DefaultValueNode(value: null),
          directives: [],
        ),
      ],
      directives: [],
      selectionSet: SelectionSetNode(
        selections: [
          FieldNode(
            name: NameNode(value: 'showById'),
            alias: null,
            arguments: [
              ArgumentNode(
                name: NameNode(value: 'id'),
                value: VariableNode(name: NameNode(value: 'id')),
              ),
            ],
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
                  name: NameNode(value: 'seasons'),
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
                  name: NameNode(value: 'cast'),
                  alias: null,
                  arguments: [],
                  directives: [],
                  selectionSet: SelectionSetNode(
                    selections: [
                      FragmentSpreadNode(
                        name: NameNode(value: 'fragmentCastMember'),
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
                  name: NameNode(value: 'tmdbId'),
                  alias: null,
                  arguments: [],
                  directives: [],
                  selectionSet: null,
                ),
                FieldNode(
                  name: NameNode(value: 'imdbId'),
                  alias: null,
                  arguments: [],
                  directives: [],
                  selectionSet: null,
                ),
                FieldNode(
                  name: NameNode(value: 'voteAverage'),
                  alias: null,
                  arguments: [],
                  directives: [],
                  selectionSet: null,
                ),
                FieldNode(
                  name: NameNode(value: 'voteCount'),
                  alias: null,
                  arguments: [],
                  directives: [],
                  selectionSet: null,
                ),
                FieldNode(
                  name: NameNode(value: 'contentRating'),
                  alias: null,
                  arguments: [],
                  directives: [],
                  selectionSet: null,
                ),
                FieldNode(
                  name: NameNode(value: 'status'),
                  alias: null,
                  arguments: [],
                  directives: [],
                  selectionSet: null,
                ),
                FieldNode(
                  name: NameNode(value: 'homepage'),
                  alias: null,
                  arguments: [],
                  directives: [],
                  selectionSet: null,
                ),
                FieldNode(
                  name: NameNode(value: 'networks'),
                  alias: null,
                  arguments: [],
                  directives: [],
                  selectionSet: null,
                ),
                FieldNode(
                  name: NameNode(value: 'studios'),
                  alias: null,
                  arguments: [],
                  directives: [],
                  selectionSet: null,
                ),
                FieldNode(
                  name: NameNode(value: 'originCountry'),
                  alias: null,
                  arguments: [],
                  directives: [],
                  selectionSet: null,
                ),
                FieldNode(
                  name: NameNode(value: 'keywords'),
                  alias: null,
                  arguments: [],
                  directives: [],
                  selectionSet: null,
                ),
                FieldNode(
                  name: NameNode(value: 'trailerKey'),
                  alias: null,
                  arguments: [],
                  directives: [],
                  selectionSet: null,
                ),
                FieldNode(
                  name: NameNode(value: 'trailerSite'),
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
    fragmentDefinitionfragmentImages,
    fragmentDefinitionfragmentMetadata,
    fragmentDefinitionfragmentCastMember,
  ],
);

class Query$showById$showById {
  Query$showById$showById({
    required this.id,
    this.images,
    required this.name,
    required this.releaseYear,
    this.metadata,
    this.seasons,
    this.cast,
    this.rating,
    this.tmdbId,
    this.imdbId,
    this.voteAverage,
    this.voteCount,
    this.contentRating,
    this.status,
    this.homepage,
    this.networks,
    this.studios,
    this.originCountry,
    this.keywords,
    this.trailerKey,
    this.trailerSite,
    this.$__typename = 'Show',
  });

  factory Query$showById$showById.fromJson(Map<String, dynamic> json) {
    final l$id = json['id'];
    final l$images = json['images'];
    final l$name = json['name'];
    final l$releaseYear = json['releaseYear'];
    final l$metadata = json['metadata'];
    final l$seasons = json['seasons'];
    final l$cast = json['cast'];
    final l$rating = json['rating'];
    final l$tmdbId = json['tmdbId'];
    final l$imdbId = json['imdbId'];
    final l$voteAverage = json['voteAverage'];
    final l$voteCount = json['voteCount'];
    final l$contentRating = json['contentRating'];
    final l$status = json['status'];
    final l$homepage = json['homepage'];
    final l$networks = json['networks'];
    final l$studios = json['studios'];
    final l$originCountry = json['originCountry'];
    final l$keywords = json['keywords'];
    final l$trailerKey = json['trailerKey'];
    final l$trailerSite = json['trailerSite'];
    final l$$__typename = json['__typename'];
    return Query$showById$showById(
      id: (l$id as String),
      images: (l$images as List<dynamic>?)
          ?.map(
            (e) =>
                Fragment$fragmentImages.fromJson((e as Map<String, dynamic>)),
          )
          .toList(),
      name: (l$name as String),
      releaseYear: (l$releaseYear as int),
      metadata: (l$metadata as List<dynamic>?)
          ?.map(
            (e) =>
                Fragment$fragmentMetadata.fromJson((e as Map<String, dynamic>)),
          )
          .toList(),
      seasons: (l$seasons as List<dynamic>?)
          ?.map(
            (e) => Query$showById$showById$seasons.fromJson(
              (e as Map<String, dynamic>),
            ),
          )
          .toList(),
      cast: (l$cast as List<dynamic>?)
          ?.map(
            (e) => Fragment$fragmentCastMember.fromJson(
              (e as Map<String, dynamic>),
            ),
          )
          .toList(),
      rating: (l$rating as int?),
      tmdbId: (l$tmdbId as int?),
      imdbId: (l$imdbId as String?),
      voteAverage: (l$voteAverage as num?)?.toDouble(),
      voteCount: (l$voteCount as int?),
      contentRating: (l$contentRating as String?),
      status: (l$status as String?),
      homepage: (l$homepage as String?),
      networks: (l$networks as String?),
      studios: (l$studios as String?),
      originCountry: (l$originCountry as String?),
      keywords: (l$keywords as String?),
      trailerKey: (l$trailerKey as String?),
      trailerSite: (l$trailerSite as String?),
      $__typename: (l$$__typename as String),
    );
  }

  final String id;

  final List<Fragment$fragmentImages>? images;

  final String name;

  final int releaseYear;

  final List<Fragment$fragmentMetadata>? metadata;

  final List<Query$showById$showById$seasons>? seasons;

  final List<Fragment$fragmentCastMember>? cast;

  final int? rating;

  final int? tmdbId;

  final String? imdbId;

  final double? voteAverage;

  final int? voteCount;

  final String? contentRating;

  final String? status;

  final String? homepage;

  final String? networks;

  final String? studios;

  final String? originCountry;

  final String? keywords;

  final String? trailerKey;

  final String? trailerSite;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$id = id;
    _resultData['id'] = l$id;
    final l$images = images;
    _resultData['images'] = l$images?.map((e) => e.toJson()).toList();
    final l$name = name;
    _resultData['name'] = l$name;
    final l$releaseYear = releaseYear;
    _resultData['releaseYear'] = l$releaseYear;
    final l$metadata = metadata;
    _resultData['metadata'] = l$metadata?.map((e) => e.toJson()).toList();
    final l$seasons = seasons;
    _resultData['seasons'] = l$seasons?.map((e) => e.toJson()).toList();
    final l$cast = cast;
    _resultData['cast'] = l$cast?.map((e) => e.toJson()).toList();
    final l$rating = rating;
    _resultData['rating'] = l$rating;
    final l$tmdbId = tmdbId;
    _resultData['tmdbId'] = l$tmdbId;
    final l$imdbId = imdbId;
    _resultData['imdbId'] = l$imdbId;
    final l$voteAverage = voteAverage;
    _resultData['voteAverage'] = l$voteAverage;
    final l$voteCount = voteCount;
    _resultData['voteCount'] = l$voteCount;
    final l$contentRating = contentRating;
    _resultData['contentRating'] = l$contentRating;
    final l$status = status;
    _resultData['status'] = l$status;
    final l$homepage = homepage;
    _resultData['homepage'] = l$homepage;
    final l$networks = networks;
    _resultData['networks'] = l$networks;
    final l$studios = studios;
    _resultData['studios'] = l$studios;
    final l$originCountry = originCountry;
    _resultData['originCountry'] = l$originCountry;
    final l$keywords = keywords;
    _resultData['keywords'] = l$keywords;
    final l$trailerKey = trailerKey;
    _resultData['trailerKey'] = l$trailerKey;
    final l$trailerSite = trailerSite;
    _resultData['trailerSite'] = l$trailerSite;
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$id = id;
    final l$images = images;
    final l$name = name;
    final l$releaseYear = releaseYear;
    final l$metadata = metadata;
    final l$seasons = seasons;
    final l$cast = cast;
    final l$rating = rating;
    final l$tmdbId = tmdbId;
    final l$imdbId = imdbId;
    final l$voteAverage = voteAverage;
    final l$voteCount = voteCount;
    final l$contentRating = contentRating;
    final l$status = status;
    final l$homepage = homepage;
    final l$networks = networks;
    final l$studios = studios;
    final l$originCountry = originCountry;
    final l$keywords = keywords;
    final l$trailerKey = trailerKey;
    final l$trailerSite = trailerSite;
    final l$$__typename = $__typename;
    return Object.hashAll([
      l$id,
      l$images == null ? null : Object.hashAll(l$images.map((v) => v)),
      l$name,
      l$releaseYear,
      l$metadata == null ? null : Object.hashAll(l$metadata.map((v) => v)),
      l$seasons == null ? null : Object.hashAll(l$seasons.map((v) => v)),
      l$cast == null ? null : Object.hashAll(l$cast.map((v) => v)),
      l$rating,
      l$tmdbId,
      l$imdbId,
      l$voteAverage,
      l$voteCount,
      l$contentRating,
      l$status,
      l$homepage,
      l$networks,
      l$studios,
      l$originCountry,
      l$keywords,
      l$trailerKey,
      l$trailerSite,
      l$$__typename,
    ]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Query$showById$showById || runtimeType != other.runtimeType) {
      return false;
    }
    final l$id = id;
    final lOther$id = other.id;
    if (l$id != lOther$id) {
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
    final l$seasons = seasons;
    final lOther$seasons = other.seasons;
    if (l$seasons != null && lOther$seasons != null) {
      if (l$seasons.length != lOther$seasons.length) {
        return false;
      }
      for (int i = 0; i < l$seasons.length; i++) {
        final l$seasons$entry = l$seasons[i];
        final lOther$seasons$entry = lOther$seasons[i];
        if (l$seasons$entry != lOther$seasons$entry) {
          return false;
        }
      }
    } else if (l$seasons != lOther$seasons) {
      return false;
    }
    final l$cast = cast;
    final lOther$cast = other.cast;
    if (l$cast != null && lOther$cast != null) {
      if (l$cast.length != lOther$cast.length) {
        return false;
      }
      for (int i = 0; i < l$cast.length; i++) {
        final l$cast$entry = l$cast[i];
        final lOther$cast$entry = lOther$cast[i];
        if (l$cast$entry != lOther$cast$entry) {
          return false;
        }
      }
    } else if (l$cast != lOther$cast) {
      return false;
    }
    final l$rating = rating;
    final lOther$rating = other.rating;
    if (l$rating != lOther$rating) {
      return false;
    }
    final l$tmdbId = tmdbId;
    final lOther$tmdbId = other.tmdbId;
    if (l$tmdbId != lOther$tmdbId) {
      return false;
    }
    final l$imdbId = imdbId;
    final lOther$imdbId = other.imdbId;
    if (l$imdbId != lOther$imdbId) {
      return false;
    }
    final l$voteAverage = voteAverage;
    final lOther$voteAverage = other.voteAverage;
    if (l$voteAverage != lOther$voteAverage) {
      return false;
    }
    final l$voteCount = voteCount;
    final lOther$voteCount = other.voteCount;
    if (l$voteCount != lOther$voteCount) {
      return false;
    }
    final l$contentRating = contentRating;
    final lOther$contentRating = other.contentRating;
    if (l$contentRating != lOther$contentRating) {
      return false;
    }
    final l$status = status;
    final lOther$status = other.status;
    if (l$status != lOther$status) {
      return false;
    }
    final l$homepage = homepage;
    final lOther$homepage = other.homepage;
    if (l$homepage != lOther$homepage) {
      return false;
    }
    final l$networks = networks;
    final lOther$networks = other.networks;
    if (l$networks != lOther$networks) {
      return false;
    }
    final l$studios = studios;
    final lOther$studios = other.studios;
    if (l$studios != lOther$studios) {
      return false;
    }
    final l$originCountry = originCountry;
    final lOther$originCountry = other.originCountry;
    if (l$originCountry != lOther$originCountry) {
      return false;
    }
    final l$keywords = keywords;
    final lOther$keywords = other.keywords;
    if (l$keywords != lOther$keywords) {
      return false;
    }
    final l$trailerKey = trailerKey;
    final lOther$trailerKey = other.trailerKey;
    if (l$trailerKey != lOther$trailerKey) {
      return false;
    }
    final l$trailerSite = trailerSite;
    final lOther$trailerSite = other.trailerSite;
    if (l$trailerSite != lOther$trailerSite) {
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

extension UtilityExtension$Query$showById$showById on Query$showById$showById {
  CopyWith$Query$showById$showById<Query$showById$showById> get copyWith =>
      CopyWith$Query$showById$showById(this, (i) => i);
}

abstract class CopyWith$Query$showById$showById<TRes> {
  factory CopyWith$Query$showById$showById(
    Query$showById$showById instance,
    TRes Function(Query$showById$showById) then,
  ) = _CopyWithImpl$Query$showById$showById;

  factory CopyWith$Query$showById$showById.stub(TRes res) =
      _CopyWithStubImpl$Query$showById$showById;

  TRes call({
    String? id,
    List<Fragment$fragmentImages>? images,
    String? name,
    int? releaseYear,
    List<Fragment$fragmentMetadata>? metadata,
    List<Query$showById$showById$seasons>? seasons,
    List<Fragment$fragmentCastMember>? cast,
    int? rating,
    int? tmdbId,
    String? imdbId,
    double? voteAverage,
    int? voteCount,
    String? contentRating,
    String? status,
    String? homepage,
    String? networks,
    String? studios,
    String? originCountry,
    String? keywords,
    String? trailerKey,
    String? trailerSite,
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
  TRes seasons(
    Iterable<Query$showById$showById$seasons>? Function(
      Iterable<
        CopyWith$Query$showById$showById$seasons<
          Query$showById$showById$seasons
        >
      >?,
    )
    _fn,
  );
  TRes cast(
    Iterable<Fragment$fragmentCastMember>? Function(
      Iterable<
        CopyWith$Fragment$fragmentCastMember<Fragment$fragmentCastMember>
      >?,
    )
    _fn,
  );
}

class _CopyWithImpl$Query$showById$showById<TRes>
    implements CopyWith$Query$showById$showById<TRes> {
  _CopyWithImpl$Query$showById$showById(this._instance, this._then);

  final Query$showById$showById _instance;

  final TRes Function(Query$showById$showById) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? id = _undefined,
    Object? images = _undefined,
    Object? name = _undefined,
    Object? releaseYear = _undefined,
    Object? metadata = _undefined,
    Object? seasons = _undefined,
    Object? cast = _undefined,
    Object? rating = _undefined,
    Object? tmdbId = _undefined,
    Object? imdbId = _undefined,
    Object? voteAverage = _undefined,
    Object? voteCount = _undefined,
    Object? contentRating = _undefined,
    Object? status = _undefined,
    Object? homepage = _undefined,
    Object? networks = _undefined,
    Object? studios = _undefined,
    Object? originCountry = _undefined,
    Object? keywords = _undefined,
    Object? trailerKey = _undefined,
    Object? trailerSite = _undefined,
    Object? $__typename = _undefined,
  }) => _then(
    Query$showById$showById(
      id: id == _undefined || id == null ? _instance.id : (id as String),
      images: images == _undefined
          ? _instance.images
          : (images as List<Fragment$fragmentImages>?),
      name: name == _undefined || name == null
          ? _instance.name
          : (name as String),
      releaseYear: releaseYear == _undefined || releaseYear == null
          ? _instance.releaseYear
          : (releaseYear as int),
      metadata: metadata == _undefined
          ? _instance.metadata
          : (metadata as List<Fragment$fragmentMetadata>?),
      seasons: seasons == _undefined
          ? _instance.seasons
          : (seasons as List<Query$showById$showById$seasons>?),
      cast: cast == _undefined
          ? _instance.cast
          : (cast as List<Fragment$fragmentCastMember>?),
      rating: rating == _undefined ? _instance.rating : (rating as int?),
      tmdbId: tmdbId == _undefined ? _instance.tmdbId : (tmdbId as int?),
      imdbId: imdbId == _undefined ? _instance.imdbId : (imdbId as String?),
      voteAverage: voteAverage == _undefined
          ? _instance.voteAverage
          : (voteAverage as double?),
      voteCount: voteCount == _undefined
          ? _instance.voteCount
          : (voteCount as int?),
      contentRating: contentRating == _undefined
          ? _instance.contentRating
          : (contentRating as String?),
      status: status == _undefined ? _instance.status : (status as String?),
      homepage: homepage == _undefined
          ? _instance.homepage
          : (homepage as String?),
      networks: networks == _undefined
          ? _instance.networks
          : (networks as String?),
      studios: studios == _undefined ? _instance.studios : (studios as String?),
      originCountry: originCountry == _undefined
          ? _instance.originCountry
          : (originCountry as String?),
      keywords: keywords == _undefined
          ? _instance.keywords
          : (keywords as String?),
      trailerKey: trailerKey == _undefined
          ? _instance.trailerKey
          : (trailerKey as String?),
      trailerSite: trailerSite == _undefined
          ? _instance.trailerSite
          : (trailerSite as String?),
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

  TRes seasons(
    Iterable<Query$showById$showById$seasons>? Function(
      Iterable<
        CopyWith$Query$showById$showById$seasons<
          Query$showById$showById$seasons
        >
      >?,
    )
    _fn,
  ) => call(
    seasons: _fn(
      _instance.seasons?.map(
        (e) => CopyWith$Query$showById$showById$seasons(e, (i) => i),
      ),
    )?.toList(),
  );

  TRes cast(
    Iterable<Fragment$fragmentCastMember>? Function(
      Iterable<
        CopyWith$Fragment$fragmentCastMember<Fragment$fragmentCastMember>
      >?,
    )
    _fn,
  ) => call(
    cast: _fn(
      _instance.cast?.map(
        (e) => CopyWith$Fragment$fragmentCastMember(e, (i) => i),
      ),
    )?.toList(),
  );
}

class _CopyWithStubImpl$Query$showById$showById<TRes>
    implements CopyWith$Query$showById$showById<TRes> {
  _CopyWithStubImpl$Query$showById$showById(this._res);

  TRes _res;

  call({
    String? id,
    List<Fragment$fragmentImages>? images,
    String? name,
    int? releaseYear,
    List<Fragment$fragmentMetadata>? metadata,
    List<Query$showById$showById$seasons>? seasons,
    List<Fragment$fragmentCastMember>? cast,
    int? rating,
    int? tmdbId,
    String? imdbId,
    double? voteAverage,
    int? voteCount,
    String? contentRating,
    String? status,
    String? homepage,
    String? networks,
    String? studios,
    String? originCountry,
    String? keywords,
    String? trailerKey,
    String? trailerSite,
    String? $__typename,
  }) => _res;

  images(_fn) => _res;

  metadata(_fn) => _res;

  seasons(_fn) => _res;

  cast(_fn) => _res;
}

class Query$showById$showById$seasons {
  Query$showById$showById$seasons({
    required this.id,
    required this.number,
    this.$__typename = 'Season',
  });

  factory Query$showById$showById$seasons.fromJson(Map<String, dynamic> json) {
    final l$id = json['id'];
    final l$number = json['number'];
    final l$$__typename = json['__typename'];
    return Query$showById$showById$seasons(
      id: (l$id as String),
      number: (l$number as int),
      $__typename: (l$$__typename as String),
    );
  }

  final String id;

  final int number;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$id = id;
    _resultData['id'] = l$id;
    final l$number = number;
    _resultData['number'] = l$number;
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$id = id;
    final l$number = number;
    final l$$__typename = $__typename;
    return Object.hashAll([l$id, l$number, l$$__typename]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Query$showById$showById$seasons ||
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
    final l$$__typename = $__typename;
    final lOther$$__typename = other.$__typename;
    if (l$$__typename != lOther$$__typename) {
      return false;
    }
    return true;
  }
}

extension UtilityExtension$Query$showById$showById$seasons
    on Query$showById$showById$seasons {
  CopyWith$Query$showById$showById$seasons<Query$showById$showById$seasons>
  get copyWith => CopyWith$Query$showById$showById$seasons(this, (i) => i);
}

abstract class CopyWith$Query$showById$showById$seasons<TRes> {
  factory CopyWith$Query$showById$showById$seasons(
    Query$showById$showById$seasons instance,
    TRes Function(Query$showById$showById$seasons) then,
  ) = _CopyWithImpl$Query$showById$showById$seasons;

  factory CopyWith$Query$showById$showById$seasons.stub(TRes res) =
      _CopyWithStubImpl$Query$showById$showById$seasons;

  TRes call({String? id, int? number, String? $__typename});
}

class _CopyWithImpl$Query$showById$showById$seasons<TRes>
    implements CopyWith$Query$showById$showById$seasons<TRes> {
  _CopyWithImpl$Query$showById$showById$seasons(this._instance, this._then);

  final Query$showById$showById$seasons _instance;

  final TRes Function(Query$showById$showById$seasons) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? id = _undefined,
    Object? number = _undefined,
    Object? $__typename = _undefined,
  }) => _then(
    Query$showById$showById$seasons(
      id: id == _undefined || id == null ? _instance.id : (id as String),
      number: number == _undefined || number == null
          ? _instance.number
          : (number as int),
      $__typename: $__typename == _undefined || $__typename == null
          ? _instance.$__typename
          : ($__typename as String),
    ),
  );
}

class _CopyWithStubImpl$Query$showById$showById$seasons<TRes>
    implements CopyWith$Query$showById$showById$seasons<TRes> {
  _CopyWithStubImpl$Query$showById$showById$seasons(this._res);

  TRes _res;

  call({String? id, int? number, String? $__typename}) => _res;
}

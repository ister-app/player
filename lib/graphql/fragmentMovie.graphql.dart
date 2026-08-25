import 'fragmentCredit.graphql.dart';
import 'fragmentImages.graphql.dart';
import 'fragmentMediafiles.graphql.dart';
import 'fragmentMetadata.graphql.dart';

import 'package:gql/ast.dart';

class Fragment$fragmentMovie {
  Fragment$fragmentMovie({
    required this.id,
    required this.name,
    required this.releaseYear,
    this.images,
    this.metadata,
    this.watchStatus,
    this.mediaFile,
    this.cast,
    this.rating,
    this.tmdbId,
    this.imdbId,
    this.voteAverage,
    this.voteCount,
    this.runtime,
    this.contentRating,
    this.status,
    this.homepage,
    this.collectionName,
    this.studios,
    this.originCountry,
    this.keywords,
    this.trailerKey,
    this.trailerSite,
    this.$__typename = 'Movie',
  });

  factory Fragment$fragmentMovie.fromJson(Map<String, dynamic> json) {
    final l$id = json['id'];
    final l$name = json['name'];
    final l$releaseYear = json['releaseYear'];
    final l$images = json['images'];
    final l$metadata = json['metadata'];
    final l$watchStatus = json['watchStatus'];
    final l$mediaFile = json['mediaFile'];
    final l$cast = json['cast'];
    final l$rating = json['rating'];
    final l$tmdbId = json['tmdbId'];
    final l$imdbId = json['imdbId'];
    final l$voteAverage = json['voteAverage'];
    final l$voteCount = json['voteCount'];
    final l$runtime = json['runtime'];
    final l$contentRating = json['contentRating'];
    final l$status = json['status'];
    final l$homepage = json['homepage'];
    final l$collectionName = json['collectionName'];
    final l$studios = json['studios'];
    final l$originCountry = json['originCountry'];
    final l$keywords = json['keywords'];
    final l$trailerKey = json['trailerKey'];
    final l$trailerSite = json['trailerSite'];
    final l$$__typename = json['__typename'];
    return Fragment$fragmentMovie(
      id: (l$id as String),
      name: (l$name as String),
      releaseYear: (l$releaseYear as int),
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
            (e) => Fragment$fragmentMovie$watchStatus.fromJson(
              (e as Map<String, dynamic>),
            ),
          )
          .toList(),
      mediaFile: (l$mediaFile as List<dynamic>?)
          ?.map(
            (e) => Fragment$fragmentMediaFiles.fromJson(
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
      runtime: (l$runtime as int?),
      contentRating: (l$contentRating as String?),
      status: (l$status as String?),
      homepage: (l$homepage as String?),
      collectionName: (l$collectionName as String?),
      studios: (l$studios as String?),
      originCountry: (l$originCountry as String?),
      keywords: (l$keywords as String?),
      trailerKey: (l$trailerKey as String?),
      trailerSite: (l$trailerSite as String?),
      $__typename: (l$$__typename as String),
    );
  }

  final String id;

  final String name;

  final int releaseYear;

  final List<Fragment$fragmentImages>? images;

  final List<Fragment$fragmentMetadata>? metadata;

  final List<Fragment$fragmentMovie$watchStatus>? watchStatus;

  final List<Fragment$fragmentMediaFiles>? mediaFile;

  final List<Fragment$fragmentCastMember>? cast;

  final int? rating;

  final int? tmdbId;

  final String? imdbId;

  final double? voteAverage;

  final int? voteCount;

  final int? runtime;

  final String? contentRating;

  final String? status;

  final String? homepage;

  final String? collectionName;

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
    final l$name = name;
    _resultData['name'] = l$name;
    final l$releaseYear = releaseYear;
    _resultData['releaseYear'] = l$releaseYear;
    final l$images = images;
    _resultData['images'] = l$images?.map((e) => e.toJson()).toList();
    final l$metadata = metadata;
    _resultData['metadata'] = l$metadata?.map((e) => e.toJson()).toList();
    final l$watchStatus = watchStatus;
    _resultData['watchStatus'] = l$watchStatus?.map((e) => e.toJson()).toList();
    final l$mediaFile = mediaFile;
    _resultData['mediaFile'] = l$mediaFile?.map((e) => e.toJson()).toList();
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
    final l$runtime = runtime;
    _resultData['runtime'] = l$runtime;
    final l$contentRating = contentRating;
    _resultData['contentRating'] = l$contentRating;
    final l$status = status;
    _resultData['status'] = l$status;
    final l$homepage = homepage;
    _resultData['homepage'] = l$homepage;
    final l$collectionName = collectionName;
    _resultData['collectionName'] = l$collectionName;
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
    final l$name = name;
    final l$releaseYear = releaseYear;
    final l$images = images;
    final l$metadata = metadata;
    final l$watchStatus = watchStatus;
    final l$mediaFile = mediaFile;
    final l$cast = cast;
    final l$rating = rating;
    final l$tmdbId = tmdbId;
    final l$imdbId = imdbId;
    final l$voteAverage = voteAverage;
    final l$voteCount = voteCount;
    final l$runtime = runtime;
    final l$contentRating = contentRating;
    final l$status = status;
    final l$homepage = homepage;
    final l$collectionName = collectionName;
    final l$studios = studios;
    final l$originCountry = originCountry;
    final l$keywords = keywords;
    final l$trailerKey = trailerKey;
    final l$trailerSite = trailerSite;
    final l$$__typename = $__typename;
    return Object.hashAll([
      l$id,
      l$name,
      l$releaseYear,
      l$images == null ? null : Object.hashAll(l$images.map((v) => v)),
      l$metadata == null ? null : Object.hashAll(l$metadata.map((v) => v)),
      l$watchStatus == null
          ? null
          : Object.hashAll(l$watchStatus.map((v) => v)),
      l$mediaFile == null ? null : Object.hashAll(l$mediaFile.map((v) => v)),
      l$cast == null ? null : Object.hashAll(l$cast.map((v) => v)),
      l$rating,
      l$tmdbId,
      l$imdbId,
      l$voteAverage,
      l$voteCount,
      l$runtime,
      l$contentRating,
      l$status,
      l$homepage,
      l$collectionName,
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
    if (other is! Fragment$fragmentMovie || runtimeType != other.runtimeType) {
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
    final l$runtime = runtime;
    final lOther$runtime = other.runtime;
    if (l$runtime != lOther$runtime) {
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
    final l$collectionName = collectionName;
    final lOther$collectionName = other.collectionName;
    if (l$collectionName != lOther$collectionName) {
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

extension UtilityExtension$Fragment$fragmentMovie on Fragment$fragmentMovie {
  CopyWith$Fragment$fragmentMovie<Fragment$fragmentMovie> get copyWith =>
      CopyWith$Fragment$fragmentMovie(this, (i) => i);
}

abstract class CopyWith$Fragment$fragmentMovie<TRes> {
  factory CopyWith$Fragment$fragmentMovie(
    Fragment$fragmentMovie instance,
    TRes Function(Fragment$fragmentMovie) then,
  ) = _CopyWithImpl$Fragment$fragmentMovie;

  factory CopyWith$Fragment$fragmentMovie.stub(TRes res) =
      _CopyWithStubImpl$Fragment$fragmentMovie;

  TRes call({
    String? id,
    String? name,
    int? releaseYear,
    List<Fragment$fragmentImages>? images,
    List<Fragment$fragmentMetadata>? metadata,
    List<Fragment$fragmentMovie$watchStatus>? watchStatus,
    List<Fragment$fragmentMediaFiles>? mediaFile,
    List<Fragment$fragmentCastMember>? cast,
    int? rating,
    int? tmdbId,
    String? imdbId,
    double? voteAverage,
    int? voteCount,
    int? runtime,
    String? contentRating,
    String? status,
    String? homepage,
    String? collectionName,
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
  TRes watchStatus(
    Iterable<Fragment$fragmentMovie$watchStatus>? Function(
      Iterable<
        CopyWith$Fragment$fragmentMovie$watchStatus<
          Fragment$fragmentMovie$watchStatus
        >
      >?,
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
  TRes cast(
    Iterable<Fragment$fragmentCastMember>? Function(
      Iterable<
        CopyWith$Fragment$fragmentCastMember<Fragment$fragmentCastMember>
      >?,
    )
    _fn,
  );
}

class _CopyWithImpl$Fragment$fragmentMovie<TRes>
    implements CopyWith$Fragment$fragmentMovie<TRes> {
  _CopyWithImpl$Fragment$fragmentMovie(this._instance, this._then);

  final Fragment$fragmentMovie _instance;

  final TRes Function(Fragment$fragmentMovie) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? id = _undefined,
    Object? name = _undefined,
    Object? releaseYear = _undefined,
    Object? images = _undefined,
    Object? metadata = _undefined,
    Object? watchStatus = _undefined,
    Object? mediaFile = _undefined,
    Object? cast = _undefined,
    Object? rating = _undefined,
    Object? tmdbId = _undefined,
    Object? imdbId = _undefined,
    Object? voteAverage = _undefined,
    Object? voteCount = _undefined,
    Object? runtime = _undefined,
    Object? contentRating = _undefined,
    Object? status = _undefined,
    Object? homepage = _undefined,
    Object? collectionName = _undefined,
    Object? studios = _undefined,
    Object? originCountry = _undefined,
    Object? keywords = _undefined,
    Object? trailerKey = _undefined,
    Object? trailerSite = _undefined,
    Object? $__typename = _undefined,
  }) => _then(
    Fragment$fragmentMovie(
      id: id == _undefined || id == null ? _instance.id : (id as String),
      name: name == _undefined || name == null
          ? _instance.name
          : (name as String),
      releaseYear: releaseYear == _undefined || releaseYear == null
          ? _instance.releaseYear
          : (releaseYear as int),
      images: images == _undefined
          ? _instance.images
          : (images as List<Fragment$fragmentImages>?),
      metadata: metadata == _undefined
          ? _instance.metadata
          : (metadata as List<Fragment$fragmentMetadata>?),
      watchStatus: watchStatus == _undefined
          ? _instance.watchStatus
          : (watchStatus as List<Fragment$fragmentMovie$watchStatus>?),
      mediaFile: mediaFile == _undefined
          ? _instance.mediaFile
          : (mediaFile as List<Fragment$fragmentMediaFiles>?),
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
      runtime: runtime == _undefined ? _instance.runtime : (runtime as int?),
      contentRating: contentRating == _undefined
          ? _instance.contentRating
          : (contentRating as String?),
      status: status == _undefined ? _instance.status : (status as String?),
      homepage: homepage == _undefined
          ? _instance.homepage
          : (homepage as String?),
      collectionName: collectionName == _undefined
          ? _instance.collectionName
          : (collectionName as String?),
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

  TRes watchStatus(
    Iterable<Fragment$fragmentMovie$watchStatus>? Function(
      Iterable<
        CopyWith$Fragment$fragmentMovie$watchStatus<
          Fragment$fragmentMovie$watchStatus
        >
      >?,
    )
    _fn,
  ) => call(
    watchStatus: _fn(
      _instance.watchStatus?.map(
        (e) => CopyWith$Fragment$fragmentMovie$watchStatus(e, (i) => i),
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

class _CopyWithStubImpl$Fragment$fragmentMovie<TRes>
    implements CopyWith$Fragment$fragmentMovie<TRes> {
  _CopyWithStubImpl$Fragment$fragmentMovie(this._res);

  TRes _res;

  call({
    String? id,
    String? name,
    int? releaseYear,
    List<Fragment$fragmentImages>? images,
    List<Fragment$fragmentMetadata>? metadata,
    List<Fragment$fragmentMovie$watchStatus>? watchStatus,
    List<Fragment$fragmentMediaFiles>? mediaFile,
    List<Fragment$fragmentCastMember>? cast,
    int? rating,
    int? tmdbId,
    String? imdbId,
    double? voteAverage,
    int? voteCount,
    int? runtime,
    String? contentRating,
    String? status,
    String? homepage,
    String? collectionName,
    String? studios,
    String? originCountry,
    String? keywords,
    String? trailerKey,
    String? trailerSite,
    String? $__typename,
  }) => _res;

  images(_fn) => _res;

  metadata(_fn) => _res;

  watchStatus(_fn) => _res;

  mediaFile(_fn) => _res;

  cast(_fn) => _res;
}

const fragmentDefinitionfragmentMovie = FragmentDefinitionNode(
  name: NameNode(value: 'fragmentMovie'),
  typeCondition: TypeConditionNode(
    on: NamedTypeNode(name: NameNode(value: 'Movie'), isNonNull: false),
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
        name: NameNode(value: 'runtime'),
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
        name: NameNode(value: 'collectionName'),
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
);
const documentNodeFragmentfragmentMovie = DocumentNode(
  definitions: [
    fragmentDefinitionfragmentMovie,
    fragmentDefinitionfragmentImages,
    fragmentDefinitionfragmentMetadata,
    fragmentDefinitionfragmentMediaFiles,
    fragmentDefinitionfragmentCastMember,
  ],
);

class Fragment$fragmentMovie$watchStatus {
  Fragment$fragmentMovie$watchStatus({
    required this.id,
    required this.playQueueItemId,
    required this.progressInMilliseconds,
    required this.watched,
    this.$__typename = 'WatchStatus',
  });

  factory Fragment$fragmentMovie$watchStatus.fromJson(
    Map<String, dynamic> json,
  ) {
    final l$id = json['id'];
    final l$playQueueItemId = json['playQueueItemId'];
    final l$progressInMilliseconds = json['progressInMilliseconds'];
    final l$watched = json['watched'];
    final l$$__typename = json['__typename'];
    return Fragment$fragmentMovie$watchStatus(
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
    if (other is! Fragment$fragmentMovie$watchStatus ||
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

extension UtilityExtension$Fragment$fragmentMovie$watchStatus
    on Fragment$fragmentMovie$watchStatus {
  CopyWith$Fragment$fragmentMovie$watchStatus<
    Fragment$fragmentMovie$watchStatus
  >
  get copyWith => CopyWith$Fragment$fragmentMovie$watchStatus(this, (i) => i);
}

abstract class CopyWith$Fragment$fragmentMovie$watchStatus<TRes> {
  factory CopyWith$Fragment$fragmentMovie$watchStatus(
    Fragment$fragmentMovie$watchStatus instance,
    TRes Function(Fragment$fragmentMovie$watchStatus) then,
  ) = _CopyWithImpl$Fragment$fragmentMovie$watchStatus;

  factory CopyWith$Fragment$fragmentMovie$watchStatus.stub(TRes res) =
      _CopyWithStubImpl$Fragment$fragmentMovie$watchStatus;

  TRes call({
    String? id,
    String? playQueueItemId,
    int? progressInMilliseconds,
    bool? watched,
    String? $__typename,
  });
}

class _CopyWithImpl$Fragment$fragmentMovie$watchStatus<TRes>
    implements CopyWith$Fragment$fragmentMovie$watchStatus<TRes> {
  _CopyWithImpl$Fragment$fragmentMovie$watchStatus(this._instance, this._then);

  final Fragment$fragmentMovie$watchStatus _instance;

  final TRes Function(Fragment$fragmentMovie$watchStatus) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? id = _undefined,
    Object? playQueueItemId = _undefined,
    Object? progressInMilliseconds = _undefined,
    Object? watched = _undefined,
    Object? $__typename = _undefined,
  }) => _then(
    Fragment$fragmentMovie$watchStatus(
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

class _CopyWithStubImpl$Fragment$fragmentMovie$watchStatus<TRes>
    implements CopyWith$Fragment$fragmentMovie$watchStatus<TRes> {
  _CopyWithStubImpl$Fragment$fragmentMovie$watchStatus(this._res);

  TRes _res;

  call({
    String? id,
    String? playQueueItemId,
    int? progressInMilliseconds,
    bool? watched,
    String? $__typename,
  }) => _res;
}

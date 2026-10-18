import 'fragmentImages.graphql.dart';
import 'fragmentMetadata.graphql.dart';

import 'package:gql/ast.dart';

import 'schema.graphql.dart';

class Fragment$fragmentGame {
  Fragment$fragmentGame({
    required this.id,
    required this.name,
    required this.title,
    required this.releaseYear,
    required this.platform,
    required this.form,
    this.entryPath,
    this.titleId,
    this.steamAppId,
    this.steamInstallDir,
    required this.steamCloud,
    required this.sizeBytes,
    required this.fileCount,
    required this.launcher,
    this.images,
    this.metadata,
    this.rating,
    this.lastPlayed,
    required this.playTimeMs,
    this.$__typename = 'Game',
  });

  factory Fragment$fragmentGame.fromJson(Map<String, dynamic> json) {
    final l$id = json['id'];
    final l$name = json['name'];
    final l$title = json['title'];
    final l$releaseYear = json['releaseYear'];
    final l$platform = json['platform'];
    final l$form = json['form'];
    final l$entryPath = json['entryPath'];
    final l$titleId = json['titleId'];
    final l$steamAppId = json['steamAppId'];
    final l$steamInstallDir = json['steamInstallDir'];
    final l$steamCloud = json['steamCloud'];
    final l$sizeBytes = json['sizeBytes'];
    final l$fileCount = json['fileCount'];
    final l$launcher = json['launcher'];
    final l$images = json['images'];
    final l$metadata = json['metadata'];
    final l$rating = json['rating'];
    final l$lastPlayed = json['lastPlayed'];
    final l$playTimeMs = json['playTimeMs'];
    final l$$__typename = json['__typename'];
    return Fragment$fragmentGame(
      id: (l$id as String),
      name: (l$name as String),
      title: (l$title as String),
      releaseYear: (l$releaseYear as int),
      platform: fromJson$Enum$GamePlatform((l$platform as String)),
      form: fromJson$Enum$GameForm((l$form as String)),
      entryPath: (l$entryPath as String?),
      titleId: (l$titleId as String?),
      steamAppId: (l$steamAppId as String?),
      steamInstallDir: (l$steamInstallDir as String?),
      steamCloud: (l$steamCloud as bool),
      sizeBytes: (l$sizeBytes as num).toDouble(),
      fileCount: (l$fileCount as int),
      launcher: Fragment$fragmentGame$launcher.fromJson(
        (l$launcher as Map<String, dynamic>),
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
      lastPlayed: (l$lastPlayed as String?),
      playTimeMs: (l$playTimeMs as num).toDouble(),
      $__typename: (l$$__typename as String),
    );
  }

  final String id;

  final String name;

  final String title;

  final int releaseYear;

  final Enum$GamePlatform platform;

  final Enum$GameForm form;

  final String? entryPath;

  final String? titleId;

  final String? steamAppId;

  final String? steamInstallDir;

  final bool steamCloud;

  final double sizeBytes;

  final int fileCount;

  final Fragment$fragmentGame$launcher launcher;

  final List<Fragment$fragmentImages>? images;

  final List<Fragment$fragmentMetadata>? metadata;

  final int? rating;

  final String? lastPlayed;

  final double playTimeMs;

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
    final l$platform = platform;
    _resultData['platform'] = toJson$Enum$GamePlatform(l$platform);
    final l$form = form;
    _resultData['form'] = toJson$Enum$GameForm(l$form);
    final l$entryPath = entryPath;
    _resultData['entryPath'] = l$entryPath;
    final l$titleId = titleId;
    _resultData['titleId'] = l$titleId;
    final l$steamAppId = steamAppId;
    _resultData['steamAppId'] = l$steamAppId;
    final l$steamInstallDir = steamInstallDir;
    _resultData['steamInstallDir'] = l$steamInstallDir;
    final l$steamCloud = steamCloud;
    _resultData['steamCloud'] = l$steamCloud;
    final l$sizeBytes = sizeBytes;
    _resultData['sizeBytes'] = l$sizeBytes;
    final l$fileCount = fileCount;
    _resultData['fileCount'] = l$fileCount;
    final l$launcher = launcher;
    _resultData['launcher'] = l$launcher.toJson();
    final l$images = images;
    _resultData['images'] = l$images?.map((e) => e.toJson()).toList();
    final l$metadata = metadata;
    _resultData['metadata'] = l$metadata?.map((e) => e.toJson()).toList();
    final l$rating = rating;
    _resultData['rating'] = l$rating;
    final l$lastPlayed = lastPlayed;
    _resultData['lastPlayed'] = l$lastPlayed;
    final l$playTimeMs = playTimeMs;
    _resultData['playTimeMs'] = l$playTimeMs;
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
    final l$platform = platform;
    final l$form = form;
    final l$entryPath = entryPath;
    final l$titleId = titleId;
    final l$steamAppId = steamAppId;
    final l$steamInstallDir = steamInstallDir;
    final l$steamCloud = steamCloud;
    final l$sizeBytes = sizeBytes;
    final l$fileCount = fileCount;
    final l$launcher = launcher;
    final l$images = images;
    final l$metadata = metadata;
    final l$rating = rating;
    final l$lastPlayed = lastPlayed;
    final l$playTimeMs = playTimeMs;
    final l$$__typename = $__typename;
    return Object.hashAll([
      l$id,
      l$name,
      l$title,
      l$releaseYear,
      l$platform,
      l$form,
      l$entryPath,
      l$titleId,
      l$steamAppId,
      l$steamInstallDir,
      l$steamCloud,
      l$sizeBytes,
      l$fileCount,
      l$launcher,
      l$images == null ? null : Object.hashAll(l$images.map((v) => v)),
      l$metadata == null ? null : Object.hashAll(l$metadata.map((v) => v)),
      l$rating,
      l$lastPlayed,
      l$playTimeMs,
      l$$__typename,
    ]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Fragment$fragmentGame || runtimeType != other.runtimeType) {
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
    final l$platform = platform;
    final lOther$platform = other.platform;
    if (l$platform != lOther$platform) {
      return false;
    }
    final l$form = form;
    final lOther$form = other.form;
    if (l$form != lOther$form) {
      return false;
    }
    final l$entryPath = entryPath;
    final lOther$entryPath = other.entryPath;
    if (l$entryPath != lOther$entryPath) {
      return false;
    }
    final l$titleId = titleId;
    final lOther$titleId = other.titleId;
    if (l$titleId != lOther$titleId) {
      return false;
    }
    final l$steamAppId = steamAppId;
    final lOther$steamAppId = other.steamAppId;
    if (l$steamAppId != lOther$steamAppId) {
      return false;
    }
    final l$steamInstallDir = steamInstallDir;
    final lOther$steamInstallDir = other.steamInstallDir;
    if (l$steamInstallDir != lOther$steamInstallDir) {
      return false;
    }
    final l$steamCloud = steamCloud;
    final lOther$steamCloud = other.steamCloud;
    if (l$steamCloud != lOther$steamCloud) {
      return false;
    }
    final l$sizeBytes = sizeBytes;
    final lOther$sizeBytes = other.sizeBytes;
    if (l$sizeBytes != lOther$sizeBytes) {
      return false;
    }
    final l$fileCount = fileCount;
    final lOther$fileCount = other.fileCount;
    if (l$fileCount != lOther$fileCount) {
      return false;
    }
    final l$launcher = launcher;
    final lOther$launcher = other.launcher;
    if (l$launcher != lOther$launcher) {
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
    final l$lastPlayed = lastPlayed;
    final lOther$lastPlayed = other.lastPlayed;
    if (l$lastPlayed != lOther$lastPlayed) {
      return false;
    }
    final l$playTimeMs = playTimeMs;
    final lOther$playTimeMs = other.playTimeMs;
    if (l$playTimeMs != lOther$playTimeMs) {
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

extension UtilityExtension$Fragment$fragmentGame on Fragment$fragmentGame {
  CopyWith$Fragment$fragmentGame<Fragment$fragmentGame> get copyWith =>
      CopyWith$Fragment$fragmentGame(this, (i) => i);
}

abstract class CopyWith$Fragment$fragmentGame<TRes> {
  factory CopyWith$Fragment$fragmentGame(
    Fragment$fragmentGame instance,
    TRes Function(Fragment$fragmentGame) then,
  ) = _CopyWithImpl$Fragment$fragmentGame;

  factory CopyWith$Fragment$fragmentGame.stub(TRes res) =
      _CopyWithStubImpl$Fragment$fragmentGame;

  TRes call({
    String? id,
    String? name,
    String? title,
    int? releaseYear,
    Enum$GamePlatform? platform,
    Enum$GameForm? form,
    String? entryPath,
    String? titleId,
    String? steamAppId,
    String? steamInstallDir,
    bool? steamCloud,
    double? sizeBytes,
    int? fileCount,
    Fragment$fragmentGame$launcher? launcher,
    List<Fragment$fragmentImages>? images,
    List<Fragment$fragmentMetadata>? metadata,
    int? rating,
    String? lastPlayed,
    double? playTimeMs,
    String? $__typename,
  });
  CopyWith$Fragment$fragmentGame$launcher<TRes> get launcher;
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

class _CopyWithImpl$Fragment$fragmentGame<TRes>
    implements CopyWith$Fragment$fragmentGame<TRes> {
  _CopyWithImpl$Fragment$fragmentGame(this._instance, this._then);

  final Fragment$fragmentGame _instance;

  final TRes Function(Fragment$fragmentGame) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? id = _undefined,
    Object? name = _undefined,
    Object? title = _undefined,
    Object? releaseYear = _undefined,
    Object? platform = _undefined,
    Object? form = _undefined,
    Object? entryPath = _undefined,
    Object? titleId = _undefined,
    Object? steamAppId = _undefined,
    Object? steamInstallDir = _undefined,
    Object? steamCloud = _undefined,
    Object? sizeBytes = _undefined,
    Object? fileCount = _undefined,
    Object? launcher = _undefined,
    Object? images = _undefined,
    Object? metadata = _undefined,
    Object? rating = _undefined,
    Object? lastPlayed = _undefined,
    Object? playTimeMs = _undefined,
    Object? $__typename = _undefined,
  }) => _then(
    Fragment$fragmentGame(
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
      platform: platform == _undefined || platform == null
          ? _instance.platform
          : (platform as Enum$GamePlatform),
      form: form == _undefined || form == null
          ? _instance.form
          : (form as Enum$GameForm),
      entryPath: entryPath == _undefined
          ? _instance.entryPath
          : (entryPath as String?),
      titleId: titleId == _undefined ? _instance.titleId : (titleId as String?),
      steamAppId: steamAppId == _undefined
          ? _instance.steamAppId
          : (steamAppId as String?),
      steamInstallDir: steamInstallDir == _undefined
          ? _instance.steamInstallDir
          : (steamInstallDir as String?),
      steamCloud: steamCloud == _undefined || steamCloud == null
          ? _instance.steamCloud
          : (steamCloud as bool),
      sizeBytes: sizeBytes == _undefined || sizeBytes == null
          ? _instance.sizeBytes
          : (sizeBytes as double),
      fileCount: fileCount == _undefined || fileCount == null
          ? _instance.fileCount
          : (fileCount as int),
      launcher: launcher == _undefined || launcher == null
          ? _instance.launcher
          : (launcher as Fragment$fragmentGame$launcher),
      images: images == _undefined
          ? _instance.images
          : (images as List<Fragment$fragmentImages>?),
      metadata: metadata == _undefined
          ? _instance.metadata
          : (metadata as List<Fragment$fragmentMetadata>?),
      rating: rating == _undefined ? _instance.rating : (rating as int?),
      lastPlayed: lastPlayed == _undefined
          ? _instance.lastPlayed
          : (lastPlayed as String?),
      playTimeMs: playTimeMs == _undefined || playTimeMs == null
          ? _instance.playTimeMs
          : (playTimeMs as double),
      $__typename: $__typename == _undefined || $__typename == null
          ? _instance.$__typename
          : ($__typename as String),
    ),
  );

  CopyWith$Fragment$fragmentGame$launcher<TRes> get launcher {
    final local$launcher = _instance.launcher;
    return CopyWith$Fragment$fragmentGame$launcher(
      local$launcher,
      (e) => call(launcher: e),
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

class _CopyWithStubImpl$Fragment$fragmentGame<TRes>
    implements CopyWith$Fragment$fragmentGame<TRes> {
  _CopyWithStubImpl$Fragment$fragmentGame(this._res);

  TRes _res;

  call({
    String? id,
    String? name,
    String? title,
    int? releaseYear,
    Enum$GamePlatform? platform,
    Enum$GameForm? form,
    String? entryPath,
    String? titleId,
    String? steamAppId,
    String? steamInstallDir,
    bool? steamCloud,
    double? sizeBytes,
    int? fileCount,
    Fragment$fragmentGame$launcher? launcher,
    List<Fragment$fragmentImages>? images,
    List<Fragment$fragmentMetadata>? metadata,
    int? rating,
    String? lastPlayed,
    double? playTimeMs,
    String? $__typename,
  }) => _res;

  CopyWith$Fragment$fragmentGame$launcher<TRes> get launcher =>
      CopyWith$Fragment$fragmentGame$launcher.stub(_res);

  images(_fn) => _res;

  metadata(_fn) => _res;
}

const fragmentDefinitionfragmentGame = FragmentDefinitionNode(
  name: NameNode(value: 'fragmentGame'),
  typeCondition: TypeConditionNode(
    on: NamedTypeNode(name: NameNode(value: 'Game'), isNonNull: false),
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
        name: NameNode(value: 'platform'),
        alias: null,
        arguments: [],
        directives: [],
        selectionSet: null,
      ),
      FieldNode(
        name: NameNode(value: 'form'),
        alias: null,
        arguments: [],
        directives: [],
        selectionSet: null,
      ),
      FieldNode(
        name: NameNode(value: 'entryPath'),
        alias: null,
        arguments: [],
        directives: [],
        selectionSet: null,
      ),
      FieldNode(
        name: NameNode(value: 'titleId'),
        alias: null,
        arguments: [],
        directives: [],
        selectionSet: null,
      ),
      FieldNode(
        name: NameNode(value: 'steamAppId'),
        alias: null,
        arguments: [],
        directives: [],
        selectionSet: null,
      ),
      FieldNode(
        name: NameNode(value: 'steamInstallDir'),
        alias: null,
        arguments: [],
        directives: [],
        selectionSet: null,
      ),
      FieldNode(
        name: NameNode(value: 'steamCloud'),
        alias: null,
        arguments: [],
        directives: [],
        selectionSet: null,
      ),
      FieldNode(
        name: NameNode(value: 'sizeBytes'),
        alias: null,
        arguments: [],
        directives: [],
        selectionSet: null,
      ),
      FieldNode(
        name: NameNode(value: 'fileCount'),
        alias: null,
        arguments: [],
        directives: [],
        selectionSet: null,
      ),
      FieldNode(
        name: NameNode(value: 'launcher'),
        alias: null,
        arguments: [],
        directives: [],
        selectionSet: SelectionSetNode(
          selections: [
            FieldNode(
              name: NameNode(value: 'kind'),
              alias: null,
              arguments: [],
              directives: [],
              selectionSet: null,
            ),
            FieldNode(
              name: NameNode(value: 'retroArchCore'),
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
        name: NameNode(value: 'lastPlayed'),
        alias: null,
        arguments: [],
        directives: [],
        selectionSet: null,
      ),
      FieldNode(
        name: NameNode(value: 'playTimeMs'),
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
const documentNodeFragmentfragmentGame = DocumentNode(
  definitions: [
    fragmentDefinitionfragmentGame,
    fragmentDefinitionfragmentImages,
    fragmentDefinitionfragmentMetadata,
  ],
);

class Fragment$fragmentGame$launcher {
  Fragment$fragmentGame$launcher({
    required this.kind,
    this.retroArchCore,
    this.$__typename = 'GameLauncherHint',
  });

  factory Fragment$fragmentGame$launcher.fromJson(Map<String, dynamic> json) {
    final l$kind = json['kind'];
    final l$retroArchCore = json['retroArchCore'];
    final l$$__typename = json['__typename'];
    return Fragment$fragmentGame$launcher(
      kind: fromJson$Enum$GameLauncherKind((l$kind as String)),
      retroArchCore: (l$retroArchCore as String?),
      $__typename: (l$$__typename as String),
    );
  }

  final Enum$GameLauncherKind kind;

  final String? retroArchCore;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$kind = kind;
    _resultData['kind'] = toJson$Enum$GameLauncherKind(l$kind);
    final l$retroArchCore = retroArchCore;
    _resultData['retroArchCore'] = l$retroArchCore;
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$kind = kind;
    final l$retroArchCore = retroArchCore;
    final l$$__typename = $__typename;
    return Object.hashAll([l$kind, l$retroArchCore, l$$__typename]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Fragment$fragmentGame$launcher ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$kind = kind;
    final lOther$kind = other.kind;
    if (l$kind != lOther$kind) {
      return false;
    }
    final l$retroArchCore = retroArchCore;
    final lOther$retroArchCore = other.retroArchCore;
    if (l$retroArchCore != lOther$retroArchCore) {
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

extension UtilityExtension$Fragment$fragmentGame$launcher
    on Fragment$fragmentGame$launcher {
  CopyWith$Fragment$fragmentGame$launcher<Fragment$fragmentGame$launcher>
  get copyWith => CopyWith$Fragment$fragmentGame$launcher(this, (i) => i);
}

abstract class CopyWith$Fragment$fragmentGame$launcher<TRes> {
  factory CopyWith$Fragment$fragmentGame$launcher(
    Fragment$fragmentGame$launcher instance,
    TRes Function(Fragment$fragmentGame$launcher) then,
  ) = _CopyWithImpl$Fragment$fragmentGame$launcher;

  factory CopyWith$Fragment$fragmentGame$launcher.stub(TRes res) =
      _CopyWithStubImpl$Fragment$fragmentGame$launcher;

  TRes call({
    Enum$GameLauncherKind? kind,
    String? retroArchCore,
    String? $__typename,
  });
}

class _CopyWithImpl$Fragment$fragmentGame$launcher<TRes>
    implements CopyWith$Fragment$fragmentGame$launcher<TRes> {
  _CopyWithImpl$Fragment$fragmentGame$launcher(this._instance, this._then);

  final Fragment$fragmentGame$launcher _instance;

  final TRes Function(Fragment$fragmentGame$launcher) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? kind = _undefined,
    Object? retroArchCore = _undefined,
    Object? $__typename = _undefined,
  }) => _then(
    Fragment$fragmentGame$launcher(
      kind: kind == _undefined || kind == null
          ? _instance.kind
          : (kind as Enum$GameLauncherKind),
      retroArchCore: retroArchCore == _undefined
          ? _instance.retroArchCore
          : (retroArchCore as String?),
      $__typename: $__typename == _undefined || $__typename == null
          ? _instance.$__typename
          : ($__typename as String),
    ),
  );
}

class _CopyWithStubImpl$Fragment$fragmentGame$launcher<TRes>
    implements CopyWith$Fragment$fragmentGame$launcher<TRes> {
  _CopyWithStubImpl$Fragment$fragmentGame$launcher(this._res);

  TRes _res;

  call({
    Enum$GameLauncherKind? kind,
    String? retroArchCore,
    String? $__typename,
  }) => _res;
}

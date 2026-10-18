import 'fragmentGame.graphql.dart';
import 'fragmentImages.graphql.dart';
import 'fragmentMetadata.graphql.dart';

import 'package:gql/ast.dart';

import 'schema.graphql.dart';

class Variables$Query$gameById {
  factory Variables$Query$gameById({String? id}) =>
      Variables$Query$gameById._({if (id != null) r'id': id});

  Variables$Query$gameById._(this._$data);

  factory Variables$Query$gameById.fromJson(Map<String, dynamic> data) {
    final result$data = <String, dynamic>{};
    if (data.containsKey('id')) {
      final l$id = data['id'];
      result$data['id'] = (l$id as String?);
    }
    return Variables$Query$gameById._(result$data);
  }

  Map<String, dynamic> _$data;

  String? get id => (_$data['id'] as String?);

  Map<String, dynamic> toJson() {
    final result$data = <String, dynamic>{};
    if (_$data.containsKey('id')) {
      final l$id = id;
      result$data['id'] = l$id;
    }
    return result$data;
  }

  CopyWith$Variables$Query$gameById<Variables$Query$gameById> get copyWith =>
      CopyWith$Variables$Query$gameById(this, (i) => i);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Variables$Query$gameById ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$id = id;
    final lOther$id = other.id;
    if (_$data.containsKey('id') != other._$data.containsKey('id')) {
      return false;
    }
    if (l$id != lOther$id) {
      return false;
    }
    return true;
  }

  @override
  int get hashCode {
    final l$id = id;
    return Object.hashAll([_$data.containsKey('id') ? l$id : const {}]);
  }
}

abstract class CopyWith$Variables$Query$gameById<TRes> {
  factory CopyWith$Variables$Query$gameById(
    Variables$Query$gameById instance,
    TRes Function(Variables$Query$gameById) then,
  ) = _CopyWithImpl$Variables$Query$gameById;

  factory CopyWith$Variables$Query$gameById.stub(TRes res) =
      _CopyWithStubImpl$Variables$Query$gameById;

  TRes call({String? id});
}

class _CopyWithImpl$Variables$Query$gameById<TRes>
    implements CopyWith$Variables$Query$gameById<TRes> {
  _CopyWithImpl$Variables$Query$gameById(this._instance, this._then);

  final Variables$Query$gameById _instance;

  final TRes Function(Variables$Query$gameById) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({Object? id = _undefined}) => _then(
    Variables$Query$gameById._({
      ..._instance._$data,
      if (id != _undefined) 'id': (id as String?),
    }),
  );
}

class _CopyWithStubImpl$Variables$Query$gameById<TRes>
    implements CopyWith$Variables$Query$gameById<TRes> {
  _CopyWithStubImpl$Variables$Query$gameById(this._res);

  TRes _res;

  call({String? id}) => _res;
}

class Query$gameById {
  Query$gameById({this.gameById, this.$__typename = 'Query'});

  factory Query$gameById.fromJson(Map<String, dynamic> json) {
    final l$gameById = json['gameById'];
    final l$$__typename = json['__typename'];
    return Query$gameById(
      gameById: l$gameById == null
          ? null
          : Query$gameById$gameById.fromJson(
              (l$gameById as Map<String, dynamic>),
            ),
      $__typename: (l$$__typename as String),
    );
  }

  final Query$gameById$gameById? gameById;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$gameById = gameById;
    _resultData['gameById'] = l$gameById?.toJson();
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$gameById = gameById;
    final l$$__typename = $__typename;
    return Object.hashAll([l$gameById, l$$__typename]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Query$gameById || runtimeType != other.runtimeType) {
      return false;
    }
    final l$gameById = gameById;
    final lOther$gameById = other.gameById;
    if (l$gameById != lOther$gameById) {
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

extension UtilityExtension$Query$gameById on Query$gameById {
  CopyWith$Query$gameById<Query$gameById> get copyWith =>
      CopyWith$Query$gameById(this, (i) => i);
}

abstract class CopyWith$Query$gameById<TRes> {
  factory CopyWith$Query$gameById(
    Query$gameById instance,
    TRes Function(Query$gameById) then,
  ) = _CopyWithImpl$Query$gameById;

  factory CopyWith$Query$gameById.stub(TRes res) =
      _CopyWithStubImpl$Query$gameById;

  TRes call({Query$gameById$gameById? gameById, String? $__typename});
  CopyWith$Query$gameById$gameById<TRes> get gameById;
}

class _CopyWithImpl$Query$gameById<TRes>
    implements CopyWith$Query$gameById<TRes> {
  _CopyWithImpl$Query$gameById(this._instance, this._then);

  final Query$gameById _instance;

  final TRes Function(Query$gameById) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? gameById = _undefined,
    Object? $__typename = _undefined,
  }) => _then(
    Query$gameById(
      gameById: gameById == _undefined
          ? _instance.gameById
          : (gameById as Query$gameById$gameById?),
      $__typename: $__typename == _undefined || $__typename == null
          ? _instance.$__typename
          : ($__typename as String),
    ),
  );

  CopyWith$Query$gameById$gameById<TRes> get gameById {
    final local$gameById = _instance.gameById;
    return local$gameById == null
        ? CopyWith$Query$gameById$gameById.stub(_then(_instance))
        : CopyWith$Query$gameById$gameById(
            local$gameById,
            (e) => call(gameById: e),
          );
  }
}

class _CopyWithStubImpl$Query$gameById<TRes>
    implements CopyWith$Query$gameById<TRes> {
  _CopyWithStubImpl$Query$gameById(this._res);

  TRes _res;

  call({Query$gameById$gameById? gameById, String? $__typename}) => _res;

  CopyWith$Query$gameById$gameById<TRes> get gameById =>
      CopyWith$Query$gameById$gameById.stub(_res);
}

const documentNodeQuerygameById = DocumentNode(
  definitions: [
    OperationDefinitionNode(
      type: OperationType.query,
      name: NameNode(value: 'gameById'),
      variableDefinitions: [
        VariableDefinitionNode(
          variable: VariableNode(name: NameNode(value: 'id')),
          type: NamedTypeNode(name: NameNode(value: 'ID'), isNonNull: false),
          defaultValue: DefaultValueNode(value: null),
          directives: [],
        ),
      ],
      directives: [],
      selectionSet: SelectionSetNode(
        selections: [
          FieldNode(
            name: NameNode(value: 'gameById'),
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
                FragmentSpreadNode(
                  name: NameNode(value: 'fragmentGame'),
                  directives: [],
                ),
                FieldNode(
                  name: NameNode(value: 'version'),
                  alias: null,
                  arguments: [],
                  directives: [],
                  selectionSet: null,
                ),
                FieldNode(
                  name: NameNode(value: 'steamBuildId'),
                  alias: null,
                  arguments: [],
                  directives: [],
                  selectionSet: null,
                ),
                FieldNode(
                  name: NameNode(value: 'updatedAt'),
                  alias: null,
                  arguments: [],
                  directives: [],
                  selectionSet: null,
                ),
                FieldNode(
                  name: NameNode(value: 'savePaths'),
                  alias: null,
                  arguments: [],
                  directives: [],
                  selectionSet: SelectionSetNode(
                    selections: [
                      FieldNode(
                        name: NameNode(value: 'path'),
                        alias: null,
                        arguments: [],
                        directives: [],
                        selectionSet: null,
                      ),
                      FieldNode(
                        name: NameNode(value: 'os'),
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
                  name: NameNode(value: 'savePathSource'),
                  alias: null,
                  arguments: [],
                  directives: [],
                  selectionSet: null,
                ),
                FieldNode(
                  name: NameNode(value: 'savePathOverride'),
                  alias: null,
                  arguments: [],
                  directives: [],
                  selectionSet: SelectionSetNode(
                    selections: [
                      FieldNode(
                        name: NameNode(value: 'path'),
                        alias: null,
                        arguments: [],
                        directives: [],
                        selectionSet: null,
                      ),
                      FieldNode(
                        name: NameNode(value: 'os'),
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
                  name: NameNode(value: 'library'),
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
                  name: NameNode(value: 'saves'),
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
                        name: NameNode(value: 'version'),
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
                        name: NameNode(value: 'sha256'),
                        alias: null,
                        arguments: [],
                        directives: [],
                        selectionSet: null,
                      ),
                      FieldNode(
                        name: NameNode(value: 'deviceName'),
                        alias: null,
                        arguments: [],
                        directives: [],
                        selectionSet: null,
                      ),
                      FieldNode(
                        name: NameNode(value: 'note'),
                        alias: null,
                        arguments: [],
                        directives: [],
                        selectionSet: null,
                      ),
                      FieldNode(
                        name: NameNode(value: 'createdAt'),
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
                  name: NameNode(value: 'achievements'),
                  alias: null,
                  arguments: [],
                  directives: [],
                  selectionSet: SelectionSetNode(
                    selections: [
                      FieldNode(
                        name: NameNode(value: 'total'),
                        alias: null,
                        arguments: [],
                        directives: [],
                        selectionSet: null,
                      ),
                      FieldNode(
                        name: NameNode(value: 'unlocked'),
                        alias: null,
                        arguments: [],
                        directives: [],
                        selectionSet: null,
                      ),
                      FieldNode(
                        name: NameNode(value: 'list'),
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
                              name: NameNode(value: 'source'),
                              alias: null,
                              arguments: [],
                              directives: [],
                              selectionSet: null,
                            ),
                            FieldNode(
                              name: NameNode(value: 'externalId'),
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
                              name: NameNode(value: 'description'),
                              alias: null,
                              arguments: [],
                              directives: [],
                              selectionSet: null,
                            ),
                            FieldNode(
                              name: NameNode(value: 'grade'),
                              alias: null,
                              arguments: [],
                              directives: [],
                              selectionSet: null,
                            ),
                            FieldNode(
                              name: NameNode(value: 'hidden'),
                              alias: null,
                              arguments: [],
                              directives: [],
                              selectionSet: null,
                            ),
                            FieldNode(
                              name: NameNode(value: 'unlockedAt'),
                              alias: null,
                              arguments: [],
                              directives: [],
                              selectionSet: null,
                            ),
                            FieldNode(
                              name: NameNode(value: 'icon'),
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
    fragmentDefinitionfragmentGame,
    fragmentDefinitionfragmentImages,
    fragmentDefinitionfragmentMetadata,
  ],
);

class Query$gameById$gameById implements Fragment$fragmentGame {
  Query$gameById$gameById({
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
    this.version,
    this.steamBuildId,
    this.updatedAt,
    required this.savePaths,
    required this.savePathSource,
    required this.savePathOverride,
    required this.$library,
    required this.saves,
    required this.achievements,
  });

  factory Query$gameById$gameById.fromJson(Map<String, dynamic> json) {
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
    final l$version = json['version'];
    final l$steamBuildId = json['steamBuildId'];
    final l$updatedAt = json['updatedAt'];
    final l$savePaths = json['savePaths'];
    final l$savePathSource = json['savePathSource'];
    final l$savePathOverride = json['savePathOverride'];
    final l$$library = json['library'];
    final l$saves = json['saves'];
    final l$achievements = json['achievements'];
    return Query$gameById$gameById(
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
      launcher: Query$gameById$gameById$launcher.fromJson(
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
      version: (l$version as String?),
      steamBuildId: (l$steamBuildId as String?),
      updatedAt: (l$updatedAt as String?),
      savePaths: (l$savePaths as List<dynamic>)
          .map(
            (e) => Query$gameById$gameById$savePaths.fromJson(
              (e as Map<String, dynamic>),
            ),
          )
          .toList(),
      savePathSource: (l$savePathSource as String),
      savePathOverride: (l$savePathOverride as List<dynamic>)
          .map(
            (e) => Query$gameById$gameById$savePathOverride.fromJson(
              (e as Map<String, dynamic>),
            ),
          )
          .toList(),
      $library: Query$gameById$gameById$library.fromJson(
        (l$$library as Map<String, dynamic>),
      ),
      saves: (l$saves as List<dynamic>)
          .map(
            (e) => Query$gameById$gameById$saves.fromJson(
              (e as Map<String, dynamic>),
            ),
          )
          .toList(),
      achievements: Query$gameById$gameById$achievements.fromJson(
        (l$achievements as Map<String, dynamic>),
      ),
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

  final Query$gameById$gameById$launcher launcher;

  final List<Fragment$fragmentImages>? images;

  final List<Fragment$fragmentMetadata>? metadata;

  final int? rating;

  final String? lastPlayed;

  final double playTimeMs;

  final String $__typename;

  final String? version;

  final String? steamBuildId;

  final String? updatedAt;

  final List<Query$gameById$gameById$savePaths> savePaths;

  final String savePathSource;

  final List<Query$gameById$gameById$savePathOverride> savePathOverride;

  final Query$gameById$gameById$library $library;

  final List<Query$gameById$gameById$saves> saves;

  final Query$gameById$gameById$achievements achievements;

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
    final l$version = version;
    _resultData['version'] = l$version;
    final l$steamBuildId = steamBuildId;
    _resultData['steamBuildId'] = l$steamBuildId;
    final l$updatedAt = updatedAt;
    _resultData['updatedAt'] = l$updatedAt;
    final l$savePaths = savePaths;
    _resultData['savePaths'] = l$savePaths.map((e) => e.toJson()).toList();
    final l$savePathSource = savePathSource;
    _resultData['savePathSource'] = l$savePathSource;
    final l$savePathOverride = savePathOverride;
    _resultData['savePathOverride'] = l$savePathOverride
        .map((e) => e.toJson())
        .toList();
    final l$$library = $library;
    _resultData['library'] = l$$library.toJson();
    final l$saves = saves;
    _resultData['saves'] = l$saves.map((e) => e.toJson()).toList();
    final l$achievements = achievements;
    _resultData['achievements'] = l$achievements.toJson();
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
    final l$version = version;
    final l$steamBuildId = steamBuildId;
    final l$updatedAt = updatedAt;
    final l$savePaths = savePaths;
    final l$savePathSource = savePathSource;
    final l$savePathOverride = savePathOverride;
    final l$$library = $library;
    final l$saves = saves;
    final l$achievements = achievements;
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
      l$version,
      l$steamBuildId,
      l$updatedAt,
      Object.hashAll(l$savePaths.map((v) => v)),
      l$savePathSource,
      Object.hashAll(l$savePathOverride.map((v) => v)),
      l$$library,
      Object.hashAll(l$saves.map((v) => v)),
      l$achievements,
    ]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Query$gameById$gameById || runtimeType != other.runtimeType) {
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
    final l$version = version;
    final lOther$version = other.version;
    if (l$version != lOther$version) {
      return false;
    }
    final l$steamBuildId = steamBuildId;
    final lOther$steamBuildId = other.steamBuildId;
    if (l$steamBuildId != lOther$steamBuildId) {
      return false;
    }
    final l$updatedAt = updatedAt;
    final lOther$updatedAt = other.updatedAt;
    if (l$updatedAt != lOther$updatedAt) {
      return false;
    }
    final l$savePaths = savePaths;
    final lOther$savePaths = other.savePaths;
    if (l$savePaths.length != lOther$savePaths.length) {
      return false;
    }
    for (int i = 0; i < l$savePaths.length; i++) {
      final l$savePaths$entry = l$savePaths[i];
      final lOther$savePaths$entry = lOther$savePaths[i];
      if (l$savePaths$entry != lOther$savePaths$entry) {
        return false;
      }
    }
    final l$savePathSource = savePathSource;
    final lOther$savePathSource = other.savePathSource;
    if (l$savePathSource != lOther$savePathSource) {
      return false;
    }
    final l$savePathOverride = savePathOverride;
    final lOther$savePathOverride = other.savePathOverride;
    if (l$savePathOverride.length != lOther$savePathOverride.length) {
      return false;
    }
    for (int i = 0; i < l$savePathOverride.length; i++) {
      final l$savePathOverride$entry = l$savePathOverride[i];
      final lOther$savePathOverride$entry = lOther$savePathOverride[i];
      if (l$savePathOverride$entry != lOther$savePathOverride$entry) {
        return false;
      }
    }
    final l$$library = $library;
    final lOther$$library = other.$library;
    if (l$$library != lOther$$library) {
      return false;
    }
    final l$saves = saves;
    final lOther$saves = other.saves;
    if (l$saves.length != lOther$saves.length) {
      return false;
    }
    for (int i = 0; i < l$saves.length; i++) {
      final l$saves$entry = l$saves[i];
      final lOther$saves$entry = lOther$saves[i];
      if (l$saves$entry != lOther$saves$entry) {
        return false;
      }
    }
    final l$achievements = achievements;
    final lOther$achievements = other.achievements;
    if (l$achievements != lOther$achievements) {
      return false;
    }
    return true;
  }
}

extension UtilityExtension$Query$gameById$gameById on Query$gameById$gameById {
  CopyWith$Query$gameById$gameById<Query$gameById$gameById> get copyWith =>
      CopyWith$Query$gameById$gameById(this, (i) => i);
}

abstract class CopyWith$Query$gameById$gameById<TRes> {
  factory CopyWith$Query$gameById$gameById(
    Query$gameById$gameById instance,
    TRes Function(Query$gameById$gameById) then,
  ) = _CopyWithImpl$Query$gameById$gameById;

  factory CopyWith$Query$gameById$gameById.stub(TRes res) =
      _CopyWithStubImpl$Query$gameById$gameById;

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
    Query$gameById$gameById$launcher? launcher,
    List<Fragment$fragmentImages>? images,
    List<Fragment$fragmentMetadata>? metadata,
    int? rating,
    String? lastPlayed,
    double? playTimeMs,
    String? $__typename,
    String? version,
    String? steamBuildId,
    String? updatedAt,
    List<Query$gameById$gameById$savePaths>? savePaths,
    String? savePathSource,
    List<Query$gameById$gameById$savePathOverride>? savePathOverride,
    Query$gameById$gameById$library? $library,
    List<Query$gameById$gameById$saves>? saves,
    Query$gameById$gameById$achievements? achievements,
  });
  CopyWith$Query$gameById$gameById$launcher<TRes> get launcher;
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
  TRes savePaths(
    Iterable<Query$gameById$gameById$savePaths> Function(
      Iterable<
        CopyWith$Query$gameById$gameById$savePaths<
          Query$gameById$gameById$savePaths
        >
      >,
    )
    _fn,
  );
  TRes savePathOverride(
    Iterable<Query$gameById$gameById$savePathOverride> Function(
      Iterable<
        CopyWith$Query$gameById$gameById$savePathOverride<
          Query$gameById$gameById$savePathOverride
        >
      >,
    )
    _fn,
  );
  CopyWith$Query$gameById$gameById$library<TRes> get $library;
  TRes saves(
    Iterable<Query$gameById$gameById$saves> Function(
      Iterable<
        CopyWith$Query$gameById$gameById$saves<Query$gameById$gameById$saves>
      >,
    )
    _fn,
  );
  CopyWith$Query$gameById$gameById$achievements<TRes> get achievements;
}

class _CopyWithImpl$Query$gameById$gameById<TRes>
    implements CopyWith$Query$gameById$gameById<TRes> {
  _CopyWithImpl$Query$gameById$gameById(this._instance, this._then);

  final Query$gameById$gameById _instance;

  final TRes Function(Query$gameById$gameById) _then;

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
    Object? version = _undefined,
    Object? steamBuildId = _undefined,
    Object? updatedAt = _undefined,
    Object? savePaths = _undefined,
    Object? savePathSource = _undefined,
    Object? savePathOverride = _undefined,
    Object? $library = _undefined,
    Object? saves = _undefined,
    Object? achievements = _undefined,
  }) => _then(
    Query$gameById$gameById(
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
          : (launcher as Query$gameById$gameById$launcher),
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
      version: version == _undefined ? _instance.version : (version as String?),
      steamBuildId: steamBuildId == _undefined
          ? _instance.steamBuildId
          : (steamBuildId as String?),
      updatedAt: updatedAt == _undefined
          ? _instance.updatedAt
          : (updatedAt as String?),
      savePaths: savePaths == _undefined || savePaths == null
          ? _instance.savePaths
          : (savePaths as List<Query$gameById$gameById$savePaths>),
      savePathSource: savePathSource == _undefined || savePathSource == null
          ? _instance.savePathSource
          : (savePathSource as String),
      savePathOverride:
          savePathOverride == _undefined || savePathOverride == null
          ? _instance.savePathOverride
          : (savePathOverride
                as List<Query$gameById$gameById$savePathOverride>),
      $library: $library == _undefined || $library == null
          ? _instance.$library
          : ($library as Query$gameById$gameById$library),
      saves: saves == _undefined || saves == null
          ? _instance.saves
          : (saves as List<Query$gameById$gameById$saves>),
      achievements: achievements == _undefined || achievements == null
          ? _instance.achievements
          : (achievements as Query$gameById$gameById$achievements),
    ),
  );

  CopyWith$Query$gameById$gameById$launcher<TRes> get launcher {
    final local$launcher = _instance.launcher;
    return CopyWith$Query$gameById$gameById$launcher(
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

  TRes savePaths(
    Iterable<Query$gameById$gameById$savePaths> Function(
      Iterable<
        CopyWith$Query$gameById$gameById$savePaths<
          Query$gameById$gameById$savePaths
        >
      >,
    )
    _fn,
  ) => call(
    savePaths: _fn(
      _instance.savePaths.map(
        (e) => CopyWith$Query$gameById$gameById$savePaths(e, (i) => i),
      ),
    ).toList(),
  );

  TRes savePathOverride(
    Iterable<Query$gameById$gameById$savePathOverride> Function(
      Iterable<
        CopyWith$Query$gameById$gameById$savePathOverride<
          Query$gameById$gameById$savePathOverride
        >
      >,
    )
    _fn,
  ) => call(
    savePathOverride: _fn(
      _instance.savePathOverride.map(
        (e) => CopyWith$Query$gameById$gameById$savePathOverride(e, (i) => i),
      ),
    ).toList(),
  );

  CopyWith$Query$gameById$gameById$library<TRes> get $library {
    final local$$library = _instance.$library;
    return CopyWith$Query$gameById$gameById$library(
      local$$library,
      (e) => call($library: e),
    );
  }

  TRes saves(
    Iterable<Query$gameById$gameById$saves> Function(
      Iterable<
        CopyWith$Query$gameById$gameById$saves<Query$gameById$gameById$saves>
      >,
    )
    _fn,
  ) => call(
    saves: _fn(
      _instance.saves.map(
        (e) => CopyWith$Query$gameById$gameById$saves(e, (i) => i),
      ),
    ).toList(),
  );

  CopyWith$Query$gameById$gameById$achievements<TRes> get achievements {
    final local$achievements = _instance.achievements;
    return CopyWith$Query$gameById$gameById$achievements(
      local$achievements,
      (e) => call(achievements: e),
    );
  }
}

class _CopyWithStubImpl$Query$gameById$gameById<TRes>
    implements CopyWith$Query$gameById$gameById<TRes> {
  _CopyWithStubImpl$Query$gameById$gameById(this._res);

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
    Query$gameById$gameById$launcher? launcher,
    List<Fragment$fragmentImages>? images,
    List<Fragment$fragmentMetadata>? metadata,
    int? rating,
    String? lastPlayed,
    double? playTimeMs,
    String? $__typename,
    String? version,
    String? steamBuildId,
    String? updatedAt,
    List<Query$gameById$gameById$savePaths>? savePaths,
    String? savePathSource,
    List<Query$gameById$gameById$savePathOverride>? savePathOverride,
    Query$gameById$gameById$library? $library,
    List<Query$gameById$gameById$saves>? saves,
    Query$gameById$gameById$achievements? achievements,
  }) => _res;

  CopyWith$Query$gameById$gameById$launcher<TRes> get launcher =>
      CopyWith$Query$gameById$gameById$launcher.stub(_res);

  images(_fn) => _res;

  metadata(_fn) => _res;

  savePaths(_fn) => _res;

  savePathOverride(_fn) => _res;

  CopyWith$Query$gameById$gameById$library<TRes> get $library =>
      CopyWith$Query$gameById$gameById$library.stub(_res);

  saves(_fn) => _res;

  CopyWith$Query$gameById$gameById$achievements<TRes> get achievements =>
      CopyWith$Query$gameById$gameById$achievements.stub(_res);
}

class Query$gameById$gameById$launcher
    implements Fragment$fragmentGame$launcher {
  Query$gameById$gameById$launcher({
    required this.kind,
    this.retroArchCore,
    this.$__typename = 'GameLauncherHint',
  });

  factory Query$gameById$gameById$launcher.fromJson(Map<String, dynamic> json) {
    final l$kind = json['kind'];
    final l$retroArchCore = json['retroArchCore'];
    final l$$__typename = json['__typename'];
    return Query$gameById$gameById$launcher(
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
    if (other is! Query$gameById$gameById$launcher ||
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

extension UtilityExtension$Query$gameById$gameById$launcher
    on Query$gameById$gameById$launcher {
  CopyWith$Query$gameById$gameById$launcher<Query$gameById$gameById$launcher>
  get copyWith => CopyWith$Query$gameById$gameById$launcher(this, (i) => i);
}

abstract class CopyWith$Query$gameById$gameById$launcher<TRes> {
  factory CopyWith$Query$gameById$gameById$launcher(
    Query$gameById$gameById$launcher instance,
    TRes Function(Query$gameById$gameById$launcher) then,
  ) = _CopyWithImpl$Query$gameById$gameById$launcher;

  factory CopyWith$Query$gameById$gameById$launcher.stub(TRes res) =
      _CopyWithStubImpl$Query$gameById$gameById$launcher;

  TRes call({
    Enum$GameLauncherKind? kind,
    String? retroArchCore,
    String? $__typename,
  });
}

class _CopyWithImpl$Query$gameById$gameById$launcher<TRes>
    implements CopyWith$Query$gameById$gameById$launcher<TRes> {
  _CopyWithImpl$Query$gameById$gameById$launcher(this._instance, this._then);

  final Query$gameById$gameById$launcher _instance;

  final TRes Function(Query$gameById$gameById$launcher) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? kind = _undefined,
    Object? retroArchCore = _undefined,
    Object? $__typename = _undefined,
  }) => _then(
    Query$gameById$gameById$launcher(
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

class _CopyWithStubImpl$Query$gameById$gameById$launcher<TRes>
    implements CopyWith$Query$gameById$gameById$launcher<TRes> {
  _CopyWithStubImpl$Query$gameById$gameById$launcher(this._res);

  TRes _res;

  call({
    Enum$GameLauncherKind? kind,
    String? retroArchCore,
    String? $__typename,
  }) => _res;
}

class Query$gameById$gameById$savePaths {
  Query$gameById$gameById$savePaths({
    required this.path,
    this.os,
    this.$__typename = 'GameSavePath',
  });

  factory Query$gameById$gameById$savePaths.fromJson(
    Map<String, dynamic> json,
  ) {
    final l$path = json['path'];
    final l$os = json['os'];
    final l$$__typename = json['__typename'];
    return Query$gameById$gameById$savePaths(
      path: (l$path as String),
      os: (l$os as String?),
      $__typename: (l$$__typename as String),
    );
  }

  final String path;

  final String? os;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$path = path;
    _resultData['path'] = l$path;
    final l$os = os;
    _resultData['os'] = l$os;
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$path = path;
    final l$os = os;
    final l$$__typename = $__typename;
    return Object.hashAll([l$path, l$os, l$$__typename]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Query$gameById$gameById$savePaths ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$path = path;
    final lOther$path = other.path;
    if (l$path != lOther$path) {
      return false;
    }
    final l$os = os;
    final lOther$os = other.os;
    if (l$os != lOther$os) {
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

extension UtilityExtension$Query$gameById$gameById$savePaths
    on Query$gameById$gameById$savePaths {
  CopyWith$Query$gameById$gameById$savePaths<Query$gameById$gameById$savePaths>
  get copyWith => CopyWith$Query$gameById$gameById$savePaths(this, (i) => i);
}

abstract class CopyWith$Query$gameById$gameById$savePaths<TRes> {
  factory CopyWith$Query$gameById$gameById$savePaths(
    Query$gameById$gameById$savePaths instance,
    TRes Function(Query$gameById$gameById$savePaths) then,
  ) = _CopyWithImpl$Query$gameById$gameById$savePaths;

  factory CopyWith$Query$gameById$gameById$savePaths.stub(TRes res) =
      _CopyWithStubImpl$Query$gameById$gameById$savePaths;

  TRes call({String? path, String? os, String? $__typename});
}

class _CopyWithImpl$Query$gameById$gameById$savePaths<TRes>
    implements CopyWith$Query$gameById$gameById$savePaths<TRes> {
  _CopyWithImpl$Query$gameById$gameById$savePaths(this._instance, this._then);

  final Query$gameById$gameById$savePaths _instance;

  final TRes Function(Query$gameById$gameById$savePaths) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? path = _undefined,
    Object? os = _undefined,
    Object? $__typename = _undefined,
  }) => _then(
    Query$gameById$gameById$savePaths(
      path: path == _undefined || path == null
          ? _instance.path
          : (path as String),
      os: os == _undefined ? _instance.os : (os as String?),
      $__typename: $__typename == _undefined || $__typename == null
          ? _instance.$__typename
          : ($__typename as String),
    ),
  );
}

class _CopyWithStubImpl$Query$gameById$gameById$savePaths<TRes>
    implements CopyWith$Query$gameById$gameById$savePaths<TRes> {
  _CopyWithStubImpl$Query$gameById$gameById$savePaths(this._res);

  TRes _res;

  call({String? path, String? os, String? $__typename}) => _res;
}

class Query$gameById$gameById$savePathOverride {
  Query$gameById$gameById$savePathOverride({
    required this.path,
    this.os,
    this.$__typename = 'GameSavePath',
  });

  factory Query$gameById$gameById$savePathOverride.fromJson(
    Map<String, dynamic> json,
  ) {
    final l$path = json['path'];
    final l$os = json['os'];
    final l$$__typename = json['__typename'];
    return Query$gameById$gameById$savePathOverride(
      path: (l$path as String),
      os: (l$os as String?),
      $__typename: (l$$__typename as String),
    );
  }

  final String path;

  final String? os;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$path = path;
    _resultData['path'] = l$path;
    final l$os = os;
    _resultData['os'] = l$os;
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$path = path;
    final l$os = os;
    final l$$__typename = $__typename;
    return Object.hashAll([l$path, l$os, l$$__typename]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Query$gameById$gameById$savePathOverride ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$path = path;
    final lOther$path = other.path;
    if (l$path != lOther$path) {
      return false;
    }
    final l$os = os;
    final lOther$os = other.os;
    if (l$os != lOther$os) {
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

extension UtilityExtension$Query$gameById$gameById$savePathOverride
    on Query$gameById$gameById$savePathOverride {
  CopyWith$Query$gameById$gameById$savePathOverride<
    Query$gameById$gameById$savePathOverride
  >
  get copyWith =>
      CopyWith$Query$gameById$gameById$savePathOverride(this, (i) => i);
}

abstract class CopyWith$Query$gameById$gameById$savePathOverride<TRes> {
  factory CopyWith$Query$gameById$gameById$savePathOverride(
    Query$gameById$gameById$savePathOverride instance,
    TRes Function(Query$gameById$gameById$savePathOverride) then,
  ) = _CopyWithImpl$Query$gameById$gameById$savePathOverride;

  factory CopyWith$Query$gameById$gameById$savePathOverride.stub(TRes res) =
      _CopyWithStubImpl$Query$gameById$gameById$savePathOverride;

  TRes call({String? path, String? os, String? $__typename});
}

class _CopyWithImpl$Query$gameById$gameById$savePathOverride<TRes>
    implements CopyWith$Query$gameById$gameById$savePathOverride<TRes> {
  _CopyWithImpl$Query$gameById$gameById$savePathOverride(
    this._instance,
    this._then,
  );

  final Query$gameById$gameById$savePathOverride _instance;

  final TRes Function(Query$gameById$gameById$savePathOverride) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? path = _undefined,
    Object? os = _undefined,
    Object? $__typename = _undefined,
  }) => _then(
    Query$gameById$gameById$savePathOverride(
      path: path == _undefined || path == null
          ? _instance.path
          : (path as String),
      os: os == _undefined ? _instance.os : (os as String?),
      $__typename: $__typename == _undefined || $__typename == null
          ? _instance.$__typename
          : ($__typename as String),
    ),
  );
}

class _CopyWithStubImpl$Query$gameById$gameById$savePathOverride<TRes>
    implements CopyWith$Query$gameById$gameById$savePathOverride<TRes> {
  _CopyWithStubImpl$Query$gameById$gameById$savePathOverride(this._res);

  TRes _res;

  call({String? path, String? os, String? $__typename}) => _res;
}

class Query$gameById$gameById$library {
  Query$gameById$gameById$library({
    required this.id,
    required this.name,
    this.$__typename = 'Library',
  });

  factory Query$gameById$gameById$library.fromJson(Map<String, dynamic> json) {
    final l$id = json['id'];
    final l$name = json['name'];
    final l$$__typename = json['__typename'];
    return Query$gameById$gameById$library(
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
    if (other is! Query$gameById$gameById$library ||
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

extension UtilityExtension$Query$gameById$gameById$library
    on Query$gameById$gameById$library {
  CopyWith$Query$gameById$gameById$library<Query$gameById$gameById$library>
  get copyWith => CopyWith$Query$gameById$gameById$library(this, (i) => i);
}

abstract class CopyWith$Query$gameById$gameById$library<TRes> {
  factory CopyWith$Query$gameById$gameById$library(
    Query$gameById$gameById$library instance,
    TRes Function(Query$gameById$gameById$library) then,
  ) = _CopyWithImpl$Query$gameById$gameById$library;

  factory CopyWith$Query$gameById$gameById$library.stub(TRes res) =
      _CopyWithStubImpl$Query$gameById$gameById$library;

  TRes call({String? id, String? name, String? $__typename});
}

class _CopyWithImpl$Query$gameById$gameById$library<TRes>
    implements CopyWith$Query$gameById$gameById$library<TRes> {
  _CopyWithImpl$Query$gameById$gameById$library(this._instance, this._then);

  final Query$gameById$gameById$library _instance;

  final TRes Function(Query$gameById$gameById$library) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? id = _undefined,
    Object? name = _undefined,
    Object? $__typename = _undefined,
  }) => _then(
    Query$gameById$gameById$library(
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

class _CopyWithStubImpl$Query$gameById$gameById$library<TRes>
    implements CopyWith$Query$gameById$gameById$library<TRes> {
  _CopyWithStubImpl$Query$gameById$gameById$library(this._res);

  TRes _res;

  call({String? id, String? name, String? $__typename}) => _res;
}

class Query$gameById$gameById$saves {
  Query$gameById$gameById$saves({
    required this.id,
    required this.version,
    required this.sizeBytes,
    required this.sha256,
    this.deviceName,
    this.note,
    required this.createdAt,
    this.$__typename = 'GameSave',
  });

  factory Query$gameById$gameById$saves.fromJson(Map<String, dynamic> json) {
    final l$id = json['id'];
    final l$version = json['version'];
    final l$sizeBytes = json['sizeBytes'];
    final l$sha256 = json['sha256'];
    final l$deviceName = json['deviceName'];
    final l$note = json['note'];
    final l$createdAt = json['createdAt'];
    final l$$__typename = json['__typename'];
    return Query$gameById$gameById$saves(
      id: (l$id as String),
      version: (l$version as int),
      sizeBytes: (l$sizeBytes as num).toDouble(),
      sha256: (l$sha256 as String),
      deviceName: (l$deviceName as String?),
      note: (l$note as String?),
      createdAt: (l$createdAt as String),
      $__typename: (l$$__typename as String),
    );
  }

  final String id;

  final int version;

  final double sizeBytes;

  final String sha256;

  final String? deviceName;

  final String? note;

  final String createdAt;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$id = id;
    _resultData['id'] = l$id;
    final l$version = version;
    _resultData['version'] = l$version;
    final l$sizeBytes = sizeBytes;
    _resultData['sizeBytes'] = l$sizeBytes;
    final l$sha256 = sha256;
    _resultData['sha256'] = l$sha256;
    final l$deviceName = deviceName;
    _resultData['deviceName'] = l$deviceName;
    final l$note = note;
    _resultData['note'] = l$note;
    final l$createdAt = createdAt;
    _resultData['createdAt'] = l$createdAt;
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$id = id;
    final l$version = version;
    final l$sizeBytes = sizeBytes;
    final l$sha256 = sha256;
    final l$deviceName = deviceName;
    final l$note = note;
    final l$createdAt = createdAt;
    final l$$__typename = $__typename;
    return Object.hashAll([
      l$id,
      l$version,
      l$sizeBytes,
      l$sha256,
      l$deviceName,
      l$note,
      l$createdAt,
      l$$__typename,
    ]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Query$gameById$gameById$saves ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$id = id;
    final lOther$id = other.id;
    if (l$id != lOther$id) {
      return false;
    }
    final l$version = version;
    final lOther$version = other.version;
    if (l$version != lOther$version) {
      return false;
    }
    final l$sizeBytes = sizeBytes;
    final lOther$sizeBytes = other.sizeBytes;
    if (l$sizeBytes != lOther$sizeBytes) {
      return false;
    }
    final l$sha256 = sha256;
    final lOther$sha256 = other.sha256;
    if (l$sha256 != lOther$sha256) {
      return false;
    }
    final l$deviceName = deviceName;
    final lOther$deviceName = other.deviceName;
    if (l$deviceName != lOther$deviceName) {
      return false;
    }
    final l$note = note;
    final lOther$note = other.note;
    if (l$note != lOther$note) {
      return false;
    }
    final l$createdAt = createdAt;
    final lOther$createdAt = other.createdAt;
    if (l$createdAt != lOther$createdAt) {
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

extension UtilityExtension$Query$gameById$gameById$saves
    on Query$gameById$gameById$saves {
  CopyWith$Query$gameById$gameById$saves<Query$gameById$gameById$saves>
  get copyWith => CopyWith$Query$gameById$gameById$saves(this, (i) => i);
}

abstract class CopyWith$Query$gameById$gameById$saves<TRes> {
  factory CopyWith$Query$gameById$gameById$saves(
    Query$gameById$gameById$saves instance,
    TRes Function(Query$gameById$gameById$saves) then,
  ) = _CopyWithImpl$Query$gameById$gameById$saves;

  factory CopyWith$Query$gameById$gameById$saves.stub(TRes res) =
      _CopyWithStubImpl$Query$gameById$gameById$saves;

  TRes call({
    String? id,
    int? version,
    double? sizeBytes,
    String? sha256,
    String? deviceName,
    String? note,
    String? createdAt,
    String? $__typename,
  });
}

class _CopyWithImpl$Query$gameById$gameById$saves<TRes>
    implements CopyWith$Query$gameById$gameById$saves<TRes> {
  _CopyWithImpl$Query$gameById$gameById$saves(this._instance, this._then);

  final Query$gameById$gameById$saves _instance;

  final TRes Function(Query$gameById$gameById$saves) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? id = _undefined,
    Object? version = _undefined,
    Object? sizeBytes = _undefined,
    Object? sha256 = _undefined,
    Object? deviceName = _undefined,
    Object? note = _undefined,
    Object? createdAt = _undefined,
    Object? $__typename = _undefined,
  }) => _then(
    Query$gameById$gameById$saves(
      id: id == _undefined || id == null ? _instance.id : (id as String),
      version: version == _undefined || version == null
          ? _instance.version
          : (version as int),
      sizeBytes: sizeBytes == _undefined || sizeBytes == null
          ? _instance.sizeBytes
          : (sizeBytes as double),
      sha256: sha256 == _undefined || sha256 == null
          ? _instance.sha256
          : (sha256 as String),
      deviceName: deviceName == _undefined
          ? _instance.deviceName
          : (deviceName as String?),
      note: note == _undefined ? _instance.note : (note as String?),
      createdAt: createdAt == _undefined || createdAt == null
          ? _instance.createdAt
          : (createdAt as String),
      $__typename: $__typename == _undefined || $__typename == null
          ? _instance.$__typename
          : ($__typename as String),
    ),
  );
}

class _CopyWithStubImpl$Query$gameById$gameById$saves<TRes>
    implements CopyWith$Query$gameById$gameById$saves<TRes> {
  _CopyWithStubImpl$Query$gameById$gameById$saves(this._res);

  TRes _res;

  call({
    String? id,
    int? version,
    double? sizeBytes,
    String? sha256,
    String? deviceName,
    String? note,
    String? createdAt,
    String? $__typename,
  }) => _res;
}

class Query$gameById$gameById$achievements {
  Query$gameById$gameById$achievements({
    required this.total,
    required this.unlocked,
    required this.list,
    this.$__typename = 'GameAchievementSummary',
  });

  factory Query$gameById$gameById$achievements.fromJson(
    Map<String, dynamic> json,
  ) {
    final l$total = json['total'];
    final l$unlocked = json['unlocked'];
    final l$list = json['list'];
    final l$$__typename = json['__typename'];
    return Query$gameById$gameById$achievements(
      total: (l$total as int),
      unlocked: (l$unlocked as int),
      list: (l$list as List<dynamic>)
          .map(
            (e) => Query$gameById$gameById$achievements$list.fromJson(
              (e as Map<String, dynamic>),
            ),
          )
          .toList(),
      $__typename: (l$$__typename as String),
    );
  }

  final int total;

  final int unlocked;

  final List<Query$gameById$gameById$achievements$list> list;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$total = total;
    _resultData['total'] = l$total;
    final l$unlocked = unlocked;
    _resultData['unlocked'] = l$unlocked;
    final l$list = list;
    _resultData['list'] = l$list.map((e) => e.toJson()).toList();
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$total = total;
    final l$unlocked = unlocked;
    final l$list = list;
    final l$$__typename = $__typename;
    return Object.hashAll([
      l$total,
      l$unlocked,
      Object.hashAll(l$list.map((v) => v)),
      l$$__typename,
    ]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Query$gameById$gameById$achievements ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$total = total;
    final lOther$total = other.total;
    if (l$total != lOther$total) {
      return false;
    }
    final l$unlocked = unlocked;
    final lOther$unlocked = other.unlocked;
    if (l$unlocked != lOther$unlocked) {
      return false;
    }
    final l$list = list;
    final lOther$list = other.list;
    if (l$list.length != lOther$list.length) {
      return false;
    }
    for (int i = 0; i < l$list.length; i++) {
      final l$list$entry = l$list[i];
      final lOther$list$entry = lOther$list[i];
      if (l$list$entry != lOther$list$entry) {
        return false;
      }
    }
    final l$$__typename = $__typename;
    final lOther$$__typename = other.$__typename;
    if (l$$__typename != lOther$$__typename) {
      return false;
    }
    return true;
  }
}

extension UtilityExtension$Query$gameById$gameById$achievements
    on Query$gameById$gameById$achievements {
  CopyWith$Query$gameById$gameById$achievements<
    Query$gameById$gameById$achievements
  >
  get copyWith => CopyWith$Query$gameById$gameById$achievements(this, (i) => i);
}

abstract class CopyWith$Query$gameById$gameById$achievements<TRes> {
  factory CopyWith$Query$gameById$gameById$achievements(
    Query$gameById$gameById$achievements instance,
    TRes Function(Query$gameById$gameById$achievements) then,
  ) = _CopyWithImpl$Query$gameById$gameById$achievements;

  factory CopyWith$Query$gameById$gameById$achievements.stub(TRes res) =
      _CopyWithStubImpl$Query$gameById$gameById$achievements;

  TRes call({
    int? total,
    int? unlocked,
    List<Query$gameById$gameById$achievements$list>? list,
    String? $__typename,
  });
  TRes list(
    Iterable<Query$gameById$gameById$achievements$list> Function(
      Iterable<
        CopyWith$Query$gameById$gameById$achievements$list<
          Query$gameById$gameById$achievements$list
        >
      >,
    )
    _fn,
  );
}

class _CopyWithImpl$Query$gameById$gameById$achievements<TRes>
    implements CopyWith$Query$gameById$gameById$achievements<TRes> {
  _CopyWithImpl$Query$gameById$gameById$achievements(
    this._instance,
    this._then,
  );

  final Query$gameById$gameById$achievements _instance;

  final TRes Function(Query$gameById$gameById$achievements) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? total = _undefined,
    Object? unlocked = _undefined,
    Object? list = _undefined,
    Object? $__typename = _undefined,
  }) => _then(
    Query$gameById$gameById$achievements(
      total: total == _undefined || total == null
          ? _instance.total
          : (total as int),
      unlocked: unlocked == _undefined || unlocked == null
          ? _instance.unlocked
          : (unlocked as int),
      list: list == _undefined || list == null
          ? _instance.list
          : (list as List<Query$gameById$gameById$achievements$list>),
      $__typename: $__typename == _undefined || $__typename == null
          ? _instance.$__typename
          : ($__typename as String),
    ),
  );

  TRes list(
    Iterable<Query$gameById$gameById$achievements$list> Function(
      Iterable<
        CopyWith$Query$gameById$gameById$achievements$list<
          Query$gameById$gameById$achievements$list
        >
      >,
    )
    _fn,
  ) => call(
    list: _fn(
      _instance.list.map(
        (e) => CopyWith$Query$gameById$gameById$achievements$list(e, (i) => i),
      ),
    ).toList(),
  );
}

class _CopyWithStubImpl$Query$gameById$gameById$achievements<TRes>
    implements CopyWith$Query$gameById$gameById$achievements<TRes> {
  _CopyWithStubImpl$Query$gameById$gameById$achievements(this._res);

  TRes _res;

  call({
    int? total,
    int? unlocked,
    List<Query$gameById$gameById$achievements$list>? list,
    String? $__typename,
  }) => _res;

  list(_fn) => _res;
}

class Query$gameById$gameById$achievements$list {
  Query$gameById$gameById$achievements$list({
    required this.id,
    required this.source,
    required this.externalId,
    required this.name,
    this.description,
    this.grade,
    required this.hidden,
    this.unlockedAt,
    this.icon,
    this.$__typename = 'GameAchievement',
  });

  factory Query$gameById$gameById$achievements$list.fromJson(
    Map<String, dynamic> json,
  ) {
    final l$id = json['id'];
    final l$source = json['source'];
    final l$externalId = json['externalId'];
    final l$name = json['name'];
    final l$description = json['description'];
    final l$grade = json['grade'];
    final l$hidden = json['hidden'];
    final l$unlockedAt = json['unlockedAt'];
    final l$icon = json['icon'];
    final l$$__typename = json['__typename'];
    return Query$gameById$gameById$achievements$list(
      id: (l$id as String),
      source: fromJson$Enum$GameAchievementSource((l$source as String)),
      externalId: (l$externalId as String),
      name: (l$name as String),
      description: (l$description as String?),
      grade: (l$grade as String?),
      hidden: (l$hidden as bool),
      unlockedAt: (l$unlockedAt as String?),
      icon: l$icon == null
          ? null
          : Fragment$fragmentImages.fromJson((l$icon as Map<String, dynamic>)),
      $__typename: (l$$__typename as String),
    );
  }

  final String id;

  final Enum$GameAchievementSource source;

  final String externalId;

  final String name;

  final String? description;

  final String? grade;

  final bool hidden;

  final String? unlockedAt;

  final Fragment$fragmentImages? icon;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$id = id;
    _resultData['id'] = l$id;
    final l$source = source;
    _resultData['source'] = toJson$Enum$GameAchievementSource(l$source);
    final l$externalId = externalId;
    _resultData['externalId'] = l$externalId;
    final l$name = name;
    _resultData['name'] = l$name;
    final l$description = description;
    _resultData['description'] = l$description;
    final l$grade = grade;
    _resultData['grade'] = l$grade;
    final l$hidden = hidden;
    _resultData['hidden'] = l$hidden;
    final l$unlockedAt = unlockedAt;
    _resultData['unlockedAt'] = l$unlockedAt;
    final l$icon = icon;
    _resultData['icon'] = l$icon?.toJson();
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$id = id;
    final l$source = source;
    final l$externalId = externalId;
    final l$name = name;
    final l$description = description;
    final l$grade = grade;
    final l$hidden = hidden;
    final l$unlockedAt = unlockedAt;
    final l$icon = icon;
    final l$$__typename = $__typename;
    return Object.hashAll([
      l$id,
      l$source,
      l$externalId,
      l$name,
      l$description,
      l$grade,
      l$hidden,
      l$unlockedAt,
      l$icon,
      l$$__typename,
    ]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Query$gameById$gameById$achievements$list ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$id = id;
    final lOther$id = other.id;
    if (l$id != lOther$id) {
      return false;
    }
    final l$source = source;
    final lOther$source = other.source;
    if (l$source != lOther$source) {
      return false;
    }
    final l$externalId = externalId;
    final lOther$externalId = other.externalId;
    if (l$externalId != lOther$externalId) {
      return false;
    }
    final l$name = name;
    final lOther$name = other.name;
    if (l$name != lOther$name) {
      return false;
    }
    final l$description = description;
    final lOther$description = other.description;
    if (l$description != lOther$description) {
      return false;
    }
    final l$grade = grade;
    final lOther$grade = other.grade;
    if (l$grade != lOther$grade) {
      return false;
    }
    final l$hidden = hidden;
    final lOther$hidden = other.hidden;
    if (l$hidden != lOther$hidden) {
      return false;
    }
    final l$unlockedAt = unlockedAt;
    final lOther$unlockedAt = other.unlockedAt;
    if (l$unlockedAt != lOther$unlockedAt) {
      return false;
    }
    final l$icon = icon;
    final lOther$icon = other.icon;
    if (l$icon != lOther$icon) {
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

extension UtilityExtension$Query$gameById$gameById$achievements$list
    on Query$gameById$gameById$achievements$list {
  CopyWith$Query$gameById$gameById$achievements$list<
    Query$gameById$gameById$achievements$list
  >
  get copyWith =>
      CopyWith$Query$gameById$gameById$achievements$list(this, (i) => i);
}

abstract class CopyWith$Query$gameById$gameById$achievements$list<TRes> {
  factory CopyWith$Query$gameById$gameById$achievements$list(
    Query$gameById$gameById$achievements$list instance,
    TRes Function(Query$gameById$gameById$achievements$list) then,
  ) = _CopyWithImpl$Query$gameById$gameById$achievements$list;

  factory CopyWith$Query$gameById$gameById$achievements$list.stub(TRes res) =
      _CopyWithStubImpl$Query$gameById$gameById$achievements$list;

  TRes call({
    String? id,
    Enum$GameAchievementSource? source,
    String? externalId,
    String? name,
    String? description,
    String? grade,
    bool? hidden,
    String? unlockedAt,
    Fragment$fragmentImages? icon,
    String? $__typename,
  });
  CopyWith$Fragment$fragmentImages<TRes> get icon;
}

class _CopyWithImpl$Query$gameById$gameById$achievements$list<TRes>
    implements CopyWith$Query$gameById$gameById$achievements$list<TRes> {
  _CopyWithImpl$Query$gameById$gameById$achievements$list(
    this._instance,
    this._then,
  );

  final Query$gameById$gameById$achievements$list _instance;

  final TRes Function(Query$gameById$gameById$achievements$list) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? id = _undefined,
    Object? source = _undefined,
    Object? externalId = _undefined,
    Object? name = _undefined,
    Object? description = _undefined,
    Object? grade = _undefined,
    Object? hidden = _undefined,
    Object? unlockedAt = _undefined,
    Object? icon = _undefined,
    Object? $__typename = _undefined,
  }) => _then(
    Query$gameById$gameById$achievements$list(
      id: id == _undefined || id == null ? _instance.id : (id as String),
      source: source == _undefined || source == null
          ? _instance.source
          : (source as Enum$GameAchievementSource),
      externalId: externalId == _undefined || externalId == null
          ? _instance.externalId
          : (externalId as String),
      name: name == _undefined || name == null
          ? _instance.name
          : (name as String),
      description: description == _undefined
          ? _instance.description
          : (description as String?),
      grade: grade == _undefined ? _instance.grade : (grade as String?),
      hidden: hidden == _undefined || hidden == null
          ? _instance.hidden
          : (hidden as bool),
      unlockedAt: unlockedAt == _undefined
          ? _instance.unlockedAt
          : (unlockedAt as String?),
      icon: icon == _undefined
          ? _instance.icon
          : (icon as Fragment$fragmentImages?),
      $__typename: $__typename == _undefined || $__typename == null
          ? _instance.$__typename
          : ($__typename as String),
    ),
  );

  CopyWith$Fragment$fragmentImages<TRes> get icon {
    final local$icon = _instance.icon;
    return local$icon == null
        ? CopyWith$Fragment$fragmentImages.stub(_then(_instance))
        : CopyWith$Fragment$fragmentImages(local$icon, (e) => call(icon: e));
  }
}

class _CopyWithStubImpl$Query$gameById$gameById$achievements$list<TRes>
    implements CopyWith$Query$gameById$gameById$achievements$list<TRes> {
  _CopyWithStubImpl$Query$gameById$gameById$achievements$list(this._res);

  TRes _res;

  call({
    String? id,
    Enum$GameAchievementSource? source,
    String? externalId,
    String? name,
    String? description,
    String? grade,
    bool? hidden,
    String? unlockedAt,
    Fragment$fragmentImages? icon,
    String? $__typename,
  }) => _res;

  CopyWith$Fragment$fragmentImages<TRes> get icon =>
      CopyWith$Fragment$fragmentImages.stub(_res);
}

import 'package:gql/ast.dart';

import 'schema.graphql.dart';

class Query$gamePlatforms {
  Query$gamePlatforms({
    required this.gamePlatforms,
    this.$__typename = 'Query',
  });

  factory Query$gamePlatforms.fromJson(Map<String, dynamic> json) {
    final l$gamePlatforms = json['gamePlatforms'];
    final l$$__typename = json['__typename'];
    return Query$gamePlatforms(
      gamePlatforms: (l$gamePlatforms as List<dynamic>)
          .map(
            (e) => Query$gamePlatforms$gamePlatforms.fromJson(
              (e as Map<String, dynamic>),
            ),
          )
          .toList(),
      $__typename: (l$$__typename as String),
    );
  }

  final List<Query$gamePlatforms$gamePlatforms> gamePlatforms;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$gamePlatforms = gamePlatforms;
    _resultData['gamePlatforms'] = l$gamePlatforms
        .map((e) => e.toJson())
        .toList();
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$gamePlatforms = gamePlatforms;
    final l$$__typename = $__typename;
    return Object.hashAll([
      Object.hashAll(l$gamePlatforms.map((v) => v)),
      l$$__typename,
    ]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Query$gamePlatforms || runtimeType != other.runtimeType) {
      return false;
    }
    final l$gamePlatforms = gamePlatforms;
    final lOther$gamePlatforms = other.gamePlatforms;
    if (l$gamePlatforms.length != lOther$gamePlatforms.length) {
      return false;
    }
    for (int i = 0; i < l$gamePlatforms.length; i++) {
      final l$gamePlatforms$entry = l$gamePlatforms[i];
      final lOther$gamePlatforms$entry = lOther$gamePlatforms[i];
      if (l$gamePlatforms$entry != lOther$gamePlatforms$entry) {
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

extension UtilityExtension$Query$gamePlatforms on Query$gamePlatforms {
  CopyWith$Query$gamePlatforms<Query$gamePlatforms> get copyWith =>
      CopyWith$Query$gamePlatforms(this, (i) => i);
}

abstract class CopyWith$Query$gamePlatforms<TRes> {
  factory CopyWith$Query$gamePlatforms(
    Query$gamePlatforms instance,
    TRes Function(Query$gamePlatforms) then,
  ) = _CopyWithImpl$Query$gamePlatforms;

  factory CopyWith$Query$gamePlatforms.stub(TRes res) =
      _CopyWithStubImpl$Query$gamePlatforms;

  TRes call({
    List<Query$gamePlatforms$gamePlatforms>? gamePlatforms,
    String? $__typename,
  });
  TRes gamePlatforms(
    Iterable<Query$gamePlatforms$gamePlatforms> Function(
      Iterable<
        CopyWith$Query$gamePlatforms$gamePlatforms<
          Query$gamePlatforms$gamePlatforms
        >
      >,
    )
    _fn,
  );
}

class _CopyWithImpl$Query$gamePlatforms<TRes>
    implements CopyWith$Query$gamePlatforms<TRes> {
  _CopyWithImpl$Query$gamePlatforms(this._instance, this._then);

  final Query$gamePlatforms _instance;

  final TRes Function(Query$gamePlatforms) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? gamePlatforms = _undefined,
    Object? $__typename = _undefined,
  }) => _then(
    Query$gamePlatforms(
      gamePlatforms: gamePlatforms == _undefined || gamePlatforms == null
          ? _instance.gamePlatforms
          : (gamePlatforms as List<Query$gamePlatforms$gamePlatforms>),
      $__typename: $__typename == _undefined || $__typename == null
          ? _instance.$__typename
          : ($__typename as String),
    ),
  );

  TRes gamePlatforms(
    Iterable<Query$gamePlatforms$gamePlatforms> Function(
      Iterable<
        CopyWith$Query$gamePlatforms$gamePlatforms<
          Query$gamePlatforms$gamePlatforms
        >
      >,
    )
    _fn,
  ) => call(
    gamePlatforms: _fn(
      _instance.gamePlatforms.map(
        (e) => CopyWith$Query$gamePlatforms$gamePlatforms(e, (i) => i),
      ),
    ).toList(),
  );
}

class _CopyWithStubImpl$Query$gamePlatforms<TRes>
    implements CopyWith$Query$gamePlatforms<TRes> {
  _CopyWithStubImpl$Query$gamePlatforms(this._res);

  TRes _res;

  call({
    List<Query$gamePlatforms$gamePlatforms>? gamePlatforms,
    String? $__typename,
  }) => _res;

  gamePlatforms(_fn) => _res;
}

const documentNodeQuerygamePlatforms = DocumentNode(
  definitions: [
    OperationDefinitionNode(
      type: OperationType.query,
      name: NameNode(value: 'gamePlatforms'),
      variableDefinitions: [],
      directives: [],
      selectionSet: SelectionSetNode(
        selections: [
          FieldNode(
            name: NameNode(value: 'gamePlatforms'),
            alias: null,
            arguments: [],
            directives: [],
            selectionSet: SelectionSetNode(
              selections: [
                FieldNode(
                  name: NameNode(value: 'platform'),
                  alias: null,
                  arguments: [],
                  directives: [],
                  selectionSet: null,
                ),
                FieldNode(
                  name: NameNode(value: 'folderNames'),
                  alias: null,
                  arguments: [],
                  directives: [],
                  selectionSet: null,
                ),
                FieldNode(
                  name: NameNode(value: 'entryExtensions'),
                  alias: null,
                  arguments: [],
                  directives: [],
                  selectionSet: null,
                ),
                FieldNode(
                  name: NameNode(value: 'companionExtensions'),
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
  ],
);

class Query$gamePlatforms$gamePlatforms {
  Query$gamePlatforms$gamePlatforms({
    required this.platform,
    required this.folderNames,
    required this.entryExtensions,
    required this.companionExtensions,
    required this.launcher,
    this.$__typename = 'GamePlatformInfo',
  });

  factory Query$gamePlatforms$gamePlatforms.fromJson(
    Map<String, dynamic> json,
  ) {
    final l$platform = json['platform'];
    final l$folderNames = json['folderNames'];
    final l$entryExtensions = json['entryExtensions'];
    final l$companionExtensions = json['companionExtensions'];
    final l$launcher = json['launcher'];
    final l$$__typename = json['__typename'];
    return Query$gamePlatforms$gamePlatforms(
      platform: fromJson$Enum$GamePlatform((l$platform as String)),
      folderNames: (l$folderNames as List<dynamic>)
          .map((e) => (e as String))
          .toList(),
      entryExtensions: (l$entryExtensions as List<dynamic>)
          .map((e) => (e as String))
          .toList(),
      companionExtensions: (l$companionExtensions as List<dynamic>)
          .map((e) => (e as String))
          .toList(),
      launcher: Query$gamePlatforms$gamePlatforms$launcher.fromJson(
        (l$launcher as Map<String, dynamic>),
      ),
      $__typename: (l$$__typename as String),
    );
  }

  final Enum$GamePlatform platform;

  final List<String> folderNames;

  final List<String> entryExtensions;

  final List<String> companionExtensions;

  final Query$gamePlatforms$gamePlatforms$launcher launcher;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$platform = platform;
    _resultData['platform'] = toJson$Enum$GamePlatform(l$platform);
    final l$folderNames = folderNames;
    _resultData['folderNames'] = l$folderNames.map((e) => e).toList();
    final l$entryExtensions = entryExtensions;
    _resultData['entryExtensions'] = l$entryExtensions.map((e) => e).toList();
    final l$companionExtensions = companionExtensions;
    _resultData['companionExtensions'] = l$companionExtensions
        .map((e) => e)
        .toList();
    final l$launcher = launcher;
    _resultData['launcher'] = l$launcher.toJson();
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$platform = platform;
    final l$folderNames = folderNames;
    final l$entryExtensions = entryExtensions;
    final l$companionExtensions = companionExtensions;
    final l$launcher = launcher;
    final l$$__typename = $__typename;
    return Object.hashAll([
      l$platform,
      Object.hashAll(l$folderNames.map((v) => v)),
      Object.hashAll(l$entryExtensions.map((v) => v)),
      Object.hashAll(l$companionExtensions.map((v) => v)),
      l$launcher,
      l$$__typename,
    ]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Query$gamePlatforms$gamePlatforms ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$platform = platform;
    final lOther$platform = other.platform;
    if (l$platform != lOther$platform) {
      return false;
    }
    final l$folderNames = folderNames;
    final lOther$folderNames = other.folderNames;
    if (l$folderNames.length != lOther$folderNames.length) {
      return false;
    }
    for (int i = 0; i < l$folderNames.length; i++) {
      final l$folderNames$entry = l$folderNames[i];
      final lOther$folderNames$entry = lOther$folderNames[i];
      if (l$folderNames$entry != lOther$folderNames$entry) {
        return false;
      }
    }
    final l$entryExtensions = entryExtensions;
    final lOther$entryExtensions = other.entryExtensions;
    if (l$entryExtensions.length != lOther$entryExtensions.length) {
      return false;
    }
    for (int i = 0; i < l$entryExtensions.length; i++) {
      final l$entryExtensions$entry = l$entryExtensions[i];
      final lOther$entryExtensions$entry = lOther$entryExtensions[i];
      if (l$entryExtensions$entry != lOther$entryExtensions$entry) {
        return false;
      }
    }
    final l$companionExtensions = companionExtensions;
    final lOther$companionExtensions = other.companionExtensions;
    if (l$companionExtensions.length != lOther$companionExtensions.length) {
      return false;
    }
    for (int i = 0; i < l$companionExtensions.length; i++) {
      final l$companionExtensions$entry = l$companionExtensions[i];
      final lOther$companionExtensions$entry = lOther$companionExtensions[i];
      if (l$companionExtensions$entry != lOther$companionExtensions$entry) {
        return false;
      }
    }
    final l$launcher = launcher;
    final lOther$launcher = other.launcher;
    if (l$launcher != lOther$launcher) {
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

extension UtilityExtension$Query$gamePlatforms$gamePlatforms
    on Query$gamePlatforms$gamePlatforms {
  CopyWith$Query$gamePlatforms$gamePlatforms<Query$gamePlatforms$gamePlatforms>
  get copyWith => CopyWith$Query$gamePlatforms$gamePlatforms(this, (i) => i);
}

abstract class CopyWith$Query$gamePlatforms$gamePlatforms<TRes> {
  factory CopyWith$Query$gamePlatforms$gamePlatforms(
    Query$gamePlatforms$gamePlatforms instance,
    TRes Function(Query$gamePlatforms$gamePlatforms) then,
  ) = _CopyWithImpl$Query$gamePlatforms$gamePlatforms;

  factory CopyWith$Query$gamePlatforms$gamePlatforms.stub(TRes res) =
      _CopyWithStubImpl$Query$gamePlatforms$gamePlatforms;

  TRes call({
    Enum$GamePlatform? platform,
    List<String>? folderNames,
    List<String>? entryExtensions,
    List<String>? companionExtensions,
    Query$gamePlatforms$gamePlatforms$launcher? launcher,
    String? $__typename,
  });
  CopyWith$Query$gamePlatforms$gamePlatforms$launcher<TRes> get launcher;
}

class _CopyWithImpl$Query$gamePlatforms$gamePlatforms<TRes>
    implements CopyWith$Query$gamePlatforms$gamePlatforms<TRes> {
  _CopyWithImpl$Query$gamePlatforms$gamePlatforms(this._instance, this._then);

  final Query$gamePlatforms$gamePlatforms _instance;

  final TRes Function(Query$gamePlatforms$gamePlatforms) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? platform = _undefined,
    Object? folderNames = _undefined,
    Object? entryExtensions = _undefined,
    Object? companionExtensions = _undefined,
    Object? launcher = _undefined,
    Object? $__typename = _undefined,
  }) => _then(
    Query$gamePlatforms$gamePlatforms(
      platform: platform == _undefined || platform == null
          ? _instance.platform
          : (platform as Enum$GamePlatform),
      folderNames: folderNames == _undefined || folderNames == null
          ? _instance.folderNames
          : (folderNames as List<String>),
      entryExtensions: entryExtensions == _undefined || entryExtensions == null
          ? _instance.entryExtensions
          : (entryExtensions as List<String>),
      companionExtensions:
          companionExtensions == _undefined || companionExtensions == null
          ? _instance.companionExtensions
          : (companionExtensions as List<String>),
      launcher: launcher == _undefined || launcher == null
          ? _instance.launcher
          : (launcher as Query$gamePlatforms$gamePlatforms$launcher),
      $__typename: $__typename == _undefined || $__typename == null
          ? _instance.$__typename
          : ($__typename as String),
    ),
  );

  CopyWith$Query$gamePlatforms$gamePlatforms$launcher<TRes> get launcher {
    final local$launcher = _instance.launcher;
    return CopyWith$Query$gamePlatforms$gamePlatforms$launcher(
      local$launcher,
      (e) => call(launcher: e),
    );
  }
}

class _CopyWithStubImpl$Query$gamePlatforms$gamePlatforms<TRes>
    implements CopyWith$Query$gamePlatforms$gamePlatforms<TRes> {
  _CopyWithStubImpl$Query$gamePlatforms$gamePlatforms(this._res);

  TRes _res;

  call({
    Enum$GamePlatform? platform,
    List<String>? folderNames,
    List<String>? entryExtensions,
    List<String>? companionExtensions,
    Query$gamePlatforms$gamePlatforms$launcher? launcher,
    String? $__typename,
  }) => _res;

  CopyWith$Query$gamePlatforms$gamePlatforms$launcher<TRes> get launcher =>
      CopyWith$Query$gamePlatforms$gamePlatforms$launcher.stub(_res);
}

class Query$gamePlatforms$gamePlatforms$launcher {
  Query$gamePlatforms$gamePlatforms$launcher({
    required this.kind,
    this.retroArchCore,
    this.$__typename = 'GameLauncherHint',
  });

  factory Query$gamePlatforms$gamePlatforms$launcher.fromJson(
    Map<String, dynamic> json,
  ) {
    final l$kind = json['kind'];
    final l$retroArchCore = json['retroArchCore'];
    final l$$__typename = json['__typename'];
    return Query$gamePlatforms$gamePlatforms$launcher(
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
    if (other is! Query$gamePlatforms$gamePlatforms$launcher ||
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

extension UtilityExtension$Query$gamePlatforms$gamePlatforms$launcher
    on Query$gamePlatforms$gamePlatforms$launcher {
  CopyWith$Query$gamePlatforms$gamePlatforms$launcher<
    Query$gamePlatforms$gamePlatforms$launcher
  >
  get copyWith =>
      CopyWith$Query$gamePlatforms$gamePlatforms$launcher(this, (i) => i);
}

abstract class CopyWith$Query$gamePlatforms$gamePlatforms$launcher<TRes> {
  factory CopyWith$Query$gamePlatforms$gamePlatforms$launcher(
    Query$gamePlatforms$gamePlatforms$launcher instance,
    TRes Function(Query$gamePlatforms$gamePlatforms$launcher) then,
  ) = _CopyWithImpl$Query$gamePlatforms$gamePlatforms$launcher;

  factory CopyWith$Query$gamePlatforms$gamePlatforms$launcher.stub(TRes res) =
      _CopyWithStubImpl$Query$gamePlatforms$gamePlatforms$launcher;

  TRes call({
    Enum$GameLauncherKind? kind,
    String? retroArchCore,
    String? $__typename,
  });
}

class _CopyWithImpl$Query$gamePlatforms$gamePlatforms$launcher<TRes>
    implements CopyWith$Query$gamePlatforms$gamePlatforms$launcher<TRes> {
  _CopyWithImpl$Query$gamePlatforms$gamePlatforms$launcher(
    this._instance,
    this._then,
  );

  final Query$gamePlatforms$gamePlatforms$launcher _instance;

  final TRes Function(Query$gamePlatforms$gamePlatforms$launcher) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? kind = _undefined,
    Object? retroArchCore = _undefined,
    Object? $__typename = _undefined,
  }) => _then(
    Query$gamePlatforms$gamePlatforms$launcher(
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

class _CopyWithStubImpl$Query$gamePlatforms$gamePlatforms$launcher<TRes>
    implements CopyWith$Query$gamePlatforms$gamePlatforms$launcher<TRes> {
  _CopyWithStubImpl$Query$gamePlatforms$gamePlatforms$launcher(this._res);

  TRes _res;

  call({
    Enum$GameLauncherKind? kind,
    String? retroArchCore,
    String? $__typename,
  }) => _res;
}

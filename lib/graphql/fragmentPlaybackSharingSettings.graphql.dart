import 'package:gql/ast.dart';
import 'schema.graphql.dart';

class Fragment$fragmentPlaybackSharingSettings {
  Fragment$fragmentPlaybackSharingSettings({
    required this.nowPlayingScope,
    required this.controlScope,
    required this.nowPlayingAllowedUserIds,
    required this.controlAllowedUserIds,
    this.$__typename = 'PlaybackSharingSettings',
  });

  factory Fragment$fragmentPlaybackSharingSettings.fromJson(
    Map<String, dynamic> json,
  ) {
    final l$nowPlayingScope = json['nowPlayingScope'];
    final l$controlScope = json['controlScope'];
    final l$nowPlayingAllowedUserIds = json['nowPlayingAllowedUserIds'];
    final l$controlAllowedUserIds = json['controlAllowedUserIds'];
    final l$$__typename = json['__typename'];
    return Fragment$fragmentPlaybackSharingSettings(
      nowPlayingScope: fromJson$Enum$SharingScope(
        (l$nowPlayingScope as String),
      ),
      controlScope: fromJson$Enum$RemoteControlScope(
        (l$controlScope as String),
      ),
      nowPlayingAllowedUserIds: (l$nowPlayingAllowedUserIds as List<dynamic>)
          .map((e) => (e as String))
          .toList(),
      controlAllowedUserIds: (l$controlAllowedUserIds as List<dynamic>)
          .map((e) => (e as String))
          .toList(),
      $__typename: (l$$__typename as String),
    );
  }

  final Enum$SharingScope nowPlayingScope;

  final Enum$RemoteControlScope controlScope;

  final List<String> nowPlayingAllowedUserIds;

  final List<String> controlAllowedUserIds;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$nowPlayingScope = nowPlayingScope;
    _resultData['nowPlayingScope'] = toJson$Enum$SharingScope(
      l$nowPlayingScope,
    );
    final l$controlScope = controlScope;
    _resultData['controlScope'] = toJson$Enum$RemoteControlScope(
      l$controlScope,
    );
    final l$nowPlayingAllowedUserIds = nowPlayingAllowedUserIds;
    _resultData['nowPlayingAllowedUserIds'] = l$nowPlayingAllowedUserIds
        .map((e) => e)
        .toList();
    final l$controlAllowedUserIds = controlAllowedUserIds;
    _resultData['controlAllowedUserIds'] = l$controlAllowedUserIds
        .map((e) => e)
        .toList();
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$nowPlayingScope = nowPlayingScope;
    final l$controlScope = controlScope;
    final l$nowPlayingAllowedUserIds = nowPlayingAllowedUserIds;
    final l$controlAllowedUserIds = controlAllowedUserIds;
    final l$$__typename = $__typename;
    return Object.hashAll([
      l$nowPlayingScope,
      l$controlScope,
      Object.hashAll(l$nowPlayingAllowedUserIds.map((v) => v)),
      Object.hashAll(l$controlAllowedUserIds.map((v) => v)),
      l$$__typename,
    ]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Fragment$fragmentPlaybackSharingSettings ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$nowPlayingScope = nowPlayingScope;
    final lOther$nowPlayingScope = other.nowPlayingScope;
    if (l$nowPlayingScope != lOther$nowPlayingScope) {
      return false;
    }
    final l$controlScope = controlScope;
    final lOther$controlScope = other.controlScope;
    if (l$controlScope != lOther$controlScope) {
      return false;
    }
    final l$nowPlayingAllowedUserIds = nowPlayingAllowedUserIds;
    final lOther$nowPlayingAllowedUserIds = other.nowPlayingAllowedUserIds;
    if (l$nowPlayingAllowedUserIds.length !=
        lOther$nowPlayingAllowedUserIds.length) {
      return false;
    }
    for (int i = 0; i < l$nowPlayingAllowedUserIds.length; i++) {
      final l$nowPlayingAllowedUserIds$entry = l$nowPlayingAllowedUserIds[i];
      final lOther$nowPlayingAllowedUserIds$entry =
          lOther$nowPlayingAllowedUserIds[i];
      if (l$nowPlayingAllowedUserIds$entry !=
          lOther$nowPlayingAllowedUserIds$entry) {
        return false;
      }
    }
    final l$controlAllowedUserIds = controlAllowedUserIds;
    final lOther$controlAllowedUserIds = other.controlAllowedUserIds;
    if (l$controlAllowedUserIds.length != lOther$controlAllowedUserIds.length) {
      return false;
    }
    for (int i = 0; i < l$controlAllowedUserIds.length; i++) {
      final l$controlAllowedUserIds$entry = l$controlAllowedUserIds[i];
      final lOther$controlAllowedUserIds$entry =
          lOther$controlAllowedUserIds[i];
      if (l$controlAllowedUserIds$entry != lOther$controlAllowedUserIds$entry) {
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

extension UtilityExtension$Fragment$fragmentPlaybackSharingSettings
    on Fragment$fragmentPlaybackSharingSettings {
  CopyWith$Fragment$fragmentPlaybackSharingSettings<
    Fragment$fragmentPlaybackSharingSettings
  >
  get copyWith =>
      CopyWith$Fragment$fragmentPlaybackSharingSettings(this, (i) => i);
}

abstract class CopyWith$Fragment$fragmentPlaybackSharingSettings<TRes> {
  factory CopyWith$Fragment$fragmentPlaybackSharingSettings(
    Fragment$fragmentPlaybackSharingSettings instance,
    TRes Function(Fragment$fragmentPlaybackSharingSettings) then,
  ) = _CopyWithImpl$Fragment$fragmentPlaybackSharingSettings;

  factory CopyWith$Fragment$fragmentPlaybackSharingSettings.stub(TRes res) =
      _CopyWithStubImpl$Fragment$fragmentPlaybackSharingSettings;

  TRes call({
    Enum$SharingScope? nowPlayingScope,
    Enum$RemoteControlScope? controlScope,
    List<String>? nowPlayingAllowedUserIds,
    List<String>? controlAllowedUserIds,
    String? $__typename,
  });
}

class _CopyWithImpl$Fragment$fragmentPlaybackSharingSettings<TRes>
    implements CopyWith$Fragment$fragmentPlaybackSharingSettings<TRes> {
  _CopyWithImpl$Fragment$fragmentPlaybackSharingSettings(
    this._instance,
    this._then,
  );

  final Fragment$fragmentPlaybackSharingSettings _instance;

  final TRes Function(Fragment$fragmentPlaybackSharingSettings) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? nowPlayingScope = _undefined,
    Object? controlScope = _undefined,
    Object? nowPlayingAllowedUserIds = _undefined,
    Object? controlAllowedUserIds = _undefined,
    Object? $__typename = _undefined,
  }) => _then(
    Fragment$fragmentPlaybackSharingSettings(
      nowPlayingScope: nowPlayingScope == _undefined || nowPlayingScope == null
          ? _instance.nowPlayingScope
          : (nowPlayingScope as Enum$SharingScope),
      controlScope: controlScope == _undefined || controlScope == null
          ? _instance.controlScope
          : (controlScope as Enum$RemoteControlScope),
      nowPlayingAllowedUserIds:
          nowPlayingAllowedUserIds == _undefined ||
              nowPlayingAllowedUserIds == null
          ? _instance.nowPlayingAllowedUserIds
          : (nowPlayingAllowedUserIds as List<String>),
      controlAllowedUserIds:
          controlAllowedUserIds == _undefined || controlAllowedUserIds == null
          ? _instance.controlAllowedUserIds
          : (controlAllowedUserIds as List<String>),
      $__typename: $__typename == _undefined || $__typename == null
          ? _instance.$__typename
          : ($__typename as String),
    ),
  );
}

class _CopyWithStubImpl$Fragment$fragmentPlaybackSharingSettings<TRes>
    implements CopyWith$Fragment$fragmentPlaybackSharingSettings<TRes> {
  _CopyWithStubImpl$Fragment$fragmentPlaybackSharingSettings(this._res);

  TRes _res;

  call({
    Enum$SharingScope? nowPlayingScope,
    Enum$RemoteControlScope? controlScope,
    List<String>? nowPlayingAllowedUserIds,
    List<String>? controlAllowedUserIds,
    String? $__typename,
  }) => _res;
}

const fragmentDefinitionfragmentPlaybackSharingSettings =
    FragmentDefinitionNode(
      name: NameNode(value: 'fragmentPlaybackSharingSettings'),
      typeCondition: TypeConditionNode(
        on: NamedTypeNode(
          name: NameNode(value: 'PlaybackSharingSettings'),
          isNonNull: false,
        ),
      ),
      directives: [],
      selectionSet: SelectionSetNode(
        selections: [
          FieldNode(
            name: NameNode(value: 'nowPlayingScope'),
            alias: null,
            arguments: [],
            directives: [],
            selectionSet: null,
          ),
          FieldNode(
            name: NameNode(value: 'controlScope'),
            alias: null,
            arguments: [],
            directives: [],
            selectionSet: null,
          ),
          FieldNode(
            name: NameNode(value: 'nowPlayingAllowedUserIds'),
            alias: null,
            arguments: [],
            directives: [],
            selectionSet: null,
          ),
          FieldNode(
            name: NameNode(value: 'controlAllowedUserIds'),
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
const documentNodeFragmentfragmentPlaybackSharingSettings = DocumentNode(
  definitions: [fragmentDefinitionfragmentPlaybackSharingSettings],
);

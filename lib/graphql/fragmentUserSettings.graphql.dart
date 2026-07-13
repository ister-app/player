import 'package:gql/ast.dart';

class Fragment$fragmentUserSettings {
  Fragment$fragmentUserSettings({
    required this.preferredAudioLanguages,
    required this.preferredSubtitleLanguages,
    required this.directPlay,
    required this.transcode,
    this.maxVideoHeight,
    this.$__typename = 'UserSettings',
  });

  factory Fragment$fragmentUserSettings.fromJson(Map<String, dynamic> json) {
    final l$preferredAudioLanguages = json['preferredAudioLanguages'];
    final l$preferredSubtitleLanguages = json['preferredSubtitleLanguages'];
    final l$directPlay = json['directPlay'];
    final l$transcode = json['transcode'];
    final l$maxVideoHeight = json['maxVideoHeight'];
    final l$$__typename = json['__typename'];
    return Fragment$fragmentUserSettings(
      preferredAudioLanguages: (l$preferredAudioLanguages as List<dynamic>)
          .map((e) => (e as String))
          .toList(),
      preferredSubtitleLanguages:
          (l$preferredSubtitleLanguages as List<dynamic>)
              .map((e) => (e as String))
              .toList(),
      directPlay: (l$directPlay as bool),
      transcode: (l$transcode as bool),
      maxVideoHeight: (l$maxVideoHeight as int?),
      $__typename: (l$$__typename as String),
    );
  }

  final List<String> preferredAudioLanguages;

  final List<String> preferredSubtitleLanguages;

  final bool directPlay;

  final bool transcode;

  final int? maxVideoHeight;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$preferredAudioLanguages = preferredAudioLanguages;
    _resultData['preferredAudioLanguages'] = l$preferredAudioLanguages
        .map((e) => e)
        .toList();
    final l$preferredSubtitleLanguages = preferredSubtitleLanguages;
    _resultData['preferredSubtitleLanguages'] = l$preferredSubtitleLanguages
        .map((e) => e)
        .toList();
    final l$directPlay = directPlay;
    _resultData['directPlay'] = l$directPlay;
    final l$transcode = transcode;
    _resultData['transcode'] = l$transcode;
    final l$maxVideoHeight = maxVideoHeight;
    _resultData['maxVideoHeight'] = l$maxVideoHeight;
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$preferredAudioLanguages = preferredAudioLanguages;
    final l$preferredSubtitleLanguages = preferredSubtitleLanguages;
    final l$directPlay = directPlay;
    final l$transcode = transcode;
    final l$maxVideoHeight = maxVideoHeight;
    final l$$__typename = $__typename;
    return Object.hashAll([
      Object.hashAll(l$preferredAudioLanguages.map((v) => v)),
      Object.hashAll(l$preferredSubtitleLanguages.map((v) => v)),
      l$directPlay,
      l$transcode,
      l$maxVideoHeight,
      l$$__typename,
    ]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Fragment$fragmentUserSettings ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$preferredAudioLanguages = preferredAudioLanguages;
    final lOther$preferredAudioLanguages = other.preferredAudioLanguages;
    if (l$preferredAudioLanguages.length !=
        lOther$preferredAudioLanguages.length) {
      return false;
    }
    for (int i = 0; i < l$preferredAudioLanguages.length; i++) {
      final l$preferredAudioLanguages$entry = l$preferredAudioLanguages[i];
      final lOther$preferredAudioLanguages$entry =
          lOther$preferredAudioLanguages[i];
      if (l$preferredAudioLanguages$entry !=
          lOther$preferredAudioLanguages$entry) {
        return false;
      }
    }
    final l$preferredSubtitleLanguages = preferredSubtitleLanguages;
    final lOther$preferredSubtitleLanguages = other.preferredSubtitleLanguages;
    if (l$preferredSubtitleLanguages.length !=
        lOther$preferredSubtitleLanguages.length) {
      return false;
    }
    for (int i = 0; i < l$preferredSubtitleLanguages.length; i++) {
      final l$preferredSubtitleLanguages$entry =
          l$preferredSubtitleLanguages[i];
      final lOther$preferredSubtitleLanguages$entry =
          lOther$preferredSubtitleLanguages[i];
      if (l$preferredSubtitleLanguages$entry !=
          lOther$preferredSubtitleLanguages$entry) {
        return false;
      }
    }
    final l$directPlay = directPlay;
    final lOther$directPlay = other.directPlay;
    if (l$directPlay != lOther$directPlay) {
      return false;
    }
    final l$transcode = transcode;
    final lOther$transcode = other.transcode;
    if (l$transcode != lOther$transcode) {
      return false;
    }
    final l$maxVideoHeight = maxVideoHeight;
    final lOther$maxVideoHeight = other.maxVideoHeight;
    if (l$maxVideoHeight != lOther$maxVideoHeight) {
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

extension UtilityExtension$Fragment$fragmentUserSettings
    on Fragment$fragmentUserSettings {
  CopyWith$Fragment$fragmentUserSettings<Fragment$fragmentUserSettings>
  get copyWith => CopyWith$Fragment$fragmentUserSettings(this, (i) => i);
}

abstract class CopyWith$Fragment$fragmentUserSettings<TRes> {
  factory CopyWith$Fragment$fragmentUserSettings(
    Fragment$fragmentUserSettings instance,
    TRes Function(Fragment$fragmentUserSettings) then,
  ) = _CopyWithImpl$Fragment$fragmentUserSettings;

  factory CopyWith$Fragment$fragmentUserSettings.stub(TRes res) =
      _CopyWithStubImpl$Fragment$fragmentUserSettings;

  TRes call({
    List<String>? preferredAudioLanguages,
    List<String>? preferredSubtitleLanguages,
    bool? directPlay,
    bool? transcode,
    int? maxVideoHeight,
    String? $__typename,
  });
}

class _CopyWithImpl$Fragment$fragmentUserSettings<TRes>
    implements CopyWith$Fragment$fragmentUserSettings<TRes> {
  _CopyWithImpl$Fragment$fragmentUserSettings(this._instance, this._then);

  final Fragment$fragmentUserSettings _instance;

  final TRes Function(Fragment$fragmentUserSettings) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? preferredAudioLanguages = _undefined,
    Object? preferredSubtitleLanguages = _undefined,
    Object? directPlay = _undefined,
    Object? transcode = _undefined,
    Object? maxVideoHeight = _undefined,
    Object? $__typename = _undefined,
  }) => _then(
    Fragment$fragmentUserSettings(
      preferredAudioLanguages:
          preferredAudioLanguages == _undefined ||
              preferredAudioLanguages == null
          ? _instance.preferredAudioLanguages
          : (preferredAudioLanguages as List<String>),
      preferredSubtitleLanguages:
          preferredSubtitleLanguages == _undefined ||
              preferredSubtitleLanguages == null
          ? _instance.preferredSubtitleLanguages
          : (preferredSubtitleLanguages as List<String>),
      directPlay: directPlay == _undefined || directPlay == null
          ? _instance.directPlay
          : (directPlay as bool),
      transcode: transcode == _undefined || transcode == null
          ? _instance.transcode
          : (transcode as bool),
      maxVideoHeight: maxVideoHeight == _undefined
          ? _instance.maxVideoHeight
          : (maxVideoHeight as int?),
      $__typename: $__typename == _undefined || $__typename == null
          ? _instance.$__typename
          : ($__typename as String),
    ),
  );
}

class _CopyWithStubImpl$Fragment$fragmentUserSettings<TRes>
    implements CopyWith$Fragment$fragmentUserSettings<TRes> {
  _CopyWithStubImpl$Fragment$fragmentUserSettings(this._res);

  TRes _res;

  call({
    List<String>? preferredAudioLanguages,
    List<String>? preferredSubtitleLanguages,
    bool? directPlay,
    bool? transcode,
    int? maxVideoHeight,
    String? $__typename,
  }) => _res;
}

const fragmentDefinitionfragmentUserSettings = FragmentDefinitionNode(
  name: NameNode(value: 'fragmentUserSettings'),
  typeCondition: TypeConditionNode(
    on: NamedTypeNode(name: NameNode(value: 'UserSettings'), isNonNull: false),
  ),
  directives: [],
  selectionSet: SelectionSetNode(
    selections: [
      FieldNode(
        name: NameNode(value: 'preferredAudioLanguages'),
        alias: null,
        arguments: [],
        directives: [],
        selectionSet: null,
      ),
      FieldNode(
        name: NameNode(value: 'preferredSubtitleLanguages'),
        alias: null,
        arguments: [],
        directives: [],
        selectionSet: null,
      ),
      FieldNode(
        name: NameNode(value: 'directPlay'),
        alias: null,
        arguments: [],
        directives: [],
        selectionSet: null,
      ),
      FieldNode(
        name: NameNode(value: 'transcode'),
        alias: null,
        arguments: [],
        directives: [],
        selectionSet: null,
      ),
      FieldNode(
        name: NameNode(value: 'maxVideoHeight'),
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
const documentNodeFragmentfragmentUserSettings = DocumentNode(
  definitions: [fragmentDefinitionfragmentUserSettings],
);

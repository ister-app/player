import 'fragmentPlaybackSharingSettings.graphql.dart';
import 'package:gql/ast.dart';

class Query$playbackSharingSettings {
  Query$playbackSharingSettings({
    required this.playbackSharingSettings,
    this.$__typename = 'Query',
  });

  factory Query$playbackSharingSettings.fromJson(Map<String, dynamic> json) {
    final l$playbackSharingSettings = json['playbackSharingSettings'];
    final l$$__typename = json['__typename'];
    return Query$playbackSharingSettings(
      playbackSharingSettings:
          Fragment$fragmentPlaybackSharingSettings.fromJson(
            (l$playbackSharingSettings as Map<String, dynamic>),
          ),
      $__typename: (l$$__typename as String),
    );
  }

  final Fragment$fragmentPlaybackSharingSettings playbackSharingSettings;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$playbackSharingSettings = playbackSharingSettings;
    _resultData['playbackSharingSettings'] = l$playbackSharingSettings.toJson();
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$playbackSharingSettings = playbackSharingSettings;
    final l$$__typename = $__typename;
    return Object.hashAll([l$playbackSharingSettings, l$$__typename]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Query$playbackSharingSettings ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$playbackSharingSettings = playbackSharingSettings;
    final lOther$playbackSharingSettings = other.playbackSharingSettings;
    if (l$playbackSharingSettings != lOther$playbackSharingSettings) {
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

extension UtilityExtension$Query$playbackSharingSettings
    on Query$playbackSharingSettings {
  CopyWith$Query$playbackSharingSettings<Query$playbackSharingSettings>
  get copyWith => CopyWith$Query$playbackSharingSettings(this, (i) => i);
}

abstract class CopyWith$Query$playbackSharingSettings<TRes> {
  factory CopyWith$Query$playbackSharingSettings(
    Query$playbackSharingSettings instance,
    TRes Function(Query$playbackSharingSettings) then,
  ) = _CopyWithImpl$Query$playbackSharingSettings;

  factory CopyWith$Query$playbackSharingSettings.stub(TRes res) =
      _CopyWithStubImpl$Query$playbackSharingSettings;

  TRes call({
    Fragment$fragmentPlaybackSharingSettings? playbackSharingSettings,
    String? $__typename,
  });
  CopyWith$Fragment$fragmentPlaybackSharingSettings<TRes>
  get playbackSharingSettings;
}

class _CopyWithImpl$Query$playbackSharingSettings<TRes>
    implements CopyWith$Query$playbackSharingSettings<TRes> {
  _CopyWithImpl$Query$playbackSharingSettings(this._instance, this._then);

  final Query$playbackSharingSettings _instance;

  final TRes Function(Query$playbackSharingSettings) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? playbackSharingSettings = _undefined,
    Object? $__typename = _undefined,
  }) => _then(
    Query$playbackSharingSettings(
      playbackSharingSettings:
          playbackSharingSettings == _undefined ||
              playbackSharingSettings == null
          ? _instance.playbackSharingSettings
          : (playbackSharingSettings
                as Fragment$fragmentPlaybackSharingSettings),
      $__typename: $__typename == _undefined || $__typename == null
          ? _instance.$__typename
          : ($__typename as String),
    ),
  );

  CopyWith$Fragment$fragmentPlaybackSharingSettings<TRes>
  get playbackSharingSettings {
    final local$playbackSharingSettings = _instance.playbackSharingSettings;
    return CopyWith$Fragment$fragmentPlaybackSharingSettings(
      local$playbackSharingSettings,
      (e) => call(playbackSharingSettings: e),
    );
  }
}

class _CopyWithStubImpl$Query$playbackSharingSettings<TRes>
    implements CopyWith$Query$playbackSharingSettings<TRes> {
  _CopyWithStubImpl$Query$playbackSharingSettings(this._res);

  TRes _res;

  call({
    Fragment$fragmentPlaybackSharingSettings? playbackSharingSettings,
    String? $__typename,
  }) => _res;

  CopyWith$Fragment$fragmentPlaybackSharingSettings<TRes>
  get playbackSharingSettings =>
      CopyWith$Fragment$fragmentPlaybackSharingSettings.stub(_res);
}

const documentNodeQueryplaybackSharingSettings = DocumentNode(
  definitions: [
    OperationDefinitionNode(
      type: OperationType.query,
      name: NameNode(value: 'playbackSharingSettings'),
      variableDefinitions: [],
      directives: [],
      selectionSet: SelectionSetNode(
        selections: [
          FieldNode(
            name: NameNode(value: 'playbackSharingSettings'),
            alias: null,
            arguments: [],
            directives: [],
            selectionSet: SelectionSetNode(
              selections: [
                FragmentSpreadNode(
                  name: NameNode(value: 'fragmentPlaybackSharingSettings'),
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
    fragmentDefinitionfragmentPlaybackSharingSettings,
  ],
);

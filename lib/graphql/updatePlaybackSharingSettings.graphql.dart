import 'fragmentPlaybackSharingSettings.graphql.dart';
import 'package:gql/ast.dart';
import 'schema.graphql.dart';

class Variables$Mutation$updatePlaybackSharingSettings {
  factory Variables$Mutation$updatePlaybackSharingSettings({
    required Input$PlaybackSharingSettingsInput input,
  }) => Variables$Mutation$updatePlaybackSharingSettings._({r'input': input});

  Variables$Mutation$updatePlaybackSharingSettings._(this._$data);

  factory Variables$Mutation$updatePlaybackSharingSettings.fromJson(
    Map<String, dynamic> data,
  ) {
    final result$data = <String, dynamic>{};
    final l$input = data['input'];
    result$data['input'] = Input$PlaybackSharingSettingsInput.fromJson(
      (l$input as Map<String, dynamic>),
    );
    return Variables$Mutation$updatePlaybackSharingSettings._(result$data);
  }

  Map<String, dynamic> _$data;

  Input$PlaybackSharingSettingsInput get input =>
      (_$data['input'] as Input$PlaybackSharingSettingsInput);

  Map<String, dynamic> toJson() {
    final result$data = <String, dynamic>{};
    final l$input = input;
    result$data['input'] = l$input.toJson();
    return result$data;
  }

  CopyWith$Variables$Mutation$updatePlaybackSharingSettings<
    Variables$Mutation$updatePlaybackSharingSettings
  >
  get copyWith =>
      CopyWith$Variables$Mutation$updatePlaybackSharingSettings(this, (i) => i);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Variables$Mutation$updatePlaybackSharingSettings ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$input = input;
    final lOther$input = other.input;
    if (l$input != lOther$input) {
      return false;
    }
    return true;
  }

  @override
  int get hashCode {
    final l$input = input;
    return Object.hashAll([l$input]);
  }
}

abstract class CopyWith$Variables$Mutation$updatePlaybackSharingSettings<TRes> {
  factory CopyWith$Variables$Mutation$updatePlaybackSharingSettings(
    Variables$Mutation$updatePlaybackSharingSettings instance,
    TRes Function(Variables$Mutation$updatePlaybackSharingSettings) then,
  ) = _CopyWithImpl$Variables$Mutation$updatePlaybackSharingSettings;

  factory CopyWith$Variables$Mutation$updatePlaybackSharingSettings.stub(
    TRes res,
  ) = _CopyWithStubImpl$Variables$Mutation$updatePlaybackSharingSettings;

  TRes call({Input$PlaybackSharingSettingsInput? input});
}

class _CopyWithImpl$Variables$Mutation$updatePlaybackSharingSettings<TRes>
    implements CopyWith$Variables$Mutation$updatePlaybackSharingSettings<TRes> {
  _CopyWithImpl$Variables$Mutation$updatePlaybackSharingSettings(
    this._instance,
    this._then,
  );

  final Variables$Mutation$updatePlaybackSharingSettings _instance;

  final TRes Function(Variables$Mutation$updatePlaybackSharingSettings) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({Object? input = _undefined}) => _then(
    Variables$Mutation$updatePlaybackSharingSettings._({
      ..._instance._$data,
      if (input != _undefined && input != null)
        'input': (input as Input$PlaybackSharingSettingsInput),
    }),
  );
}

class _CopyWithStubImpl$Variables$Mutation$updatePlaybackSharingSettings<TRes>
    implements CopyWith$Variables$Mutation$updatePlaybackSharingSettings<TRes> {
  _CopyWithStubImpl$Variables$Mutation$updatePlaybackSharingSettings(this._res);

  TRes _res;

  call({Input$PlaybackSharingSettingsInput? input}) => _res;
}

class Mutation$updatePlaybackSharingSettings {
  Mutation$updatePlaybackSharingSettings({
    required this.updatePlaybackSharingSettings,
    this.$__typename = 'Mutation',
  });

  factory Mutation$updatePlaybackSharingSettings.fromJson(
    Map<String, dynamic> json,
  ) {
    final l$updatePlaybackSharingSettings =
        json['updatePlaybackSharingSettings'];
    final l$$__typename = json['__typename'];
    return Mutation$updatePlaybackSharingSettings(
      updatePlaybackSharingSettings:
          Fragment$fragmentPlaybackSharingSettings.fromJson(
            (l$updatePlaybackSharingSettings as Map<String, dynamic>),
          ),
      $__typename: (l$$__typename as String),
    );
  }

  final Fragment$fragmentPlaybackSharingSettings updatePlaybackSharingSettings;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$updatePlaybackSharingSettings = updatePlaybackSharingSettings;
    _resultData['updatePlaybackSharingSettings'] =
        l$updatePlaybackSharingSettings.toJson();
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$updatePlaybackSharingSettings = updatePlaybackSharingSettings;
    final l$$__typename = $__typename;
    return Object.hashAll([l$updatePlaybackSharingSettings, l$$__typename]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Mutation$updatePlaybackSharingSettings ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$updatePlaybackSharingSettings = updatePlaybackSharingSettings;
    final lOther$updatePlaybackSharingSettings =
        other.updatePlaybackSharingSettings;
    if (l$updatePlaybackSharingSettings !=
        lOther$updatePlaybackSharingSettings) {
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

extension UtilityExtension$Mutation$updatePlaybackSharingSettings
    on Mutation$updatePlaybackSharingSettings {
  CopyWith$Mutation$updatePlaybackSharingSettings<
    Mutation$updatePlaybackSharingSettings
  >
  get copyWith =>
      CopyWith$Mutation$updatePlaybackSharingSettings(this, (i) => i);
}

abstract class CopyWith$Mutation$updatePlaybackSharingSettings<TRes> {
  factory CopyWith$Mutation$updatePlaybackSharingSettings(
    Mutation$updatePlaybackSharingSettings instance,
    TRes Function(Mutation$updatePlaybackSharingSettings) then,
  ) = _CopyWithImpl$Mutation$updatePlaybackSharingSettings;

  factory CopyWith$Mutation$updatePlaybackSharingSettings.stub(TRes res) =
      _CopyWithStubImpl$Mutation$updatePlaybackSharingSettings;

  TRes call({
    Fragment$fragmentPlaybackSharingSettings? updatePlaybackSharingSettings,
    String? $__typename,
  });
  CopyWith$Fragment$fragmentPlaybackSharingSettings<TRes>
  get updatePlaybackSharingSettings;
}

class _CopyWithImpl$Mutation$updatePlaybackSharingSettings<TRes>
    implements CopyWith$Mutation$updatePlaybackSharingSettings<TRes> {
  _CopyWithImpl$Mutation$updatePlaybackSharingSettings(
    this._instance,
    this._then,
  );

  final Mutation$updatePlaybackSharingSettings _instance;

  final TRes Function(Mutation$updatePlaybackSharingSettings) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? updatePlaybackSharingSettings = _undefined,
    Object? $__typename = _undefined,
  }) => _then(
    Mutation$updatePlaybackSharingSettings(
      updatePlaybackSharingSettings:
          updatePlaybackSharingSettings == _undefined ||
              updatePlaybackSharingSettings == null
          ? _instance.updatePlaybackSharingSettings
          : (updatePlaybackSharingSettings
                as Fragment$fragmentPlaybackSharingSettings),
      $__typename: $__typename == _undefined || $__typename == null
          ? _instance.$__typename
          : ($__typename as String),
    ),
  );

  CopyWith$Fragment$fragmentPlaybackSharingSettings<TRes>
  get updatePlaybackSharingSettings {
    final local$updatePlaybackSharingSettings =
        _instance.updatePlaybackSharingSettings;
    return CopyWith$Fragment$fragmentPlaybackSharingSettings(
      local$updatePlaybackSharingSettings,
      (e) => call(updatePlaybackSharingSettings: e),
    );
  }
}

class _CopyWithStubImpl$Mutation$updatePlaybackSharingSettings<TRes>
    implements CopyWith$Mutation$updatePlaybackSharingSettings<TRes> {
  _CopyWithStubImpl$Mutation$updatePlaybackSharingSettings(this._res);

  TRes _res;

  call({
    Fragment$fragmentPlaybackSharingSettings? updatePlaybackSharingSettings,
    String? $__typename,
  }) => _res;

  CopyWith$Fragment$fragmentPlaybackSharingSettings<TRes>
  get updatePlaybackSharingSettings =>
      CopyWith$Fragment$fragmentPlaybackSharingSettings.stub(_res);
}

const documentNodeMutationupdatePlaybackSharingSettings = DocumentNode(
  definitions: [
    OperationDefinitionNode(
      type: OperationType.mutation,
      name: NameNode(value: 'updatePlaybackSharingSettings'),
      variableDefinitions: [
        VariableDefinitionNode(
          variable: VariableNode(name: NameNode(value: 'input')),
          type: NamedTypeNode(
            name: NameNode(value: 'PlaybackSharingSettingsInput'),
            isNonNull: true,
          ),
          defaultValue: DefaultValueNode(value: null),
          directives: [],
        ),
      ],
      directives: [],
      selectionSet: SelectionSetNode(
        selections: [
          FieldNode(
            name: NameNode(value: 'updatePlaybackSharingSettings'),
            alias: null,
            arguments: [
              ArgumentNode(
                name: NameNode(value: 'input'),
                value: VariableNode(name: NameNode(value: 'input')),
              ),
            ],
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

import 'fragmentUserSettings.graphql.dart';
import 'package:gql/ast.dart';
import 'schema.graphql.dart';

class Variables$Mutation$updateUserSettings {
  factory Variables$Mutation$updateUserSettings({
    required Input$UserSettingsInput input,
  }) => Variables$Mutation$updateUserSettings._({r'input': input});

  Variables$Mutation$updateUserSettings._(this._$data);

  factory Variables$Mutation$updateUserSettings.fromJson(
    Map<String, dynamic> data,
  ) {
    final result$data = <String, dynamic>{};
    final l$input = data['input'];
    result$data['input'] = Input$UserSettingsInput.fromJson(
      (l$input as Map<String, dynamic>),
    );
    return Variables$Mutation$updateUserSettings._(result$data);
  }

  Map<String, dynamic> _$data;

  Input$UserSettingsInput get input =>
      (_$data['input'] as Input$UserSettingsInput);

  Map<String, dynamic> toJson() {
    final result$data = <String, dynamic>{};
    final l$input = input;
    result$data['input'] = l$input.toJson();
    return result$data;
  }

  CopyWith$Variables$Mutation$updateUserSettings<
    Variables$Mutation$updateUserSettings
  >
  get copyWith =>
      CopyWith$Variables$Mutation$updateUserSettings(this, (i) => i);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Variables$Mutation$updateUserSettings ||
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

abstract class CopyWith$Variables$Mutation$updateUserSettings<TRes> {
  factory CopyWith$Variables$Mutation$updateUserSettings(
    Variables$Mutation$updateUserSettings instance,
    TRes Function(Variables$Mutation$updateUserSettings) then,
  ) = _CopyWithImpl$Variables$Mutation$updateUserSettings;

  factory CopyWith$Variables$Mutation$updateUserSettings.stub(TRes res) =
      _CopyWithStubImpl$Variables$Mutation$updateUserSettings;

  TRes call({Input$UserSettingsInput? input});
}

class _CopyWithImpl$Variables$Mutation$updateUserSettings<TRes>
    implements CopyWith$Variables$Mutation$updateUserSettings<TRes> {
  _CopyWithImpl$Variables$Mutation$updateUserSettings(
    this._instance,
    this._then,
  );

  final Variables$Mutation$updateUserSettings _instance;

  final TRes Function(Variables$Mutation$updateUserSettings) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({Object? input = _undefined}) => _then(
    Variables$Mutation$updateUserSettings._({
      ..._instance._$data,
      if (input != _undefined && input != null)
        'input': (input as Input$UserSettingsInput),
    }),
  );
}

class _CopyWithStubImpl$Variables$Mutation$updateUserSettings<TRes>
    implements CopyWith$Variables$Mutation$updateUserSettings<TRes> {
  _CopyWithStubImpl$Variables$Mutation$updateUserSettings(this._res);

  TRes _res;

  call({Input$UserSettingsInput? input}) => _res;
}

class Mutation$updateUserSettings {
  Mutation$updateUserSettings({
    required this.updateUserSettings,
    this.$__typename = 'Mutation',
  });

  factory Mutation$updateUserSettings.fromJson(Map<String, dynamic> json) {
    final l$updateUserSettings = json['updateUserSettings'];
    final l$$__typename = json['__typename'];
    return Mutation$updateUserSettings(
      updateUserSettings: Fragment$fragmentUserSettings.fromJson(
        (l$updateUserSettings as Map<String, dynamic>),
      ),
      $__typename: (l$$__typename as String),
    );
  }

  final Fragment$fragmentUserSettings updateUserSettings;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$updateUserSettings = updateUserSettings;
    _resultData['updateUserSettings'] = l$updateUserSettings.toJson();
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$updateUserSettings = updateUserSettings;
    final l$$__typename = $__typename;
    return Object.hashAll([l$updateUserSettings, l$$__typename]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Mutation$updateUserSettings ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$updateUserSettings = updateUserSettings;
    final lOther$updateUserSettings = other.updateUserSettings;
    if (l$updateUserSettings != lOther$updateUserSettings) {
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

extension UtilityExtension$Mutation$updateUserSettings
    on Mutation$updateUserSettings {
  CopyWith$Mutation$updateUserSettings<Mutation$updateUserSettings>
  get copyWith => CopyWith$Mutation$updateUserSettings(this, (i) => i);
}

abstract class CopyWith$Mutation$updateUserSettings<TRes> {
  factory CopyWith$Mutation$updateUserSettings(
    Mutation$updateUserSettings instance,
    TRes Function(Mutation$updateUserSettings) then,
  ) = _CopyWithImpl$Mutation$updateUserSettings;

  factory CopyWith$Mutation$updateUserSettings.stub(TRes res) =
      _CopyWithStubImpl$Mutation$updateUserSettings;

  TRes call({
    Fragment$fragmentUserSettings? updateUserSettings,
    String? $__typename,
  });
  CopyWith$Fragment$fragmentUserSettings<TRes> get updateUserSettings;
}

class _CopyWithImpl$Mutation$updateUserSettings<TRes>
    implements CopyWith$Mutation$updateUserSettings<TRes> {
  _CopyWithImpl$Mutation$updateUserSettings(this._instance, this._then);

  final Mutation$updateUserSettings _instance;

  final TRes Function(Mutation$updateUserSettings) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? updateUserSettings = _undefined,
    Object? $__typename = _undefined,
  }) => _then(
    Mutation$updateUserSettings(
      updateUserSettings:
          updateUserSettings == _undefined || updateUserSettings == null
          ? _instance.updateUserSettings
          : (updateUserSettings as Fragment$fragmentUserSettings),
      $__typename: $__typename == _undefined || $__typename == null
          ? _instance.$__typename
          : ($__typename as String),
    ),
  );

  CopyWith$Fragment$fragmentUserSettings<TRes> get updateUserSettings {
    final local$updateUserSettings = _instance.updateUserSettings;
    return CopyWith$Fragment$fragmentUserSettings(
      local$updateUserSettings,
      (e) => call(updateUserSettings: e),
    );
  }
}

class _CopyWithStubImpl$Mutation$updateUserSettings<TRes>
    implements CopyWith$Mutation$updateUserSettings<TRes> {
  _CopyWithStubImpl$Mutation$updateUserSettings(this._res);

  TRes _res;

  call({
    Fragment$fragmentUserSettings? updateUserSettings,
    String? $__typename,
  }) => _res;

  CopyWith$Fragment$fragmentUserSettings<TRes> get updateUserSettings =>
      CopyWith$Fragment$fragmentUserSettings.stub(_res);
}

const documentNodeMutationupdateUserSettings = DocumentNode(
  definitions: [
    OperationDefinitionNode(
      type: OperationType.mutation,
      name: NameNode(value: 'updateUserSettings'),
      variableDefinitions: [
        VariableDefinitionNode(
          variable: VariableNode(name: NameNode(value: 'input')),
          type: NamedTypeNode(
            name: NameNode(value: 'UserSettingsInput'),
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
            name: NameNode(value: 'updateUserSettings'),
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
                  name: NameNode(value: 'fragmentUserSettings'),
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
    fragmentDefinitionfragmentUserSettings,
  ],
);

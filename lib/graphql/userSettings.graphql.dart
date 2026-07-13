import 'fragmentUserSettings.graphql.dart';
import 'package:gql/ast.dart';

class Query$userSettings {
  Query$userSettings({required this.userSettings, this.$__typename = 'Query'});

  factory Query$userSettings.fromJson(Map<String, dynamic> json) {
    final l$userSettings = json['userSettings'];
    final l$$__typename = json['__typename'];
    return Query$userSettings(
      userSettings: Fragment$fragmentUserSettings.fromJson(
        (l$userSettings as Map<String, dynamic>),
      ),
      $__typename: (l$$__typename as String),
    );
  }

  final Fragment$fragmentUserSettings userSettings;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$userSettings = userSettings;
    _resultData['userSettings'] = l$userSettings.toJson();
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$userSettings = userSettings;
    final l$$__typename = $__typename;
    return Object.hashAll([l$userSettings, l$$__typename]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Query$userSettings || runtimeType != other.runtimeType) {
      return false;
    }
    final l$userSettings = userSettings;
    final lOther$userSettings = other.userSettings;
    if (l$userSettings != lOther$userSettings) {
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

extension UtilityExtension$Query$userSettings on Query$userSettings {
  CopyWith$Query$userSettings<Query$userSettings> get copyWith =>
      CopyWith$Query$userSettings(this, (i) => i);
}

abstract class CopyWith$Query$userSettings<TRes> {
  factory CopyWith$Query$userSettings(
    Query$userSettings instance,
    TRes Function(Query$userSettings) then,
  ) = _CopyWithImpl$Query$userSettings;

  factory CopyWith$Query$userSettings.stub(TRes res) =
      _CopyWithStubImpl$Query$userSettings;

  TRes call({Fragment$fragmentUserSettings? userSettings, String? $__typename});
  CopyWith$Fragment$fragmentUserSettings<TRes> get userSettings;
}

class _CopyWithImpl$Query$userSettings<TRes>
    implements CopyWith$Query$userSettings<TRes> {
  _CopyWithImpl$Query$userSettings(this._instance, this._then);

  final Query$userSettings _instance;

  final TRes Function(Query$userSettings) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? userSettings = _undefined,
    Object? $__typename = _undefined,
  }) => _then(
    Query$userSettings(
      userSettings: userSettings == _undefined || userSettings == null
          ? _instance.userSettings
          : (userSettings as Fragment$fragmentUserSettings),
      $__typename: $__typename == _undefined || $__typename == null
          ? _instance.$__typename
          : ($__typename as String),
    ),
  );

  CopyWith$Fragment$fragmentUserSettings<TRes> get userSettings {
    final local$userSettings = _instance.userSettings;
    return CopyWith$Fragment$fragmentUserSettings(
      local$userSettings,
      (e) => call(userSettings: e),
    );
  }
}

class _CopyWithStubImpl$Query$userSettings<TRes>
    implements CopyWith$Query$userSettings<TRes> {
  _CopyWithStubImpl$Query$userSettings(this._res);

  TRes _res;

  call({Fragment$fragmentUserSettings? userSettings, String? $__typename}) =>
      _res;

  CopyWith$Fragment$fragmentUserSettings<TRes> get userSettings =>
      CopyWith$Fragment$fragmentUserSettings.stub(_res);
}

const documentNodeQueryuserSettings = DocumentNode(
  definitions: [
    OperationDefinitionNode(
      type: OperationType.query,
      name: NameNode(value: 'userSettings'),
      variableDefinitions: [],
      directives: [],
      selectionSet: SelectionSetNode(
        selections: [
          FieldNode(
            name: NameNode(value: 'userSettings'),
            alias: null,
            arguments: [],
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

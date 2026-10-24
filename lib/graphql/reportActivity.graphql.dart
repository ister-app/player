import 'package:gql/ast.dart';

import 'schema.graphql.dart';

class Variables$Mutation$reportActivity {
  factory Variables$Mutation$reportActivity({
    required String sessionId,
    required Enum$MediaType mediaType,
    required String mediaId,
    String? mediaFileId,
    double? progressFraction,
    String? progressLabel,
    required Enum$PlayState playState,
    required String deviceId,
  }) => Variables$Mutation$reportActivity._({
    r'sessionId': sessionId,
    r'mediaType': mediaType,
    r'mediaId': mediaId,
    if (mediaFileId != null) r'mediaFileId': mediaFileId,
    if (progressFraction != null) r'progressFraction': progressFraction,
    if (progressLabel != null) r'progressLabel': progressLabel,
    r'playState': playState,
    r'deviceId': deviceId,
  });

  Variables$Mutation$reportActivity._(this._$data);

  factory Variables$Mutation$reportActivity.fromJson(
    Map<String, dynamic> data,
  ) {
    final result$data = <String, dynamic>{};
    final l$sessionId = data['sessionId'];
    result$data['sessionId'] = (l$sessionId as String);
    final l$mediaType = data['mediaType'];
    result$data['mediaType'] = fromJson$Enum$MediaType((l$mediaType as String));
    final l$mediaId = data['mediaId'];
    result$data['mediaId'] = (l$mediaId as String);
    if (data.containsKey('mediaFileId')) {
      final l$mediaFileId = data['mediaFileId'];
      result$data['mediaFileId'] = (l$mediaFileId as String?);
    }
    if (data.containsKey('progressFraction')) {
      final l$progressFraction = data['progressFraction'];
      result$data['progressFraction'] = (l$progressFraction as num?)
          ?.toDouble();
    }
    if (data.containsKey('progressLabel')) {
      final l$progressLabel = data['progressLabel'];
      result$data['progressLabel'] = (l$progressLabel as String?);
    }
    final l$playState = data['playState'];
    result$data['playState'] = fromJson$Enum$PlayState((l$playState as String));
    final l$deviceId = data['deviceId'];
    result$data['deviceId'] = (l$deviceId as String);
    return Variables$Mutation$reportActivity._(result$data);
  }

  Map<String, dynamic> _$data;

  String get sessionId => (_$data['sessionId'] as String);

  Enum$MediaType get mediaType => (_$data['mediaType'] as Enum$MediaType);

  String get mediaId => (_$data['mediaId'] as String);

  String? get mediaFileId => (_$data['mediaFileId'] as String?);

  double? get progressFraction => (_$data['progressFraction'] as double?);

  String? get progressLabel => (_$data['progressLabel'] as String?);

  Enum$PlayState get playState => (_$data['playState'] as Enum$PlayState);

  String get deviceId => (_$data['deviceId'] as String);

  Map<String, dynamic> toJson() {
    final result$data = <String, dynamic>{};
    final l$sessionId = sessionId;
    result$data['sessionId'] = l$sessionId;
    final l$mediaType = mediaType;
    result$data['mediaType'] = toJson$Enum$MediaType(l$mediaType);
    final l$mediaId = mediaId;
    result$data['mediaId'] = l$mediaId;
    if (_$data.containsKey('mediaFileId')) {
      final l$mediaFileId = mediaFileId;
      result$data['mediaFileId'] = l$mediaFileId;
    }
    if (_$data.containsKey('progressFraction')) {
      final l$progressFraction = progressFraction;
      result$data['progressFraction'] = l$progressFraction;
    }
    if (_$data.containsKey('progressLabel')) {
      final l$progressLabel = progressLabel;
      result$data['progressLabel'] = l$progressLabel;
    }
    final l$playState = playState;
    result$data['playState'] = toJson$Enum$PlayState(l$playState);
    final l$deviceId = deviceId;
    result$data['deviceId'] = l$deviceId;
    return result$data;
  }

  CopyWith$Variables$Mutation$reportActivity<Variables$Mutation$reportActivity>
  get copyWith => CopyWith$Variables$Mutation$reportActivity(this, (i) => i);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Variables$Mutation$reportActivity ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$sessionId = sessionId;
    final lOther$sessionId = other.sessionId;
    if (l$sessionId != lOther$sessionId) {
      return false;
    }
    final l$mediaType = mediaType;
    final lOther$mediaType = other.mediaType;
    if (l$mediaType != lOther$mediaType) {
      return false;
    }
    final l$mediaId = mediaId;
    final lOther$mediaId = other.mediaId;
    if (l$mediaId != lOther$mediaId) {
      return false;
    }
    final l$mediaFileId = mediaFileId;
    final lOther$mediaFileId = other.mediaFileId;
    if (_$data.containsKey('mediaFileId') !=
        other._$data.containsKey('mediaFileId')) {
      return false;
    }
    if (l$mediaFileId != lOther$mediaFileId) {
      return false;
    }
    final l$progressFraction = progressFraction;
    final lOther$progressFraction = other.progressFraction;
    if (_$data.containsKey('progressFraction') !=
        other._$data.containsKey('progressFraction')) {
      return false;
    }
    if (l$progressFraction != lOther$progressFraction) {
      return false;
    }
    final l$progressLabel = progressLabel;
    final lOther$progressLabel = other.progressLabel;
    if (_$data.containsKey('progressLabel') !=
        other._$data.containsKey('progressLabel')) {
      return false;
    }
    if (l$progressLabel != lOther$progressLabel) {
      return false;
    }
    final l$playState = playState;
    final lOther$playState = other.playState;
    if (l$playState != lOther$playState) {
      return false;
    }
    final l$deviceId = deviceId;
    final lOther$deviceId = other.deviceId;
    if (l$deviceId != lOther$deviceId) {
      return false;
    }
    return true;
  }

  @override
  int get hashCode {
    final l$sessionId = sessionId;
    final l$mediaType = mediaType;
    final l$mediaId = mediaId;
    final l$mediaFileId = mediaFileId;
    final l$progressFraction = progressFraction;
    final l$progressLabel = progressLabel;
    final l$playState = playState;
    final l$deviceId = deviceId;
    return Object.hashAll([
      l$sessionId,
      l$mediaType,
      l$mediaId,
      _$data.containsKey('mediaFileId') ? l$mediaFileId : const {},
      _$data.containsKey('progressFraction') ? l$progressFraction : const {},
      _$data.containsKey('progressLabel') ? l$progressLabel : const {},
      l$playState,
      l$deviceId,
    ]);
  }
}

abstract class CopyWith$Variables$Mutation$reportActivity<TRes> {
  factory CopyWith$Variables$Mutation$reportActivity(
    Variables$Mutation$reportActivity instance,
    TRes Function(Variables$Mutation$reportActivity) then,
  ) = _CopyWithImpl$Variables$Mutation$reportActivity;

  factory CopyWith$Variables$Mutation$reportActivity.stub(TRes res) =
      _CopyWithStubImpl$Variables$Mutation$reportActivity;

  TRes call({
    String? sessionId,
    Enum$MediaType? mediaType,
    String? mediaId,
    String? mediaFileId,
    double? progressFraction,
    String? progressLabel,
    Enum$PlayState? playState,
    String? deviceId,
  });
}

class _CopyWithImpl$Variables$Mutation$reportActivity<TRes>
    implements CopyWith$Variables$Mutation$reportActivity<TRes> {
  _CopyWithImpl$Variables$Mutation$reportActivity(this._instance, this._then);

  final Variables$Mutation$reportActivity _instance;

  final TRes Function(Variables$Mutation$reportActivity) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? sessionId = _undefined,
    Object? mediaType = _undefined,
    Object? mediaId = _undefined,
    Object? mediaFileId = _undefined,
    Object? progressFraction = _undefined,
    Object? progressLabel = _undefined,
    Object? playState = _undefined,
    Object? deviceId = _undefined,
  }) => _then(
    Variables$Mutation$reportActivity._({
      ..._instance._$data,
      if (sessionId != _undefined && sessionId != null)
        'sessionId': (sessionId as String),
      if (mediaType != _undefined && mediaType != null)
        'mediaType': (mediaType as Enum$MediaType),
      if (mediaId != _undefined && mediaId != null)
        'mediaId': (mediaId as String),
      if (mediaFileId != _undefined) 'mediaFileId': (mediaFileId as String?),
      if (progressFraction != _undefined)
        'progressFraction': (progressFraction as double?),
      if (progressLabel != _undefined)
        'progressLabel': (progressLabel as String?),
      if (playState != _undefined && playState != null)
        'playState': (playState as Enum$PlayState),
      if (deviceId != _undefined && deviceId != null)
        'deviceId': (deviceId as String),
    }),
  );
}

class _CopyWithStubImpl$Variables$Mutation$reportActivity<TRes>
    implements CopyWith$Variables$Mutation$reportActivity<TRes> {
  _CopyWithStubImpl$Variables$Mutation$reportActivity(this._res);

  TRes _res;

  call({
    String? sessionId,
    Enum$MediaType? mediaType,
    String? mediaId,
    String? mediaFileId,
    double? progressFraction,
    String? progressLabel,
    Enum$PlayState? playState,
    String? deviceId,
  }) => _res;
}

class Mutation$reportActivity {
  Mutation$reportActivity({
    required this.reportActivity,
    this.$__typename = 'Mutation',
  });

  factory Mutation$reportActivity.fromJson(Map<String, dynamic> json) {
    final l$reportActivity = json['reportActivity'];
    final l$$__typename = json['__typename'];
    return Mutation$reportActivity(
      reportActivity: (l$reportActivity as bool),
      $__typename: (l$$__typename as String),
    );
  }

  final bool reportActivity;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$reportActivity = reportActivity;
    _resultData['reportActivity'] = l$reportActivity;
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$reportActivity = reportActivity;
    final l$$__typename = $__typename;
    return Object.hashAll([l$reportActivity, l$$__typename]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Mutation$reportActivity || runtimeType != other.runtimeType) {
      return false;
    }
    final l$reportActivity = reportActivity;
    final lOther$reportActivity = other.reportActivity;
    if (l$reportActivity != lOther$reportActivity) {
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

extension UtilityExtension$Mutation$reportActivity on Mutation$reportActivity {
  CopyWith$Mutation$reportActivity<Mutation$reportActivity> get copyWith =>
      CopyWith$Mutation$reportActivity(this, (i) => i);
}

abstract class CopyWith$Mutation$reportActivity<TRes> {
  factory CopyWith$Mutation$reportActivity(
    Mutation$reportActivity instance,
    TRes Function(Mutation$reportActivity) then,
  ) = _CopyWithImpl$Mutation$reportActivity;

  factory CopyWith$Mutation$reportActivity.stub(TRes res) =
      _CopyWithStubImpl$Mutation$reportActivity;

  TRes call({bool? reportActivity, String? $__typename});
}

class _CopyWithImpl$Mutation$reportActivity<TRes>
    implements CopyWith$Mutation$reportActivity<TRes> {
  _CopyWithImpl$Mutation$reportActivity(this._instance, this._then);

  final Mutation$reportActivity _instance;

  final TRes Function(Mutation$reportActivity) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? reportActivity = _undefined,
    Object? $__typename = _undefined,
  }) => _then(
    Mutation$reportActivity(
      reportActivity: reportActivity == _undefined || reportActivity == null
          ? _instance.reportActivity
          : (reportActivity as bool),
      $__typename: $__typename == _undefined || $__typename == null
          ? _instance.$__typename
          : ($__typename as String),
    ),
  );
}

class _CopyWithStubImpl$Mutation$reportActivity<TRes>
    implements CopyWith$Mutation$reportActivity<TRes> {
  _CopyWithStubImpl$Mutation$reportActivity(this._res);

  TRes _res;

  call({bool? reportActivity, String? $__typename}) => _res;
}

const documentNodeMutationreportActivity = DocumentNode(
  definitions: [
    OperationDefinitionNode(
      type: OperationType.mutation,
      name: NameNode(value: 'reportActivity'),
      variableDefinitions: [
        VariableDefinitionNode(
          variable: VariableNode(name: NameNode(value: 'sessionId')),
          type: NamedTypeNode(name: NameNode(value: 'ID'), isNonNull: true),
          defaultValue: DefaultValueNode(value: null),
          directives: [],
        ),
        VariableDefinitionNode(
          variable: VariableNode(name: NameNode(value: 'mediaType')),
          type: NamedTypeNode(
            name: NameNode(value: 'MediaType'),
            isNonNull: true,
          ),
          defaultValue: DefaultValueNode(value: null),
          directives: [],
        ),
        VariableDefinitionNode(
          variable: VariableNode(name: NameNode(value: 'mediaId')),
          type: NamedTypeNode(name: NameNode(value: 'ID'), isNonNull: true),
          defaultValue: DefaultValueNode(value: null),
          directives: [],
        ),
        VariableDefinitionNode(
          variable: VariableNode(name: NameNode(value: 'mediaFileId')),
          type: NamedTypeNode(name: NameNode(value: 'ID'), isNonNull: false),
          defaultValue: DefaultValueNode(value: null),
          directives: [],
        ),
        VariableDefinitionNode(
          variable: VariableNode(name: NameNode(value: 'progressFraction')),
          type: NamedTypeNode(name: NameNode(value: 'Float'), isNonNull: false),
          defaultValue: DefaultValueNode(value: null),
          directives: [],
        ),
        VariableDefinitionNode(
          variable: VariableNode(name: NameNode(value: 'progressLabel')),
          type: NamedTypeNode(
            name: NameNode(value: 'String'),
            isNonNull: false,
          ),
          defaultValue: DefaultValueNode(value: null),
          directives: [],
        ),
        VariableDefinitionNode(
          variable: VariableNode(name: NameNode(value: 'playState')),
          type: NamedTypeNode(
            name: NameNode(value: 'PlayState'),
            isNonNull: true,
          ),
          defaultValue: DefaultValueNode(value: null),
          directives: [],
        ),
        VariableDefinitionNode(
          variable: VariableNode(name: NameNode(value: 'deviceId')),
          type: NamedTypeNode(name: NameNode(value: 'ID'), isNonNull: true),
          defaultValue: DefaultValueNode(value: null),
          directives: [],
        ),
      ],
      directives: [],
      selectionSet: SelectionSetNode(
        selections: [
          FieldNode(
            name: NameNode(value: 'reportActivity'),
            alias: null,
            arguments: [
              ArgumentNode(
                name: NameNode(value: 'sessionId'),
                value: VariableNode(name: NameNode(value: 'sessionId')),
              ),
              ArgumentNode(
                name: NameNode(value: 'mediaType'),
                value: VariableNode(name: NameNode(value: 'mediaType')),
              ),
              ArgumentNode(
                name: NameNode(value: 'mediaId'),
                value: VariableNode(name: NameNode(value: 'mediaId')),
              ),
              ArgumentNode(
                name: NameNode(value: 'mediaFileId'),
                value: VariableNode(name: NameNode(value: 'mediaFileId')),
              ),
              ArgumentNode(
                name: NameNode(value: 'progressFraction'),
                value: VariableNode(name: NameNode(value: 'progressFraction')),
              ),
              ArgumentNode(
                name: NameNode(value: 'progressLabel'),
                value: VariableNode(name: NameNode(value: 'progressLabel')),
              ),
              ArgumentNode(
                name: NameNode(value: 'playState'),
                value: VariableNode(name: NameNode(value: 'playState')),
              ),
              ArgumentNode(
                name: NameNode(value: 'deviceId'),
                value: VariableNode(name: NameNode(value: 'deviceId')),
              ),
            ],
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
  ],
);

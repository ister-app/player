import 'package:gql/ast.dart';

import 'schema.graphql.dart';

class Variables$Mutation$updatePlayQueueHeartbeat {
  factory Variables$Mutation$updatePlayQueueHeartbeat({
    required String id,
    required String playQueueItemId,
    required int progressInMilliseconds,
    Input$StreamSettingsInput? streamSettings,
    Enum$PlayState? playState,
    String? deviceId,
    int? anchorPositionMs,
    double? anchorServerTimeMs,
    Enum$RepeatMode? repeatMode,
  }) => Variables$Mutation$updatePlayQueueHeartbeat._({
    r'id': id,
    r'playQueueItemId': playQueueItemId,
    r'progressInMilliseconds': progressInMilliseconds,
    if (streamSettings != null) r'streamSettings': streamSettings,
    if (playState != null) r'playState': playState,
    if (deviceId != null) r'deviceId': deviceId,
    if (anchorPositionMs != null) r'anchorPositionMs': anchorPositionMs,
    if (anchorServerTimeMs != null) r'anchorServerTimeMs': anchorServerTimeMs,
    if (repeatMode != null) r'repeatMode': repeatMode,
  });

  Variables$Mutation$updatePlayQueueHeartbeat._(this._$data);

  factory Variables$Mutation$updatePlayQueueHeartbeat.fromJson(
    Map<String, dynamic> data,
  ) {
    final result$data = <String, dynamic>{};
    final l$id = data['id'];
    result$data['id'] = (l$id as String);
    final l$playQueueItemId = data['playQueueItemId'];
    result$data['playQueueItemId'] = (l$playQueueItemId as String);
    final l$progressInMilliseconds = data['progressInMilliseconds'];
    result$data['progressInMilliseconds'] = (l$progressInMilliseconds as int);
    if (data.containsKey('streamSettings')) {
      final l$streamSettings = data['streamSettings'];
      result$data['streamSettings'] = l$streamSettings == null
          ? null
          : Input$StreamSettingsInput.fromJson(
              (l$streamSettings as Map<String, dynamic>),
            );
    }
    if (data.containsKey('playState')) {
      final l$playState = data['playState'];
      result$data['playState'] = l$playState == null
          ? null
          : fromJson$Enum$PlayState((l$playState as String));
    }
    if (data.containsKey('deviceId')) {
      final l$deviceId = data['deviceId'];
      result$data['deviceId'] = (l$deviceId as String?);
    }
    if (data.containsKey('anchorPositionMs')) {
      final l$anchorPositionMs = data['anchorPositionMs'];
      result$data['anchorPositionMs'] = (l$anchorPositionMs as int?);
    }
    if (data.containsKey('anchorServerTimeMs')) {
      final l$anchorServerTimeMs = data['anchorServerTimeMs'];
      result$data['anchorServerTimeMs'] = (l$anchorServerTimeMs as num?)
          ?.toDouble();
    }
    if (data.containsKey('repeatMode')) {
      final l$repeatMode = data['repeatMode'];
      result$data['repeatMode'] = l$repeatMode == null
          ? null
          : fromJson$Enum$RepeatMode((l$repeatMode as String));
    }
    return Variables$Mutation$updatePlayQueueHeartbeat._(result$data);
  }

  Map<String, dynamic> _$data;

  String get id => (_$data['id'] as String);

  String get playQueueItemId => (_$data['playQueueItemId'] as String);

  int get progressInMilliseconds => (_$data['progressInMilliseconds'] as int);

  Input$StreamSettingsInput? get streamSettings =>
      (_$data['streamSettings'] as Input$StreamSettingsInput?);

  Enum$PlayState? get playState => (_$data['playState'] as Enum$PlayState?);

  String? get deviceId => (_$data['deviceId'] as String?);

  int? get anchorPositionMs => (_$data['anchorPositionMs'] as int?);

  double? get anchorServerTimeMs => (_$data['anchorServerTimeMs'] as double?);

  Enum$RepeatMode? get repeatMode => (_$data['repeatMode'] as Enum$RepeatMode?);

  Map<String, dynamic> toJson() {
    final result$data = <String, dynamic>{};
    final l$id = id;
    result$data['id'] = l$id;
    final l$playQueueItemId = playQueueItemId;
    result$data['playQueueItemId'] = l$playQueueItemId;
    final l$progressInMilliseconds = progressInMilliseconds;
    result$data['progressInMilliseconds'] = l$progressInMilliseconds;
    if (_$data.containsKey('streamSettings')) {
      final l$streamSettings = streamSettings;
      result$data['streamSettings'] = l$streamSettings?.toJson();
    }
    if (_$data.containsKey('playState')) {
      final l$playState = playState;
      result$data['playState'] = l$playState == null
          ? null
          : toJson$Enum$PlayState(l$playState);
    }
    if (_$data.containsKey('deviceId')) {
      final l$deviceId = deviceId;
      result$data['deviceId'] = l$deviceId;
    }
    if (_$data.containsKey('anchorPositionMs')) {
      final l$anchorPositionMs = anchorPositionMs;
      result$data['anchorPositionMs'] = l$anchorPositionMs;
    }
    if (_$data.containsKey('anchorServerTimeMs')) {
      final l$anchorServerTimeMs = anchorServerTimeMs;
      result$data['anchorServerTimeMs'] = l$anchorServerTimeMs;
    }
    if (_$data.containsKey('repeatMode')) {
      final l$repeatMode = repeatMode;
      result$data['repeatMode'] = l$repeatMode == null
          ? null
          : toJson$Enum$RepeatMode(l$repeatMode);
    }
    return result$data;
  }

  CopyWith$Variables$Mutation$updatePlayQueueHeartbeat<
    Variables$Mutation$updatePlayQueueHeartbeat
  >
  get copyWith =>
      CopyWith$Variables$Mutation$updatePlayQueueHeartbeat(this, (i) => i);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Variables$Mutation$updatePlayQueueHeartbeat ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$id = id;
    final lOther$id = other.id;
    if (l$id != lOther$id) {
      return false;
    }
    final l$playQueueItemId = playQueueItemId;
    final lOther$playQueueItemId = other.playQueueItemId;
    if (l$playQueueItemId != lOther$playQueueItemId) {
      return false;
    }
    final l$progressInMilliseconds = progressInMilliseconds;
    final lOther$progressInMilliseconds = other.progressInMilliseconds;
    if (l$progressInMilliseconds != lOther$progressInMilliseconds) {
      return false;
    }
    final l$streamSettings = streamSettings;
    final lOther$streamSettings = other.streamSettings;
    if (_$data.containsKey('streamSettings') !=
        other._$data.containsKey('streamSettings')) {
      return false;
    }
    if (l$streamSettings != lOther$streamSettings) {
      return false;
    }
    final l$playState = playState;
    final lOther$playState = other.playState;
    if (_$data.containsKey('playState') !=
        other._$data.containsKey('playState')) {
      return false;
    }
    if (l$playState != lOther$playState) {
      return false;
    }
    final l$deviceId = deviceId;
    final lOther$deviceId = other.deviceId;
    if (_$data.containsKey('deviceId') !=
        other._$data.containsKey('deviceId')) {
      return false;
    }
    if (l$deviceId != lOther$deviceId) {
      return false;
    }
    final l$anchorPositionMs = anchorPositionMs;
    final lOther$anchorPositionMs = other.anchorPositionMs;
    if (_$data.containsKey('anchorPositionMs') !=
        other._$data.containsKey('anchorPositionMs')) {
      return false;
    }
    if (l$anchorPositionMs != lOther$anchorPositionMs) {
      return false;
    }
    final l$anchorServerTimeMs = anchorServerTimeMs;
    final lOther$anchorServerTimeMs = other.anchorServerTimeMs;
    if (_$data.containsKey('anchorServerTimeMs') !=
        other._$data.containsKey('anchorServerTimeMs')) {
      return false;
    }
    if (l$anchorServerTimeMs != lOther$anchorServerTimeMs) {
      return false;
    }
    final l$repeatMode = repeatMode;
    final lOther$repeatMode = other.repeatMode;
    if (_$data.containsKey('repeatMode') !=
        other._$data.containsKey('repeatMode')) {
      return false;
    }
    if (l$repeatMode != lOther$repeatMode) {
      return false;
    }
    return true;
  }

  @override
  int get hashCode {
    final l$id = id;
    final l$playQueueItemId = playQueueItemId;
    final l$progressInMilliseconds = progressInMilliseconds;
    final l$streamSettings = streamSettings;
    final l$playState = playState;
    final l$deviceId = deviceId;
    final l$anchorPositionMs = anchorPositionMs;
    final l$anchorServerTimeMs = anchorServerTimeMs;
    final l$repeatMode = repeatMode;
    return Object.hashAll([
      l$id,
      l$playQueueItemId,
      l$progressInMilliseconds,
      _$data.containsKey('streamSettings') ? l$streamSettings : const {},
      _$data.containsKey('playState') ? l$playState : const {},
      _$data.containsKey('deviceId') ? l$deviceId : const {},
      _$data.containsKey('anchorPositionMs') ? l$anchorPositionMs : const {},
      _$data.containsKey('anchorServerTimeMs')
          ? l$anchorServerTimeMs
          : const {},
      _$data.containsKey('repeatMode') ? l$repeatMode : const {},
    ]);
  }
}

abstract class CopyWith$Variables$Mutation$updatePlayQueueHeartbeat<TRes> {
  factory CopyWith$Variables$Mutation$updatePlayQueueHeartbeat(
    Variables$Mutation$updatePlayQueueHeartbeat instance,
    TRes Function(Variables$Mutation$updatePlayQueueHeartbeat) then,
  ) = _CopyWithImpl$Variables$Mutation$updatePlayQueueHeartbeat;

  factory CopyWith$Variables$Mutation$updatePlayQueueHeartbeat.stub(TRes res) =
      _CopyWithStubImpl$Variables$Mutation$updatePlayQueueHeartbeat;

  TRes call({
    String? id,
    String? playQueueItemId,
    int? progressInMilliseconds,
    Input$StreamSettingsInput? streamSettings,
    Enum$PlayState? playState,
    String? deviceId,
    int? anchorPositionMs,
    double? anchorServerTimeMs,
    Enum$RepeatMode? repeatMode,
  });
}

class _CopyWithImpl$Variables$Mutation$updatePlayQueueHeartbeat<TRes>
    implements CopyWith$Variables$Mutation$updatePlayQueueHeartbeat<TRes> {
  _CopyWithImpl$Variables$Mutation$updatePlayQueueHeartbeat(
    this._instance,
    this._then,
  );

  final Variables$Mutation$updatePlayQueueHeartbeat _instance;

  final TRes Function(Variables$Mutation$updatePlayQueueHeartbeat) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? id = _undefined,
    Object? playQueueItemId = _undefined,
    Object? progressInMilliseconds = _undefined,
    Object? streamSettings = _undefined,
    Object? playState = _undefined,
    Object? deviceId = _undefined,
    Object? anchorPositionMs = _undefined,
    Object? anchorServerTimeMs = _undefined,
    Object? repeatMode = _undefined,
  }) => _then(
    Variables$Mutation$updatePlayQueueHeartbeat._({
      ..._instance._$data,
      if (id != _undefined && id != null) 'id': (id as String),
      if (playQueueItemId != _undefined && playQueueItemId != null)
        'playQueueItemId': (playQueueItemId as String),
      if (progressInMilliseconds != _undefined &&
          progressInMilliseconds != null)
        'progressInMilliseconds': (progressInMilliseconds as int),
      if (streamSettings != _undefined)
        'streamSettings': (streamSettings as Input$StreamSettingsInput?),
      if (playState != _undefined) 'playState': (playState as Enum$PlayState?),
      if (deviceId != _undefined) 'deviceId': (deviceId as String?),
      if (anchorPositionMs != _undefined)
        'anchorPositionMs': (anchorPositionMs as int?),
      if (anchorServerTimeMs != _undefined)
        'anchorServerTimeMs': (anchorServerTimeMs as double?),
      if (repeatMode != _undefined)
        'repeatMode': (repeatMode as Enum$RepeatMode?),
    }),
  );
}

class _CopyWithStubImpl$Variables$Mutation$updatePlayQueueHeartbeat<TRes>
    implements CopyWith$Variables$Mutation$updatePlayQueueHeartbeat<TRes> {
  _CopyWithStubImpl$Variables$Mutation$updatePlayQueueHeartbeat(this._res);

  TRes _res;

  call({
    String? id,
    String? playQueueItemId,
    int? progressInMilliseconds,
    Input$StreamSettingsInput? streamSettings,
    Enum$PlayState? playState,
    String? deviceId,
    int? anchorPositionMs,
    double? anchorServerTimeMs,
    Enum$RepeatMode? repeatMode,
  }) => _res;
}

class Mutation$updatePlayQueueHeartbeat {
  Mutation$updatePlayQueueHeartbeat({
    this.updatePlayQueue,
    this.$__typename = 'Mutation',
  });

  factory Mutation$updatePlayQueueHeartbeat.fromJson(
    Map<String, dynamic> json,
  ) {
    final l$updatePlayQueue = json['updatePlayQueue'];
    final l$$__typename = json['__typename'];
    return Mutation$updatePlayQueueHeartbeat(
      updatePlayQueue: l$updatePlayQueue == null
          ? null
          : Mutation$updatePlayQueueHeartbeat$updatePlayQueue.fromJson(
              (l$updatePlayQueue as Map<String, dynamic>),
            ),
      $__typename: (l$$__typename as String),
    );
  }

  final Mutation$updatePlayQueueHeartbeat$updatePlayQueue? updatePlayQueue;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$updatePlayQueue = updatePlayQueue;
    _resultData['updatePlayQueue'] = l$updatePlayQueue?.toJson();
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$updatePlayQueue = updatePlayQueue;
    final l$$__typename = $__typename;
    return Object.hashAll([l$updatePlayQueue, l$$__typename]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Mutation$updatePlayQueueHeartbeat ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$updatePlayQueue = updatePlayQueue;
    final lOther$updatePlayQueue = other.updatePlayQueue;
    if (l$updatePlayQueue != lOther$updatePlayQueue) {
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

extension UtilityExtension$Mutation$updatePlayQueueHeartbeat
    on Mutation$updatePlayQueueHeartbeat {
  CopyWith$Mutation$updatePlayQueueHeartbeat<Mutation$updatePlayQueueHeartbeat>
  get copyWith => CopyWith$Mutation$updatePlayQueueHeartbeat(this, (i) => i);
}

abstract class CopyWith$Mutation$updatePlayQueueHeartbeat<TRes> {
  factory CopyWith$Mutation$updatePlayQueueHeartbeat(
    Mutation$updatePlayQueueHeartbeat instance,
    TRes Function(Mutation$updatePlayQueueHeartbeat) then,
  ) = _CopyWithImpl$Mutation$updatePlayQueueHeartbeat;

  factory CopyWith$Mutation$updatePlayQueueHeartbeat.stub(TRes res) =
      _CopyWithStubImpl$Mutation$updatePlayQueueHeartbeat;

  TRes call({
    Mutation$updatePlayQueueHeartbeat$updatePlayQueue? updatePlayQueue,
    String? $__typename,
  });
  CopyWith$Mutation$updatePlayQueueHeartbeat$updatePlayQueue<TRes>
  get updatePlayQueue;
}

class _CopyWithImpl$Mutation$updatePlayQueueHeartbeat<TRes>
    implements CopyWith$Mutation$updatePlayQueueHeartbeat<TRes> {
  _CopyWithImpl$Mutation$updatePlayQueueHeartbeat(this._instance, this._then);

  final Mutation$updatePlayQueueHeartbeat _instance;

  final TRes Function(Mutation$updatePlayQueueHeartbeat) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? updatePlayQueue = _undefined,
    Object? $__typename = _undefined,
  }) => _then(
    Mutation$updatePlayQueueHeartbeat(
      updatePlayQueue: updatePlayQueue == _undefined
          ? _instance.updatePlayQueue
          : (updatePlayQueue
                as Mutation$updatePlayQueueHeartbeat$updatePlayQueue?),
      $__typename: $__typename == _undefined || $__typename == null
          ? _instance.$__typename
          : ($__typename as String),
    ),
  );

  CopyWith$Mutation$updatePlayQueueHeartbeat$updatePlayQueue<TRes>
  get updatePlayQueue {
    final local$updatePlayQueue = _instance.updatePlayQueue;
    return local$updatePlayQueue == null
        ? CopyWith$Mutation$updatePlayQueueHeartbeat$updatePlayQueue.stub(
            _then(_instance),
          )
        : CopyWith$Mutation$updatePlayQueueHeartbeat$updatePlayQueue(
            local$updatePlayQueue,
            (e) => call(updatePlayQueue: e),
          );
  }
}

class _CopyWithStubImpl$Mutation$updatePlayQueueHeartbeat<TRes>
    implements CopyWith$Mutation$updatePlayQueueHeartbeat<TRes> {
  _CopyWithStubImpl$Mutation$updatePlayQueueHeartbeat(this._res);

  TRes _res;

  call({
    Mutation$updatePlayQueueHeartbeat$updatePlayQueue? updatePlayQueue,
    String? $__typename,
  }) => _res;

  CopyWith$Mutation$updatePlayQueueHeartbeat$updatePlayQueue<TRes>
  get updatePlayQueue =>
      CopyWith$Mutation$updatePlayQueueHeartbeat$updatePlayQueue.stub(_res);
}

const documentNodeMutationupdatePlayQueueHeartbeat = DocumentNode(
  definitions: [
    OperationDefinitionNode(
      type: OperationType.mutation,
      name: NameNode(value: 'updatePlayQueueHeartbeat'),
      variableDefinitions: [
        VariableDefinitionNode(
          variable: VariableNode(name: NameNode(value: 'id')),
          type: NamedTypeNode(name: NameNode(value: 'ID'), isNonNull: true),
          defaultValue: DefaultValueNode(value: null),
          directives: [],
        ),
        VariableDefinitionNode(
          variable: VariableNode(name: NameNode(value: 'playQueueItemId')),
          type: NamedTypeNode(name: NameNode(value: 'ID'), isNonNull: true),
          defaultValue: DefaultValueNode(value: null),
          directives: [],
        ),
        VariableDefinitionNode(
          variable: VariableNode(
            name: NameNode(value: 'progressInMilliseconds'),
          ),
          type: NamedTypeNode(name: NameNode(value: 'Int'), isNonNull: true),
          defaultValue: DefaultValueNode(value: null),
          directives: [],
        ),
        VariableDefinitionNode(
          variable: VariableNode(name: NameNode(value: 'streamSettings')),
          type: NamedTypeNode(
            name: NameNode(value: 'StreamSettingsInput'),
            isNonNull: false,
          ),
          defaultValue: DefaultValueNode(value: null),
          directives: [],
        ),
        VariableDefinitionNode(
          variable: VariableNode(name: NameNode(value: 'playState')),
          type: NamedTypeNode(
            name: NameNode(value: 'PlayState'),
            isNonNull: false,
          ),
          defaultValue: DefaultValueNode(value: null),
          directives: [],
        ),
        VariableDefinitionNode(
          variable: VariableNode(name: NameNode(value: 'deviceId')),
          type: NamedTypeNode(name: NameNode(value: 'ID'), isNonNull: false),
          defaultValue: DefaultValueNode(value: null),
          directives: [],
        ),
        VariableDefinitionNode(
          variable: VariableNode(name: NameNode(value: 'anchorPositionMs')),
          type: NamedTypeNode(name: NameNode(value: 'Int'), isNonNull: false),
          defaultValue: DefaultValueNode(value: null),
          directives: [],
        ),
        VariableDefinitionNode(
          variable: VariableNode(name: NameNode(value: 'anchorServerTimeMs')),
          type: NamedTypeNode(name: NameNode(value: 'Float'), isNonNull: false),
          defaultValue: DefaultValueNode(value: null),
          directives: [],
        ),
        VariableDefinitionNode(
          variable: VariableNode(name: NameNode(value: 'repeatMode')),
          type: NamedTypeNode(
            name: NameNode(value: 'RepeatMode'),
            isNonNull: false,
          ),
          defaultValue: DefaultValueNode(value: null),
          directives: [],
        ),
      ],
      directives: [],
      selectionSet: SelectionSetNode(
        selections: [
          FieldNode(
            name: NameNode(value: 'updatePlayQueue'),
            alias: null,
            arguments: [
              ArgumentNode(
                name: NameNode(value: 'id'),
                value: VariableNode(name: NameNode(value: 'id')),
              ),
              ArgumentNode(
                name: NameNode(value: 'playQueueItemId'),
                value: VariableNode(name: NameNode(value: 'playQueueItemId')),
              ),
              ArgumentNode(
                name: NameNode(value: 'progressInMilliseconds'),
                value: VariableNode(
                  name: NameNode(value: 'progressInMilliseconds'),
                ),
              ),
              ArgumentNode(
                name: NameNode(value: 'streamSettings'),
                value: VariableNode(name: NameNode(value: 'streamSettings')),
              ),
              ArgumentNode(
                name: NameNode(value: 'playState'),
                value: VariableNode(name: NameNode(value: 'playState')),
              ),
              ArgumentNode(
                name: NameNode(value: 'deviceId'),
                value: VariableNode(name: NameNode(value: 'deviceId')),
              ),
              ArgumentNode(
                name: NameNode(value: 'anchorPositionMs'),
                value: VariableNode(name: NameNode(value: 'anchorPositionMs')),
              ),
              ArgumentNode(
                name: NameNode(value: 'anchorServerTimeMs'),
                value: VariableNode(
                  name: NameNode(value: 'anchorServerTimeMs'),
                ),
              ),
              ArgumentNode(
                name: NameNode(value: 'repeatMode'),
                value: VariableNode(name: NameNode(value: 'repeatMode')),
              ),
            ],
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
                  name: NameNode(value: 'currentItemId'),
                  alias: null,
                  arguments: [],
                  directives: [],
                  selectionSet: null,
                ),
                FieldNode(
                  name: NameNode(value: 'sourceExhausted'),
                  alias: null,
                  arguments: [],
                  directives: [],
                  selectionSet: null,
                ),
                FieldNode(
                  name: NameNode(value: 'playQueueItems'),
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

class Mutation$updatePlayQueueHeartbeat$updatePlayQueue {
  Mutation$updatePlayQueueHeartbeat$updatePlayQueue({
    required this.id,
    this.currentItemId,
    required this.sourceExhausted,
    this.playQueueItems,
    this.$__typename = 'PlayQueue',
  });

  factory Mutation$updatePlayQueueHeartbeat$updatePlayQueue.fromJson(
    Map<String, dynamic> json,
  ) {
    final l$id = json['id'];
    final l$currentItemId = json['currentItemId'];
    final l$sourceExhausted = json['sourceExhausted'];
    final l$playQueueItems = json['playQueueItems'];
    final l$$__typename = json['__typename'];
    return Mutation$updatePlayQueueHeartbeat$updatePlayQueue(
      id: (l$id as String),
      currentItemId: (l$currentItemId as String?),
      sourceExhausted: (l$sourceExhausted as bool),
      playQueueItems: (l$playQueueItems as List<dynamic>?)
          ?.map(
            (e) =>
                Mutation$updatePlayQueueHeartbeat$updatePlayQueue$playQueueItems.fromJson(
                  (e as Map<String, dynamic>),
                ),
          )
          .toList(),
      $__typename: (l$$__typename as String),
    );
  }

  final String id;

  final String? currentItemId;

  final bool sourceExhausted;

  final List<Mutation$updatePlayQueueHeartbeat$updatePlayQueue$playQueueItems>?
  playQueueItems;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$id = id;
    _resultData['id'] = l$id;
    final l$currentItemId = currentItemId;
    _resultData['currentItemId'] = l$currentItemId;
    final l$sourceExhausted = sourceExhausted;
    _resultData['sourceExhausted'] = l$sourceExhausted;
    final l$playQueueItems = playQueueItems;
    _resultData['playQueueItems'] = l$playQueueItems
        ?.map((e) => e.toJson())
        .toList();
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$id = id;
    final l$currentItemId = currentItemId;
    final l$sourceExhausted = sourceExhausted;
    final l$playQueueItems = playQueueItems;
    final l$$__typename = $__typename;
    return Object.hashAll([
      l$id,
      l$currentItemId,
      l$sourceExhausted,
      l$playQueueItems == null
          ? null
          : Object.hashAll(l$playQueueItems.map((v) => v)),
      l$$__typename,
    ]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Mutation$updatePlayQueueHeartbeat$updatePlayQueue ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$id = id;
    final lOther$id = other.id;
    if (l$id != lOther$id) {
      return false;
    }
    final l$currentItemId = currentItemId;
    final lOther$currentItemId = other.currentItemId;
    if (l$currentItemId != lOther$currentItemId) {
      return false;
    }
    final l$sourceExhausted = sourceExhausted;
    final lOther$sourceExhausted = other.sourceExhausted;
    if (l$sourceExhausted != lOther$sourceExhausted) {
      return false;
    }
    final l$playQueueItems = playQueueItems;
    final lOther$playQueueItems = other.playQueueItems;
    if (l$playQueueItems != null && lOther$playQueueItems != null) {
      if (l$playQueueItems.length != lOther$playQueueItems.length) {
        return false;
      }
      for (int i = 0; i < l$playQueueItems.length; i++) {
        final l$playQueueItems$entry = l$playQueueItems[i];
        final lOther$playQueueItems$entry = lOther$playQueueItems[i];
        if (l$playQueueItems$entry != lOther$playQueueItems$entry) {
          return false;
        }
      }
    } else if (l$playQueueItems != lOther$playQueueItems) {
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

extension UtilityExtension$Mutation$updatePlayQueueHeartbeat$updatePlayQueue
    on Mutation$updatePlayQueueHeartbeat$updatePlayQueue {
  CopyWith$Mutation$updatePlayQueueHeartbeat$updatePlayQueue<
    Mutation$updatePlayQueueHeartbeat$updatePlayQueue
  >
  get copyWith => CopyWith$Mutation$updatePlayQueueHeartbeat$updatePlayQueue(
    this,
    (i) => i,
  );
}

abstract class CopyWith$Mutation$updatePlayQueueHeartbeat$updatePlayQueue<
  TRes
> {
  factory CopyWith$Mutation$updatePlayQueueHeartbeat$updatePlayQueue(
    Mutation$updatePlayQueueHeartbeat$updatePlayQueue instance,
    TRes Function(Mutation$updatePlayQueueHeartbeat$updatePlayQueue) then,
  ) = _CopyWithImpl$Mutation$updatePlayQueueHeartbeat$updatePlayQueue;

  factory CopyWith$Mutation$updatePlayQueueHeartbeat$updatePlayQueue.stub(
    TRes res,
  ) = _CopyWithStubImpl$Mutation$updatePlayQueueHeartbeat$updatePlayQueue;

  TRes call({
    String? id,
    String? currentItemId,
    bool? sourceExhausted,
    List<Mutation$updatePlayQueueHeartbeat$updatePlayQueue$playQueueItems>?
    playQueueItems,
    String? $__typename,
  });
  TRes playQueueItems(
    Iterable<Mutation$updatePlayQueueHeartbeat$updatePlayQueue$playQueueItems>?
    Function(
      Iterable<
        CopyWith$Mutation$updatePlayQueueHeartbeat$updatePlayQueue$playQueueItems<
          Mutation$updatePlayQueueHeartbeat$updatePlayQueue$playQueueItems
        >
      >?,
    )
    _fn,
  );
}

class _CopyWithImpl$Mutation$updatePlayQueueHeartbeat$updatePlayQueue<TRes>
    implements
        CopyWith$Mutation$updatePlayQueueHeartbeat$updatePlayQueue<TRes> {
  _CopyWithImpl$Mutation$updatePlayQueueHeartbeat$updatePlayQueue(
    this._instance,
    this._then,
  );

  final Mutation$updatePlayQueueHeartbeat$updatePlayQueue _instance;

  final TRes Function(Mutation$updatePlayQueueHeartbeat$updatePlayQueue) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? id = _undefined,
    Object? currentItemId = _undefined,
    Object? sourceExhausted = _undefined,
    Object? playQueueItems = _undefined,
    Object? $__typename = _undefined,
  }) => _then(
    Mutation$updatePlayQueueHeartbeat$updatePlayQueue(
      id: id == _undefined || id == null ? _instance.id : (id as String),
      currentItemId: currentItemId == _undefined
          ? _instance.currentItemId
          : (currentItemId as String?),
      sourceExhausted: sourceExhausted == _undefined || sourceExhausted == null
          ? _instance.sourceExhausted
          : (sourceExhausted as bool),
      playQueueItems: playQueueItems == _undefined
          ? _instance.playQueueItems
          : (playQueueItems
                as List<
                  Mutation$updatePlayQueueHeartbeat$updatePlayQueue$playQueueItems
                >?),
      $__typename: $__typename == _undefined || $__typename == null
          ? _instance.$__typename
          : ($__typename as String),
    ),
  );

  TRes playQueueItems(
    Iterable<Mutation$updatePlayQueueHeartbeat$updatePlayQueue$playQueueItems>?
    Function(
      Iterable<
        CopyWith$Mutation$updatePlayQueueHeartbeat$updatePlayQueue$playQueueItems<
          Mutation$updatePlayQueueHeartbeat$updatePlayQueue$playQueueItems
        >
      >?,
    )
    _fn,
  ) => call(
    playQueueItems: _fn(
      _instance.playQueueItems?.map(
        (e) =>
            CopyWith$Mutation$updatePlayQueueHeartbeat$updatePlayQueue$playQueueItems(
              e,
              (i) => i,
            ),
      ),
    )?.toList(),
  );
}

class _CopyWithStubImpl$Mutation$updatePlayQueueHeartbeat$updatePlayQueue<TRes>
    implements
        CopyWith$Mutation$updatePlayQueueHeartbeat$updatePlayQueue<TRes> {
  _CopyWithStubImpl$Mutation$updatePlayQueueHeartbeat$updatePlayQueue(
    this._res,
  );

  TRes _res;

  call({
    String? id,
    String? currentItemId,
    bool? sourceExhausted,
    List<Mutation$updatePlayQueueHeartbeat$updatePlayQueue$playQueueItems>?
    playQueueItems,
    String? $__typename,
  }) => _res;

  playQueueItems(_fn) => _res;
}

class Mutation$updatePlayQueueHeartbeat$updatePlayQueue$playQueueItems {
  Mutation$updatePlayQueueHeartbeat$updatePlayQueue$playQueueItems({
    required this.id,
    this.$__typename = 'PlayQueueItem',
  });

  factory Mutation$updatePlayQueueHeartbeat$updatePlayQueue$playQueueItems.fromJson(
    Map<String, dynamic> json,
  ) {
    final l$id = json['id'];
    final l$$__typename = json['__typename'];
    return Mutation$updatePlayQueueHeartbeat$updatePlayQueue$playQueueItems(
      id: (l$id as String),
      $__typename: (l$$__typename as String),
    );
  }

  final String id;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$id = id;
    _resultData['id'] = l$id;
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$id = id;
    final l$$__typename = $__typename;
    return Object.hashAll([l$id, l$$__typename]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other
            is! Mutation$updatePlayQueueHeartbeat$updatePlayQueue$playQueueItems ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$id = id;
    final lOther$id = other.id;
    if (l$id != lOther$id) {
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

extension UtilityExtension$Mutation$updatePlayQueueHeartbeat$updatePlayQueue$playQueueItems
    on Mutation$updatePlayQueueHeartbeat$updatePlayQueue$playQueueItems {
  CopyWith$Mutation$updatePlayQueueHeartbeat$updatePlayQueue$playQueueItems<
    Mutation$updatePlayQueueHeartbeat$updatePlayQueue$playQueueItems
  >
  get copyWith =>
      CopyWith$Mutation$updatePlayQueueHeartbeat$updatePlayQueue$playQueueItems(
        this,
        (i) => i,
      );
}

abstract class CopyWith$Mutation$updatePlayQueueHeartbeat$updatePlayQueue$playQueueItems<
  TRes
> {
  factory CopyWith$Mutation$updatePlayQueueHeartbeat$updatePlayQueue$playQueueItems(
    Mutation$updatePlayQueueHeartbeat$updatePlayQueue$playQueueItems instance,
    TRes Function(
      Mutation$updatePlayQueueHeartbeat$updatePlayQueue$playQueueItems,
    )
    then,
  ) = _CopyWithImpl$Mutation$updatePlayQueueHeartbeat$updatePlayQueue$playQueueItems;

  factory CopyWith$Mutation$updatePlayQueueHeartbeat$updatePlayQueue$playQueueItems.stub(
    TRes res,
  ) = _CopyWithStubImpl$Mutation$updatePlayQueueHeartbeat$updatePlayQueue$playQueueItems;

  TRes call({String? id, String? $__typename});
}

class _CopyWithImpl$Mutation$updatePlayQueueHeartbeat$updatePlayQueue$playQueueItems<
  TRes
>
    implements
        CopyWith$Mutation$updatePlayQueueHeartbeat$updatePlayQueue$playQueueItems<
          TRes
        > {
  _CopyWithImpl$Mutation$updatePlayQueueHeartbeat$updatePlayQueue$playQueueItems(
    this._instance,
    this._then,
  );

  final Mutation$updatePlayQueueHeartbeat$updatePlayQueue$playQueueItems
  _instance;

  final TRes Function(
    Mutation$updatePlayQueueHeartbeat$updatePlayQueue$playQueueItems,
  )
  _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({Object? id = _undefined, Object? $__typename = _undefined}) =>
      _then(
        Mutation$updatePlayQueueHeartbeat$updatePlayQueue$playQueueItems(
          id: id == _undefined || id == null ? _instance.id : (id as String),
          $__typename: $__typename == _undefined || $__typename == null
              ? _instance.$__typename
              : ($__typename as String),
        ),
      );
}

class _CopyWithStubImpl$Mutation$updatePlayQueueHeartbeat$updatePlayQueue$playQueueItems<
  TRes
>
    implements
        CopyWith$Mutation$updatePlayQueueHeartbeat$updatePlayQueue$playQueueItems<
          TRes
        > {
  _CopyWithStubImpl$Mutation$updatePlayQueueHeartbeat$updatePlayQueue$playQueueItems(
    this._res,
  );

  TRes _res;

  call({String? id, String? $__typename}) => _res;
}

class Input$StreamSettingsInput {
  factory Input$StreamSettingsInput({
    required bool direct,
    required bool transcode,
    Enum$SubtitleFormat? subtitleFormat,
  }) => Input$StreamSettingsInput._({
    r'direct': direct,
    r'transcode': transcode,
    if (subtitleFormat != null) r'subtitleFormat': subtitleFormat,
  });

  Input$StreamSettingsInput._(this._$data);

  factory Input$StreamSettingsInput.fromJson(Map<String, dynamic> data) {
    final result$data = <String, dynamic>{};
    final l$direct = data['direct'];
    result$data['direct'] = (l$direct as bool);
    final l$transcode = data['transcode'];
    result$data['transcode'] = (l$transcode as bool);
    if (data.containsKey('subtitleFormat')) {
      final l$subtitleFormat = data['subtitleFormat'];
      result$data['subtitleFormat'] = l$subtitleFormat == null
          ? null
          : fromJson$Enum$SubtitleFormat((l$subtitleFormat as String));
    }
    return Input$StreamSettingsInput._(result$data);
  }

  Map<String, dynamic> _$data;

  bool get direct => (_$data['direct'] as bool);

  bool get transcode => (_$data['transcode'] as bool);

  Enum$SubtitleFormat? get subtitleFormat =>
      (_$data['subtitleFormat'] as Enum$SubtitleFormat?);

  Map<String, dynamic> toJson() {
    final result$data = <String, dynamic>{};
    final l$direct = direct;
    result$data['direct'] = l$direct;
    final l$transcode = transcode;
    result$data['transcode'] = l$transcode;
    if (_$data.containsKey('subtitleFormat')) {
      final l$subtitleFormat = subtitleFormat;
      result$data['subtitleFormat'] = l$subtitleFormat == null
          ? null
          : toJson$Enum$SubtitleFormat(l$subtitleFormat);
    }
    return result$data;
  }

  CopyWith$Input$StreamSettingsInput<Input$StreamSettingsInput> get copyWith =>
      CopyWith$Input$StreamSettingsInput(this, (i) => i);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Input$StreamSettingsInput ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$direct = direct;
    final lOther$direct = other.direct;
    if (l$direct != lOther$direct) {
      return false;
    }
    final l$transcode = transcode;
    final lOther$transcode = other.transcode;
    if (l$transcode != lOther$transcode) {
      return false;
    }
    final l$subtitleFormat = subtitleFormat;
    final lOther$subtitleFormat = other.subtitleFormat;
    if (_$data.containsKey('subtitleFormat') !=
        other._$data.containsKey('subtitleFormat')) {
      return false;
    }
    if (l$subtitleFormat != lOther$subtitleFormat) {
      return false;
    }
    return true;
  }

  @override
  int get hashCode {
    final l$direct = direct;
    final l$transcode = transcode;
    final l$subtitleFormat = subtitleFormat;
    return Object.hashAll([
      l$direct,
      l$transcode,
      _$data.containsKey('subtitleFormat') ? l$subtitleFormat : const {},
    ]);
  }
}

abstract class CopyWith$Input$StreamSettingsInput<TRes> {
  factory CopyWith$Input$StreamSettingsInput(
    Input$StreamSettingsInput instance,
    TRes Function(Input$StreamSettingsInput) then,
  ) = _CopyWithImpl$Input$StreamSettingsInput;

  factory CopyWith$Input$StreamSettingsInput.stub(TRes res) =
      _CopyWithStubImpl$Input$StreamSettingsInput;

  TRes call({
    bool? direct,
    bool? transcode,
    Enum$SubtitleFormat? subtitleFormat,
  });
}

class _CopyWithImpl$Input$StreamSettingsInput<TRes>
    implements CopyWith$Input$StreamSettingsInput<TRes> {
  _CopyWithImpl$Input$StreamSettingsInput(this._instance, this._then);

  final Input$StreamSettingsInput _instance;

  final TRes Function(Input$StreamSettingsInput) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? direct = _undefined,
    Object? transcode = _undefined,
    Object? subtitleFormat = _undefined,
  }) => _then(
    Input$StreamSettingsInput._({
      ..._instance._$data,
      if (direct != _undefined && direct != null) 'direct': (direct as bool),
      if (transcode != _undefined && transcode != null)
        'transcode': (transcode as bool),
      if (subtitleFormat != _undefined)
        'subtitleFormat': (subtitleFormat as Enum$SubtitleFormat?),
    }),
  );
}

class _CopyWithStubImpl$Input$StreamSettingsInput<TRes>
    implements CopyWith$Input$StreamSettingsInput<TRes> {
  _CopyWithStubImpl$Input$StreamSettingsInput(this._res);

  TRes _res;

  call({bool? direct, bool? transcode, Enum$SubtitleFormat? subtitleFormat}) =>
      _res;
}

class Input$CreatePlayQueueInput {
  factory Input$CreatePlayQueueInput({
    required Enum$PlayQueueSourceType sourceType,
    required String sourceId,
    String? startId,
    bool? shuffle,
  }) => Input$CreatePlayQueueInput._({
    r'sourceType': sourceType,
    r'sourceId': sourceId,
    if (startId != null) r'startId': startId,
    if (shuffle != null) r'shuffle': shuffle,
  });

  Input$CreatePlayQueueInput._(this._$data);

  factory Input$CreatePlayQueueInput.fromJson(Map<String, dynamic> data) {
    final result$data = <String, dynamic>{};
    final l$sourceType = data['sourceType'];
    result$data['sourceType'] = fromJson$Enum$PlayQueueSourceType(
      (l$sourceType as String),
    );
    final l$sourceId = data['sourceId'];
    result$data['sourceId'] = (l$sourceId as String);
    if (data.containsKey('startId')) {
      final l$startId = data['startId'];
      result$data['startId'] = (l$startId as String?);
    }
    if (data.containsKey('shuffle')) {
      final l$shuffle = data['shuffle'];
      result$data['shuffle'] = (l$shuffle as bool?);
    }
    return Input$CreatePlayQueueInput._(result$data);
  }

  Map<String, dynamic> _$data;

  Enum$PlayQueueSourceType get sourceType =>
      (_$data['sourceType'] as Enum$PlayQueueSourceType);

  String get sourceId => (_$data['sourceId'] as String);

  String? get startId => (_$data['startId'] as String?);

  bool? get shuffle => (_$data['shuffle'] as bool?);

  Map<String, dynamic> toJson() {
    final result$data = <String, dynamic>{};
    final l$sourceType = sourceType;
    result$data['sourceType'] = toJson$Enum$PlayQueueSourceType(l$sourceType);
    final l$sourceId = sourceId;
    result$data['sourceId'] = l$sourceId;
    if (_$data.containsKey('startId')) {
      final l$startId = startId;
      result$data['startId'] = l$startId;
    }
    if (_$data.containsKey('shuffle')) {
      final l$shuffle = shuffle;
      result$data['shuffle'] = l$shuffle;
    }
    return result$data;
  }

  CopyWith$Input$CreatePlayQueueInput<Input$CreatePlayQueueInput>
  get copyWith => CopyWith$Input$CreatePlayQueueInput(this, (i) => i);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Input$CreatePlayQueueInput ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$sourceType = sourceType;
    final lOther$sourceType = other.sourceType;
    if (l$sourceType != lOther$sourceType) {
      return false;
    }
    final l$sourceId = sourceId;
    final lOther$sourceId = other.sourceId;
    if (l$sourceId != lOther$sourceId) {
      return false;
    }
    final l$startId = startId;
    final lOther$startId = other.startId;
    if (_$data.containsKey('startId') != other._$data.containsKey('startId')) {
      return false;
    }
    if (l$startId != lOther$startId) {
      return false;
    }
    final l$shuffle = shuffle;
    final lOther$shuffle = other.shuffle;
    if (_$data.containsKey('shuffle') != other._$data.containsKey('shuffle')) {
      return false;
    }
    if (l$shuffle != lOther$shuffle) {
      return false;
    }
    return true;
  }

  @override
  int get hashCode {
    final l$sourceType = sourceType;
    final l$sourceId = sourceId;
    final l$startId = startId;
    final l$shuffle = shuffle;
    return Object.hashAll([
      l$sourceType,
      l$sourceId,
      _$data.containsKey('startId') ? l$startId : const {},
      _$data.containsKey('shuffle') ? l$shuffle : const {},
    ]);
  }
}

abstract class CopyWith$Input$CreatePlayQueueInput<TRes> {
  factory CopyWith$Input$CreatePlayQueueInput(
    Input$CreatePlayQueueInput instance,
    TRes Function(Input$CreatePlayQueueInput) then,
  ) = _CopyWithImpl$Input$CreatePlayQueueInput;

  factory CopyWith$Input$CreatePlayQueueInput.stub(TRes res) =
      _CopyWithStubImpl$Input$CreatePlayQueueInput;

  TRes call({
    Enum$PlayQueueSourceType? sourceType,
    String? sourceId,
    String? startId,
    bool? shuffle,
  });
}

class _CopyWithImpl$Input$CreatePlayQueueInput<TRes>
    implements CopyWith$Input$CreatePlayQueueInput<TRes> {
  _CopyWithImpl$Input$CreatePlayQueueInput(this._instance, this._then);

  final Input$CreatePlayQueueInput _instance;

  final TRes Function(Input$CreatePlayQueueInput) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? sourceType = _undefined,
    Object? sourceId = _undefined,
    Object? startId = _undefined,
    Object? shuffle = _undefined,
  }) => _then(
    Input$CreatePlayQueueInput._({
      ..._instance._$data,
      if (sourceType != _undefined && sourceType != null)
        'sourceType': (sourceType as Enum$PlayQueueSourceType),
      if (sourceId != _undefined && sourceId != null)
        'sourceId': (sourceId as String),
      if (startId != _undefined) 'startId': (startId as String?),
      if (shuffle != _undefined) 'shuffle': (shuffle as bool?),
    }),
  );
}

class _CopyWithStubImpl$Input$CreatePlayQueueInput<TRes>
    implements CopyWith$Input$CreatePlayQueueInput<TRes> {
  _CopyWithStubImpl$Input$CreatePlayQueueInput(this._res);

  TRes _res;

  call({
    Enum$PlayQueueSourceType? sourceType,
    String? sourceId,
    String? startId,
    bool? shuffle,
  }) => _res;
}

enum Enum$PlayState {
  PLAYING,
  PAUSED,
  $unknown;

  factory Enum$PlayState.fromJson(String value) =>
      fromJson$Enum$PlayState(value);

  String toJson() => toJson$Enum$PlayState(this);
}

String toJson$Enum$PlayState(Enum$PlayState e) {
  switch (e) {
    case Enum$PlayState.PLAYING:
      return r'PLAYING';
    case Enum$PlayState.PAUSED:
      return r'PAUSED';
    case Enum$PlayState.$unknown:
      return r'$unknown';
  }
}

Enum$PlayState fromJson$Enum$PlayState(String value) {
  switch (value) {
    case r'PLAYING':
      return Enum$PlayState.PLAYING;
    case r'PAUSED':
      return Enum$PlayState.PAUSED;
    default:
      return Enum$PlayState.$unknown;
  }
}

enum Enum$ServerActivityEventType {
  NODE_ACTIVITY,
  QUEUE_STATS,
  FAILURE,
  $unknown;

  factory Enum$ServerActivityEventType.fromJson(String value) =>
      fromJson$Enum$ServerActivityEventType(value);

  String toJson() => toJson$Enum$ServerActivityEventType(this);
}

String toJson$Enum$ServerActivityEventType(Enum$ServerActivityEventType e) {
  switch (e) {
    case Enum$ServerActivityEventType.NODE_ACTIVITY:
      return r'NODE_ACTIVITY';
    case Enum$ServerActivityEventType.QUEUE_STATS:
      return r'QUEUE_STATS';
    case Enum$ServerActivityEventType.FAILURE:
      return r'FAILURE';
    case Enum$ServerActivityEventType.$unknown:
      return r'$unknown';
  }
}

Enum$ServerActivityEventType fromJson$Enum$ServerActivityEventType(
  String value,
) {
  switch (value) {
    case r'NODE_ACTIVITY':
      return Enum$ServerActivityEventType.NODE_ACTIVITY;
    case r'QUEUE_STATS':
      return Enum$ServerActivityEventType.QUEUE_STATS;
    case r'FAILURE':
      return Enum$ServerActivityEventType.FAILURE;
    default:
      return Enum$ServerActivityEventType.$unknown;
  }
}

enum Enum$SortingEnum {
  DATE_CREATED,
  NAME,
  $unknown;

  factory Enum$SortingEnum.fromJson(String value) =>
      fromJson$Enum$SortingEnum(value);

  String toJson() => toJson$Enum$SortingEnum(this);
}

String toJson$Enum$SortingEnum(Enum$SortingEnum e) {
  switch (e) {
    case Enum$SortingEnum.DATE_CREATED:
      return r'DATE_CREATED';
    case Enum$SortingEnum.NAME:
      return r'NAME';
    case Enum$SortingEnum.$unknown:
      return r'$unknown';
  }
}

Enum$SortingEnum fromJson$Enum$SortingEnum(String value) {
  switch (value) {
    case r'DATE_CREATED':
      return Enum$SortingEnum.DATE_CREATED;
    case r'NAME':
      return Enum$SortingEnum.NAME;
    default:
      return Enum$SortingEnum.$unknown;
  }
}

enum Enum$SortingOrder {
  DESCENDING,
  ASCENDING,
  $unknown;

  factory Enum$SortingOrder.fromJson(String value) =>
      fromJson$Enum$SortingOrder(value);

  String toJson() => toJson$Enum$SortingOrder(this);
}

String toJson$Enum$SortingOrder(Enum$SortingOrder e) {
  switch (e) {
    case Enum$SortingOrder.DESCENDING:
      return r'DESCENDING';
    case Enum$SortingOrder.ASCENDING:
      return r'ASCENDING';
    case Enum$SortingOrder.$unknown:
      return r'$unknown';
  }
}

Enum$SortingOrder fromJson$Enum$SortingOrder(String value) {
  switch (value) {
    case r'DESCENDING':
      return Enum$SortingOrder.DESCENDING;
    case r'ASCENDING':
      return Enum$SortingOrder.ASCENDING;
    default:
      return Enum$SortingOrder.$unknown;
  }
}

enum Enum$LibraryType {
  MOVIE,
  SHOW,
  MUSIC,
  $unknown;

  factory Enum$LibraryType.fromJson(String value) =>
      fromJson$Enum$LibraryType(value);

  String toJson() => toJson$Enum$LibraryType(this);
}

String toJson$Enum$LibraryType(Enum$LibraryType e) {
  switch (e) {
    case Enum$LibraryType.MOVIE:
      return r'MOVIE';
    case Enum$LibraryType.SHOW:
      return r'SHOW';
    case Enum$LibraryType.MUSIC:
      return r'MUSIC';
    case Enum$LibraryType.$unknown:
      return r'$unknown';
  }
}

Enum$LibraryType fromJson$Enum$LibraryType(String value) {
  switch (value) {
    case r'MOVIE':
      return Enum$LibraryType.MOVIE;
    case r'SHOW':
      return Enum$LibraryType.SHOW;
    case r'MUSIC':
      return Enum$LibraryType.MUSIC;
    default:
      return Enum$LibraryType.$unknown;
  }
}

enum Enum$MediaType {
  MOVIE,
  EPISODE,
  TRACK,
  $unknown;

  factory Enum$MediaType.fromJson(String value) =>
      fromJson$Enum$MediaType(value);

  String toJson() => toJson$Enum$MediaType(this);
}

String toJson$Enum$MediaType(Enum$MediaType e) {
  switch (e) {
    case Enum$MediaType.MOVIE:
      return r'MOVIE';
    case Enum$MediaType.EPISODE:
      return r'EPISODE';
    case Enum$MediaType.TRACK:
      return r'TRACK';
    case Enum$MediaType.$unknown:
      return r'$unknown';
  }
}

Enum$MediaType fromJson$Enum$MediaType(String value) {
  switch (value) {
    case r'MOVIE':
      return Enum$MediaType.MOVIE;
    case r'EPISODE':
      return Enum$MediaType.EPISODE;
    case r'TRACK':
      return Enum$MediaType.TRACK;
    default:
      return Enum$MediaType.$unknown;
  }
}

enum Enum$PlayQueueSourceType {
  MOVIE,
  SHOW,
  ALBUM,
  LIBRARY,
  $unknown;

  factory Enum$PlayQueueSourceType.fromJson(String value) =>
      fromJson$Enum$PlayQueueSourceType(value);

  String toJson() => toJson$Enum$PlayQueueSourceType(this);
}

String toJson$Enum$PlayQueueSourceType(Enum$PlayQueueSourceType e) {
  switch (e) {
    case Enum$PlayQueueSourceType.MOVIE:
      return r'MOVIE';
    case Enum$PlayQueueSourceType.SHOW:
      return r'SHOW';
    case Enum$PlayQueueSourceType.ALBUM:
      return r'ALBUM';
    case Enum$PlayQueueSourceType.LIBRARY:
      return r'LIBRARY';
    case Enum$PlayQueueSourceType.$unknown:
      return r'$unknown';
  }
}

Enum$PlayQueueSourceType fromJson$Enum$PlayQueueSourceType(String value) {
  switch (value) {
    case r'MOVIE':
      return Enum$PlayQueueSourceType.MOVIE;
    case r'SHOW':
      return Enum$PlayQueueSourceType.SHOW;
    case r'ALBUM':
      return Enum$PlayQueueSourceType.ALBUM;
    case r'LIBRARY':
      return Enum$PlayQueueSourceType.LIBRARY;
    default:
      return Enum$PlayQueueSourceType.$unknown;
  }
}

enum Enum$SubtitleFormat {
  WEBVTT,
  SRT,
  $unknown;

  factory Enum$SubtitleFormat.fromJson(String value) =>
      fromJson$Enum$SubtitleFormat(value);

  String toJson() => toJson$Enum$SubtitleFormat(this);
}

String toJson$Enum$SubtitleFormat(Enum$SubtitleFormat e) {
  switch (e) {
    case Enum$SubtitleFormat.WEBVTT:
      return r'WEBVTT';
    case Enum$SubtitleFormat.SRT:
      return r'SRT';
    case Enum$SubtitleFormat.$unknown:
      return r'$unknown';
  }
}

Enum$SubtitleFormat fromJson$Enum$SubtitleFormat(String value) {
  switch (value) {
    case r'WEBVTT':
      return Enum$SubtitleFormat.WEBVTT;
    case r'SRT':
      return Enum$SubtitleFormat.SRT;
    default:
      return Enum$SubtitleFormat.$unknown;
  }
}

enum Enum$DirectoryType {
  LIBRARY,
  CACHE,
  $unknown;

  factory Enum$DirectoryType.fromJson(String value) =>
      fromJson$Enum$DirectoryType(value);

  String toJson() => toJson$Enum$DirectoryType(this);
}

String toJson$Enum$DirectoryType(Enum$DirectoryType e) {
  switch (e) {
    case Enum$DirectoryType.LIBRARY:
      return r'LIBRARY';
    case Enum$DirectoryType.CACHE:
      return r'CACHE';
    case Enum$DirectoryType.$unknown:
      return r'$unknown';
  }
}

Enum$DirectoryType fromJson$Enum$DirectoryType(String value) {
  switch (value) {
    case r'LIBRARY':
      return Enum$DirectoryType.LIBRARY;
    case r'CACHE':
      return Enum$DirectoryType.CACHE;
    default:
      return Enum$DirectoryType.$unknown;
  }
}

enum Enum$CreditType {
  CAST,
  GUEST_STAR,
  $unknown;

  factory Enum$CreditType.fromJson(String value) =>
      fromJson$Enum$CreditType(value);

  String toJson() => toJson$Enum$CreditType(this);
}

String toJson$Enum$CreditType(Enum$CreditType e) {
  switch (e) {
    case Enum$CreditType.CAST:
      return r'CAST';
    case Enum$CreditType.GUEST_STAR:
      return r'GUEST_STAR';
    case Enum$CreditType.$unknown:
      return r'$unknown';
  }
}

Enum$CreditType fromJson$Enum$CreditType(String value) {
  switch (value) {
    case r'CAST':
      return Enum$CreditType.CAST;
    case r'GUEST_STAR':
      return Enum$CreditType.GUEST_STAR;
    default:
      return Enum$CreditType.$unknown;
  }
}

enum Enum$__TypeKind {
  SCALAR,
  OBJECT,
  INTERFACE,
  UNION,
  ENUM,
  INPUT_OBJECT,
  LIST,
  NON_NULL,
  $unknown;

  factory Enum$__TypeKind.fromJson(String value) =>
      fromJson$Enum$__TypeKind(value);

  String toJson() => toJson$Enum$__TypeKind(this);
}

String toJson$Enum$__TypeKind(Enum$__TypeKind e) {
  switch (e) {
    case Enum$__TypeKind.SCALAR:
      return r'SCALAR';
    case Enum$__TypeKind.OBJECT:
      return r'OBJECT';
    case Enum$__TypeKind.INTERFACE:
      return r'INTERFACE';
    case Enum$__TypeKind.UNION:
      return r'UNION';
    case Enum$__TypeKind.ENUM:
      return r'ENUM';
    case Enum$__TypeKind.INPUT_OBJECT:
      return r'INPUT_OBJECT';
    case Enum$__TypeKind.LIST:
      return r'LIST';
    case Enum$__TypeKind.NON_NULL:
      return r'NON_NULL';
    case Enum$__TypeKind.$unknown:
      return r'$unknown';
  }
}

Enum$__TypeKind fromJson$Enum$__TypeKind(String value) {
  switch (value) {
    case r'SCALAR':
      return Enum$__TypeKind.SCALAR;
    case r'OBJECT':
      return Enum$__TypeKind.OBJECT;
    case r'INTERFACE':
      return Enum$__TypeKind.INTERFACE;
    case r'UNION':
      return Enum$__TypeKind.UNION;
    case r'ENUM':
      return Enum$__TypeKind.ENUM;
    case r'INPUT_OBJECT':
      return Enum$__TypeKind.INPUT_OBJECT;
    case r'LIST':
      return Enum$__TypeKind.LIST;
    case r'NON_NULL':
      return Enum$__TypeKind.NON_NULL;
    default:
      return Enum$__TypeKind.$unknown;
  }
}

enum Enum$__DirectiveLocation {
  QUERY,
  MUTATION,
  SUBSCRIPTION,
  FIELD,
  FRAGMENT_DEFINITION,
  FRAGMENT_SPREAD,
  INLINE_FRAGMENT,
  VARIABLE_DEFINITION,
  SCHEMA,
  SCALAR,
  OBJECT,
  FIELD_DEFINITION,
  ARGUMENT_DEFINITION,
  INTERFACE,
  UNION,
  ENUM,
  ENUM_VALUE,
  INPUT_OBJECT,
  INPUT_FIELD_DEFINITION,
  $unknown;

  factory Enum$__DirectiveLocation.fromJson(String value) =>
      fromJson$Enum$__DirectiveLocation(value);

  String toJson() => toJson$Enum$__DirectiveLocation(this);
}

String toJson$Enum$__DirectiveLocation(Enum$__DirectiveLocation e) {
  switch (e) {
    case Enum$__DirectiveLocation.QUERY:
      return r'QUERY';
    case Enum$__DirectiveLocation.MUTATION:
      return r'MUTATION';
    case Enum$__DirectiveLocation.SUBSCRIPTION:
      return r'SUBSCRIPTION';
    case Enum$__DirectiveLocation.FIELD:
      return r'FIELD';
    case Enum$__DirectiveLocation.FRAGMENT_DEFINITION:
      return r'FRAGMENT_DEFINITION';
    case Enum$__DirectiveLocation.FRAGMENT_SPREAD:
      return r'FRAGMENT_SPREAD';
    case Enum$__DirectiveLocation.INLINE_FRAGMENT:
      return r'INLINE_FRAGMENT';
    case Enum$__DirectiveLocation.VARIABLE_DEFINITION:
      return r'VARIABLE_DEFINITION';
    case Enum$__DirectiveLocation.SCHEMA:
      return r'SCHEMA';
    case Enum$__DirectiveLocation.SCALAR:
      return r'SCALAR';
    case Enum$__DirectiveLocation.OBJECT:
      return r'OBJECT';
    case Enum$__DirectiveLocation.FIELD_DEFINITION:
      return r'FIELD_DEFINITION';
    case Enum$__DirectiveLocation.ARGUMENT_DEFINITION:
      return r'ARGUMENT_DEFINITION';
    case Enum$__DirectiveLocation.INTERFACE:
      return r'INTERFACE';
    case Enum$__DirectiveLocation.UNION:
      return r'UNION';
    case Enum$__DirectiveLocation.ENUM:
      return r'ENUM';
    case Enum$__DirectiveLocation.ENUM_VALUE:
      return r'ENUM_VALUE';
    case Enum$__DirectiveLocation.INPUT_OBJECT:
      return r'INPUT_OBJECT';
    case Enum$__DirectiveLocation.INPUT_FIELD_DEFINITION:
      return r'INPUT_FIELD_DEFINITION';
    case Enum$__DirectiveLocation.$unknown:
      return r'$unknown';
  }
}

Enum$__DirectiveLocation fromJson$Enum$__DirectiveLocation(String value) {
  switch (value) {
    case r'QUERY':
      return Enum$__DirectiveLocation.QUERY;
    case r'MUTATION':
      return Enum$__DirectiveLocation.MUTATION;
    case r'SUBSCRIPTION':
      return Enum$__DirectiveLocation.SUBSCRIPTION;
    case r'FIELD':
      return Enum$__DirectiveLocation.FIELD;
    case r'FRAGMENT_DEFINITION':
      return Enum$__DirectiveLocation.FRAGMENT_DEFINITION;
    case r'FRAGMENT_SPREAD':
      return Enum$__DirectiveLocation.FRAGMENT_SPREAD;
    case r'INLINE_FRAGMENT':
      return Enum$__DirectiveLocation.INLINE_FRAGMENT;
    case r'VARIABLE_DEFINITION':
      return Enum$__DirectiveLocation.VARIABLE_DEFINITION;
    case r'SCHEMA':
      return Enum$__DirectiveLocation.SCHEMA;
    case r'SCALAR':
      return Enum$__DirectiveLocation.SCALAR;
    case r'OBJECT':
      return Enum$__DirectiveLocation.OBJECT;
    case r'FIELD_DEFINITION':
      return Enum$__DirectiveLocation.FIELD_DEFINITION;
    case r'ARGUMENT_DEFINITION':
      return Enum$__DirectiveLocation.ARGUMENT_DEFINITION;
    case r'INTERFACE':
      return Enum$__DirectiveLocation.INTERFACE;
    case r'UNION':
      return Enum$__DirectiveLocation.UNION;
    case r'ENUM':
      return Enum$__DirectiveLocation.ENUM;
    case r'ENUM_VALUE':
      return Enum$__DirectiveLocation.ENUM_VALUE;
    case r'INPUT_OBJECT':
      return Enum$__DirectiveLocation.INPUT_OBJECT;
    case r'INPUT_FIELD_DEFINITION':
      return Enum$__DirectiveLocation.INPUT_FIELD_DEFINITION;
    default:
      return Enum$__DirectiveLocation.$unknown;
  }
}

const possibleTypesMap = <String, Set<String>>{
  'SearchResult': {'Movie', 'Show', 'Episode', 'Person', 'Album', 'Track'},
};

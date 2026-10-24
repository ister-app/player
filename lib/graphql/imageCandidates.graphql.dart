import 'fragmentImages.graphql.dart';

import 'package:gql/ast.dart';

import 'schema.graphql.dart';

class Variables$Query$imageCandidates {
  factory Variables$Query$imageCandidates({
    required Input$ImageTargetInput target,
    required Enum$ImageType type,
  }) => Variables$Query$imageCandidates._({r'target': target, r'type': type});

  Variables$Query$imageCandidates._(this._$data);

  factory Variables$Query$imageCandidates.fromJson(Map<String, dynamic> data) {
    final result$data = <String, dynamic>{};
    final l$target = data['target'];
    result$data['target'] = Input$ImageTargetInput.fromJson(
      (l$target as Map<String, dynamic>),
    );
    final l$type = data['type'];
    result$data['type'] = fromJson$Enum$ImageType((l$type as String));
    return Variables$Query$imageCandidates._(result$data);
  }

  Map<String, dynamic> _$data;

  Input$ImageTargetInput get target =>
      (_$data['target'] as Input$ImageTargetInput);

  Enum$ImageType get type => (_$data['type'] as Enum$ImageType);

  Map<String, dynamic> toJson() {
    final result$data = <String, dynamic>{};
    final l$target = target;
    result$data['target'] = l$target.toJson();
    final l$type = type;
    result$data['type'] = toJson$Enum$ImageType(l$type);
    return result$data;
  }

  CopyWith$Variables$Query$imageCandidates<Variables$Query$imageCandidates>
  get copyWith => CopyWith$Variables$Query$imageCandidates(this, (i) => i);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Variables$Query$imageCandidates ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$target = target;
    final lOther$target = other.target;
    if (l$target != lOther$target) {
      return false;
    }
    final l$type = type;
    final lOther$type = other.type;
    if (l$type != lOther$type) {
      return false;
    }
    return true;
  }

  @override
  int get hashCode {
    final l$target = target;
    final l$type = type;
    return Object.hashAll([l$target, l$type]);
  }
}

abstract class CopyWith$Variables$Query$imageCandidates<TRes> {
  factory CopyWith$Variables$Query$imageCandidates(
    Variables$Query$imageCandidates instance,
    TRes Function(Variables$Query$imageCandidates) then,
  ) = _CopyWithImpl$Variables$Query$imageCandidates;

  factory CopyWith$Variables$Query$imageCandidates.stub(TRes res) =
      _CopyWithStubImpl$Variables$Query$imageCandidates;

  TRes call({Input$ImageTargetInput? target, Enum$ImageType? type});
}

class _CopyWithImpl$Variables$Query$imageCandidates<TRes>
    implements CopyWith$Variables$Query$imageCandidates<TRes> {
  _CopyWithImpl$Variables$Query$imageCandidates(this._instance, this._then);

  final Variables$Query$imageCandidates _instance;

  final TRes Function(Variables$Query$imageCandidates) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({Object? target = _undefined, Object? type = _undefined}) => _then(
    Variables$Query$imageCandidates._({
      ..._instance._$data,
      if (target != _undefined && target != null)
        'target': (target as Input$ImageTargetInput),
      if (type != _undefined && type != null) 'type': (type as Enum$ImageType),
    }),
  );
}

class _CopyWithStubImpl$Variables$Query$imageCandidates<TRes>
    implements CopyWith$Variables$Query$imageCandidates<TRes> {
  _CopyWithStubImpl$Variables$Query$imageCandidates(this._res);

  TRes _res;

  call({Input$ImageTargetInput? target, Enum$ImageType? type}) => _res;
}

class Query$imageCandidates {
  Query$imageCandidates({
    required this.imageCandidates,
    this.$__typename = 'Query',
  });

  factory Query$imageCandidates.fromJson(Map<String, dynamic> json) {
    final l$imageCandidates = json['imageCandidates'];
    final l$$__typename = json['__typename'];
    return Query$imageCandidates(
      imageCandidates: Query$imageCandidates$imageCandidates.fromJson(
        (l$imageCandidates as Map<String, dynamic>),
      ),
      $__typename: (l$$__typename as String),
    );
  }

  final Query$imageCandidates$imageCandidates imageCandidates;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$imageCandidates = imageCandidates;
    _resultData['imageCandidates'] = l$imageCandidates.toJson();
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$imageCandidates = imageCandidates;
    final l$$__typename = $__typename;
    return Object.hashAll([l$imageCandidates, l$$__typename]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Query$imageCandidates || runtimeType != other.runtimeType) {
      return false;
    }
    final l$imageCandidates = imageCandidates;
    final lOther$imageCandidates = other.imageCandidates;
    if (l$imageCandidates != lOther$imageCandidates) {
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

extension UtilityExtension$Query$imageCandidates on Query$imageCandidates {
  CopyWith$Query$imageCandidates<Query$imageCandidates> get copyWith =>
      CopyWith$Query$imageCandidates(this, (i) => i);
}

abstract class CopyWith$Query$imageCandidates<TRes> {
  factory CopyWith$Query$imageCandidates(
    Query$imageCandidates instance,
    TRes Function(Query$imageCandidates) then,
  ) = _CopyWithImpl$Query$imageCandidates;

  factory CopyWith$Query$imageCandidates.stub(TRes res) =
      _CopyWithStubImpl$Query$imageCandidates;

  TRes call({
    Query$imageCandidates$imageCandidates? imageCandidates,
    String? $__typename,
  });
  CopyWith$Query$imageCandidates$imageCandidates<TRes> get imageCandidates;
}

class _CopyWithImpl$Query$imageCandidates<TRes>
    implements CopyWith$Query$imageCandidates<TRes> {
  _CopyWithImpl$Query$imageCandidates(this._instance, this._then);

  final Query$imageCandidates _instance;

  final TRes Function(Query$imageCandidates) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? imageCandidates = _undefined,
    Object? $__typename = _undefined,
  }) => _then(
    Query$imageCandidates(
      imageCandidates: imageCandidates == _undefined || imageCandidates == null
          ? _instance.imageCandidates
          : (imageCandidates as Query$imageCandidates$imageCandidates),
      $__typename: $__typename == _undefined || $__typename == null
          ? _instance.$__typename
          : ($__typename as String),
    ),
  );

  CopyWith$Query$imageCandidates$imageCandidates<TRes> get imageCandidates {
    final local$imageCandidates = _instance.imageCandidates;
    return CopyWith$Query$imageCandidates$imageCandidates(
      local$imageCandidates,
      (e) => call(imageCandidates: e),
    );
  }
}

class _CopyWithStubImpl$Query$imageCandidates<TRes>
    implements CopyWith$Query$imageCandidates<TRes> {
  _CopyWithStubImpl$Query$imageCandidates(this._res);

  TRes _res;

  call({
    Query$imageCandidates$imageCandidates? imageCandidates,
    String? $__typename,
  }) => _res;

  CopyWith$Query$imageCandidates$imageCandidates<TRes> get imageCandidates =>
      CopyWith$Query$imageCandidates$imageCandidates.stub(_res);
}

const documentNodeQueryimageCandidates = DocumentNode(
  definitions: [
    OperationDefinitionNode(
      type: OperationType.query,
      name: NameNode(value: 'imageCandidates'),
      variableDefinitions: [
        VariableDefinitionNode(
          variable: VariableNode(name: NameNode(value: 'target')),
          type: NamedTypeNode(
            name: NameNode(value: 'ImageTargetInput'),
            isNonNull: true,
          ),
          defaultValue: DefaultValueNode(value: null),
          directives: [],
        ),
        VariableDefinitionNode(
          variable: VariableNode(name: NameNode(value: 'type')),
          type: NamedTypeNode(
            name: NameNode(value: 'ImageType'),
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
            name: NameNode(value: 'imageCandidates'),
            alias: null,
            arguments: [
              ArgumentNode(
                name: NameNode(value: 'target'),
                value: VariableNode(name: NameNode(value: 'target')),
              ),
              ArgumentNode(
                name: NameNode(value: 'type'),
                value: VariableNode(name: NameNode(value: 'type')),
              ),
            ],
            directives: [],
            selectionSet: SelectionSetNode(
              selections: [
                FieldNode(
                  name: NameNode(value: 'current'),
                  alias: null,
                  arguments: [],
                  directives: [],
                  selectionSet: SelectionSetNode(
                    selections: [
                      FragmentSpreadNode(
                        name: NameNode(value: 'fragmentImages'),
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
                  name: NameNode(value: 'remote'),
                  alias: null,
                  arguments: [],
                  directives: [],
                  selectionSet: SelectionSetNode(
                    selections: [
                      FieldNode(
                        name: NameNode(value: 'previewUrl'),
                        alias: null,
                        arguments: [],
                        directives: [],
                        selectionSet: null,
                      ),
                      FieldNode(
                        name: NameNode(value: 'sourceUri'),
                        alias: null,
                        arguments: [],
                        directives: [],
                        selectionSet: null,
                      ),
                      FieldNode(
                        name: NameNode(value: 'source'),
                        alias: null,
                        arguments: [],
                        directives: [],
                        selectionSet: null,
                      ),
                      FieldNode(
                        name: NameNode(value: 'width'),
                        alias: null,
                        arguments: [],
                        directives: [],
                        selectionSet: null,
                      ),
                      FieldNode(
                        name: NameNode(value: 'height'),
                        alias: null,
                        arguments: [],
                        directives: [],
                        selectionSet: null,
                      ),
                      FieldNode(
                        name: NameNode(value: 'language'),
                        alias: null,
                        arguments: [],
                        directives: [],
                        selectionSet: null,
                      ),
                      FieldNode(
                        name: NameNode(value: 'score'),
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
    fragmentDefinitionfragmentImages,
  ],
);

class Query$imageCandidates$imageCandidates {
  Query$imageCandidates$imageCandidates({
    required this.current,
    required this.remote,
    this.$__typename = 'ImageCandidates',
  });

  factory Query$imageCandidates$imageCandidates.fromJson(
    Map<String, dynamic> json,
  ) {
    final l$current = json['current'];
    final l$remote = json['remote'];
    final l$$__typename = json['__typename'];
    return Query$imageCandidates$imageCandidates(
      current: (l$current as List<dynamic>)
          .map(
            (e) =>
                Fragment$fragmentImages.fromJson((e as Map<String, dynamic>)),
          )
          .toList(),
      remote: (l$remote as List<dynamic>)
          .map(
            (e) => Query$imageCandidates$imageCandidates$remote.fromJson(
              (e as Map<String, dynamic>),
            ),
          )
          .toList(),
      $__typename: (l$$__typename as String),
    );
  }

  final List<Fragment$fragmentImages> current;

  final List<Query$imageCandidates$imageCandidates$remote> remote;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$current = current;
    _resultData['current'] = l$current.map((e) => e.toJson()).toList();
    final l$remote = remote;
    _resultData['remote'] = l$remote.map((e) => e.toJson()).toList();
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$current = current;
    final l$remote = remote;
    final l$$__typename = $__typename;
    return Object.hashAll([
      Object.hashAll(l$current.map((v) => v)),
      Object.hashAll(l$remote.map((v) => v)),
      l$$__typename,
    ]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Query$imageCandidates$imageCandidates ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$current = current;
    final lOther$current = other.current;
    if (l$current.length != lOther$current.length) {
      return false;
    }
    for (int i = 0; i < l$current.length; i++) {
      final l$current$entry = l$current[i];
      final lOther$current$entry = lOther$current[i];
      if (l$current$entry != lOther$current$entry) {
        return false;
      }
    }
    final l$remote = remote;
    final lOther$remote = other.remote;
    if (l$remote.length != lOther$remote.length) {
      return false;
    }
    for (int i = 0; i < l$remote.length; i++) {
      final l$remote$entry = l$remote[i];
      final lOther$remote$entry = lOther$remote[i];
      if (l$remote$entry != lOther$remote$entry) {
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

extension UtilityExtension$Query$imageCandidates$imageCandidates
    on Query$imageCandidates$imageCandidates {
  CopyWith$Query$imageCandidates$imageCandidates<
    Query$imageCandidates$imageCandidates
  >
  get copyWith =>
      CopyWith$Query$imageCandidates$imageCandidates(this, (i) => i);
}

abstract class CopyWith$Query$imageCandidates$imageCandidates<TRes> {
  factory CopyWith$Query$imageCandidates$imageCandidates(
    Query$imageCandidates$imageCandidates instance,
    TRes Function(Query$imageCandidates$imageCandidates) then,
  ) = _CopyWithImpl$Query$imageCandidates$imageCandidates;

  factory CopyWith$Query$imageCandidates$imageCandidates.stub(TRes res) =
      _CopyWithStubImpl$Query$imageCandidates$imageCandidates;

  TRes call({
    List<Fragment$fragmentImages>? current,
    List<Query$imageCandidates$imageCandidates$remote>? remote,
    String? $__typename,
  });
  TRes current(
    Iterable<Fragment$fragmentImages> Function(
      Iterable<CopyWith$Fragment$fragmentImages<Fragment$fragmentImages>>,
    )
    _fn,
  );
  TRes remote(
    Iterable<Query$imageCandidates$imageCandidates$remote> Function(
      Iterable<
        CopyWith$Query$imageCandidates$imageCandidates$remote<
          Query$imageCandidates$imageCandidates$remote
        >
      >,
    )
    _fn,
  );
}

class _CopyWithImpl$Query$imageCandidates$imageCandidates<TRes>
    implements CopyWith$Query$imageCandidates$imageCandidates<TRes> {
  _CopyWithImpl$Query$imageCandidates$imageCandidates(
    this._instance,
    this._then,
  );

  final Query$imageCandidates$imageCandidates _instance;

  final TRes Function(Query$imageCandidates$imageCandidates) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? current = _undefined,
    Object? remote = _undefined,
    Object? $__typename = _undefined,
  }) => _then(
    Query$imageCandidates$imageCandidates(
      current: current == _undefined || current == null
          ? _instance.current
          : (current as List<Fragment$fragmentImages>),
      remote: remote == _undefined || remote == null
          ? _instance.remote
          : (remote as List<Query$imageCandidates$imageCandidates$remote>),
      $__typename: $__typename == _undefined || $__typename == null
          ? _instance.$__typename
          : ($__typename as String),
    ),
  );

  TRes current(
    Iterable<Fragment$fragmentImages> Function(
      Iterable<CopyWith$Fragment$fragmentImages<Fragment$fragmentImages>>,
    )
    _fn,
  ) => call(
    current: _fn(
      _instance.current.map(
        (e) => CopyWith$Fragment$fragmentImages(e, (i) => i),
      ),
    ).toList(),
  );

  TRes remote(
    Iterable<Query$imageCandidates$imageCandidates$remote> Function(
      Iterable<
        CopyWith$Query$imageCandidates$imageCandidates$remote<
          Query$imageCandidates$imageCandidates$remote
        >
      >,
    )
    _fn,
  ) => call(
    remote: _fn(
      _instance.remote.map(
        (e) =>
            CopyWith$Query$imageCandidates$imageCandidates$remote(e, (i) => i),
      ),
    ).toList(),
  );
}

class _CopyWithStubImpl$Query$imageCandidates$imageCandidates<TRes>
    implements CopyWith$Query$imageCandidates$imageCandidates<TRes> {
  _CopyWithStubImpl$Query$imageCandidates$imageCandidates(this._res);

  TRes _res;

  call({
    List<Fragment$fragmentImages>? current,
    List<Query$imageCandidates$imageCandidates$remote>? remote,
    String? $__typename,
  }) => _res;

  current(_fn) => _res;

  remote(_fn) => _res;
}

class Query$imageCandidates$imageCandidates$remote {
  Query$imageCandidates$imageCandidates$remote({
    required this.previewUrl,
    required this.sourceUri,
    required this.source,
    this.width,
    this.height,
    this.language,
    this.score,
    this.$__typename = 'RemoteImageCandidate',
  });

  factory Query$imageCandidates$imageCandidates$remote.fromJson(
    Map<String, dynamic> json,
  ) {
    final l$previewUrl = json['previewUrl'];
    final l$sourceUri = json['sourceUri'];
    final l$source = json['source'];
    final l$width = json['width'];
    final l$height = json['height'];
    final l$language = json['language'];
    final l$score = json['score'];
    final l$$__typename = json['__typename'];
    return Query$imageCandidates$imageCandidates$remote(
      previewUrl: (l$previewUrl as String),
      sourceUri: (l$sourceUri as String),
      source: fromJson$Enum$MetadataSource((l$source as String)),
      width: (l$width as int?),
      height: (l$height as int?),
      language: (l$language as String?),
      score: (l$score as num?)?.toDouble(),
      $__typename: (l$$__typename as String),
    );
  }

  final String previewUrl;

  final String sourceUri;

  final Enum$MetadataSource source;

  final int? width;

  final int? height;

  final String? language;

  final double? score;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$previewUrl = previewUrl;
    _resultData['previewUrl'] = l$previewUrl;
    final l$sourceUri = sourceUri;
    _resultData['sourceUri'] = l$sourceUri;
    final l$source = source;
    _resultData['source'] = toJson$Enum$MetadataSource(l$source);
    final l$width = width;
    _resultData['width'] = l$width;
    final l$height = height;
    _resultData['height'] = l$height;
    final l$language = language;
    _resultData['language'] = l$language;
    final l$score = score;
    _resultData['score'] = l$score;
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$previewUrl = previewUrl;
    final l$sourceUri = sourceUri;
    final l$source = source;
    final l$width = width;
    final l$height = height;
    final l$language = language;
    final l$score = score;
    final l$$__typename = $__typename;
    return Object.hashAll([
      l$previewUrl,
      l$sourceUri,
      l$source,
      l$width,
      l$height,
      l$language,
      l$score,
      l$$__typename,
    ]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Query$imageCandidates$imageCandidates$remote ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$previewUrl = previewUrl;
    final lOther$previewUrl = other.previewUrl;
    if (l$previewUrl != lOther$previewUrl) {
      return false;
    }
    final l$sourceUri = sourceUri;
    final lOther$sourceUri = other.sourceUri;
    if (l$sourceUri != lOther$sourceUri) {
      return false;
    }
    final l$source = source;
    final lOther$source = other.source;
    if (l$source != lOther$source) {
      return false;
    }
    final l$width = width;
    final lOther$width = other.width;
    if (l$width != lOther$width) {
      return false;
    }
    final l$height = height;
    final lOther$height = other.height;
    if (l$height != lOther$height) {
      return false;
    }
    final l$language = language;
    final lOther$language = other.language;
    if (l$language != lOther$language) {
      return false;
    }
    final l$score = score;
    final lOther$score = other.score;
    if (l$score != lOther$score) {
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

extension UtilityExtension$Query$imageCandidates$imageCandidates$remote
    on Query$imageCandidates$imageCandidates$remote {
  CopyWith$Query$imageCandidates$imageCandidates$remote<
    Query$imageCandidates$imageCandidates$remote
  >
  get copyWith =>
      CopyWith$Query$imageCandidates$imageCandidates$remote(this, (i) => i);
}

abstract class CopyWith$Query$imageCandidates$imageCandidates$remote<TRes> {
  factory CopyWith$Query$imageCandidates$imageCandidates$remote(
    Query$imageCandidates$imageCandidates$remote instance,
    TRes Function(Query$imageCandidates$imageCandidates$remote) then,
  ) = _CopyWithImpl$Query$imageCandidates$imageCandidates$remote;

  factory CopyWith$Query$imageCandidates$imageCandidates$remote.stub(TRes res) =
      _CopyWithStubImpl$Query$imageCandidates$imageCandidates$remote;

  TRes call({
    String? previewUrl,
    String? sourceUri,
    Enum$MetadataSource? source,
    int? width,
    int? height,
    String? language,
    double? score,
    String? $__typename,
  });
}

class _CopyWithImpl$Query$imageCandidates$imageCandidates$remote<TRes>
    implements CopyWith$Query$imageCandidates$imageCandidates$remote<TRes> {
  _CopyWithImpl$Query$imageCandidates$imageCandidates$remote(
    this._instance,
    this._then,
  );

  final Query$imageCandidates$imageCandidates$remote _instance;

  final TRes Function(Query$imageCandidates$imageCandidates$remote) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? previewUrl = _undefined,
    Object? sourceUri = _undefined,
    Object? source = _undefined,
    Object? width = _undefined,
    Object? height = _undefined,
    Object? language = _undefined,
    Object? score = _undefined,
    Object? $__typename = _undefined,
  }) => _then(
    Query$imageCandidates$imageCandidates$remote(
      previewUrl: previewUrl == _undefined || previewUrl == null
          ? _instance.previewUrl
          : (previewUrl as String),
      sourceUri: sourceUri == _undefined || sourceUri == null
          ? _instance.sourceUri
          : (sourceUri as String),
      source: source == _undefined || source == null
          ? _instance.source
          : (source as Enum$MetadataSource),
      width: width == _undefined ? _instance.width : (width as int?),
      height: height == _undefined ? _instance.height : (height as int?),
      language: language == _undefined
          ? _instance.language
          : (language as String?),
      score: score == _undefined ? _instance.score : (score as double?),
      $__typename: $__typename == _undefined || $__typename == null
          ? _instance.$__typename
          : ($__typename as String),
    ),
  );
}

class _CopyWithStubImpl$Query$imageCandidates$imageCandidates$remote<TRes>
    implements CopyWith$Query$imageCandidates$imageCandidates$remote<TRes> {
  _CopyWithStubImpl$Query$imageCandidates$imageCandidates$remote(this._res);

  TRes _res;

  call({
    String? previewUrl,
    String? sourceUri,
    Enum$MetadataSource? source,
    int? width,
    int? height,
    String? language,
    double? score,
    String? $__typename,
  }) => _res;
}

import 'package:gql/ast.dart';

class Mutation$createStreamTokenMutation {
  Mutation$createStreamTokenMutation({
    required this.createStreamToken,
    this.$__typename = 'Mutation',
  });

  factory Mutation$createStreamTokenMutation.fromJson(
    Map<String, dynamic> json,
  ) {
    final l$createStreamToken = json['createStreamToken'];
    final l$$__typename = json['__typename'];
    return Mutation$createStreamTokenMutation(
      createStreamToken:
          Mutation$createStreamTokenMutation$createStreamToken.fromJson(
            (l$createStreamToken as Map<String, dynamic>),
          ),
      $__typename: (l$$__typename as String),
    );
  }

  final Mutation$createStreamTokenMutation$createStreamToken createStreamToken;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$createStreamToken = createStreamToken;
    _resultData['createStreamToken'] = l$createStreamToken.toJson();
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$createStreamToken = createStreamToken;
    final l$$__typename = $__typename;
    return Object.hashAll([l$createStreamToken, l$$__typename]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Mutation$createStreamTokenMutation ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$createStreamToken = createStreamToken;
    final lOther$createStreamToken = other.createStreamToken;
    if (l$createStreamToken != lOther$createStreamToken) {
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

extension UtilityExtension$Mutation$createStreamTokenMutation
    on Mutation$createStreamTokenMutation {
  CopyWith$Mutation$createStreamTokenMutation<
    Mutation$createStreamTokenMutation
  >
  get copyWith => CopyWith$Mutation$createStreamTokenMutation(this, (i) => i);
}

abstract class CopyWith$Mutation$createStreamTokenMutation<TRes> {
  factory CopyWith$Mutation$createStreamTokenMutation(
    Mutation$createStreamTokenMutation instance,
    TRes Function(Mutation$createStreamTokenMutation) then,
  ) = _CopyWithImpl$Mutation$createStreamTokenMutation;

  factory CopyWith$Mutation$createStreamTokenMutation.stub(TRes res) =
      _CopyWithStubImpl$Mutation$createStreamTokenMutation;

  TRes call({
    Mutation$createStreamTokenMutation$createStreamToken? createStreamToken,
    String? $__typename,
  });
  CopyWith$Mutation$createStreamTokenMutation$createStreamToken<TRes>
  get createStreamToken;
}

class _CopyWithImpl$Mutation$createStreamTokenMutation<TRes>
    implements CopyWith$Mutation$createStreamTokenMutation<TRes> {
  _CopyWithImpl$Mutation$createStreamTokenMutation(this._instance, this._then);

  final Mutation$createStreamTokenMutation _instance;

  final TRes Function(Mutation$createStreamTokenMutation) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? createStreamToken = _undefined,
    Object? $__typename = _undefined,
  }) => _then(
    Mutation$createStreamTokenMutation(
      createStreamToken:
          createStreamToken == _undefined || createStreamToken == null
          ? _instance.createStreamToken
          : (createStreamToken
                as Mutation$createStreamTokenMutation$createStreamToken),
      $__typename: $__typename == _undefined || $__typename == null
          ? _instance.$__typename
          : ($__typename as String),
    ),
  );

  CopyWith$Mutation$createStreamTokenMutation$createStreamToken<TRes>
  get createStreamToken {
    final local$createStreamToken = _instance.createStreamToken;
    return CopyWith$Mutation$createStreamTokenMutation$createStreamToken(
      local$createStreamToken,
      (e) => call(createStreamToken: e),
    );
  }
}

class _CopyWithStubImpl$Mutation$createStreamTokenMutation<TRes>
    implements CopyWith$Mutation$createStreamTokenMutation<TRes> {
  _CopyWithStubImpl$Mutation$createStreamTokenMutation(this._res);

  TRes _res;

  call({
    Mutation$createStreamTokenMutation$createStreamToken? createStreamToken,
    String? $__typename,
  }) => _res;

  CopyWith$Mutation$createStreamTokenMutation$createStreamToken<TRes>
  get createStreamToken =>
      CopyWith$Mutation$createStreamTokenMutation$createStreamToken.stub(_res);
}

const documentNodeMutationcreateStreamTokenMutation = DocumentNode(
  definitions: [
    OperationDefinitionNode(
      type: OperationType.mutation,
      name: NameNode(value: 'createStreamTokenMutation'),
      variableDefinitions: [],
      directives: [],
      selectionSet: SelectionSetNode(
        selections: [
          FieldNode(
            name: NameNode(value: 'createStreamToken'),
            alias: null,
            arguments: [],
            directives: [],
            selectionSet: SelectionSetNode(
              selections: [
                FieldNode(
                  name: NameNode(value: 'token'),
                  alias: null,
                  arguments: [],
                  directives: [],
                  selectionSet: null,
                ),
                FieldNode(
                  name: NameNode(value: 'expiresAt'),
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
  ],
);

class Mutation$createStreamTokenMutation$createStreamToken {
  Mutation$createStreamTokenMutation$createStreamToken({
    required this.token,
    required this.expiresAt,
    this.$__typename = 'StreamToken',
  });

  factory Mutation$createStreamTokenMutation$createStreamToken.fromJson(
    Map<String, dynamic> json,
  ) {
    final l$token = json['token'];
    final l$expiresAt = json['expiresAt'];
    final l$$__typename = json['__typename'];
    return Mutation$createStreamTokenMutation$createStreamToken(
      token: (l$token as String),
      expiresAt: (l$expiresAt as String),
      $__typename: (l$$__typename as String),
    );
  }

  final String token;

  final String expiresAt;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$token = token;
    _resultData['token'] = l$token;
    final l$expiresAt = expiresAt;
    _resultData['expiresAt'] = l$expiresAt;
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$token = token;
    final l$expiresAt = expiresAt;
    final l$$__typename = $__typename;
    return Object.hashAll([l$token, l$expiresAt, l$$__typename]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Mutation$createStreamTokenMutation$createStreamToken ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$token = token;
    final lOther$token = other.token;
    if (l$token != lOther$token) {
      return false;
    }
    final l$expiresAt = expiresAt;
    final lOther$expiresAt = other.expiresAt;
    if (l$expiresAt != lOther$expiresAt) {
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

extension UtilityExtension$Mutation$createStreamTokenMutation$createStreamToken
    on Mutation$createStreamTokenMutation$createStreamToken {
  CopyWith$Mutation$createStreamTokenMutation$createStreamToken<
    Mutation$createStreamTokenMutation$createStreamToken
  >
  get copyWith => CopyWith$Mutation$createStreamTokenMutation$createStreamToken(
    this,
    (i) => i,
  );
}

abstract class CopyWith$Mutation$createStreamTokenMutation$createStreamToken<
  TRes
> {
  factory CopyWith$Mutation$createStreamTokenMutation$createStreamToken(
    Mutation$createStreamTokenMutation$createStreamToken instance,
    TRes Function(Mutation$createStreamTokenMutation$createStreamToken) then,
  ) = _CopyWithImpl$Mutation$createStreamTokenMutation$createStreamToken;

  factory CopyWith$Mutation$createStreamTokenMutation$createStreamToken.stub(
    TRes res,
  ) = _CopyWithStubImpl$Mutation$createStreamTokenMutation$createStreamToken;

  TRes call({String? token, String? expiresAt, String? $__typename});
}

class _CopyWithImpl$Mutation$createStreamTokenMutation$createStreamToken<TRes>
    implements
        CopyWith$Mutation$createStreamTokenMutation$createStreamToken<TRes> {
  _CopyWithImpl$Mutation$createStreamTokenMutation$createStreamToken(
    this._instance,
    this._then,
  );

  final Mutation$createStreamTokenMutation$createStreamToken _instance;

  final TRes Function(Mutation$createStreamTokenMutation$createStreamToken)
  _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? token = _undefined,
    Object? expiresAt = _undefined,
    Object? $__typename = _undefined,
  }) => _then(
    Mutation$createStreamTokenMutation$createStreamToken(
      token: token == _undefined || token == null
          ? _instance.token
          : (token as String),
      expiresAt: expiresAt == _undefined || expiresAt == null
          ? _instance.expiresAt
          : (expiresAt as String),
      $__typename: $__typename == _undefined || $__typename == null
          ? _instance.$__typename
          : ($__typename as String),
    ),
  );
}

class _CopyWithStubImpl$Mutation$createStreamTokenMutation$createStreamToken<
  TRes
>
    implements
        CopyWith$Mutation$createStreamTokenMutation$createStreamToken<TRes> {
  _CopyWithStubImpl$Mutation$createStreamTokenMutation$createStreamToken(
    this._res,
  );

  TRes _res;

  call({String? token, String? expiresAt, String? $__typename}) => _res;
}

import 'fragmentSavedView.graphql.dart';

import 'package:gql/ast.dart';

import 'schema.graphql.dart';

class Variables$Query$savedViews {
  factory Variables$Query$savedViews({
    String? libraryId,
    Enum$FilterKind? kind,
  }) => Variables$Query$savedViews._({
    if (libraryId != null) r'libraryId': libraryId,
    if (kind != null) r'kind': kind,
  });

  Variables$Query$savedViews._(this._$data);

  factory Variables$Query$savedViews.fromJson(Map<String, dynamic> data) {
    final result$data = <String, dynamic>{};
    if (data.containsKey('libraryId')) {
      final l$libraryId = data['libraryId'];
      result$data['libraryId'] = (l$libraryId as String?);
    }
    if (data.containsKey('kind')) {
      final l$kind = data['kind'];
      result$data['kind'] = l$kind == null
          ? null
          : fromJson$Enum$FilterKind((l$kind as String));
    }
    return Variables$Query$savedViews._(result$data);
  }

  Map<String, dynamic> _$data;

  String? get libraryId => (_$data['libraryId'] as String?);

  Enum$FilterKind? get kind => (_$data['kind'] as Enum$FilterKind?);

  Map<String, dynamic> toJson() {
    final result$data = <String, dynamic>{};
    if (_$data.containsKey('libraryId')) {
      final l$libraryId = libraryId;
      result$data['libraryId'] = l$libraryId;
    }
    if (_$data.containsKey('kind')) {
      final l$kind = kind;
      result$data['kind'] = l$kind == null
          ? null
          : toJson$Enum$FilterKind(l$kind);
    }
    return result$data;
  }

  CopyWith$Variables$Query$savedViews<Variables$Query$savedViews>
  get copyWith => CopyWith$Variables$Query$savedViews(this, (i) => i);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Variables$Query$savedViews ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$libraryId = libraryId;
    final lOther$libraryId = other.libraryId;
    if (_$data.containsKey('libraryId') !=
        other._$data.containsKey('libraryId')) {
      return false;
    }
    if (l$libraryId != lOther$libraryId) {
      return false;
    }
    final l$kind = kind;
    final lOther$kind = other.kind;
    if (_$data.containsKey('kind') != other._$data.containsKey('kind')) {
      return false;
    }
    if (l$kind != lOther$kind) {
      return false;
    }
    return true;
  }

  @override
  int get hashCode {
    final l$libraryId = libraryId;
    final l$kind = kind;
    return Object.hashAll([
      _$data.containsKey('libraryId') ? l$libraryId : const {},
      _$data.containsKey('kind') ? l$kind : const {},
    ]);
  }
}

abstract class CopyWith$Variables$Query$savedViews<TRes> {
  factory CopyWith$Variables$Query$savedViews(
    Variables$Query$savedViews instance,
    TRes Function(Variables$Query$savedViews) then,
  ) = _CopyWithImpl$Variables$Query$savedViews;

  factory CopyWith$Variables$Query$savedViews.stub(TRes res) =
      _CopyWithStubImpl$Variables$Query$savedViews;

  TRes call({String? libraryId, Enum$FilterKind? kind});
}

class _CopyWithImpl$Variables$Query$savedViews<TRes>
    implements CopyWith$Variables$Query$savedViews<TRes> {
  _CopyWithImpl$Variables$Query$savedViews(this._instance, this._then);

  final Variables$Query$savedViews _instance;

  final TRes Function(Variables$Query$savedViews) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({Object? libraryId = _undefined, Object? kind = _undefined}) =>
      _then(
        Variables$Query$savedViews._({
          ..._instance._$data,
          if (libraryId != _undefined) 'libraryId': (libraryId as String?),
          if (kind != _undefined) 'kind': (kind as Enum$FilterKind?),
        }),
      );
}

class _CopyWithStubImpl$Variables$Query$savedViews<TRes>
    implements CopyWith$Variables$Query$savedViews<TRes> {
  _CopyWithStubImpl$Variables$Query$savedViews(this._res);

  TRes _res;

  call({String? libraryId, Enum$FilterKind? kind}) => _res;
}

class Query$savedViews {
  Query$savedViews({required this.savedViews, this.$__typename = 'Query'});

  factory Query$savedViews.fromJson(Map<String, dynamic> json) {
    final l$savedViews = json['savedViews'];
    final l$$__typename = json['__typename'];
    return Query$savedViews(
      savedViews: (l$savedViews as List<dynamic>)
          .map(
            (e) => Fragment$fragmentSavedView.fromJson(
              (e as Map<String, dynamic>),
            ),
          )
          .toList(),
      $__typename: (l$$__typename as String),
    );
  }

  final List<Fragment$fragmentSavedView> savedViews;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$savedViews = savedViews;
    _resultData['savedViews'] = l$savedViews.map((e) => e.toJson()).toList();
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$savedViews = savedViews;
    final l$$__typename = $__typename;
    return Object.hashAll([
      Object.hashAll(l$savedViews.map((v) => v)),
      l$$__typename,
    ]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Query$savedViews || runtimeType != other.runtimeType) {
      return false;
    }
    final l$savedViews = savedViews;
    final lOther$savedViews = other.savedViews;
    if (l$savedViews.length != lOther$savedViews.length) {
      return false;
    }
    for (int i = 0; i < l$savedViews.length; i++) {
      final l$savedViews$entry = l$savedViews[i];
      final lOther$savedViews$entry = lOther$savedViews[i];
      if (l$savedViews$entry != lOther$savedViews$entry) {
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

extension UtilityExtension$Query$savedViews on Query$savedViews {
  CopyWith$Query$savedViews<Query$savedViews> get copyWith =>
      CopyWith$Query$savedViews(this, (i) => i);
}

abstract class CopyWith$Query$savedViews<TRes> {
  factory CopyWith$Query$savedViews(
    Query$savedViews instance,
    TRes Function(Query$savedViews) then,
  ) = _CopyWithImpl$Query$savedViews;

  factory CopyWith$Query$savedViews.stub(TRes res) =
      _CopyWithStubImpl$Query$savedViews;

  TRes call({
    List<Fragment$fragmentSavedView>? savedViews,
    String? $__typename,
  });
  TRes savedViews(
    Iterable<Fragment$fragmentSavedView> Function(
      Iterable<CopyWith$Fragment$fragmentSavedView<Fragment$fragmentSavedView>>,
    )
    _fn,
  );
}

class _CopyWithImpl$Query$savedViews<TRes>
    implements CopyWith$Query$savedViews<TRes> {
  _CopyWithImpl$Query$savedViews(this._instance, this._then);

  final Query$savedViews _instance;

  final TRes Function(Query$savedViews) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? savedViews = _undefined,
    Object? $__typename = _undefined,
  }) => _then(
    Query$savedViews(
      savedViews: savedViews == _undefined || savedViews == null
          ? _instance.savedViews
          : (savedViews as List<Fragment$fragmentSavedView>),
      $__typename: $__typename == _undefined || $__typename == null
          ? _instance.$__typename
          : ($__typename as String),
    ),
  );

  TRes savedViews(
    Iterable<Fragment$fragmentSavedView> Function(
      Iterable<CopyWith$Fragment$fragmentSavedView<Fragment$fragmentSavedView>>,
    )
    _fn,
  ) => call(
    savedViews: _fn(
      _instance.savedViews.map(
        (e) => CopyWith$Fragment$fragmentSavedView(e, (i) => i),
      ),
    ).toList(),
  );
}

class _CopyWithStubImpl$Query$savedViews<TRes>
    implements CopyWith$Query$savedViews<TRes> {
  _CopyWithStubImpl$Query$savedViews(this._res);

  TRes _res;

  call({List<Fragment$fragmentSavedView>? savedViews, String? $__typename}) =>
      _res;

  savedViews(_fn) => _res;
}

const documentNodeQuerysavedViews = DocumentNode(
  definitions: [
    OperationDefinitionNode(
      type: OperationType.query,
      name: NameNode(value: 'savedViews'),
      variableDefinitions: [
        VariableDefinitionNode(
          variable: VariableNode(name: NameNode(value: 'libraryId')),
          type: NamedTypeNode(name: NameNode(value: 'ID'), isNonNull: false),
          defaultValue: DefaultValueNode(value: null),
          directives: [],
        ),
        VariableDefinitionNode(
          variable: VariableNode(name: NameNode(value: 'kind')),
          type: NamedTypeNode(
            name: NameNode(value: 'FilterKind'),
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
            name: NameNode(value: 'savedViews'),
            alias: null,
            arguments: [
              ArgumentNode(
                name: NameNode(value: 'libraryId'),
                value: VariableNode(name: NameNode(value: 'libraryId')),
              ),
              ArgumentNode(
                name: NameNode(value: 'kind'),
                value: VariableNode(name: NameNode(value: 'kind')),
              ),
            ],
            directives: [],
            selectionSet: SelectionSetNode(
              selections: [
                FragmentSpreadNode(
                  name: NameNode(value: 'fragmentSavedView'),
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
    fragmentDefinitionfragmentSavedView,
  ],
);

class Variables$Mutation$createSavedView {
  factory Variables$Mutation$createSavedView({
    required Input$SavedViewInput input,
  }) => Variables$Mutation$createSavedView._({r'input': input});

  Variables$Mutation$createSavedView._(this._$data);

  factory Variables$Mutation$createSavedView.fromJson(
    Map<String, dynamic> data,
  ) {
    final result$data = <String, dynamic>{};
    final l$input = data['input'];
    result$data['input'] = Input$SavedViewInput.fromJson(
      (l$input as Map<String, dynamic>),
    );
    return Variables$Mutation$createSavedView._(result$data);
  }

  Map<String, dynamic> _$data;

  Input$SavedViewInput get input => (_$data['input'] as Input$SavedViewInput);

  Map<String, dynamic> toJson() {
    final result$data = <String, dynamic>{};
    final l$input = input;
    result$data['input'] = l$input.toJson();
    return result$data;
  }

  CopyWith$Variables$Mutation$createSavedView<
    Variables$Mutation$createSavedView
  >
  get copyWith => CopyWith$Variables$Mutation$createSavedView(this, (i) => i);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Variables$Mutation$createSavedView ||
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

abstract class CopyWith$Variables$Mutation$createSavedView<TRes> {
  factory CopyWith$Variables$Mutation$createSavedView(
    Variables$Mutation$createSavedView instance,
    TRes Function(Variables$Mutation$createSavedView) then,
  ) = _CopyWithImpl$Variables$Mutation$createSavedView;

  factory CopyWith$Variables$Mutation$createSavedView.stub(TRes res) =
      _CopyWithStubImpl$Variables$Mutation$createSavedView;

  TRes call({Input$SavedViewInput? input});
}

class _CopyWithImpl$Variables$Mutation$createSavedView<TRes>
    implements CopyWith$Variables$Mutation$createSavedView<TRes> {
  _CopyWithImpl$Variables$Mutation$createSavedView(this._instance, this._then);

  final Variables$Mutation$createSavedView _instance;

  final TRes Function(Variables$Mutation$createSavedView) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({Object? input = _undefined}) => _then(
    Variables$Mutation$createSavedView._({
      ..._instance._$data,
      if (input != _undefined && input != null)
        'input': (input as Input$SavedViewInput),
    }),
  );
}

class _CopyWithStubImpl$Variables$Mutation$createSavedView<TRes>
    implements CopyWith$Variables$Mutation$createSavedView<TRes> {
  _CopyWithStubImpl$Variables$Mutation$createSavedView(this._res);

  TRes _res;

  call({Input$SavedViewInput? input}) => _res;
}

class Mutation$createSavedView {
  Mutation$createSavedView({
    required this.createSavedView,
    this.$__typename = 'Mutation',
  });

  factory Mutation$createSavedView.fromJson(Map<String, dynamic> json) {
    final l$createSavedView = json['createSavedView'];
    final l$$__typename = json['__typename'];
    return Mutation$createSavedView(
      createSavedView: Fragment$fragmentSavedView.fromJson(
        (l$createSavedView as Map<String, dynamic>),
      ),
      $__typename: (l$$__typename as String),
    );
  }

  final Fragment$fragmentSavedView createSavedView;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$createSavedView = createSavedView;
    _resultData['createSavedView'] = l$createSavedView.toJson();
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$createSavedView = createSavedView;
    final l$$__typename = $__typename;
    return Object.hashAll([l$createSavedView, l$$__typename]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Mutation$createSavedView ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$createSavedView = createSavedView;
    final lOther$createSavedView = other.createSavedView;
    if (l$createSavedView != lOther$createSavedView) {
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

extension UtilityExtension$Mutation$createSavedView
    on Mutation$createSavedView {
  CopyWith$Mutation$createSavedView<Mutation$createSavedView> get copyWith =>
      CopyWith$Mutation$createSavedView(this, (i) => i);
}

abstract class CopyWith$Mutation$createSavedView<TRes> {
  factory CopyWith$Mutation$createSavedView(
    Mutation$createSavedView instance,
    TRes Function(Mutation$createSavedView) then,
  ) = _CopyWithImpl$Mutation$createSavedView;

  factory CopyWith$Mutation$createSavedView.stub(TRes res) =
      _CopyWithStubImpl$Mutation$createSavedView;

  TRes call({Fragment$fragmentSavedView? createSavedView, String? $__typename});
  CopyWith$Fragment$fragmentSavedView<TRes> get createSavedView;
}

class _CopyWithImpl$Mutation$createSavedView<TRes>
    implements CopyWith$Mutation$createSavedView<TRes> {
  _CopyWithImpl$Mutation$createSavedView(this._instance, this._then);

  final Mutation$createSavedView _instance;

  final TRes Function(Mutation$createSavedView) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? createSavedView = _undefined,
    Object? $__typename = _undefined,
  }) => _then(
    Mutation$createSavedView(
      createSavedView: createSavedView == _undefined || createSavedView == null
          ? _instance.createSavedView
          : (createSavedView as Fragment$fragmentSavedView),
      $__typename: $__typename == _undefined || $__typename == null
          ? _instance.$__typename
          : ($__typename as String),
    ),
  );

  CopyWith$Fragment$fragmentSavedView<TRes> get createSavedView {
    final local$createSavedView = _instance.createSavedView;
    return CopyWith$Fragment$fragmentSavedView(
      local$createSavedView,
      (e) => call(createSavedView: e),
    );
  }
}

class _CopyWithStubImpl$Mutation$createSavedView<TRes>
    implements CopyWith$Mutation$createSavedView<TRes> {
  _CopyWithStubImpl$Mutation$createSavedView(this._res);

  TRes _res;

  call({Fragment$fragmentSavedView? createSavedView, String? $__typename}) =>
      _res;

  CopyWith$Fragment$fragmentSavedView<TRes> get createSavedView =>
      CopyWith$Fragment$fragmentSavedView.stub(_res);
}

const documentNodeMutationcreateSavedView = DocumentNode(
  definitions: [
    OperationDefinitionNode(
      type: OperationType.mutation,
      name: NameNode(value: 'createSavedView'),
      variableDefinitions: [
        VariableDefinitionNode(
          variable: VariableNode(name: NameNode(value: 'input')),
          type: NamedTypeNode(
            name: NameNode(value: 'SavedViewInput'),
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
            name: NameNode(value: 'createSavedView'),
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
                  name: NameNode(value: 'fragmentSavedView'),
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
    fragmentDefinitionfragmentSavedView,
  ],
);

class Variables$Mutation$updateSavedView {
  factory Variables$Mutation$updateSavedView({
    required String id,
    required Input$SavedViewInput input,
  }) => Variables$Mutation$updateSavedView._({r'id': id, r'input': input});

  Variables$Mutation$updateSavedView._(this._$data);

  factory Variables$Mutation$updateSavedView.fromJson(
    Map<String, dynamic> data,
  ) {
    final result$data = <String, dynamic>{};
    final l$id = data['id'];
    result$data['id'] = (l$id as String);
    final l$input = data['input'];
    result$data['input'] = Input$SavedViewInput.fromJson(
      (l$input as Map<String, dynamic>),
    );
    return Variables$Mutation$updateSavedView._(result$data);
  }

  Map<String, dynamic> _$data;

  String get id => (_$data['id'] as String);

  Input$SavedViewInput get input => (_$data['input'] as Input$SavedViewInput);

  Map<String, dynamic> toJson() {
    final result$data = <String, dynamic>{};
    final l$id = id;
    result$data['id'] = l$id;
    final l$input = input;
    result$data['input'] = l$input.toJson();
    return result$data;
  }

  CopyWith$Variables$Mutation$updateSavedView<
    Variables$Mutation$updateSavedView
  >
  get copyWith => CopyWith$Variables$Mutation$updateSavedView(this, (i) => i);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Variables$Mutation$updateSavedView ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$id = id;
    final lOther$id = other.id;
    if (l$id != lOther$id) {
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
    final l$id = id;
    final l$input = input;
    return Object.hashAll([l$id, l$input]);
  }
}

abstract class CopyWith$Variables$Mutation$updateSavedView<TRes> {
  factory CopyWith$Variables$Mutation$updateSavedView(
    Variables$Mutation$updateSavedView instance,
    TRes Function(Variables$Mutation$updateSavedView) then,
  ) = _CopyWithImpl$Variables$Mutation$updateSavedView;

  factory CopyWith$Variables$Mutation$updateSavedView.stub(TRes res) =
      _CopyWithStubImpl$Variables$Mutation$updateSavedView;

  TRes call({String? id, Input$SavedViewInput? input});
}

class _CopyWithImpl$Variables$Mutation$updateSavedView<TRes>
    implements CopyWith$Variables$Mutation$updateSavedView<TRes> {
  _CopyWithImpl$Variables$Mutation$updateSavedView(this._instance, this._then);

  final Variables$Mutation$updateSavedView _instance;

  final TRes Function(Variables$Mutation$updateSavedView) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({Object? id = _undefined, Object? input = _undefined}) => _then(
    Variables$Mutation$updateSavedView._({
      ..._instance._$data,
      if (id != _undefined && id != null) 'id': (id as String),
      if (input != _undefined && input != null)
        'input': (input as Input$SavedViewInput),
    }),
  );
}

class _CopyWithStubImpl$Variables$Mutation$updateSavedView<TRes>
    implements CopyWith$Variables$Mutation$updateSavedView<TRes> {
  _CopyWithStubImpl$Variables$Mutation$updateSavedView(this._res);

  TRes _res;

  call({String? id, Input$SavedViewInput? input}) => _res;
}

class Mutation$updateSavedView {
  Mutation$updateSavedView({
    required this.updateSavedView,
    this.$__typename = 'Mutation',
  });

  factory Mutation$updateSavedView.fromJson(Map<String, dynamic> json) {
    final l$updateSavedView = json['updateSavedView'];
    final l$$__typename = json['__typename'];
    return Mutation$updateSavedView(
      updateSavedView: Fragment$fragmentSavedView.fromJson(
        (l$updateSavedView as Map<String, dynamic>),
      ),
      $__typename: (l$$__typename as String),
    );
  }

  final Fragment$fragmentSavedView updateSavedView;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$updateSavedView = updateSavedView;
    _resultData['updateSavedView'] = l$updateSavedView.toJson();
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$updateSavedView = updateSavedView;
    final l$$__typename = $__typename;
    return Object.hashAll([l$updateSavedView, l$$__typename]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Mutation$updateSavedView ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$updateSavedView = updateSavedView;
    final lOther$updateSavedView = other.updateSavedView;
    if (l$updateSavedView != lOther$updateSavedView) {
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

extension UtilityExtension$Mutation$updateSavedView
    on Mutation$updateSavedView {
  CopyWith$Mutation$updateSavedView<Mutation$updateSavedView> get copyWith =>
      CopyWith$Mutation$updateSavedView(this, (i) => i);
}

abstract class CopyWith$Mutation$updateSavedView<TRes> {
  factory CopyWith$Mutation$updateSavedView(
    Mutation$updateSavedView instance,
    TRes Function(Mutation$updateSavedView) then,
  ) = _CopyWithImpl$Mutation$updateSavedView;

  factory CopyWith$Mutation$updateSavedView.stub(TRes res) =
      _CopyWithStubImpl$Mutation$updateSavedView;

  TRes call({Fragment$fragmentSavedView? updateSavedView, String? $__typename});
  CopyWith$Fragment$fragmentSavedView<TRes> get updateSavedView;
}

class _CopyWithImpl$Mutation$updateSavedView<TRes>
    implements CopyWith$Mutation$updateSavedView<TRes> {
  _CopyWithImpl$Mutation$updateSavedView(this._instance, this._then);

  final Mutation$updateSavedView _instance;

  final TRes Function(Mutation$updateSavedView) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? updateSavedView = _undefined,
    Object? $__typename = _undefined,
  }) => _then(
    Mutation$updateSavedView(
      updateSavedView: updateSavedView == _undefined || updateSavedView == null
          ? _instance.updateSavedView
          : (updateSavedView as Fragment$fragmentSavedView),
      $__typename: $__typename == _undefined || $__typename == null
          ? _instance.$__typename
          : ($__typename as String),
    ),
  );

  CopyWith$Fragment$fragmentSavedView<TRes> get updateSavedView {
    final local$updateSavedView = _instance.updateSavedView;
    return CopyWith$Fragment$fragmentSavedView(
      local$updateSavedView,
      (e) => call(updateSavedView: e),
    );
  }
}

class _CopyWithStubImpl$Mutation$updateSavedView<TRes>
    implements CopyWith$Mutation$updateSavedView<TRes> {
  _CopyWithStubImpl$Mutation$updateSavedView(this._res);

  TRes _res;

  call({Fragment$fragmentSavedView? updateSavedView, String? $__typename}) =>
      _res;

  CopyWith$Fragment$fragmentSavedView<TRes> get updateSavedView =>
      CopyWith$Fragment$fragmentSavedView.stub(_res);
}

const documentNodeMutationupdateSavedView = DocumentNode(
  definitions: [
    OperationDefinitionNode(
      type: OperationType.mutation,
      name: NameNode(value: 'updateSavedView'),
      variableDefinitions: [
        VariableDefinitionNode(
          variable: VariableNode(name: NameNode(value: 'id')),
          type: NamedTypeNode(name: NameNode(value: 'ID'), isNonNull: true),
          defaultValue: DefaultValueNode(value: null),
          directives: [],
        ),
        VariableDefinitionNode(
          variable: VariableNode(name: NameNode(value: 'input')),
          type: NamedTypeNode(
            name: NameNode(value: 'SavedViewInput'),
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
            name: NameNode(value: 'updateSavedView'),
            alias: null,
            arguments: [
              ArgumentNode(
                name: NameNode(value: 'id'),
                value: VariableNode(name: NameNode(value: 'id')),
              ),
              ArgumentNode(
                name: NameNode(value: 'input'),
                value: VariableNode(name: NameNode(value: 'input')),
              ),
            ],
            directives: [],
            selectionSet: SelectionSetNode(
              selections: [
                FragmentSpreadNode(
                  name: NameNode(value: 'fragmentSavedView'),
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
    fragmentDefinitionfragmentSavedView,
  ],
);

class Variables$Mutation$deleteSavedView {
  factory Variables$Mutation$deleteSavedView({required String id}) =>
      Variables$Mutation$deleteSavedView._({r'id': id});

  Variables$Mutation$deleteSavedView._(this._$data);

  factory Variables$Mutation$deleteSavedView.fromJson(
    Map<String, dynamic> data,
  ) {
    final result$data = <String, dynamic>{};
    final l$id = data['id'];
    result$data['id'] = (l$id as String);
    return Variables$Mutation$deleteSavedView._(result$data);
  }

  Map<String, dynamic> _$data;

  String get id => (_$data['id'] as String);

  Map<String, dynamic> toJson() {
    final result$data = <String, dynamic>{};
    final l$id = id;
    result$data['id'] = l$id;
    return result$data;
  }

  CopyWith$Variables$Mutation$deleteSavedView<
    Variables$Mutation$deleteSavedView
  >
  get copyWith => CopyWith$Variables$Mutation$deleteSavedView(this, (i) => i);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Variables$Mutation$deleteSavedView ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$id = id;
    final lOther$id = other.id;
    if (l$id != lOther$id) {
      return false;
    }
    return true;
  }

  @override
  int get hashCode {
    final l$id = id;
    return Object.hashAll([l$id]);
  }
}

abstract class CopyWith$Variables$Mutation$deleteSavedView<TRes> {
  factory CopyWith$Variables$Mutation$deleteSavedView(
    Variables$Mutation$deleteSavedView instance,
    TRes Function(Variables$Mutation$deleteSavedView) then,
  ) = _CopyWithImpl$Variables$Mutation$deleteSavedView;

  factory CopyWith$Variables$Mutation$deleteSavedView.stub(TRes res) =
      _CopyWithStubImpl$Variables$Mutation$deleteSavedView;

  TRes call({String? id});
}

class _CopyWithImpl$Variables$Mutation$deleteSavedView<TRes>
    implements CopyWith$Variables$Mutation$deleteSavedView<TRes> {
  _CopyWithImpl$Variables$Mutation$deleteSavedView(this._instance, this._then);

  final Variables$Mutation$deleteSavedView _instance;

  final TRes Function(Variables$Mutation$deleteSavedView) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({Object? id = _undefined}) => _then(
    Variables$Mutation$deleteSavedView._({
      ..._instance._$data,
      if (id != _undefined && id != null) 'id': (id as String),
    }),
  );
}

class _CopyWithStubImpl$Variables$Mutation$deleteSavedView<TRes>
    implements CopyWith$Variables$Mutation$deleteSavedView<TRes> {
  _CopyWithStubImpl$Variables$Mutation$deleteSavedView(this._res);

  TRes _res;

  call({String? id}) => _res;
}

class Mutation$deleteSavedView {
  Mutation$deleteSavedView({
    required this.deleteSavedView,
    this.$__typename = 'Mutation',
  });

  factory Mutation$deleteSavedView.fromJson(Map<String, dynamic> json) {
    final l$deleteSavedView = json['deleteSavedView'];
    final l$$__typename = json['__typename'];
    return Mutation$deleteSavedView(
      deleteSavedView: (l$deleteSavedView as bool),
      $__typename: (l$$__typename as String),
    );
  }

  final bool deleteSavedView;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$deleteSavedView = deleteSavedView;
    _resultData['deleteSavedView'] = l$deleteSavedView;
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$deleteSavedView = deleteSavedView;
    final l$$__typename = $__typename;
    return Object.hashAll([l$deleteSavedView, l$$__typename]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Mutation$deleteSavedView ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$deleteSavedView = deleteSavedView;
    final lOther$deleteSavedView = other.deleteSavedView;
    if (l$deleteSavedView != lOther$deleteSavedView) {
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

extension UtilityExtension$Mutation$deleteSavedView
    on Mutation$deleteSavedView {
  CopyWith$Mutation$deleteSavedView<Mutation$deleteSavedView> get copyWith =>
      CopyWith$Mutation$deleteSavedView(this, (i) => i);
}

abstract class CopyWith$Mutation$deleteSavedView<TRes> {
  factory CopyWith$Mutation$deleteSavedView(
    Mutation$deleteSavedView instance,
    TRes Function(Mutation$deleteSavedView) then,
  ) = _CopyWithImpl$Mutation$deleteSavedView;

  factory CopyWith$Mutation$deleteSavedView.stub(TRes res) =
      _CopyWithStubImpl$Mutation$deleteSavedView;

  TRes call({bool? deleteSavedView, String? $__typename});
}

class _CopyWithImpl$Mutation$deleteSavedView<TRes>
    implements CopyWith$Mutation$deleteSavedView<TRes> {
  _CopyWithImpl$Mutation$deleteSavedView(this._instance, this._then);

  final Mutation$deleteSavedView _instance;

  final TRes Function(Mutation$deleteSavedView) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? deleteSavedView = _undefined,
    Object? $__typename = _undefined,
  }) => _then(
    Mutation$deleteSavedView(
      deleteSavedView: deleteSavedView == _undefined || deleteSavedView == null
          ? _instance.deleteSavedView
          : (deleteSavedView as bool),
      $__typename: $__typename == _undefined || $__typename == null
          ? _instance.$__typename
          : ($__typename as String),
    ),
  );
}

class _CopyWithStubImpl$Mutation$deleteSavedView<TRes>
    implements CopyWith$Mutation$deleteSavedView<TRes> {
  _CopyWithStubImpl$Mutation$deleteSavedView(this._res);

  TRes _res;

  call({bool? deleteSavedView, String? $__typename}) => _res;
}

const documentNodeMutationdeleteSavedView = DocumentNode(
  definitions: [
    OperationDefinitionNode(
      type: OperationType.mutation,
      name: NameNode(value: 'deleteSavedView'),
      variableDefinitions: [
        VariableDefinitionNode(
          variable: VariableNode(name: NameNode(value: 'id')),
          type: NamedTypeNode(name: NameNode(value: 'ID'), isNonNull: true),
          defaultValue: DefaultValueNode(value: null),
          directives: [],
        ),
      ],
      directives: [],
      selectionSet: SelectionSetNode(
        selections: [
          FieldNode(
            name: NameNode(value: 'deleteSavedView'),
            alias: null,
            arguments: [
              ArgumentNode(
                name: NameNode(value: 'id'),
                value: VariableNode(name: NameNode(value: 'id')),
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

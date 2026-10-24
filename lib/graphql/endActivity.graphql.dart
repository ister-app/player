import 'package:gql/ast.dart';

class Variables$Mutation$endActivity {
  factory Variables$Mutation$endActivity({required String sessionId}) =>
      Variables$Mutation$endActivity._({r'sessionId': sessionId});

  Variables$Mutation$endActivity._(this._$data);

  factory Variables$Mutation$endActivity.fromJson(Map<String, dynamic> data) {
    final result$data = <String, dynamic>{};
    final l$sessionId = data['sessionId'];
    result$data['sessionId'] = (l$sessionId as String);
    return Variables$Mutation$endActivity._(result$data);
  }

  Map<String, dynamic> _$data;

  String get sessionId => (_$data['sessionId'] as String);

  Map<String, dynamic> toJson() {
    final result$data = <String, dynamic>{};
    final l$sessionId = sessionId;
    result$data['sessionId'] = l$sessionId;
    return result$data;
  }

  CopyWith$Variables$Mutation$endActivity<Variables$Mutation$endActivity>
  get copyWith => CopyWith$Variables$Mutation$endActivity(this, (i) => i);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Variables$Mutation$endActivity ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$sessionId = sessionId;
    final lOther$sessionId = other.sessionId;
    if (l$sessionId != lOther$sessionId) {
      return false;
    }
    return true;
  }

  @override
  int get hashCode {
    final l$sessionId = sessionId;
    return Object.hashAll([l$sessionId]);
  }
}

abstract class CopyWith$Variables$Mutation$endActivity<TRes> {
  factory CopyWith$Variables$Mutation$endActivity(
    Variables$Mutation$endActivity instance,
    TRes Function(Variables$Mutation$endActivity) then,
  ) = _CopyWithImpl$Variables$Mutation$endActivity;

  factory CopyWith$Variables$Mutation$endActivity.stub(TRes res) =
      _CopyWithStubImpl$Variables$Mutation$endActivity;

  TRes call({String? sessionId});
}

class _CopyWithImpl$Variables$Mutation$endActivity<TRes>
    implements CopyWith$Variables$Mutation$endActivity<TRes> {
  _CopyWithImpl$Variables$Mutation$endActivity(this._instance, this._then);

  final Variables$Mutation$endActivity _instance;

  final TRes Function(Variables$Mutation$endActivity) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({Object? sessionId = _undefined}) => _then(
    Variables$Mutation$endActivity._({
      ..._instance._$data,
      if (sessionId != _undefined && sessionId != null)
        'sessionId': (sessionId as String),
    }),
  );
}

class _CopyWithStubImpl$Variables$Mutation$endActivity<TRes>
    implements CopyWith$Variables$Mutation$endActivity<TRes> {
  _CopyWithStubImpl$Variables$Mutation$endActivity(this._res);

  TRes _res;

  call({String? sessionId}) => _res;
}

class Mutation$endActivity {
  Mutation$endActivity({
    required this.endActivity,
    this.$__typename = 'Mutation',
  });

  factory Mutation$endActivity.fromJson(Map<String, dynamic> json) {
    final l$endActivity = json['endActivity'];
    final l$$__typename = json['__typename'];
    return Mutation$endActivity(
      endActivity: (l$endActivity as bool),
      $__typename: (l$$__typename as String),
    );
  }

  final bool endActivity;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$endActivity = endActivity;
    _resultData['endActivity'] = l$endActivity;
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$endActivity = endActivity;
    final l$$__typename = $__typename;
    return Object.hashAll([l$endActivity, l$$__typename]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Mutation$endActivity || runtimeType != other.runtimeType) {
      return false;
    }
    final l$endActivity = endActivity;
    final lOther$endActivity = other.endActivity;
    if (l$endActivity != lOther$endActivity) {
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

extension UtilityExtension$Mutation$endActivity on Mutation$endActivity {
  CopyWith$Mutation$endActivity<Mutation$endActivity> get copyWith =>
      CopyWith$Mutation$endActivity(this, (i) => i);
}

abstract class CopyWith$Mutation$endActivity<TRes> {
  factory CopyWith$Mutation$endActivity(
    Mutation$endActivity instance,
    TRes Function(Mutation$endActivity) then,
  ) = _CopyWithImpl$Mutation$endActivity;

  factory CopyWith$Mutation$endActivity.stub(TRes res) =
      _CopyWithStubImpl$Mutation$endActivity;

  TRes call({bool? endActivity, String? $__typename});
}

class _CopyWithImpl$Mutation$endActivity<TRes>
    implements CopyWith$Mutation$endActivity<TRes> {
  _CopyWithImpl$Mutation$endActivity(this._instance, this._then);

  final Mutation$endActivity _instance;

  final TRes Function(Mutation$endActivity) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? endActivity = _undefined,
    Object? $__typename = _undefined,
  }) => _then(
    Mutation$endActivity(
      endActivity: endActivity == _undefined || endActivity == null
          ? _instance.endActivity
          : (endActivity as bool),
      $__typename: $__typename == _undefined || $__typename == null
          ? _instance.$__typename
          : ($__typename as String),
    ),
  );
}

class _CopyWithStubImpl$Mutation$endActivity<TRes>
    implements CopyWith$Mutation$endActivity<TRes> {
  _CopyWithStubImpl$Mutation$endActivity(this._res);

  TRes _res;

  call({bool? endActivity, String? $__typename}) => _res;
}

const documentNodeMutationendActivity = DocumentNode(
  definitions: [
    OperationDefinitionNode(
      type: OperationType.mutation,
      name: NameNode(value: 'endActivity'),
      variableDefinitions: [
        VariableDefinitionNode(
          variable: VariableNode(name: NameNode(value: 'sessionId')),
          type: NamedTypeNode(name: NameNode(value: 'ID'), isNonNull: true),
          defaultValue: DefaultValueNode(value: null),
          directives: [],
        ),
      ],
      directives: [],
      selectionSet: SelectionSetNode(
        selections: [
          FieldNode(
            name: NameNode(value: 'endActivity'),
            alias: null,
            arguments: [
              ArgumentNode(
                name: NameNode(value: 'sessionId'),
                value: VariableNode(name: NameNode(value: 'sessionId')),
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

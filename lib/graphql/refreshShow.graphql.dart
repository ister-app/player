import 'package:gql/ast.dart';

class Variables$Mutation$refreshShow {
  factory Variables$Mutation$refreshShow({required String showId}) =>
      Variables$Mutation$refreshShow._({r'showId': showId});

  Variables$Mutation$refreshShow._(this._$data);

  factory Variables$Mutation$refreshShow.fromJson(Map<String, dynamic> data) {
    final result$data = <String, dynamic>{};
    final l$showId = data['showId'];
    result$data['showId'] = (l$showId as String);
    return Variables$Mutation$refreshShow._(result$data);
  }

  Map<String, dynamic> _$data;

  String get showId => (_$data['showId'] as String);

  Map<String, dynamic> toJson() {
    final result$data = <String, dynamic>{};
    final l$showId = showId;
    result$data['showId'] = l$showId;
    return result$data;
  }

  CopyWith$Variables$Mutation$refreshShow<Variables$Mutation$refreshShow>
  get copyWith => CopyWith$Variables$Mutation$refreshShow(this, (i) => i);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Variables$Mutation$refreshShow ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$showId = showId;
    final lOther$showId = other.showId;
    if (l$showId != lOther$showId) {
      return false;
    }
    return true;
  }

  @override
  int get hashCode {
    final l$showId = showId;
    return Object.hashAll([l$showId]);
  }
}

abstract class CopyWith$Variables$Mutation$refreshShow<TRes> {
  factory CopyWith$Variables$Mutation$refreshShow(
    Variables$Mutation$refreshShow instance,
    TRes Function(Variables$Mutation$refreshShow) then,
  ) = _CopyWithImpl$Variables$Mutation$refreshShow;

  factory CopyWith$Variables$Mutation$refreshShow.stub(TRes res) =
      _CopyWithStubImpl$Variables$Mutation$refreshShow;

  TRes call({String? showId});
}

class _CopyWithImpl$Variables$Mutation$refreshShow<TRes>
    implements CopyWith$Variables$Mutation$refreshShow<TRes> {
  _CopyWithImpl$Variables$Mutation$refreshShow(this._instance, this._then);

  final Variables$Mutation$refreshShow _instance;

  final TRes Function(Variables$Mutation$refreshShow) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({Object? showId = _undefined}) => _then(
    Variables$Mutation$refreshShow._({
      ..._instance._$data,
      if (showId != _undefined && showId != null) 'showId': (showId as String),
    }),
  );
}

class _CopyWithStubImpl$Variables$Mutation$refreshShow<TRes>
    implements CopyWith$Variables$Mutation$refreshShow<TRes> {
  _CopyWithStubImpl$Variables$Mutation$refreshShow(this._res);

  TRes _res;

  call({String? showId}) => _res;
}

class Mutation$refreshShow {
  Mutation$refreshShow({
    required this.refreshShow,
    this.$__typename = 'Mutation',
  });

  factory Mutation$refreshShow.fromJson(Map<String, dynamic> json) {
    final l$refreshShow = json['refreshShow'];
    final l$$__typename = json['__typename'];
    return Mutation$refreshShow(
      refreshShow: (l$refreshShow as bool),
      $__typename: (l$$__typename as String),
    );
  }

  final bool refreshShow;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$refreshShow = refreshShow;
    _resultData['refreshShow'] = l$refreshShow;
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$refreshShow = refreshShow;
    final l$$__typename = $__typename;
    return Object.hashAll([l$refreshShow, l$$__typename]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Mutation$refreshShow || runtimeType != other.runtimeType) {
      return false;
    }
    final l$refreshShow = refreshShow;
    final lOther$refreshShow = other.refreshShow;
    if (l$refreshShow != lOther$refreshShow) {
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

extension UtilityExtension$Mutation$refreshShow on Mutation$refreshShow {
  CopyWith$Mutation$refreshShow<Mutation$refreshShow> get copyWith =>
      CopyWith$Mutation$refreshShow(this, (i) => i);
}

abstract class CopyWith$Mutation$refreshShow<TRes> {
  factory CopyWith$Mutation$refreshShow(
    Mutation$refreshShow instance,
    TRes Function(Mutation$refreshShow) then,
  ) = _CopyWithImpl$Mutation$refreshShow;

  factory CopyWith$Mutation$refreshShow.stub(TRes res) =
      _CopyWithStubImpl$Mutation$refreshShow;

  TRes call({bool? refreshShow, String? $__typename});
}

class _CopyWithImpl$Mutation$refreshShow<TRes>
    implements CopyWith$Mutation$refreshShow<TRes> {
  _CopyWithImpl$Mutation$refreshShow(this._instance, this._then);

  final Mutation$refreshShow _instance;

  final TRes Function(Mutation$refreshShow) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? refreshShow = _undefined,
    Object? $__typename = _undefined,
  }) => _then(
    Mutation$refreshShow(
      refreshShow: refreshShow == _undefined || refreshShow == null
          ? _instance.refreshShow
          : (refreshShow as bool),
      $__typename: $__typename == _undefined || $__typename == null
          ? _instance.$__typename
          : ($__typename as String),
    ),
  );
}

class _CopyWithStubImpl$Mutation$refreshShow<TRes>
    implements CopyWith$Mutation$refreshShow<TRes> {
  _CopyWithStubImpl$Mutation$refreshShow(this._res);

  TRes _res;

  call({bool? refreshShow, String? $__typename}) => _res;
}

const documentNodeMutationrefreshShow = DocumentNode(
  definitions: [
    OperationDefinitionNode(
      type: OperationType.mutation,
      name: NameNode(value: 'refreshShow'),
      variableDefinitions: [
        VariableDefinitionNode(
          variable: VariableNode(name: NameNode(value: 'showId')),
          type: NamedTypeNode(name: NameNode(value: 'ID'), isNonNull: true),
          defaultValue: DefaultValueNode(value: null),
          directives: [],
        ),
      ],
      directives: [],
      selectionSet: SelectionSetNode(
        selections: [
          FieldNode(
            name: NameNode(value: 'refreshShow'),
            alias: null,
            arguments: [
              ArgumentNode(
                name: NameNode(value: 'showId'),
                value: VariableNode(name: NameNode(value: 'showId')),
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

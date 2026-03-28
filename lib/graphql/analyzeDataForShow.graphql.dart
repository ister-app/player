import 'package:gql/ast.dart';

class Variables$Mutation$analyzeDataForShowMutation {
  factory Variables$Mutation$analyzeDataForShowMutation({
    required String showId,
  }) => Variables$Mutation$analyzeDataForShowMutation._({r'showId': showId});

  Variables$Mutation$analyzeDataForShowMutation._(this._$data);

  factory Variables$Mutation$analyzeDataForShowMutation.fromJson(
    Map<String, dynamic> data,
  ) {
    final result$data = <String, dynamic>{};
    final l$showId = data['showId'];
    result$data['showId'] = (l$showId as String);
    return Variables$Mutation$analyzeDataForShowMutation._(result$data);
  }

  Map<String, dynamic> _$data;

  String get showId => (_$data['showId'] as String);

  Map<String, dynamic> toJson() {
    final result$data = <String, dynamic>{};
    final l$showId = showId;
    result$data['showId'] = l$showId;
    return result$data;
  }

  CopyWith$Variables$Mutation$analyzeDataForShowMutation<
    Variables$Mutation$analyzeDataForShowMutation
  >
  get copyWith =>
      CopyWith$Variables$Mutation$analyzeDataForShowMutation(this, (i) => i);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Variables$Mutation$analyzeDataForShowMutation ||
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

abstract class CopyWith$Variables$Mutation$analyzeDataForShowMutation<TRes> {
  factory CopyWith$Variables$Mutation$analyzeDataForShowMutation(
    Variables$Mutation$analyzeDataForShowMutation instance,
    TRes Function(Variables$Mutation$analyzeDataForShowMutation) then,
  ) = _CopyWithImpl$Variables$Mutation$analyzeDataForShowMutation;

  factory CopyWith$Variables$Mutation$analyzeDataForShowMutation.stub(
    TRes res,
  ) = _CopyWithStubImpl$Variables$Mutation$analyzeDataForShowMutation;

  TRes call({String? showId});
}

class _CopyWithImpl$Variables$Mutation$analyzeDataForShowMutation<TRes>
    implements CopyWith$Variables$Mutation$analyzeDataForShowMutation<TRes> {
  _CopyWithImpl$Variables$Mutation$analyzeDataForShowMutation(
    this._instance,
    this._then,
  );

  final Variables$Mutation$analyzeDataForShowMutation _instance;

  final TRes Function(Variables$Mutation$analyzeDataForShowMutation) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({Object? showId = _undefined}) => _then(
    Variables$Mutation$analyzeDataForShowMutation._({
      ..._instance._$data,
      if (showId != _undefined && showId != null) 'showId': (showId as String),
    }),
  );
}

class _CopyWithStubImpl$Variables$Mutation$analyzeDataForShowMutation<TRes>
    implements CopyWith$Variables$Mutation$analyzeDataForShowMutation<TRes> {
  _CopyWithStubImpl$Variables$Mutation$analyzeDataForShowMutation(this._res);

  TRes _res;

  call({String? showId}) => _res;
}

class Mutation$analyzeDataForShowMutation {
  Mutation$analyzeDataForShowMutation({
    required this.analyzeDataForShow,
    this.$__typename = 'Mutation',
  });

  factory Mutation$analyzeDataForShowMutation.fromJson(
    Map<String, dynamic> json,
  ) {
    final l$analyzeDataForShow = json['analyzeDataForShow'];
    final l$$__typename = json['__typename'];
    return Mutation$analyzeDataForShowMutation(
      analyzeDataForShow: (l$analyzeDataForShow as bool),
      $__typename: (l$$__typename as String),
    );
  }

  final bool analyzeDataForShow;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$analyzeDataForShow = analyzeDataForShow;
    _resultData['analyzeDataForShow'] = l$analyzeDataForShow;
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$analyzeDataForShow = analyzeDataForShow;
    final l$$__typename = $__typename;
    return Object.hashAll([l$analyzeDataForShow, l$$__typename]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Mutation$analyzeDataForShowMutation ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$analyzeDataForShow = analyzeDataForShow;
    final lOther$analyzeDataForShow = other.analyzeDataForShow;
    if (l$analyzeDataForShow != lOther$analyzeDataForShow) {
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

extension UtilityExtension$Mutation$analyzeDataForShowMutation
    on Mutation$analyzeDataForShowMutation {
  CopyWith$Mutation$analyzeDataForShowMutation<
    Mutation$analyzeDataForShowMutation
  >
  get copyWith => CopyWith$Mutation$analyzeDataForShowMutation(this, (i) => i);
}

abstract class CopyWith$Mutation$analyzeDataForShowMutation<TRes> {
  factory CopyWith$Mutation$analyzeDataForShowMutation(
    Mutation$analyzeDataForShowMutation instance,
    TRes Function(Mutation$analyzeDataForShowMutation) then,
  ) = _CopyWithImpl$Mutation$analyzeDataForShowMutation;

  factory CopyWith$Mutation$analyzeDataForShowMutation.stub(TRes res) =
      _CopyWithStubImpl$Mutation$analyzeDataForShowMutation;

  TRes call({bool? analyzeDataForShow, String? $__typename});
}

class _CopyWithImpl$Mutation$analyzeDataForShowMutation<TRes>
    implements CopyWith$Mutation$analyzeDataForShowMutation<TRes> {
  _CopyWithImpl$Mutation$analyzeDataForShowMutation(this._instance, this._then);

  final Mutation$analyzeDataForShowMutation _instance;

  final TRes Function(Mutation$analyzeDataForShowMutation) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? analyzeDataForShow = _undefined,
    Object? $__typename = _undefined,
  }) => _then(
    Mutation$analyzeDataForShowMutation(
      analyzeDataForShow:
          analyzeDataForShow == _undefined || analyzeDataForShow == null
          ? _instance.analyzeDataForShow
          : (analyzeDataForShow as bool),
      $__typename: $__typename == _undefined || $__typename == null
          ? _instance.$__typename
          : ($__typename as String),
    ),
  );
}

class _CopyWithStubImpl$Mutation$analyzeDataForShowMutation<TRes>
    implements CopyWith$Mutation$analyzeDataForShowMutation<TRes> {
  _CopyWithStubImpl$Mutation$analyzeDataForShowMutation(this._res);

  TRes _res;

  call({bool? analyzeDataForShow, String? $__typename}) => _res;
}

const documentNodeMutationanalyzeDataForShowMutation = DocumentNode(
  definitions: [
    OperationDefinitionNode(
      type: OperationType.mutation,
      name: NameNode(value: 'analyzeDataForShowMutation'),
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
            name: NameNode(value: 'analyzeDataForShow'),
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

import 'package:gql/ast.dart';

class Variables$Mutation$refreshTrack {
  factory Variables$Mutation$refreshTrack({required String trackId}) =>
      Variables$Mutation$refreshTrack._({r'trackId': trackId});

  Variables$Mutation$refreshTrack._(this._$data);

  factory Variables$Mutation$refreshTrack.fromJson(Map<String, dynamic> data) {
    final result$data = <String, dynamic>{};
    final l$trackId = data['trackId'];
    result$data['trackId'] = (l$trackId as String);
    return Variables$Mutation$refreshTrack._(result$data);
  }

  Map<String, dynamic> _$data;

  String get trackId => (_$data['trackId'] as String);

  Map<String, dynamic> toJson() {
    final result$data = <String, dynamic>{};
    final l$trackId = trackId;
    result$data['trackId'] = l$trackId;
    return result$data;
  }

  CopyWith$Variables$Mutation$refreshTrack<Variables$Mutation$refreshTrack>
  get copyWith => CopyWith$Variables$Mutation$refreshTrack(this, (i) => i);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Variables$Mutation$refreshTrack ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$trackId = trackId;
    final lOther$trackId = other.trackId;
    if (l$trackId != lOther$trackId) {
      return false;
    }
    return true;
  }

  @override
  int get hashCode {
    final l$trackId = trackId;
    return Object.hashAll([l$trackId]);
  }
}

abstract class CopyWith$Variables$Mutation$refreshTrack<TRes> {
  factory CopyWith$Variables$Mutation$refreshTrack(
    Variables$Mutation$refreshTrack instance,
    TRes Function(Variables$Mutation$refreshTrack) then,
  ) = _CopyWithImpl$Variables$Mutation$refreshTrack;

  factory CopyWith$Variables$Mutation$refreshTrack.stub(TRes res) =
      _CopyWithStubImpl$Variables$Mutation$refreshTrack;

  TRes call({String? trackId});
}

class _CopyWithImpl$Variables$Mutation$refreshTrack<TRes>
    implements CopyWith$Variables$Mutation$refreshTrack<TRes> {
  _CopyWithImpl$Variables$Mutation$refreshTrack(this._instance, this._then);

  final Variables$Mutation$refreshTrack _instance;

  final TRes Function(Variables$Mutation$refreshTrack) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({Object? trackId = _undefined}) => _then(
    Variables$Mutation$refreshTrack._({
      ..._instance._$data,
      if (trackId != _undefined && trackId != null)
        'trackId': (trackId as String),
    }),
  );
}

class _CopyWithStubImpl$Variables$Mutation$refreshTrack<TRes>
    implements CopyWith$Variables$Mutation$refreshTrack<TRes> {
  _CopyWithStubImpl$Variables$Mutation$refreshTrack(this._res);

  TRes _res;

  call({String? trackId}) => _res;
}

class Mutation$refreshTrack {
  Mutation$refreshTrack({
    required this.refreshTrack,
    this.$__typename = 'Mutation',
  });

  factory Mutation$refreshTrack.fromJson(Map<String, dynamic> json) {
    final l$refreshTrack = json['refreshTrack'];
    final l$$__typename = json['__typename'];
    return Mutation$refreshTrack(
      refreshTrack: (l$refreshTrack as bool),
      $__typename: (l$$__typename as String),
    );
  }

  final bool refreshTrack;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$refreshTrack = refreshTrack;
    _resultData['refreshTrack'] = l$refreshTrack;
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$refreshTrack = refreshTrack;
    final l$$__typename = $__typename;
    return Object.hashAll([l$refreshTrack, l$$__typename]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Mutation$refreshTrack || runtimeType != other.runtimeType) {
      return false;
    }
    final l$refreshTrack = refreshTrack;
    final lOther$refreshTrack = other.refreshTrack;
    if (l$refreshTrack != lOther$refreshTrack) {
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

extension UtilityExtension$Mutation$refreshTrack on Mutation$refreshTrack {
  CopyWith$Mutation$refreshTrack<Mutation$refreshTrack> get copyWith =>
      CopyWith$Mutation$refreshTrack(this, (i) => i);
}

abstract class CopyWith$Mutation$refreshTrack<TRes> {
  factory CopyWith$Mutation$refreshTrack(
    Mutation$refreshTrack instance,
    TRes Function(Mutation$refreshTrack) then,
  ) = _CopyWithImpl$Mutation$refreshTrack;

  factory CopyWith$Mutation$refreshTrack.stub(TRes res) =
      _CopyWithStubImpl$Mutation$refreshTrack;

  TRes call({bool? refreshTrack, String? $__typename});
}

class _CopyWithImpl$Mutation$refreshTrack<TRes>
    implements CopyWith$Mutation$refreshTrack<TRes> {
  _CopyWithImpl$Mutation$refreshTrack(this._instance, this._then);

  final Mutation$refreshTrack _instance;

  final TRes Function(Mutation$refreshTrack) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? refreshTrack = _undefined,
    Object? $__typename = _undefined,
  }) => _then(
    Mutation$refreshTrack(
      refreshTrack: refreshTrack == _undefined || refreshTrack == null
          ? _instance.refreshTrack
          : (refreshTrack as bool),
      $__typename: $__typename == _undefined || $__typename == null
          ? _instance.$__typename
          : ($__typename as String),
    ),
  );
}

class _CopyWithStubImpl$Mutation$refreshTrack<TRes>
    implements CopyWith$Mutation$refreshTrack<TRes> {
  _CopyWithStubImpl$Mutation$refreshTrack(this._res);

  TRes _res;

  call({bool? refreshTrack, String? $__typename}) => _res;
}

const documentNodeMutationrefreshTrack = DocumentNode(
  definitions: [
    OperationDefinitionNode(
      type: OperationType.mutation,
      name: NameNode(value: 'refreshTrack'),
      variableDefinitions: [
        VariableDefinitionNode(
          variable: VariableNode(name: NameNode(value: 'trackId')),
          type: NamedTypeNode(name: NameNode(value: 'ID'), isNonNull: true),
          defaultValue: DefaultValueNode(value: null),
          directives: [],
        ),
      ],
      directives: [],
      selectionSet: SelectionSetNode(
        selections: [
          FieldNode(
            name: NameNode(value: 'refreshTrack'),
            alias: null,
            arguments: [
              ArgumentNode(
                name: NameNode(value: 'trackId'),
                value: VariableNode(name: NameNode(value: 'trackId')),
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

import 'package:gql/ast.dart';

class Variables$Mutation$analyzeDataForTrackMutation {
  factory Variables$Mutation$analyzeDataForTrackMutation({
    required String trackId,
  }) => Variables$Mutation$analyzeDataForTrackMutation._({r'trackId': trackId});

  Variables$Mutation$analyzeDataForTrackMutation._(this._$data);

  factory Variables$Mutation$analyzeDataForTrackMutation.fromJson(
    Map<String, dynamic> data,
  ) {
    final result$data = <String, dynamic>{};
    final l$trackId = data['trackId'];
    result$data['trackId'] = (l$trackId as String);
    return Variables$Mutation$analyzeDataForTrackMutation._(result$data);
  }

  Map<String, dynamic> _$data;

  String get trackId => (_$data['trackId'] as String);

  Map<String, dynamic> toJson() {
    final result$data = <String, dynamic>{};
    final l$trackId = trackId;
    result$data['trackId'] = l$trackId;
    return result$data;
  }

  CopyWith$Variables$Mutation$analyzeDataForTrackMutation<
    Variables$Mutation$analyzeDataForTrackMutation
  >
  get copyWith =>
      CopyWith$Variables$Mutation$analyzeDataForTrackMutation(this, (i) => i);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Variables$Mutation$analyzeDataForTrackMutation ||
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

abstract class CopyWith$Variables$Mutation$analyzeDataForTrackMutation<TRes> {
  factory CopyWith$Variables$Mutation$analyzeDataForTrackMutation(
    Variables$Mutation$analyzeDataForTrackMutation instance,
    TRes Function(Variables$Mutation$analyzeDataForTrackMutation) then,
  ) = _CopyWithImpl$Variables$Mutation$analyzeDataForTrackMutation;

  factory CopyWith$Variables$Mutation$analyzeDataForTrackMutation.stub(
    TRes res,
  ) = _CopyWithStubImpl$Variables$Mutation$analyzeDataForTrackMutation;

  TRes call({String? trackId});
}

class _CopyWithImpl$Variables$Mutation$analyzeDataForTrackMutation<TRes>
    implements CopyWith$Variables$Mutation$analyzeDataForTrackMutation<TRes> {
  _CopyWithImpl$Variables$Mutation$analyzeDataForTrackMutation(
    this._instance,
    this._then,
  );

  final Variables$Mutation$analyzeDataForTrackMutation _instance;

  final TRes Function(Variables$Mutation$analyzeDataForTrackMutation) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({Object? trackId = _undefined}) => _then(
    Variables$Mutation$analyzeDataForTrackMutation._({
      ..._instance._$data,
      if (trackId != _undefined && trackId != null)
        'trackId': (trackId as String),
    }),
  );
}

class _CopyWithStubImpl$Variables$Mutation$analyzeDataForTrackMutation<TRes>
    implements CopyWith$Variables$Mutation$analyzeDataForTrackMutation<TRes> {
  _CopyWithStubImpl$Variables$Mutation$analyzeDataForTrackMutation(this._res);

  TRes _res;

  call({String? trackId}) => _res;
}

class Mutation$analyzeDataForTrackMutation {
  Mutation$analyzeDataForTrackMutation({
    required this.analyzeDataForTrack,
    this.$__typename = 'Mutation',
  });

  factory Mutation$analyzeDataForTrackMutation.fromJson(
    Map<String, dynamic> json,
  ) {
    final l$analyzeDataForTrack = json['analyzeDataForTrack'];
    final l$$__typename = json['__typename'];
    return Mutation$analyzeDataForTrackMutation(
      analyzeDataForTrack: (l$analyzeDataForTrack as bool),
      $__typename: (l$$__typename as String),
    );
  }

  final bool analyzeDataForTrack;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$analyzeDataForTrack = analyzeDataForTrack;
    _resultData['analyzeDataForTrack'] = l$analyzeDataForTrack;
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$analyzeDataForTrack = analyzeDataForTrack;
    final l$$__typename = $__typename;
    return Object.hashAll([l$analyzeDataForTrack, l$$__typename]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Mutation$analyzeDataForTrackMutation ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$analyzeDataForTrack = analyzeDataForTrack;
    final lOther$analyzeDataForTrack = other.analyzeDataForTrack;
    if (l$analyzeDataForTrack != lOther$analyzeDataForTrack) {
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

extension UtilityExtension$Mutation$analyzeDataForTrackMutation
    on Mutation$analyzeDataForTrackMutation {
  CopyWith$Mutation$analyzeDataForTrackMutation<
    Mutation$analyzeDataForTrackMutation
  >
  get copyWith => CopyWith$Mutation$analyzeDataForTrackMutation(this, (i) => i);
}

abstract class CopyWith$Mutation$analyzeDataForTrackMutation<TRes> {
  factory CopyWith$Mutation$analyzeDataForTrackMutation(
    Mutation$analyzeDataForTrackMutation instance,
    TRes Function(Mutation$analyzeDataForTrackMutation) then,
  ) = _CopyWithImpl$Mutation$analyzeDataForTrackMutation;

  factory CopyWith$Mutation$analyzeDataForTrackMutation.stub(TRes res) =
      _CopyWithStubImpl$Mutation$analyzeDataForTrackMutation;

  TRes call({bool? analyzeDataForTrack, String? $__typename});
}

class _CopyWithImpl$Mutation$analyzeDataForTrackMutation<TRes>
    implements CopyWith$Mutation$analyzeDataForTrackMutation<TRes> {
  _CopyWithImpl$Mutation$analyzeDataForTrackMutation(
    this._instance,
    this._then,
  );

  final Mutation$analyzeDataForTrackMutation _instance;

  final TRes Function(Mutation$analyzeDataForTrackMutation) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? analyzeDataForTrack = _undefined,
    Object? $__typename = _undefined,
  }) => _then(
    Mutation$analyzeDataForTrackMutation(
      analyzeDataForTrack:
          analyzeDataForTrack == _undefined || analyzeDataForTrack == null
          ? _instance.analyzeDataForTrack
          : (analyzeDataForTrack as bool),
      $__typename: $__typename == _undefined || $__typename == null
          ? _instance.$__typename
          : ($__typename as String),
    ),
  );
}

class _CopyWithStubImpl$Mutation$analyzeDataForTrackMutation<TRes>
    implements CopyWith$Mutation$analyzeDataForTrackMutation<TRes> {
  _CopyWithStubImpl$Mutation$analyzeDataForTrackMutation(this._res);

  TRes _res;

  call({bool? analyzeDataForTrack, String? $__typename}) => _res;
}

const documentNodeMutationanalyzeDataForTrackMutation = DocumentNode(
  definitions: [
    OperationDefinitionNode(
      type: OperationType.mutation,
      name: NameNode(value: 'analyzeDataForTrackMutation'),
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
            name: NameNode(value: 'analyzeDataForTrack'),
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

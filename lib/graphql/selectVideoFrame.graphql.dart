import 'fragmentImages.graphql.dart';

import 'package:gql/ast.dart';

import 'schema.graphql.dart';

class Variables$Mutation$selectVideoFrame {
  factory Variables$Mutation$selectVideoFrame({
    required Input$ImageTargetInput target,
    required Enum$ImageType type,
    required String mediaFileId,
    required int positionMs,
  }) => Variables$Mutation$selectVideoFrame._({
    r'target': target,
    r'type': type,
    r'mediaFileId': mediaFileId,
    r'positionMs': positionMs,
  });

  Variables$Mutation$selectVideoFrame._(this._$data);

  factory Variables$Mutation$selectVideoFrame.fromJson(
    Map<String, dynamic> data,
  ) {
    final result$data = <String, dynamic>{};
    final l$target = data['target'];
    result$data['target'] = Input$ImageTargetInput.fromJson(
      (l$target as Map<String, dynamic>),
    );
    final l$type = data['type'];
    result$data['type'] = fromJson$Enum$ImageType((l$type as String));
    final l$mediaFileId = data['mediaFileId'];
    result$data['mediaFileId'] = (l$mediaFileId as String);
    final l$positionMs = data['positionMs'];
    result$data['positionMs'] = (l$positionMs as int);
    return Variables$Mutation$selectVideoFrame._(result$data);
  }

  Map<String, dynamic> _$data;

  Input$ImageTargetInput get target =>
      (_$data['target'] as Input$ImageTargetInput);

  Enum$ImageType get type => (_$data['type'] as Enum$ImageType);

  String get mediaFileId => (_$data['mediaFileId'] as String);

  int get positionMs => (_$data['positionMs'] as int);

  Map<String, dynamic> toJson() {
    final result$data = <String, dynamic>{};
    final l$target = target;
    result$data['target'] = l$target.toJson();
    final l$type = type;
    result$data['type'] = toJson$Enum$ImageType(l$type);
    final l$mediaFileId = mediaFileId;
    result$data['mediaFileId'] = l$mediaFileId;
    final l$positionMs = positionMs;
    result$data['positionMs'] = l$positionMs;
    return result$data;
  }

  CopyWith$Variables$Mutation$selectVideoFrame<
    Variables$Mutation$selectVideoFrame
  >
  get copyWith => CopyWith$Variables$Mutation$selectVideoFrame(this, (i) => i);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Variables$Mutation$selectVideoFrame ||
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
    final l$mediaFileId = mediaFileId;
    final lOther$mediaFileId = other.mediaFileId;
    if (l$mediaFileId != lOther$mediaFileId) {
      return false;
    }
    final l$positionMs = positionMs;
    final lOther$positionMs = other.positionMs;
    if (l$positionMs != lOther$positionMs) {
      return false;
    }
    return true;
  }

  @override
  int get hashCode {
    final l$target = target;
    final l$type = type;
    final l$mediaFileId = mediaFileId;
    final l$positionMs = positionMs;
    return Object.hashAll([l$target, l$type, l$mediaFileId, l$positionMs]);
  }
}

abstract class CopyWith$Variables$Mutation$selectVideoFrame<TRes> {
  factory CopyWith$Variables$Mutation$selectVideoFrame(
    Variables$Mutation$selectVideoFrame instance,
    TRes Function(Variables$Mutation$selectVideoFrame) then,
  ) = _CopyWithImpl$Variables$Mutation$selectVideoFrame;

  factory CopyWith$Variables$Mutation$selectVideoFrame.stub(TRes res) =
      _CopyWithStubImpl$Variables$Mutation$selectVideoFrame;

  TRes call({
    Input$ImageTargetInput? target,
    Enum$ImageType? type,
    String? mediaFileId,
    int? positionMs,
  });
}

class _CopyWithImpl$Variables$Mutation$selectVideoFrame<TRes>
    implements CopyWith$Variables$Mutation$selectVideoFrame<TRes> {
  _CopyWithImpl$Variables$Mutation$selectVideoFrame(this._instance, this._then);

  final Variables$Mutation$selectVideoFrame _instance;

  final TRes Function(Variables$Mutation$selectVideoFrame) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? target = _undefined,
    Object? type = _undefined,
    Object? mediaFileId = _undefined,
    Object? positionMs = _undefined,
  }) => _then(
    Variables$Mutation$selectVideoFrame._({
      ..._instance._$data,
      if (target != _undefined && target != null)
        'target': (target as Input$ImageTargetInput),
      if (type != _undefined && type != null) 'type': (type as Enum$ImageType),
      if (mediaFileId != _undefined && mediaFileId != null)
        'mediaFileId': (mediaFileId as String),
      if (positionMs != _undefined && positionMs != null)
        'positionMs': (positionMs as int),
    }),
  );
}

class _CopyWithStubImpl$Variables$Mutation$selectVideoFrame<TRes>
    implements CopyWith$Variables$Mutation$selectVideoFrame<TRes> {
  _CopyWithStubImpl$Variables$Mutation$selectVideoFrame(this._res);

  TRes _res;

  call({
    Input$ImageTargetInput? target,
    Enum$ImageType? type,
    String? mediaFileId,
    int? positionMs,
  }) => _res;
}

class Mutation$selectVideoFrame {
  Mutation$selectVideoFrame({
    required this.selectVideoFrame,
    this.$__typename = 'Mutation',
  });

  factory Mutation$selectVideoFrame.fromJson(Map<String, dynamic> json) {
    final l$selectVideoFrame = json['selectVideoFrame'];
    final l$$__typename = json['__typename'];
    return Mutation$selectVideoFrame(
      selectVideoFrame: Fragment$fragmentImages.fromJson(
        (l$selectVideoFrame as Map<String, dynamic>),
      ),
      $__typename: (l$$__typename as String),
    );
  }

  final Fragment$fragmentImages selectVideoFrame;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$selectVideoFrame = selectVideoFrame;
    _resultData['selectVideoFrame'] = l$selectVideoFrame.toJson();
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$selectVideoFrame = selectVideoFrame;
    final l$$__typename = $__typename;
    return Object.hashAll([l$selectVideoFrame, l$$__typename]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Mutation$selectVideoFrame ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$selectVideoFrame = selectVideoFrame;
    final lOther$selectVideoFrame = other.selectVideoFrame;
    if (l$selectVideoFrame != lOther$selectVideoFrame) {
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

extension UtilityExtension$Mutation$selectVideoFrame
    on Mutation$selectVideoFrame {
  CopyWith$Mutation$selectVideoFrame<Mutation$selectVideoFrame> get copyWith =>
      CopyWith$Mutation$selectVideoFrame(this, (i) => i);
}

abstract class CopyWith$Mutation$selectVideoFrame<TRes> {
  factory CopyWith$Mutation$selectVideoFrame(
    Mutation$selectVideoFrame instance,
    TRes Function(Mutation$selectVideoFrame) then,
  ) = _CopyWithImpl$Mutation$selectVideoFrame;

  factory CopyWith$Mutation$selectVideoFrame.stub(TRes res) =
      _CopyWithStubImpl$Mutation$selectVideoFrame;

  TRes call({Fragment$fragmentImages? selectVideoFrame, String? $__typename});
  CopyWith$Fragment$fragmentImages<TRes> get selectVideoFrame;
}

class _CopyWithImpl$Mutation$selectVideoFrame<TRes>
    implements CopyWith$Mutation$selectVideoFrame<TRes> {
  _CopyWithImpl$Mutation$selectVideoFrame(this._instance, this._then);

  final Mutation$selectVideoFrame _instance;

  final TRes Function(Mutation$selectVideoFrame) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? selectVideoFrame = _undefined,
    Object? $__typename = _undefined,
  }) => _then(
    Mutation$selectVideoFrame(
      selectVideoFrame:
          selectVideoFrame == _undefined || selectVideoFrame == null
          ? _instance.selectVideoFrame
          : (selectVideoFrame as Fragment$fragmentImages),
      $__typename: $__typename == _undefined || $__typename == null
          ? _instance.$__typename
          : ($__typename as String),
    ),
  );

  CopyWith$Fragment$fragmentImages<TRes> get selectVideoFrame {
    final local$selectVideoFrame = _instance.selectVideoFrame;
    return CopyWith$Fragment$fragmentImages(
      local$selectVideoFrame,
      (e) => call(selectVideoFrame: e),
    );
  }
}

class _CopyWithStubImpl$Mutation$selectVideoFrame<TRes>
    implements CopyWith$Mutation$selectVideoFrame<TRes> {
  _CopyWithStubImpl$Mutation$selectVideoFrame(this._res);

  TRes _res;

  call({Fragment$fragmentImages? selectVideoFrame, String? $__typename}) =>
      _res;

  CopyWith$Fragment$fragmentImages<TRes> get selectVideoFrame =>
      CopyWith$Fragment$fragmentImages.stub(_res);
}

const documentNodeMutationselectVideoFrame = DocumentNode(
  definitions: [
    OperationDefinitionNode(
      type: OperationType.mutation,
      name: NameNode(value: 'selectVideoFrame'),
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
        VariableDefinitionNode(
          variable: VariableNode(name: NameNode(value: 'mediaFileId')),
          type: NamedTypeNode(name: NameNode(value: 'ID'), isNonNull: true),
          defaultValue: DefaultValueNode(value: null),
          directives: [],
        ),
        VariableDefinitionNode(
          variable: VariableNode(name: NameNode(value: 'positionMs')),
          type: NamedTypeNode(name: NameNode(value: 'Int'), isNonNull: true),
          defaultValue: DefaultValueNode(value: null),
          directives: [],
        ),
      ],
      directives: [],
      selectionSet: SelectionSetNode(
        selections: [
          FieldNode(
            name: NameNode(value: 'selectVideoFrame'),
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
              ArgumentNode(
                name: NameNode(value: 'mediaFileId'),
                value: VariableNode(name: NameNode(value: 'mediaFileId')),
              ),
              ArgumentNode(
                name: NameNode(value: 'positionMs'),
                value: VariableNode(name: NameNode(value: 'positionMs')),
              ),
            ],
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

import 'package:gql/ast.dart';

import 'schema.graphql.dart';

class Variables$Mutation$clearSelectedImage {
  factory Variables$Mutation$clearSelectedImage({
    required Input$ImageTargetInput target,
    required Enum$ImageType type,
  }) => Variables$Mutation$clearSelectedImage._({
    r'target': target,
    r'type': type,
  });

  Variables$Mutation$clearSelectedImage._(this._$data);

  factory Variables$Mutation$clearSelectedImage.fromJson(
    Map<String, dynamic> data,
  ) {
    final result$data = <String, dynamic>{};
    final l$target = data['target'];
    result$data['target'] = Input$ImageTargetInput.fromJson(
      (l$target as Map<String, dynamic>),
    );
    final l$type = data['type'];
    result$data['type'] = fromJson$Enum$ImageType((l$type as String));
    return Variables$Mutation$clearSelectedImage._(result$data);
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

  CopyWith$Variables$Mutation$clearSelectedImage<
    Variables$Mutation$clearSelectedImage
  >
  get copyWith =>
      CopyWith$Variables$Mutation$clearSelectedImage(this, (i) => i);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Variables$Mutation$clearSelectedImage ||
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

abstract class CopyWith$Variables$Mutation$clearSelectedImage<TRes> {
  factory CopyWith$Variables$Mutation$clearSelectedImage(
    Variables$Mutation$clearSelectedImage instance,
    TRes Function(Variables$Mutation$clearSelectedImage) then,
  ) = _CopyWithImpl$Variables$Mutation$clearSelectedImage;

  factory CopyWith$Variables$Mutation$clearSelectedImage.stub(TRes res) =
      _CopyWithStubImpl$Variables$Mutation$clearSelectedImage;

  TRes call({Input$ImageTargetInput? target, Enum$ImageType? type});
}

class _CopyWithImpl$Variables$Mutation$clearSelectedImage<TRes>
    implements CopyWith$Variables$Mutation$clearSelectedImage<TRes> {
  _CopyWithImpl$Variables$Mutation$clearSelectedImage(
    this._instance,
    this._then,
  );

  final Variables$Mutation$clearSelectedImage _instance;

  final TRes Function(Variables$Mutation$clearSelectedImage) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({Object? target = _undefined, Object? type = _undefined}) => _then(
    Variables$Mutation$clearSelectedImage._({
      ..._instance._$data,
      if (target != _undefined && target != null)
        'target': (target as Input$ImageTargetInput),
      if (type != _undefined && type != null) 'type': (type as Enum$ImageType),
    }),
  );
}

class _CopyWithStubImpl$Variables$Mutation$clearSelectedImage<TRes>
    implements CopyWith$Variables$Mutation$clearSelectedImage<TRes> {
  _CopyWithStubImpl$Variables$Mutation$clearSelectedImage(this._res);

  TRes _res;

  call({Input$ImageTargetInput? target, Enum$ImageType? type}) => _res;
}

class Mutation$clearSelectedImage {
  Mutation$clearSelectedImage({
    required this.clearSelectedImage,
    this.$__typename = 'Mutation',
  });

  factory Mutation$clearSelectedImage.fromJson(Map<String, dynamic> json) {
    final l$clearSelectedImage = json['clearSelectedImage'];
    final l$$__typename = json['__typename'];
    return Mutation$clearSelectedImage(
      clearSelectedImage: (l$clearSelectedImage as bool),
      $__typename: (l$$__typename as String),
    );
  }

  final bool clearSelectedImage;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$clearSelectedImage = clearSelectedImage;
    _resultData['clearSelectedImage'] = l$clearSelectedImage;
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$clearSelectedImage = clearSelectedImage;
    final l$$__typename = $__typename;
    return Object.hashAll([l$clearSelectedImage, l$$__typename]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Mutation$clearSelectedImage ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$clearSelectedImage = clearSelectedImage;
    final lOther$clearSelectedImage = other.clearSelectedImage;
    if (l$clearSelectedImage != lOther$clearSelectedImage) {
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

extension UtilityExtension$Mutation$clearSelectedImage
    on Mutation$clearSelectedImage {
  CopyWith$Mutation$clearSelectedImage<Mutation$clearSelectedImage>
  get copyWith => CopyWith$Mutation$clearSelectedImage(this, (i) => i);
}

abstract class CopyWith$Mutation$clearSelectedImage<TRes> {
  factory CopyWith$Mutation$clearSelectedImage(
    Mutation$clearSelectedImage instance,
    TRes Function(Mutation$clearSelectedImage) then,
  ) = _CopyWithImpl$Mutation$clearSelectedImage;

  factory CopyWith$Mutation$clearSelectedImage.stub(TRes res) =
      _CopyWithStubImpl$Mutation$clearSelectedImage;

  TRes call({bool? clearSelectedImage, String? $__typename});
}

class _CopyWithImpl$Mutation$clearSelectedImage<TRes>
    implements CopyWith$Mutation$clearSelectedImage<TRes> {
  _CopyWithImpl$Mutation$clearSelectedImage(this._instance, this._then);

  final Mutation$clearSelectedImage _instance;

  final TRes Function(Mutation$clearSelectedImage) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? clearSelectedImage = _undefined,
    Object? $__typename = _undefined,
  }) => _then(
    Mutation$clearSelectedImage(
      clearSelectedImage:
          clearSelectedImage == _undefined || clearSelectedImage == null
          ? _instance.clearSelectedImage
          : (clearSelectedImage as bool),
      $__typename: $__typename == _undefined || $__typename == null
          ? _instance.$__typename
          : ($__typename as String),
    ),
  );
}

class _CopyWithStubImpl$Mutation$clearSelectedImage<TRes>
    implements CopyWith$Mutation$clearSelectedImage<TRes> {
  _CopyWithStubImpl$Mutation$clearSelectedImage(this._res);

  TRes _res;

  call({bool? clearSelectedImage, String? $__typename}) => _res;
}

const documentNodeMutationclearSelectedImage = DocumentNode(
  definitions: [
    OperationDefinitionNode(
      type: OperationType.mutation,
      name: NameNode(value: 'clearSelectedImage'),
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
            name: NameNode(value: 'clearSelectedImage'),
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

import 'fragmentImages.graphql.dart';

import 'package:gql/ast.dart';

import 'schema.graphql.dart';

class Variables$Mutation$selectRemoteImage {
  factory Variables$Mutation$selectRemoteImage({
    required Input$ImageTargetInput target,
    required Enum$ImageType type,
    required String sourceUri,
  }) => Variables$Mutation$selectRemoteImage._({
    r'target': target,
    r'type': type,
    r'sourceUri': sourceUri,
  });

  Variables$Mutation$selectRemoteImage._(this._$data);

  factory Variables$Mutation$selectRemoteImage.fromJson(
    Map<String, dynamic> data,
  ) {
    final result$data = <String, dynamic>{};
    final l$target = data['target'];
    result$data['target'] = Input$ImageTargetInput.fromJson(
      (l$target as Map<String, dynamic>),
    );
    final l$type = data['type'];
    result$data['type'] = fromJson$Enum$ImageType((l$type as String));
    final l$sourceUri = data['sourceUri'];
    result$data['sourceUri'] = (l$sourceUri as String);
    return Variables$Mutation$selectRemoteImage._(result$data);
  }

  Map<String, dynamic> _$data;

  Input$ImageTargetInput get target =>
      (_$data['target'] as Input$ImageTargetInput);

  Enum$ImageType get type => (_$data['type'] as Enum$ImageType);

  String get sourceUri => (_$data['sourceUri'] as String);

  Map<String, dynamic> toJson() {
    final result$data = <String, dynamic>{};
    final l$target = target;
    result$data['target'] = l$target.toJson();
    final l$type = type;
    result$data['type'] = toJson$Enum$ImageType(l$type);
    final l$sourceUri = sourceUri;
    result$data['sourceUri'] = l$sourceUri;
    return result$data;
  }

  CopyWith$Variables$Mutation$selectRemoteImage<
    Variables$Mutation$selectRemoteImage
  >
  get copyWith => CopyWith$Variables$Mutation$selectRemoteImage(this, (i) => i);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Variables$Mutation$selectRemoteImage ||
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
    final l$sourceUri = sourceUri;
    final lOther$sourceUri = other.sourceUri;
    if (l$sourceUri != lOther$sourceUri) {
      return false;
    }
    return true;
  }

  @override
  int get hashCode {
    final l$target = target;
    final l$type = type;
    final l$sourceUri = sourceUri;
    return Object.hashAll([l$target, l$type, l$sourceUri]);
  }
}

abstract class CopyWith$Variables$Mutation$selectRemoteImage<TRes> {
  factory CopyWith$Variables$Mutation$selectRemoteImage(
    Variables$Mutation$selectRemoteImage instance,
    TRes Function(Variables$Mutation$selectRemoteImage) then,
  ) = _CopyWithImpl$Variables$Mutation$selectRemoteImage;

  factory CopyWith$Variables$Mutation$selectRemoteImage.stub(TRes res) =
      _CopyWithStubImpl$Variables$Mutation$selectRemoteImage;

  TRes call({
    Input$ImageTargetInput? target,
    Enum$ImageType? type,
    String? sourceUri,
  });
}

class _CopyWithImpl$Variables$Mutation$selectRemoteImage<TRes>
    implements CopyWith$Variables$Mutation$selectRemoteImage<TRes> {
  _CopyWithImpl$Variables$Mutation$selectRemoteImage(
    this._instance,
    this._then,
  );

  final Variables$Mutation$selectRemoteImage _instance;

  final TRes Function(Variables$Mutation$selectRemoteImage) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? target = _undefined,
    Object? type = _undefined,
    Object? sourceUri = _undefined,
  }) => _then(
    Variables$Mutation$selectRemoteImage._({
      ..._instance._$data,
      if (target != _undefined && target != null)
        'target': (target as Input$ImageTargetInput),
      if (type != _undefined && type != null) 'type': (type as Enum$ImageType),
      if (sourceUri != _undefined && sourceUri != null)
        'sourceUri': (sourceUri as String),
    }),
  );
}

class _CopyWithStubImpl$Variables$Mutation$selectRemoteImage<TRes>
    implements CopyWith$Variables$Mutation$selectRemoteImage<TRes> {
  _CopyWithStubImpl$Variables$Mutation$selectRemoteImage(this._res);

  TRes _res;

  call({
    Input$ImageTargetInput? target,
    Enum$ImageType? type,
    String? sourceUri,
  }) => _res;
}

class Mutation$selectRemoteImage {
  Mutation$selectRemoteImage({
    required this.selectRemoteImage,
    this.$__typename = 'Mutation',
  });

  factory Mutation$selectRemoteImage.fromJson(Map<String, dynamic> json) {
    final l$selectRemoteImage = json['selectRemoteImage'];
    final l$$__typename = json['__typename'];
    return Mutation$selectRemoteImage(
      selectRemoteImage: Fragment$fragmentImages.fromJson(
        (l$selectRemoteImage as Map<String, dynamic>),
      ),
      $__typename: (l$$__typename as String),
    );
  }

  final Fragment$fragmentImages selectRemoteImage;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$selectRemoteImage = selectRemoteImage;
    _resultData['selectRemoteImage'] = l$selectRemoteImage.toJson();
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$selectRemoteImage = selectRemoteImage;
    final l$$__typename = $__typename;
    return Object.hashAll([l$selectRemoteImage, l$$__typename]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Mutation$selectRemoteImage ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$selectRemoteImage = selectRemoteImage;
    final lOther$selectRemoteImage = other.selectRemoteImage;
    if (l$selectRemoteImage != lOther$selectRemoteImage) {
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

extension UtilityExtension$Mutation$selectRemoteImage
    on Mutation$selectRemoteImage {
  CopyWith$Mutation$selectRemoteImage<Mutation$selectRemoteImage>
  get copyWith => CopyWith$Mutation$selectRemoteImage(this, (i) => i);
}

abstract class CopyWith$Mutation$selectRemoteImage<TRes> {
  factory CopyWith$Mutation$selectRemoteImage(
    Mutation$selectRemoteImage instance,
    TRes Function(Mutation$selectRemoteImage) then,
  ) = _CopyWithImpl$Mutation$selectRemoteImage;

  factory CopyWith$Mutation$selectRemoteImage.stub(TRes res) =
      _CopyWithStubImpl$Mutation$selectRemoteImage;

  TRes call({Fragment$fragmentImages? selectRemoteImage, String? $__typename});
  CopyWith$Fragment$fragmentImages<TRes> get selectRemoteImage;
}

class _CopyWithImpl$Mutation$selectRemoteImage<TRes>
    implements CopyWith$Mutation$selectRemoteImage<TRes> {
  _CopyWithImpl$Mutation$selectRemoteImage(this._instance, this._then);

  final Mutation$selectRemoteImage _instance;

  final TRes Function(Mutation$selectRemoteImage) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? selectRemoteImage = _undefined,
    Object? $__typename = _undefined,
  }) => _then(
    Mutation$selectRemoteImage(
      selectRemoteImage:
          selectRemoteImage == _undefined || selectRemoteImage == null
          ? _instance.selectRemoteImage
          : (selectRemoteImage as Fragment$fragmentImages),
      $__typename: $__typename == _undefined || $__typename == null
          ? _instance.$__typename
          : ($__typename as String),
    ),
  );

  CopyWith$Fragment$fragmentImages<TRes> get selectRemoteImage {
    final local$selectRemoteImage = _instance.selectRemoteImage;
    return CopyWith$Fragment$fragmentImages(
      local$selectRemoteImage,
      (e) => call(selectRemoteImage: e),
    );
  }
}

class _CopyWithStubImpl$Mutation$selectRemoteImage<TRes>
    implements CopyWith$Mutation$selectRemoteImage<TRes> {
  _CopyWithStubImpl$Mutation$selectRemoteImage(this._res);

  TRes _res;

  call({Fragment$fragmentImages? selectRemoteImage, String? $__typename}) =>
      _res;

  CopyWith$Fragment$fragmentImages<TRes> get selectRemoteImage =>
      CopyWith$Fragment$fragmentImages.stub(_res);
}

const documentNodeMutationselectRemoteImage = DocumentNode(
  definitions: [
    OperationDefinitionNode(
      type: OperationType.mutation,
      name: NameNode(value: 'selectRemoteImage'),
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
          variable: VariableNode(name: NameNode(value: 'sourceUri')),
          type: NamedTypeNode(name: NameNode(value: 'String'), isNonNull: true),
          defaultValue: DefaultValueNode(value: null),
          directives: [],
        ),
      ],
      directives: [],
      selectionSet: SelectionSetNode(
        selections: [
          FieldNode(
            name: NameNode(value: 'selectRemoteImage'),
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
                name: NameNode(value: 'sourceUri'),
                value: VariableNode(name: NameNode(value: 'sourceUri')),
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

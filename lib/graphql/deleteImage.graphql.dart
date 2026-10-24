import 'package:gql/ast.dart';

class Variables$Mutation$deleteImage {
  factory Variables$Mutation$deleteImage({required String imageId}) =>
      Variables$Mutation$deleteImage._({r'imageId': imageId});

  Variables$Mutation$deleteImage._(this._$data);

  factory Variables$Mutation$deleteImage.fromJson(Map<String, dynamic> data) {
    final result$data = <String, dynamic>{};
    final l$imageId = data['imageId'];
    result$data['imageId'] = (l$imageId as String);
    return Variables$Mutation$deleteImage._(result$data);
  }

  Map<String, dynamic> _$data;

  String get imageId => (_$data['imageId'] as String);

  Map<String, dynamic> toJson() {
    final result$data = <String, dynamic>{};
    final l$imageId = imageId;
    result$data['imageId'] = l$imageId;
    return result$data;
  }

  CopyWith$Variables$Mutation$deleteImage<Variables$Mutation$deleteImage>
  get copyWith => CopyWith$Variables$Mutation$deleteImage(this, (i) => i);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Variables$Mutation$deleteImage ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$imageId = imageId;
    final lOther$imageId = other.imageId;
    if (l$imageId != lOther$imageId) {
      return false;
    }
    return true;
  }

  @override
  int get hashCode {
    final l$imageId = imageId;
    return Object.hashAll([l$imageId]);
  }
}

abstract class CopyWith$Variables$Mutation$deleteImage<TRes> {
  factory CopyWith$Variables$Mutation$deleteImage(
    Variables$Mutation$deleteImage instance,
    TRes Function(Variables$Mutation$deleteImage) then,
  ) = _CopyWithImpl$Variables$Mutation$deleteImage;

  factory CopyWith$Variables$Mutation$deleteImage.stub(TRes res) =
      _CopyWithStubImpl$Variables$Mutation$deleteImage;

  TRes call({String? imageId});
}

class _CopyWithImpl$Variables$Mutation$deleteImage<TRes>
    implements CopyWith$Variables$Mutation$deleteImage<TRes> {
  _CopyWithImpl$Variables$Mutation$deleteImage(this._instance, this._then);

  final Variables$Mutation$deleteImage _instance;

  final TRes Function(Variables$Mutation$deleteImage) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({Object? imageId = _undefined}) => _then(
    Variables$Mutation$deleteImage._({
      ..._instance._$data,
      if (imageId != _undefined && imageId != null)
        'imageId': (imageId as String),
    }),
  );
}

class _CopyWithStubImpl$Variables$Mutation$deleteImage<TRes>
    implements CopyWith$Variables$Mutation$deleteImage<TRes> {
  _CopyWithStubImpl$Variables$Mutation$deleteImage(this._res);

  TRes _res;

  call({String? imageId}) => _res;
}

class Mutation$deleteImage {
  Mutation$deleteImage({
    required this.deleteImage,
    this.$__typename = 'Mutation',
  });

  factory Mutation$deleteImage.fromJson(Map<String, dynamic> json) {
    final l$deleteImage = json['deleteImage'];
    final l$$__typename = json['__typename'];
    return Mutation$deleteImage(
      deleteImage: (l$deleteImage as bool),
      $__typename: (l$$__typename as String),
    );
  }

  final bool deleteImage;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$deleteImage = deleteImage;
    _resultData['deleteImage'] = l$deleteImage;
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$deleteImage = deleteImage;
    final l$$__typename = $__typename;
    return Object.hashAll([l$deleteImage, l$$__typename]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Mutation$deleteImage || runtimeType != other.runtimeType) {
      return false;
    }
    final l$deleteImage = deleteImage;
    final lOther$deleteImage = other.deleteImage;
    if (l$deleteImage != lOther$deleteImage) {
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

extension UtilityExtension$Mutation$deleteImage on Mutation$deleteImage {
  CopyWith$Mutation$deleteImage<Mutation$deleteImage> get copyWith =>
      CopyWith$Mutation$deleteImage(this, (i) => i);
}

abstract class CopyWith$Mutation$deleteImage<TRes> {
  factory CopyWith$Mutation$deleteImage(
    Mutation$deleteImage instance,
    TRes Function(Mutation$deleteImage) then,
  ) = _CopyWithImpl$Mutation$deleteImage;

  factory CopyWith$Mutation$deleteImage.stub(TRes res) =
      _CopyWithStubImpl$Mutation$deleteImage;

  TRes call({bool? deleteImage, String? $__typename});
}

class _CopyWithImpl$Mutation$deleteImage<TRes>
    implements CopyWith$Mutation$deleteImage<TRes> {
  _CopyWithImpl$Mutation$deleteImage(this._instance, this._then);

  final Mutation$deleteImage _instance;

  final TRes Function(Mutation$deleteImage) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? deleteImage = _undefined,
    Object? $__typename = _undefined,
  }) => _then(
    Mutation$deleteImage(
      deleteImage: deleteImage == _undefined || deleteImage == null
          ? _instance.deleteImage
          : (deleteImage as bool),
      $__typename: $__typename == _undefined || $__typename == null
          ? _instance.$__typename
          : ($__typename as String),
    ),
  );
}

class _CopyWithStubImpl$Mutation$deleteImage<TRes>
    implements CopyWith$Mutation$deleteImage<TRes> {
  _CopyWithStubImpl$Mutation$deleteImage(this._res);

  TRes _res;

  call({bool? deleteImage, String? $__typename}) => _res;
}

const documentNodeMutationdeleteImage = DocumentNode(
  definitions: [
    OperationDefinitionNode(
      type: OperationType.mutation,
      name: NameNode(value: 'deleteImage'),
      variableDefinitions: [
        VariableDefinitionNode(
          variable: VariableNode(name: NameNode(value: 'imageId')),
          type: NamedTypeNode(name: NameNode(value: 'ID'), isNonNull: true),
          defaultValue: DefaultValueNode(value: null),
          directives: [],
        ),
      ],
      directives: [],
      selectionSet: SelectionSetNode(
        selections: [
          FieldNode(
            name: NameNode(value: 'deleteImage'),
            alias: null,
            arguments: [
              ArgumentNode(
                name: NameNode(value: 'imageId'),
                value: VariableNode(name: NameNode(value: 'imageId')),
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

import 'fragmentImages.graphql.dart';

import 'package:gql/ast.dart';

class Variables$Mutation$selectImage {
  factory Variables$Mutation$selectImage({required String imageId}) =>
      Variables$Mutation$selectImage._({r'imageId': imageId});

  Variables$Mutation$selectImage._(this._$data);

  factory Variables$Mutation$selectImage.fromJson(Map<String, dynamic> data) {
    final result$data = <String, dynamic>{};
    final l$imageId = data['imageId'];
    result$data['imageId'] = (l$imageId as String);
    return Variables$Mutation$selectImage._(result$data);
  }

  Map<String, dynamic> _$data;

  String get imageId => (_$data['imageId'] as String);

  Map<String, dynamic> toJson() {
    final result$data = <String, dynamic>{};
    final l$imageId = imageId;
    result$data['imageId'] = l$imageId;
    return result$data;
  }

  CopyWith$Variables$Mutation$selectImage<Variables$Mutation$selectImage>
  get copyWith => CopyWith$Variables$Mutation$selectImage(this, (i) => i);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Variables$Mutation$selectImage ||
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

abstract class CopyWith$Variables$Mutation$selectImage<TRes> {
  factory CopyWith$Variables$Mutation$selectImage(
    Variables$Mutation$selectImage instance,
    TRes Function(Variables$Mutation$selectImage) then,
  ) = _CopyWithImpl$Variables$Mutation$selectImage;

  factory CopyWith$Variables$Mutation$selectImage.stub(TRes res) =
      _CopyWithStubImpl$Variables$Mutation$selectImage;

  TRes call({String? imageId});
}

class _CopyWithImpl$Variables$Mutation$selectImage<TRes>
    implements CopyWith$Variables$Mutation$selectImage<TRes> {
  _CopyWithImpl$Variables$Mutation$selectImage(this._instance, this._then);

  final Variables$Mutation$selectImage _instance;

  final TRes Function(Variables$Mutation$selectImage) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({Object? imageId = _undefined}) => _then(
    Variables$Mutation$selectImage._({
      ..._instance._$data,
      if (imageId != _undefined && imageId != null)
        'imageId': (imageId as String),
    }),
  );
}

class _CopyWithStubImpl$Variables$Mutation$selectImage<TRes>
    implements CopyWith$Variables$Mutation$selectImage<TRes> {
  _CopyWithStubImpl$Variables$Mutation$selectImage(this._res);

  TRes _res;

  call({String? imageId}) => _res;
}

class Mutation$selectImage {
  Mutation$selectImage({
    required this.selectImage,
    this.$__typename = 'Mutation',
  });

  factory Mutation$selectImage.fromJson(Map<String, dynamic> json) {
    final l$selectImage = json['selectImage'];
    final l$$__typename = json['__typename'];
    return Mutation$selectImage(
      selectImage: Fragment$fragmentImages.fromJson(
        (l$selectImage as Map<String, dynamic>),
      ),
      $__typename: (l$$__typename as String),
    );
  }

  final Fragment$fragmentImages selectImage;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$selectImage = selectImage;
    _resultData['selectImage'] = l$selectImage.toJson();
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$selectImage = selectImage;
    final l$$__typename = $__typename;
    return Object.hashAll([l$selectImage, l$$__typename]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Mutation$selectImage || runtimeType != other.runtimeType) {
      return false;
    }
    final l$selectImage = selectImage;
    final lOther$selectImage = other.selectImage;
    if (l$selectImage != lOther$selectImage) {
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

extension UtilityExtension$Mutation$selectImage on Mutation$selectImage {
  CopyWith$Mutation$selectImage<Mutation$selectImage> get copyWith =>
      CopyWith$Mutation$selectImage(this, (i) => i);
}

abstract class CopyWith$Mutation$selectImage<TRes> {
  factory CopyWith$Mutation$selectImage(
    Mutation$selectImage instance,
    TRes Function(Mutation$selectImage) then,
  ) = _CopyWithImpl$Mutation$selectImage;

  factory CopyWith$Mutation$selectImage.stub(TRes res) =
      _CopyWithStubImpl$Mutation$selectImage;

  TRes call({Fragment$fragmentImages? selectImage, String? $__typename});
  CopyWith$Fragment$fragmentImages<TRes> get selectImage;
}

class _CopyWithImpl$Mutation$selectImage<TRes>
    implements CopyWith$Mutation$selectImage<TRes> {
  _CopyWithImpl$Mutation$selectImage(this._instance, this._then);

  final Mutation$selectImage _instance;

  final TRes Function(Mutation$selectImage) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? selectImage = _undefined,
    Object? $__typename = _undefined,
  }) => _then(
    Mutation$selectImage(
      selectImage: selectImage == _undefined || selectImage == null
          ? _instance.selectImage
          : (selectImage as Fragment$fragmentImages),
      $__typename: $__typename == _undefined || $__typename == null
          ? _instance.$__typename
          : ($__typename as String),
    ),
  );

  CopyWith$Fragment$fragmentImages<TRes> get selectImage {
    final local$selectImage = _instance.selectImage;
    return CopyWith$Fragment$fragmentImages(
      local$selectImage,
      (e) => call(selectImage: e),
    );
  }
}

class _CopyWithStubImpl$Mutation$selectImage<TRes>
    implements CopyWith$Mutation$selectImage<TRes> {
  _CopyWithStubImpl$Mutation$selectImage(this._res);

  TRes _res;

  call({Fragment$fragmentImages? selectImage, String? $__typename}) => _res;

  CopyWith$Fragment$fragmentImages<TRes> get selectImage =>
      CopyWith$Fragment$fragmentImages.stub(_res);
}

const documentNodeMutationselectImage = DocumentNode(
  definitions: [
    OperationDefinitionNode(
      type: OperationType.mutation,
      name: NameNode(value: 'selectImage'),
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
            name: NameNode(value: 'selectImage'),
            alias: null,
            arguments: [
              ArgumentNode(
                name: NameNode(value: 'imageId'),
                value: VariableNode(name: NameNode(value: 'imageId')),
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

import 'package:gql/ast.dart';

class Fragment$fragmentImages {
  Fragment$fragmentImages({
    required this.type,
    required this.id,
    this.$__typename = 'Image',
  });

  factory Fragment$fragmentImages.fromJson(Map<String, dynamic> json) {
    final l$type = json['type'];
    final l$id = json['id'];
    final l$$__typename = json['__typename'];
    return Fragment$fragmentImages(
      type: (l$type as String),
      id: (l$id as String),
      $__typename: (l$$__typename as String),
    );
  }

  final String type;

  final String id;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$type = type;
    _resultData['type'] = l$type;
    final l$id = id;
    _resultData['id'] = l$id;
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$type = type;
    final l$id = id;
    final l$$__typename = $__typename;
    return Object.hashAll([
      l$type,
      l$id,
      l$$__typename,
    ]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Fragment$fragmentImages || runtimeType != other.runtimeType) {
      return false;
    }
    final l$type = type;
    final lOther$type = other.type;
    if (l$type != lOther$type) {
      return false;
    }
    final l$id = id;
    final lOther$id = other.id;
    if (l$id != lOther$id) {
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

extension UtilityExtension$Fragment$fragmentImages on Fragment$fragmentImages {
  CopyWith$Fragment$fragmentImages<Fragment$fragmentImages> get copyWith =>
      CopyWith$Fragment$fragmentImages(
        this,
        (i) => i,
      );
}

abstract class CopyWith$Fragment$fragmentImages<TRes> {
  factory CopyWith$Fragment$fragmentImages(
    Fragment$fragmentImages instance,
    TRes Function(Fragment$fragmentImages) then,
  ) = _CopyWithImpl$Fragment$fragmentImages;

  factory CopyWith$Fragment$fragmentImages.stub(TRes res) =
      _CopyWithStubImpl$Fragment$fragmentImages;

  TRes call({
    String? type,
    String? id,
    String? $__typename,
  });
}

class _CopyWithImpl$Fragment$fragmentImages<TRes>
    implements CopyWith$Fragment$fragmentImages<TRes> {
  _CopyWithImpl$Fragment$fragmentImages(
    this._instance,
    this._then,
  );

  final Fragment$fragmentImages _instance;

  final TRes Function(Fragment$fragmentImages) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? type = _undefined,
    Object? id = _undefined,
    Object? $__typename = _undefined,
  }) =>
      _then(Fragment$fragmentImages(
        type: type == _undefined || type == null
            ? _instance.type
            : (type as String),
        id: id == _undefined || id == null ? _instance.id : (id as String),
        $__typename: $__typename == _undefined || $__typename == null
            ? _instance.$__typename
            : ($__typename as String),
      ));
}

class _CopyWithStubImpl$Fragment$fragmentImages<TRes>
    implements CopyWith$Fragment$fragmentImages<TRes> {
  _CopyWithStubImpl$Fragment$fragmentImages(this._res);

  TRes _res;

  call({
    String? type,
    String? id,
    String? $__typename,
  }) =>
      _res;
}

const fragmentDefinitionfragmentImages = FragmentDefinitionNode(
  name: NameNode(value: 'fragmentImages'),
  typeCondition: TypeConditionNode(
      on: NamedTypeNode(
    name: NameNode(value: 'Image'),
    isNonNull: false,
  )),
  directives: [],
  selectionSet: SelectionSetNode(selections: [
    FieldNode(
      name: NameNode(value: 'type'),
      alias: null,
      arguments: [],
      directives: [],
      selectionSet: null,
    ),
    FieldNode(
      name: NameNode(value: 'id'),
      alias: null,
      arguments: [],
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
  ]),
);
const documentNodeFragmentfragmentImages = DocumentNode(definitions: [
  fragmentDefinitionfragmentImages,
]);
